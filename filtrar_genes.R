if (!require("pacman")) install.packages("pacman")
p_load(readr, dplyr, tidyr, rsample, conflicted)

conflicts_prefer(dplyr::filter)

perfis <- read_csv("matriz_perfis_genes.csv", col_names = TRUE)

calc_variacao_categorica <- function(coluna) {
  return(length(unique(coluna)))
}

genes_variantes <- perfis %>%
  summarise(across(-condition, calc_variacao_categorica)) %>%
  pivot_longer(everything(), names_to = "gene", values_to = "desvio_padrao") %>%
  arrange(desc(desvio_padrao)) %>%
  slice_head(n = 500) %>%
  pull(gene)

dados_filtrados <- perfis %>%
  select(condition, all_of(genes_variantes))
