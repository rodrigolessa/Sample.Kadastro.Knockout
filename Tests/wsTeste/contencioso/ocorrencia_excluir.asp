<!--#include file="../include/conn.asp"-->
<!--#include file="funcoes.asp"-->
<%
sql = "delete from ocorrencias where id = "&tplic(1,request("codigo"))
conn.execute(sql)

ok = grava_log_c(session("nomeusu"),"EXCLUSÃO","OCORRÊNCIA","Processo: "&request("processo"))

response.redirect("proc_ocorrencia.asp?id_processo="&request("id_processo")&"&processo=" & request("processo") & "&modulo=C&tipo_ocorr="&request("tipo_ocorr"))
%>

