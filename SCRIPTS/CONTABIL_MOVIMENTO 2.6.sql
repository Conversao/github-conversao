INSERT  INTO DBA.CONTABIL_MOVIMENTO (IDCTACONTABIL,IDPLANILHA,NUMSEQUENCIA,TIPONATUREZALCTO,IDEMPRESA,IDUSUARIO,ORIGEMMOVIMENTO,DTMOVIMENTO,VALLANCAMENTO,COMPLEMENTO,TIPONATUREZACTA,FLAGATUALIZAGEREN,DTLANCAMENTO,FLAGEXPORTADO,FLAGFLUXOEXECUTADO,FLAGSALDOPROCESSADO)
        -----------------------------
        -- Contas a Receber e Cartões
        -----------------------------
        -- Débito
        SELECT  CR.IDCTACONTABIL                AS IDCTACONTABIL,
                CR.IDPLANILHA                   AS IDPLANILHA,
                1                               AS NUMSEQUENCIA,
                'D'                             AS TIPONATUREZALCTO,
                CR.IDEMPRESA                    AS IDEMPRESA,
                2                               AS IDUSUARIO,
                CR.ORIGEMMOVIMENTO              AS ORIGEMMOVIMENTO,
                CR.DTMOVIMENTO                  AS DTMOVIMENTO,
                SUM(CR.VALTITULO)               AS VALLANCAMENTO,
                CR.OBSTITULO                    AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'F'                             AS FLAGFLUXOEXECUTADO,
                'F'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.CONTAS_RECEBER              CR,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   CR.IDCTACONTABIL                = CPC.IDCTACONTABIL     AND
                CR.IDPLANILHA                   < 0                     AND
                CR.SERIENOTA                    = 'AVU'                 AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   CR.IDPLANILHA           = CM.IDPLANILHA AND
                                                        CR.IDEMPRESA            = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'D')
                GROUP BY        CR.IDCTACONTABIL,
                                CR.IDPLANILHA,
                                CR.IDEMPRESA,
                                CR.ORIGEMMOVIMENTO,
                                CR.DTMOVIMENTO,
                                CR.OBSTITULO,
                                CPC.TIPONATUREZA

        UNION ALL

        -- Crédito
        SELECT  CR.IDCTACONTABILCONTRAPARTIDA   AS IDCTACONTABIL,
                CR.IDPLANILHA                   AS IDPLANILHA,
                1                               AS NUMSEQUENCIA,
                'C'                             AS TIPONATUREZALCTO,
                CR.IDEMPRESA                    AS IDEMPRESA,
                2                               AS IDUSUARIO,
                CR.ORIGEMMOVIMENTO              AS ORIGEMMOVIMENTO,
                CR.DTMOVIMENTO                  AS DTMOVIMENTO,
                SUM(CR.VALTITULO)               AS VALLANCAMENTO,
                CR.OBSTITULO                    AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'F'                             AS FLAGFLUXOEXECUTADO,
                'F'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.CONTAS_RECEBER              CR,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   CR.IDCTACONTABILCONTRAPARTIDA   = CPC.IDCTACONTABIL     AND
                CR.IDPLANILHA                   < 0                     AND
                CR.SERIENOTA                    = 'AVU'                 AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   CR.IDPLANILHA           = CM.IDPLANILHA AND
                                                        CR.IDEMPRESA            = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'C')
                GROUP BY        CR.IDCTACONTABILCONTRAPARTIDA,
                                CR.IDPLANILHA,
                                CR.IDEMPRESA,
                                CR.ORIGEMMOVIMENTO,
                                CR.DTMOVIMENTO,
                                CR.OBSTITULO,
                                CPC.TIPONATUREZA

UNION ALL

        -------------------
        -- Contas a pagar
        -------------------

        -- Débito
        SELECT  CP.IDCTACONTABIL                AS IDCTACONTABIL,
                CP.IDPLANILHA                   AS IDPLANILHA,
                1                               AS NUMSEQUENCIA,
                'D'                             AS TIPONATUREZALCTO,
                CP.IDEMPRESA                    AS IDEMPRESA,
                2                               AS IDUSUARIO,
                CP.ORIGEMMOVIMENTO              AS ORIGEMMOVIMENTO,
                CP.DTMOVIMENTO                  AS DTMOVIMENTO,
                SUM(CP.VALTITULO)               AS VALLANCAMENTO,
                CP.OBSTITULO                    AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'F'                             AS FLAGFLUXOEXECUTADO,
                'F'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.CONTAS_PAGAR                CP,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   CP.IDCTACONTABIL                = CPC.IDCTACONTABIL     AND
                CP.IDPLANILHA                   < 0                     AND
                CP.SERIENOTA                    = 'AVU'                 AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   CP.IDPLANILHA           = CM.IDPLANILHA AND
                                                        CP.IDEMPRESA            = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'D')
                GROUP BY        CP.IDCTACONTABIL,
                                CP.IDPLANILHA,
                                CP.IDEMPRESA,
                                CP.ORIGEMMOVIMENTO,
                                CP.DTMOVIMENTO,
                                CP.OBSTITULO,
                                CPC.TIPONATUREZA

        UNION ALL

        -- Crédito
        SELECT  CP.IDCTACONTABILCONTRAPARTIDA   AS IDCTACONTABIL,
                CP.IDPLANILHA                   AS IDPLANILHA,
                1                               AS NUMSEQUENCIA,
                'C'                             AS TIPONATUREZALCTO,
                CP.IDEMPRESA                    AS IDEMPRESA,
                2                               AS IDUSUARIO,
                CP.ORIGEMMOVIMENTO              AS ORIGEMMOVIMENTO,
                CP.DTMOVIMENTO                  AS DTMOVIMENTO,
                SUM(CP.VALTITULO)               AS VALLANCAMENTO,
                CP.OBSTITULO                    AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'F'                             AS FLAGFLUXOEXECUTADO,
                'F'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.CONTAS_PAGAR                CP,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   CP.IDCTACONTABILCONTRAPARTIDA   = CPC.IDCTACONTABIL     AND
                CP.IDPLANILHA                   < 0                     AND
                CP.SERIENOTA                    = 'AVU'                 AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   CP.IDPLANILHA           = CM.IDPLANILHA AND
                                                        CP.IDEMPRESA            = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'C')
                GROUP BY        CP.IDCTACONTABILCONTRAPARTIDA,
                                CP.IDPLANILHA,
                                CP.IDEMPRESA,
                                CP.ORIGEMMOVIMENTO,
                                CP.DTMOVIMENTO,
                                CP.OBSTITULO,
                                CPC.TIPONATUREZA

