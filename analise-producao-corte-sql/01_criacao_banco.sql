-- Projeto: Análise de Produção e Perdas do Corte
-- Banco: SQL Server

IF DB_ID('producao_corte') IS NULL
BEGIN
    CREATE DATABASE producao_corte;
END;
GO

USE producao_corte;
GO

CREATE TABLE referencias (
    id_referencia INT IDENTITY(1,1) PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    descricao VARCHAR(100) NOT NULL,
    tipo_tecido VARCHAR(80) NOT NULL
);
GO

CREATE TABLE ordens_corte (
    id_ordem INT IDENTITY(1,1) PRIMARY KEY,
    numero_ordem VARCHAR(20) NOT NULL UNIQUE,
    data_ordem DATE NOT NULL,
    id_referencia INT NOT NULL,
    quantidade_planejada INT NOT NULL,
    CONSTRAINT fk_ordem_referencia
        FOREIGN KEY (id_referencia) REFERENCES referencias(id_referencia),
    CONSTRAINT ck_quantidade_planejada CHECK (quantidade_planejada > 0)
);
GO

CREATE TABLE apontamentos_corte (
    id_apontamento INT IDENTITY(1,1) PRIMARY KEY,
    id_ordem INT NOT NULL,
    data_corte DATE NOT NULL,
    equipe VARCHAR(40) NOT NULL,
    turno VARCHAR(20) NOT NULL,
    tecido_consumido_kg DECIMAL(10,2) NOT NULL,
    tecido_aproveitado_kg DECIMAL(10,2) NOT NULL,
    pecas_cortadas INT NOT NULL,
    tempo_corte_minutos INT NOT NULL,
    CONSTRAINT fk_apontamento_ordem
        FOREIGN KEY (id_ordem) REFERENCES ordens_corte(id_ordem),
    CONSTRAINT ck_tecido_consumido CHECK (tecido_consumido_kg > 0),
    CONSTRAINT ck_tecido_aproveitado
        CHECK (tecido_aproveitado_kg >= 0 AND tecido_aproveitado_kg <= tecido_consumido_kg),
    CONSTRAINT ck_pecas_cortadas CHECK (pecas_cortadas >= 0),
    CONSTRAINT ck_tempo_corte CHECK (tempo_corte_minutos > 0)
);
GO

CREATE TABLE ocorrencias_corte (
    id_ocorrencia INT IDENTITY(1,1) PRIMARY KEY,
    id_apontamento INT NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    motivo VARCHAR(100) NOT NULL,
    perda_kg DECIMAL(10,2) NULL,
    pecas_retrabalho INT NULL,
    tempo_retrabalho_minutos INT NULL,
    CONSTRAINT fk_ocorrencia_apontamento
        FOREIGN KEY (id_apontamento) REFERENCES apontamentos_corte(id_apontamento),
    CONSTRAINT ck_tipo_ocorrencia CHECK (tipo IN ('PERDA', 'RETRABALHO')),
    CONSTRAINT ck_perda_kg CHECK (perda_kg IS NULL OR perda_kg >= 0),
    CONSTRAINT ck_pecas_retrabalho CHECK (pecas_retrabalho IS NULL OR pecas_retrabalho >= 0),
    CONSTRAINT ck_tempo_retrabalho CHECK (tempo_retrabalho_minutos IS NULL OR tempo_retrabalho_minutos >= 0)
);
GO
