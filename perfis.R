library(pacman)
p_load(tidyverse, progress, scales, Rcpp, conflicted)

conflicts_prefer(dplyr::filter)

calc_quartis <- function(valores_gene) {
    return(quantile(valores_gene, probs = c(0, 0.25, 0.5, 0.75, 1), na.rm = TRUE))
}

cppFunction('
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
String classificar_gene(double x, NumericVector quartis_gene) {
    double min = quartis_gene[0];
    double q1 = quartis_gene[1];
    double q2 = quartis_gene[2];
    double q3 = quartis_gene[3];
    double max = quartis_gene[4];
    
    if (min == max) return "BAIXO";
    
    double baixo = 0, medio = 0, alto = 0;
    
    if (x >= min && x <= q1 && q1 > min) baixo = (x - min) / (q1 - min);
    else if (x > q1 && x <= q2 && q2 > q1) baixo = (q2 - x) / (q2 - q1);
    
    if (x >= q1 && x <= q2 && q2 > q1) medio = (x - q1) / (q2 - q1);
    else if (x > q2 && x <= q3 && q3 > q2) medio = (q3 - x) / (q3 - q2);
    
    if (x >= q2 && x <= q3 && q3 > q2) alto = (x - q2) / (q3 - q2);
    else if (x > q3 && x <= max && max > q3) alto = (max - x) / (max - q3);
    
    if (baixo >= medio && baixo >= alto) return "BAIXO";
    else if (medio >= alto) return "MEDIO";
    else return "ALTO";
}
')

criar_perfis <- function(dados) {
    novos_dados <- dados %>%
        mutate(condition = if_else(str_detect(condition, "Tumor"), "Tumor", condition))
    
    nomes_genes <- setdiff(names(novos_dados), c("id", "barcode", "condition"))
    
    dados_normal <- novos_dados %>%
        filter(condition == "Normal") %>%
        select(all_of(nomes_genes))
    
    dados_tumor <- novos_dados %>%
        filter(condition == "Tumor") %>%
        select(all_of(nomes_genes))
    
    quartis_genes <- apply(
        novos_dados %>% select(all_of(nomes_genes)), MARGIN = 2, calc_quartis
    )
    
    medias_normal <- colMeans(dados_normal, na.rm = TRUE)
    medias_tumor  <- colMeans(dados_tumor, na.rm = TRUE)
    
    perfis_normal <- sapply(nomes_genes, function(gene) {
        classificar_gene(medias_normal[gene], quartis_genes[, gene])
    })
    
    perfis_tumor <- sapply(nomes_genes, function(gene) {
        classificar_gene(medias_tumor[gene], quartis_genes[, gene])
    })
    
    perfis <- rbind(Normal = perfis_normal, Tumor = perfis_tumor) %>%
        as.data.frame() %>% rownames_to_column("condition")
    
    return(perfis)
}

# matriz_perfis <- criar_perfis(dados)
# write_csv(matriz_perfis, "matriz_perfis_genes.csv")
dados <- read_csv(file = "norm_tibble.csv", col_names = TRUE)
perfis <- read_csv(file = "matriz_perfis_genes.csv", col_names = TRUE)

calc_acuracia <- function(dados, matriz_perfis) {
    novos_dados <- dados %>%
        mutate(condition = if_else(str_detect(condition, "Tumor"), "Tumor", condition))
    
    nomes_genes <- setdiff(names(novos_dados), c("id", "barcode", "condition"))
    
    quartis_genes <- apply(novos_dados %>% select(all_of(nomes_genes)), 2, calc_quartis)
    
    total_acertos <- 0
    total_comparacoes <- 0
    
    perfis_esperados_normal_lista <- matriz_perfis %>%
        filter(condition == "Normal") %>%
        select(-condition) %>%
        as.list()
    
    perfis_esperados_tumor_lista <- matriz_perfis %>%
        filter(condition == "Tumor") %>%
        select(-condition) %>%
        as.list()
    
    pb <- progress_bar$new(
        total = length(nomes_genes),
        format = "[:bar] :percent | Gene :current/:total | Tempo restante :eta"
    )
    
    for (gene in nomes_genes) {
        pb$tick()
        
        valores_do_gene <- novos_dados[[gene]]
        quartis <- quartis_genes[, gene]
        
        perfis_geral <- sapply(valores_do_gene, function(v) {
            classificar_gene(v, quartis)
        })
        
        perfil_esperado_normal <- perfis_esperados_normal_lista[[gene]]
        perfil_esperado_tumor  <- perfis_esperados_tumor_lista[[gene]]

        perfis_esperados <- if_else(novos_dados$condition == "Normal", 
                                    perfil_esperado_normal, perfil_esperado_tumor)
        
        comp <- (perfis_geral != perfis_esperados)
        total_acertos <- total_acertos + sum(comp, na.rm = TRUE)
        total_comparacoes <- total_comparacoes + sum(!is.na(comp))
    }
    
    acuracia_total <- total_acertos / total_comparacoes
}