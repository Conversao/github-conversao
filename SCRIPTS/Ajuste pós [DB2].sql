-----------------------------------------------------------------------------------------------
-- Sem registro na POLITICA_PRECO_PRODUTO
-----------------------------------------------------------------------------------------------
INSERT  INTO DBA.POLITICA_PRECO_PRODUTO (        IDPRODUTO,        IDSUBPRODUTO,        IDEMPRESA,      DTALTERACAO,     VALPRECOVAREJO, PERMARGEMVAREJO,        VALPRECOATACADO,        PERMARGEMATACADO,       VALPROMVAREJO,  QTDMINPROMVAREJO,       VALPROMATACADO, QTDMINPROMATACADO,      VALCUSTOREPOS,  CUSTOGERENCIAL, CUSTONOTAFISCAL,        CUSTOULTIMACOMPRA , PERDESPOPER )
SELECT
        PRODUTO_GRADE.IDPRODUTO,
        PRODUTO_GRADE.IDSUBPRODUTO,
        EMPRESA.IDEMPRESA AS IDEMPRESA,
        NOW()   AS DTALTERACAO,
        0       AS VALPRECOVAREJO,
        0       AS PERMARGEMVAREJO,
        0       AS VALPRECOATACADO,
        0       AS PERMARGEMATACADO,
        0       AS VALPROMVAREJO,
        0       AS QTDMINPROMVAREJO,
        0       AS VALPROMATACADO,
        0       AS QTDMINPROMATACADO,
        0       AS VALCUSTOREPOS,
        0       AS CUSTOGERENCIAL,
        0       AS CUSTONOTAFISCAL,
        0       AS CUSTOULTIMACOMPRA,
        0       AS PERDESPOPER
FROM
        PRODUTO_GRADE,
        EMPRESA
WHERE
        NOT EXISTS(     SELECT
                                1
                        FROM
                                POLITICA_PRECO_PRODUTO
                        WHERE
                                POLITICA_PRECO_PRODUTO.IDEMPRESA        = EMPRESA.IDEMPRESA             AND
                                POLITICA_PRECO_PRODUTO.IDSUBPRODUTO     = PRODUTO_GRADE.IDSUBPRODUTO
                  )
GO
COMMIT
GO


-----------------------------------------------------------------------------------------------
-- Código de barras da unidade tributária
-----------------------------------------------------------------------------------------------
-- Replica o IDCODBARPROD para o IDCODBARPRODTRIB quando não existe, apenas para IDCODBARPROD de tamanho >= 8
BEGIN
    DECLARE I_IDPRODUTO         INTEGER;
    DECLARE I_IDSUBPRODUTO      INTEGER;
    DECLARE D_IDCODBARPROD      DECIMAL(14,0);
    DECLARE I_COUNT             INTEGER;
    DECLARE V_COMMIT            VARCHAR(6);

    SET V_COMMIT = 'COMMIT';

     REPEAT

        SET I_COUNT = 0;

        EXECUTE IMMEDIATE V_COMMIT;

        FOR LOOPQUERY AS
            SELECT
                PRODUTO_GRADE.IDPRODUTO,
                PRODUTO_GRADE.IDSUBPRODUTO,
                PRODUTO_GRADE.IDCODBARPROD
            FROM
                DBA.PRODUTO_GRADE
            WHERE
                LENGTH(CAST(IDCODBARPROD AS VARCHAR(20))) >= 8 AND
                (
                IDCODBARPRODTRIB  IS NULL
                )
            FETCH
                FIRST 1000 ROWS ONLY
        DO
            SET I_IDPRODUTO         = IDPRODUTO;
            SET I_IDSUBPRODUTO      = IDSUBPRODUTO;
            SET D_IDCODBARPROD      = IDCODBARPROD;
            SET I_COUNT             = I_COUNT + 1;

            UPDATE
                DBA.PRODUTO_GRADE
            SET
                IDCODBARPRODTRIB    = CAST(D_IDCODBARPROD AS VARCHAR(20))
            WHERE
                IDPRODUTO           = I_IDPRODUTO AND
                IDSUBPRODUTO        = I_IDSUBPRODUTO;
        END FOR;

    UNTIL(I_COUNT = 0)

    END REPEAT;
END
GO

-- Replica o IDCODBARPRODTRIB para o CODBARPRODTRIB quando não existe ou são diferentes
BEGIN
    DECLARE I_IDPRODUTO         INTEGER;
    DECLARE I_IDSUBPRODUTO      INTEGER;
    DECLARE D_IDCODBARPROD      DECIMAL(14,0);
    DECLARE I_COUNT             INTEGER;
    DECLARE V_COMMIT            VARCHAR(6);

    SET V_COMMIT = 'COMMIT';

     REPEAT

        SET I_COUNT = 0;

        EXECUTE IMMEDIATE V_COMMIT;

        FOR LOOPQUERY AS
            SELECT
                PRODUTO_GRADE.IDPRODUTO,
                PRODUTO_GRADE.IDSUBPRODUTO,
                PRODUTO_GRADE.IDCODBARPRODTRIB
            FROM
                DBA.PRODUTO_GRADE
            WHERE
                (
                CODBARPRODTRIB      IS NULL AND
                IDCODBARPRODTRIB    IS NOT NULL
                )
                OR
                (
                CODBARPRODTRIB      <> IDCODBARPRODTRIB AND
                IDCODBARPRODTRIB    IS NOT NULL
                )
            FETCH
                FIRST 1000 ROWS ONLY
        DO
            SET I_IDPRODUTO         = IDPRODUTO;
            SET I_IDSUBPRODUTO      = IDSUBPRODUTO;
            SET D_IDCODBARPROD      = IDCODBARPRODTRIB;
            SET I_COUNT             = I_COUNT + 1;

            UPDATE
                DBA.PRODUTO_GRADE
            SET
                CODBARPRODTRIB      = CAST(D_IDCODBARPROD AS VARCHAR(20))
            WHERE
                IDPRODUTO           = I_IDPRODUTO AND
                IDSUBPRODUTO        = I_IDSUBPRODUTO;
        END FOR;

    UNTIL(I_COUNT = 0)

    END REPEAT;
END
GO

-----------------------------------------------------------------------------------------------
-- CODBAR | Replica o IDCODBARPROD para o CODBAR quando não existe ou são diferentes
-----------------------------------------------------------------------------------------------
BEGIN
    DECLARE I_IDPRODUTO         INTEGER;
    DECLARE I_IDSUBPRODUTO      INTEGER;
    DECLARE D_IDCODBARPROD      DECIMAL(14,0);
    DECLARE I_COUNT             INTEGER;
    DECLARE V_COMMIT            VARCHAR(6);

    SET V_COMMIT = 'COMMIT';

     REPEAT

        SET I_COUNT = 0;

        EXECUTE IMMEDIATE V_COMMIT;

        FOR LOOPQUERY AS
            SELECT
                PRODUTO_GRADE.IDPRODUTO,
                PRODUTO_GRADE.IDSUBPRODUTO,
                PRODUTO_GRADE.IDCODBARPROD
            FROM
                DBA.PRODUTO_GRADE PRODUTO_GRADE
            WHERE
                (
                CODBAR          IS NULL AND
                IDCODBARPROD    IS NOT NULL
                )
                OR
                (
                CODBAR          <> IDCODBARPROD AND
                IDCODBARPROD    IS NOT NULL
                )
            FETCH
                FIRST 1000 ROWS ONLY
        DO
            SET I_IDPRODUTO         = IDPRODUTO;
            SET I_IDSUBPRODUTO      = IDSUBPRODUTO;
            SET D_IDCODBARPROD      = IDCODBARPROD;
            SET I_COUNT             = I_COUNT + 1;

            UPDATE
                DBA.PRODUTO_GRADE
            SET
                CODBAR              = CAST(D_IDCODBARPROD AS VARCHAR(20))
            WHERE
                IDPRODUTO           = I_IDPRODUTO AND
                IDSUBPRODUTO        = I_IDSUBPRODUTO;
        END FOR;

    UNTIL(I_COUNT = 0)

    END REPEAT;
END
GO



