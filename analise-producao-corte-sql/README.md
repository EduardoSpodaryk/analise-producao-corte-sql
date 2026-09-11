# Análise de Produção e Perdas do Corte

Projeto em SQL voltado à análise de dados de um setor de corte de uma indústria têxtil.

A proposta é simular uma base simples de produção e usar SQL para investigar desperdício de tecido, produtividade das equipes, retrabalho e cumprimento das ordens de corte.

Os dados são fictícios.

## Perguntas analisadas

- Qual referência apresenta maior percentual de perda?
- Quais são os principais motivos de desperdício?
- Qual equipe apresenta maior produtividade em peças por hora?
- Quanto do volume cortado precisou de retrabalho?
- Quais ordens tiveram perda ou retrabalho acima dos limites definidos para a análise?
- Como a perda e a produtividade evoluíram ao longo dos meses?
- O volume cortado ficou próximo do planejado?

## Estrutura

```text
analise-producao-corte-sql/
├── 01_criacao_banco.sql
├── 02_dados_exemplo.sql
├── 03_consultas_analiticas.sql
├── 04_view_bi.sql
└── README.md
```

## Banco utilizado

Os scripts foram escritos para SQL Server.

## Modelo de dados

O banco possui quatro tabelas:

- `referencias`: cadastro simples das referências de produto;
- `ordens_corte`: quantidade planejada por ordem;
- `apontamentos_corte`: produção realizada, consumo de tecido e tempo de corte;
- `ocorrencias_corte`: perdas e retrabalhos associados aos apontamentos.

## Indicadores

- peças cortadas;
- percentual de perda de tecido;
- perda em kg;
- peças por hora;
- percentual de retrabalho;
- planejado x realizado;
- participação dos motivos de perda.

## Consultas utilizadas

O arquivo `03_consultas_analiticas.sql` contém exemplos de:

- `JOIN`;
- `GROUP BY`;
- `CASE`;
- `CTE`;
- funções de agregação;
- `NULLIF` e `COALESCE`;
- funções de janela para análise de Pareto.

## View para BI

O arquivo `04_view_bi.sql` cria a view `vw_producao_corte_bi`.

Ela reúne os principais campos de produção em uma linha por apontamento de corte e pode servir como camada para consumo em uma ferramenta de BI.

As ocorrências são agregadas antes da junção para evitar duplicação dos valores de produção quando um apontamento possui mais de uma ocorrência.

## Como executar

Execute os arquivos nesta ordem:

```text
01_criacao_banco.sql
02_dados_exemplo.sql
03_consultas_analiticas.sql
04_view_bi.sql
```

## Contexto

Escolhi o processo de corte como tema por já ter tido contato profissional com essa etapa da indústria têxtil. A ideia foi usar esse contexto para construir consultas ligadas a problemas que fazem sentido no dia a dia da produção.

O foco do projeto é SQL aplicado à análise de negócio, e não a construção de um sistema completo de chão de fábrica.
