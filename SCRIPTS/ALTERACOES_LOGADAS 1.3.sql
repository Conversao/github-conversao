/*
        Inserir na tabela ALTERACOES_LOGADAS (CISSPoder > Utilit�rios > Conculta Altera��es) a rela��o de c�digos do
        sistema antigo e c�digos novos, quando durante a convers�o, foi necess�rio alterar o c�digo dos produtos.

        Vari�veis
        ---------
        -- Tabela                               TABELA_CONVERSAO_DEFINITIVA
        -- C�digo antigo                        CODIGO_ANTIGO
        -- C�digo novo                          NOVOIDSUBPRODUTO
        -- Data da abertura da loja             2020-01-01

*/

INSERT INTO DBA.ALTERACOES_LOGADAS (IDALTERACAO, IDUSUARIOALTERACAO, DESCRALTERACAO, DADONOVO, DTHORAALTERACAO, DADOANTIGO, TIPOALTERACAO, CODIGO1, CODIGO2, CODIGO3)
SELECT
        NUMBER() * -1,
        2,
        'Gerado novo c�digo para o produto. Antigo: '||CODIGO_ANTIGO||' novo: '||NOVOIDSUBPRODUTO,
        NOVOIDSUBPRODUTO,                       -- CODIGONOVO
        '2020-01-01 00:00:00',                  -- DIA DA ABERTURA
        CODIGO_ANTIGO,                          -- CODIGO DO SISTEMA ANTIGO
        'PROD',
        999,                                    -- CODIGO1: 999
        CASE
                WHEN ISNUMERIC(CODIGO_ANTIGO) = 1 AND CODIGO_ANTIGO BETWEEN -2147483648 AND 2147483647 THEN CODIGO_ANTIGO
                ELSE NULL
        END          ,                          -- CODIGO2: CODIGOANTIGOCLIENTE
        NOVOIDSUBPRODUTO                        -- CODIGO3: CODIGONOVO
FROM    CONV.TABELA_CONVERSAO_DEFINITIVA
WHERE   FLAGCONVER      IN('T', 'J')
GO
COMMIT


-- Output
SELECT idalteracao,idusuarioalteracao,descralteracao,dadonovo,dthoraalteracao,dadoantigo,tipoalteracao,codigo1,codigo2,codigo3,codigo4,flag1,flag2,flag3,flag4,data1,data2,data3,data4,hora1,hora2,valor1,valor2,valor3,valor4,textop01,textop02,textom01,textom02 FROM DBA.ALTERACOES_LOGADAS WHERE IDALTERACAO < 1; OUTPUT TO C:\TEMP\ALTERACOES_LOGADAS.TXT

-- Import
db2 "IMPORT FROM C:\TEMP\ALTERACOES_LOGADAS.TXT OF DEL MODIFIED BY CHARDEL'''' INSERT INTO ALTERACOES_LOGADAS ( idalteracao,idusuarioalteracao,descralteracao,dadonovo,dthoraalteracao,dadoantigo,tipoalteracao,codigo1,codigo2,codigo3,codigo4,flag1,flag2,flag3,flag4,data1,data2,data3,data4,hora1,hora2,valor1,valor2,valor3,valor4,textop01,textop02,textom01,textom02)"

/*
 * Hist�rico de altera��es
        - 20/08/2018 -          | Ultima altera��o;
        - 31/01/2020 - 1.2      | Ajuste nas vari�veis e descri��es. Altera��o na data que deve ser informada, pois validando com analista cont�bil Mauricio Rodrigues (e ele validando com Gabriela Vitto Cecchin), a data de inser��o desta informa��o precisa ser posterior a data de cadastro do produto e precisa ser uma data em que o SPED ser� apurado pelo CISSPoder;
        - 24/09/2020 - 1.3      | Adi��o de CASE para inserir na coluna CODIGO2 apenas n�meros v�lidos do range integer.
		- 14/09/2021 - 			| Adcionado ao github
*/