-----------------------------------------------------------------------------------------------
-- CEST
-----------------------------------------------------------------------------------------------
DROP PROCEDURE DBA.SP_121475_2()
GO
CREATE PROCEDURE DBA.SP_121475_2()
BEGIN
    DECLARE LI_ATEND        INTEGER    DEFAULT 0;
    DECLARE LI_FOR          INTEGER    DEFAULT 8;
    DECLARE LI_COUNT        INTEGER    DEFAULT 0;
    DECLARE LS_COMMIT       VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE LS_CODCESTNEW   VARCHAR(8);
    DECLARE LS_CODCEST      VARCHAR(8);
    DECLARE LS_NCM          VARCHAR(8);

    DECLARE CUR_NCM CURSOR WITH HOLD FOR
        SELECT DISTINCT
            CODCEST,
            NCM
        FROM
            DBA.PRODUTO_GRADE AS PG
        WHERE
            PG.FLAGINATIVO = 'F';

    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET LI_ATEND = 1;

    OPEN CUR_NCM;

    FETCH
        CUR_NCM
    INTO
        LS_CODCEST,
        LS_NCM;

    WHILE ( LI_ATEND = 0 ) DO

        SET LI_COUNT = 0;

        SET LI_COUNT = LI_COUNT + COALESCE( (SELECT COUNT(*) FROM DBA.CEST_NCM WHERE CODCEST = LS_CODCEST AND NCM = LS_NCM )        , 0 );
        SET LI_COUNT = LI_COUNT + COALESCE( (SELECT COUNT(*) FROM DBA.CEST_NCM WHERE CODCEST = LS_CODCEST AND NCM = LEFT(LS_NCM,7) ), 0 );
        SET LI_COUNT = LI_COUNT + COALESCE( (SELECT COUNT(*) FROM DBA.CEST_NCM WHERE CODCEST = LS_CODCEST AND NCM = LEFT(LS_NCM,6) ), 0 );
        SET LI_COUNT = LI_COUNT + COALESCE( (SELECT COUNT(*) FROM DBA.CEST_NCM WHERE CODCEST = LS_CODCEST AND NCM = LEFT(LS_NCM,5) ), 0 );
        SET LI_COUNT = LI_COUNT + COALESCE( (SELECT COUNT(*) FROM DBA.CEST_NCM WHERE CODCEST = LS_CODCEST AND NCM = LEFT(LS_NCM,4) ), 0 );
        SET LI_COUNT = LI_COUNT + COALESCE( (SELECT COUNT(*) FROM DBA.CEST_NCM WHERE CODCEST = LS_CODCEST AND NCM = LEFT(LS_NCM,3) ), 0 );
        SET LI_COUNT = LI_COUNT + COALESCE( (SELECT COUNT(*) FROM DBA.CEST_NCM WHERE CODCEST = LS_CODCEST AND NCM = LEFT(LS_NCM,2) ), 0 );

        IF LI_COUNT = 0 THEN
            SET LI_FOR = 8;
        ELSE
            SET LI_FOR = 0;
        END IF;

        WHILE LI_FOR > 0 DO

            IF LI_FOR >= 2 THEN

                SET LS_CODCESTNEW = (SELECT MIN(CODCEST) FROM DBA.CEST_NCM WHERE NCM = LEFT(LS_NCM,LI_FOR) );

                IF LS_CODCESTNEW IS NOT NULL AND LS_CODCESTNEW <> '' THEN

                    IF COALESCE(LS_CODCEST, '-1') <> LS_CODCESTNEW THEN

                        UPDATE
                            DBA.PRODUTO_GRADE
                        SET
                            CODCEST = LS_CODCESTNEW
                        WHERE
                            COALESCE( CODCEST, '-1' ) = COALESCE( LS_CODCEST, '-1' ) AND
                            NCM                       = LS_NCM;

                        EXECUTE IMMEDIATE LS_COMMIT;
                        SET LI_FOR = 0;

                    ELSE

                        SET LI_FOR = 0;

                    END IF;

                END IF;
            ELSE

                IF COALESCE( LS_CODCEST, '-1') <> '0000000' THEN

                    UPDATE
                        DBA.PRODUTO_GRADE
                    SET
                        CODCEST = '0000000'
                    WHERE
                        COALESCE( CODCEST, '-1' ) = COALESCE( LS_CODCEST, '-1' ) AND
                        NCM                       = LS_NCM;

                    EXECUTE IMMEDIATE LS_COMMIT;
                    SET LI_FOR = 0;

                ELSE

                    SET LI_FOR = 0;

                END IF;

            END IF;

            SET LI_FOR = LI_FOR - 1;

        END WHILE;

        FETCH
            CUR_NCM
        INTO
            LS_CODCEST,
            LS_NCM;

    END WHILE;

    CLOSE CUR_NCM;

END
GO
CALL DBA.SP_121475_2()
GO

-----------------------------------------------------------------------------------------------
-- Ajuste dos enters
-----------------------------------------------------------------------------------------------
-- Alterando:
-----------------------------------------------
-- Remover enters na OBSGERAL
-----------------------------------------------
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     OBSGERAL    LIKE '%\x0D\x0A%'   OR OBSGERAL         LIKE '%\x0D\x0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     OBSGERAL                        = REPLACE(OBSGERAL     , '\x0D\x0A',       CHR(9) )
                WHERE   OBSGERAL                        LIKE '%\x0D\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     OBSGERAL                        = REPLACE(OBSGERAL     , '\X09',       CHR(9) )
                WHERE   OBSGERAL                        LIKE '%\x0D\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   OBSGERAL    LIKE '%\x0D\x0A%'   OR OBSGERAL    LIKE '%\x0D\x0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     OBSGERAL    LIKE '%\x0D%'   OR OBSGERAL         LIKE '%\x0D%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     OBSGERAL                        = REPLACE(OBSGERAL     , '\x0D',       CHR(9) )
                WHERE   OBSGERAL                        LIKE '%\x0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     OBSGERAL                        = REPLACE(OBSGERAL     , '\x0D',       CHR(9) )
                WHERE   OBSGERAL                        LIKE '%\x0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   OBSGERAL    LIKE '%\x0D%'   OR OBSGERAL    LIKE '%\x0D%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     OBSGERAL    LIKE '%\x0A%'   OR OBSGERAL         LIKE '%\x0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     OBSGERAL                        = REPLACE(OBSGERAL     , '\x0A',       CHR(9) )
                WHERE   OBSGERAL                        LIKE '%\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     OBSGERAL                        = REPLACE(OBSGERAL     , '\x0A',       CHR(9) )
                WHERE   OBSGERAL                        LIKE '%\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   OBSGERAL    LIKE '%\x0A%'   OR OBSGERAL    LIKE '%\x0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     OBSGERAL    LIKE '%\X0D\X0A%'   OR OBSGERAL         LIKE '%\X0D\X0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     OBSGERAL                        = REPLACE(OBSGERAL     , '\X0D\X0A',       CHR(9) )
                WHERE   OBSGERAL                        LIKE '%\X0D\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     OBSGERAL                        = REPLACE(OBSGERAL     , '\X0D\X0A',       CHR(9) )
                WHERE   OBSGERAL                        LIKE '%\X0D\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   OBSGERAL    LIKE '%\X0D\X0A%'   OR OBSGERAL    LIKE '%\X0D\X0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     OBSGERAL    LIKE '%\X0D%'   OR OBSGERAL         LIKE '%\X0D%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     OBSGERAL                        = REPLACE(OBSGERAL     , '\X0D',       CHR(9) )
                WHERE   OBSGERAL                        LIKE '%\X0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     OBSGERAL                        = REPLACE(OBSGERAL     , '\X0D',       CHR(9) )
                WHERE   OBSGERAL                        LIKE '%\X0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   OBSGERAL    LIKE '%\X0D%'   OR OBSGERAL    LIKE '%\X0D%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     OBSGERAL    LIKE '%\X0A%'   OR OBSGERAL         LIKE '%\X0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     OBSGERAL                        = REPLACE(OBSGERAL     , '\X0A',       CHR(9) )
                WHERE   OBSGERAL                        LIKE '%\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     OBSGERAL                        = REPLACE(OBSGERAL     , '\X0A',       CHR(9) )
                WHERE   OBSGERAL                        LIKE '%\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   OBSGERAL    LIKE '%\X0A%'   OR OBSGERAL    LIKE '%\X0A%'  );

        END WHILE;
