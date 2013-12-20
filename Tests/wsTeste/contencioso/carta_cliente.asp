<%
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Pega dados do Cliente
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	if clientex = "" then
		cliente_carta = ""
	else
		sql = "SELECT Envolvidos.apelido, Envolvidos.contato1, Envolvidos.logradouro1, Envolvidos.bairro1, Envolvidos.cidade1, "&_
		" Envolvidos.estado1, Envolvidos.cep1, Envolvidos.end_corr1, Envolvidos.logradouro2, Envolvidos.bairro2, Envolvidos.cidade2, "&_
		" Envolvidos.estado2, Envolvidos.cep2, Envolvidos.end_corr2 FROM contencioso.dbo.TabCliCont c INNER JOIN"&_
		" Envolvidos ON c.envolvido = Envolvidos.id WHERE (c.codigo IN ("&tplic(1,mid(clientex,1,len(clientex)-1))&")) ORDER BY Envolvidos.apelido "
	
	
	set rst_cli = db_apol.execute(sql)
	
	if rst_cli.eof then
		cliente_carta = "Cliente não cadastrado"
		contato1_carta = "Cliente não cadastrado"
	else
		cliente_carta = rst_cli("razao")
		contato1_carta = rst_cli("nome")
	 	logradouro_carta = rst_cli("logradouro")
		bairro_carta = rst_cli("bairro")
		cidade_carta = rst_cli("cidade")
		estado_carta = rst_cli("estado")
		cep_carta = rst_cli("cep")
	end if

		
'		do while not rst_cli.eof
		
'		cliente_carta =  rst_cli("apelido")& " , " &cliente_carta
'		contato1_carta =  rst_cli("contato1")& " , " &cliente_carta
'		if (rst_cli("end_corr2")) then
'		 	logradouro_carta = rst_cli("logradouro2")& " , " &logradouro_carta
'			bairro_carta = rst_cli("bairro2")& " , " &bairro_carta
'			cidade_carta =  rst_cli("cidade2")& " , " &cidade_carta
'			estado_carta = rst_cli("estado2")& " , " &estado_carta
'			cep_carta = rst_cli("cep2")& " , " &cep_carta
'		 else
'		 	logradouro_carta = rst_cli("logradouro1")& " , " &logradouro_carta
'			bairro_carta = rst_cli("bairro1")& " , " &bairro_carta
'			cidade_carta =  rst_cli("cidade1")& " , " &cidade_carta
'			estado_carta = rst_cli("estado1")& " , " &estado_carta
'			cep_carta = rst_cli("cep1")& " , " &cep_carta
'		 end if
'		rst_cli.movenext
'		loop
		
		end if
		
	end if
%>