<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<%
sql = "delete from TabValCont where codigo= "&tplic(1,request("codigo"))
db.execute(sql)

response.redirect("proc_valores.asp?id_processo="&request("id_processo")&"&modulo=C")
%>

