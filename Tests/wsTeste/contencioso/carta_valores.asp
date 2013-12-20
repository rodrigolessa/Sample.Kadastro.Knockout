<%
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Pega dados do Processo
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	sql = "SELECT * FROM TabValCont WHERE processo = "&tplic(1,id_processo)&" AND usuario = '"&session("vinculado")&"' and data <= GETDATE()"
	set rs_proc = db.execute(sql)

	if rs_proc.eof then%>
	<title>APOL Jurídico</title>
	<body bgcolor="#EFEFEF">
			<table  width="100%" class=preto12 border="0" cellspacing="2" cellpadding="3">
					<tr class="preto12">
						<td align=center>
						<b><font color=red>Não existe valores para este processo.</font></b>
					</tr>
			</table>
		<%response.end
	end if

	valores = "Valores: "
	do while not rs_proc.eof
'		if cdate(rs_proc("data")) <= date() then
			set rsaux = db.execute("SELECT * FROM Auxiliares WHERE (codigo = '"&rs_proc("referencia")&"')")
			valores = valores & "\par            " & rs_proc("data")&"  \tab- "&rs_proc("moeda")&" "&rs_proc("valor")&"   \tab- "&rsaux("descricao")&"                                        \tab- "&rs_proc("obs")
			rs_proc.movenext
'		end if
	loop
%>