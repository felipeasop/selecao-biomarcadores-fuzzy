if (!require("pacman")) install.packages("pacman")
p_load(tidyverse, rsample)

dados <- read_csv("norm_tibble.csv")

genes_filtrados <- dados %>% select(-id, -barcode, -condition)

genes_selecionados <- genes_filtrados %>% 
  summarise(across(everything(), sd)) %>%
  pivot_longer(everything(), names_to = "gene", values_to = "desvio_padrao") %>%
  arrange(desc(desvio_padrao)) %>%
  slice_head(n = 500) %>% pull(gene)


dados_filtrados <- dados_brutos %>% 
  select(condition, all_of(genes_selecionados))

set.seed(1) 
split_projeto <- initial_split(dados_filtrados, prop = 0.8, strata = condition)

dados_treino <- training(split_projeto)
dados_teste  <- testing(split_projeto)

saveRDS(dados_treino, "dados_treino.rds")
saveRDS(dados_teste,  "dados_teste.rds")

print(table(dados_treino$condition)) 