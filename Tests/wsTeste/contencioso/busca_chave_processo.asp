<!--#include file="../include/conn.asp"-->
<!--#include file="../include/funcoes.asp"-->
<!--#include file="../usuario_logado.asp"-->
<%
Dim sqlR, rsR

sqlR = "select (tribunal_sync + '_' + tipo_consulta_processo + '.' + processo) as chavevinculo from contencioso.dbo.TabProcCont where id_processo = '"&request("idProc")&"'"

set rsR = conn.Execute(sqlR)

if not rsR.eof then
	response.write rsR("chavevinculo")
end if
%>
