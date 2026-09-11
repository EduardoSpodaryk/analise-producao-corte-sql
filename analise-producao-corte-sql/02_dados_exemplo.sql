USE producao_corte;
GO

INSERT INTO referencias (codigo, descricao, tipo_tecido) VALUES
('CAM-101', 'Camiseta básica masculina', 'Meia malha'),
('CAM-205', 'Camiseta feminina slim', 'Viscolycra'),
('MOL-310', 'Moletom canguru', 'Moletom 3 cabos'),
('BER-120', 'Bermuda esportiva', 'Dry fit'),
('CAL-410', 'Calça jogger', 'Moletinho');
GO

INSERT INTO ordens_corte (numero_ordem, data_ordem, id_referencia, quantidade_planejada) VALUES
('OC-260701', '2026-07-01', 1, 800),
('OC-260704', '2026-07-04', 2, 650),
('OC-260708', '2026-07-08', 3, 420),
('OC-260712', '2026-07-12', 4, 900),
('OC-260718', '2026-07-18', 5, 520),
('OC-260725', '2026-07-25', 1, 1000),
('OC-260803', '2026-08-03', 2, 750),
('OC-260807', '2026-08-07', 4, 1100),
('OC-260811', '2026-08-11', 3, 500),
('OC-260816', '2026-08-16', 5, 600),
('OC-260821', '2026-08-21', 1, 950),
('OC-260827', '2026-08-27', 2, 720),
('OC-260902', '2026-09-02', 4, 1000),
('OC-260905', '2026-09-05', 3, 460),
('OC-260907', '2026-09-07', 5, 580),
('OC-260909', '2026-09-09', 1, 1050);
GO

INSERT INTO apontamentos_corte
(id_ordem, data_corte, equipe, turno, tecido_consumido_kg, tecido_aproveitado_kg, pecas_cortadas, tempo_corte_minutos)
VALUES
(1,  '2026-07-02', 'Equipe A', '1º turno', 188.00, 176.72, 795, 260),
(2,  '2026-07-05', 'Equipe B', '1º turno', 162.00, 147.42, 638, 250),
(3,  '2026-07-09', 'Equipe A', '2º turno', 226.00, 210.18, 415, 300),
(4,  '2026-07-13', 'Equipe C', '1º turno', 171.00, 164.16, 905, 280),
(5,  '2026-07-19', 'Equipe B', '2º turno', 198.00, 182.16, 507, 295),
(6,  '2026-07-26', 'Equipe A', '1º turno', 232.00, 220.40, 1012, 305),
(7,  '2026-08-04', 'Equipe B', '1º turno', 184.00, 165.60, 735, 285),
(8,  '2026-08-08', 'Equipe C', '2º turno', 207.00, 198.72, 1092, 315),
(9,  '2026-08-12', 'Equipe A', '1º turno', 267.00, 248.31, 492, 330),
(10, '2026-08-17', 'Equipe B', '2º turno', 221.00, 202.44, 586, 310),
(11, '2026-08-22', 'Equipe A', '1º turno', 219.00, 210.24, 958, 290),
(12, '2026-08-28', 'Equipe C', '1º turno', 177.00, 168.15, 714, 260),
(13, '2026-09-03', 'Equipe C', '2º turno', 191.00, 184.32, 1005, 295),
(14, '2026-09-06', 'Equipe A', '1º turno', 245.00, 225.40, 451, 320),
(15, '2026-09-08', 'Equipe B', '1º turno', 214.00, 194.74, 562, 300),
(16, '2026-09-10', 'Equipe A', '2º turno', 241.00, 231.36, 1061, 310);
GO

INSERT INTO ocorrencias_corte
(id_apontamento, tipo, motivo, perda_kg, pecas_retrabalho, tempo_retrabalho_minutos)
VALUES
(1, 'PERDA', 'Ponta de enfesto', 4.00, NULL, NULL),
(1, 'PERDA', 'Falha no tecido', 7.28, NULL, NULL),
(2, 'PERDA', 'Falha no tecido', 8.50, NULL, NULL),
(2, 'PERDA', 'Emenda de rolo', 6.08, NULL, NULL),
(3, 'PERDA', 'Ponta de enfesto', 5.20, NULL, NULL),
(3, 'PERDA', 'Encaixe pouco eficiente', 10.62, NULL, NULL),
(4, 'PERDA', 'Ponta de enfesto', 3.10, NULL, NULL),
(4, 'PERDA', 'Emenda de rolo', 3.74, NULL, NULL),
(5, 'PERDA', 'Falha no tecido', 9.00, NULL, NULL),
(5, 'PERDA', 'Erro de corte', 6.84, NULL, NULL),
(6, 'PERDA', 'Ponta de enfesto', 4.70, NULL, NULL),
(6, 'PERDA', 'Encaixe pouco eficiente', 6.90, NULL, NULL),
(7, 'PERDA', 'Falha no tecido', 11.00, NULL, NULL),
(7, 'PERDA', 'Encaixe pouco eficiente', 7.40, NULL, NULL),
(8, 'PERDA', 'Ponta de enfesto', 3.50, NULL, NULL),
(8, 'PERDA', 'Emenda de rolo', 4.78, NULL, NULL),
(9, 'PERDA', 'Falha no tecido', 10.20, NULL, NULL),
(9, 'PERDA', 'Erro de corte', 8.49, NULL, NULL),
(10, 'PERDA', 'Encaixe pouco eficiente', 10.50, NULL, NULL),
(10, 'PERDA', 'Ponta de enfesto', 8.06, NULL, NULL),
(11, 'PERDA', 'Ponta de enfesto', 3.60, NULL, NULL),
(11, 'PERDA', 'Emenda de rolo', 5.16, NULL, NULL),
(12, 'PERDA', 'Falha no tecido', 5.20, NULL, NULL),
(12, 'PERDA', 'Ponta de enfesto', 3.65, NULL, NULL),
(13, 'PERDA', 'Ponta de enfesto', 2.90, NULL, NULL),
(13, 'PERDA', 'Emenda de rolo', 3.78, NULL, NULL),
(14, 'PERDA', 'Falha no tecido', 12.00, NULL, NULL),
(14, 'PERDA', 'Erro de corte', 7.60, NULL, NULL),
(15, 'PERDA', 'Encaixe pouco eficiente', 10.00, NULL, NULL),
(15, 'PERDA', 'Falha no tecido', 9.26, NULL, NULL),
(16, 'PERDA', 'Ponta de enfesto', 4.20, NULL, NULL),
(16, 'PERDA', 'Emenda de rolo', 5.44, NULL, NULL),
(2, 'RETRABALHO', 'Recorte por falha no tecido', NULL, 28, 45),
(3, 'RETRABALHO', 'Ajuste de marcação', NULL, 18, 30),
(5, 'RETRABALHO', 'Recorte por erro de corte', NULL, 34, 55),
(7, 'RETRABALHO', 'Recorte por falha no tecido', NULL, 42, 65),
(9, 'RETRABALHO', 'Recorte por erro de corte', NULL, 31, 50),
(10, 'RETRABALHO', 'Ajuste de marcação', NULL, 22, 35),
(12, 'RETRABALHO', 'Recorte por falha no tecido', NULL, 16, 25),
(14, 'RETRABALHO', 'Recorte por erro de corte', NULL, 38, 60),
(15, 'RETRABALHO', 'Ajuste de marcação', NULL, 25, 40);
GO
