	/*Grupo: Tein8 - 2TDSF
Gabriel de Nicola Gonçalves RM 88803
Gustavo de Souza Nascimento RM 88804
João Victor Deziderio       RM 88805
Nathan Pagliari Augusto     RM 88806*/

--Entrega Challenge Sprint 2

set serveroutput on
set verify off

DROP TABLE T8_APLICACAO
DROP TABLE T8_EMPRESA

--CRIAÇÃO DE TABELAS
CREATE TABLE T8_EMPRESA (
    cd_empresa          NUMBER(4) PRIMARY KEY,
    nm_empresa          VARCHAR2(50) NOT NULL,
    ds_cnpj             VARCHAR2(50) NOT NULL,
    ds_empresa          VARCHAR2(50),
    ds_email            VARCHAR2(50) NOT NULL,
    ds_senha            VARCHAR2(50) NOT NULL,
    dt_compra           DATE NOT NULL,
    ds_vl_compra        NUMERIC(15,2) NOT NULL,
    ds_status_compra    VARCHAR2(50)
);

CREATE TABLE T8_APLICACAO (
    cd_aplicacao     NUMBER(4) NOT NULL,
    cd_empresa       NUMBER(4) NOT NULL,
    FOREIGN KEY (cd_empresa) REFERENCES T8_EMPRESA(cd_empresa),
    nm_aplicacoes    VARCHAR2(50) NOT NULL,
    nr_botoes        NUMBER(4) NOT NULL,
    nr_entrada_dados NUMBER(4) NOT NULL,
    nr_links         NUMBER(4) NOT NULL,
    PRIMARY KEY (cd_aplicacao,cd_empresa)
);

-- INSERT - EXCEPTION de dupla chave e others

BEGIN
    INSERT INTO T8_EMPRESA (CD_EMPRESA, NM_EMPRESA, DS_CNPJ, DS_EMPRESA, DS_EMAIL, DS_SENHA, DT_COMPRA, ds_vl_compra,ds_status_compra) VALUES (1000,'Amazom','12.416.910/0001-03','Plataforma de vendas', 'amazomlogin@gmail.com','amazomsenha123',sysdate,1600.00,'Aguardando pagamento');
    INSERT INTO T8_EMPRESA (CD_EMPRESA, NM_EMPRESA, DS_CNPJ, DS_EMPRESA, DS_EMAIL, DS_SENHA, DT_COMPRA, ds_vl_compra,ds_status_compra) VALUES (2000,'Alura','11.139.533/0001-05','Plataforma de cursos de tecnologia online', 'alura@gmail.com','alurazinha001',sysdate,2200.,'Aguardando pagamento');
    INSERT INTO T8_EMPRESA (CD_EMPRESA, NM_EMPRESA, DS_CNPJ, DS_EMPRESA, DS_EMAIL, DS_SENHA, DT_COMPRA, ds_vl_compra,ds_status_compra) VALUES (3000,'FIAP','04.030.647/0002-01','Faculdade de Tecnologia', 'fiapeducacao@gmail.com','fiap007',sysdate,1500.00,'Aguardando pagamento');
    INSERT INTO T8_EMPRESA (CD_EMPRESA, NM_EMPRESA, DS_CNPJ, DS_EMPRESA, DS_EMAIL, DS_SENHA, DT_COMPRA, ds_vl_compra,ds_status_compra) VALUES (4000,'GitHub','44.467.068/0002-01','Plataforma de hospedagem de código-fonte', 'github.dev@outlook.com','2008GHTD',sysdate,3000.00,'Aguardando pagamento');
    INSERT INTO T8_EMPRESA (CD_EMPRESA, NM_EMPRESA, DS_CNPJ, DS_EMPRESA, DS_EMAIL, DS_SENHA, DT_COMPRA, ds_vl_compra,ds_status_compra) VALUES (5000,'LinkdIn','13.638.767/0001-92','Rede Social Profissional', 'linkdinPRO@gmail.com','LK200305',sysdate,2800.00,'Aguardando pagamento');
    INSERT INTO T8_APLICACAO  VALUES (1,1000,'CARRINHO',10,3,0);
    INSERT INTO T8_APLICACAO  VALUES (1,2000,'HELPDESK',2,2,5);
    INSERT INTO T8_APLICACAO  VALUES (1,3000,'BOLETIM',3,0,0);
    INSERT INTO T8_APLICACAO  VALUES (1,4000,'REPOSITORIO',12,6,1);
    INSERT INTO T8_APLICACAO  VALUES (1,5000,'PERFIL',2,30,1);
EXCEPTION 
    WHEN dup_val_on_index THEN 
        dbms_output.put_line('Chave primaria repetida');
    WHEN OTHERS THEN 
      ROLLBACK;
      dbms_output.put_line ('Erro para popular tabelas');
      dbms_output.put_line ('ERROR CODE:'||CHR(10)||SQLCODE);
      dbms_output.put_line ('ERROR MESSAGE:'||CHR(10)||SQLERRM);
END;

-- Função para desconto de 10% caso o valor for acima de 5000
CREATE OR REPLACE FUNCTION desconto(valor IN NUMBER) RETURN NUMBER IS 
BEGIN
    IF valor >= 5000 THEN
        RETURN (valor * 0.90);
    ELSE 
        RETURN valor;
    END IF;
END desconto;


DROP PROCEDURE add_empresa
DROP PROCEDURE add_aplicacoes

