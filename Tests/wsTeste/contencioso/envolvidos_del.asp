<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<%
sql = "delete from tabclicont where codigo = "&tplic(1,request("codigo"))
db.execute(sql)

ok = grava_log_c(session("nomeusu"),"EXCLUSÃO","ENVOLVIDO","Processo: "&request("processo"))

response.redirect("proc_envolvidos.asp?id_processo="&request("id_processo")&"&modulo=C")
%>
