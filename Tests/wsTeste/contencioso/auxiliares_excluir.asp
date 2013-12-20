<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'-->
<%

sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' AND codigo = "&tplic(1,request("id"))
set rst = db.execute(sql)
if not rst.eof then
	select case rst("tipo")
		case "N"
			xtit = "Natureza"
		
		case "P"
			xtit = "Providência"
			
		case "H"
			xtit = "Históricos"
			
		case "R"
			xtit = "Rito"
		
		case "O"
			xtit = "Órgão"
		
		case "J"
			xtit = "Juizo"

		case "T"
			xtit = "Tipo&nbsp;de&nbsp;Ação"

		case "3"
			xtit = Replace(Request("campo"), " ", "&nbsp;")
		
		case "4"
			xtit = Replace(Request("campo"), " ", "&nbsp;")
	end select
	
	descricao = rst("descricao")
end if

sql = "delete from auxiliares where codigo = "&tplic(1,request("ID"))
db.execute(sql)

ok = grava_log_c(session("nomeusu"),"EXCLUSÃO",ucase(xtit),mid(descricao,1,20))

response.redirect "auxiliares_list.asp?acao=C&PRIMEIRO=N&tipo="&request("tipo")&"&campo="&request("campo")&"&pdescricao_c="&request("pdescricao_c")&""
%>