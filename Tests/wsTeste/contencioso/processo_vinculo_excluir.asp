<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<%
set rs_cont = db.execute("select processo from contencioso.dbo.TabProcCont where id_processo = " & request("id_processo"))
if not rs_cont.eof then
	proc_cont = rs_cont("processo")
end if
desc_log = "Processo: "&proc_cont & " -> Vinculado: " & request("vinculado") & " (" & request("modulo_vinculo") & ")"

select case Request("tipo_modulo")
case "P"
	%>
	<!--#include file="../patente/include/conn_apol_pat.asp"-->
	<!--#include file="../patente/include/conn.asp"-->
	<%
	sql = "DELETE FROM Vinculado WHERE usuario = '" &Session("vinculado")& "' and id = "&tplic(1,request("codigo"))
	conn_pat.execute(sql)

case "PI"
	%>
	<!--#include file="../patente/include/conn_apol_pat.asp"-->
	<!--#include file="../patente/include/conn.asp"-->
	<%
	sql = "DELETE FROM apol_patentes.dbo.Pi_Vinculado WHERE usuario = '" &Session("vinculado")& "' and codigo = "&tplic(1,request("codigo"))
	conn.execute(sql)
	desc_log = "Processo Inter.: "&proc_cont & " -> Vinculado: " & request("vinculado") & " (" & request("modulo_vinculo") & ")"

case "M"
	%>
	<!--#include file="../include/conn.asp"-->
	<%
	sql = "DELETE FROM apol.dbo.Vinculado WHERE usuario = '" &Session("vinculado")& "' and id = "&tplic(1,request("codigo"))
	conn.execute(sql)

case "D"%>
	<!--#include file="../include/conn.asp"-->
	<%
	sql = "DELETE FROM Dominios_Vinculado WHERE usuario = '" &Session("vinculado")& "' and codigo = "&tplic(1,request("codigo"))
	conn.execute(sql)
	desc_log = "Domínio: "&proc_cont & " -> Vinculado: " & request("vinculado") & " (" & request("modulo_vinculo") & ")"

case "MI"%>
	<!--#include file="../include/conn.asp"-->
	<%
	sql = "DELETE FROM Mi_Vinculado WHERE usuario = '" &Session("vinculado")& "' and codigo = "&tplic(1,request("codigo"))
	conn.execute(sql)
	desc_log = "Processo Inter.: "&proc_cont & " -> Vinculado: " & request("vinculado") & " (" & request("modulo_vinculo") & ")"

case "C"
	sql = "select case tipo WHEN 'C' THEN (select processo from contencioso.dbo.TabProcCont where id_processo = tabvincproc.processo2) "
	sql = sql & " WHEN 'M' THEN processo2 WHEN 'P' THEN processo2 WHEN 'V' THEN (select codigo from apol_contratos.dbo.contrato where id_contrato = tabvincproc.processo2) END as vinculado, "
	sql = sql & " case tipo WHEN 'C' THEN 'Jurídico' WHEN 'M' THEN 'Marca' WHEN 'P' THEN 'Patente' WHEN 'V' THEN 'Contratos' END "
	sql = sql & " as tipo from TabVincProc where usuario = '" &Session("vinculado")& "' and codigo = "&tplic(1,request("codigo"))

	set rs = db.execute(sql)
	if not rs.eof then
		vinculado = rs("vinculado")
		tipo = rs("tipo")
		if tipo = "Patente" then
			if left(vinculado,2) = "ND" then
				vinculado = right(vinculado,len(vinculado)-2)
			end if
		end if
		sql = "delete from TabVincProc where codigo = '"&request("codigo")&"' and usuario = '"&Session("vinculado")&"'"
		db.execute(sql) 
	else%>
		<script>
		alert('Registro vinculado já foi excluído anteriormente.');
		window.location.href = "proc_vinculado.asp?id_processo=<%=request("id_processo")%>&modulo=C"
		</script>
		<%Response.end
	end if
	
case "V"
	%>
	<!--#include file="../contrato/conn_v.asp"-->
	<!--#include file="../contrato/funcoes.asp"-->
	<!--#include file="../contrato/conn.asp"-->
	<%
	sql = "DELETE FROM Vincula_Contrato WHERE usuario = '" &Session("vinculado")& "' and id_vinculado = "&tplic(1,request("codigo"))
	conn_v.execute(sql)
	desc_log = "Contrato: "&proc_cont & " -> Vinculado: " & request("vinculado") & " (" & request("modulo_vinculo") & ")"

end select


ok = grava_log_c(session("nomeusu"),"EXCLUSÃO","VINCULO", desc_log)
response.redirect("proc_vinculado.asp?id_processo="&request("id_processo")&"&modulo=C")
%>