UNION ALL


        -------------------------------
        -- Cheques Recebidos | Lançados
        -------------------------------

        -- Débito
        SELECT  CHM.IDCTACONTABIL               AS IDCTACONTABIL,
                CHM.IDPLANILHA                  AS IDPLANILHA,
                CH.NUMSEQUENCIA                 AS NUMSEQUENCIA,
                'D'                             AS TIPONATUREZALCTO,
                CHM.IDEMPRESA                   AS IDEMPRESA,
                2                               AS IDUSUARIO,
                'AVU'                           AS ORIGEMMOVIMENTO,
                CHM.DTMOVIMENTO                 AS DTMOVIMENTO,
                SUM(CHM.VALOR)                  AS VALLANCAMENTO,
                CHM.OBSGERAL                    AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'F'                             AS FLAGFLUXOEXECUTADO,
                'F'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.CHEQUES_MOVIMENTO           CHM,
                DBA.CHEQUES                     CH,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   CH.TIPOCHEQUE                   = 'R'                   AND
                CHM.IDCTACONTABIL               = CPC.IDCTACONTABIL     AND
                CHM.IDPLANILHACHEQUE            = CH.IDPLANILHA         AND
                CHM.TIPOSITUACAO                = 'L'                   AND
                CHM.IDPLANILHA                  < 0                     AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   CHM.IDPLANILHA          = CM.IDPLANILHA AND
                                                        CHM.IDEMPRESA           = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'D')
                GROUP BY        CHM.IDCTACONTABIL,
                                CHM.IDPLANILHA,
                                CHM.IDEMPRESA,
                                CHM.DTMOVIMENTO,
                                CHM.OBSGERAL,
                                CPC.TIPONATUREZA,
                                CH.NUMSEQUENCIA

        UNION ALL

        -- Crédito
        SELECT  3110104                         AS IDCTACONTABIL, -- 3110104 - VENDA EM CHEQUE
                CHM.IDPLANILHA                  AS IDPLANILHA,
                CH.NUMSEQUENCIA                 AS NUMSEQUENCIA,
                'C'                             AS TIPONATUREZALCTO,
                CHM.IDEMPRESA                   AS IDEMPRESA,
                2                               AS IDUSUARIO,
                'AVU'                           AS ORIGEMMOVIMENTO,
                CHM.DTMOVIMENTO                 AS DTMOVIMENTO,
                SUM(CHM.VALOR)                  AS VALLANCAMENTO,
                CHM.OBSGERAL                    AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'F'                             AS FLAGFLUXOEXECUTADO,
                'F'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.CHEQUES_MOVIMENTO           CHM,
                DBA.CHEQUES                     CH,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   CH.TIPOCHEQUE                   = 'R'                   AND
                3110104                         = CPC.IDCTACONTABIL     AND
                CHM.IDPLANILHACHEQUE            = CH.IDPLANILHA         AND
                CHM.IDPLANILHA                  < 0                     AND
                CHM.TIPOSITUACAO                = 'L'                   AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   CHM.IDPLANILHA          = CM.IDPLANILHA AND
                                                        CHM.IDEMPRESA           = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'C')
                GROUP BY        CHM.IDCTACONTABIL,
                                CHM.IDPLANILHA,
                                CHM.IDEMPRESA,
                                CHM.DTMOVIMENTO,
                                CHM.OBSGERAL,
                                CPC.TIPONATUREZA,
                                CH.NUMSEQUENCIA

