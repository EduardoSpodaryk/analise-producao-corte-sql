USE producao_corte;
GO

CREATE OR ALTER VIEW vw_producao_corte_bi AS
WITH ocorrencias_resumo AS (
    SELECT
        id_apontamento,
        SUM(CASE WHEN tipo = 'PERDA' THEN COALESCE(perda_kg, 0) ELSE 0 END) AS perda_registrada_kg,
        SUM(CASE WHEN tipo = 'RETRABALHO' THEN COALESCE(pecas_retrabalho, 0) ELSE 0 END) AS pecas_retrabalho,
        SUM(CASE WHEN tipo = 'RETRABALHO' THEN COALESCE(tempo_retrabalho_minutos, 0) ELSE 0 END) AS minutos_retrabalho
    FROM ocorrencias_corte
    GROUP BY id_apontamento
)
SELECT
    a.id_apontamento,
    o.numero_ordem,
    o.data_ordem,
    a.data_corte,
    r.codigo AS referencia,
    r.descricao,
    r.tipo_tecido,
    a.equipe,
    a.turno,
    o.quantidade_planejada,
    a.pecas_cortadas,
    a.tempo_corte_minutos,
    a.tecido_consumido_kg,
    a.tecido_aproveitado_kg,
    CAST(a.tecido_consumido_kg - a.tecido_aproveitado_kg AS DECIMAL(10,2)) AS perda_calculada_kg,
    CAST(
        100.0 * (a.tecido_consumido_kg - a.tecido_aproveitado_kg)
        / NULLIF(a.tecido_consumido_kg, 0)
        AS DECIMAL(10,2)
    ) AS percentual_perda,
    CAST(
        a.pecas_cortadas / NULLIF(a.tempo_corte_minutos / 60.0, 0)
        AS DECIMAL(10,2)
    ) AS pecas_por_hora,
    COALESCE(oc.perda_registrada_kg, 0) AS perda_registrada_kg,
    COALESCE(oc.pecas_retrabalho, 0) AS pecas_retrabalho,
    COALESCE(oc.minutos_retrabalho, 0) AS minutos_retrabalho,
    CAST(
        100.0 * COALESCE(oc.pecas_retrabalho, 0)
        / NULLIF(a.pecas_cortadas, 0)
        AS DECIMAL(10,2)
    ) AS percentual_retrabalho
FROM apontamentos_corte a
JOIN ordens_corte o ON o.id_ordem = a.id_ordem
JOIN referencias r ON r.id_referencia = o.id_referencia
LEFT JOIN ocorrencias_resumo oc ON oc.id_apontamento = a.id_apontamento;
GO

SELECT *
FROM vw_producao_corte_bi
ORDER BY data_corte;
GO
