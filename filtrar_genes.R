if (!require("pacman")) install.packages("pacman")
p_load(tidyverse, rsample)

dados <- read_csv("norm_tibble.csv")

genes_filtrados <- dados %>% select(-id, -barcode, -condition)

# Selecionando genes com maior variação
genes_selecionados <- genes_filtrados %>% summarise(across(everything(), sd)) %>%
  pivot_longer(everything(), names_to = "gene", values_to = "desvio_padrao") %>%
  arrange(desc(desvio_padrao)) %>% slice_head(n = 500) %>% pull(gene)
