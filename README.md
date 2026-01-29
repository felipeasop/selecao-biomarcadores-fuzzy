# Análise Comparativa de Meta-heurísticas Evolutivas na Otimização de Sistemas de Inferência Fuzzy para Seleção de Biomarcadores em Dados Transcriptômicos de Câncer de Cólon

## Visão Geral

Este projeto de pesquisa foca na descoberta de biomarcadores para o câncer de cólon. O desafio central reside na alta dimensionalidade dos dados genéticos, conhecido como problema $p >> n$, onde existem milhares de genes para um número reduzido de amostras biológicas.

O objetivo é identificar o subconjunto mínimo de genes com maior capacidade de distinguir tecidos saudáveis e tecidos tumorais, otimizando o diagnóstico e reduzindo custos computacionais.

## Objetivos do Projeto

- **Identificação de Biomarcadores**: Encontrar genes específicos que servem como assinaturas da doença.
- **Otimização Híbrida**: Utilizar Algoritmos Genéticos para explorar de forma eficiente as combinações de genes.
- **Interpretabilidade com Lógica Fuzzy**: Aplicar Sistemas de Inferência Fuzzy para aproximar os dados de expressão gênica em termos como Baixo, Médio e Alto, permitindo adaptar a incerteza dos dados biológicos para algo computacionalmente tratável.
- **Análise Comparativa**: Avaliar qual técnica evolutiva é mais eficaz na busca por soluções que equilibrem alta acurácia diagnóstica com o menor número possível de genes selecionados, priorizando a parcimônia.

## Metodologia Proposta

A solução é estruturada como um sistema em duas etapas principais:

- **Exploração (Evolutiva)**: O Algoritmo Genético simula o processo de evolução natural para testar milhares de combinações de genes, selecionando aquelas que apresentam melhor desempenho.
- **Avaliação (Fuzzy)**: Cada combinação é avaliada por um Sistema de Inferência Fuzzy, responsável por classificar as amostras e atribuir uma medida de qualidade (fitness) baseada na precisão do diagnóstico.

## Resultado Esperado

A conclusão deste trabalho resultará em uma ferramenta capaz de acelerar o processo de descoberta de biomarcadores em relação aos métodos convencionais.
