<!--#include file="db_open.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/dbconn.asp"-->
<%
	if tplic(1, Request("pmarcados")) = "" then
		response.write "<script>"
		response.write "alert('Nenhum processo selecionado.'); history.back();"
		response.write "</script>"
		response.end
	end if
	pmarcados = "'" & tplic(1, Request("pmarcados")) & "'"
	
	if InStr(pmarcados, "#") > 0 then
		pmarcados = replace(tplic(1, Request("pmarcados")),", ","##")
		pmarcados = replace(pmarcados,"#","'")
		pmarcados = replace(pmarcados,"''","','")
	end if
	processos = replace(pmarcados,"'","")
	processos_excluidos = "''"

	sql = "Select distinct processo from TabProcCont where id_processo IN (" & processos & ") and usuario = '"&session("vinculado")&"'"
	set rsproc = db.execute(SQL)
	
	if not rsproc.eof then
		processos_excluidos = "'"
		processos_excluidos = processos_excluidos & rsproc.GetString(,,"", "', '", "&nbsp")
		processos_excluidos = left(processos_excluidos, len(processos_excluidos)-3)
	end if
	
	'response.write "<br>processos_excluidos = " & processos_excluidos
	
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'Excluindo Procidências e Ocorrências para os processos selecionados'
	'procs = split(processos, ", ", -1, 1)
	itensExcluir = split(processos_excluidos, ",")
	
	if isArray(itensExcluir) then
		
		for i = 0 to ubound(itensExcluir)

			sql = "DELETE FROM Providencias WHERE tipo IN ('C', 'T') AND usuario = '" & session("vinculado") & "' AND processo = " & itensExcluir(i)
			'response.write "<br>DEL : " & sql
			'response.end
		conn.execute(sql)
		
			sql = "DELETE FROM Providencias WHERE tipo IN ('C', 'T') AND usuario like '" & session("vinculado") & "##%' AND processo = " & itensExcluir(i)
		conn.execute(sql)
	next
			
		sql = "DELETE FROM Ocorrencias WHERE tipo IN ('C', 'T') AND usuario = '" & session("vinculado") & "' AND processo IN (" & processos_excluidos & ")"
		conn.execute(sql)

	end if
			
	sql = "delete from apol.dbo.cad_livre_processos where processo IN (" & pmarcados & ") and usuario = '" & session("vinculado") & "'"
	conn.execute(sql)

	db.execute("Delete from TabValCont where processo in ("&processos&") and usuario = '"&session("vinculado")&"'")
	db.execute("Delete from TabVincProc where processo1 in ("&pmarcados&") and usuario = '"&session("vinculado")&"'")

	'------------------------------------------------------------------
	'----------------------excluir andamentos   -----------------------
	'------------------------------------------------------------------
	sqlxx = "select DISTINCT V.ID as VISAO, v.PROCESSO_FK,v.CHAVE,PP.ID as codpasta from VISAO V, PASTA PP, Contencioso.dbo.tbConexaoTribunais_Andamentos ANDA" &_
			" where V.CHAVE IN (" & processos_excluidos& ") and ANDA.usuario = '"&session("vinculado")&"'" &_
			" and PP.ID > 3 and pp.NOME= '"&session("vinculado")&"'" &_ 
			" and ANDA.VisaoISIS_FK = v.ID and ANDA.processo = v.CHAVE"
	set rsAndamentos = dbconn.execute(sqlxx)

	'do while not rsAndamentos.eof
	'
	'	visao = rsAndamentos("VISAO")
	'	procID = rsAndamentos("PROCESSO_FK")
	'	sqlxz = "select * from PARTE where Visao_FK = " &rsAndamentos("VISAO")
	'	set rsParte = dbconn.execute(sqlxz)
	'
	'	whle not rsParte.eof then
	'		dbconn.execute("delete from NOME_PARTE where NOME_PARTE.PARTE_FK = " & rsParte("id"))
	'		dbconn.execute("delete from ADVOGADO where ADVOGADO.PARTE_FK =  " & rsParte("id"))
	'		dbconn.execute("delete from PARTE where PARTE.VISAO_FK  = "& rsParte("id") )
	'		rsParte.movenext
	'	loop
