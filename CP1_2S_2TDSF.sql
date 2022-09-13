/*            

             2TDSF
Gabriel de Nicola Gonçalves RM 88803
Gustavo de Souza Nascimento RM 88804
João Victor Deziderio       RM 88805
Nathan Pagliari Augusto     RM 88806

        Projeto: Boletim
*/

set serveroutput on
set verify off

-- DROP TABELAS --

DROP TABLE HISTORICO;
DROP TABLE TURMA;
DROP TABLE ALUNO;
DROP TABLE DISCIPLICA;
DROP TABLE PROFESSOR;

-- CRIANDO TABELAS --

CREATE TABLE ALUNO(
    RA NUMBER(4) PRIMARY KEY,
    NOME VARCHAR(25) NOT NULL,
    ENDERECO VARCHAR(30) NOT NULL
);

CREATE TABLE DISCIPLICA(
    COD_DISC NUMBER(4) PRIMARY KEY,
    NOME_DISC VARCHAR(30) NOT NULL,
    CARGA_HOR NUMBER(4) NOT NULL
);

CREATE TABLE PROFESSOR(
    COD_PROF NUMBER(4) PRIMARY KEY,
    NOME_PROF VARCHAR(25) NOT NULL,
    ENDERECO VARCHAR(30),
    CIDADE VARCHAR(25)
);

CREATE TABLE TURMA(
    COD_DISC NUMBER(4),
    FOREIGN KEY (COD_DISC) REFERENCES DISCIPLICA(COD_DISC),
    COD_TURMA NUMBER(4) PRIMARY KEY,
    COD_PROF NUMBER(4),
    FOREIGN KEY (COD_PROF) REFERENCES PROFESSOR(COD_PROF),
    ANO NUMBER(4) NOT NULL,
    CIDADE VARCHAR(20) NOT NULL
);

CREATE TABLE HISTORICO(
    RA NUMBER(4),
    COD_DISC NUMBER(4),
    COD_TURMA NUMBER(4),
    COD_PROF NUMBER(4),
    FOREIGN KEY (RA) REFERENCES ALUNO(RA),
    FOREIGN KEY (COD_DISC) REFERENCES DISCIPLICA(COD_DISC),
    FOREIGN KEY (COD_TURMA) REFERENCES TURMA(COD_TURMA),
    FOREIGN KEY (COD_PROF) REFERENCES PROFESSOR(COD_PROF),
    ANO NUMBER(4),
    FALTAS NUMBER(3),
    NOTA1 NUMBER(4,2),
    NOTA2 NUMBER(4,2),
    MEDIA NUMBER(4,2),
    SITUACAO VARCHAR(20)
);

-- POPULAR TABELAS --

BEGIN

    INSERT INTO ALUNO VALUES (0001,'Nathan','Rua Sete de Setembro');
    INSERT INTO ALUNO VALUES (0002,'Pedro','Rua Quinze De Novembro ');
    INSERT INTO ALUNO VALUES (0003,'Gustavo','Rua Tiradentes');
    INSERT INTO ALUNO VALUES (0004,'Gabriel','Rua Amazonas');
    INSERT INTO ALUNO VALUES (0005,'Joao','Rua Santa Luzia');

    INSERT INTO DISCIPLICA VALUES (04,'Geografia',12);
    INSERT INTO DISCIPLICA VALUES (08,'Biologia',12);
    INSERT INTO DISCIPLICA VALUES (02,'Matemática',20);
    INSERT INTO DISCIPLICA VALUES (01,'Português',20);
    INSERT INTO DISCIPLICA VALUES (12,'Inglês',4);

    INSERT INTO PROFESSOR (COD_PROF, NOME_PROF) VALUES (1004,'Ricardo');
    INSERT INTO PROFESSOR (COD_PROF, NOME_PROF) VALUES (1008,'Ana');
    INSERT INTO PROFESSOR (COD_PROF, NOME_PROF) VALUES (1002,'Renata');
    INSERT INTO PROFESSOR (COD_PROF, NOME_PROF) VALUES (1013,'Vinicus');
    INSERT INTO PROFESSOR (COD_PROF, NOME_PROF) VALUES (1011,'Leonardo');

    INSERT INTO TURMA VALUES (04,5001,1004,9,'Tarde');
    INSERT INTO TURMA VALUES (08,5002,1008,8,'Tarde');
    INSERT INTO TURMA VALUES (02,5003,1002,6,'Manhã');
    INSERT INTO TURMA VALUES (01,5004,1013,7,'Manhã');
    INSERT INTO TURMA VALUES (12,5005,1011,9,'Noite');
    
EXCEPTION 
    when dup_val_on_index then 
        dbms_output.put_line('Chave primaria repetida');
    when others then 
     ROLLBACK;
      dbms_output.put_line ('Erro para popular tabelas');
      dbms_output.put_line ('ERROR CODE:'||CHR(10)||SQLCODE);
      dbms_output.put_line ('ERROR MESSAGE:'||CHR(10)||SQLERRM);
END;

-- FUNÇÃO CALCULAR MÉDIA --
create or replace function calcular_media (nota1 in number,nota2 in number) return number is media_final number;
begin
    media_final := (nota1 + nota2) / 2;
    return media_final;
end calcular_media;

-- Exemplo: Ra:01 COD_DISC:04 COD_TURMA:5004 COD_PROF: 1011
DECLARE
    RA NUMBER(4):= & RA;
    COD_DISC NUMBER(4):= & Codigo_disco;
    COD_TURMA NUMBER(4):= & Codigo_turma;
    COD_PROF NUMBER(4):= & Codigo_professor;
    ano number(4):= & Ano_do_aluno;
    faltas number(3):= & Faltas_do_aluno;
    nota1 number(4,2):= & Nota_da_prova_1;
    nota2 number(4,2):= & Nota_da_prova_2;
    media number:= calcular_media(nota1,nota2);
BEGIN
        IF faltas >= 50 Then 
            INSERT INTO HISTORICO VALUES (RA,COD_DISC,COD_TURMA,COD_PROF,ano,faltas,nota1,nota2,media,'Reprovado por faltas');
        ELSE 
            IF media >= 7 THEN
                INSERT INTO HISTORICO VALUES (RA,COD_DISC,COD_TURMA,COD_PROF,ano,faltas,nota1,nota2,media,'Aprovado');
            ELSIF media >= 5 AND media <= 6.9 THEN 
                INSERT INTO HISTORICO VALUES (RA,COD_DISC,COD_TURMA,COD_PROF,ano,faltas,nota1,nota2,media,'Recuperação');
            ELSE
                INSERT INTO HISTORICO VALUES (RA,COD_DISC,COD_TURMA,COD_PROF,ano,faltas,nota1,nota2,media,'Reprovado por nota');
            END IF;
        END IF;
        dbms_output.put_line ('Cadastro de histórico concluído');
EXCEPTION
    when others then 
        ROLLBACK;
        dbms_output.put_line ('Erro para cadastrar histórico');
        dbms_output.put_line ('ERROR CODE:'||CHR(10)||SQLCODE);
        dbms_output.put_line ('ERROR MESSAGE:'||CHR(10)||SQLERRM);
END;