CREATE PROCEDURE add_empresa(codigo NUMBER, nome VARCHAR2, cnpj VARCHAR2,email VARCHAR2,senha VARCHAR2,valor NUMBER) IS
BEGIN
  INSERT INTO T8_EMPRESA (CD_EMPRESA,NM_EMPRESA, DS_CNPJ,DS_EMAIL,DS_SENHA,DT_COMPRA,DS_VL_COMPRA,DS_STATUS_COMPRA) VALUES (codigo, nome, cnpj,email,senha,sysdate,desconto(valor),'Aguardando pagamento');
  DBMS_OUTPUT.PUT_LINE('A empresa '||nome||' foi adicionada');
EXCEPTION
    WHEN dup_val_on_index THEN 
        dbms_output.put_line('Chave primaria repetida');
    WHEN OTHERS THEN
      ROLLBACK;
      dbms_output.put_line ('INSERT OPERATION FAILED');
      dbms_output.put_line ('ERROR CODE:'||CHR(10)||SQLCODE);
      dbms_output.put_line ('ERROR MESSAGE:'||CHR(10)||SQLERRM);
END;

EXEC add_empresa(6000, 'XP','02.332.886/0001-04','xpcontato@gmail.com','testedesenhaxp',6000);


--Procedure para cadastrar aplicações 
CREATE PROCEDURE add_aplicacoes( aplicacao NUMBER, empresa NUMBER, nome VARCHAR2,botoes NUMBER,dados NUMBER,links NUMBER) IS
BEGIN
  INSERT INTO T8_APLICACAO (cd_aplicacao,cd_empresa, nm_aplicacoes, nr_botoes,nr_entrada_dados,nr_links)
  VALUES (aplicacao, empresa, nome,botoes,dados,links);
  DBMS_OUTPUT.PUT_LINE('Aplicação adicioanda');
EXCEPTION
    WHEN dup_val_on_index THEN 
        dbms_output.put_line('Chave primaria repetida');
    WHEN OTHERS THEN
      ROLLBACK;
      dbms_output.put_line ('INSERT OPERATION FAILED');
      dbms_output.put_line ('ERROR CODE:'||CHR(10)||SQLCODE);
      dbms_output.put_line ('ERROR MESSAGE:'||CHR(10)||SQLERRM);
END;


EXEC add_aplicacoes(3, 3000,'LISTA DE DESEJOS',6,3,9);



-- UPDATE - Modificar status de compra da empresa 
DECLARE 
    CODIGO_EMPRESA number(6) := & Numero_da_Empresa_que_fez_o_pagamento;
    e_invalid_dept EXCEPTION;
BEGIN
    UPDATE  T8_EMPRESA SET ds_status_compra = 'confirmado' WHERE CD_EMPRESA = CODIGO_EMPRESA;
    IF SQL%NOTFOUND THEN
      RAISE e_invalid_dept;
    END IF;
    dbms_output.put_line('ATUALIZAÇÃO CONCLUIDA');
EXCEPTION
   WHEN e_invalid_dept THEN
      dbms_output.put_line('EMPRESA NÃO ENCONTRADA NO BANCO');
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line ('ERRO PARA ATUALIZAR A EMPRESA');
        dbms_output.put_line ('ERROR CODE:'||CHR(10)||SQLCODE);
        dbms_output.put_line ('ERROR MESSAGE:'||CHR(10)||SQLERRM);
END;


--DELETE - Exception se a empresa não for localizada no banco
DECLARE 
    CODIGO_EMPRESA number(6) := & Numero_da_Empresa_que_sera_deletada;
    e_invalid_dept EXCEPTION;
BEGIN
    DELETE FROM T8_APLICACAO  WHERE CD_EMPRESA = CODIGO_EMPRESA; 
    DELETE FROM T8_EMPRESA WHERE CD_EMPRESA = CODIGO_EMPRESA;
    IF SQL%NOTFOUND THEN
      RAISE e_invalid_dept;
    END IF;
    dbms_output.put_line('EMPRESA EXCLUIDA DO BANCO');
EXCEPTION
   WHEN e_invalid_dept THEN
      dbms_output.put_line('EMPRESA NÃO ENCONTRADA NO BANCO');
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line ('ERRO PARA EXCLUIR EMPRESA DO BANCO');
        dbms_output.put_line ('ERROR CODE:'||CHR(10)||SQLCODE);
        dbms_output.put_line ('ERROR MESSAGE:'||CHR(10)||SQLERRM);
END;


--DELETE - Exception se a aplicacao ou empresa não for localizada no banco
DECLARE 
    CODIGO_EMPRESA number(4) := & Codigo_Da_Empresa;
    CODIGO_APLICACAO number(4) := & Codigo_Da_Aplicacao;
    e_invalid_dept EXCEPTION;
BEGIN
    DELETE FROM T8_APLICACAO  WHERE CD_EMPRESA = CODIGO_EMPRESA AND CD_APLICACAO = CODIGO_APLICACAO; 
    IF SQL%NOTFOUND THEN
      RAISE e_invalid_dept;
    END IF;
    dbms_output.put_line('APLICAÇÃO EXCLUIDA DO BANCO');
EXCEPTION
   WHEN e_invalid_dept THEN
      dbms_output.put_line('APLICAÇÃO NÃO ENCONTRADA NO BANCO');
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line ('ERRO PARA EXCLUIR APLICAÇÃO DO BANCO');
        dbms_output.put_line ('ERROR CODE:'||CHR(10)||SQLCODE);
        dbms_output.put_line ('ERROR MESSAGE:'||CHR(10)||SQLERRM);
END;
