<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<%
dim sql

If request("principal") = 1 Then
	principal = 1
	sql = "select * from TabCliCont where usuario = '"&session("vinculado")&"' and processo = '"&tplic(0,request("proc"))&"' and principal = 1 and tipo_env = "&tplic(0,request("tipo_env"))&""
	set rs_conf = db.execute(sql)
	If not rs_conf.eof then%>
			<script>
			window.alert("Já existe um Principal para este Tipo !")
//			window.location="javascript:history.back(-1)"
			window.location.href = "../cliente.asp?erro=1&modulo=C&id_proc=<%=request("proc")%>&processo=<%=request("processo")%>&tipo_env=<%=request("tipo")%>"

			</script>
	<%response.end
	end if
Else
	principal = 0
End If	

sql = "select * from TabCliCont where usuario = '"&session("vinculado")&"' and processo = '"&tplic(0,request("proc"))&"' and envolvido = "&tplic(1,request("apelido"))&" and tipo_env = "&tplic(0,request("tipo_env"))&""
set rst = db.execute(sql)
if rst.eof then
	sql = "insert into TabCliCont (usuario, processo, envolvido, tipo_env,principal) values ('"&session("vinculado")&"', '"&tplic(0,request("proc"))&"', "&tplic(1,request("apelido"))&", "&tplic(0,request("tipo_env"))&",'"&principal&"')"
	db.execute(sql)
else%>
	<script>
	window.alert("Já existe um Envolvido com este Tipo associado ao Processo!");
	window.location.href = "../cliente.asp?erro=1&modulo=C&id_proc=<%=request("proc")%>&processo=<%=request("processo")%>"
	</script>
<%	Response.end
end if

set rs = conn.execute("SELECT Envolvidos.id, Envolvidos.apelido, Tipo_Envolvido.nome_tipo_env FROM Envolvidos CROSS JOIN Tipo_Envolvido WHERE (Envolvidos.usuario = '"&Session("vinculado")&"') AND (Envolvidos.id = "&tplic(1,request("apelido"))&") AND (Tipo_Envolvido.id_tipo_env = "&tplic(1,request("tipo_env"))&")")
if not rs.eof then
	apelido = rs("apelido")
	vtipo = rs("nome_tipo_env")
end if

ok = grava_log_c(session("nomeusu"),"INCLUSÃO","ENVOLVIDO","Processo: "&request("proc")& " - " & vtipo & apelido)

qs = ""
for each campo in Request.querystring
		if campo = "proc" then
			qs = qs & "&" & campo & "=" & Request.querystring(campo)
		end if
next

qs = replace(qs,"&proc=","&id_processo=") & "&modulo=C"	
%>
<script>
	opener.frame_envolvidos.location.reload();
	window.close();
</script>