END
GO
COMMIT
GO
-----------------------------------------------
-- Remover enters na REFBANCARIA
-----------------------------------------------
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFBANCARIA    LIKE '%\x0D\x0A%'   OR REFBANCARIA         LIKE '%\x0D\x0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFBANCARIA                        = REPLACE(REFBANCARIA     , '\x0D\x0A',       CHR(9) )
                WHERE   REFBANCARIA                        LIKE '%\x0D\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFBANCARIA                        = REPLACE(REFBANCARIA     , '\X09',       CHR(9) )
                WHERE   REFBANCARIA                        LIKE '%\x0D\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFBANCARIA    LIKE '%\x0D\x0A%'   OR REFBANCARIA    LIKE '%\x0D\x0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFBANCARIA    LIKE '%\x0D%'   OR REFBANCARIA         LIKE '%\x0D%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFBANCARIA                        = REPLACE(REFBANCARIA     , '\x0D',       CHR(9) )
                WHERE   REFBANCARIA                        LIKE '%\x0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFBANCARIA                        = REPLACE(REFBANCARIA     , '\x0D',       CHR(9) )
                WHERE   REFBANCARIA                        LIKE '%\x0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFBANCARIA    LIKE '%\x0D%'   OR REFBANCARIA    LIKE '%\x0D%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFBANCARIA    LIKE '%\x0A%'   OR REFBANCARIA         LIKE '%\x0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFBANCARIA                        = REPLACE(REFBANCARIA     , '\x0A',       CHR(9) )
                WHERE   REFBANCARIA                        LIKE '%\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFBANCARIA                        = REPLACE(REFBANCARIA     , '\x0A',       CHR(9) )
                WHERE   REFBANCARIA                        LIKE '%\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFBANCARIA    LIKE '%\x0A%'   OR REFBANCARIA    LIKE '%\x0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFBANCARIA    LIKE '%\X0D\X0A%'   OR REFBANCARIA         LIKE '%\X0D\X0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFBANCARIA                        = REPLACE(REFBANCARIA     , '\X0D\X0A',       CHR(9) )
                WHERE   REFBANCARIA                        LIKE '%\X0D\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFBANCARIA                        = REPLACE(REFBANCARIA     , '\X0D\X0A',       CHR(9) )
                WHERE   REFBANCARIA                        LIKE '%\X0D\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFBANCARIA    LIKE '%\X0D\X0A%'   OR REFBANCARIA    LIKE '%\X0D\X0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFBANCARIA    LIKE '%\X0D%'   OR REFBANCARIA         LIKE '%\X0D%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFBANCARIA                        = REPLACE(REFBANCARIA     , '\X0D',       CHR(9) )
                WHERE   REFBANCARIA                        LIKE '%\X0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFBANCARIA                        = REPLACE(REFBANCARIA     , '\X0D',       CHR(9) )
                WHERE   REFBANCARIA                        LIKE '%\X0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFBANCARIA    LIKE '%\X0D%'   OR REFBANCARIA    LIKE '%\X0D%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFBANCARIA    LIKE '%\X0A%'   OR REFBANCARIA         LIKE '%\X0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFBANCARIA                        = REPLACE(REFBANCARIA     , '\X0A',       CHR(9) )
                WHERE   REFBANCARIA                        LIKE '%\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFBANCARIA                        = REPLACE(REFBANCARIA     , '\X0A',       CHR(9) )
                WHERE   REFBANCARIA                        LIKE '%\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFBANCARIA    LIKE '%\X0A%'   OR REFBANCARIA    LIKE '%\X0A%'  );

        END WHILE;
END
GO

COMMIT
GO
-----------------------------------------------
-- Remover enters na REFCOMERCIAL
-----------------------------------------------
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFCOMERCIAL    LIKE '%\x0D\x0A%'   OR REFCOMERCIAL         LIKE '%\x0D\x0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFCOMERCIAL                        = REPLACE(REFCOMERCIAL     , '\x0D\x0A',       CHR(9) )
                WHERE   REFCOMERCIAL                        LIKE '%\x0D\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFCOMERCIAL                        = REPLACE(REFCOMERCIAL     , '\X09',       CHR(9) )
                WHERE   REFCOMERCIAL                        LIKE '%\x0D\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFCOMERCIAL    LIKE '%\x0D\x0A%'   OR REFCOMERCIAL    LIKE '%\x0D\x0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFCOMERCIAL    LIKE '%\x0D%'   OR REFCOMERCIAL         LIKE '%\x0D%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFCOMERCIAL                        = REPLACE(REFCOMERCIAL     , '\x0D',       CHR(9) )
                WHERE   REFCOMERCIAL                        LIKE '%\x0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFCOMERCIAL                        = REPLACE(REFCOMERCIAL     , '\x0D',       CHR(9) )
                WHERE   REFCOMERCIAL                        LIKE '%\x0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFCOMERCIAL    LIKE '%\x0D%'   OR REFCOMERCIAL    LIKE '%\x0D%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFCOMERCIAL    LIKE '%\x0A%'   OR REFCOMERCIAL         LIKE '%\x0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFCOMERCIAL                        = REPLACE(REFCOMERCIAL     , '\x0A',       CHR(9) )
                WHERE   REFCOMERCIAL                        LIKE '%\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFCOMERCIAL                        = REPLACE(REFCOMERCIAL     , '\x0A',       CHR(9) )
                WHERE   REFCOMERCIAL                        LIKE '%\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFCOMERCIAL    LIKE '%\x0A%'   OR REFCOMERCIAL    LIKE '%\x0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFCOMERCIAL    LIKE '%\X0D\X0A%'   OR REFCOMERCIAL         LIKE '%\X0D\X0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFCOMERCIAL                        = REPLACE(REFCOMERCIAL     , '\X0D\X0A',       CHR(9) )
                WHERE   REFCOMERCIAL                        LIKE '%\X0D\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFCOMERCIAL                        = REPLACE(REFCOMERCIAL     , '\X0D\X0A',       CHR(9) )
                WHERE   REFCOMERCIAL                        LIKE '%\X0D\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFCOMERCIAL    LIKE '%\X0D\X0A%'   OR REFCOMERCIAL    LIKE '%\X0D\X0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFCOMERCIAL    LIKE '%\X0D%'   OR REFCOMERCIAL         LIKE '%\X0D%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFCOMERCIAL                        = REPLACE(REFCOMERCIAL     , '\X0D',       CHR(9) )
                WHERE   REFCOMERCIAL                        LIKE '%\X0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFCOMERCIAL                        = REPLACE(REFCOMERCIAL     , '\X0D',       CHR(9) )
                WHERE   REFCOMERCIAL                        LIKE '%\X0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFCOMERCIAL    LIKE '%\X0D%'   OR REFCOMERCIAL    LIKE '%\X0D%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFCOMERCIAL    LIKE '%\X0A%'   OR REFCOMERCIAL         LIKE '%\X0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFCOMERCIAL                        = REPLACE(REFCOMERCIAL     , '\X0A',       CHR(9) )
                WHERE   REFCOMERCIAL                        LIKE '%\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFCOMERCIAL                        = REPLACE(REFCOMERCIAL     , '\X0A',       CHR(9) )
                WHERE   REFCOMERCIAL                        LIKE '%\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFCOMERCIAL    LIKE '%\X0A%'   OR REFCOMERCIAL    LIKE '%\X0A%'  );

        END WHILE;
END
GO