'
'
'		sqlx1 = "select * from PASTAS2PROCESSOS where PASTAS2PROCESSOS.PASTAS_FK = "&rsAndamentos("codpasta") &" and PASTAS2PROCESSOS.PROCESSOS_FK= "&rsAndamentos("PROCESSO_FK")		
'		set rsP2P = dbconn.execute(sqlx1)
'
'		if not rsP2P.eof then
'			dbconn.execute("delete from PASTAS2PROCESSOS where PASTAS2PROCESSOS.PASTAS_FK = "&rsAndamentos("codpasta") &" and PASTAS2PROCESSOS.PROCESSOS_FK= "&rsAndamentos("PROCESSO_FK"))		
'		end if
'		
'		dbconn.execute("delete from PROCESSO_RELACIONADO where PROCESSO_RELACIONADO.VISAO_FK = " &rsAndamentos("VISAO"))
'		dbconn.execute("delete from HISTORICO where HISTORICO.VISAO_FK = " &rsAndamentos("VISAO"))
'		dbconn.execute("delete from OUTRO where OUTRO.VISAO_FK = " &rsAndamentos("VISAO"))
'
'		rsAndamentos.movenext
'		
'	loop
'	dbconn.execute("delete from visao where ID = " &visao )
	'db.execute("delete from tbConexaoTribunais_Parametros where usuario = '"&session("vinculado")&"'")
	'dbconn.execute("delete from PASTA where PASTA.NOME = '"&session("vinculado")&"'")

	db.execute("delete from tb_Andamentos where id_processo in (" & processos & ")")	
		
	db.execute("delete from tbConexaoTribunais_Andamentos where processo IN (" & processos_excluidos& ") and usuario = '"&session("vinculado")&"'")
	'------------------------------------------------------------------

	'-------- apaga vinculo em todos os módulos ---------------
	modulo_vinc_apaga = "('C','T')"
	pmarcados_vinc_del = pmarcados
	conn.execute("delete from apol.dbo.Vinculado where vinculado in ("&pmarcados_vinc_del&") and usuario = '"&session("vinculado")&"' and tipo in "&modulo_vinc_apaga)
	conn.execute("delete from apol.dbo.Mi_Vinculado where vinculado in ("&pmarcados_vinc_del&") and usuario = '"&session("vinculado")&"' and tipo  in "&modulo_vinc_apaga)
	conn.execute("delete from apol.dbo.Dominios_Vinculado where vinculado in ("&pmarcados_vinc_del&") and usuario = '"&session("vinculado")&"' and tipo  in "&modulo_vinc_apaga)
	conn.execute("Delete from apol_patentes.dbo.vinculado where naturezav+vinculado in ("&pmarcados_vinc_del&") and usuario = '"&session("vinculado")&"' and tipo  in "&modulo_vinc_apaga)
	conn.execute("delete from apol_patentes.dbo.Pi_Vinculado where vinculado in ("&pmarcados_vinc_del&") and usuario = '"&session("vinculado")&"' and tipo  in "&modulo_vinc_apaga)
	conn.execute("DELETE FROM apol_contratos.dbo.Vincula_Contrato WHERE contrato_anexo in ("&pmarcados_vinc_del&") and usuario = '"&session("vinculado")&"' and modulo  in "&modulo_vinc_apaga)
	conn.execute("Delete from contencioso.dbo.TabVincProc where processo2 in ("&pmarcados_vinc_del&") and usuario = '"&session("vinculado")&"' and tipo in "&modulo_vinc_apaga)
	'----------------------------------------------------------

	db.execute("Delete from TabProcCont where id_processo in ("&processos&") and usuario = '"&session("vinculado")&"'")
	db.execute("Delete from TabCliCont where processo in ("&pmarcados&") and usuario = '"&session("vinculado")&"'")
	set rs = db.execute("UPDATE Parametros SET proc_excluido = 1, dt_excluido = GETDATE() WHERE proc_excluido = 0 AND usuario IN (SELECT nomeusu FROM usuarios_apol.dbo.usuario WHERE vinculado = '"&session("vinculado")&"')")

	' ******* movimentação de pastas ****************
	
    sql_mov = 	" SELECT DISTINCT i.id_solicitacao, i.id_item_solicitacao, usu.nomeusu, i.processo " & _
				" FROM 	item_solicitacao i " & _
				" JOIN	solicitacao s " & _
				"	ON	i.id_solicitacao = s.id_solicitacao " & _
				" JOIN	usuarios_apol..usuario usu " & _
				"	ON	s.id_usuario_para = usu.codigo " & _
				" WHERE i.id_documento_solicitado in (" & processos & ") " & _
				" 	AND i.id_usuario_principal = '" & session("codigo_vinculado") & "' " & _
				"	AND i.tipo_processo in ('C','T')"
				
    set rs_mov = conn.execute(sql_mov)
	
	lstSolicitacaoId = ""
    do while not rs_mov.eof
		lstSolicitacaoId = lstSolicitacaoId & rs_mov("id_solicitacao") & ","
	
		conn.execute("DELETE historico_solicitacao WHERE id_item_solicitacao = " & rs_mov("id_item_solicitacao"))
		conn.execute("DELETE item_solicitacao WHERE id_item_solicitacao = " & rs_mov("id_item_solicitacao"))
	   
		msg_log_mov = " Solicitação excluída devido a exclusão da pasta: " & rs_mov("processo")&" | Solicitada por: " &rs_mov("nomeusu")
		ok = grava_log_c(session("nomeusu"),"EXCLUSÃO","MOV. DE PASTA",msg_log_mov)       
		
		rs_mov.MoveNext
	loop
	
	if not lstSolicitacaoId = "" then 
		lstSolicitacaoId = left(lstSolicitacaoId,len(lstSolicitacaoId)-1)
		arrSolicitacaoId = split(lstSolicitacaoId,",")
		for each SolicitacaoId in arrSolicitacaoId
			if cstr(conn.execute("SELECT count(*) as total FROM item_solicitacao WHERE id_solicitacao = " & SolicitacaoId)("total")) = "0" then 
				conn.execute("DELETE FROM solicitacao WHERE id_solicitacao = " & SolicitacaoId)
			end if
		next
	end if	
	' ***********************************************

	ok = grava_log_c(session("nomeusu"),"EXCLUSÃO","PROVIDÊNCIA","Processos: "&processos_excluidos&"")
	ok = grava_log_c(session("nomeusu"),"EXCLUSÃO","OCORRÊNCIA","Processos: "&processos_excluidos&"")
	ok = grava_log_c(session("nomeusu"),"EXCLUSÃO","VINC.VALOR","Processos: "&processos_excluidos&"")
	ok = grava_log_c(session("nomeusu"),"EXCLUSÃO","VINC.CLIENTE","Processos: "&processos_excluidos&"")
	ok = grava_log_c(session("nomeusu"),"EXCLUSÃO","VINC.PROCESSO","Processos: "&processos_excluidos&"")
	ok = grava_log_c(session("nomeusu"),"EXCLUSÃO","PROCESSO","Nº: "&processos_excluidos&"")

	campos = ""
	for each campo in request.form
		if campo <> "pmarcados" then
			if campo <> "filtrar" then
				if campo <> "atual" and campo <> "sql" then
					campos = campos&"&"&campo&"="&replace(request.form(campo),"%","%25")
				end if
			else
				campos = campos&"&filtrar="
			end if
		else
			campos = campos&"&pmarcados="
		end if
	next

	if request("vindo") = "1" then
		sVoltarProcesso = ""
		sVoltarArg1 = ""
		sVoltarArg2 = ""
		iPosicao = 0
		sVoltarURL = "consulta_main.asp?exc=1"&campos
		if instr(Request.ServerVariables("HTTP_REFERER"), "consulta_main.asp") > 0 and isobject(session("C_nvgc_prcss")) then
			session("C_nvgc_prcss") = null
		end if
		if isobject(session("C_nvgc_prcss")) then
			sVoltarURL = "processo_result.asp"
			
			iPosicao = Session("C_nvgc_prcss").AbsolutePosition
	
			if iPosicao = session("C_nvgc_prcss").recordCount then iPosicao = iPosicao - 1
	
			session("C_nvgc_prcss").close
			session("C_nvgc_prcss").open session("sql2"), db
	
			if iPosicao > 0 then
				Session("C_nvgc_prcss").AbsolutePosition = iPosicao
			
				sVoltarProcesso = Session("C_nvgc_prcss")("id_processo")
				sVoltarArg1 = Session("C_nvgc_prcss")("pasta")
				sVoltarArg2 = Session("C_nvgc_prcss")("processo")
				sVoltarURL = "processo.asp"
				
				if not sVoltarProcesso = "" then 
					sVoltarURL = sVoltarURL & "?pg=" & iPosicao & "&id_processo=" & sVoltarProcesso & " &modulo=C&processo=" & sVoltarArg2 & "&pasta=" & sVoltarArg1
				end if
			end if
		end if
	
		'response.write "<br>sVoltarURL = " & sVoltarURL
		'response.end
		response.redirect sVoltarURL
	else
		response.redirect "processo_result.asp?a=1"&campos
	end if
%>
