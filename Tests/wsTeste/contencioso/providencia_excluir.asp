<!--#include file="../include/conn.asp"-->
<!--#include file="funcoes.asp"-->
<%
sql = "delete from providencias where id = "&tplic(1,request("cod"))
conn.execute(sql)

response.redirect("processo.asp?id_processo="&request("id_processo")&"&modulo=C")
%>