COMMIT
GO
-----------------------------------------------
-- Remover enters na REFPESSOAL
-----------------------------------------------
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFPESSOAL    LIKE '%\x0D\x0A%'   OR REFPESSOAL         LIKE '%\x0D\x0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFPESSOAL                        = REPLACE(REFPESSOAL     , '\x0D\x0A',       CHR(9) )
                WHERE   REFPESSOAL                        LIKE '%\x0D\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFPESSOAL                        = REPLACE(REFPESSOAL     , '\X09',       CHR(9) )
                WHERE   REFPESSOAL                        LIKE '%\x0D\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFPESSOAL    LIKE '%\x0D\x0A%'   OR REFPESSOAL    LIKE '%\x0D\x0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFPESSOAL    LIKE '%\x0D%'   OR REFPESSOAL         LIKE '%\x0D%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFPESSOAL                        = REPLACE(REFPESSOAL     , '\x0D',       CHR(9) )
                WHERE   REFPESSOAL                        LIKE '%\x0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFPESSOAL                        = REPLACE(REFPESSOAL     , '\x0D',       CHR(9) )
                WHERE   REFPESSOAL                        LIKE '%\x0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFPESSOAL    LIKE '%\x0D%'   OR REFPESSOAL    LIKE '%\x0D%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFPESSOAL    LIKE '%\x0A%'   OR REFPESSOAL         LIKE '%\x0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFPESSOAL                        = REPLACE(REFPESSOAL     , '\x0A',       CHR(9) )
                WHERE   REFPESSOAL                        LIKE '%\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFPESSOAL                        = REPLACE(REFPESSOAL     , '\x0A',       CHR(9) )
                WHERE   REFPESSOAL                        LIKE '%\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFPESSOAL    LIKE '%\x0A%'   OR REFPESSOAL    LIKE '%\x0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFPESSOAL    LIKE '%\X0D\X0A%'   OR REFPESSOAL         LIKE '%\X0D\X0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFPESSOAL                        = REPLACE(REFPESSOAL     , '\X0D\X0A',       CHR(9) )
                WHERE   REFPESSOAL                        LIKE '%\X0D\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFPESSOAL                        = REPLACE(REFPESSOAL     , '\X0D\X0A',       CHR(9) )
                WHERE   REFPESSOAL                        LIKE '%\X0D\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFPESSOAL    LIKE '%\X0D\X0A%'   OR REFPESSOAL    LIKE '%\X0D\X0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFPESSOAL    LIKE '%\X0D%'   OR REFPESSOAL         LIKE '%\X0D%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFPESSOAL                        = REPLACE(REFPESSOAL     , '\X0D',       CHR(9) )
                WHERE   REFPESSOAL                        LIKE '%\X0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFPESSOAL                        = REPLACE(REFPESSOAL     , '\X0D',       CHR(9) )
                WHERE   REFPESSOAL                        LIKE '%\X0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFPESSOAL    LIKE '%\X0D%'   OR REFPESSOAL    LIKE '%\X0D%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFPESSOAL    LIKE '%\X0A%'   OR REFPESSOAL         LIKE '%\X0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFPESSOAL                        = REPLACE(REFPESSOAL     , '\X0A',       CHR(9) )
                WHERE   REFPESSOAL                        LIKE '%\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFPESSOAL                        = REPLACE(REFPESSOAL     , '\X0A',       CHR(9) )
                WHERE   REFPESSOAL                        LIKE '%\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFPESSOAL    LIKE '%\X0A%'   OR REFPESSOAL    LIKE '%\X0A%'  );

        END WHILE;
END
GO

COMMIT
GO
-----------------------------------------------
-- Remover enters na REFSEPROC
-----------------------------------------------
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFSEPROC    LIKE '%\x0D\x0A%'   OR REFSEPROC         LIKE '%\x0D\x0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFSEPROC                        = REPLACE(REFSEPROC     , '\x0D\x0A',       CHR(9) )
                WHERE   REFSEPROC                        LIKE '%\x0D\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFSEPROC                        = REPLACE(REFSEPROC     , '\X09',       CHR(9) )
                WHERE   REFSEPROC                        LIKE '%\x0D\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFSEPROC    LIKE '%\x0D\x0A%'   OR REFSEPROC    LIKE '%\x0D\x0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFSEPROC    LIKE '%\x0D%'   OR REFSEPROC         LIKE '%\x0D%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFSEPROC                        = REPLACE(REFSEPROC     , '\x0D',       CHR(9) )
                WHERE   REFSEPROC                        LIKE '%\x0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFSEPROC                        = REPLACE(REFSEPROC     , '\x0D',       CHR(9) )
                WHERE   REFSEPROC                        LIKE '%\x0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFSEPROC    LIKE '%\x0D%'   OR REFSEPROC    LIKE '%\x0D%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFSEPROC    LIKE '%\x0A%'   OR REFSEPROC         LIKE '%\x0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFSEPROC                        = REPLACE(REFSEPROC     , '\x0A',       CHR(9) )
                WHERE   REFSEPROC                        LIKE '%\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFSEPROC                        = REPLACE(REFSEPROC     , '\x0A',       CHR(9) )
                WHERE   REFSEPROC                        LIKE '%\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFSEPROC    LIKE '%\x0A%'   OR REFSEPROC    LIKE '%\x0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFSEPROC    LIKE '%\X0D\X0A%'   OR REFSEPROC         LIKE '%\X0D\X0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFSEPROC                        = REPLACE(REFSEPROC     , '\X0D\X0A',       CHR(9) )
                WHERE   REFSEPROC                        LIKE '%\X0D\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFSEPROC                        = REPLACE(REFSEPROC     , '\X0D\X0A',       CHR(9) )
                WHERE   REFSEPROC                        LIKE '%\X0D\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFSEPROC    LIKE '%\X0D\X0A%'   OR REFSEPROC    LIKE '%\X0D\X0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFSEPROC    LIKE '%\X0D%'   OR REFSEPROC         LIKE '%\X0D%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFSEPROC                        = REPLACE(REFSEPROC     , '\X0D',       CHR(9) )
                WHERE   REFSEPROC                        LIKE '%\X0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFSEPROC                        = REPLACE(REFSEPROC     , '\X0D',       CHR(9) )
                WHERE   REFSEPROC                        LIKE '%\X0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFSEPROC    LIKE '%\X0D%'   OR REFSEPROC    LIKE '%\X0D%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFSEPROC    LIKE '%\X0A%'   OR REFSEPROC         LIKE '%\X0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFSEPROC                        = REPLACE(REFSEPROC     , '\X0A',       CHR(9) )
                WHERE   REFSEPROC                        LIKE '%\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFSEPROC                        = REPLACE(REFSEPROC     , '\X0A',       CHR(9) )
                WHERE   REFSEPROC                        LIKE '%\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFSEPROC    LIKE '%\X0A%'   OR REFSEPROC    LIKE '%\X0A%'  );

        END WHILE;
END
GO