UNION ALL

        --------------------------------
        -- Cheques Recebidos | Liquidado
        --------------------------------

        -- Débito
        SELECT  CHM.IDCTACONTABIL               AS IDCTACONTABIL,
                CHM.IDPLANILHA                  AS IDPLANILHA,
                CH.NUMSEQUENCIA                 AS NUMSEQUENCIA,
                'D'                             AS TIPONATUREZALCTO,
                CHM.IDEMPRESA                   AS IDEMPRESA,
                2                               AS IDUSUARIO,
                'AVU'                           AS ORIGEMMOVIMENTO,
                CHM.DTMOVIMENTO                 AS DTMOVIMENTO,
                SUM(CHM.VALOR)                  AS VALLANCAMENTO,
                CHM.OBSGERAL                    AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'F'                             AS FLAGFLUXOEXECUTADO,
                'F'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.CHEQUES_MOVIMENTO           CHM,
                DBA.CHEQUES                     CH,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   CH.TIPOCHEQUE                   = 'R'                   AND
                CHM.IDCTACONTABIL               = CPC.IDCTACONTABIL     AND
                CHM.IDPLANILHACHEQUE            = CH.IDPLANILHA         AND
                CHM.TIPOSITUACAO                = 'Q'                   AND
                CHM.IDPLANILHA                  < 0                     AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   CHM.IDPLANILHA          = CM.IDPLANILHA AND
                                                        CHM.IDEMPRESA           = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'D')
                GROUP BY        CHM.IDCTACONTABIL,
                                CHM.IDPLANILHA,
                                CHM.IDEMPRESA,
                                CHM.DTMOVIMENTO,
                                CHM.OBSGERAL,
                                CPC.TIPONATUREZA,
                                CH.NUMSEQUENCIA

        UNION ALL

        -- Crédito
        SELECT  1120501                         AS IDCTACONTABIL, -- 1120501 - CHEQUES A RECEBER
                CHM.IDPLANILHA                  AS IDPLANILHA,
                CH.NUMSEQUENCIA                 AS NUMSEQUENCIA,
                'C'                             AS TIPONATUREZALCTO,
                CHM.IDEMPRESA                   AS IDEMPRESA,
                2                               AS IDUSUARIO,
                'AVU'                           AS ORIGEMMOVIMENTO,
                CHM.DTMOVIMENTO                 AS DTMOVIMENTO,
                SUM(CHM.VALOR)                  AS VALLANCAMENTO,
                CHM.OBSGERAL                    AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'F'                             AS FLAGFLUXOEXECUTADO,
                'F'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.CHEQUES_MOVIMENTO           CHM,
                DBA.CHEQUES                     CH,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   CH.TIPOCHEQUE                   = 'R'                   AND
                1120501                         = CPC.IDCTACONTABIL     AND
                CHM.IDPLANILHACHEQUE            = CH.IDPLANILHA         AND
                CHM.IDPLANILHA                  < 0                     AND
                CHM.TIPOSITUACAO                = 'Q'                   AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   CHM.IDPLANILHA          = CM.IDPLANILHA AND
                                                        CHM.IDEMPRESA           = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'C')
                GROUP BY        CHM.IDCTACONTABIL,
                                CHM.IDPLANILHA,
                                CHM.IDEMPRESA,
                                CHM.DTMOVIMENTO,
                                CHM.OBSGERAL,
                                CPC.TIPONATUREZA,
                                CH.NUMSEQUENCIA

UNION ALL


        ---------------------------------
        -- Cheques Recebidos | Devolvidos
        ---------------------------------
        -- Débito
        SELECT  CHM.IDCTACONTABIL               AS IDCTACONTABIL,
                CHM.IDPLANILHA                  AS IDPLANILHA,
                CH.NUMSEQUENCIA                 AS NUMSEQUENCIA,
                'D'                             AS TIPONATUREZALCTO,
                CHM.IDEMPRESA                   AS IDEMPRESA,
                2                               AS IDUSUARIO,
                'AVU'                           AS ORIGEMMOVIMENTO,
                CHM.DTMOVIMENTO                 AS DTMOVIMENTO,
                SUM(CHM.VALOR)                  AS VALLANCAMENTO,
                CHM.OBSGERAL                    AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'F'                             AS FLAGFLUXOEXECUTADO,
                'F'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.CHEQUES_MOVIMENTO           CHM,
                DBA.CHEQUES                     CH,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   CH.TIPOCHEQUE                   = 'R'                   AND
                CHM.IDCTACONTABIL               = CPC.IDCTACONTABIL     AND
                CHM.IDPLANILHACHEQUE            = CH.IDPLANILHA         AND
                CHM.TIPOSITUACAO                = 'D'                   AND
                CHM.IDPLANILHA                  < 0                     AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   CHM.IDPLANILHA          = CM.IDPLANILHA AND
                                                        CHM.IDEMPRESA           = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'D')
                GROUP BY        CHM.IDCTACONTABIL,
                                CHM.IDPLANILHA,
                                CHM.IDEMPRESA,
                                CHM.DTMOVIMENTO,
                                CHM.OBSGERAL,
                                CPC.TIPONATUREZA,
                                CH.NUMSEQUENCIA
        UNION ALL

        -- Crédito
        SELECT  1120501                         AS IDCTACONTABIL, -- 1120501 - CHEQUES A RECEBER
                CHM.IDPLANILHA                  AS IDPLANILHA,
                CH.NUMSEQUENCIA                 AS NUMSEQUENCIA,
                'C'                             AS TIPONATUREZALCTO,
                CHM.IDEMPRESA                   AS IDEMPRESA,
                2                               AS IDUSUARIO,
                'AVU'                           AS ORIGEMMOVIMENTO,
                CHM.DTMOVIMENTO                 AS DTMOVIMENTO,
                SUM(CHM.VALOR)                  AS VALLANCAMENTO,
                CHM.OBSGERAL                    AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'F'                             AS FLAGFLUXOEXECUTADO,
                'F'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.CHEQUES_MOVIMENTO           CHM,
                DBA.CHEQUES                     CH,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   CH.TIPOCHEQUE                   = 'R'                   AND
                1120501                         = CPC.IDCTACONTABIL     AND
                CHM.IDPLANILHACHEQUE            = CH.IDPLANILHA         AND
                CHM.IDPLANILHA                  < 0                     AND
                CHM.TIPOSITUACAO                = 'D'                   AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   CHM.IDPLANILHA          = CM.IDPLANILHA AND
                                                        CHM.IDEMPRESA           = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'C')
                GROUP BY        CHM.IDCTACONTABIL,
                                CHM.IDPLANILHA,
                                CHM.IDEMPRESA,
                                CHM.DTMOVIMENTO,
                                CHM.OBSGERAL,
                                CPC.TIPONATUREZA,
                                CH.NUMSEQUENCIA


