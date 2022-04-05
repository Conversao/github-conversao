DROP PROCEDURE DBA.SP_CUSTOS_CONVERSAO
GO
CREATE PROCEDURE DBA.SP_CUSTOS_CONVERSAO ( I_IDEMPRESA INTEGER, D_DTMOVIMENTO DATE )
BEGIN

    DECLARE LI_IDPLANILHA INTEGER;

    SET LI_IDPLANILHA = ( ( '9' || RIGHT( LEFT( REPLACE( TIMESTAMP(D_DTMOVIMENTO), '-', ''), 8 ), 6) || I_IDEMPRESA ) * -1 ) ;


    IF ( SELECT COUNT(*) FROM NOTAS WHERE IDEMPRESA = I_IDEMPRESA AND IDPLANILHA = LI_IDPLANILHA ) = 0 THEN

        INSERT  INTO DBA.NOTAS(IDPLANILHA, NUMCUPOMFISCAL, IDEMPRESA, DTMOVIMENTO, IDCLIFOR) VALUES  (
            LI_IDPLANILHA,
            LI_IDPLANILHA,
            I_IDEMPRESA,
            D_DTMOVIMENTO,
            (
            SELECT
                IDCLIFOR
            FROM
                CLIENTE_FORNECEDOR
            WHERE
                UFCLIFOR                = ( SELECT UF FROM EMPRESA WHERE IDEMPRESA = I_IDEMPRESA ) AND
                TIPOCADASTRO            IN('A', 'F') AND
                INSCRESTADUAL           IS NOT NULL AND
                TRIM(INSCRESTADUAL)     NOT IN('', 'ISENTO') AND
                IDATIVIDADE             IN(11) AND
                TIPOREGIMETRIBFEDERAL   = 'R'
                FETCH FIRST 1 ROWS ONLY
            )
        );

    END IF;


    FOR LOOPQUERY AS
        SELECT
            LI_IDPLANILHA               AS PLANILHA,
            IDEMPRESA                   AS EMPRESA,
            IDPRODUTO                   AS PRODUTO,
            IDSUBPRODUTO                AS SUBPRODUTO,
            CASE
                WHEN CUSTOGERENCIAL     > 0 THEN
                    CUSTOGERENCIAL
                WHEN CUSTOULTIMACOMPRA  > 0 THEN
                    CUSTOULTIMACOMPRA
                WHEN CUSTONOTAFISCAL    > 0 THEN
                    CUSTONOTAFISCAL
                WHEN VALCUSTOREPOS      > 0 THEN
                    VALCUSTOREPOS
            ELSE
                0
            END                         AS GERENCIAL,
            CUSTOULTIMACOMPRA           AS ULTIMA,
            CUSTONOTAFISCAL             AS NOTA,
            VALCUSTOREPOS               AS REPOSICAO,
            CASE
                WHEN CUSTONOTAFISCAL    > 0 THEN
                    CUSTONOTAFISCAL
                WHEN CUSTOGERENCIAL     > 0 THEN
                    CUSTOGERENCIAL
                WHEN CUSTOULTIMACOMPRA  > 0 THEN
                    CUSTOULTIMACOMPRA
                WHEN VALCUSTOREPOS      > 0 THEN
                    VALCUSTOREPOS
            ELSE
                0
            END                         AS CUSTO
        FROM
            POLITICA_PRECO_PRODUTO      PPP
        WHERE
            IDEMPRESA                   = I_IDEMPRESA AND
            ( CUSTONOTAFISCAL           > 0 OR
              CUSTOGERENCIAL            > 0 OR
              CUSTOULTIMACOMPRA         > 0 OR
              VALCUSTOREPOS             > 0 ) AND
            NOT EXISTS ( SELECT  1
                         FROM    MOVIMENTO_CUSTO MC
                         WHERE   DATE(MC.DTMOVIMENTO) = D_DTMOVIMENTO AND
                                 MC.IDPLANILHA        = LI_IDPLANILHA AND
                                 MC.IDEMPRESA         = PPP.IDEMPRESA AND
                                 MC.IDPRODUTO         = PPP.IDPRODUTO AND
                                 MC.IDSUBPRODUTO      = PPP.IDSUBPRODUTO )
            FETCH FIRST 20000 ROWS ONLY
    DO
        INSERT INTO DBA.MOVIMENTO_CUSTO( IDEMPRESA, IDPLANILHA, IDPRODUTO, IDSUBPRODUTO,VALUNITARIO ,VALUNITARIOBRUTO,QTDPRODUTO,NUMSEQUENCIA,DTMOVIMENTO, PERIPI, FLAGALTEROUCUSTO, TIPOREGIMETRIBFEDERAL,    TIPOCATEGORIA,    PERDESPOPERAC,    PEROUTDESPESAS,    PERICMSENTRADA,    PERMARGEMSUBST,    PERICMSUBSTFRONT, TIPOSITTRIB)
        VALUES ( EMPRESA, PLANILHA, PRODUTO, SUBPRODUTO, CUSTO, CUSTO, 1, 1, D_DTMOVIMENTO, 0, 'T', 'R', 'M', 0, 0, 0, 0, 0, 'A' );

        UPDATE
            PRODUTO_CUSTO
        SET
            CUSTONOTAFISCAL     = NOTA,
            CUSTOGERENCIAL      = GERENCIAL,
            CUSTOULTIMACOMPRA   = ULTIMA,
            CUSTOREPOSICAO      = REPOSICAO
        WHERE
            DATE(DTMOVIMENTO)   = D_DTMOVIMENTO AND
            IDEMPRESA           = EMPRESA       AND
            IDPLANILHA          = PLANILHA      AND
            IDPRODUTO           = PRODUTO       AND
            IDSUBPRODUTO        = SUBPRODUTO;

        UPDATE
            POLITICA_PRECO_PRODUTO
        SET
            CUSTONOTAFISCAL     = NOTA,
            CUSTOGERENCIAL      = GERENCIAL,
            CUSTOULTIMACOMPRA   = ULTIMA,
            VALCUSTOREPOS       = REPOSICAO
        WHERE
            IDEMPRESA           = EMPRESA AND
            IDPRODUTO           = PRODUTO AND
            IDSUBPRODUTO        = SUBPRODUTO;

    END FOR;

END

GO
COMMIT

-- Rodar varias vezes até inserir tudo.
-- CALL SP_CUSTOS_CONVERSAO( <EMPRESA>, <DATA ANTERIOR A ABERTURA DA LOJA 'AAAA-MM-DD'> )

-- Validar se todos foram inseridos:
-- SELECT COUNT(*), IDEMPRESA FROM DBA.MOVIMENTO_CUSTO WHERE DATE(DTMOVIMENTO) = 'AAAA-MM-DD' GROUP BY IDEMPRESA


-- Validando
-- SELECT IDEMPRESA, ORIGEMMOVIMENTO, DATE(DTMOVIMENTO), COUNT(*) FROM DBA.MOVIMENTO_CUSTO GROUP BY IDEMPRESA, ORIGEMMOVIMENTO, DATE(DTMOVIMENTO) ORDER BY DATE(DTMOVIMENTO)


/*

 * Histórico de alterações
        - 01/04/2019 -          | Ultima alteração;
        - 25/11/2019 - 2.1      | Alteração na ordem com que o CASE pega os custos, para considerar o Custo Nota Fiscal em primeiro lugar.

*/

