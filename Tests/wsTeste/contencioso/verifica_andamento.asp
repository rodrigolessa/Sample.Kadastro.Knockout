<%@  language="VBScript" %>
<% Response.Charset="ISO-8859-1"  %>
<!--#include file="../include/conn.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../usuario_logado.asp"-->
<%
Dim sqlPr, rsR, andamento, abc

andamento = request("andamento")

sqlR = "select ocorrencia = descricao_andamento from Contencioso.dbo.tb_Andamentos where id = '" + andamento + "'"

'Executando a procedure selecionada
set rsR = conn.Execute(sqlR)

if not rsR.eof then
	response.write rsR("ocorrencia")
end if
%>
