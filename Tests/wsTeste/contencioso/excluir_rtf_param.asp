<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<%
'campo = ""
'if request("origem") = "CB" then	
'	campo = "cobranca"		
'else
'	campo = "comunicacao"
'end if

campo = "comunicacao"

db.execute("UPDATE Parametros SET "&tplic(1,campo)&" = null WHERE  usuario = '"&session("vinculado")&"'")

response.redirect "param.asp"
%>