UNION ALL

        ------------------------------
        -- Cheques Emitidos | Lançados
        ------------------------------

        -- Débito
        SELECT  CHM.IDCTACONTABIL               AS IDCTACONTABIL,
                CHM.IDPLANILHA                  AS IDPLANILHA,
                CH.NUMSEQUENCIA                 AS NUMSEQUENCIA,
                'D'                             AS TIPONATUREZALCTO,
                CHM.IDEMPRESA                   AS IDEMPRESA,
                2                               AS IDUSUARIO,
                'AVU'                           AS ORIGEMMOVIMENTO,
                CHM.DTMOVIMENTO                 AS DTMOVIMENTO,
                SUM(CHM.VALOR)                  AS VALLANCAMENTO,
                CHM.OBSGERAL                    AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'F'                             AS FLAGFLUXOEXECUTADO,
                'F'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.CHEQUES_MOVIMENTO           CHM,
                DBA.CHEQUES                     CH,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   CH.TIPOCHEQUE                   = 'E'                   AND
                CH.IDPLANILHA                   = CHM.IDPLANILHACHEQUE  AND
                CHM.IDCTACONTABIL               = CPC.IDCTACONTABIL     AND
                CHM.TIPOSITUACAO                = 'L'                   AND
                CHM.IDPLANILHA                  < 0                     AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   CHM.IDPLANILHA          = CM.IDPLANILHA AND
                                                        CHM.IDEMPRESA           = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'D')
                GROUP BY        CHM.IDPLANILHA,
                                CHM.IDEMPRESA,
                                CHM.DTMOVIMENTO,
                                CHM.OBSGERAL,
                                CPC.TIPONATUREZA,
                                CH.NUMSEQUENCIA,
                                CHM.IDCTACONTABIL

        UNION ALL

        -- Crédito
        SELECT  2110101                         AS IDCTACONTABIL, -- 2110101 - FORNECEDORES DE MERCADORIA
                CHM.IDPLANILHA                  AS IDPLANILHA,
                CH.NUMSEQUENCIA                 AS NUMSEQUENCIA,
                'C'                             AS TIPONATUREZALCTO,
                CHM.IDEMPRESA                   AS IDEMPRESA,
                2                               AS IDUSUARIO,
                'AVU'                           AS ORIGEMMOVIMENTO,
                CHM.DTMOVIMENTO                 AS DTMOVIMENTO,
                SUM(CHM.VALOR)                  AS VALLANCAMENTO,
                CHM.OBSGERAL                    AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'F'                             AS FLAGFLUXOEXECUTADO,
                'F'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.CHEQUES_MOVIMENTO           CHM,
                DBA.CHEQUES                     CH,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   CH.TIPOCHEQUE                   = 'E'                   AND
                2110101                         = CPC.IDCTACONTABIL     AND
                CHM.IDPLANILHA                  < 0                     AND
                CH.IDPLANILHA                   = CHM.IDPLANILHA        AND
                CHM.TIPOSITUACAO                = 'L'                   AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   CHM.IDPLANILHA          = CM.IDPLANILHA AND
                                                        CHM.IDEMPRESA           = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'C')
                GROUP BY        CHM.IDPLANILHA,
                                CHM.IDEMPRESA,
                                CHM.DTMOVIMENTO,
                                CHM.OBSGERAL,
                                CPC.TIPONATUREZA,
                                CH.NUMSEQUENCIA

