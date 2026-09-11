USE producao_corte;
GO

-- 1. Indicadores gerais
SELECT
    SUM(a.pecas_cortadas) AS pecas_cortadas,
    SUM(o.quantidade_planejada) AS pecas_planejadas,
    CAST(SUM(a.tecido_consumido_kg) AS DECIMAL(12,2)) AS tecido_consumido_kg,
    CAST(SUM(a.tecido_consumido_kg - a.tecido_aproveitado_kg) AS DECIMAL(12,2)) AS perda_total_kg,
    CAST(
        100.0 * SUM(a.tecido_consumido_kg - a.tecido_aproveitado_kg)
        / NULLIF(SUM(a.tecido_consumido_kg), 0)
        AS DECIMAL(10,2)
    ) AS percentual_perda
FROM apontamentos_corte a
JOIN ordens_corte o ON o.id_ordem = a.id_ordem;
GO

-- 2. Perda por referência
SELECT
    r.codigo,
    r.descricao,
    CAST(SUM(a.tecido_consumido_kg) AS DECIMAL(12,2)) AS tecido_consumido_kg,
    CAST(SUM(a.tecido_consumido_kg - a.tecido_aproveitado_kg) AS DECIMAL(12,2)) AS perda_kg,
    CAST(
        100.0 * SUM(a.tecido_consumido_kg - a.tecido_aproveitado_kg)
        / NULLIF(SUM(a.tecido_consumido_kg), 0)
        AS DECIMAL(10,2)
    ) AS percentual_perda
FROM apontamentos_corte a
JOIN ordens_corte o ON o.id_ordem = a.id_ordem
JOIN referencias r ON r.id_referencia = o.id_referencia
GROUP BY r.codigo, r.descricao
ORDER BY percentual_perda DESC;
GO

-- 3. Produtividade por equipe
SELECT
    equipe,
    SUM(pecas_cortadas) AS pecas_cortadas,
    SUM(tempo_corte_minutos) AS minutos_trabalhados,
    CAST(
        SUM(pecas_cortadas) /
        NULLIF(SUM(tempo_corte_minutos) / 60.0, 0)
        AS DECIMAL(10,2)
    ) AS pecas_por_hora
FROM apontamentos_corte
GROUP BY equipe
ORDER BY pecas_por_hora DESC;
GO

-- 4. Principais motivos de perda
SELECT
    motivo,
    COUNT(*) AS ocorrencias,
    CAST(SUM(perda_kg) AS DECIMAL(12,2)) AS perda_kg
FROM ocorrencias_corte
WHERE tipo = 'PERDA'
GROUP BY motivo
ORDER BY perda_kg DESC;
GO

-- 5. Retrabalho por referência
SELECT
    r.codigo,
    r.descricao,
    SUM(COALESCE(oc.pecas_retrabalho, 0)) AS pecas_retrabalhadas,
    SUM(COALESCE(oc.tempo_retrabalho_minutos, 0)) AS minutos_retrabalho,
    CAST(
        100.0 * SUM(COALESCE(oc.pecas_retrabalho, 0))
        / NULLIF(SUM(a.pecas_cortadas), 0)
        AS DECIMAL(10,2)
    ) AS percentual_retrabalho
FROM apontamentos_corte a
JOIN ordens_corte o ON o.id_ordem = a.id_ordem
JOIN referencias r ON r.id_referencia = o.id_referencia
LEFT JOIN ocorrencias_corte oc
    ON oc.id_apontamento = a.id_apontamento
    AND oc.tipo = 'RETRABALHO'
GROUP BY r.codigo, r.descricao
ORDER BY percentual_retrabalho DESC;
GO

-- 6. Planejado x cortado por ordem
SELECT
    o.numero_ordem,
    r.codigo AS referencia,
    o.quantidade_planejada,
    a.pecas_cortadas,
    a.pecas_cortadas - o.quantidade_planejada AS diferenca_pecas,
    CAST(
        100.0 * a.pecas_cortadas
        / NULLIF(o.quantidade_planejada, 0)
        AS DECIMAL(10,2)
    ) AS percentual_atendimento
