if (!require("pacman")) install.packages("pacman")
p_load(readr, dplyr, tidyr, conflicted) 

conflicts_prefer(dplyr::filter)

perfis <- read_csv("matriz_perfis_genes.csv", col_names = TRUE)

calc_variacao_categorica <- function(coluna) {
  return(length(unique(coluna)))
}

genes_variantes <- perfis %>%
  summarise(across(-condition, calc_variacao_categorica)) %>%
  pivot_longer(everything(), names_to = "gene", values_to = "variacao") %>%
  arrange(desc(variacao)) %>%
  slice_head(n = 500) %>%
  pull(gene)

dados_filtrados <- perfis %>%
  select(condition, all_of(genes_variantes))

set.seed(1)
indices <- sample(1:nrow(dados_filtrados), size = 0.8 * nrow(dados_filtrados))
dados_treino <- dados_filtrados[indices, ]
dados_teste  <- dados_filtrados[-indices, ]

write_csv(dados_treino, "dados_treino.csv")
write_csv(dados_teste,  "dados_teste.csv")