COMMIT
GO
-----------------------------------------------
-- Remover enters na DESCRCONTRATOSERVICO
-----------------------------------------------
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     DESCRCONTRATOSERVICO    LIKE '%\x0D\x0A%'   OR DESCRCONTRATOSERVICO         LIKE '%\x0D\x0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     DESCRCONTRATOSERVICO                        = REPLACE(DESCRCONTRATOSERVICO     , '\x0D\x0A',       CHR(9) )
                WHERE   DESCRCONTRATOSERVICO                        LIKE '%\x0D\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     DESCRCONTRATOSERVICO                        = REPLACE(DESCRCONTRATOSERVICO     , '\X09',       CHR(9) )
                WHERE   DESCRCONTRATOSERVICO                        LIKE '%\x0D\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   DESCRCONTRATOSERVICO    LIKE '%\x0D\x0A%'   OR DESCRCONTRATOSERVICO    LIKE '%\x0D\x0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     DESCRCONTRATOSERVICO    LIKE '%\x0D%'   OR DESCRCONTRATOSERVICO         LIKE '%\x0D%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     DESCRCONTRATOSERVICO                        = REPLACE(DESCRCONTRATOSERVICO     , '\x0D',       CHR(9) )
                WHERE   DESCRCONTRATOSERVICO                        LIKE '%\x0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     DESCRCONTRATOSERVICO                        = REPLACE(DESCRCONTRATOSERVICO     , '\x0D',       CHR(9) )
                WHERE   DESCRCONTRATOSERVICO                        LIKE '%\x0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   DESCRCONTRATOSERVICO    LIKE '%\x0D%'   OR DESCRCONTRATOSERVICO    LIKE '%\x0D%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     DESCRCONTRATOSERVICO    LIKE '%\x0A%'   OR DESCRCONTRATOSERVICO         LIKE '%\x0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     DESCRCONTRATOSERVICO                        = REPLACE(DESCRCONTRATOSERVICO     , '\x0A',       CHR(9) )
                WHERE   DESCRCONTRATOSERVICO                        LIKE '%\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     DESCRCONTRATOSERVICO                        = REPLACE(DESCRCONTRATOSERVICO     , '\x0A',       CHR(9) )
                WHERE   DESCRCONTRATOSERVICO                        LIKE '%\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   DESCRCONTRATOSERVICO    LIKE '%\x0A%'   OR DESCRCONTRATOSERVICO    LIKE '%\x0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     DESCRCONTRATOSERVICO    LIKE '%\X0D\X0A%'   OR DESCRCONTRATOSERVICO         LIKE '%\X0D\X0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     DESCRCONTRATOSERVICO                        = REPLACE(DESCRCONTRATOSERVICO     , '\X0D\X0A',       CHR(9) )
                WHERE   DESCRCONTRATOSERVICO                        LIKE '%\X0D\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     DESCRCONTRATOSERVICO                        = REPLACE(DESCRCONTRATOSERVICO     , '\X0D\X0A',       CHR(9) )
                WHERE   DESCRCONTRATOSERVICO                        LIKE '%\X0D\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   DESCRCONTRATOSERVICO    LIKE '%\X0D\X0A%'   OR DESCRCONTRATOSERVICO    LIKE '%\X0D\X0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     DESCRCONTRATOSERVICO    LIKE '%\X0D%'   OR DESCRCONTRATOSERVICO         LIKE '%\X0D%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     DESCRCONTRATOSERVICO                        = REPLACE(DESCRCONTRATOSERVICO     , '\X0D',       CHR(9) )
                WHERE   DESCRCONTRATOSERVICO                        LIKE '%\X0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     DESCRCONTRATOSERVICO                        = REPLACE(DESCRCONTRATOSERVICO     , '\X0D',       CHR(9) )
                WHERE   DESCRCONTRATOSERVICO                        LIKE '%\X0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   DESCRCONTRATOSERVICO    LIKE '%\X0D%'   OR DESCRCONTRATOSERVICO    LIKE '%\X0D%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     DESCRCONTRATOSERVICO    LIKE '%\X0A%'   OR DESCRCONTRATOSERVICO         LIKE '%\X0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     DESCRCONTRATOSERVICO                        = REPLACE(DESCRCONTRATOSERVICO     , '\X0A',       CHR(9) )
                WHERE   DESCRCONTRATOSERVICO                        LIKE '%\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     DESCRCONTRATOSERVICO                        = REPLACE(DESCRCONTRATOSERVICO     , '\X0A',       CHR(9) )
                WHERE   DESCRCONTRATOSERVICO                        LIKE '%\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   DESCRCONTRATOSERVICO    LIKE '%\X0A%'   OR DESCRCONTRATOSERVICO    LIKE '%\X0A%'  );

        END WHILE;
END
GO

COMMIT
GO

-----------------------------------------------
-- Remover enters na OBSESPECIFIC
-----------------------------------------------
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_ESPECIFICACAO_TECNICA WHERE     OBSESPECIFIC    LIKE '%\x0D\x0A%'   OR OBSESPECIFIC         LIKE '%\x0D\x0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.PRODUTO_ESPECIFICACAO_TECNICA
                SET     OBSESPECIFIC                        = REPLACE(OBSESPECIFIC     , '\x0D\x0A',       CHR(9) )
                WHERE   OBSESPECIFIC                        LIKE '%\x0D\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.PRODUTO_ESPECIFICACAO_TECNICA
                SET     OBSESPECIFIC                        = REPLACE(OBSESPECIFIC     , '\X09',       CHR(9) )
                WHERE   OBSESPECIFIC                        LIKE '%\x0D\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_ESPECIFICACAO_TECNICA WHERE   OBSESPECIFIC    LIKE '%\x0D\x0A%'   OR OBSESPECIFIC    LIKE '%\x0D\x0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_ESPECIFICACAO_TECNICA WHERE     OBSESPECIFIC    LIKE '%\x0D%'   OR OBSESPECIFIC         LIKE '%\x0D%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.PRODUTO_ESPECIFICACAO_TECNICA
                SET     OBSESPECIFIC                        = REPLACE(OBSESPECIFIC     , '\x0D',       CHR(9) )
                WHERE   OBSESPECIFIC                        LIKE '%\x0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.PRODUTO_ESPECIFICACAO_TECNICA
                SET     OBSESPECIFIC                        = REPLACE(OBSESPECIFIC     , '\x0D',       CHR(9) )
                WHERE   OBSESPECIFIC                        LIKE '%\x0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_ESPECIFICACAO_TECNICA WHERE   OBSESPECIFIC    LIKE '%\x0D%'   OR OBSESPECIFIC    LIKE '%\x0D%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_ESPECIFICACAO_TECNICA WHERE     OBSESPECIFIC    LIKE '%\x0A%'   OR OBSESPECIFIC         LIKE '%\x0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.PRODUTO_ESPECIFICACAO_TECNICA
                SET     OBSESPECIFIC                        = REPLACE(OBSESPECIFIC     , '\x0A',       CHR(9) )
                WHERE   OBSESPECIFIC                        LIKE '%\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.PRODUTO_ESPECIFICACAO_TECNICA
                SET     OBSESPECIFIC                        = REPLACE(OBSESPECIFIC     , '\x0A',       CHR(9) )
                WHERE   OBSESPECIFIC                        LIKE '%\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_ESPECIFICACAO_TECNICA WHERE   OBSESPECIFIC    LIKE '%\x0A%'   OR OBSESPECIFIC    LIKE '%\x0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_ESPECIFICACAO_TECNICA WHERE     OBSESPECIFIC    LIKE '%\X0D\X0A%'   OR OBSESPECIFIC         LIKE '%\X0D\X0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.PRODUTO_ESPECIFICACAO_TECNICA
                SET     OBSESPECIFIC                        = REPLACE(OBSESPECIFIC     , '\X0D\X0A',       CHR(9) )
                WHERE   OBSESPECIFIC                        LIKE '%\X0D\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.PRODUTO_ESPECIFICACAO_TECNICA
                SET     OBSESPECIFIC                        = REPLACE(OBSESPECIFIC     , '\X0D\X0A',       CHR(9) )
                WHERE   OBSESPECIFIC                        LIKE '%\X0D\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_ESPECIFICACAO_TECNICA WHERE   OBSESPECIFIC    LIKE '%\X0D\X0A%'   OR OBSESPECIFIC    LIKE '%\X0D\X0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_ESPECIFICACAO_TECNICA WHERE     OBSESPECIFIC    LIKE '%\X0D%'   OR OBSESPECIFIC         LIKE '%\X0D%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.PRODUTO_ESPECIFICACAO_TECNICA
                SET     OBSESPECIFIC                        = REPLACE(OBSESPECIFIC     , '\X0D',       CHR(9) )
                WHERE   OBSESPECIFIC                        LIKE '%\X0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.PRODUTO_ESPECIFICACAO_TECNICA
                SET     OBSESPECIFIC                        = REPLACE(OBSESPECIFIC     , '\X0D',       CHR(9) )
                WHERE   OBSESPECIFIC                        LIKE '%\X0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_ESPECIFICACAO_TECNICA WHERE   OBSESPECIFIC    LIKE '%\X0D%'   OR OBSESPECIFIC    LIKE '%\X0D%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_ESPECIFICACAO_TECNICA WHERE     OBSESPECIFIC    LIKE '%\X0A%'   OR OBSESPECIFIC         LIKE '%\X0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.PRODUTO_ESPECIFICACAO_TECNICA
                SET     OBSESPECIFIC                        = REPLACE(OBSESPECIFIC     , '\X0A',       CHR(9) )
                WHERE   OBSESPECIFIC                        LIKE '%\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.PRODUTO_ESPECIFICACAO_TECNICA
                SET     OBSESPECIFIC                        = REPLACE(OBSESPECIFIC     , '\X0A',       CHR(9) )
                WHERE   OBSESPECIFIC                        LIKE '%\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_ESPECIFICACAO_TECNICA WHERE   OBSESPECIFIC    LIKE '%\X0A%'   OR OBSESPECIFIC    LIKE '%\X0A%'  );

        END WHILE;
