<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<%
sql = "delete from tabclicont where codigo = "&tplic(1,request("codigo"))
db.execute(sql)

if request("tipo") = "C" then
	vtipo = "Cliente: "
elseif request("tipo") = "O" then
	vtipo = "Outra Parte: "
end if

set rs = conn.execute("Select id, apelido from envolvidos where usuario = '"&Session("vinculado")&"' and id = "&tplic(1,request("id")))
if not rs.eof then
	apelido = rs("apelido")
end if

ok = grava_log_c(session("nomeusu"),"EXCLUSÃO","VINC.CLIENTE","Processo: "&request("processo")& " - " & vtipo & apelido)

if request("tipo") = "C" then
	response.redirect("proc_cliente.asp?id_processo="&request("id_processo")&"&modulo=C")
elseif request("tipo") = "O" then
	response.redirect("proc_outraparte.asp?id_processo="&request("id_processo")&"&modulo=C")
end if
%>
