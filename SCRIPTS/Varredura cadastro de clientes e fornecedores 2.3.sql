/*       Este script tem por objetivo, retornar uma s�rie de valida��es sobre a consist�ncia dos cadastros de Clientes/Fornecedores,
        para analise e/ou posterior ajuste por parte do cliente ou via convers�o. (Considera ativos e inativos (Exceto algumas valida��es
        que est�o explicitas se considera ativos ou inativos))               */

WITH CLIENTE AS (

                SELECT
                    COUNT(PF.IDCLIFOR) AS TOTAL,
                    'Estado civil como solteiro, divorciado ou viuvo porem com nome no c�njuge;' AS DESCRICAO,
                    'SELECT C.IDCLIFOR, CF.NOME, CF.NOMEFANTASIA, TIPOESTADOCIVIL,NOMECONJUGE FROM CLIENTE_FORNECEDOR CF, PESSOA_FISICA PF JOIN CONJUGE C ON (PF.IDCLIFOR = C.IDCLIFOR) WHERE PF.IDCLIFOR = CF.IDCLIFOR AND PF.TIPOESTADOCIVIL IS NOT NULL AND PF.TIPOESTADOCIVIL IN(''S'', ''D'', ''V'') AND (C.NOMECONJUGE IS NOT NULL OR TRIM(C.NOMECONJUGE) <> '''')' AS QUERY
                FROM
                    PESSOA_FISICA PF JOIN CONJUGE C ON
                        (PF.IDCLIFOR = C.IDCLIFOR)
                WHERE
                    PF.TIPOESTADOCIVIL IS NOT NULL AND
                    PF.TIPOESTADOCIVIL IN('S', 'D', 'V') AND
                    (C.NOMECONJUGE IS NOT NULL OR TRIM(C.NOMECONJUGE) <> '')

                UNION ALL

                SELECT
                    COUNT(*) AS TOTAL,
                    'Campo obrigat�rio n�o preenchido;' AS DESCRICAO,
                    'SELECT IDCLIFOR, NOME, NOMEFANTASIA, CNPJCPF, IDCEP, ENDERECO, BAIRRO, NUMERO, INSCRESTADUAL FROM    CLIENTE_FORNECEDOR WHERE   (TRIM(NOME) = '''' OR NOME IS NULL) OR (TRIM(CNPJCPF) = '''' OR CNPJCPF IS NULL) OR (TRIM(IDCEP) = '''' OR IDCEP IS NULL) OR (TRIM(ENDERECO) = '''' OR ENDERECO IS NULL) OR (TRIM(BAIRRO) = '''' OR BAIRRO IS NULL) OR (TRIM(NUMERO) = '''' OR NUMERO IS NULL)' AS QUERY
                FROM
                        CLIENTE_FORNECEDOR
                WHERE
                        (TRIM(NOME) = '' OR NOME IS NULL) OR
                        (TRIM(CNPJCPF) = '' OR CNPJCPF IS NULL) OR
                        (TRIM(IDCEP) = '' OR IDCEP IS NULL) OR
                        (TRIM(ENDERECO) = '' OR ENDERECO IS NULL) OR
                        (TRIM(BAIRRO) = '' OR BAIRRO IS NULL) OR
                        (TRIM(NUMERO) = '' OR NUMERO IS NULL)

                UNION ALL

                SELECT
                    COUNT(CF.IDCLIFOR) AS TOTAL,
                    'Nomes em branco ou nulo;' AS DESCRICAO,
                    'SELECT IDCLIFOR, NOME, NOMEFANTASIA FROM CLIENTE_FORNECEDOR WHERE NOME IS NULL OR TRIM(NOME)=''''' AS QUERY
                FROM
                    CLIENTE_FORNECEDOR AS CF
                WHERE
                    CF.NOME IS NULL OR
                    TRIM(CF.NOME) = ''

                UNION ALL

                SELECT
                    COUNT(CF.IDCLIFOR) AS TOTAL,
                    'CNPJ/CPF em branco ou nulo;' AS DESCRICAO,
                    'SELECT IDCLIFOR, NOME, NOMEFANTASIA, CNPJCPF FROM CLIENTE_FORNECEDOR WHERE CNPJCPF IS NULL OR TRIM(CNPJCPF) = ''''' AS QUERY
                FROM
                    CLIENTE_FORNECEDOR AS CF
                WHERE
                    CF.CNPJCPF IS NULL OR
                    TRIM(CF.CNPJCPF) = ''

                UNION ALL

                SELECT
                    COUNT(CF.IDCLIFOR) AS TOTAL,
                    'E-mail ou e-mail financeiro sem @;' AS DESCRICAO,
                    'SELECT CF.IDCLIFOR, CF.NOME, CF.EMAIL, CF.EMAILFINANCEIRO FROM CLIENTE_FORNECEDOR CF WHERE (CF.EMAIL IS NOT NULL AND TRIM(CF.EMAIL) <> '''' AND CF.EMAIL NOT LIKE (''%@%'')) OR (CF.EMAILFINANCEIRO IS NOT NULL AND TRIM(CF.EMAILFINANCEIRO) <> '''' AND CF.EMAILFINANCEIRO NOT LIKE (''%@%''))' AS QUERY
                FROM
                    CLIENTE_FORNECEDOR AS CF
                WHERE
                    (CF.EMAIL IS NOT NULL AND TRIM(CF.EMAIL) <> '' AND CF.EMAIL NOT LIKE ('%@%')) OR
                    (CF.EMAILFINANCEIRO IS NOT NULL AND TRIM(CF.EMAILFINANCEIRO) <> '' AND CF.EMAILFINANCEIRO NOT LIKE ('%@%'))

                UNION ALL

                SELECT
                    COUNT(CF.IDCLIFOR) AS TOTAL,
                    'Cliente pessoa fisica com ramo de atividade diferente de 4 (Consumidor final N�o Contribuinte);' AS DESCRICAO,
                    'SELECT IDCLIFOR, NOME, NOMEFANTASIA, IDATIVIDADE FROM CLIENTE_FORNECEDOR WHERE TIPOCADASTRO = ''C'' AND TIPOFISICAJURIDICA = ''F'' AND IDATIVIDADE <> 4' AS QUERY
                FROM
                    CLIENTE_FORNECEDOR AS CF
                WHERE
                    CF.TIPOCADASTRO = 'C' AND
                    CF.TIPOFISICAJURIDICA = 'F' AND
                    CF.IDATIVIDADE <> 4

                UNION ALL

                SELECT
                    COUNT(PF.IDCLIFOR) AS TOTAL,
                    'Estado civil como casado ou amasiado porem sem nome no c�njuge;' AS DESCRICAO,
                    'SELECT C.IDCLIFOR, CF.NOME, CF.NOMEFANTASIA, TIPOESTADOCIVIL,NOMECONJUGE FROM CLIENTE_FORNECEDOR CF, PESSOA_FISICA PF JOIN CONJUGE C ON (PF.IDCLIFOR = C.IDCLIFOR) WHERE PF.IDCLIFOR = CF.IDCLIFOR AND PF.TIPOESTADOCIVIL IS NOT NULL AND PF.TIPOESTADOCIVIL IN(''C'', ''A'') AND (C.NOMECONJUGE IS NULL OR TRIM(C.NOMECONJUGE) = '''')' AS QUERY
                FROM
                    PESSOA_FISICA PF JOIN CONJUGE C ON
                        (PF.IDCLIFOR = C.IDCLIFOR)
                WHERE
                    PF.TIPOESTADOCIVIL IS NOT NULL AND
                    PF.TIPOESTADOCIVIL IN('C', 'A') AND
                    (C.NOMECONJUGE IS NULL OR TRIM(C.NOMECONJUGE) = '')

                UNION ALL

                SELECT
                    COUNT(CF.IDCLIFOR) AS TOTAL,
                    'Alguma informa��o do endere�o faltante;' AS DESCRICAO,
                    'SELECT IDCLIFOR, NOME, NOMEFANTASIA, BAIRRO,IDCEP,COMPLEMENTO,ENDERECO,IDCIDADE,NUMERO,UFCLIFOR FROM    CLIENTE_FORNECEDOR WHERE   (BAIRRO IS NULL OR TRIM(BAIRRO) = '''') OR (IDCEP IS NULL OR TRIM(IDCEP) = '''') OR /* (COMPLEMENTO  IS NULL OR TRIM(COMPLEMENTO) = '''') OR */ (ENDERECO IS NULL OR TRIM(ENDERECO) = '''') OR (IDCIDADE  IS NULL OR TRIM(IDCIDADE) = '''') OR (NUMERO IS NULL OR TRIM(NUMERO) = '''') OR (UFCLIFOR IS NULL OR TRIM(UFCLIFOR) = '''')' AS QUERY
                FROM
                    CLIENTE_FORNECEDOR CF
                WHERE
                    (BAIRRO IS NULL OR TRIM(BAIRRO) = '') OR
                    (IDCEP IS NULL OR TRIM(IDCEP) = '') OR
                 /* (COMPLEMENTO  IS NULL OR TRIM(COMPLEMENTO) = '') OR */
                    (ENDERECO IS NULL OR TRIM(ENDERECO) = '') OR
                    (IDCIDADE  IS NULL OR TRIM(IDCIDADE) = '') OR
                    (NUMERO IS NULL OR TRIM(NUMERO) = '') OR
                    (UFCLIFOR IS NULL OR TRIM(UFCLIFOR) = '')


                UNION ALL

                SELECT
                    COUNT(CF.IDCLIFOR) AS TOTAL,
                    'Alguma informa��o do endere�o cobran�a faltante;' AS DESCRICAO,
                    'SELECT IDCLIFOR, NOME, NOMEFANTASIA, BAIRROCOBRANCA,CEPCOBRANCA,COMPLEMENTOCOBRANCA,ENDERCOBRANCA,IDCIDADECOBRANCA,NUMEROCOBRANCA,UFCOBRANCA FROM    CLIENTE_FORNECEDOR WHERE   (BAIRROCOBRANCA IS NULL OR TRIM(BAIRROCOBRANCA) = '''') OR (CEPCOBRANCA IS NULL OR TRIM(CEPCOBRANCA) = '''') OR /* (COMPLEMENTOCOBRANCA  IS NULL OR TRIM(COMPLEMENTOCOBRANCA) = '''') OR */ (ENDERCOBRANCA IS NULL OR TRIM(ENDERCOBRANCA) = '''') OR (IDCIDADECOBRANCA  IS NULL OR TRIM(IDCIDADECOBRANCA) = '''') OR (NUMEROCOBRANCA IS NULL OR TRIM(NUMEROCOBRANCA) = '''') OR (UFCOBRANCA IS NULL OR TRIM(UFCOBRANCA) = '''')' AS QUERY
                FROM
                    CLIENTE_FORNECEDOR CF
                WHERE
                    (BAIRROCOBRANCA IS NULL OR TRIM(BAIRROCOBRANCA) = '') OR
                    (CEPCOBRANCA IS NULL OR TRIM(CEPCOBRANCA) = '') OR
                  /*  (COMPLEMENTOCOBRANCA  IS NULL OR TRIM(COMPLEMENTOCOBRANCA) = '') OR */
                    (ENDERCOBRANCA IS NULL OR TRIM(ENDERCOBRANCA) = '') OR
                    (IDCIDADECOBRANCA  IS NULL OR TRIM(IDCIDADECOBRANCA) = '') OR
                    (NUMEROCOBRANCA IS NULL OR TRIM(NUMEROCOBRANCA) = '') OR
                    (UFCOBRANCA IS NULL OR TRIM(UFCOBRANCA) = '')

             UNION ALL

            SELECT
                COUNT(CF.IDCLIFOR) AS TOTAL,
                'Cadastro sem seu fidelizado;' AS DESCRICAO,
                'SELECT CF.IDCLIFOR, CF.NOME, CF.NOMEFANTASIA FROM CLIENTE_FORNECEDOR CF WHERE CF.IDCLIFOR NOT IN (SELECT CA.IDCLIFOR FROM CLIENTE_AUTORIZADOS CA)' AS QUERY
            FROM
                CLIENTE_FORNECEDOR CF
            WHERE
                IDCLIFOR NOT IN (SELECT
                                    IDCLIFOR
                                FROM
                                    CLIENTE_AUTORIZADOS
                                )
            UNION ALL

            SELECT
                COUNT(CF.IDCLIFOR) AS TOTAL,
                'Fornecedores com ramo de atividade 4 (Consumidor final N�o Contribuinte);' AS DESCRICAO,
                'SELECT IDCLIFOR, NOME, NOMEFANTASIA, IDATIVIDADE FROM CLIENTE_FORNECEDOR WHERE TIPOCADASTRO = ''F'' AND IDATIVIDADE = 4' AS QUERY
            FROM
                CLIENTE_FORNECEDOR AS CF
            WHERE
                CF.TIPOCADASTRO = 'F' AND
                CF.IDATIVIDADE = 4

            UNION ALL

            SELECT
                COUNT(CF.IDCLIFOR) AS TOTAL,
                'Pessoas jur�dicas com CNPJ/CPF menor que 14 d�gitos;' AS DESCRICAO,
                'SELECT CF.IDCLIFOR, CF.NOME, CF.NOMEFANTASIA, LENGTH(CF.CNPJCPF) AS TAMANHO, CF.CNPJCPF FROM CLIENTE_FORNECEDOR CF WHERE TIPOFISICAJURIDICA = ''J'' AND LENGTH(CF.CNPJCPF) < 14' AS QUERY
            FROM
                CLIENTE_FORNECEDOR AS CF
            WHERE
                CF.TIPOFISICAJURIDICA = 'J' AND
                LENGTH(CF.CNPJCPF) < 14

            UNION ALL

            SELECT
                COUNT(CF.IDCLIFOR)      AS TOTAL,
                'Pessoas f�sicas com CNPJ/CPF menor que 11 d�gitos;' AS DESCRICAO,
                'SELECT CF.IDCLIFOR, CF.NOME, CF.NOMEFANTASIA, LENGTH(CF.CNPJCPF) AS TAMANHO, CF.CNPJCPF FROM CLIENTE_FORNECEDOR CF WHERE TIPOFISICAJURIDICA = ''F'' AND LENGTH(CF.CNPJCPF) < 11' AS QUERY
            FROM
                CLIENTE_FORNECEDOR      AS CF
            WHERE
                CF.TIPOFISICAJURIDICA   = 'F' AND
                LENGTH(CF.CNPJCPF)      < 11

            UNION ALL

            SELECT
                COUNT(CF.IDCLIFOR) AS TOTAL,
                'Pessoas f�sicas com CNPJ/CPF maior que 11 d�gitos;' AS DESCRICAO,
                'SELECT CF.IDCLIFOR, CF.NOME, CF.NOMEFANTASIA, LENGTH(CF.CNPJCPF) AS TAMANHO, CF.CNPJCPF FROM CLIENTE_FORNECEDOR CF WHERE TIPOFISICAJURIDICA = ''F'' AND LENGTH(CF.CNPJCPF) > 11' AS QUERY
            FROM
                CLIENTE_FORNECEDOR AS CF
            WHERE
                CF.TIPOFISICAJURIDICA = 'F' AND
                LENGTH(CF.CNPJCPF) > 11

            UNION ALL

            SELECT
                COUNT(CF.IDCLIFOR) AS TOTAL,
                'Telefones menores que 10 d�gitos;' AS DESCRICAO,
                'SELECT CF.IDCLIFOR,CF.NOME, CF.NOMEFANTASIA,FONE1,FONE2,FONECELULAR,FONEFAX FROM    CLIENTE_FORNECEDOR CF WHERE   (LENGTH(TRIM(FONE1)) < 10 AND LENGTH(TRIM(FONE1)) > 0) OR (LENGTH(TRIM(FONE2)) < 10 AND LENGTH(TRIM(FONE2)) > 0) OR (LENGTH(TRIM(FONECELULAR)) < 10 AND LENGTH(TRIM(FONECELULAR)) > 0) OR (LENGTH(TRIM(FONEFAX)) < 10 AND LENGTH(TRIM(FONEFAX)) > 0)' AS QUERY
            FROM
                CLIENTE_FORNECEDOR AS CF
            WHERE
                (LENGTH(TRIM(FONE1)) < 10 AND LENGTH(TRIM(FONE1)) > 0)
                OR (LENGTH(TRIM(FONE2)) < 10 AND LENGTH(TRIM(FONE2)) > 0)
                OR (LENGTH(TRIM(FONECELULAR)) < 10 AND LENGTH(TRIM(FONECELULAR)) > 0)
                OR (LENGTH(TRIM(FONEFAX)) < 10 AND LENGTH(TRIM(FONEFAX)) > 0)

            UNION ALL

            SELECT
                COUNT(*) AS TOTAL,
                'Locais de Entrega cujo endere�o � igual ao endere�o de Localiza��o (Cep, endere�o, n�mero, bairro, complemento e inscri��o);' AS DESCRICAO,
                'SELECT  CF.IDCLIFOR,        CF.NOME,        CF.IDCEP                        CAD_CEP,        LE.CEPENTREGA                   ENT_CEP,        CF.ENDERECO                     CAD_ENDERECO,        LE.ENDERECOENTREGA              ENT_ENDERECO,        CF.NUMERO                       CAD_NUMERO,        LE.NUMERO                       ENT_NUMERO,        CF.BAIRRO                       CAD_BAIRRO,        LE.BAIRROENTREGA                ENT_BAIRRO,        CF.COMPLEMENTO                  CAD_COMPLEMENTO,        LE.COMPLEMENTO                  ENT_COMPLEMENTO,        CF.INSCRESTADUAL                CAD_INSCRICAO,        LE.INSCRESTAENT                 ENT_INSCRICAO FROM    DBA.CLIENTE_FORNECEDOR          CF,         DBA.LOCAL_ENTREGA               LE WHERE   CF.IDCLIFOR                     = LE.IDCLIFOR                           AND        CF.IDCEP                        = LE.CEPENTREGA                         AND        COALESCE(CF.ENDERECO      , '''') = COALESCE(LE.ENDERECOENTREGA   , '''')   AND        COALESCE(LE.NUMERO        , '''') = COALESCE(LE.NUMERO            , '''')   AND        COALESCE(CF.BAIRRO        , '''') = COALESCE(LE.BAIRROENTREGA     , '''')   AND        COALESCE(CF.COMPLEMENTO   , '''') = COALESCE(LE.COMPLEMENTO       , '''')   AND        COALESCE(CF.INSCRESTADUAL , '''') = COALESCE(LE.INSCRESTAENT      , '''')        ORDER BY CF.IDCLIFOR' AS QUERY
            FROM    DBA.CLIENTE_FORNECEDOR          CF,
                    DBA.LOCAL_ENTREGA               LE
            WHERE   CF.IDCLIFOR                     = LE.IDCLIFOR                           AND
                    CF.IDCEP                        = LE.CEPENTREGA                         AND
                    COALESCE(CF.ENDERECO      , '') = COALESCE(LE.ENDERECOENTREGA   , '')   AND
                    COALESCE(LE.NUMERO        , '') = COALESCE(LE.NUMERO            , '')   AND
                    COALESCE(CF.BAIRRO        , '') = COALESCE(LE.BAIRROENTREGA     , '')   AND
                    COALESCE(CF.COMPLEMENTO   , '') = COALESCE(LE.COMPLEMENTO       , '')   AND
                    COALESCE(CF.INSCRESTADUAL , '') = COALESCE(LE.INSCRESTAENT      , '')

            UNION ALL

            SELECT
                COUNT(*) AS TOTAL,
                'Pessoas duplicadas, ou seja, mais de uma pessoa com mesmo CPF/CNPJ (Apenas ativos);' AS DESCRICAO,
                'SELECT  CF2.IDCLIFOR,        CF2.NOME,        CASE CF2.TIPOCADASTRO         WHEN ''C'' THEN ''Cliente''         WHEN ''A'' THEN ''Cliente/Fornecedor''         WHEN ''U'' THEN ''Colaborador''          WHEN ''F'' THEN ''Fornecedor''          WHEN ''M'' THEN ''Motorista''          WHEN ''O'' THEN ''Produtivo''          WHEN ''P'' THEN ''Prospect''          WHEN ''R'' THEN ''Revenda/Subvendedor''          WHEN ''T'' THEN ''Transportador''          WHEN ''V'' THEN ''Vendedor/Canal''          ELSE ''''         END TIPOCADASTRO,         CF2.CNPJCPF,         (       SELECT COUNT(*)                 FROM    DBA.CONTAS_RECEBER      CR                 WHERE   CR.IDCLIFOR             = CF2.IDCLIFOR         ) AS CONTAS_RECEBER,         (       SELECT COUNT(*)                 FROM    DBA.CONTAS_RECEBER      CRP                 WHERE   CRP.IDCLIFOR            = CF2.IDCLIFOR AND                         CRP.FLAGBAIXADA         = ''F''         ) AS CONTAS_RECEBER_PENDENTES,         (       SELECT COUNT(*)                 FROM    DBA.CONTAS_PAGAR        CP                 WHERE   CP.IDCLIFOR             = CF2.IDCLIFOR         ) AS CONTAS_PAGAR,         (       SELECT COUNT(*)                 FROM    DBA.CONTAS_PAGAR        CPP                 WHERE   CPP.IDCLIFOR            = CF2.IDCLIFOR AND                         CPP.FLAGBAIXADA         = ''F''         ) AS CONTAS_PAGAR_PENDENTES,         (       SELECT COUNT(*)                 FROM    DBA.PEDIDO_COMPRA       PC                 WHERE   PC.IDCLIFOR             = CF2.IDCLIFOR         ) AS PEDIDO_COMPRA,         (       SELECT COUNT(*)                 FROM    DBA.ORCAMENTO           O                 WHERE   O.IDCLIFOR              = CF2.IDCLIFOR         ) AS ORCAMENTO_PEDIDO_VENDA FROM    DBA.CLIENTE_FORNECEDOR  CF2 WHERE   CF2.FLAGINATIVO = ''F'' AND CF2.CNPJCPF             IN(                                     SELECT  CF.CNPJCPF                                     FROM    DBA.CLIENTE_FORNECEDOR  CF                                     WHERE   CF.FLAGINATIVO = ''F'' AND CF.CNPJCPF              IS NOT NULL AND                                             LTRIM(RTRIM(CF.CNPJCPF)) <> ''''                                             GROUP BY CNPJCPF HAVING COUNT(*)>1                                 )         ORDER BY CF2.CNPJCPF' AS QUERY
            FROM
                CLIENTE_FORNECEDOR      AS CF2
            WHERE
                CF2.FLAGINATIVO         = 'F' AND
                CF2.CNPJCPF             IN(
                                                SELECT  CF.CNPJCPF
                                                FROM    DBA.CLIENTE_FORNECEDOR  CF
                                                WHERE   CF.FLAGINATIVO         = 'F' AND
                                                        CF.CNPJCPF              IS NOT NULL AND
                                                        LTRIM(RTRIM(CF.CNPJCPF)) <> ''
                                                        GROUP BY CNPJCPF HAVING COUNT(*)>1
                                            )

            UNION ALL

            SELECT
                COUNT(*) AS TOTAL,
                'Pessoas inativas com financeiro em aberto;' AS DESCRICAO,
                'SELECT  CF2.IDCLIFOR,         CF2.NOME,         CASE CF2.TIPOCADASTRO          WHEN ''C'' THEN ''Cliente''          WHEN ''A'' THEN ''Cliente/Fornecedor''          WHEN ''U'' THEN ''Colaborador''          WHEN ''F'' THEN ''Fornecedor''          WHEN ''M'' THEN ''Motorista''          WHEN ''O'' THEN ''Produtivo''          WHEN ''P'' THEN ''Prospect''          WHEN ''R'' THEN ''Revenda/Subvendedor''          WHEN ''T'' THEN ''Transportador''          WHEN ''V'' THEN ''Vendedor/Canal''          ELSE ''''         END TIPOCADASTRO,         CF2.CNPJCPF,         (       SELECT  COUNT(*)                 FROM    DBA.CONTAS_RECEBER      CRP                 WHERE   CRP.IDCLIFOR            = CF2.IDCLIFOR AND                         CRP.FLAGBAIXADA         = ''F''         ) AS CONTAS_RECEBER_PENDENTES,         (       SELECT  COUNT(*)                 FROM    DBA.CONTAS_PAGAR        CPP                 WHERE   CPP.IDCLIFOR            = CF2.IDCLIFOR AND                         CPP.FLAGBAIXADA         = ''F''         ) AS CONTAS_PAGAR_PENDENTES FROM    DBA.CLIENTE_FORNECEDOR                  CF2 WHERE   CF2.FLAGINATIVO                         = ''T'' AND         (         CF2.IDCLIFOR                            IN(                                                         SELECT  A.IDCLIFOR                                                         FROM    DBA.CONTAS_PAGAR        A                                                         WHERE   A.FLAGBAIXADA           = ''F''                                                 )         OR         CF2.IDCLIFOR                            IN(                                                         SELECT  B.IDCLIFOR                                                         FROM    DBA.CONTAS_RECEBER      B                                                         WHERE   B.FLAGBAIXADA           = ''F''                                                 )         ) ' AS QUERY
            FROM
                CLIENTE_FORNECEDOR      AS CF2
            WHERE
                 CF2.FLAGINATIVO                         = 'T' AND
                (
                CF2.IDCLIFOR                            IN(
                                                                SELECT  A.IDCLIFOR
                                                                FROM    DBA.CONTAS_PAGAR        A
                                                                WHERE   A.FLAGBAIXADA           = 'F'
                                                        )
                OR
                CF2.IDCLIFOR                            IN(
                                                                SELECT  B.IDCLIFOR
                                                                FROM    DBA.CONTAS_RECEBER      B
                                                                WHERE   B.FLAGBAIXADA           = 'F'
                                                        )
                )

            UNION ALL

            SELECT
                COUNT(*) AS TOTAL,
                'Conta cont�bil | Contas a pagar cuja conta cont�bil n�o existe ou n�o foi informada;' AS DESCRICAO,
                'SELECT  CF2.IDCLIFOR,         CF2.NOME,         CASE CF2.TIPOCADASTRO          WHEN ''C'' THEN ''Cliente''          WHEN ''A'' THEN ''Cliente/Fornecedor''          WHEN ''U'' THEN ''Colaborador''          WHEN ''F'' THEN ''Fornecedor''          WHEN ''M'' THEN ''Motorista''          WHEN ''O'' THEN ''Produtivo''          WHEN ''P'' THEN ''Prospect''          WHEN ''R'' THEN ''Revenda/Subvendedor''          WHEN ''T'' THEN ''Transportador''          WHEN ''V'' THEN ''Vendedor/Canal''          ELSE ''''         END TIPOCADASTRO,         CF2.CNPJCPF, CP.IDEMPRESA EMPRESA, CP.IDTITULO TITULO, CP.DIGITOTITULO DIGITO, CP.SERIENOTA SERIE, CP.VALTITULO VALOR, CP.IDCTACONTABIL, CP.IDCTACONTABILCONTRAPARTIDA    FROM CONTAS_PAGAR            AS CP, CLIENTE_FORNECEDOR      AS CF2 WHERE CF2.FLAGINATIVO                        = ''F'' AND CF2.IDCLIFOR                           = CP.IDCLIFOR AND CP.IDPLANILHA                          < 0 AND CP.SERIENOTA                           = ''AVU'' AND ( ( CP.IDCTACONTABIL                   IS NULL OR TRIM(CP.IDCTACONTABIL)             = '''' OR CP.IDCTACONTABILCONTRAPARTIDA      IS NULL OR TRIM(CP.IDCTACONTABILCONTRAPARTIDA) = '''' )  OR ( CP.IDCTACONTABIL                   NOT IN(SELECT CPC.IDCTACONTABIL FROM DBA.CONTABIL_PLANO_CONTAS CPC) OR CP.IDCTACONTABILCONTRAPARTIDA      NOT IN(SELECT CPC.IDCTACONTABIL FROM DBA.CONTABIL_PLANO_CONTAS CPC) )  ) ' AS QUERY
            FROM
                CONTAS_PAGAR            AS CP,
                CLIENTE_FORNECEDOR      AS CF2
            WHERE
                 CF2.FLAGINATIVO                        = 'F' AND
                 CF2.IDCLIFOR                           = CP.IDCLIFOR AND
                 CP.IDPLANILHA                          < 0 AND
                 CP.SERIENOTA                           = 'AVU' AND
                 (
                     (
                            CP.IDCTACONTABIL                   IS NULL OR
                            TRIM(CP.IDCTACONTABIL)             = '' OR
                            CP.IDCTACONTABILCONTRAPARTIDA      IS NULL OR
                            TRIM(CP.IDCTACONTABILCONTRAPARTIDA) = ''
                     )
                        OR
                     (
                            CP.IDCTACONTABIL                   NOT IN(SELECT CPC.IDCTACONTABIL FROM DBA.CONTABIL_PLANO_CONTAS CPC) OR
                            CP.IDCTACONTABILCONTRAPARTIDA      NOT IN(SELECT CPC.IDCTACONTABIL FROM DBA.CONTABIL_PLANO_CONTAS CPC)
                     )
                 )

            UNION ALL

            SELECT
                COUNT(*) AS TOTAL,
                'Conta cont�bil | Contas a receber cuja conta cont�bil n�o existe ou n�o foi informada;' AS DESCRICAO,
                'SELECT  CF2.IDCLIFOR,         CF2.NOME,         CASE CF2.TIPOCADASTRO          WHEN ''C'' THEN ''Cliente''          WHEN ''A'' THEN ''Cliente/Fornecedor''          WHEN ''U'' THEN ''Colaborador''          WHEN ''F'' THEN ''Fornecedor''          WHEN ''M'' THEN ''Motorista''          WHEN ''O'' THEN ''Produtivo''          WHEN ''P'' THEN ''Prospect''          WHEN ''R'' THEN ''Revenda/Subvendedor''          WHEN ''T'' THEN ''Transportador''          WHEN ''V'' THEN ''Vendedor/Canal''          ELSE ''''         END TIPOCADASTRO,         CF2.CNPJCPF, CP.IDEMPRESA EMPRESA, CP.IDTITULO TITULO, CP.DIGITOTITULO DIGITO, CP.SERIENOTA SERIE, CP.VALTITULO VALOR, CP.IDCTACONTABIL, CP.IDCTACONTABILCONTRAPARTIDA    FROM CONTAS_RECEBER            AS CP, CLIENTE_FORNECEDOR      AS CF2 WHERE CF2.FLAGINATIVO                        = ''F'' AND CF2.IDCLIFOR                           = CP.IDCLIFOR AND CP.IDPLANILHA                          < 0 AND CP.SERIENOTA                           = ''AVU'' AND ( ( CP.IDCTACONTABIL                   IS NULL OR TRIM(CP.IDCTACONTABIL)             = '''' OR CP.IDCTACONTABILCONTRAPARTIDA      IS NULL OR TRIM(CP.IDCTACONTABILCONTRAPARTIDA) = '''' )  OR ( CP.IDCTACONTABIL                   NOT IN(SELECT CPC.IDCTACONTABIL FROM DBA.CONTABIL_PLANO_CONTAS CPC) OR CP.IDCTACONTABILCONTRAPARTIDA      NOT IN(SELECT CPC.IDCTACONTABIL FROM DBA.CONTABIL_PLANO_CONTAS CPC) )  ) ' AS QUERY
            FROM
                CONTAS_RECEBER          AS CP,
                CLIENTE_FORNECEDOR      AS CF2
            WHERE
                 CF2.FLAGINATIVO                        = 'F' AND
                 CF2.IDCLIFOR                           = CP.IDCLIFOR AND
                 CP.IDPLANILHA                          < 0 AND
                 CP.SERIENOTA                           = 'AVU' AND
                 (
                     (
                            CP.IDCTACONTABIL                   IS NULL OR
                            TRIM(CP.IDCTACONTABIL)             = '' OR
                            CP.IDCTACONTABILCONTRAPARTIDA      IS NULL OR
                            TRIM(CP.IDCTACONTABILCONTRAPARTIDA) = ''
                     )
                        OR
                     (
                            CP.IDCTACONTABIL                   NOT IN(SELECT CPC.IDCTACONTABIL FROM DBA.CONTABIL_PLANO_CONTAS CPC) OR
                            CP.IDCTACONTABILCONTRAPARTIDA      NOT IN(SELECT CPC.IDCTACONTABIL FROM DBA.CONTABIL_PLANO_CONTAS CPC)
                     )
                 )

            UNION ALL

            SELECT
                COUNT(*) AS TOTAL,
                'Conta cont�bil | Movimento de cheques cuja conta cont�bil n�o existe ou n�o foi informada (Pessoas ativas e inativas);' AS DESCRICAO,
                'SELECT CHM.IDEMPRESA, CHM.IDNUMCHEQUE, CHM.IDCTACONTABIL, CHM.VALOR FROM CHEQUES_MOVIMENTO       AS CHM WHERE CHM.IDPLANILHA                         < 0 AND ( CHM.IDCTACONTABIL                   IS NULL OR TRIM(CHM.IDCTACONTABIL)             = '''' OR CHM.IDCTACONTABIL                   NOT IN(SELECT CPC.IDCTACONTABIL FROM DBA.CONTABIL_PLANO_CONTAS CPC) )' AS QUERY
            FROM
                CHEQUES_MOVIMENTO       AS CHM
            WHERE
                 CHM.IDPLANILHA                         < 0 AND
                 (
                    CHM.IDCTACONTABIL                   IS NULL OR
                    TRIM(CHM.IDCTACONTABIL)             = '' OR
                    CHM.IDCTACONTABIL                   NOT IN(SELECT CPC.IDCTACONTABIL FROM DBA.CONTABIL_PLANO_CONTAS CPC)
                 )

            UNION ALL

            SELECT
                COUNT(*) AS TOTAL,
                'Conta cont�bil | Adiantamentos cuja conta cont�bil n�o existe ou n�o foi informada;' AS DESCRICAO,
                'SELECT  CF2.IDCLIFOR,         CF2.NOME,         CASE CF2.TIPOCADASTRO          WHEN ''C'' THEN ''Cliente''          WHEN ''A'' THEN ''Cliente/Fornecedor''          WHEN ''U'' THEN ''Colaborador''          WHEN ''F'' THEN ''Fornecedor''          WHEN ''M'' THEN ''Motorista''          WHEN ''O'' THEN ''Produtivo''          WHEN ''P'' THEN ''Prospect''          WHEN ''R'' THEN ''Revenda/Subvendedor''          WHEN ''T'' THEN ''Transportador''          WHEN ''V'' THEN ''Vendedor/Canal''          ELSE ''''         END TIPOCADASTRO,         CF2.CNPJCPF, CP.IDEMPRESA EMPRESA, CP.IDADIANTAMENTO, CP.ORIGEMMOVIMENTO SERIE, CP.VALADIANTAMENTO VALOR, CP.IDCTACONTABIL FROM ADIANTAMENTO            AS CP, CLIENTE_FORNECEDOR      AS CF2 WHERE CF2.FLAGINATIVO                        = ''F'' AND CF2.IDCLIFOR                           = CP.IDCLIFOR AND CP.IDPLANILHA                          < 0 AND  CP.ORIGEMMOVIMENTO                     = ''AVU'' AND ( CP.IDCTACONTABIL                   IS NULL OR   TRIM(CP.IDCTACONTABIL)             = '''' OR  CP.IDCTACONTABIL                   NOT IN(SELECT CPC.IDCTACONTABIL FROM DBA.CONTABIL_PLANO_CONTAS CPC) ) ' AS QUERY
            FROM
                ADIANTAMENTO            AS CP,
                CLIENTE_FORNECEDOR      AS CF2
            WHERE
                 CF2.FLAGINATIVO                        = 'F' AND
                 CF2.IDCLIFOR                           = CP.IDCLIFOR AND
                 CP.IDPLANILHA                          < 0 AND
                 CP.ORIGEMMOVIMENTO                     = 'AVU' AND
                 (
                    CP.IDCTACONTABIL                   IS NULL OR
                    TRIM(CP.IDCTACONTABIL)             = '' OR
                    CP.IDCTACONTABIL                   NOT IN(SELECT CPC.IDCTACONTABIL FROM DBA.CONTABIL_PLANO_CONTAS CPC)
                 )

            )


