<%
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Pega dados do Processo
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	sql = "SELECT DISTINCT TabProcCont.id_processo, TabProcCont.processo, TabProcCont.pasta, TabProcCont.situacao, TabProcCont.situacaoenc, TabProcCont.dt_encerra, TabProcCont.instancia, TabProcCont.orgao, TabProcCont.juizo, TabProcCont.comarca, TabProcCont.participante, TabProcCont.desc_res, TabProcCont.natureza, TabProcCont.competencia, TabProcCont.responsavel, TabProcCont.tipo, TabProcCont.tipo_acao, TabProcCont.rito, TabProcCont.distribuicao, TabProcCont.principal, TabProcCont.objeto_principal, TabProcCont.dt_citacao, "&_
	"cast(TabProcCont.desc_det as varchar(max)) as DESCRICAO "&_
	"FROM TabProcCont "&_
	"WHERE TabProcCont.id_processo="&tplic(1,id_processo)&""
	
	set rs_proc = db.execute(sql)

	if rs_proc.eof then%>
	<title>APOL Jurídico</title>
	<body bgcolor="#EFEFEF">
			<table  width="100%" class=preto11 border="0" cellspacing="2" cellpadding="3">
					<tr class="preto11">
						<td align=center>
						<b><font color=red>Processo não encontrado.</font></b>
					</tr>
			</table>
		<%response.end
	end if

	processo = rs_proc("processo")
	objeto = rs_proc("desc_res")
	p_pasta_proprio	= rs_proc("pasta")
	responsavel = rs_proc("responsavel")
	situacao = rs_proc("situacao")
	descricao = rs_proc("DESCRICAO")
	
	if isnull(descricao) then
		objeto = ""
	end if
	if isnull(pasta) then
		pasta = ""
	end if
	if isnull(responsavel) or responsavel = 0 then
		responsavel = ""
	else
	set rs = conn.execute("Select * from responsaveis where tipo <> 'cliente' and usuario = '"&Session("vinculado")&"' and id = "&tplic(1,responsavel)&"")				
		if not rs.eof then
			responsavel = rs("nome")
		end if
	end if
	if isnull(situacao) then
		situacao = ""
	else
		situacao = replace(replace(replace(replace(situacao,"A","Ativo"),"C","Acordo"),"E","Encerrado"), "I", "Inativo")
	end if

	if situacao <> "Encerrado" then
		situacaoenc = ""
	else
		situacaoenc = rs_proc("situacaoenc")	
		if isnull(situacaoenc) then
			situacaoenc = ""
		else
			situacaoenc = " - "&replace(replace(replace(situacaoenc,"G","Causa Ganha"),"P","Causa Perdida"),"A","Feito Acordo")
		end if
	end if

	situacao = situacao&situacaoenc

	dt_encerra = fdata(rs_proc("dt_encerra"))
	if isnull(dt_encerra) then
		dt_encerra = ""
	end if
	
	dt_citacao = fdata(rs_proc("dt_citacao"))
	if isnull(dt_citacao) then
		dt_citacao = ""
	end if

	distribuicao = fdata(rs_proc("distribuicao"))
	if isnull(distribuicao) then
		distribuicao = ""
	end if

	instancia = rs_proc("instancia")	
	if isnull(instancia) then
		instancia = ""
	end if

	competencia	= rs_proc("competencia")	
	if isnull(competencia) then
		competencia = ""
	else
		competencia = replace(replace(competencia,"E","Estadual"),"F","Federal")
	end if

	tipo = rs_proc("tipo")	
	if isnull(tipo) then
		tipo = ""
	else
		tipo = replace(replace(tipo,"J","Jurídico"),"A","Administrativo")
	end if

	if rs_proc("tipo_acao") <> "" and not isnull(rs_proc("tipo_acao")) then 
		set rs = db.execute("Select * from auxiliares where codigo = "&tplic(1,cint(rs_proc("tipo_acao"))))		
		if not rs.eof then
			tipo_acao = rs("descricao")
		else
			tipo_acao = "não encontrado"
		end if
	end if

	principal = rs_proc("principal")	
	if isnull(principal) then
		principal = ""
	else
		principal = replace(replace(principal,"S","Sim"),"N","Não")
	end if

	if rs_proc("natureza") <> "" and not isnull(rs_proc("natureza")) then 
		set rs = db.execute("Select * from auxiliares where codigo = "&tplic(1,cint(rs_proc("natureza"))))		
		if not rs.eof then
			natureza = rs("descricao")
		else
			natureza = "não encontrado"
		end if
	end if

	if rs_proc("rito") <> "" and not isnull(rs_proc("rito")) then 
		set rs = db.execute("Select * from auxiliares where codigo = "&tplic(1,cint(rs_proc("rito")))	)	
		if not rs.eof then
			rito = rs("descricao")
		else
			rito = "não encontrado"
		end if
	end if
	
	if rs_proc("objeto_principal") <> "" and not isnull(rs_proc("objeto_principal")) then 
		set rs = db.execute("Select * from auxiliares where codigo = "&tplic(1,cint(rs_proc("objeto_principal")))	)	
		objeto_principal = "não encontrado"
		if not rs.eof then
			objeto_principal = rs("descricao")
		end if
	end if

	if rs_proc("orgao") <> "" and not isnull(rs_proc("orgao")) then 
		set rs = db.execute("Select * from auxiliares where codigo = "&tplic(1,cint(rs_proc("orgao"))))		
		if not rs.eof then
			orgao = rs("descricao")
		else
			orgao = "não encontrado"
		end if
	end if
	
	if rs_proc("juizo") <> "" and not isnull(rs_proc("juizo")) then 
		set rs = db.execute("Select * from auxiliares where codigo = "&tplic(1,cint(rs_proc("juizo"))))		
		if not rs.eof then
			juizo = rs("descricao")
		else
			juizo = "não encontrado"
		end if
	end if
	
	if rs_proc("comarca") <> "" and not isnull(rs_proc("comarca")) then 
		set rs = db.execute("Select * from auxiliares where codigo = "&tplic(1,cint(rs_proc("comarca"))))		
		if not rs.eof then
			comarca = rs("descricao")
		else
			comarca = "não encontrado"
		end if
	end if		
	
	posicao = rs_proc("participante")	
	if isnull(posicao) then
		posicao = ""
	end if
	'Interessado-----------------------
	sql = "SELECT DISTINCT ec.processo, e.apelido, te.nome_tipo_env, e.razao " & _
		  "FROM envolvidos e " & _
		  " INNER JOIN contencioso.dbo.TabCliCont ec ON e.id = ec.envolvido " & _
		  " INNER JOIN Tipo_Envolvido te ON te.id_tipo_env = ec.tipo_env " & _
		  "WHERE e.usuario = '"&session("vinculado")&"' AND ec.processo = '"&tplic(1,id_processo)&"' AND upper(te.nome_tipo_env) = 'INTERESSADO'"
	set rs_interessado = conn.execute(sql)
	if not rs_interessado.eof then
		interessado = rs_interessado("apelido")
		razao_social_interessado = rs_interessado("razao")
	end if

	'-------- Razão Social do Titular --------'
	'sql005 = "SELECT DISTINCT e.razao " & _
	'	  "FROM envolvidos e " & _
	'	  " INNER JOIN contencioso.dbo.TabCliCont ec ON e.id = ec.envolvido " & _
	'	  " INNER JOIN Tipo_Envolvido te ON te.id_tipo_env = ec.tipo_env " & _
	'	  "WHERE e.usuario = '"&session("vinculado")&"' " & _
	'	  "	AND ec.processo = '"&tplic(1,id_processo)&"' " & _
	'	  "	AND UPPER(te.nome_tipo_env) = 'TITULAR'"
	'set rs005 = conn.execute(sql005)
	'if not rs005.eof then
	'	razao_social_titular_controlado = rs005("razao")
	'end if
	'-------- Razão Social do Titular --------'

	'Prazo Gerencial e Oficial ----------------
	sql = "SELECT DISTINCT TOP(1) id, prazo_ger, prazo_ofi "&_
		  "FROM Providencias "&_
		  "JOIN Contencioso.dbo.TabProcCont T ON Providencias.processo COLLATE SQL_Latin1_General_CP1_CI_AS = T.processo AND Providencias.usuario = T.usuario "&_
		  "WHERE T.id_processo = "&tplic(1,id_processo)&" and T.usuario = '"&session("vinculado")&"' and Providencias.tipo = 'C' AND ISNULL(Providencias.executada, 0) = 0 "&_
		  "ORDER BY prazo_ger, prazo_ofi, id desc"
	set rs_providencia = conn.execute(sql)
	if not rs_providencia.eof then
		prazo_ger = rs_providencia("prazo_ger")
		prazo_ofi = rs_providencia("prazo_ofi")
	end if
	

	cliente = "Cliente: "

	set rs = db.execute("SELECT DISTINCT APOL.dbo.Tipo_Envolvido.id_tipo_env,contencioso.dbo.TabCliCont.codigo,APOL.dbo.Envolvidos.razao, APOL.dbo.Envolvidos.pasta, APOL.dbo.Envolvidos.id, APOL.dbo.Tipo_Envolvido.nome_tipo_env, APOL.dbo.Envolvidos.apelido, APOL.dbo.Endereco_Env.modulo_recebe "&_
	" FROM contencioso.dbo.TabCliCont LEFT OUTER JOIN APOL.dbo.Envolvidos ON APOL.dbo.Envolvidos.id = contencioso.dbo.TabCliCont.envolvido LEFT OUTER JOIN APOL.dbo.Tipo_Envolvido ON APOL.dbo.Tipo_Envolvido.id_tipo_env = contencioso.dbo.TabCliCont.tipo_env LEFT OUTER JOIN APOL.dbo.Endereco_Env ON APOL.dbo.Endereco_Env.id_env = APOL.dbo.Envolvidos.id"&_
	" WHERE (contencioso.dbo.TabCliCont.usuario = '"&Session("vinculado")&"') and modulo_recebe in (0,3)"&_
	" AND contencioso.dbo.TabCliCont.processo = "&rs_proc("id_processo")&" and contencioso.dbo.TabCliCont.principal = 1 ORDER BY APOL.dbo.Envolvidos.apelido")
	do while not rs.eof
		cliente = cliente & "\par            " & rs("razao")
		clientex = rs("codigo")&","&clientex
	rs.movenext
	loop

