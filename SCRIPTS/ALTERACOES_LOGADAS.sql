/*
        Inserir na tabela ALTERACOES_LOGADAS (CISSPoder > Utilitários > Conculta Alterações) a relação de códigos do
        sistema antigo e códigos novos, quando durante a conversão, foi necessário alterar o código dos produtos.

        Variáveis
        ---------
        -- Tabela                               TABELA_CONVERSAO_DEFINITIVA
        -- Código antigo                        CODIGO_ANTIGO
        -- Código novo                          NOVOIDSUBPRODUTO
        -- Data da abertura da loja             2020-01-01

*/

INSERT INTO DBA.ALTERACOES_LOGADAS (IDALTERACAO, IDUSUARIOALTERACAO, DESCRALTERACAO, DADONOVO, DTHORAALTERACAO, DADOANTIGO, TIPOALTERACAO, CODIGO1, CODIGO2, CODIGO3)
SELECT
        NUMBER() * -1,
        2,
        'Gerado novo código para o produto. Antigo: '||CODIGO_ANTIGO||' novo: '||NOVOIDSUBPRODUTO,
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
 * Histórico de alterações
        - 20/08/2018 -          | Ultima alteração;
        - 31/01/2020 - 1.2      | Ajuste nas variáveis e descrições. Alteração na data que deve ser informada, pois validando com analista contábil Mauricio Rodrigues (e ele validando com Gabriela Vitto Cecchin), a data de inserção desta informação precisa ser posterior a data de cadastro do produto e precisa ser uma data em que o SPED será apurado pelo CISSPoder;
        - 24/09/2020 - 1.3      | Adição de CASE para inserir na coluna CODIGO2 apenas números válidos do range integer.
		- 14/09/2021 - 			| Adcionado ao github
*/
