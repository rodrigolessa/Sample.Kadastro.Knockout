<%
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Pega dados da Outra Parte
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	if outrapartex = "" then
		outraparte_carta = ""
	else
		sql = "SELECT Envolvidos.apelido FROM contencioso.dbo.TabCliCont c INNER JOIN"&_
		" Envolvidos ON c.envolvido = Envolvidos.id WHERE c.usuario = '"&session("vinculado")&"' AND (c.codigo IN ("&tplic(1,mid(outrapartex,1,len(outrapartex)-1))&")) ORDER BY Envolvidos.apelido "

		set rst_cli = db_apol.execute(sql)

		if rst_cli.eof then
			cliente = "Cliente não cadastrado"
			contato1 = "Cliente não cadastrado"
		else

		outraparte_carta = ""
		
		do while not rst_cli.eof
			outraparte_carta = rst_cli("apelido")& " , " &outraparte_carta
		rst_cli.movenext
		loop
		
		end if
		
		outraparte_carta = mid(outraparte_carta,1,len(outraparte_carta)-2)
		
	end if
%>