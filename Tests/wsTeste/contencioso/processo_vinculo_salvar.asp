<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<%
dim sql
call monta_insert("TabVincProc","f","S")
'response.write 	request("fprocesso2_n")
'response.write sql
'response.end
db.execute(sql)

'----------------------------------
hoje = date()
'----------------------------------

if request("ftipo_c") = "M" then

	tipo = "Marca"

	sql_proc = "select * from TabProcCont where id_processo = '"&tplic(0,request("fprocesso1_n"))&"'"
	set rs_proc = db.execute(sql_proc)
	ocorrencia = "Processo do Jurídico Vínculado "&rs_proc("processo")&""
	conn.execute("INSERT INTO ocorrencias(tipo, usuario, data, processo, ocorrencia)  "&_
	" VALUES('"&tplic(0,request("ftipo_c"))&"', '"&session("vinculado")&"', "&rdata(hoje)&", "&_
	" '"&tplic(0,request("fprocesso2_n"))&"', '"&tplic(0,ocorrencia)&"')")
	ok = grava_log(session("nomeusu"),"INCLUSÃO","OCORRÊNCIA","Processo: "&request("fprocesso2_n"))

elseif request("ftipo_c") = "C" then

	tipo = "Jurídico"

elseif request("ftipo_c") = "P" then

	tipo = "Patente"

	sql_proc = "select * from TabProcCont where id_processo = '"&tplic(0,request("fprocesso1_n"))&"'"
	set rs_proc = db.execute(sql_proc)
	ocorrencia = "Processo do Jurídico Vínculado "&rs_proc("processo")&""
	conn.execute("INSERT INTO ocorrencias(tipo, usuario, data, processo, ocorrencia)  "&_
	" VALUES('"&tplic(0,request("ftipo_c"))&"', '"&session("vinculado")&"', "&rdata(hoje)&", "&_
	" '"&tplic(0,request("fprocesso2_n"))&"', '"&tplic(0,ocorrencia)&"')")
	ok = grava_log_pat(session("nomeusu"),"INCLUSÃO","OCORRÊNCIA","Processo: "&request("processo"))

end if

select case request("ftipo_c")
	case "C"
		sql = "select * from TabProcCont where usuario = '"&session("vinculado")&"' and id_processo = "&tplic(1,request("fprocesso2_n"))
		set rstp = db.execute(sql)
		if not rstp.eof then
			vprocvinc = rstp("processo")
		end if
	case "M"
		vprocvinc = request("fprocesso2_n")
	case "P"
		vprocvinc = request("fprocesso2_n")
end select
					
ok = grava_log_c(session("nomeusu"),"INCLUSÃO","VINC.PROCESSO",tipo & ": "&request("processo1") & " - " & vprocvinc)

	qs = ""
	for each campo in Request.form
		if campo = "fprocesso1_n" then
			qs = qs & "&" & campo & "=" & Request.form(campo)
		end if
	next	
	qs = replace(qs,"&fprocesso1_n","&id_processo")
	'response.write qs
%>
<script>
	opener.frame_vinculado.location.reload();
	window.close();
</script>