UNION ALL


        -----------------------------
        -- Adiantamento (Fornecedores)
        -----------------------------
        -- Débito
        SELECT  AD.IDCTACONTABIL                AS IDCTACONTABIL,       -- Quando converter utilizar a conta 1120601 - ADIANTAMENTO A FORNECEDORES
                AD.IDPLANILHA                   AS IDPLANILHA,
                1                               AS NUMSEQUENCIA,
                'D'                             AS TIPONATUREZALCTO,
                AD.IDEMPRESA                    AS IDEMPRESA,
                2                               AS IDUSUARIO,
                AD.ORIGEMMOVIMENTO              AS ORIGEMMOVIMENTO,
                AD.DTMOVIMENTO                  AS DTMOVIMENTO,
                SUM(AD.VALADIANTAMENTO)         AS VALLANCAMENTO,
                AD.OBSADIANTAMENTO              AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'T'                             AS FLAGFLUXOEXECUTADO,
                'T'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.ADIANTAMENTO                AD,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   AD.IDCTACONTABIL                = CPC.IDCTACONTABIL     AND
                AD.IDPLANILHA                   < 0                     AND
                AD.ORIGEMMOVIMENTO              = 'AVU'                 AND
                AD.TIPOADIANTAMENTO             = 'F'                   AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   AD.IDPLANILHA           = CM.IDPLANILHA AND
                                                        AD.IDEMPRESA            = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'D')
                GROUP BY        AD.IDCTACONTABIL,
                                AD.IDPLANILHA,
                                AD.IDEMPRESA,
                                AD.ORIGEMMOVIMENTO,
                                AD.DTMOVIMENTO,
                                AD.OBSADIANTAMENTO,
                                CPC.TIPONATUREZA

        UNION ALL

        -- Crédito
        SELECT  2420301                         AS IDCTACONTABIL,       -- 2420301 | C - RESERVA DE LUCROS
                AD.IDPLANILHA                   AS IDPLANILHA,
                1                               AS NUMSEQUENCIA,
                'C'                             AS TIPONATUREZALCTO,
                AD.IDEMPRESA                    AS IDEMPRESA,
                2                               AS IDUSUARIO,
                AD.ORIGEMMOVIMENTO              AS ORIGEMMOVIMENTO,
                AD.DTMOVIMENTO                  AS DTMOVIMENTO,
                SUM(AD.VALADIANTAMENTO)         AS VALLANCAMENTO,
                AD.OBSADIANTAMENTO              AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'T'                             AS FLAGFLUXOEXECUTADO,
                'T'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.ADIANTAMENTO                AD,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   2420301                         = CPC.IDCTACONTABIL     AND
                AD.IDPLANILHA                   < 0                     AND
                AD.ORIGEMMOVIMENTO              = 'AVU'                 AND
                AD.TIPOADIANTAMENTO             = 'F'                   AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   AD.IDPLANILHA           = CM.IDPLANILHA AND
                                                        AD.IDEMPRESA            = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'C')
                GROUP BY
                                AD.IDPLANILHA,
                                AD.IDEMPRESA,
                                AD.ORIGEMMOVIMENTO,
                                AD.DTMOVIMENTO,
                                AD.OBSADIANTAMENTO,
                                CPC.TIPONATUREZA



        UNION ALL



        -----------------------------
        -- Adiantamento (Funcionários)
        -----------------------------
        -- Débito
        SELECT  AD.IDCTACONTABIL                AS IDCTACONTABIL,       -- Quando converter utilizar a conta 1120602 - ADIANTAMENTO A EMPREGADOS
                AD.IDPLANILHA                   AS IDPLANILHA,
                1                               AS NUMSEQUENCIA,
                'D'                             AS TIPONATUREZALCTO,
                AD.IDEMPRESA                    AS IDEMPRESA,
                2                               AS IDUSUARIO,
                AD.ORIGEMMOVIMENTO              AS ORIGEMMOVIMENTO,
                AD.DTMOVIMENTO                  AS DTMOVIMENTO,
                SUM(AD.VALADIANTAMENTO)         AS VALLANCAMENTO,
                AD.OBSADIANTAMENTO              AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'T'                             AS FLAGFLUXOEXECUTADO,
                'T'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.ADIANTAMENTO                AD,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   AD.IDCTACONTABIL                = CPC.IDCTACONTABIL     AND
                AD.IDPLANILHA                   < 0                     AND
                AD.ORIGEMMOVIMENTO              = 'AVU'                 AND
                AD.TIPOADIANTAMENTO             = 'U'                   AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   AD.IDPLANILHA           = CM.IDPLANILHA AND
                                                        AD.IDEMPRESA            = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'D')
                GROUP BY        AD.IDCTACONTABIL,
                                AD.IDPLANILHA,
                                AD.IDEMPRESA,
                                AD.ORIGEMMOVIMENTO,
                                AD.DTMOVIMENTO,
                                AD.OBSADIANTAMENTO,
                                CPC.TIPONATUREZA

        UNION ALL

        -- Crédito
        SELECT  2420301                         AS IDCTACONTABIL,       -- 2420301 | C - RESERVA DE LUCROS
                AD.IDPLANILHA                   AS IDPLANILHA,
                1                               AS NUMSEQUENCIA,
                'C'                             AS TIPONATUREZALCTO,
                AD.IDEMPRESA                    AS IDEMPRESA,
                2                               AS IDUSUARIO,
                AD.ORIGEMMOVIMENTO              AS ORIGEMMOVIMENTO,
                AD.DTMOVIMENTO                  AS DTMOVIMENTO,
                SUM(AD.VALADIANTAMENTO)         AS VALLANCAMENTO,
                AD.OBSADIANTAMENTO              AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'T'                             AS FLAGFLUXOEXECUTADO,
                'T'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.ADIANTAMENTO                AD,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   2420301                         = CPC.IDCTACONTABIL     AND
                AD.IDPLANILHA                   < 0                     AND
                AD.ORIGEMMOVIMENTO              = 'AVU'                 AND
                AD.TIPOADIANTAMENTO             = 'U'                   AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   AD.IDPLANILHA           = CM.IDPLANILHA AND
                                                        AD.IDEMPRESA            = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'C')
                GROUP BY
                                AD.IDPLANILHA,
                                AD.IDEMPRESA,
                                AD.ORIGEMMOVIMENTO,
                                AD.DTMOVIMENTO,
                                AD.OBSADIANTAMENTO,
                                CPC.TIPONATUREZA



        UNION ALL



        -----------------------------
        -- Adiantamento (Clientes)
        -----------------------------
        -- Débito
        SELECT  2420303                         AS IDCTACONTABIL,       -- 2420303 - RESERVA DE LUCROS A REALIZAR
                AD.IDPLANILHA                   AS IDPLANILHA,
                1                               AS NUMSEQUENCIA,
                'D'                             AS TIPONATUREZALCTO,
                AD.IDEMPRESA                    AS IDEMPRESA,
                2                               AS IDUSUARIO,
                AD.ORIGEMMOVIMENTO              AS ORIGEMMOVIMENTO,
                AD.DTMOVIMENTO                  AS DTMOVIMENTO,
                SUM(AD.VALADIANTAMENTO)         AS VALLANCAMENTO,
                AD.OBSADIANTAMENTO              AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'T'                             AS FLAGFLUXOEXECUTADO,
                'T'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.ADIANTAMENTO                AD,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   2420303                         = CPC.IDCTACONTABIL     AND
                AD.IDPLANILHA                   < 0                     AND
                AD.ORIGEMMOVIMENTO              = 'AVU'                 AND
                AD.TIPOADIANTAMENTO             = 'C'                   AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   AD.IDPLANILHA           = CM.IDPLANILHA AND
                                                        AD.IDEMPRESA            = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'D')
                GROUP BY
                                AD.IDPLANILHA,
                                AD.IDEMPRESA,
                                AD.ORIGEMMOVIMENTO,
                                AD.DTMOVIMENTO,
                                AD.OBSADIANTAMENTO,
                                CPC.TIPONATUREZA

        UNION ALL

        -- Crédito
        SELECT  AD.IDCTACONTABIL                AS IDCTACONTABIL,       -- Quando converter utilizar a conta 2110301 - ADIANTAMENTOS DE CLIENTES
                AD.IDPLANILHA                   AS IDPLANILHA,
                1                               AS NUMSEQUENCIA,
                'C'                             AS TIPONATUREZALCTO,
                AD.IDEMPRESA                    AS IDEMPRESA,
                2                               AS IDUSUARIO,
                AD.ORIGEMMOVIMENTO              AS ORIGEMMOVIMENTO,
                AD.DTMOVIMENTO                  AS DTMOVIMENTO,
                SUM(AD.VALADIANTAMENTO)         AS VALLANCAMENTO,
                AD.OBSADIANTAMENTO              AS COMPLEMENTO,
                CPC.TIPONATUREZA                AS TIPONATUREZACTA,
                'F'                             AS FLAGATUALIZAGEREN,
                TODAY()                         AS DTLANCAMENTO,
                'F'                             AS FLAGEXPORTADO,
                'T'                             AS FLAGFLUXOEXECUTADO,
                'T'                             AS FLAGSALDOPROCESSADO
        FROM    DBA.ADIANTAMENTO                AD,
                DBA.CONTABIL_PLANO_CONTAS       CPC
        WHERE   AD.IDCTACONTABIL                = CPC.IDCTACONTABIL     AND
                AD.IDPLANILHA                   < 0                     AND
                AD.ORIGEMMOVIMENTO              = 'AVU'                 AND
                AD.TIPOADIANTAMENTO             = 'C'                   AND
                NOT EXISTS                      (SELECT 1
                                                FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                WHERE   AD.IDPLANILHA           = CM.IDPLANILHA AND
                                                        AD.IDEMPRESA            = CM.IDEMPRESA AND
                                                        CM.TIPONATUREZALCTO     = 'C')
                GROUP BY        AD.IDCTACONTABIL,
                                AD.IDPLANILHA,
                                AD.IDEMPRESA,
                                AD.ORIGEMMOVIMENTO,
                                AD.DTMOVIMENTO,
                                AD.OBSADIANTAMENTO,
                                CPC.TIPONATUREZA