'--------------------------------------------------------

'	outraparte = "Outra Parte: "

	set rs = db.execute("SELECT APOL.dbo.Tipo_Envolvido.id_tipo_env,contencioso.dbo.TabCliCont.codigo,APOL.dbo.Envolvidos.razao, APOL.dbo.Envolvidos.pasta, APOL.dbo.Envolvidos.id, "&_
	" APOL.dbo.Tipo_Envolvido.nome_tipo_env FROM contencioso.dbo.TabCliCont LEFT OUTER JOIN APOL.dbo.Envolvidos ON "&_
	" APOL.dbo.Envolvidos.id = contencioso.dbo.TabCliCont.envolvido LEFT OUTER JOIN APOL.dbo.Tipo_Envolvido ON "&_
	" APOL.dbo.Tipo_Envolvido.id_tipo_env = contencioso.dbo.TabCliCont.tipo_env WHERE (contencioso.dbo.TabCliCont.usuario = '"&Session("vinculado")&"') "&_
	" AND contencioso.dbo.TabCliCont.processo = "&rs_proc("id_processo")&" AND (APOL.dbo.Tipo_Envolvido.nome_tipo_env = 'outra parte') ORDER BY APOL.dbo.Envolvidos.apelido")

	do while not rs.eof
'		outraparte = outraparte & "\par            " & rs("razao")
'		outrapartex = rs("razao")&","&outrapartex
		outrapartex = outrapartex&" / "&rs("razao")

	rs.movenext
	loop
	
'--------------------------------------------------------

	sql = "select empresa from usuarios_apol.dbo.usuario where nomeusu = '"&session("vinculado")&"'"
	set rst_env = db_apol.execute(sql)
	if rst_env.eof then
		escritorio_carta = ""
	else
		escritorio_carta = RST_ENV("empresa")
	end if
%>