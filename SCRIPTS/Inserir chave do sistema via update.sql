-- select * from empresa
-- select * from cnpj_base
-- SELECT * FROM CIDADES_IBGE WHERE IDCIDADE = '82813'

update empresa set cnpjbase = null
go
update cnpj_base set cnpjbase = '82213604'
go
update  empresa
set     UF = 'SP',
        IDCIDADE = '85936',
        razaosocial = 'CISS Consultoria em Informática, Serviços e Software S/A',
        chaveliberacao = '<>',
        nomefantasia = 'CISS Software e Serviços',
        cnpj =     '82213604000180',
        cnpjbase = '82213604'
where   idempresa = 1
go
commit


