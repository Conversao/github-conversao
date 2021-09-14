/*       Este script tem por objetivo, retornar uma s�rie de valida��es sobre a consist�ncia dos cadastros de produtos
        para an�lise e/ou posterior ajuste por parte do cliente ou via convers�o. (Considera somente produtos ativos)    */

WITH PRODUTO_VALIDACAO AS  (
                            -- Outros
                            SELECT
                                COUNT(*) Total,
                                'NCM | Produtos com NCM inv�lido ou inexistente no cadastro de NCM;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.DESCRRESPRODUTO, PG.NCM FROM PRODUTO_GRADE AS PG WHERE PG.FLAGINATIVO = ''F'' AND (PG.NCM IS NULL OR TRIM(PG.NCM) = '''' OR LENGTH(CAST(PG.NCM AS VARCHAR(8))) <> 8 OR PG.NCM NOT IN( SELECT  NCM.NCM FROM    DBA.NCM) )' AS QUERY
                            FROM
                                PRODUTO_GRADE PG
                            WHERE
                                PG.FLAGINATIVO                          = 'F' AND
                                (
                                PG.NCM                                  IS NULL OR
                                TRIM(PG.NCM)                            = '' OR
                                LENGTH(CAST(PG.NCM AS VARCHAR(8)))      <> 8 OR
                                PG.NCM                                  NOT IN( SELECT  NCM.NCM
                                                                                FROM    DBA.NCM)
                                )


                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'CEST | Produtos com C�digo CEST inv�lido;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.DESCRRESPRODUTO, PG.CODCEST FROM PRODUTO_GRADE AS PG WHERE PG.FLAGINATIVO = ''F'' AND (PG.CODCEST IS NULL OR TRIM(PG.CODCEST) = '''' OR LENGTH(CAST(PG.CODCEST AS VARCHAR(7))) <> 7)' AS QUERY
                            FROM
                                PRODUTO_GRADE PG
                            WHERE
                                PG.FLAGINATIVO = 'F' AND
                                (PG.CODCEST IS NULL
                                OR TRIM(PG.CODCEST) = ''
                                OR LENGTH(CAST(PG.CODCEST AS VARCHAR(7))) <> 7)

                            UNION ALL


                            -- Pre�os e custos
                            SELECT
                                COUNT(*) Total,
                                'Pre�os e Custos | Produtos sem registro na POLITICA_PRECO_PRODUTO (Todas as empresas);' AS Descricao,
                                'SELECT E.IDEMPRESA, PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO FROM PRODUTO_GRADE PG, EMPRESA E WHERE PG.FLAGINATIVO = ''F'' AND NOT EXISTS (    SELECT  1 FROM    DBA.POLITICA_PRECO_PRODUTO PPP WHERE   PPP.IDEMPRESA = E.IDEMPRESA AND PPP.IDSUBPRODUTO = PG.IDSUBPRODUTO) ORDER BY PG.IDSUBPRODUTO, E.IDEMPRESA'  AS QUERY
                            FROM
                                PRODUTO_GRADE PG,
                                EMPRESA E
                            WHERE
                                PG.FLAGINATIVO = 'F' AND
                                NOT EXISTS (    SELECT  1
                                                FROM    DBA.POLITICA_PRECO_PRODUTO PPP
                                                WHERE   PPP.IDEMPRESA = E.IDEMPRESA AND
                                                        PPP.IDSUBPRODUTO = PG.IDSUBPRODUTO)

                           UNION ALL

                           SELECT
                                COUNT(*) Total,
                                'Pre�os | Produtos sem pre�o varejo (Todas as empresas);' AS Descricao,
                                'SELECT PPP.IDEMPRESA, PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PPP.VALPRECOVAREJO, PPP.PERMARGEMVAREJO , PPP.VALPRECOATACADO, PPP.PERMARGEMATACADO, PPP.VALCUSTOREPOS , PPP.CUSTOGERENCIAL , PPP.CUSTONOTAFISCAL , PPP.CUSTOULTIMACOMPRA FROM PRODUTO_GRADE AS PG, POLITICA_PRECO_PRODUTO PPP WHERE PG.FLAGINATIVO = ''F'' AND PG.IDSUBPRODUTO = PPP.IDSUBPRODUTO AND (PPP.valprecovarejo = 0 OR PPP.valprecovarejo IS NULL) ORDER BY PG.IDSUBPRODUTO, PPP.IDEMPRESA' AS QUERY
                            FROM
                                PRODUTO_GRADE PG,
                                POLITICA_PRECO_PRODUTO PPP
                            WHERE
                                PG.FLAGINATIVO = 'F' AND
                                PG.IDSUBPRODUTO = PPP.IDSUBPRODUTO AND
                                (PPP.valprecovarejo = 0 OR
                                PPP.valprecovarejo IS NULL)

                           UNION ALL

                           SELECT
                                COUNT(*) Total,
                                'Pre�os | Produtos sem pre�o atacado (Todas as empresas);' AS Descricao,
                                'SELECT PPP.IDEMPRESA, PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PPP.VALPRECOVAREJO, PPP.PERMARGEMVAREJO , PPP.VALPRECOATACADO, PPP.PERMARGEMATACADO, PPP.VALCUSTOREPOS , PPP.CUSTOGERENCIAL , PPP.CUSTONOTAFISCAL , PPP.CUSTOULTIMACOMPRA FROM PRODUTO_GRADE AS PG, POLITICA_PRECO_PRODUTO PPP WHERE PG.FLAGINATIVO = ''F'' AND PG.IDSUBPRODUTO = PPP.IDSUBPRODUTO AND (PPP.valprecoatacado = 0 OR PPP.valprecoatacado IS NULL) ORDER BY PG.IDSUBPRODUTO, PPP.IDEMPRESA' AS QUERY
                            FROM
                                PRODUTO_GRADE PG,
                                POLITICA_PRECO_PRODUTO PPP
                            WHERE
                                PG.FLAGINATIVO = 'F' AND
                                PG.IDSUBPRODUTO = PPP.IDSUBPRODUTO AND
                                (PPP.valprecoatacado = 0 OR
                                PPP.valprecoatacado IS NULL)

                           UNION ALL

                           SELECT
                                COUNT(*) Total,
                                'Pre�os | Produtos com pre�o menor que o custo (Todas as empresas);' AS Descricao,
                                'SELECT PPP.IDEMPRESA, PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PPP.VALPRECOVAREJO, PPP.PERMARGEMVAREJO , PPP.VALPRECOATACADO, PPP.PERMARGEMATACADO, PPP.VALCUSTOREPOS , PPP.CUSTOGERENCIAL , PPP.CUSTONOTAFISCAL , PPP.CUSTOULTIMACOMPRA FROM PRODUTO_GRADE           PG, POLITICA_PRECO_PRODUTO  PPP WHERE PG.FLAGINATIVO          = ''F'' AND PG.IDSUBPRODUTO         = PPP.IDSUBPRODUTO AND ( ( PPP.VALPRECOVAREJO      > 0 AND ( PPP.VALPRECOVAREJO      < PPP.VALCUSTOREPOS OR PPP.VALPRECOVAREJO      < PPP.CUSTOULTIMACOMPRA OR PPP.VALPRECOVAREJO      < PPP.CUSTOGERENCIAL OR PPP.VALPRECOVAREJO      < PPP.CUSTONOTAFISCAL ) ) OR ( PPP.VALPRECOATACADO     > 0 AND ( PPP.VALPRECOATACADO     < PPP.VALCUSTOREPOS OR PPP.VALPRECOATACADO     < PPP.CUSTOULTIMACOMPRA OR PPP.VALPRECOATACADO     < PPP.CUSTOGERENCIAL OR PPP.VALPRECOATACADO     < PPP.CUSTONOTAFISCAL ) ) )' AS QUERY
                            FROM
                                PRODUTO_GRADE           PG,
                                POLITICA_PRECO_PRODUTO  PPP
                            WHERE
                                PG.FLAGINATIVO          = 'F' AND
                                PG.IDSUBPRODUTO         = PPP.IDSUBPRODUTO AND
                                (
                                    (
                                        PPP.VALPRECOVAREJO      > 0 AND
                                            (
                                            PPP.VALPRECOVAREJO      < PPP.VALCUSTOREPOS OR
                                            PPP.VALPRECOVAREJO      < PPP.CUSTOULTIMACOMPRA OR
                                            PPP.VALPRECOVAREJO      < PPP.CUSTOGERENCIAL OR
                                            PPP.VALPRECOVAREJO      < PPP.CUSTONOTAFISCAL
                                            )
                                    ) OR
                                    (
                                        PPP.VALPRECOATACADO     > 0 AND
                                            (
                                            PPP.VALPRECOATACADO     < PPP.VALCUSTOREPOS OR
                                            PPP.VALPRECOATACADO     < PPP.CUSTOULTIMACOMPRA OR
                                            PPP.VALPRECOATACADO     < PPP.CUSTOGERENCIAL OR
                                            PPP.VALPRECOATACADO     < PPP.CUSTONOTAFISCAL
                                            )
                                    )
                                )

                           UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Custos | Produtos sem custo reposi��o (Todas as empresas);' AS Descricao,
                                'SELECT PPP.IDEMPRESA, PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PPP.VALPRECOVAREJO, PPP.PERMARGEMVAREJO , PPP.VALPRECOATACADO, PPP.PERMARGEMATACADO, PPP.VALCUSTOREPOS , PPP.CUSTOGERENCIAL , PPP.CUSTONOTAFISCAL , PPP.CUSTOULTIMACOMPRA FROM PRODUTO_GRADE AS PG, POLITICA_PRECO_PRODUTO PPP WHERE PG.FLAGINATIVO = ''F'' AND PG.IDSUBPRODUTO = PPP.IDSUBPRODUTO AND (PPP.valcustorepos = 0 OR PPP.valcustorepos IS NULL) ORDER BY PG.IDSUBPRODUTO, PPP.IDEMPRESA' AS QUERY
                            FROM
                                PRODUTO_GRADE PG,
                                POLITICA_PRECO_PRODUTO PPP
                            WHERE
                                PG.FLAGINATIVO = 'F' AND
                                PG.IDSUBPRODUTO = PPP.IDSUBPRODUTO AND
                                (PPP.valcustorepos = 0 OR
                                PPP.valcustorepos IS NULL)

                           UNION ALL


                            SELECT
                                COUNT(*) Total,
                                'Custos | Produtos sem custo gerencial (Todas as empresas);' AS Descricao,
                                'SELECT PPP.IDEMPRESA, PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PPP.VALPRECOVAREJO, PPP.PERMARGEMVAREJO , PPP.VALPRECOATACADO, PPP.PERMARGEMATACADO, PPP.VALCUSTOREPOS , PPP.CUSTOGERENCIAL , PPP.CUSTONOTAFISCAL , PPP.CUSTOULTIMACOMPRA FROM PRODUTO_GRADE AS PG, POLITICA_PRECO_PRODUTO PPP WHERE PG.FLAGINATIVO = ''F'' AND PG.IDSUBPRODUTO = PPP.IDSUBPRODUTO AND (PPP.custogerencial = 0 OR PPP.custogerencial IS NULL) ORDER BY PG.IDSUBPRODUTO, PPP.IDEMPRESA' AS QUERY
                            FROM
                                PRODUTO_GRADE PG,
                                POLITICA_PRECO_PRODUTO PPP
                            WHERE
                                PG.FLAGINATIVO = 'F' AND
                                PG.IDSUBPRODUTO = PPP.IDSUBPRODUTO AND
                                (PPP.custogerencial = 0 OR
                                PPP.custogerencial IS NULL)

                           UNION ALL

                           SELECT
                                COUNT(*) Total,
                                'Custos | Produtos sem custo nota fiscal (Todas as empresas);' AS Descricao,
                                'SELECT PPP.IDEMPRESA, PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PPP.VALPRECOVAREJO, PPP.PERMARGEMVAREJO , PPP.VALPRECOATACADO, PPP.PERMARGEMATACADO, PPP.VALCUSTOREPOS , PPP.CUSTOGERENCIAL , PPP.CUSTONOTAFISCAL , PPP.CUSTOULTIMACOMPRA FROM PRODUTO_GRADE AS PG, POLITICA_PRECO_PRODUTO PPP WHERE PG.FLAGINATIVO = ''F'' AND PG.IDSUBPRODUTO = PPP.IDSUBPRODUTO AND (PPP.custonotafiscal = 0 OR PPP.custonotafiscal IS NULL) ORDER BY PG.IDSUBPRODUTO, PPP.IDEMPRESA' AS QUERY
                            FROM
                                PRODUTO_GRADE PG,
                                POLITICA_PRECO_PRODUTO PPP
                            WHERE
                                PG.FLAGINATIVO = 'F' AND
                                PG.IDSUBPRODUTO = PPP.IDSUBPRODUTO AND
                                (PPP.custonotafiscal = 0 OR
                                PPP.custonotafiscal IS NULL)

                           UNION ALL

                           SELECT
                                COUNT(*) Total,
                                'Custos | Produtos sem custo ultima compra (Todas as empresas);' AS Descricao,
                                'SELECT PPP.IDEMPRESA, PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PPP.VALPRECOVAREJO, PPP.PERMARGEMVAREJO , PPP.VALPRECOATACADO, PPP.PERMARGEMATACADO, PPP.VALCUSTOREPOS , PPP.CUSTOGERENCIAL , PPP.CUSTONOTAFISCAL , PPP.CUSTOULTIMACOMPRA FROM PRODUTO_GRADE AS PG, POLITICA_PRECO_PRODUTO PPP WHERE PG.FLAGINATIVO = ''F'' AND PG.IDSUBPRODUTO = PPP.IDSUBPRODUTO AND (PPP.custoultimacompra = 0 OR PPP.custoultimacompra IS NULL) ORDER BY PG.IDSUBPRODUTO, PPP.IDEMPRESA' AS QUERY
                            FROM
                                PRODUTO_GRADE PG,
                                POLITICA_PRECO_PRODUTO PPP
                            WHERE
                                PG.FLAGINATIVO = 'F' AND
                                PG.IDSUBPRODUTO = PPP.IDSUBPRODUTO AND
                                (PPP.custoultimacompra = 0 OR
                                PPP.custoultimacompra IS NULL)

                           UNION ALL

                           SELECT
                                COUNT(*) Total,
                                'Custos | Produtos sem algum dos custos (Todas as empresas);' AS Descricao,
                                'SELECT PPP.IDEMPRESA, PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PPP.VALPRECOVAREJO, PPP.PERMARGEMVAREJO , PPP.VALPRECOATACADO, PPP.PERMARGEMATACADO, PPP.VALCUSTOREPOS , PPP.CUSTOGERENCIAL , PPP.CUSTONOTAFISCAL , PPP.CUSTOULTIMACOMPRA FROM PRODUTO_GRADE AS PG, POLITICA_PRECO_PRODUTO PPP WHERE PG.FLAGINATIVO = ''F'' AND PG.IDSUBPRODUTO = PPP.IDSUBPRODUTO AND (PPP.VALCUSTOREPOS = 0 OR PPP.VALCUSTOREPOS IS NULL OR PPP.CUSTOGERENCIAL = 0 OR PPP.CUSTOGERENCIAL IS NULL OR PPP.CUSTONOTAFISCAL = 0 OR PPP.CUSTONOTAFISCAL IS NULL OR PPP.custoultimacompra = 0 OR PPP.custoultimacompra IS NULL ) ORDER BY PPP.IDSUBPRODUTO, PPP.IDEMPRESA' AS QUERY
                            FROM
                                PRODUTO_GRADE PG,
                                POLITICA_PRECO_PRODUTO PPP
                            WHERE
                                PG.FLAGINATIVO = 'F' AND
                                PG.IDSUBPRODUTO = PPP.IDSUBPRODUTO AND
                                (PPP.VALCUSTOREPOS = 0 OR
                                PPP.VALCUSTOREPOS IS NULL OR
                                PPP.CUSTOGERENCIAL = 0 OR
                                PPP.CUSTOGERENCIAL IS NULL OR
                                PPP.CUSTONOTAFISCAL = 0 OR
                                PPP.CUSTONOTAFISCAL IS NULL OR
                                PPP.custoultimacompra = 0 OR
                                PPP.custoultimacompra IS NULL )

                           UNION ALL

                           -- Descri��es
                           SELECT
                                COUNT(*) Total,
                                'Descri��es | Produtos com descri��o em branco ou nula;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, P.DESCRCOMPRODUTO, PG.DESCRRESPRODUTO FROM PRODUTO P, PRODUTO_GRADE PG WHERE PG.FLAGINATIVO = ''F'' AND P.IDPRODUTO = PG.IDPRODUTO AND ( P.DESCRCOMPRODUTO IS NULL OR TRIM(P.DESCRCOMPRODUTO) = '''' OR PG.DESCRRESPRODUTO IS NULL OR TRIM(PG.DESCRRESPRODUTO) = '''')' AS QUERY
                            FROM
                                PRODUTO                 P,
                                PRODUTO_GRADE           PG
                            WHERE
                                PG.FLAGINATIVO          = 'F' AND
                                P.IDPRODUTO             = PG.IDPRODUTO AND (
                                P.DESCRCOMPRODUTO       IS NULL OR
                                TRIM(P.DESCRCOMPRODUTO) = '' OR
                                PG.DESCRRESPRODUTO      IS NULL OR
                                TRIM(PG.DESCRRESPRODUTO) = '')

                           UNION ALL

                           SELECT
                                COUNT(*) Total,
                                'Descri��es | Produtos com subdescri��o nula;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, P.DESCRCOMPRODUTO, PG.SUBDESCRICAO, PG.DESCRRESPRODUTO FROM PRODUTO P, PRODUTO_GRADE PG WHERE PG.FLAGINATIVO = ''F'' AND P.IDPRODUTO = PG.IDPRODUTO AND PG.SUBDESCRICAO IS NULL' AS QUERY
                            FROM
                                PRODUTO P,
                                PRODUTO_GRADE PG
                            WHERE
                                PG.FLAGINATIVO  = 'F'           AND
                                P.IDPRODUTO     = PG.IDPRODUTO  AND
                                PG.SUBDESCRICAO IS NULL

                           UNION ALL

                           -- Relacionamento de Produto com Fornecedor
                           SELECT
                                COUNT(*) Total,
                                'Relacionamento de Produto com Fornecedor | Produtos sem fornecedor;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO FROM PRODUTO_GRADE PG WHERE PG.FLAGINATIVO = ''F'' AND PG.IDSUBPRODUTO NOT IN(SELECT PF.IDSUBPRODUTO FROM PRODUTO_FORNECEDOR PF)' AS QUERY
                           FROM
                                PRODUTO_GRADE PG
                           WHERE
                                PG.FLAGINATIVO = 'F' AND
                                PG.IDPRODUTO NOT IN (SELECT      PF.IDSUBPRODUTO
                                                    FROM        PRODUTO_FORNECEDOR PF)


                           UNION ALL

                           SELECT
                                COUNT(*) Total,
                                'Relacionamento de Produto com Fornecedor | Produtos com fornecedor, por�m sem fornecedor padr�o marcado;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO FROM    PRODUTO_GRADE   PG WHERE    PG.FLAGINATIVO  = ''F'' AND    PG.IDSUBPRODUTO IN      (       SELECT  PF1.IDSUBPRODUTO FROM    PRODUTO_FORNECEDOR      PF1 WHERE   PF1.IDSUBPRODUTO        NOT IN  (       SELECT      PF2.IDSUBPRODUTO FROM        PRODUTO_FORNECEDOR          PF2 WHERE       PF2.FLAGFORNECEDORPADRAO    = ''T'' ) )' AS QUERY
                           FROM
                                PRODUTO_GRADE   PG
                           WHERE
                                PG.FLAGINATIVO  = 'F' AND
                                PG.IDSUBPRODUTO IN      (       SELECT  PF1.IDSUBPRODUTO
                                                                FROM    PRODUTO_FORNECEDOR      PF1
                                                                WHERE   PF1.IDSUBPRODUTO        NOT IN  (       SELECT      PF2.IDSUBPRODUTO
                                                                                                                FROM        PRODUTO_FORNECEDOR          PF2
                                                                                                                WHERE       PF2.FLAGFORNECEDORPADRAO    = 'T'
                                                                                                        )
                                                        )

                           UNION ALL

                           SELECT
                                COUNT(*) Total,
                                'Relacionamento de Produto com Fornecedor | Mesmo fornecedor com c�digo interno do fornecedor igual para mais de um produto;' AS Descricao,
                                'SELECT  A.IDCLIFOR, C.CNPJCPF, C.NOME , A.CODIGOINTERNOFORN, A.IDSUBPRODUTO, D.IDCODBARPROD , D.DESCRRESPRODUTO FROM    DBA.PRODUTO_FORNECEDOR  A, DBA.CLIENTE_FORNECEDOR  C , DBA.PRODUTO_GRADE       D WHERE   D.FLAGINATIVO           = ''F'' AND C.IDCLIFOR              = A.IDCLIFOR AND D.IDSUBPRODUTO          = A.IDSUBPRODUTO AND EXISTS                     (    SELECT  1 FROM    PRODUTO_FORNECEDOR      B WHERE   B.CODIGOINTERNOFORN     IS NOT NULL AND B.CODIGOINTERNOFORN     = A.CODIGOINTERNOFORN AND B.IDCLIFOR              = A.IDCLIFOR AND B.IDSUBPRODUTO          IN(     SELECT  E.IDSUBPRODUTO FROM    DBA.PRODUTO_GRADE       E WHERE   E.FLAGINATIVO           = ''F'' ) GROUP BY B.CODIGOINTERNOFORN , B.IDCLIFOR HAVING COUNT(*) > 1 ) ORDER BY A.CODIGOINTERNOFORN, A.IDCLIFOR' AS QUERY
                           FROM
                                DBA.PRODUTO_FORNECEDOR  A,
                                DBA.CLIENTE_FORNECEDOR  C ,
                                DBA.PRODUTO_GRADE       D
                           WHERE
                                D.FLAGINATIVO           = 'F' AND
                                C.IDCLIFOR              = A.IDCLIFOR AND
                                D.IDSUBPRODUTO          = A.IDSUBPRODUTO AND
                                EXISTS                     (    SELECT  1
                                                                FROM    PRODUTO_FORNECEDOR      B
                                                                WHERE   B.CODIGOINTERNOFORN     IS NOT NULL AND
                                                                        B.CODIGOINTERNOFORN     = A.CODIGOINTERNOFORN AND
                                                                        B.IDCLIFOR              = A.IDCLIFOR AND
                                                                        B.IDSUBPRODUTO          IN(     SELECT  E.IDSUBPRODUTO
                                                                                                        FROM    DBA.PRODUTO_GRADE       E
                                                                                                        WHERE   E.FLAGINATIVO           = 'F'
                                                                                                  )
                                                                        GROUP BY B.CODIGOINTERNOFORN , B.IDCLIFOR
                                                                        HAVING COUNT(*) > 1
                                                           )

                           UNION ALL

                           -- Estrutura mercadol�gica
                           SELECT
                                COUNT(*) Total,
                                'Estrutura Mercadol�gica | Produtos para divis�o geral;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, P.DESCRCOMPRODUTO, PG.DESCRRESPRODUTO, D.IDDIVISAO, D.DESCRDIVISAO FROM PRODUTO P, PRODUTO_GRADE PG, DIVISAO D WHERE PG.FLAGINATIVO = ''F'' AND P.IDPRODUTO = PG.IDPRODUTO AND P.IDDIVISAO = D.IDDIVISAO AND UPPER(TRIM(D.DESCRDIVISAO)) = ''GERAL''' AS QUERY
                            FROM
                                PRODUTO P,
                                PRODUTO_GRADE PG,
                                DIVISAO D
                            WHERE
                                PG.FLAGINATIVO = 'F' AND
                                P.IDPRODUTO = PG.IDPRODUTO AND
                                P.IDDIVISAO = D.IDDIVISAO AND
                                UPPER(TRIM(D.DESCRDIVISAO)) = 'GERAL'

                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Estrutura Mercadol�gica | Produtos para se��o geral;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, P.DESCRCOMPRODUTO, PG.DESCRRESPRODUTO, S.IDSECAO, S.DESCRSECAO FROM PRODUTO P, PRODUTO_GRADE PG, SECAO S WHERE PG.FLAGINATIVO = ''F'' AND P.IDPRODUTO = PG.IDPRODUTO AND P.IDSECAO = S.IDSECAO AND UPPER(TRIM(S.DESCRSECAO)) = ''GERAL''' AS QUERY
                            FROM
                                PRODUTO P,
                                PRODUTO_GRADE PG,
                                SECAO S
                            WHERE
                                PG.FLAGINATIVO = 'F' AND
                                P.IDPRODUTO = PG.IDPRODUTO AND
                                P.IDSECAO = S.IDSECAO AND
                                UPPER(TRIM(S.DESCRSECAO)) = 'GERAL'

                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Estrutura Mercadol�gica | Produtos para grupo geral;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, P.DESCRCOMPRODUTO, PG.DESCRRESPRODUTO, G.IDGRUPO, G.DESCRGRUPO FROM PRODUTO P, PRODUTO_GRADE PG, GRUPO G WHERE PG.FLAGINATIVO = ''F'' AND P.IDPRODUTO = PG.IDPRODUTO AND P.IDGRUPO = G.IDGRUPO AND UPPER(TRIM(G.DESCRGRUPO)) = ''GERAL''' AS QUERY
                            FROM
                                PRODUTO P,
                                PRODUTO_GRADE PG,
                                GRUPO G
                            WHERE
                                PG.FLAGINATIVO = 'F' AND
                                P.IDPRODUTO = PG.IDPRODUTO AND
                                P.IDGRUPO = G.IDGRUPO AND
                                UPPER(TRIM(G.DESCRGRUPO)) = 'GERAL'

                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Estrutura Mercadol�gica | Produtos para subgrupo geral;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, P.DESCRCOMPRODUTO, PG.DESCRRESPRODUTO, SG.IDSUBGRUPO, SG.DESCRSUBGRUPO FROM PRODUTO P, PRODUTO_GRADE PG, SUBGRUPO SG WHERE PG.FLAGINATIVO = ''F'' AND P.IDPRODUTO = PG.IDPRODUTO AND P.IDSUBGRUPO = SG.IDSUBGRUPO AND UPPER(TRIM(SG.DESCRSUBGRUPO)) = ''GERAL''' AS QUERY
                            FROM
                                PRODUTO P,
                                PRODUTO_GRADE PG,
                                SUBGRUPO SG
                            WHERE
                                PG.FLAGINATIVO = 'F' AND
                                P.IDPRODUTO = PG.IDPRODUTO AND
                                P.IDSUBGRUPO = SG.IDSUBGRUPO AND
                                UPPER(TRIM(SG.DESCRSUBGRUPO)) = 'GERAL'

                            UNION ALL



                            SELECT
                                COUNT(*) Total,
                                'Estrutura Mercadol�gica Integrada | Produtos relacionados a estrutura mercadol�gica incorretamente quando a configura��o "Utiliza estrutura mercadol�gica integrada" est� marcada;' AS Descricao,
                                'SELECT  P.IDPRODUTO, P.DESCRCOMPRODUTO, P.IDDIVISAO, P.IDSECAO, P.IDGRUPO, P.IDSUBGRUPO FROM    DBA.PRODUTO             P, DBA.PRODUTO_GRADE       PG WHERE   PG.FLAGINATIVO          = ''F'' AND        P.IDPRODUTO             = PG.IDPRODUTO AND         (         EXISTS                ( SELECT  1                                 FROM    DBA.SECAO       S                                 WHERE   P.IDSECAO       = S.IDSECAO AND                                         P.IDDIVISAO     <> S.IDDIVISAO AND                                         S.IDDIVISAO     IS NOT NULL)         OR         EXISTS                ( SELECT  1                                 FROM    DBA.GRUPO       G                                 WHERE   P.IDGRUPO       = G.IDGRUPO AND                                         P.IDSECAO       <> G.IDSECAO)         OR         EXISTS                ( SELECT  1                                 FROM    DBA.SUBGRUPO    SG                                 WHERE   P.IDSUBGRUPO    = SG.IDSUBGRUPO AND                                         P.IDGRUPO       <> SG.IDGRUPO)         )' AS QUERY
                            FROM
                                DBA.PRODUTO             P,
                                DBA.PRODUTO_GRADE       PG
                            WHERE
                                PG.FLAGINATIVO          = 'F' AND
                                P.IDPRODUTO             = PG.IDPRODUTO AND
                                (
                                EXISTS                ( SELECT  1
                                                        FROM    DBA.SECAO       S
                                                        WHERE   P.IDSECAO       = S.IDSECAO AND
                                                                P.IDDIVISAO     <> S.IDDIVISAO AND
                                                                S.IDDIVISAO     IS NOT NULL)
                                OR
                                EXISTS                ( SELECT  1
                                                        FROM    DBA.GRUPO       G
                                                        WHERE   P.IDGRUPO       = G.IDGRUPO AND
                                                                P.IDSECAO       <> G.IDSECAO)
                                OR
                                EXISTS                ( SELECT  1
                                                        FROM    DBA.SUBGRUPO    SG
                                                        WHERE   P.IDSUBGRUPO    = SG.IDSUBGRUPO AND
                                                                P.IDGRUPO       <> SG.IDGRUPO)
                                )


                           UNION ALL


                            -- Tributa��o por grupo
                            SELECT
                                COUNT(*) Total,
                                'Tributa��o por grupo | Produtos sem tributa��o dentro do estado;' AS Descricao,
                                'SELECT E.UF, PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO,G.IDGRUPO, G.DESCRGRUPO FROM GRUPO                                           G, PRODUTO                                         P, PRODUTO_GRADE                                   PG, (SELECT DISTINCT EMPRESA.UF FROM EMPRESA)       E WHERE PG.FLAGINATIVO                                  = ''F'' AND P.FLAGTRIBUTACAOGRUPO                           = ''T'' AND P.IDPRODUTO                                     = PG.IDPRODUTO AND P.IDGRUPO                                       = G.IDGRUPO AND NOT EXISTS                                      (       SELECT  1 FROM    DBA.GRUPO_TRIBUTACAO_ESTADO     GTE WHERE   GTE.IDGRUPO                     = P.IDGRUPO AND GTE.UF                          = E.UF )' AS QUERY
                            FROM
                                GRUPO                                           G,
                                PRODUTO                                         P,
                                PRODUTO_GRADE                                   PG,
                                (SELECT DISTINCT EMPRESA.UF FROM EMPRESA)       E
                            WHERE
                                PG.FLAGINATIVO                                  = 'F' AND
                                P.FLAGTRIBUTACAOGRUPO                           = 'T' AND
                                P.IDPRODUTO                                     = PG.IDPRODUTO AND
                                P.IDGRUPO                                       = G.IDGRUPO AND
                                NOT EXISTS                                      (       SELECT  1
                                                                                        FROM    DBA.GRUPO_TRIBUTACAO_ESTADO     GTE
                                                                                        WHERE   GTE.IDGRUPO                     = P.IDGRUPO AND
                                                                                                GTE.UF                          = E.UF
                                                                                )



                           UNION ALL


                            -- Tributa��o normal
                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Produtos sem tributa��o dentro do estado;' AS Descricao,
                                'SELECT E.UF, PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO FROM PRODUTO P, PRODUTO_GRADE PG, (SELECT DISTINCT EMPRESA.UF FROM EMPRESA) E WHERE PG.FLAGINATIVO = ''F'' AND P.FLAGTRIBUTACAOGRUPO   = ''F'' AND P.IDPRODUTO = PG.IDPRODUTO AND NOT EXISTS      (SELECT 1 FROM    DBA.PRODUTO_TRIBUTACAO_ESTADO PTE WHERE   PTE.IDSUBPRODUTO = PG.IDSUBPRODUTO AND PTE.UF = E.UF) ORDER BY PG.IDSUBPRODUTO' AS QUERY
                            FROM
                                PRODUTO                                         P,
                                PRODUTO_GRADE                                   PG,
                                (SELECT DISTINCT EMPRESA.UF FROM EMPRESA)       E
                            WHERE
                                PG.FLAGINATIVO                                  = 'F' AND
                                P.FLAGTRIBUTACAOGRUPO                           = 'F' AND
                                P.IDPRODUTO                                     = PG.IDPRODUTO AND
                                NOT EXISTS                                      (       SELECT  1
                                                                                        FROM    DBA.PRODUTO_TRIBUTACAO_ESTADO   PTE
                                                                                        WHERE   PTE.IDSUBPRODUTO                = PG.IDSUBPRODUTO AND
                                                                                                PTE.UF                          = E.UF
                                                                                )

                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Produtos cujo C�digo da Situa��o Tribut�ria n�o pertence ao Tipo da Situa��o Tribut�ria;' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UFORIGEM, PTE.UF, PTE.TIPOSITTRIBENT, PTE.IDSITTRIBENT, PTE.TIPOSITTRIBSAI, PTE.IDSITTRIBSAI FROM    PRODUTO                         P, PRODUTO_GRADE                   PG, PRODUTO_TRIBUTACAO_ESTADO       PTE, SITUACAO_TRIBUTARIA             ST WHERE ST.IDSITTRIBUTARIA              <> 90 AND PG.FLAGINATIVO                  = ''F'' AND P.FLAGTRIBUTACAOGRUPO           = ''F'' AND P.IDPRODUTO                     = PG.IDPRODUTO AND PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO AND ( PTE.TIPOSITTRIBENT              <> ''A'' OR PTE.TIPOSITTRIBSAI              <> ''A'' ) AND ( ( PTE.TIPOSITTRIBENT     <> ''A'' AND PTE.IDSITTRIBENT       = ST.IDSITTRIBUTARIA AND PTE.TIPOSITTRIBENT     <> ST.TIPOSITTRIB ) OR ( PTE.TIPOSITTRIBSAI     <> ''A'' AND PTE.IDSITTRIBSAI       = ST.IDSITTRIBUTARIA AND PTE.TIPOSITTRIBSAI     <> ST.TIPOSITTRIB )  )' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE,
                                SITUACAO_TRIBUTARIA             ST
                            WHERE
                                ST.IDSITTRIBUTARIA              <> 90 AND
                                PG.FLAGINATIVO                  = 'F' AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F' AND
                                P.IDPRODUTO                     = PG.IDPRODUTO AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO AND
                                (
                                PTE.TIPOSITTRIBENT              <> 'A' OR
                                PTE.TIPOSITTRIBSAI              <> 'A'

                                ) AND
                                (
                                   (
                                    PTE.TIPOSITTRIBENT     <> 'A' AND
                                    PTE.IDSITTRIBENT       = ST.IDSITTRIBUTARIA AND
                                    PTE.TIPOSITTRIBENT     <> ST.TIPOSITTRIB
                                    )
                                    OR
                                    (
                                    PTE.TIPOSITTRIBSAI     <> 'A' AND
                                    PTE.IDSITTRIBSAI       = ST.IDSITTRIBUTARIA AND
                                    PTE.TIPOSITTRIBSAI     <> ST.TIPOSITTRIB
                                    )
                                )



                            UNION ALL


                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Algum dos campos de tributa��o nulo;' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UF,  PTE.UFORIGEM,  PTE.IDSITTRIBENT,  PTE.TIPOSITTRIBENT,  PTE.IDSITTRIBSAI,  PTE.PERICMENT,  PTE.PERREDTRIBENT,  PTE.TIPOSITTRIBSAI,  PTE.PERICMSAI,  PTE.PERREDTRIBSAI,  PTE.PERREDSUBTRIB,  PTE.PERICMSUBST,  PTE.VALBASESUBSTFIXA,  PTE.FLAGICMSGARANTIDO,  PTE.PERMARGEMSUBSTI,  PTE.PERMARGEMIVAMB,  PTE.DTALTERACAO,  PTE.PERANTINDENT,  PTE.PERANTCOMENT,  PTE.FLAGMARGEMBASESUBSTFIXA,  PTE.FLAGBASECREDSUBSTFIXA,  PTE.PERCUSTOADICIONAL,  PTE.PERDIFALIQICMINTEREST,  PTE.FLAGUTILIZABASEFIXA,  PTE.FLAGCONSIDERAMAIORBASEFIXA,  PTE.PERMARGEMSUBSTINDUSTRIA,  PTE.FLAGPROTOCOLOICMS107,  PTE.FLAGEVIDENCIA,  PTE.PERMARGEMSUBSTISAI,  PTE.PERCREDPRESUMIDOSAI,  PTE.PERCREDPRESUMIDOENT,  PTE.FLAGMARGEMSUBSTORIGINALSAI FROM   PRODUTO P, PRODUTO_GRADE               PG,     PRODUTO_TRIBUTACAO_ESTADO   PTE WHERE     PG.FLAGINATIVO      = ''F'' AND PG.IDPRODUTO = P.IDPRODUTO AND P.FLAGTRIBUTACAOGRUPO = ''F'' AND     PG.IDSUBPRODUTO     = PTE.IDSUBPRODUTO AND     (PTE.UF IS NULL OR     PTE.UFORIGEM IS NULL OR     PTE.IDSITTRIBENT IS NULL OR     PTE.TIPOSITTRIBENT IS NULL OR     PTE.IDSITTRIBSAI IS NULL OR     PTE.PERICMENT IS NULL OR     PTE.PERREDTRIBENT IS NULL OR     PTE.TIPOSITTRIBSAI IS NULL OR     PTE.PERICMSAI IS NULL OR     PTE.PERREDTRIBSAI IS NULL OR     PTE.PERREDSUBTRIB IS NULL OR     PTE.PERICMSUBST IS NULL OR     PTE.VALBASESUBSTFIXA IS NULL OR     PTE.FLAGICMSGARANTIDO IS NULL OR     PTE.PERMARGEMSUBSTI IS NULL OR     PTE.PERMARGEMIVAMB IS NULL OR     PTE.DTALTERACAO IS NULL OR     PTE.PERANTINDENT IS NULL OR     PTE.PERANTCOMENT IS NULL OR     PTE.FLAGMARGEMBASESUBSTFIXA IS NULL OR     PTE.FLAGBASECREDSUBSTFIXA IS NULL OR     PTE.PERCUSTOADICIONAL IS NULL OR     PTE.PERDIFALIQICMINTEREST IS NULL OR     PTE.FLAGUTILIZABASEFIXA IS NULL OR     PTE.FLAGCONSIDERAMAIORBASEFIXA IS NULL OR     PTE.PERMARGEMSUBSTINDUSTRIA IS NULL OR     PTE.FLAGPROTOCOLOICMS107 IS NULL OR     PTE.FLAGEVIDENCIA IS NULL OR     PTE.PERMARGEMSUBSTISAI IS NULL OR     PTE.PERCREDPRESUMIDOSAI IS NULL OR     PTE.PERCREDPRESUMIDOENT IS NULL OR     PTE.FLAGMARGEMSUBSTORIGINALSAI IS NULL)' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE
                            WHERE
                                PG.FLAGINATIVO                  = 'F' AND
                                PG.IDPRODUTO                    = P.IDPRODUTO AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F' AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO AND
                                (PTE.UF IS NULL OR
                                PTE.UFORIGEM IS NULL OR
                                PTE.IDSITTRIBENT IS NULL OR
                                PTE.TIPOSITTRIBENT IS NULL OR
                                PTE.IDSITTRIBSAI IS NULL OR
                                PTE.PERICMENT IS NULL OR
                                PTE.PERREDTRIBENT IS NULL OR
                                PTE.TIPOSITTRIBSAI IS NULL OR
                                PTE.PERICMSAI IS NULL OR
                                PTE.PERREDTRIBSAI IS NULL OR
                                PTE.PERREDSUBTRIB IS NULL OR
                                PTE.PERICMSUBST IS NULL OR
                                PTE.VALBASESUBSTFIXA IS NULL OR
                                PTE.FLAGICMSGARANTIDO IS NULL OR
                                PTE.PERMARGEMSUBSTI IS NULL OR
                                PTE.PERMARGEMIVAMB IS NULL OR
                                PTE.DTALTERACAO IS NULL OR
                                PTE.PERANTINDENT IS NULL OR
                                PTE.PERANTCOMENT IS NULL OR
                                PTE.FLAGMARGEMBASESUBSTFIXA IS NULL OR
                                PTE.FLAGBASECREDSUBSTFIXA IS NULL OR
                                PTE.PERCUSTOADICIONAL IS NULL OR
                                PTE.PERDIFALIQICMINTEREST IS NULL OR
                                PTE.FLAGUTILIZABASEFIXA IS NULL OR
                                PTE.FLAGCONSIDERAMAIORBASEFIXA IS NULL OR
                                PTE.PERMARGEMSUBSTINDUSTRIA IS NULL OR
                                PTE.FLAGPROTOCOLOICMS107 IS NULL OR
                                PTE.FLAGEVIDENCIA IS NULL OR
                                PTE.PERMARGEMSUBSTISAI IS NULL OR
                                PTE.PERCREDPRESUMIDOSAI IS NULL OR
                                PTE.PERCREDPRESUMIDOENT IS NULL OR
                                PTE.FLAGMARGEMSUBSTORIGINALSAI IS NULL)



                            UNION ALL


                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Produtos Substitui��o Tribut�ria sem % ICMS Substitui��o Tribut�ria;' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UFORIGEM, PTE.UF, PTE.TIPOSITTRIBENT, PTE.IDSITTRIBENT, PTE.PERICMENT, PTE.PERICMSUBST FROM  PRODUTO                         P, PRODUTO_GRADE                   PG, PRODUTO_TRIBUTACAO_ESTADO       PTE WHERE PG.IDPRODUTO                    = P.IDPRODUTO AND P.FLAGTRIBUTACAOGRUPO           = ''F'' AND PG.FLAGINATIVO                  = ''F'' AND  PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO AND ( PTE.PERICMSUBST                 = 0 OR PTE.PERICMSUBST                 IS NULL ) AND (PTE.TIPOSITTRIBENT             = ''F'' )' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE
                            WHERE
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO      AND
                                (
                                PTE.PERICMSUBST                 = 0 OR
                                PTE.PERICMSUBST                 IS NULL
                                ) AND
                                (PTE.TIPOSITTRIBENT             = 'F' )

                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Produtos Isentos com % ICMS;' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UFORIGEM, PTE.UF, PTE.TIPOSITTRIBENT, PTE.IDSITTRIBENT, PTE.PERICMENT, PTE.TIPOSITTRIBSAI, PTE.IDSITTRIBSAI, PTE.PERICMSAI FROM  PRODUTO  P,  PRODUTO_GRADE               PG,    PRODUTO_TRIBUTACAO_ESTADO   PTE WHERE PG.IDPRODUTO                    = P.IDPRODUTO  AND P.FLAGTRIBUTACAOGRUPO           = ''F'' AND PG.FLAGINATIVO                  = ''F''                   AND PG.IDPRODUTO                    = PTE.IDPRODUTO         AND PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO      AND ( ( PTE.TIPOSITTRIBENT      = ''I'' AND PTE.PERICMENT           > 0 ) OR ( PTE.TIPOSITTRIBSAI      = ''I'' AND PTE.PERICMSAI           > 0 ) ) ' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE
                            WHERE
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDPRODUTO                    = PTE.IDPRODUTO         AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO      AND
                                (
                                        (
                                                PTE.TIPOSITTRIBENT      = 'I' AND
                                                PTE.PERICMENT           > 0
                                        )
                                        OR
                                        (
                                                PTE.TIPOSITTRIBSAI      = 'I' AND
                                                PTE.PERICMSAI           > 0
                                        )
                                )


                            UNION ALL


                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Produtos Tributados sem % ICMS;' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UFORIGEM, PTE.UF, PTE.TIPOSITTRIBENT, PTE.IDSITTRIBENT, PTE.PERICMENT, PTE.TIPOSITTRIBSAI, PTE.IDSITTRIBSAI, PTE.PERICMSAI FROM  PRODUTO                         P,  PRODUTO_GRADE               PG,    PRODUTO_TRIBUTACAO_ESTADO   PTE WHERE    PG.IDPRODUTO = P.IDPRODUTO AND P.FLAGTRIBUTACAOGRUPO  = ''F''  AND  PG.FLAGINATIVO       = ''F'' AND     PG.IDSUBPRODUTO      = PTE.IDSUBPRODUTO AND     (((PTE.PERICMENT     = 0 OR PTE.PERICMENT IS NULL ) AND PTE.TIPOSITTRIBENT  = ''T'') OR     ((PTE.PERICMSAI      = 0 OR PTE.PERICMSAI IS NULL ) AND PTE.TIPOSITTRIBSAI  = ''T''))' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE
                            WHERE
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO      AND
                                (
                                        (
                                                (
                                                        PTE.PERICMENT   = 0 OR
                                                        PTE.PERICMENT   IS NULL
                                                 ) AND
                                                PTE.TIPOSITTRIBENT      = 'T'
                                        ) OR
                                        (
                                                (
                                                        PTE.PERICMSAI   = 0 OR
                                                        PTE.PERICMSAI   IS NULL
                                                ) AND
                                                PTE.TIPOSITTRIBSAI      = 'T'
                                        )
                                )


                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Produtos Substitui��o Tribut�ria sem % ICMS;' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UFORIGEM, PTE.UF, PTE.TIPOSITTRIBENT, PTE.IDSITTRIBENT, PTE.PERICMENT, PTE.TIPOSITTRIBSAI, PTE.IDSITTRIBSAI, PTE.PERICMSAI FROM PRODUTO                         P,   PRODUTO_GRADE               PG,    PRODUTO_TRIBUTACAO_ESTADO   PTE WHERE  PG.IDPRODUTO                    = P.IDPRODUTO           AND P.FLAGTRIBUTACAOGRUPO           = ''F''                   AND   PG.FLAGINATIVO       = ''F'' AND     PG.IDSUBPRODUTO      = PTE.IDSUBPRODUTO AND     (((PTE.PERICMENT     = 0 OR PTE.PERICMENT IS NULL ) AND PTE.TIPOSITTRIBENT  = ''F'') OR     ((PTE.PERICMSAI      = 0 OR PTE.PERICMSAI IS NULL ) AND PTE.TIPOSITTRIBSAI  = ''F''))' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE
                            WHERE
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO      AND
                                (((PTE.PERICMENT                = 0 OR PTE.PERICMENT IS NULL ) AND PTE.TIPOSITTRIBENT  = 'F') OR
                                ((PTE.PERICMSAI                 = 0 OR PTE.PERICMSAI IS NULL ) AND PTE.TIPOSITTRIBSAI  = 'F'))


                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Produtos Tributados;' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UFORIGEM, PTE.UF, PTE.TIPOSITTRIBENT, PTE.IDSITTRIBENT, PTE.TIPOSITTRIBSAI, PTE.IDSITTRIBSAI FROM  PRODUTO                         P,  PRODUTO_GRADE               PG,    PRODUTO_TRIBUTACAO_ESTADO   PTE WHERE  PG.IDPRODUTO                    = P.IDPRODUTO           AND P.FLAGTRIBUTACAOGRUPO           = ''F''                   AND   PG.FLAGINATIVO      = ''F'' AND     PG.IDSUBPRODUTO     = PTE.IDSUBPRODUTO AND     ( PTE.TIPOSITTRIBENT = ''T'' OR PTE.TIPOSITTRIBSAI = ''T'' )' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE
                            WHERE
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO      AND
                                (
                                PTE.TIPOSITTRIBENT              = 'T' OR
                                PTE.TIPOSITTRIBSAI              = 'T'
                                )


                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Produtos Isentos;' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UFORIGEM, PTE.UF, PTE.TIPOSITTRIBENT, PTE.IDSITTRIBENT, PTE.TIPOSITTRIBSAI, PTE.IDSITTRIBSAI FROM  PRODUTO                         P,  PRODUTO_GRADE               PG,    PRODUTO_TRIBUTACAO_ESTADO   PTE WHERE  PG.IDPRODUTO                    = P.IDPRODUTO           AND P.FLAGTRIBUTACAOGRUPO           = ''F''                   AND   PG.FLAGINATIVO      = ''F'' AND     PG.IDSUBPRODUTO     = PTE.IDSUBPRODUTO AND     ( PTE.TIPOSITTRIBENT = ''I'' OR PTE.TIPOSITTRIBSAI = ''I'' )' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE
                            WHERE
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO      AND
                                (
                                PTE.TIPOSITTRIBENT              = 'I' OR
                                PTE.TIPOSITTRIBSAI              = 'I'
                                )

                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Produtos Diferidos;' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UFORIGEM, PTE.UF, PTE.TIPOSITTRIBENT, PTE.IDSITTRIBENT, PTE.TIPOSITTRIBSAI, PTE.IDSITTRIBSAI FROM  PRODUTO                         P,  PRODUTO_GRADE               PG,    PRODUTO_TRIBUTACAO_ESTADO   PTE WHERE  PG.IDPRODUTO                    = P.IDPRODUTO           AND P.FLAGTRIBUTACAOGRUPO           = ''F''                   AND   PG.FLAGINATIVO      = ''F'' AND     PG.IDSUBPRODUTO     = PTE.IDSUBPRODUTO AND     ( PTE.TIPOSITTRIBENT = ''D'' OR PTE.TIPOSITTRIBSAI = ''D'' )' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE
                            WHERE
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO      AND
                                (
                                PTE.TIPOSITTRIBENT              = 'D' OR
                                PTE.TIPOSITTRIBSAI              = 'D'
                                )

                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Produtos Substitui��o Tribut�ria;' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UFORIGEM, PTE.UF, PTE.TIPOSITTRIBENT, PTE.IDSITTRIBENT, PTE.TIPOSITTRIBSAI, PTE.IDSITTRIBSAI FROM  PRODUTO                         P,  PRODUTO_GRADE               PG,    PRODUTO_TRIBUTACAO_ESTADO   PTE WHERE  PG.IDPRODUTO                    = P.IDPRODUTO           AND P.FLAGTRIBUTACAOGRUPO           = ''F''                   AND   PG.FLAGINATIVO      = ''F'' AND     PG.IDSUBPRODUTO     = PTE.IDSUBPRODUTO AND     ( PTE.TIPOSITTRIBENT = ''F'' OR PTE.TIPOSITTRIBSAI = ''F'' )' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE
                            WHERE
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO      AND
                                (
                                PTE.TIPOSITTRIBENT              = 'F' OR
                                PTE.TIPOSITTRIBSAI              = 'F'
                                )

                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Produtos Suspensos;' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UFORIGEM, PTE.UF, PTE.TIPOSITTRIBENT, PTE.IDSITTRIBENT, PTE.TIPOSITTRIBSAI, PTE.IDSITTRIBSAI FROM  PRODUTO                         P,  PRODUTO_GRADE               PG,    PRODUTO_TRIBUTACAO_ESTADO   PTE WHERE  PG.IDPRODUTO                    = P.IDPRODUTO           AND P.FLAGTRIBUTACAOGRUPO           = ''F''                   AND   PG.FLAGINATIVO      = ''F'' AND     PG.IDSUBPRODUTO     = PTE.IDSUBPRODUTO AND     ( PTE.TIPOSITTRIBENT = ''S'' OR PTE.TIPOSITTRIBSAI = ''S'' )' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE
                            WHERE
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO      AND
                                (
                                PTE.TIPOSITTRIBENT              = 'S' OR
                                PTE.TIPOSITTRIBSAI              = 'S'
                                )

                                UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Produtos Substitui��o Fronteira;' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UFORIGEM, PTE.UF, PTE.TIPOSITTRIBENT, PTE.IDSITTRIBENT, PTE.TIPOSITTRIBSAI, PTE.IDSITTRIBSAI FROM PRODUTO                         P,   PRODUTO_GRADE               PG,    PRODUTO_TRIBUTACAO_ESTADO   PTE WHERE  PG.IDPRODUTO                    = P.IDPRODUTO           AND P.FLAGTRIBUTACAOGRUPO           = ''F''                   AND   PG.FLAGINATIVO      = ''F'' AND     PG.IDSUBPRODUTO     = PTE.IDSUBPRODUTO AND     ( PTE.TIPOSITTRIBENT = ''A'' OR PTE.TIPOSITTRIBSAI = ''A'' )' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE
                            WHERE
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO      AND
                                (
                                PTE.TIPOSITTRIBENT              = 'A' OR
                                PTE.TIPOSITTRIBSAI              = 'A'
                                )


                            UNION ALL


                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | N�o existe tributa��o de entrada para o estado da empresa, mas existe para outros estados;' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO     FROM PRODUTO                         P, PRODUTO_GRADE                   PG WHERE PG.IDPRODUTO                    = P.IDPRODUTO           AND P.FLAGTRIBUTACAOGRUPO           = ''F''                   AND PG.FLAGINATIVO                  = ''F'' AND ( ( NOT EXISTS      (   SELECT  1 FROM    DBA.PRODUTO_TRIBUTACAO_ESTADO   PTE  WHERE   PTE.UFORIGEM                    = PTE.UF AND PG.IDPRODUTO                    = PTE.IDPRODUTO AND PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO ) OR EXISTS          ( SELECT  1 FROM    DBA.PRODUTO_TRIBUTACAO_ESTADO   PTE2 WHERE   PTE2.UFORIGEM                   = PTE2.UF AND PG.IDPRODUTO                    = PTE2.IDPRODUTO AND PG.IDSUBPRODUTO                 = PTE2.IDSUBPRODUTO AND ( PTE2.TIPOSITTRIBENT             IS NULL OR PTE2.IDSITTRIBENT               IS NULL ) ) ) AND ( EXISTS          ( SELECT  1 FROM    DBA.PRODUTO_TRIBUTACAO_ESTADO   PTE3 WHERE   PTE3.UFORIGEM                   <> PTE3.UF AND PG.IDPRODUTO                    = PTE3.IDPRODUTO AND PG.IDSUBPRODUTO                 = PTE3.IDSUBPRODUTO AND ( PTE3.TIPOSITTRIBENT             IS NOT NULL OR PTE3.IDSITTRIBENT               IS NOT NULL ) ) ) ) ' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG
                            WHERE
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                PG.FLAGINATIVO                  = 'F'                   AND
                                (
                                    (
                                    NOT EXISTS      (       -- N�o existe registro de tributa��o no estado
                                                            SELECT  1
                                                            FROM    DBA.PRODUTO_TRIBUTACAO_ESTADO   PTE
                                                            WHERE   PTE.UFORIGEM                    = PTE.UF AND
                                                                    PG.IDPRODUTO                    = PTE.IDPRODUTO AND
                                                                    PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO
                                                    )

                                                    OR

                                    EXISTS          (       -- Ou existe registro, por�m sem entrada
                                                            SELECT  1
                                                            FROM    DBA.PRODUTO_TRIBUTACAO_ESTADO   PTE2
                                                            WHERE   PTE2.UFORIGEM                   = PTE2.UF AND
                                                                    PG.IDPRODUTO                    = PTE2.IDPRODUTO AND
                                                                    PG.IDSUBPRODUTO                 = PTE2.IDSUBPRODUTO AND
                                                                    (
                                                                    PTE2.TIPOSITTRIBENT             IS NULL OR
                                                                    PTE2.IDSITTRIBENT               IS NULL
                                                                    )
                                                    )
                                    )

                                    AND

                                    (
                                    EXISTS          (       -- Mas existe tributa��o de entrada para outros estados
                                                            SELECT  1
                                                            FROM    DBA.PRODUTO_TRIBUTACAO_ESTADO   PTE3
                                                            WHERE   PTE3.UFORIGEM                   <> PTE3.UF AND
                                                                    PG.IDPRODUTO                    = PTE3.IDPRODUTO AND
                                                                    PG.IDSUBPRODUTO                 = PTE3.IDSUBPRODUTO AND
                                                                    (
                                                                    PTE3.TIPOSITTRIBENT             IS NOT NULL OR
                                                                    PTE3.IDSITTRIBENT               IS NOT NULL
                                                                    )
                                                    )
                                    )

                                )


                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Produtos que entram com um Tipo de Situa��o Tribut�ria e saem com outra (Dentro do estado);' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UFORIGEM, PTE.UF, PTE.TIPOSITTRIBENT, PTE.IDSITTRIBENT, PTE.TIPOSITTRIBSAI, PTE.IDSITTRIBSAI FROM                                  PRODUTO                         P,  PRODUTO_GRADE               PG,    PRODUTO_TRIBUTACAO_ESTADO   PTE WHERE PG.IDPRODUTO                    = P.IDPRODUTO           AND P.FLAGTRIBUTACAOGRUPO           = ''F''                   AND  PG.FLAGINATIVO                  = ''F'' AND PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO AND PTE.UFORIGEM                    = PTE.UF AND PTE.TIPOSITTRIBENT              IS NOT NULL AND PTE.TIPOSITTRIBSAI              IS NOT NULL AND PTE.TIPOSITTRIBENT              <> PTE.TIPOSITTRIBSAI' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE
                            WHERE
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO      AND
                                PTE.UFORIGEM                    = PTE.UF                AND
                                PTE.TIPOSITTRIBENT              IS NOT NULL             AND
                                PTE.TIPOSITTRIBSAI              IS NOT NULL             AND
                                PTE.TIPOSITTRIBENT              <> PTE.TIPOSITTRIBSAI


                            UNION ALL


                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Produtos que entram com um Tipo de Situa��o Tribut�ria e saem com outra (Fora do estado);' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UFORIGEM, PTE.UF, PTE.TIPOSITTRIBENT, PTE.IDSITTRIBENT, PTE.TIPOSITTRIBSAI, PTE.IDSITTRIBSAI FROM                                 PRODUTO                         P,   PRODUTO_GRADE               PG,    PRODUTO_TRIBUTACAO_ESTADO   PTE WHERE  PG.IDPRODUTO                    = P.IDPRODUTO           AND P.FLAGTRIBUTACAOGRUPO           = ''F''                   AND PG.FLAGINATIVO                  = ''F'' AND PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO AND PTE.UFORIGEM                    <> PTE.UF AND PTE.TIPOSITTRIBENT              IS NOT NULL AND PTE.TIPOSITTRIBSAI              IS NOT NULL AND PTE.TIPOSITTRIBENT              <> PTE.TIPOSITTRIBSAI' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE
                            WHERE
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO      AND
                                PTE.UFORIGEM                    <> PTE.UF               AND
                                PTE.TIPOSITTRIBENT              IS NOT NULL             AND
                                PTE.TIPOSITTRIBSAI              IS NOT NULL             AND
                                PTE.TIPOSITTRIBENT              <> PTE.TIPOSITTRIBSAI

                            UNION ALL


                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Existe tributa��o de entrada mas n�o existe de sa�da (Dentro do estado);' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UFORIGEM, PTE.UF, PTE.TIPOSITTRIBENT, PTE.IDSITTRIBENT, PTE.PERICMENT, PTE.TIPOSITTRIBSAI, PTE.IDSITTRIBSAI, PTE.PERICMSAI FROM                                  PRODUTO                         P,  PRODUTO_GRADE               PG,    PRODUTO_TRIBUTACAO_ESTADO   PTE WHERE PG.IDPRODUTO                    = P.IDPRODUTO           AND P.FLAGTRIBUTACAOGRUPO           = ''F''                   AND PG.FLAGINATIVO                  = ''F'' AND PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO AND PTE.UFORIGEM                    = PTE.UF AND ( PTE.TIPOSITTRIBENT              IS NOT NULL OR PTE.IDSITTRIBENT                IS NOT NULL ) AND ( PTE.TIPOSITTRIBSAI              IS NULL OR PTE.IDSITTRIBSAI                IS NULL ) ' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE
                            WHERE
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO      AND
                                PTE.UFORIGEM                    = PTE.UF                AND
                                (
                                PTE.TIPOSITTRIBENT              IS NOT NULL OR
                                PTE.IDSITTRIBENT                IS NOT NULL
                                )
                                AND
                                (
                                PTE.TIPOSITTRIBSAI              IS NULL OR
                                PTE.IDSITTRIBSAI                IS NULL
                                )

                            UNION ALL



                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal (Federal) | PIS/COFINS de Sa�da sem C�digo de Natureza da Receita;' AS Descricao,
                                'SELECT  P.IDPRODUTO, P.DESCRCOMPRODUTO, P.IDCSTPISCOFINSSAIDA, STPC.DESCRCSTPISCOFINS FROM PRODUTO                         P, PRODUTO_GRADE                   PG, SITUACAO_TRIBUTARIA_PISCOFINS   STPC WHERE PG.FLAGINATIVO                  = ''F'' AND PG.IDPRODUTO                    = P.IDPRODUTO AND P.FLAGTRIBUTACAOGRUPO           = ''F''                   AND P.IDCSTPISCOFINSSAIDA           IN(4, 5, 6, 7, 8, 9) AND P.IDNATUREZAPISCOFINS           IS NULL AND P.IDCSTPISCOFINSSAIDA           = STPC.IDCSTPISCOFINS' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                SITUACAO_TRIBUTARIA_PISCOFINS   STPC
                            WHERE
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                P.IDCSTPISCOFINSSAIDA           IN(4, 5, 6, 7, 8, 9)    AND
                                P.IDNATUREZAPISCOFINS           IS NULL                 AND
                                P.IDCSTPISCOFINSSAIDA           = STPC.IDCSTPISCOFINS

                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal (Federal) | C�digo de Natureza da Receita que n�o pertence ao CST de PIS/COFINS de Sa�da;' AS Descricao,
                                'SELECT P.IDPRODUTO, P.DESCRCOMPRODUTO, P.IDCSTPISCOFINSSAIDA, STPC.DESCRCSTPISCOFINS, P.IDNATUREZAPISCOFINS FROM PRODUTO                         P, PRODUTO_GRADE                   PG, SITUACAO_TRIBUTARIA_PISCOFINS   STPC WHERE PG.FLAGINATIVO                  = ''F'' AND PG.IDPRODUTO                    = P.IDPRODUTO AND P.FLAGTRIBUTACAOGRUPO           = ''F''                   AND P.IDNATUREZAPISCOFINS           IS NOT NULL AND P.IDCSTPISCOFINSSAIDA           = STPC.IDCSTPISCOFINS AND NOT EXISTS                      (       SELECT  1 FROM    PISCOFINS_CODIGO_NATUREZA_RECEITA       PCCNR WHERE   PCCNR.IDCSTPISCOFINS                    = P.IDCSTPISCOFINSSAIDA AND PCCNR.IDNATUREZAPISCOFINS               = P.IDNATUREZAPISCOFINS )' AS QUERY

                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                SITUACAO_TRIBUTARIA_PISCOFINS   STPC
                            WHERE
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                P.IDNATUREZAPISCOFINS           IS NOT NULL             AND
                                P.IDCSTPISCOFINSSAIDA           = STPC.IDCSTPISCOFINS   AND
                                NOT EXISTS                      (       SELECT  1
                                                                        FROM    PISCOFINS_CODIGO_NATUREZA_RECEITA       PCCNR
                                                                        WHERE   PCCNR.IDCSTPISCOFINS                    = P.IDCSTPISCOFINSSAIDA AND
                                                                                PCCNR.IDNATUREZAPISCOFINS               = P.IDNATUREZAPISCOFINS

                                                                )


                            UNION ALL


                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Existe tributa��o de entrada mas n�o existe de sa�da (Fora do estado);' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UFORIGEM, PTE.UF, PTE.TIPOSITTRIBENT, PTE.IDSITTRIBENT, PTE.PERICMENT, PTE.TIPOSITTRIBSAI, PTE.IDSITTRIBSAI, PTE.PERICMSAI FROM  PRODUTO                         P,  PRODUTO_GRADE               PG,    PRODUTO_TRIBUTACAO_ESTADO   PTE WHERE PG.IDPRODUTO                    = P.IDPRODUTO           AND P.FLAGTRIBUTACAOGRUPO           = ''F''                   AND  PG.FLAGINATIVO                  = ''F'' AND PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO AND PTE.UFORIGEM                    <> PTE.UF AND ( PTE.TIPOSITTRIBENT              IS NOT NULL OR PTE.IDSITTRIBENT                IS NOT NULL ) AND ( PTE.TIPOSITTRIBSAI              IS NULL OR PTE.IDSITTRIBSAI                IS NULL ) ' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE
                            WHERE
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO      AND
                                PTE.UFORIGEM                    <> PTE.UF               AND
                                (
                                PTE.TIPOSITTRIBENT              IS NOT NULL     OR
                                PTE.IDSITTRIBENT                IS NOT NULL
                                )
                                AND
                                (
                                PTE.TIPOSITTRIBSAI              IS NULL         OR
                                PTE.IDSITTRIBSAI                IS NULL
                                )


                            UNION ALL


                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Existe tributa��o de sa�da mas n�o existe de entrada (Dentro do estado);' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UFORIGEM, PTE.UF, PTE.TIPOSITTRIBENT, PTE.IDSITTRIBENT, PTE.PERICMENT, PTE.TIPOSITTRIBSAI, PTE.IDSITTRIBSAI, PTE.PERICMSAI FROM  PRODUTO                         P,  PRODUTO_GRADE               PG,    PRODUTO_TRIBUTACAO_ESTADO   PTE WHERE PG.IDPRODUTO                    = P.IDPRODUTO           AND P.FLAGTRIBUTACAOGRUPO           = ''F''                   AND  PG.FLAGINATIVO                  = ''F'' AND PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO AND PTE.UFORIGEM                    = PTE.UF AND ( PTE.TIPOSITTRIBENT              IS  NULL OR PTE.IDSITTRIBENT                IS  NULL ) AND ( PTE.TIPOSITTRIBSAI              IS NOT NULL OR PTE.IDSITTRIBSAI                IS NOT NULL ) ' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE
                            WHERE
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO      AND
                                PTE.UFORIGEM                    = PTE.UF                AND
                                (
                                PTE.TIPOSITTRIBENT              IS NULL         OR
                                PTE.IDSITTRIBENT                IS NULL
                                )
                                AND
                                (
                                PTE.TIPOSITTRIBSAI              IS NOT NULL     OR
                                PTE.IDSITTRIBSAI                IS NOT NULL
                                )


                            UNION ALL


                            SELECT
                                COUNT(*) Total,
                                'Tributa��o normal | Existe tributa��o de sa�da mas n�o existe de entrada (Fora do estado);' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PTE.UFORIGEM, PTE.UF, PTE.TIPOSITTRIBENT, PTE.IDSITTRIBENT, PTE.PERICMENT, PTE.TIPOSITTRIBSAI, PTE.IDSITTRIBSAI, PTE.PERICMSAI FROM  PRODUTO                         P,  PRODUTO_GRADE               PG,    PRODUTO_TRIBUTACAO_ESTADO   PTE WHERE PG.IDPRODUTO                    = P.IDPRODUTO           AND P.FLAGTRIBUTACAOGRUPO           = ''F''                   AND  PG.FLAGINATIVO                  = ''F'' AND PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO AND PTE.UFORIGEM                    <> PTE.UF AND ( PTE.TIPOSITTRIBENT              IS  NULL OR PTE.IDSITTRIBENT                IS  NULL ) AND ( PTE.TIPOSITTRIBSAI              IS NOT NULL OR PTE.IDSITTRIBSAI                IS NOT NULL ) ' AS QUERY
                            FROM
                                PRODUTO                         P,
                                PRODUTO_GRADE                   PG,
                                PRODUTO_TRIBUTACAO_ESTADO       PTE
                            WHERE
                                PG.IDPRODUTO                    = P.IDPRODUTO           AND
                                P.FLAGTRIBUTACAOGRUPO           = 'F'                   AND
                                PG.FLAGINATIVO                  = 'F'                   AND
                                PG.IDSUBPRODUTO                 = PTE.IDSUBPRODUTO      AND
                                PTE.UFORIGEM                    <> PTE.UF               AND
                                (
                                PTE.TIPOSITTRIBENT              IS NULL         OR
                                PTE.IDSITTRIBENT                IS NULL
                                )
                                AND
                                (
                                PTE.TIPOSITTRIBSAI              IS NOT NULL     OR
                                PTE.IDSITTRIBSAI                IS NOT NULL
                                )



                            UNION ALL

                            -- Lote
                            SELECT
                                COUNT(*) Total,
                                'Lotes | Produtos marcado para usar lote, por�m n�o tem lote;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PG.FLAGLOTE FROM PRODUTO_GRADE PG WHERE PG.FLAGINATIVO = ''F'' AND PG.FLAGLOTE = ''T'' AND PG.IDSUBPRODUTO NOT IN(SELECT PGL.IDSUBPRODUTO FROM DBA.PRODUTO_GRADE_LOTE PGL)' AS QUERY
                            FROM
                                PRODUTO_GRADE PG
                            WHERE
                                PG.FLAGINATIVO = 'F' AND
                                PG.FLAGLOTE = 'T' AND
                                PG.IDSUBPRODUTO NOT IN(SELECT PGL.IDSUBPRODUTO FROM DBA.PRODUTO_GRADE_LOTE PGL)

                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Lotes | Produtos que tem lote, por�m n�o est�o marcados para user lote;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PG.FLAGLOTE, PGL.IDLOTE FROM PRODUTO_GRADE PG, PRODUTO_GRADE_LOTE PGL WHERE PG.FLAGINATIVO = ''F'' AND PG.FLAGLOTE = ''F'' AND PG.IDSUBPRODUTO = PGL.IDSUBPRODUTO' AS QUERY
                            FROM
                                PRODUTO_GRADE PG,
                                PRODUTO_GRADE_LOTE PGL
                            WHERE
                                PG.FLAGINATIVO  = 'F' AND
                                PG.FLAGLOTE     = 'F' AND
                                PG.IDSUBPRODUTO = PGL.IDSUBPRODUTO

                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Lotes | Existe movimenta��o de estoque com e sem lote;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO FROM PRODUTO_GRADE PG WHERE PG.FLAGINATIVO  = ''F'' AND EXISTS          (       SELECT  1 FROM    DBA.ESTOQUE_ANALITICO   EA1  WHERE   EA1.IDPRODUTO           = PG.IDPRODUTO          AND EA1.IDSUBPRODUTO        = PG.IDSUBPRODUTO       AND EA1.IDLOTE              IS NULL  ) AND EXISTS          (       SELECT  1 FROM    DBA.ESTOQUE_ANALITICO   EA2 WHERE   EA2.IDPRODUTO           = PG.IDPRODUTO          AND EA2.IDSUBPRODUTO        = PG.IDSUBPRODUTO       AND EA2.IDLOTE              IS NOT NULL )' AS QUERY
                            FROM
                                PRODUTO_GRADE PG
                            WHERE
                                PG.FLAGINATIVO  = 'F' AND
                                EXISTS          (       SELECT  1
                                                        FROM    DBA.ESTOQUE_ANALITICO   EA1
                                                        WHERE   EA1.IDPRODUTO           = PG.IDPRODUTO          AND
                                                                EA1.IDSUBPRODUTO        = PG.IDSUBPRODUTO       AND
                                                                EA1.IDLOTE              IS NULL
                                                ) AND
                                EXISTS          (       SELECT  1
                                                        FROM    DBA.ESTOQUE_ANALITICO   EA2
                                                        WHERE   EA2.IDPRODUTO           = PG.IDPRODUTO          AND
                                                                EA2.IDSUBPRODUTO        = PG.IDSUBPRODUTO       AND
                                                                EA2.IDLOTE              IS NOT NULL
                                                )

                            UNION ALL

                            -- Balan�o
                            SELECT
                                COUNT(*) Total,
                                'Balan�o | Produtos lan�ados no balan�o sem custo informado;' AS Descricao,
                                '        SELECT                                                                 ' ||
                                '                PG.IDPRODUTO,                                                  ' ||
                                '                PG.IDSUBPRODUTO,                                               ' ||
                                '                PG.DESCRRESPRODUTO,                                            ' ||
                                '                EB.QTDCONTADA "QUANTIDADE (BALANCO)",                          ' ||
                                '                EB.CUSTOUNITARIO "CUSTO (BALANCO)",                            ' ||
                                '                EB.IDEMPRESA "IDEMPRESA (BALANCO)",                            ' ||
                                '                E.RAZAOSOCIAL,                                                 ' ||
                                '                EB.IDLOCALESTOQUE "IDLOCALESTOQUE (BALANCO)",                  ' ||
                                '                ECL.DESCRLOCAL,                                                ' ||
                                '                EB.IDPLANILHA "IDPLANILHA (BALANCO)"                           ' ||
                                '        FROM                                                                   ' ||
                                '                DBA.ESTOQUE_BALANCO             EB,                            ' ||
                                '                DBA.PRODUTO_GRADE               PG,                            ' ||
                                '                DBA.EMPRESA                     E,                             ' ||
                                '                DBA.ESTOQUE_CADASTRO_LOCAL      ECL                            ' ||
                                '        WHERE                                                                  ' ||
                                '                PG.FLAGINATIVO                  = ''F''                 AND    ' ||
                                '                PG.IDPRODUTO                    = EB.IDPRODUTO          AND    ' ||
                                '                PG.IDSUBPRODUTO                 = EB.IDSUBPRODUTO       AND    ' ||
                                '                ECL.IDLOCALESTOQUE              = EB.IDLOCALESTOQUE     AND    ' ||
                                '                E.IDEMPRESA                     = EB.IDEMPRESA          AND    ' ||
                                '                (                                                              ' ||
                                '                EB.CUSTOUNITARIO                <= 0 OR                        ' ||
                                '                EB.CUSTOUNITARIO                IS NULL                        ' ||
                                '                )                                                              ' ||
                                '        ORDER BY                                                               ' ||
                                '                PG.IDPRODUTO,                                                  ' ||
                                '                PG.IDSUBPRODUTO                                                '
                                 AS QUERY
                            FROM
                                PRODUTO_GRADE           PG,
                                ESTOQUE_BALANCO         EB
                            WHERE
                                PG.FLAGINATIVO          = 'F' AND
                                PG.IDSUBPRODUTO         = EB.IDSUBPRODUTO AND
                                (
                                EB.CUSTOUNITARIO        <= 0 OR
                                EB.CUSTOUNITARIO        IS NULL
                                )

                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Balan�o | Produtos lan�ados no balan�o e inativos no sistema;' AS Descricao,
                                'SELECT  PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, EB.QTDCONTADA "QUANTIDADE (BALANCO)", EB.CUSTOUNITARIO "CUSTO (BALANCO)", EB.IDEMPRESA "IDEMPRESA (BALANCO)", E.RAZAOSOCIAL, EB.IDLOCALESTOQUE "IDLOCALESTOQUE (BALANCO)", ECL.DESCRLOCAL, EB.IDPLANILHA "IDPLANILHA (BALANCO)" FROM    PRODUTO_GRADE PG, ESTOQUE_BALANCO EB, EMPRESA E, ESTOQUE_CADASTRO_LOCAL ECL WHERE   PG.FLAGINATIVO = ''T'' AND PG.IDSUBPRODUTO = EB.IDSUBPRODUTO AND EB.IDEMPRESA = E.IDEMPRESA AND EB.IDLOCALESTOQUE = ECL.IDLOCALESTOQUE ORDER BY PG.IDPRODUTO, PG.IDSUBPRODUTO' AS QUERY
                            FROM
                                PRODUTO_GRADE           PG,
                                ESTOQUE_BALANCO         EB
                            WHERE
                                PG.FLAGINATIVO          = 'T' AND
                                PG.IDSUBPRODUTO         = EB.IDSUBPRODUTO

                            UNION ALL

                            -- Lote e Balan�o
                            SELECT
                                COUNT(*) Total,
                                'Lotes e Balan�o | Produtos que tem lote no balan�o, por�m n�o est�o marcados para user lote;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PG.FLAGLOTE, EB.IDEMPRESA "IDEMPRESA (BALANCO)", EB.IDLOCALESTOQUE "IDLOCALESTOQUE (BALANCO)", EB.IDPLANILHA "IDPLANILHA (BALANCO)", EB.IDLOTE "IDLOTE (BALANCO)" FROM PRODUTO_GRADE PG, ESTOQUE_BALANCO EB WHERE PG.FLAGINATIVO = ''F'' AND PG.FLAGLOTE = ''F'' AND PG.IDSUBPRODUTO = EB.IDSUBPRODUTO AND EB.IDLOTE IS NOT NULL' AS QUERY
                            FROM
                                PRODUTO_GRADE PG,
                                ESTOQUE_BALANCO EB
                            WHERE
                                PG.FLAGINATIVO  = 'F' AND
                                PG.FLAGLOTE     = 'F' AND
                                PG.IDSUBPRODUTO = EB.IDSUBPRODUTO AND
                                EB.IDLOTE       IS NOT NULL

                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Lotes e Balan�o | Produtos que tem lote no balan�o, por�m o lote n�o existe;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PG.FLAGLOTE, EB.IDEMPRESA "IDEMPRESA (BALANCO)", EB.IDLOCALESTOQUE "IDLOCALESTOQUE (BALANCO)", EB.IDPLANILHA "IDPLANILHA (BALANCO)", EB.IDLOTE "IDLOTE (BALANCO)" FROM PRODUTO_GRADE PG, ESTOQUE_BALANCO EB WHERE PG.FLAGINATIVO = ''F'' AND PG.IDSUBPRODUTO = EB.IDSUBPRODUTO AND EB.IDLOTE IS NOT NULL AND NOT EXISTS      (SELECT 1 FROM    PRODUTO_GRADE_LOTE PGL WHERE   PGL.IDLOTE = EB.IDLOTE AND PGL.IDSUBPRODUTO = EB.IDSUBPRODUTO)' AS QUERY
                            FROM
                                PRODUTO_GRADE PG,
                                ESTOQUE_BALANCO EB
                            WHERE
                                PG.FLAGINATIVO  = 'F' AND
                                PG.IDSUBPRODUTO = EB.IDSUBPRODUTO AND
                                EB.IDLOTE       IS NOT NULL AND
                                NOT EXISTS      (SELECT 1
                                                FROM    PRODUTO_GRADE_LOTE PGL
                                                WHERE   PGL.IDLOTE = EB.IDLOTE AND
                                                        PGL.IDSUBPRODUTO = EB.IDSUBPRODUTO)

                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Lotes e Balan�o | Produtos marcados para usar lote, por�m o lote n�o est� informado no balan�o;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PG.FLAGLOTE, EB.IDEMPRESA "IDEMPRESA (BALANCO)", EB.IDLOCALESTOQUE "IDLOCALESTOQUE (BALANCO)", EB.IDPLANILHA "IDPLANILHA (BALANCO)", EB.IDLOTE "IDLOTE (BALANCO)" FROM PRODUTO_GRADE PG, ESTOQUE_BALANCO EB WHERE PG.FLAGINATIVO = ''F'' AND PG.FLAGLOTE = ''T'' AND PG.IDSUBPRODUTO = EB.IDSUBPRODUTO AND EB.IDLOTE IS NULL' AS QUERY
                            FROM
                                PRODUTO_GRADE PG,
                                ESTOQUE_BALANCO EB
                            WHERE
                                PG.FLAGINATIVO  = 'F' AND
                                PG.FLAGLOTE     = 'T' AND
                                PG.IDSUBPRODUTO = EB.IDSUBPRODUTO AND
                                EB.IDLOTE       IS NULL


                            UNION ALL


                            -- Lotes e Mapa de Endere�amento
                            SELECT
                                COUNT(*) Total,
                                'Lotes e Mapa de Endere�amento | Produtos que tem lote no endere�amento, por�m n�o est�o marcados para usar lote;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PG.FLAGLOTE, PMEL.IDLOTE FROM DBA.PRODUTO_GRADE               PG, DBA.PRODUTO_MAPA_ENDERECO_LOTE  PMEL WHERE PG.FLAGINATIVO                  = ''F'' AND PG.FLAGLOTE                     = ''F'' AND PG.IDPRODUTO                    = PMEL.IDPRODUTO AND PG.IDSUBPRODUTO                 = PMEL.IDSUBPRODUTO AND  PMEL.IDLOTE                     IS NOT NULL ' AS QUERY
                            FROM
                                DBA.PRODUTO_GRADE               PG,
                                DBA.PRODUTO_MAPA_ENDERECO_LOTE  PMEL
                            WHERE
                                PG.FLAGINATIVO                  = 'F' AND
                                PG.FLAGLOTE                     = 'F' AND
                                PG.IDPRODUTO                    = PMEL.IDPRODUTO AND
                                PG.IDSUBPRODUTO                 = PMEL.IDSUBPRODUTO AND
                                PMEL.IDLOTE                     IS NOT NULL

                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Lotes e Mapa de Endere�amento | Produtos que tem lote no endere�amento, por�m o lote n�o existe;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO, PMEL.IDLOTE FROM DBA.PRODUTO_GRADE               PG, DBA.PRODUTO_MAPA_ENDERECO_LOTE  PMEL WHERE PG.FLAGINATIVO                  = ''F'' AND PG.IDPRODUTO                    = PMEL.IDPRODUTO AND PG.IDSUBPRODUTO                 = PMEL.IDSUBPRODUTO AND PMEL.IDLOTE                     IS NOT NULL AND NOT EXISTS                      (       SELECT 1 FROM    PRODUTO_GRADE_LOTE      PGL WHERE   PGL.IDLOTE              = PMEL.IDLOTE AND PGL.IDPRODUTO           = PMEL.IDPRODUTO AND PGL.IDSUBPRODUTO        = PMEL.IDSUBPRODUTO ) ' AS QUERY
                            FROM
                                DBA.PRODUTO_GRADE               PG,
                                DBA.PRODUTO_MAPA_ENDERECO_LOTE  PMEL
                            WHERE
                                PG.FLAGINATIVO                  = 'F' AND
                                PG.IDPRODUTO                    = PMEL.IDPRODUTO AND
                                PG.IDSUBPRODUTO                 = PMEL.IDSUBPRODUTO AND
                                PMEL.IDLOTE                     IS NOT NULL AND
                                NOT EXISTS                      (       SELECT 1
                                                                        FROM    PRODUTO_GRADE_LOTE      PGL
                                                                        WHERE   PGL.IDLOTE              = PMEL.IDLOTE AND
                                                                                PGL.IDPRODUTO           = PMEL.IDPRODUTO AND
                                                                                PGL.IDSUBPRODUTO        = PMEL.IDSUBPRODUTO
                                                                )


                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Lotes e Mapa de Endere�amento | Produtos que est�o marcados para usar lote, por�m n�o tem lote no endere�amento;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO FROM DBA.PRODUTO_GRADE               PG WHERE PG.FLAGINATIVO                  = ''F'' AND PG.FLAGLOTE                     = ''T'' AND NOT EXISTS                      (       SELECT  1 FROM    DBA.PRODUTO_MAPA_ENDERECO_LOTE  PMEL WHERE   PG.IDPRODUTO                    = PMEL.IDPRODUTO AND PG.IDSUBPRODUTO                 = PMEL.IDSUBPRODUTO ) AND EXISTS (       SELECT  1 FROM    DBA.PRODUTO_MAPA_ENDERECO       PME WHERE   PG.IDPRODUTO                    = PME.IDPRODUTO AND PG.IDSUBPRODUTO                 = PME.IDSUBPRODUTO ) ' AS QUERY
                            FROM
                                DBA.PRODUTO_GRADE               PG
                            WHERE
                                PG.FLAGINATIVO                  = 'F' AND
                                PG.FLAGLOTE                     = 'T' AND
                                NOT EXISTS                      (       SELECT  1
                                                                        FROM    DBA.PRODUTO_MAPA_ENDERECO_LOTE  PMEL
                                                                        WHERE   PG.IDPRODUTO                    = PMEL.IDPRODUTO AND
                                                                                PG.IDSUBPRODUTO                 = PMEL.IDSUBPRODUTO
                                                                ) AND
                                EXISTS                          (       SELECT  1
                                                                        FROM    DBA.PRODUTO_MAPA_ENDERECO       PME
                                                                        WHERE   PG.IDPRODUTO                    = PME.IDPRODUTO AND
                                                                                PG.IDSUBPRODUTO                 = PME.IDSUBPRODUTO
                                                                )


                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Lotes e Mapa de Endere�amento | Existe endere�amento com lote marcado como endere�o padr�o, por�m o endere�o n�o est� marcado como padr�o;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO FROM DBA.PRODUTO_GRADE               PG WHERE PG.FLAGINATIVO                  = ''F'' AND EXISTS                          (       SELECT  1 FROM    DBA.PRODUTO_MAPA_ENDERECO_LOTE  PMEL WHERE   PG.IDPRODUTO                    = PMEL.IDPRODUTO        AND PG.IDSUBPRODUTO                 = PMEL.IDSUBPRODUTO     AND PMEL.FLAGPADRAO                 = ''T''                   AND NOT EXISTS                      (   SELECT  1 FROM    DBA.PRODUTO_MAPA_ENDERECO           PME WHERE   PMEL.IDPRODUTO                      = PME.IDPRODUTO         AND PMEL.IDSUBPRODUTO                   = PME.IDSUBPRODUTO      AND PMEL.IDEMPRESA                      = PME.IDEMPRESA         AND PMEL.IDBAIRRO                       = PME.IDBAIRRO          AND PMEL.IDRUA                          = PME.IDRUA             AND  PMEL.IDBLOCO                        = PME.IDBLOCO           AND  PMEL.IDNIVEL                        = PME.IDNIVEL           AND PME.FLAGPADRAO                      = ''T'' )  ) ' AS QUERY
                            FROM
                                DBA.PRODUTO_GRADE               PG
                            WHERE
                                PG.FLAGINATIVO                  = 'F' AND
                                EXISTS                          (       SELECT  1
                                                                        FROM    DBA.PRODUTO_MAPA_ENDERECO_LOTE  PMEL
                                                                        WHERE   PG.IDPRODUTO                    = PMEL.IDPRODUTO        AND
                                                                                PG.IDSUBPRODUTO                 = PMEL.IDSUBPRODUTO     AND
                                                                                PMEL.FLAGPADRAO                 = 'T'                   AND
                                                                                NOT EXISTS                      (   SELECT  1
                                                                                                                    FROM    DBA.PRODUTO_MAPA_ENDERECO           PME
                                                                                                                    WHERE   PMEL.IDPRODUTO                      = PME.IDPRODUTO         AND
                                                                                                                            PMEL.IDSUBPRODUTO                   = PME.IDSUBPRODUTO      AND
                                                                                                                            PMEL.IDEMPRESA                      = PME.IDEMPRESA         AND
                                                                                                                            PMEL.IDBAIRRO                       = PME.IDBAIRRO          AND
                                                                                                                            PMEL.IDRUA                          = PME.IDRUA             AND
                                                                                                                            PMEL.IDBLOCO                        = PME.IDBLOCO           AND
                                                                                                                            PMEL.IDNIVEL                        = PME.IDNIVEL           AND
                                                                                                                            PME.FLAGPADRAO                      = 'T'
                                                                                                                )
                                                                )

                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Lotes e Mapa de Endere�amento | Existe endere�amento marcado como padr�o, por�m n�o existe nenhum endere�o de lote padr�o;' AS Descricao,
                                'SELECT PG.IDPRODUTO, PG.IDSUBPRODUTO, PG.DESCRRESPRODUTO FROM  DBA.PRODUTO_GRADE               PG WHERE PG.FLAGINATIVO                  = ''F'' AND EXISTS                          (       SELECT  1 FROM    DBA.PRODUTO_MAPA_ENDERECO       PME WHERE   PG.IDPRODUTO                    = PME.IDPRODUTO        AND PG.IDSUBPRODUTO                 = PME.IDSUBPRODUTO     AND PME.FLAGPADRAO                  = ''T''                  AND NOT EXISTS                      (   SELECT  1 FROM    DBA.PRODUTO_MAPA_ENDERECO_LOTE      PMEL WHERE   PMEL.IDPRODUTO                      = PME.IDPRODUTO         AND PMEL.IDSUBPRODUTO                   = PME.IDSUBPRODUTO      AND PMEL.IDEMPRESA                      = PME.IDEMPRESA         AND PMEL.IDBAIRRO                       = PME.IDBAIRRO          AND PMEL.IDRUA                          = PME.IDRUA             AND PMEL.IDBLOCO                        = PME.IDBLOCO           AND PMEL.IDNIVEL                        = PME.IDNIVEL           AND PMEL.FLAGPADRAO                     = ''T'' )                       AND EXISTS                          (   SELECT  1 FROM    DBA.PRODUTO_MAPA_ENDERECO_LOTE      PMEL WHERE   PMEL.IDPRODUTO                      = PME.IDPRODUTO         AND PMEL.IDSUBPRODUTO                   = PME.IDSUBPRODUTO      AND PMEL.IDEMPRESA                      = PME.IDEMPRESA         AND PMEL.IDBAIRRO                       = PME.IDBAIRRO          AND PMEL.IDRUA                          = PME.IDRUA             AND PMEL.IDBLOCO                        = PME.IDBLOCO           AND PMEL.IDNIVEL                        = PME.IDNIVEL ) ) ' AS QUERY
                            FROM
                                DBA.PRODUTO_GRADE               PG
                            WHERE
                                PG.FLAGINATIVO                  = 'F' AND
                                EXISTS                          (       SELECT  1
                                                                        FROM    DBA.PRODUTO_MAPA_ENDERECO       PME
                                                                        WHERE   PG.IDPRODUTO                    = PME.IDPRODUTO        AND
                                                                                PG.IDSUBPRODUTO                 = PME.IDSUBPRODUTO     AND
                                                                                PME.FLAGPADRAO                  = 'T'                  AND
                                                                                NOT EXISTS                      (   SELECT  1
                                                                                                                    FROM    DBA.PRODUTO_MAPA_ENDERECO_LOTE      PMEL
                                                                                                                    WHERE   PMEL.IDPRODUTO                      = PME.IDPRODUTO         AND
                                                                                                                            PMEL.IDSUBPRODUTO                   = PME.IDSUBPRODUTO      AND
                                                                                                                            PMEL.IDEMPRESA                      = PME.IDEMPRESA         AND
                                                                                                                            PMEL.IDBAIRRO                       = PME.IDBAIRRO          AND
                                                                                                                            PMEL.IDRUA                          = PME.IDRUA             AND
                                                                                                                            PMEL.IDBLOCO                        = PME.IDBLOCO           AND
                                                                                                                            PMEL.IDNIVEL                        = PME.IDNIVEL           AND
                                                                                                                            PMEL.FLAGPADRAO                     = 'T'
                                                                                                                )                       AND
                                                                                EXISTS                          (   SELECT  1
                                                                                                                    FROM    DBA.PRODUTO_MAPA_ENDERECO_LOTE      PMEL
                                                                                                                    WHERE   PMEL.IDPRODUTO                      = PME.IDPRODUTO         AND
                                                                                                                            PMEL.IDSUBPRODUTO                   = PME.IDSUBPRODUTO      AND
                                                                                                                            PMEL.IDEMPRESA                      = PME.IDEMPRESA         AND
                                                                                                                            PMEL.IDBAIRRO                       = PME.IDBAIRRO          AND
                                                                                                                            PMEL.IDRUA                          = PME.IDRUA             AND
                                                                                                                            PMEL.IDBLOCO                        = PME.IDBLOCO           AND
                                                                                                                            PMEL.IDNIVEL                        = PME.IDNIVEL
                                                                                                                )
                                                                )

                            UNION ALL

                            -- Balan�a
                            SELECT
                                COUNT(*) Total,
                                'Balan�a | Produtos que est�o marcados para exportar para a balan�a e cont�m c�digo de barras maior que 6 d�gitos;' AS Descricao,
                                'SELECT B.IDSUBPRODUTO, B.DESCRRESPRODUTO, B.IDCODBARPROD, LENGTH(CAST(B.IDCODBARPROD AS VARCHAR(14))) TAMANHO FROM DBA.PRODUTO_GRADE                               B WHERE B.FLAGINATIVO                                   = ''F'' AND B.FLAGEXPBALANCAGRADE                           = ''T'' AND LENGTH(CAST(B.IDCODBARPROD AS VARCHAR(14)))     > 6' AS QUERY
                            FROM
                                DBA.PRODUTO_GRADE                               B
                            WHERE
                                B.FLAGINATIVO                                   = 'F' AND
                                B.FLAGEXPBALANCAGRADE                           = 'T' AND
                                LENGTH(CAST(B.IDCODBARPROD AS VARCHAR(14)))     > 6

                            UNION ALL


                            SELECT
                                COUNT(*) Total,
                                'Balan�a | Produtos que est�o marcados para exportar para a balan�a com embalagem diferente de ''KG'';' AS Descricao,
                                'SELECT A.IDPRODUTO, A.DESCRCOMPRODUTO, A.EMBALAGEMENTRADA, A.VALGRAMAENTRADA, A.EMBALAGEMSAIDA, A.VALGRAMASAIDA   FROM DBA.PRODUTO                                     A, DBA.PRODUTO_GRADE                               B WHERE A.IDPRODUTO                                     = B.IDPRODUTO AND B.FLAGINATIVO                                   = ''F'' AND A.FLAGEXPBALANCA                                = ''T'' AND ( A.EMBALAGEMENTRADA                              <> ''KG'' OR A.EMBALAGEMSAIDA                                <> ''KG'' )' AS QUERY
                            FROM
                                DBA.PRODUTO                                     A,
                                DBA.PRODUTO_GRADE                               B
                            WHERE
                                A.IDPRODUTO                                     = B.IDPRODUTO AND
                                B.FLAGINATIVO                                   = 'F' AND
                                A.FLAGEXPBALANCA                                = 'T' AND
                                (
                                A.EMBALAGEMENTRADA                              <> 'KG' OR
                                A.EMBALAGEMSAIDA                                <> 'KG'
                                )



                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Balan�a | Produtos que n�o est�o marcados para exportar para a balan�a, mas existe pelo menos um derivado que esta;' AS Descricao,
                                'SELECT B.IDPRODUTO, B.DESCRCOMPRODUTO FROM DBA.PRODUTO B WHERE B.FLAGEXPBALANCA = ''F'' AND B.IDPRODUTO IN(SELECT A.IDPRODUTO FROM DBA.PRODUTO_GRADE A WHERE A.FLAGEXPBALANCAGRADE = ''T'' AND A.FLAGINATIVO           = ''F'')' AS QUERY
                            FROM
                                DBA.PRODUTO B
                            WHERE
                                B.FLAGEXPBALANCA                        = 'F' AND
                                B.IDPRODUTO                             IN(     SELECT  A.IDPRODUTO
                                                                                FROM    DBA.PRODUTO_GRADE       A
                                                                                WHERE   A.FLAGEXPBALANCAGRADE   = 'T' AND
                                                                                        A.FLAGINATIVO           = 'F'
                                                                          )


                            UNION ALL

                            SELECT
                                COUNT(*) Total,
                                'Balan�a | Produtos com dias de validade por�m "Imprime data de embalagem na etiqueta" desmarcado;' AS Descricao,
                                'SELECT B.IDPRODUTO, A.IDSUBPRODUTO, B.DESCRCOMPRODUTO, ''PRODUTO:'' AS PRODUTO, B.DIASVALIDADE, B.FLAGIMPRIMEDATAEMBALAGEM, ''GRADE:'' AS GRADE, A.DIASVALIDADE, A.FLAGIMPRIMEDATAEMBALAGEMGRADE  FROM  DBA.PRODUTO                             B, DBA.PRODUTO_GRADE                       A WHERE B.IDPRODUTO                             = A.IDPRODUTO AND A.FLAGINATIVO                           = ''F'' AND ( ( A.DIASVALIDADE                          > 0 AND A.FLAGIMPRIMEDATAEMBALAGEMGRADE         = ''F'' ) OR ( B.DIASVALIDADE                          > 0 AND B.FLAGIMPRIMEDATAEMBALAGEM              = ''F'' ) )' AS QUERY
                            FROM
                                DBA.PRODUTO                             B,
                                DBA.PRODUTO_GRADE                       A
                            WHERE
                                B.IDPRODUTO                             = A.IDPRODUTO AND
                                A.FLAGINATIVO                           = 'F' AND
                                (
                                        (
                                                A.DIASVALIDADE                          > 0 AND
                                                A.FLAGIMPRIMEDATAEMBALAGEMGRADE         = 'F'
                                        )
                                        OR
                                        (
                                                B.DIASVALIDADE                          > 0 AND
                                                B.FLAGIMPRIMEDATAEMBALAGEM              = 'F'
                                        )
                                )



)
SELECT
    PRODUTO_VALIDACAO.TOTAL,
    PRODUTO_VALIDACAO.DESCRICAO,
    PRODUTO_VALIDACAO.QUERY
FROM
    PRODUTO_VALIDACAO
    ORDER BY Descricao


/*

 * Hist�rico de altera��es
        - 09/08/2019 -          | �ltima altera��o;
        - 19/09/2019 - 2.2      | Ajuste na se��o "Tributa��o normal | Produtos substitu�dos sem % ICMS Substitui��o Tribut�ria;" para considerar apenas produtos substitu�dos na entrada e ajustada a query para mostrar o % ICMS da entrada e n�o mostrar as informa��es de sa�da;
        - 19/09/2019 - 2.2      | "Criada a se��o Tributa��o normal | Produtos Substitui��o Tribut�ria sem % ICMS";
        - 19/09/2019 - 2.2      | Alterada a descri��o da se��o de "Tributa��o normal | Produtos substitu�dos sem % ICMS Substitui��o Tribut�ria;" para "Tributa��o normal | Produtos Substitui��o Tribut�ria sem % ICMS Substitui��o Tribut�ria;";
        - 20/09/2019 - 2.2      | Criada a valida��o "Tributa��o normal | Produtos que entram com um Tipo de Situa��o Tribut�ria e saem com outra (Dentro do estado)";
        - 20/09/2019 - 2.2      | Criada a valida��o "Tributa��o normal | Produtos que entram com um Tipo de Situa��o Tribut�ria e saem com outra (Fora do estado)";
        - 20/09/2019 - 2.2      | Criada a valida��o "Tributa��o normal | Existe tributa��o de entrada mas n�o existe de sa�da (Dentro do estado)";
        - 20/09/2019 - 2.2      | Criada a valida��o "Tributa��o normal | Existe tributa��o de entrada mas n�o existe de sa�da (Fora do estado)";
        - 20/09/2019 - 2.2      | Criada a valida��o "Tributa��o normal | Existe tributa��o de sa�da mas n�o existe de entrada (Dentro do estado)";
        - 20/09/2019 - 2.2      | Criada a valida��o "Tributa��o normal | Existe tributa��o de sa�da mas n�o existe de entrada (Fora do estado)";
        - 01/10/2019 - 2.3      | Criada a valida��o "Balan�a | Produtos que est�o marcados para exportar para a balan�a e cont�m c�digo de barras maior que 6 d�gitos";
        - 14/10/2019 - 2.4      | Ajuste nas se��es "Balan�o | Produtos lan�ados no balan�o e inativos no sistema;" e "Balan�o | Produtos lan�ados no balan�o sem custo informado;" adicionando a raz�o social da empresa e descri��o do local de estoque;
        - 25/10/2019 - 2.5      | Criada a valida��o "Balan�a | Produtos que est�o marcados para exportar para a balan�a com embalagem diferente de 'KG'";
        - 05/11/2019 - 2.6      | Criada a valida��o "Pre�os | Produtos com pre�o menor que o custo (Todas as empresas);";
        - 06/11/2019 - 2.7      | Criada a valida��o "Tributa��o normal (Federal) | PIS/COFINS de Sa�da sem C�digo de Natureza da Receita; e Tributa��o normal (Federal) | C�digo de Natureza da Receita que n�o pertence ao CST de PIS/COFINS de Sa�da;";
        - 13/11/2019 - 2.8      | Criada a valida��o "Tributa��o normal | N�o existe tributa��o de entrada para o estado da empresa, mas existe para outros estados;";
        - 21/11/2019 - 2.9      | Criada a valida��o "Lotes e Mapa de Endere�amento | Produtos que tem lote no endere�amento, por�m n�o est�o marcados para usar lote;";
        - 21/11/2019 - 2.9      | Criada a valida��o "Lotes e Mapa de Endere�amento | Produtos que est�o marcados para usar lote, por�m n�o tem lote no endere�amento;";
        - 21/11/2019 - 2.9      | Criada a valida��o "Lotes e Mapa de Endere�amento | Produtos que tem lote no endere�amento, por�m o lote n�o existe;";
        - 21/11/2019 - 2.9      | Criada a valida��o "Lotes e Mapa de Endere�amento | Existe endere�amento marcado como padr�o, por�m n�o existe nenhum endere�o de lote padr�o;";
        - 21/11/2019 - 2.9      | Criada a valida��o "Lotes e Mapa de Endere�amento | Existe endere�amento com lote marcado como endere�o padr�o, por�m o endere�o n�o est� marcado como padr�o;";
        - 21/11/2019 - 2.9      | Ajustes ortogr�ficos gerais;
        - 30/11/2019 - 3.0      | Ajuste na valida��o "Tributa��o normal | Produtos Isentos com % ICMS;" que estava retornando informa��es erradas;
        - 14/01/2020 - 3.1      | Criada a valida��o "Lotes | Existe movimenta��o de estoque com e sem lote;";
        - 10/02/2020 - 3.2      | Altera��o da se��o onde valida o Relacionamento de Produto com Fornecedor mudando a nomenclatura da se��o de "Fornecedores | ..." para "Relacionamento de Produto com Fornecedor | ..."; Criada a valida��o "Relacionamento de Produto com Fornecedor | Mesmo fornecedor com c�digo interno do fornecedor igual para mais de um produto;";
        - 08/06/2020 - 3.3      | Ajuste na se��o "Relacionamento de Produto com Fornecedor | Mesmo fornecedor com c�digo interno do fornecedor igual para mais de um produto;" pois quando existia uma ocorr�ncia do mesmo c�digo interno existir mais de uma vez para o mesmo fornecedor, no resultado do select ele retornava aquele c�digo interno para todos os fornecedores que ele existia, n�o somente para aquele que repetia mais de uma vez;
        - 08/06/2020 - 3.3      | Ajuste na se��o "Relacionamento de Produto com Fornecedor | Mesmo fornecedor com c�digo interno do fornecedor igual para mais de um produto;" pois dentro da valida��o das duplicidades na tabela PRODUTO_FORNECEDOR, estava considerando produtos ativos e inativos;
        - 25/06/2020 - 3.4      | Ajuste em todas as valida��es de tributa��o, para desconsiderar quando o produto � tributado por grupo;
        - 25/06/2020 - 3.4      | Criada a valida��o "Tributa��o por grupo | Produtos sem tributa��o dentro do estado;";
        - 30/06/2020 - 3.5      | Ajuste na se��o "Balan�a | Produtos que n�o est�o marcados para exportar para a balan�a, mas existe pelo menos um derivado que esta;" pois estava considerando produtos inativos;
        - 30/06/2020 - 3.5      | Criada a valida��o "Balan�a | Produtos com dias de validade por�m "Imprime data de embalagem na etiqueta" desmarcado;";
        - 26/08/2021 - 3.6      | Corre��o na query "Balan�o | Produtos lan�ados no balan�o sem custo informado;".

 * Melhorias e corre��es para aplicar
        - Criar uma coluna para classificar entre "Inconsist�ncia" e "Informativo";
        - Criar recurso para conseguir filtrar em cadastros ativos, inativos ou ambos;
        - Nas valida��es de tributa��o, revisar a ordena��o das colunas, para ficar com melhor exibi��o.;
        - Al�m da valida��o "Tributa��o normal | Produtos Tributados sem % ICMS;" verificar quais outros tipos de situa��o tribut�ria obrigam informar al�quota para fazer mais valida��es assim.
        - Na valida��o: "Estrutura Mercadol�gica Integrada | Produtos relacionados a estrutura mercadol�gica incorretamente quando a configura��o "Utiliza estrutura mercadol�gica integrada" est� marcada;" Separar a an�lise com divis�o e sem divis�o, tendo em vista que a divis�o n�o � obrigat�ria
        - Identificar produtos com c�digo de barras duplicados
        - Produtos cujo c�digo da grade n�o tem um igual ao principal.
        - Produto inativo (normal ou inativo para compra ou inativo para venda) e em pedido de compra ou pedido de venda.
        - Balan�o cuja rela��o Local de Estoque X Empresa est� errado de acordo com o cadastro de "Locais de Estoque"

*/