GO
COMMIT
GO





-- Falta fazer:

-------------------------------------
-- Cheques Recebidos | Reapresentados
-------------------------------------
-------------------------------------
-- Cheques Recebidos | Em Custódia
-------------------------------------
-------------------------------------
-- Cheques Recebidos | Transferido
-------------------------------------

-------------------------
-- Cheques Pago a Terceiros
-------------------------
-------------------------
-- Cheques Roubados
-------------------------


-------------
-- Validações
------------------------------------------------------------------------------------------------------------------------------------
-- Verificar se existe planilha duplicada
SELECT IDPLANILHA
FROM    (
        SELECT  IDPLANILHA      FROM    DBA.CONTAS_RECEBER      CR      WHERE CR.IDPLANILHA  < 0 AND CR.SERIENOTA       = 'AVU'
        UNION ALL
        SELECT  IDPLANILHA      FROM    DBA.CONTAS_PAGAR        CP      WHERE CP.IDPLANILHA  < 0 AND CP.SERIENOTA       = 'AVU'
        UNION ALL
        SELECT  IDPLANILHA      FROM    DBA.CHEQUES_MOVIMENTO   CHM     WHERE CHM.IDPLANILHA < 0
        UNION ALL
        SELECT  IDPLANILHA      FROM    DBA.ADIANTAMENTO        AD      WHERE AD.IDPLANILHA  < 0 AND AD.ORIGEMMOVIMENTO = 'AVU'
        ) AS TMP
        GROUP BY IDPLANILHA
        HAVING COUNT(*)>1