FROM ordens_corte o
JOIN referencias r ON r.id_referencia = o.id_referencia
JOIN apontamentos_corte a ON a.id_ordem = o.id_ordem
ORDER BY o.data_ordem;
GO

-- 7. Ordens que merecem atenção
WITH retrabalho AS (
    SELECT
        id_apontamento,
        SUM(COALESCE(pecas_retrabalho, 0)) AS pecas_retrabalhadas
    FROM ocorrencias_corte
    WHERE tipo = 'RETRABALHO'
    GROUP BY id_apontamento
)
SELECT
    o.numero_ordem,
    r.codigo AS referencia,
    a.equipe,
    a.pecas_cortadas,
    CAST(
        100.0 * (a.tecido_consumido_kg - a.tecido_aproveitado_kg)
        / NULLIF(a.tecido_consumido_kg, 0)
        AS DECIMAL(10,2)
    ) AS percentual_perda,
    CAST(
        100.0 * COALESCE(rt.pecas_retrabalhadas, 0)
        / NULLIF(a.pecas_cortadas, 0)
        AS DECIMAL(10,2)
    ) AS percentual_retrabalho
FROM apontamentos_corte a
JOIN ordens_corte o ON o.id_ordem = a.id_ordem
JOIN referencias r ON r.id_referencia = o.id_referencia
LEFT JOIN retrabalho rt ON rt.id_apontamento = a.id_apontamento
WHERE
    100.0 * (a.tecido_consumido_kg - a.tecido_aproveitado_kg)
        / NULLIF(a.tecido_consumido_kg, 0) > 8
    OR
    100.0 * COALESCE(rt.pecas_retrabalhadas, 0)
        / NULLIF(a.pecas_cortadas, 0) > 5
ORDER BY percentual_perda DESC;
GO

-- 8. Evolução mensal
SELECT
    YEAR(data_corte) AS ano,
    MONTH(data_corte) AS mes,
    SUM(pecas_cortadas) AS pecas_cortadas,
    CAST(SUM(tecido_consumido_kg - tecido_aproveitado_kg) AS DECIMAL(12,2)) AS perda_kg,
    CAST(
        100.0 * SUM(tecido_consumido_kg - tecido_aproveitado_kg)
        / NULLIF(SUM(tecido_consumido_kg), 0)
        AS DECIMAL(10,2)
    ) AS percentual_perda,
    CAST(
        SUM(pecas_cortadas) /
        NULLIF(SUM(tempo_corte_minutos) / 60.0, 0)
        AS DECIMAL(10,2)
    ) AS pecas_por_hora
FROM apontamentos_corte
GROUP BY YEAR(data_corte), MONTH(data_corte)
ORDER BY ano, mes;
GO

-- 9. Pareto dos motivos de perda
WITH perdas AS (
    SELECT
        motivo,
        SUM(perda_kg) AS perda_kg
    FROM ocorrencias_corte
    WHERE tipo = 'PERDA'
    GROUP BY motivo
),
pareto AS (
    SELECT
        motivo,
        perda_kg,
        SUM(perda_kg) OVER (
            ORDER BY perda_kg DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS perda_acumulada,
        SUM(perda_kg) OVER () AS perda_total
    FROM perdas
)
SELECT
    motivo,
    CAST(perda_kg AS DECIMAL(12,2)) AS perda_kg,
    CAST(100.0 * perda_kg / NULLIF(perda_total, 0) AS DECIMAL(10,2)) AS participacao_percentual,
    CAST(100.0 * perda_acumulada / NULLIF(perda_total, 0) AS DECIMAL(10,2)) AS percentual_acumulado
FROM pareto
ORDER BY perda_kg DESC;
GO
