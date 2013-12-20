<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn.asp"-->

<%
dim sql
if request("codigo") = "" then
	'call monta_insert("TabValCont","v","S")
	
	processo = tplic(1,request("vprocesso_c"))
	referencia = tplic(1,request("vreferencia_c"))
	data = tplic(1,request("vdata_d"))
	valor = tplic(1,request("vvalor_n"))
	moeda = tplic(1,request("vmoeda_c"))
	obs= tplic(1,request("vobs_c"))
	
	sql = "insert into TabValCont (usuario,processo,referencia,data,valor,moeda,obs) values ('"
	sql = sql & session("vinculado") & "','" & processo & "','" & referencia & "'," & rdata(data) & ",'" & replace(valor,",",".")
	sql = sql & "','" & moeda & "','" & obs & "')"
	
	ok = grava_log_c(session("nomeusu"),"INCLUSÃO","VINC.VALOR","Processo: "&request("fprocesso_c") )

	db.execute(sql)
	for each campo in Request.form
		if campo = "vprocesso_c" then
			qs = qs & "&" & campo & "=" & Request.form(campo)
		end if
	next	
	qs = replace(qs,"&vprocesso_c","&id_processo")
%>

<script>
	opener.frame_valores.location.reload();
	window.close();
</script>
<%
else
	call monta_update("TabValCont","v"," Where codigo = "&request("codigo"),"S")				
	ok = grava_log_c(session("nomeusu"),"ALTERAÇÃO","VINC.VALOR","Processo: "&request("fprocesso_c") )

	db.execute(sql)
	for each campo in Request.form
		if campo = "vprocesso_c" then
			qs = qs & "&" & campo & "=" & Request.form(campo)
		end if
	next	
	qs = replace(qs,"&vprocesso_c","&id_processo")
%>

<script>
	opener.location.reload();
	window.close();
</script>

<%end if%>