END
GO

COMMIT
GO

-----------------------------------------------
-- Remover enters na DESCRICAO
-----------------------------------------------
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_GRADE_ECOMMERCE WHERE     DESCRICAO    LIKE '%\x0D\x0A%'   OR DESCRICAO         LIKE '%\x0D\x0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.PRODUTO_GRADE_ECOMMERCE
                SET     DESCRICAO                        = REPLACE(DESCRICAO     , '\x0D\x0A',       CHR(9) )
                WHERE   DESCRICAO                        LIKE '%\x0D\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.PRODUTO_GRADE_ECOMMERCE
                SET     DESCRICAO                        = REPLACE(DESCRICAO     , '\X09',       CHR(9) )
                WHERE   DESCRICAO                        LIKE '%\x0D\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_GRADE_ECOMMERCE WHERE   DESCRICAO    LIKE '%\x0D\x0A%'   OR DESCRICAO    LIKE '%\x0D\x0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_GRADE_ECOMMERCE WHERE     DESCRICAO    LIKE '%\x0D%'   OR DESCRICAO         LIKE '%\x0D%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.PRODUTO_GRADE_ECOMMERCE
                SET     DESCRICAO                        = REPLACE(DESCRICAO     , '\x0D',       CHR(9) )
                WHERE   DESCRICAO                        LIKE '%\x0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.PRODUTO_GRADE_ECOMMERCE
                SET     DESCRICAO                        = REPLACE(DESCRICAO     , '\x0D',       CHR(9) )
                WHERE   DESCRICAO                        LIKE '%\x0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_GRADE_ECOMMERCE WHERE   DESCRICAO    LIKE '%\x0D%'   OR DESCRICAO    LIKE '%\x0D%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_GRADE_ECOMMERCE WHERE     DESCRICAO    LIKE '%\x0A%'   OR DESCRICAO         LIKE '%\x0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.PRODUTO_GRADE_ECOMMERCE
                SET     DESCRICAO                        = REPLACE(DESCRICAO     , '\x0A',       CHR(9) )
                WHERE   DESCRICAO                        LIKE '%\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.PRODUTO_GRADE_ECOMMERCE
                SET     DESCRICAO                        = REPLACE(DESCRICAO     , '\x0A',       CHR(9) )
                WHERE   DESCRICAO                        LIKE '%\x0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_GRADE_ECOMMERCE WHERE   DESCRICAO    LIKE '%\x0A%'   OR DESCRICAO    LIKE '%\x0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_GRADE_ECOMMERCE WHERE     DESCRICAO    LIKE '%\X0D\X0A%'   OR DESCRICAO         LIKE '%\X0D\X0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.PRODUTO_GRADE_ECOMMERCE
                SET     DESCRICAO                        = REPLACE(DESCRICAO     , '\X0D\X0A',       CHR(9) )
                WHERE   DESCRICAO                        LIKE '%\X0D\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.PRODUTO_GRADE_ECOMMERCE
                SET     DESCRICAO                        = REPLACE(DESCRICAO     , '\X0D\X0A',       CHR(9) )
                WHERE   DESCRICAO                        LIKE '%\X0D\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_GRADE_ECOMMERCE WHERE   DESCRICAO    LIKE '%\X0D\X0A%'   OR DESCRICAO    LIKE '%\X0D\X0A%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_GRADE_ECOMMERCE WHERE     DESCRICAO    LIKE '%\X0D%'   OR DESCRICAO         LIKE '%\X0D%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.PRODUTO_GRADE_ECOMMERCE
                SET     DESCRICAO                        = REPLACE(DESCRICAO     , '\X0D',       CHR(9) )
                WHERE   DESCRICAO                        LIKE '%\X0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.PRODUTO_GRADE_ECOMMERCE
                SET     DESCRICAO                        = REPLACE(DESCRICAO     , '\X0D',       CHR(9) )
                WHERE   DESCRICAO                        LIKE '%\X0D%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_GRADE_ECOMMERCE WHERE   DESCRICAO    LIKE '%\X0D%'   OR DESCRICAO    LIKE '%\X0D%'  );

        END WHILE;
END
GO
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_GRADE_ECOMMERCE WHERE     DESCRICAO    LIKE '%\X0A%'   OR DESCRICAO         LIKE '%\X0A%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.PRODUTO_GRADE_ECOMMERCE
                SET     DESCRICAO                        = REPLACE(DESCRICAO     , '\X0A',       CHR(9) )
                WHERE   DESCRICAO                        LIKE '%\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.PRODUTO_GRADE_ECOMMERCE
                SET     DESCRICAO                        = REPLACE(DESCRICAO     , '\X0A',       CHR(9) )
                WHERE   DESCRICAO                        LIKE '%\X0A%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_GRADE_ECOMMERCE WHERE   DESCRICAO    LIKE '%\X0A%'   OR DESCRICAO    LIKE '%\X0A%'  );

        END WHILE;
END
GO

COMMIT
GO


-----------------------------------------------------------------------------------------------
-- Ajustar contador da CLIENTE_OBSERVACAO_HISTORICO
-----------------------------------------------------------------------------------------------
BEGIN
        DECLARE LS_STMT         VARCHAR(500);
        SET LS_STMT             = 'ALTER TABLE CLIENTE_OBSERVACAO_HISTORICO  ALTER COLUMN IDOBSERVACAO SET GENERATED ALWAYS RESTART WITH ' || (SELECT COALESCE(MAX(IDOBSERVACAO), 0) + 1 FROM CLIENTE_OBSERVACAO_HISTORICO);
        EXECUTE IMMEDIATE LS_STMT;

END
GO
COMMIT
GO


-----------------------------------------------------------------------------------------------
-- Ajustar contador de locais de entrega
-----------------------------------------------------------------------------------------------
BEGIN
        DECLARE LS_STMT         VARCHAR(500);
        SET LS_STMT             = 'UPDATE  DBA.CONFIG_CONTADOR SET     IDCONTADOR = ' || ( SELECT MAX(IDLOCALENTREGA) + 1000 FROM DBA.LOCAL_ENTREGA ) || ' , DESCRLABEL = ''CONTADOR DE LOCAIS DE ENTREGA'' WHERE   DESCRCONTADOR = ''CTDLOCALENT'' ';

        IF ( SELECT MAX(IDLOCALENTREGA) FROM DBA.LOCAL_ENTREGA ) IS NOT NULL THEN

            IF ( SELECT 1 FROM DBA.CONFIG_CONTADOR WHERE DESCRCONTADOR = 'CTDLOCALENT' ) IS NULL THEN
                    INSERT INTO DBA.CONFIG_CONTADOR(DESCRCONTADOR, IDCONTADOR, DESCRLABEL, DTALTERACAO)
                    SELECT 'CTDLOCALENT', MAX(IDLOCALENTREGA) + 1000, 'CONTADOR DE LOCAIS DE ENTREGA', NOW() FROM DBA.LOCAL_ENTREGA;
            ELSE
                    EXECUTE IMMEDIATE LS_STMT;
            END IF;

        END IF;
END
GO
COMMIT
GO


-----------------------------------------------------------------------------------------------
-- Ajustar a sequence da CENARIO_FISCAL
-----------------------------------------------------------------------------------------------
BEGIN
        DECLARE LS_STMT         VARCHAR(500);
        SET LS_STMT             = 'ALTER SEQUENCE SQ_CENARIOFISCAL RESTART WITH ' ||  (SELECT COALESCE(MAX(IDCENARIOFISCAL), 0) + 1 FROM DBA.CENARIO_FISCAL);
        EXECUTE IMMEDIATE LS_STMT;

