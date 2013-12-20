<!--#include file="db_open.asp"-->
<%
if Request("apenso") = "" then
	apenso = "N"
else
	apenso = "S"
end if

sql = "UPDATE TabVincProc SET obs = '"&tplic(0,request("obs"))&"', apenso = '"&apenso&"' WHERE codigo = "&tplic(0,request("id"))&""
db.execute(sql)

ok = grava_log_cont(session("nomeusu"),"ALTERAÇÃO","VINCULO","Processo: "&request("processo")& " -> Vinculado: " & request("vinculado") & " (" & request("modulo_vinculado") & ")")
%>
<script>
	opener.window.location.reload();
	window.close();
</script>

