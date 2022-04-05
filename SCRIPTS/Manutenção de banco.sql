--------------
-- TABLE STATS
--------------

select DATE(stats_time) DATE , count(*) COUNT from syscat.tables where TYPE = 'T' group by DATE(stats_time) ORDER BY DATE(stats_time)

-- Estatísticas em todas as tabelas
select 'db2 "RUNSTATS ON TABLE '||trim(TABSCHEMA)||'.'||trim(TABNAME)||' ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND INDEXES ALL ALLOW WRITE ACCESS"' " " from syscat.tables where TYPE = 'T' order by npages desc
db2 -x "select 'RUNSTATS ON TABLE '||rtrim(TABSCHEMA)||'.'||rtrim(TABNAME)|| ' ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND INDEXES ALL ALLOW WRITE ACCESS;' from SYSCAT.TABLES where TYPE = 'T' order by npages desc" > updstat.sql
db2 -tvf updstat.sql

-- Estatísticas em tabelas cuja Estatística foi atualizada anterior a data de hoje
select 'db2 "RUNSTATS ON TABLE '||trim(TABSCHEMA)||'.'||trim(TABNAME)||' ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND INDEXES ALL ALLOW WRITE ACCESS"' " " from syscat.tables where TYPE = 'T' and stats_time is null or stats_time < TODAY() order by npages desc
db2 -x "select 'RUNSTATS ON TABLE '||rtrim(TABSCHEMA)||'.'||rtrim(TABNAME)|| ' ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND INDEXES ALL ALLOW WRITE ACCESS;' from SYSCAT.TABLES where TYPE = 'T' and stats_time is null or stats_time < TODAY() order by npages desc" > updstat.sql
db2 -tvf updstat.sql


        -- Estatística em tabelas com nome mínusculo (Exemplo)
        call admin_cmd('RUNSTATS ON TABLE NFE."schema_version" ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND INDEXES ALL ALLOW WRITE ACCESS')


----------
-- OBJECTS
----------

select * from SYSIBM.SYSINVALIDOBJECTS

-- Revalidar objetos
call ADMIN_REVALIDATE_DB_OBJECTS(null, null, null)
db2 "call admin_revalidate_db_objects(null, null, null)"


-----------
-- PACKAGES
-----------

SELECT DATE(LAST_BIND_TIME) DATE, VALID, COUNT(*) COUNT FROM SYSCAT.PACKAGES GROUP BY DATE(LAST_BIND_TIME), VALID ORDER BY DATE(LAST_BIND_TIME), VALID

-- Rebind em todos os pacotes
SELECT 'db2 "REBIND PACKAGE '||TRIM(PKGSCHEMA)||'.'||TRIM(PKGNAME)||'"' as " " FROM SYSCAT.PACKAGES
db2 -x "SELECT 'REBIND PACKAGE '||TRIM(pkgschema)||'.'||PKGNAME||';' FROM SYSCAT.PACKAGES" > reb.sql
db2 -tvf reb.sql

-- Rebind em pacotes corrompidos (Inválidos)
SELECT 'db2 "REBIND PACKAGE '||TRIM(PKGSCHEMA)||'.'||TRIM(PKGNAME)||'"' as " " FROM SYSCAT.PACKAGES WHERE VALID <> 'Y'
db2 -x "SELECT 'REBIND PACKAGE '||TRIM(pkgschema)||'.'||PKGNAME||';' FROM SYSCAT.PACKAGES WHERE VALID <> 'Y'" > reb.sql
db2 -tvf reb.sql

-- Rebind em pacotes cujo rebind foi anterior a data de hoje
SELECT 'db2 "REBIND PACKAGE '||TRIM(PKGSCHEMA)||'.'||TRIM(PKGNAME)||'"' as " " FROM SYSCAT.PACKAGES WHERE LAST_BIND_TIME < TODAY()
db2 -x "SELECT 'REBIND PACKAGE '||TRIM(pkgschema)||'.'||PKGNAME||';' FROM SYSCAT.PACKAGES WHERE LAST_BIND_TIME < TODAY()" > reb.sql
db2 -tvf reb.sql


------------
-- INTEGRITY
------------

select * from syscat.tables where status = 'C'

-- Integridade pendente
select 'db2 "set integrity for '||ltrim(rtrim(tabschema))||'.'||tabname||' all immediate unchecked"' as " "from syscat.tables where status = 'C'
db2 "SELECT CAST('SET INTEGRITY FOR '||rtrim(tabschema)||'.'||rtrim(tabname)||' ALL IMMEDIATE UNCHECKED;' AS CHAR(160)) as CMD from syscat.tables WHERE type='T' AND status='C'" > setint.sql
db2 -tvf setint.sql


---------
-- OUTROS
---------

-- Empresa
SELECT * FROM DBA.EMPRESA

-- Versão do banco
select * from sysibm.sysversions order by version_timestamp

-- Erros de atualização de banco
SELECT COUNT(*) FROM LOG_ATUALIZACAO_CMD        WHERE RETORNOCATALOGADO <> 'T'
SELECT COUNT(*) FROM STATUS_OBJETOS             WHERE TIPOSTATUS <> 'C'
SELECT COUNT(*) FROM STATUS_OBJETOS_UPGRADE     WHERE TIPOSTATUS <> 'C'

COMMIT
