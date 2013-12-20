<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<%
dim sql
sql = "select * from TabCliCont where usuario = '"&session("vinculado")&"' and processo = '"&tplic(0,request("proc"))&"' and envolvido = "&tplic(1,request("cliente"))&" and tipo = '"&tplic(0,request("tipo"))&"'"
set rst = db.execute(sql)
if rst.eof then
	sql = "insert into TabCliCont (usuario, processo, envolvido, tipo) values ('"&session("vinculado")&"', '"&tplic(0,request("proc"))&"', "&tplic(1,request("cliente"))&", '"&tplic(0,request("tipo"))&"')"
	'response.write sql
	'response.end
	db.execute(sql)
end if

if request("tipo") = "cliente" then
	vtipo = " Cliente: "
elseif request("tipo") = "outraparte" then
	vtipo = " Outra Parte: "
end if

set rs = conn.execute("Select id, apelido from envolvidos where usuario = '"&Session("vinculado")&"' and id = "&tplic(1,request("cliente")))
if not rs.eof then
	apelido = rs("apelido")
end if

ok = grava_log_c(session("nomeusu"),"INCLUSÃO","VINC.CLIENTE","Processo: "&request("processo")& " - " & vtipo & apelido)

	qs = ""
	for each campo in Request.querystring			
			if campo = "proc" then
				qs = qs & "&" & campo & "=" & Request.querystring(campo)
			end if
	next	
	
	qs = replace(qs,"&proc=","&id_processo=") & "&modulo=C"	
	'response.write qs
	'response.end

if request("tipo") = "cliente" then%>
<script>
	opener.frame_cliente.location.reload();
	window.close();
</script>
<%elseif request("tipo") = "outraparte" then%>
<script>
	opener.frame_outraparte.location.reload();
	window.close();
</script>
<%end if
%>