-- Precisa ser inserido na CONTABIL_MOVIMENTO
SELECT
        (
            (
            SELECT  COUNT(*)
            FROM    DBA.CONTAS_RECEBER              CR
            WHERE   CR.IDPLANILHA                   < 0     AND
                    CR.SERIENOTA                    = 'AVU' AND
                    NOT EXISTS                      (SELECT 1
                                                    FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                    WHERE   CR.IDPLANILHA           = CM.IDPLANILHA AND
                                                            CR.IDEMPRESA            = CM.IDEMPRESA AND
                                                            CM.TIPONATUREZALCTO     = 'D')
            )
        +
            (
            SELECT  COUNT(*)
            FROM    DBA.CONTAS_RECEBER              CR
            WHERE   CR.IDPLANILHA                   < 0     AND
                    CR.SERIENOTA                    = 'AVU' AND
                    NOT EXISTS                      (SELECT 1
                                                    FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                    WHERE   CR.IDPLANILHA           = CM.IDPLANILHA AND
                                                            CR.IDEMPRESA            = CM.IDEMPRESA AND
                                                            CM.TIPONATUREZALCTO     = 'C')
            )
        +
            (
            SELECT  COUNT(*)
            FROM    DBA.CONTAS_PAGAR                CP
            WHERE   CP.IDPLANILHA                   < 0     AND
                    CP.SERIENOTA                    = 'AVU' AND
                    NOT EXISTS                      (SELECT 1
                                                    FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                    WHERE   CP.IDPLANILHA           = CM.IDPLANILHA AND
                                                            CP.IDEMPRESA            = CM.IDEMPRESA AND
                                                            CM.TIPONATUREZALCTO     = 'D')
            )
        +
            (
            SELECT  COUNT(*)
            FROM    DBA.CONTAS_PAGAR                CP
            WHERE   CP.IDPLANILHA                   < 0     AND
                    CP.SERIENOTA                    = 'AVU' AND
                    NOT EXISTS                      (SELECT 1
                                                    FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                    WHERE   CP.IDPLANILHA           = CM.IDPLANILHA AND
                                                            CP.IDEMPRESA            = CM.IDEMPRESA AND
                                                            CM.TIPONATUREZALCTO     = 'C')
            )
        +
            (
            SELECT  COUNT(*)
            FROM    DBA.CHEQUES_MOVIMENTO           CHM
            WHERE   CHM.IDPLANILHA                  < 0                     AND
                    NOT EXISTS                      (SELECT 1
                                                    FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                    WHERE   CHM.IDPLANILHA          = CM.IDPLANILHA AND
                                                            CHM.IDEMPRESA           = CM.IDEMPRESA AND
                                                            CM.TIPONATUREZALCTO     = 'D')
            )
        +
            (
            SELECT  COUNT(*)
            FROM    DBA.CHEQUES_MOVIMENTO           CHM
            WHERE   CHM.IDPLANILHA                  < 0                     AND
                    NOT EXISTS                      (SELECT 1
                                                    FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                    WHERE   CHM.IDPLANILHA          = CM.IDPLANILHA AND
                                                            CHM.IDEMPRESA           = CM.IDEMPRESA AND
                                                            CM.TIPONATUREZALCTO     = 'C')
            )
        +
            (
            SELECT  COUNT(*)
            FROM    DBA.ADIANTAMENTO                AD
            WHERE   AD.IDPLANILHA                   < 0                     AND
                    NOT EXISTS                      (SELECT 1
                                                    FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                    WHERE   AD.IDPLANILHA           = CM.IDPLANILHA AND
                                                            AD.IDEMPRESA            = CM.IDEMPRESA AND
                                                            CM.TIPONATUREZALCTO     = 'C')
            )
        +
            (
            SELECT  COUNT(*)
            FROM    DBA.ADIANTAMENTO                AD
            WHERE   AD.IDPLANILHA                   < 0                     AND
                    NOT EXISTS                      (SELECT 1
                                                    FROM    DBA.CONTABIL_MOVIMENTO  CM
                                                    WHERE   AD.IDPLANILHA           = CM.IDPLANILHA AND
                                                            AD.IDEMPRESA            = CM.IDEMPRESA AND
                                                            CM.TIPONATUREZALCTO     = 'D')
            )
        ) TMP
FROM    DUMMY