END
GO
COMMIT
GO


-----------------------------------------------------------------------------------------------
-- Ajustar contador da CARGO_COMPLEMENTAR
-----------------------------------------------------------------------------------------------
BEGIN
        DECLARE LS_STMT         VARCHAR(500);
        SET LS_STMT             = 'ALTER TABLE DBA.CARGO_COMPLEMENTAR  ALTER COLUMN IDCARGOCOMPLEMENTAR SET GENERATED ALWAYS RESTART WITH ' || (SELECT COALESCE(MAX(IDCARGOCOMPLEMENTAR), 0) + 1 FROM DBA.CARGO_COMPLEMENTAR);
        EXECUTE IMMEDIATE LS_STMT;

END
GO
COMMIT
GO


-----------------------------------------------------------------------------------------------
-- Remover ponto e virgula no final dos e-mails
-----------------------------------------------------------------------------------------------
BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   RIGHT( TRIM(EMAIL) , 1) = ';' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     EMAIL                                   = LEFT(TRIM(EMAIL), LENGTH(TRIM(EMAIL))-1)
                WHERE   RIGHT( TRIM(EMAIL) , 1)                 = ';'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   RIGHT( TRIM(EMAIL) , 1) = ';' );

        END WHILE;
END
GO

BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   RIGHT( TRIM(EMAILFINANCEIRO) , 1) = ';' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     EMAILFINANCEIRO                         = LEFT(TRIM(EMAILFINANCEIRO), LENGTH(TRIM(EMAILFINANCEIRO))-1)
                WHERE   RIGHT( TRIM(EMAILFINANCEIRO) , 1)       = ';'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   RIGHT( TRIM(EMAILFINANCEIRO) , 1) = ';' );

        END WHILE;
END
GO

BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR_CONTATO WHERE   RIGHT( TRIM(EMAIL) , 1) = ';' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR_CONTATO
                SET     EMAIL                                   = LEFT(TRIM(EMAIL), LENGTH(TRIM(EMAIL))-1)
                WHERE   RIGHT( TRIM(EMAIL) , 1)                 = ';'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR_CONTATO WHERE   RIGHT( TRIM(EMAIL) , 1) = ';' );

        END WHILE;
END
GO
COMMIT
GO



-----------------------------------------------------------------------------------------------
-- Ajuste dos tabs
-----------------------------------------------------------------------------------------------

BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     OBSGERAL    LIKE '%\X09%'   OR OBSGERAL         LIKE '%\x09%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     OBSGERAL                        = REPLACE(OBSGERAL     , '\x09',       CHR(9) )
                WHERE   OBSGERAL                        LIKE '%\x09%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     OBSGERAL                        = REPLACE(OBSGERAL     , '\X09',       CHR(9) )
                WHERE   OBSGERAL                        LIKE '%\X09%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   OBSGERAL    LIKE '%\X09%'   OR OBSGERAL    LIKE '%\x09%'  );

        END WHILE;
END
GO

BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFBANCARIA    LIKE '%\X09%'   OR REFBANCARIA         LIKE '%\x09%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFBANCARIA                     = REPLACE(REFBANCARIA     , '\x09',       CHR(9) )
                WHERE   REFBANCARIA                     LIKE '%\x09%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFBANCARIA                     = REPLACE(REFBANCARIA     , '\X09',       CHR(9) )
                WHERE   REFBANCARIA                     LIKE '%\X09%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFBANCARIA    LIKE '%\X09%'   OR REFBANCARIA    LIKE '%\x09%'  );

        END WHILE;
END
GO

BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFCOMERCIAL    LIKE '%\X09%'   OR REFCOMERCIAL         LIKE '%\x09%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFCOMERCIAL                    = REPLACE(REFCOMERCIAL     , '\x09',       CHR(9) )
                WHERE   REFCOMERCIAL                    LIKE '%\x09%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFCOMERCIAL                    = REPLACE(REFCOMERCIAL     , '\X09',       CHR(9) )
                WHERE   REFCOMERCIAL                    LIKE '%\X09%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFCOMERCIAL    LIKE '%\X09%'   OR REFCOMERCIAL    LIKE '%\x09%'  );

        END WHILE;
END
GO

BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFPESSOAL    LIKE '%\X09%'   OR REFPESSOAL         LIKE '%\x09%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFPESSOAL                      = REPLACE(REFPESSOAL     , '\x09',       CHR(9) )
                WHERE   REFPESSOAL                      LIKE '%\x09%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFPESSOAL                      = REPLACE(REFPESSOAL     , '\X09',       CHR(9) )
                WHERE   REFPESSOAL                      LIKE '%\X09%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFPESSOAL    LIKE '%\X09%'   OR REFPESSOAL    LIKE '%\x09%'  );

        END WHILE;
END
GO

BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     REFSEPROC    LIKE '%\X09%'   OR REFSEPROC         LIKE '%\x09%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFSEPROC                       = REPLACE(REFSEPROC     , '\x09',       CHR(9) )
                WHERE   REFSEPROC                       LIKE '%\x09%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     REFSEPROC                       = REPLACE(REFSEPROC     , '\X09',       CHR(9) )
                WHERE   REFSEPROC                       LIKE '%\X09%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   REFSEPROC    LIKE '%\X09%'   OR REFSEPROC    LIKE '%\x09%'  );

        END WHILE;
END
GO

BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE     DESCRCONTRATOSERVICO    LIKE '%\X09%'   OR DESCRCONTRATOSERVICO         LIKE '%\x09%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     DESCRCONTRATOSERVICO            = REPLACE(DESCRCONTRATOSERVICO     , '\x09',       CHR(9) )
                WHERE   DESCRCONTRATOSERVICO            LIKE '%\x09%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.CLIENTE_FORNECEDOR
                SET     DESCRCONTRATOSERVICO            = REPLACE(DESCRCONTRATOSERVICO     , '\X09',       CHR(9) )
                WHERE   DESCRCONTRATOSERVICO            LIKE '%\X09%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.CLIENTE_FORNECEDOR WHERE   DESCRCONTRATOSERVICO    LIKE '%\X09%'   OR DESCRCONTRATOSERVICO    LIKE '%\x09%'  );

        END WHILE;
END
GO

BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_ESPECIFICACAO_TECNICA WHERE     OBSESPECIFIC    LIKE '%\X09%'   OR OBSESPECIFIC         LIKE '%\x09%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.PRODUTO_ESPECIFICACAO_TECNICA
                SET     OBSESPECIFIC                            = REPLACE(OBSESPECIFIC     , '\x09',       x'09' )
                WHERE   OBSESPECIFIC                            LIKE '%\x09%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.PRODUTO_ESPECIFICACAO_TECNICA
                SET     OBSESPECIFIC                            = REPLACE(OBSESPECIFIC     , '\X09',       x'09' )
                WHERE   OBSESPECIFIC                            LIKE '%\X09%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_ESPECIFICACAO_TECNICA WHERE   OBSESPECIFIC    LIKE '%\X09%'   OR OBSESPECIFIC    LIKE '%\x09%'  );

        END WHILE;
END
GO

BEGIN
    DECLARE LS_COMMIT   VARCHAR(6) DEFAULT 'COMMIT';
    DECLARE CONTADOR    INTEGER;

    SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_GRADE_ECOMMERCE WHERE   DESCRICAO    LIKE '%\X09%'   OR DESCRICAO    LIKE '%\x09%' );

        WHILE ( CONTADOR > 0 ) DO

                UPDATE  DBA.PRODUTO_GRADE_ECOMMERCE
                SET     DESCRICAO                       = REPLACE(DESCRICAO     , '\x09',       CHR(9) )
                WHERE   DESCRICAO                       LIKE '%\x09%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                UPDATE  DBA.PRODUTO_GRADE_ECOMMERCE
                SET     DESCRICAO                       = REPLACE(DESCRICAO     , '\X09',       CHR(9) )
                WHERE   DESCRICAO                       LIKE '%\X09%'
                        LIMIT 1000;

                EXECUTE IMMEDIATE LS_COMMIT;

                SET CONTADOR  = ( SELECT  COUNT(*) FROM    DBA.PRODUTO_GRADE_ECOMMERCE WHERE   DESCRICAO    LIKE '%\X09%'   OR DESCRICAO    LIKE '%\x09%'  );

        END WHILE;