SELECT
    CLIENTE.TOTAL,
    CLIENTE.DESCRICAO,
    CLIENTE.QUERY
FROM
    CLIENTE
ORDER BY
    CLIENTE.DESCRICAO

/*

 * Hist�rico de altera��es
        - 06/02/2019 -          | �ltima altera��o;
        - 06/02/2019 - 2.1      | Criada a valida��o "Locais de Entrega cujo endere�o � igual ao endere�o de Localiza��o (Cep, endere�o, n�mero, bairro, complemento e inscri��o);";
        - 12/02/2020 - 2.2      | Ajuste na descri��o do cabe�alho do script. Criada a valida��o "Pessoas duplicadas, ou seja, mais de uma pessoa com mesmo CPF/CNPJ (Apenas ativos);". Criada a valida��o "Pessoas inativas com financeiro em aberto;";
        - 01/09/2020 - 2.3      | Cria��o de quatro valida��es para identificar financiero convertido cuja conta cont�bil n�o foi informada ou � inv�lida;

 * Melhorias e corre��es para aplicar
        - Criar uma coluna para classificar entre "Inconsist�ncia" e "Informativo";
        - Criar recurso para conseguir filtrar em cadastros ativos, inativos ou ambos;
        - Criar valida��o "Cliente/Fornecedor inativo com financeiro em aberto"
        - Criar valida��o "Cliente/Fornecedor inativo com pedido de compra ou venda."

*/