-- Tudo que esta na contábil de acordo com os titulos e cheques convertidos
SELECT  COUNT(*)
FROM    DBA.CONTABIL_MOVIMENTO  CM
WHERE   EXISTS                  (SELECT 1
                                FROM    DBA.CONTAS_RECEBER      CR
                                WHERE   CR.IDPLANILHA           = CM.IDPLANILHA AND
                                        CR.IDEMPRESA            = CM.IDEMPRESA AND
                                        CR.IDPLANILHA           < 0 AND
                                        CR.SERIENOTA            = 'AVU') OR
        EXISTS                  (SELECT 1
                                FROM    DBA.CONTAS_PAGAR        CP
                                WHERE   CP.IDPLANILHA           = CM.IDPLANILHA AND
                                        CP.IDEMPRESA            = CM.IDEMPRESA AND
                                        CP.IDPLANILHA           < 0 AND
                                        CP.SERIENOTA            = 'AVU') OR
        EXISTS                  (SELECT 1
                                FROM    DBA.CHEQUES_MOVIMENTO   CHM
                                WHERE   CHM.IDPLANILHA          = CM.IDPLANILHA AND
                                        CHM.IDEMPRESA           = CM.IDEMPRESA AND
                                        CHM.IDPLANILHA          < 0) OR
        EXISTS                  (SELECT 1
                                FROM    DBA.ADIANTAMENTO        AD
                                WHERE   AD.IDPLANILHA           = CM.IDPLANILHA AND
                                        AD.IDEMPRESA            = CM.IDEMPRESA AND
                                        AD.IDPLANILHA           < 0 AND
                                        AD.ORIGEMMOVIMENTO      = 'AVU')


------------------------------------------------------------------------------------------------------------------------------------
-- Para quando necessáro inserir os dados no ASA e exportar para o DB2
------------------------------------------------------------------------------------------------------------------------------------
-- Export
SELECT idctacontabil, idplanilha, numsequencia, tiponaturezalcto, idempresa, idempresadestino, idhistorico, idusuario, origemmovimento, dtmovimento, vallancamento, tiponaturezacta, tipoabamovimento, dtmovimentogeren, flagatualizageren, dtlancamento, dthoraultimaalteracao, flagexportado, idexportacaomicrosiga, flagfluxoexecutado, flagsaldoprocessado, FLAGPISCOFINSPROCESSADO, Tipolancamento from DBA.CONTABIL_MOVIMENTO; OUTPUT TO C:\Temp\contabil_movimento.TXT
-- Load
DB2 LOAD CLIENT FROM C:\Temp\contabil_movimento.TXT OF DEL MODIFIED BY CHARDEL'''' INSERT INTO contabil_movimento ( idctacontabil, idplanilha, numsequencia, tiponaturezalcto, idempresa, idempresadestino, idhistorico, idusuario, origemmovimento, dtmovimento, vallancamento, tiponaturezacta, tipoabamovimento, dtmovimentogeren, flagatualizageren, dtlancamento, dthoraultimaalteracao, flagexportado, idexportacaomicrosiga, flagfluxoexecutado, flagsaldoprocessado, FLAGPISCOFINSPROCESSADO, Tipolancamento) COPY YES TO C:\Temp\
-- Integridade
DB2 SET INTEGRITY FOR DBA.contabil_movimento STAGING, GENERATED COLUMN, FOREIGN KEY, CHECK, MATERIALIZED QUERY IMMEDIATE UNCHECKED


------------------------------------------------------------------------------------------------------------------------------------
-- Para quando necessário criar uma tabela temporária, inserir os dados nela, exportar e carregar via load:
------------------------------------------------------------------------------------------------------------------------------------
-- Export
db2 "export to contabil_movimento.ixf of ixf select * from conv.contabil_movimento"
-- Load
db2 "load client from contabil_movimento.ixf of ixf insert into dba.contabil_movimento copy yes to /db2/backup/LOAD/"
-- Integridade
db2 "SET INTEGRITY FOR DBA.contabil_movimento STAGING, GENERATED COLUMN, FOREIGN KEY, CHECK, MATERIALIZED QUERY IMMEDIATE UNCHECKED"


/*

 * Histórico de alterações
        -            - 2.0      | Automatizado para pegar as contas contábeis e natureza do plano de contas e algumas outras informações voláteis de sua origem. Incluido contábil dos cartões e cheques.
        -            - 2.1      | Incluído cheques do tipo "Emitido" de situação "Lançado";
        -            - 2.2      | Incluído cheques do tipo "Recebido" de situação "Lançado", "Liquidado" e "Devolvido";
        -            - 2.3      | Incluído validação do tipo de natureza do lançamento em todo o script para evitar que seja inserido apenas lançamento de Débido e não de Crédito ou vice-versa.
        -            - 2.4      | Incluído insert e validações considerando conversão de Adiantamentos (Cliente, fornecedor e funcionário)
        - 25/11/2019 - 2.4      | Última alteração;
        - 02/12/2019 - 2.5      | Ajuste no rodapé, versionamento e inserção da opção para exportar a tabela diretamente do DB2 em IXF e realizar LOAD no banco;
        - 02/09/2020 - 2.6      | Ajuste na seção que valida "Tudo que esta na contábil de acordo com os titulos e cheques convertidos" adicionando o IDEMPRESA na comparação. Adição de novo item nas "Melhorias e correções para aplicar".

 * Melhorias e correções para aplicar
        - Transformar este insert em uma função que não de problema de cair a conexão no DB2;
        - Quando transformar em SP antes de executar os inserts fazer as validações de planilha duplicada, conta contabil não informada ou inexistente no cadastro de contas contábeis;
        - Concluir os inserts das demais situações que um cheque pode ter.

*/