END
GO

COMMIT
GO

-----------------------------------------------------------------------------------------------
-- Sem registro na ESTOQUE_SALDO_ATUAL
-----------------------------------------------------------------------------------------------
BEGIN
        DECLARE I_COUNT         INTEGER;
        DECLARE V_COMMIT        VARCHAR(6);

        SET V_COMMIT            = 'COMMIT';

        REPEAT

                SET I_COUNT = 0;

                EXECUTE IMMEDIATE V_COMMIT;

                FOR LOOPQUERY AS

                        SELECT
                                COUNT(*) QTD
                        FROM
                                DBA.PRODUTO_GRADE,
                                (
                                SELECT
                                                ECL.IDLOCALESTOQUE,
                                                CASE
                                                 WHEN ECL.IDEMPRESABAIXAEST IS NOT NULL THEN
                                                        ECL.IDEMPRESABAIXAEST
                                                ELSE
                                                        E.IDEMPRESA
                                                END IDEMPRESA

                                FROM
                                                DBA.ESTOQUE_CADASTRO_LOCAL      AS ECL
                                LEFT JOIN
                                                DBA.EMPRESA                                     AS E ON ECL.IDEMPRESABAIXAEST IS NULL
                                ORDER BY
                                                ECL.IDLOCALESTOQUE,
                                                IDEMPRESA
                                ) AS EMPRESA_LOCAL
                        WHERE
                                NOT EXISTS      (
                                                        SELECT
                                                                1
                                                        FROM
                                                                DBA.ESTOQUE_SALDO_ATUAL
                                                        WHERE
                                                                ESTOQUE_SALDO_ATUAL.IDEMPRESA           = EMPRESA_LOCAL.IDEMPRESA       AND
                                                                ESTOQUE_SALDO_ATUAL.IDLOCALESTOQUE      = EMPRESA_LOCAL.IDLOCALESTOQUE  AND
                                                                ESTOQUE_SALDO_ATUAL.IDPRODUTO           = PRODUTO_GRADE.IDPRODUTO       AND
                                                                ESTOQUE_SALDO_ATUAL.IDSUBPRODUTO        = PRODUTO_GRADE.IDSUBPRODUTO

                                                )

                DO
                        SET I_COUNT     = QTD;

                        INSERT  INTO DBA.ESTOQUE_SALDO_ATUAL ( IDPRODUTO,IDSUBPRODUTO,IDLOCALESTOQUE,IDEMPRESA,DTMOVIMENTO )
                        SELECT
                                PRODUTO_GRADE.IDPRODUTO         AS PRODUTO,
                                PRODUTO_GRADE.IDSUBPRODUTO      AS SUBPRODUTO,
                                EMPRESA_LOCAL.IDLOCALESTOQUE    AS LOCAL,
                                EMPRESA_LOCAL.IDEMPRESA         AS EMPRESA,
                                TODAY()                                                 AS DATA
                        FROM
                                DBA.PRODUTO_GRADE,
                                (
                                SELECT
                                                ECL.IDLOCALESTOQUE,
                                                CASE
                                                 WHEN ECL.IDEMPRESABAIXAEST IS NOT NULL THEN
                                                        ECL.IDEMPRESABAIXAEST
                                                ELSE
                                                        E.IDEMPRESA
                                                END IDEMPRESA

                                FROM
                                                DBA.ESTOQUE_CADASTRO_LOCAL      AS ECL
                                LEFT JOIN
                                                DBA.EMPRESA                                     AS E ON ECL.IDEMPRESABAIXAEST IS NULL
                                ORDER BY
                                                ECL.IDLOCALESTOQUE,
                                                IDEMPRESA
                                ) AS EMPRESA_LOCAL
                        WHERE
                                NOT EXISTS      (
                                                        SELECT
                                                                1
                                                        FROM
                                                                DBA.ESTOQUE_SALDO_ATUAL
                                                        WHERE
                                                                ESTOQUE_SALDO_ATUAL.IDEMPRESA           = EMPRESA_LOCAL.IDEMPRESA       AND
                                                                ESTOQUE_SALDO_ATUAL.IDLOCALESTOQUE      = EMPRESA_LOCAL.IDLOCALESTOQUE  AND
                                                                ESTOQUE_SALDO_ATUAL.IDPRODUTO           = PRODUTO_GRADE.IDPRODUTO       AND
                                                                ESTOQUE_SALDO_ATUAL.IDSUBPRODUTO        = PRODUTO_GRADE.IDSUBPRODUTO
                                                )
                        FETCH
                                FIRST 50000 ROWS ONLY;

                END FOR;

        UNTIL(I_COUNT = 0)

        END REPEAT;

END
GO

COMMIT
GO


/*

 * Histórico de alterações
        - 22/08/2018 -          | Ultima alteração;
        - 21/08/2019 - 1.1      | Versionado script e inclusão do rodapé; Criado ajuste "CODBAR" (Replicar o IDCORBARPROD para o CODBAR, quando este não existir ou quando for diferente);
        - 27/08/2019 - 1.2      | Alteração na seção "CODBAR", criando uma estrutura de SP para efetuar o ajuste. Ajustar a seção "Códgio de barras da unidade tributária" para replicar somente EANs de tamanho maior ou igual a 8, pois estes campos devem receber o código de barras válido da menor unidade de medida, e códigos menores que 8 claramente não tem GTIN válido, por este motivo a Sefaz não aprova a nota;
        - 15/10/2019 - 1.3      | Criada a seção "Ajustar contador da CLIENTE_OBSERVACAO_HISTORICO";
        - 21/11/2019 - 1.4      | Criada a seção "Ajustar contador de locais de entrega";
        - 10/03/2020 - 1.5      | Criada a seção "Ajustar sequence da CENARIO_FISCAL";
        - 30/03/2020 - 1.6      | Ajuste na seção "Ajustar contador de locais de entrega", quando não existia nenhum registro na tabela LOCAL_ENTREGA a rotina retornava valor nulo e atribuía este ao update/insert, resultando em erro de execução. Adicionado um IF para validar e corrigir;
        - 20/05/2020 - 1.7      | Ajuste na seção "Ajustar contador da CLIENTE_OBSERVACAO_HISTORICO" para corrigir erro de execução quando tabela esta vazia;
        - 22/07/2020 - 1.8      | Criada a seção "Ajustar contador da CARGO_COMPLEMENTAR";
        - 26/02/2021 - 1.9      | Alteração do ajustes de enters das especificações técnicas mudando o "CHR(10)" para "x'0D' || x'0A'". Ajustes na identação do script. Remoção do ajuste de enters na coluna COMENTARIO da tabela CLIENTE_FORNECEDOR;
        - 16/03/2021 - 2.0      | Criada a seção "Remover ponto e virgula no final dos e-mails";
        - 18/03/2021 - 2.1      | Alteração na seção "Ajuste dos enters" adicionando tratamento ao campo descrição das propriedades de e-commerce;
        - 24/03/2021 - 2.2      | Criada a seção "Ajuste dos tabs".
        - 12/05/2021 - 2.3      | Alterado ajustes de enters para rodar em estrutura de loop;
        - 15/07/2021 - 2.4      | Adição de novas colunas na seção "Sem registro na POLITICA_PRECO_PRODUTO" para evitar deixar campos nulos, da mesma forma como o CISSPoder faz o insert na tabela.
        - 27/07/2021 - 2.5      | Criada a seção "Sem registro na ESTOQUE_SALDO_ATUAL" para inserir registros zerados de todos os produtos, todas as empresas e todos os locais de estoque quando ainda não existam nesta tabela, a partir do que Michel Guilherme Da Rold Silva informou que o sistema necessita desta informação devido algum problema relacionado a avaria ou devolução (algo neste sentido) para futuras releaseses do sistema iriam adicionar um insert para que quando o produto for cadastrado ele inserir esses registros.
		- 14/09/2021 - 			| Adcionado ao github
*/
