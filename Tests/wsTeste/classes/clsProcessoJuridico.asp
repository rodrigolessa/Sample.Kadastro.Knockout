<%
'--------------------------------------------------------------------------'
'Author: Rodrigo Lessa
'Create: 2013-10-1
'
'Dependences Parameters:
'	N/A
'
'Dependences Files:
'	/include/adovbs.inc
'	/include/helpers/inc_ADOHelper.asp
'	/contencioso/db_open.asp
'
'Methods:
'	Sub Class_Initialize
'	Sub Class_Terminate
'
'--------------------------------------------------------------------------'

Class clsProcessoJuridico

	Private m_idProcesso
	Private m_usuario
	Private m_processo
	Private m_natureza
	Private m_pasta
	Private m_descObjeto
	Private m_tipo
	Private m_competencia
	Private m_situacao
	Private m_situacaoEncerramento
	Private m_cliente
	Private m_outraParte
	Private m_vinculados
	Private m_instancia
	Private m_rito
	Private m_orgao
	Private m_juizo
	Private m_comarca
	Private m_distribuicao
	Private m_dataEncerramento
	Private m_responsavel
	Private m_descDetalhada
	Private m_obs
	Private m_participante
	Private m_principal
	Private m_arquivo
	Private m_tribunalSync
	Private m_campoLivre1
	Private m_campoLivre2
	Private m_acordo
	Private m_valorCausa
	Private m_valorProvavel
	Private m_valorFinal
	Private m_resultadoPrevisto
	Private m_tipoAcao
	Private m_dataCadastro
	Private m_objetoPrincipal
	Private m_dataCitacao
	Private m_campoLivre3
	Private m_campoLivre4
	Private m_habilitaTribunal
	Private m_periodicidade
	Private m_tipoConsultaProcesso
	Private m_flagNovaNumeracao

	Public Property Get IdProcesso()
		IdProcesso = m_idProcesso
	End Property
	Public Property Let IdProcesso(p_Data)
		m_idProcesso = p_Data
	End Property
	
	Public Property Get Usuario()
		Usuario = m_usuario
	End Property
	Public Property Let Usuario(p_Data)
		m_usuario = p_Data
	End Property
	
	Public Property Get Processo()
		Processo = m_processo
	End Property
	Public Property Let Processo(p_Data)
		m_processo = p_Data
	End Property
	
	Public Property Get Natureza()
		Natureza = m_natureza
	End Property
	Public Property Let Natureza(p_Data)
		m_natureza = p_Data
	End Property
	
	Public Property Get Pasta()
		Pasta = m_pasta
	End Property
	Public Property Let Pasta(p_Data)
		m_pasta = p_Data
	End Property
	
	Public Property Get DescricaoObjeto()
		DescricaoObjeto = m_descObjeto
	End Property
	Public Property Let DescricaoObjeto(p_Data)
		m_descObjeto = p_Data
	End Property
	
	Public Property Get Tipo()
		Tipo = m_tipo
	End Property
	Public Property Let Tipo(p_Data)
		m_tipo = p_Data
	End Property
	
	Public Property Get Competencia()
		Competencia = m_competencia
	End Property
	Public Property Let Competencia(p_Data)
		m_competencia = p_Data
	End Property
	
	Public Property Get Situacao()
		Situacao = m_situacao
	End Property
	Public Property Let Situacao(p_Data)
		m_situacao = p_Data
	End Property
	
	Public Property Get SituacaoEncerramento()
		SituacaoEncerramento = m_situacaoEncerramento
	End Property
	Public Property Let SituacaoEncerramento(p_Data)
		m_situacaoEncerramento = p_Data
	End Property
	
	Public Property Get Cliente()
		Cliente = m_cliente
	End Property
	Public Property Let Cliente(p_Data)
		m_cliente = p_Data
	End Property
	
	Public Property Get OutraParte()
		OutraParte = m_outraParte
	End Property
	Public Property Let OutraParte(p_Data)
		m_outraParte = p_Data
	End Property
	
	Public Property Get Vinculados()
		Vinculados = m_vinculados
	End Property
	Public Property Let Vinculados(p_Data)
		m_vinculados = p_Data
	End Property
	
	Public Property Get Instancia()
		Instancia = m_instancia
	End Property
	Public Property Let Instancia(p_Data)
		m_instancia = p_Data
	End Property
	
	Public Property Get Rito()
		Rito = m_rito
	End Property
	Public Property Let Rito(p_Data)
		m_rito = p_Data
	End Property
	
	Public Property Get Orgao()
		Orgao = m_orgao
	End Property
	Public Property Let Orgao(p_Data)
		m_orgao = p_Data
	End Property
	
	Public Property Get Juizo()
		Juizo = m_juizo
	End Property
	Public Property Let Juizo(p_Data)
		m_juizo = p_Data
	End Property
	
	Public Property Get Comarca()
		Comarca = m_comarca
	End Property
	Public Property Let Comarca(p_Data)
		m_comarca = p_Data
	End Property
	
	Public Property Get Distribuicao()
		Distribuicao = m_distribuicao
	End Property
	Public Property Let Distribuicao(p_Data)
		m_distribuicao = p_Data
	End Property
	
	Public Property Get DataEncerramento()
		DataEncerramento = m_dataEncerramento
	End Property
	Public Property Let DataEncerramento(p_Data)
		m_dataEncerramento = p_Data
	End Property
	
	Public Property Get Responsavel()
		Responsavel = m_responsavel
	End Property
	Public Property Let Responsavel(p_Data)
		m_responsavel = p_Data
	End Property
	
	Public Property Get DescricaoDetalhada()
		DescricaoDetalhada = m_descDetalhada
	End Property
	Public Property Let DescricaoDetalhada(p_Data)
		m_descDetalhada = p_Data
	End Property
	
	Public Property Get Observacao()
		Observacao = m_obs
	End Property
	Public Property Let Observacao(p_Data)
		m_obs = p_Data
	End Property
	
	Public Property Get Participante()
		Participante = m_participante
	End Property
	Public Property Let Participante(p_Data)
		m_participante = p_Data
	End Property
	
	Public Property Get Principal()
		Principal = m_principal
	End Property
	Public Property Let Principal(p_Data)
		m_principal = p_Data
	End Property
	
	Public Property Get Arquivo()
		Arquivo = m_arquivo
	End Property
	Public Property Let Arquivo(p_Data)
		m_arquivo = p_Data
	End Property
	
	Public Property Get TribunalSync()
		TribunalSync = m_tribunalSync
	End Property
	Public Property Let TribunalSync(p_Data)
		m_tribunalSync = p_Data
	End Property
	
	Public Property Get CampoLivre1()
		CampoLivre1 = m_campoLivre1
	End Property
	Public Property Let CampoLivre1(p_Data)
		m_campoLivre1 = p_Data
	End Property
	
	Public Property Get CampoLivre2()
		CampoLivre2 = m_campoLivre2
	End Property
	Public Property Let CampoLivre2(p_Data)
		m_campoLivre2 = p_Data
	End Property
	
	Public Property Get Acordo()
		Acordo = m_acordo
	End Property
	Public Property Let Acordo(p_Data)
		m_acordo = p_Data
	End Property
	
	Public Property Get ValorCausa()
		ValorCausa = m_valorCausa
	End Property
	Public Property Let ValorCausa(p_Data)
		m_valorCausa = p_Data
	End Property
	
	Public Property Get ValorProvavel()
		ValorProvavel = m_valorProvavel
	End Property
	Public Property Let ValorProvavel(p_Data)
		m_valorProvavel = p_Data
	End Property
	
	Public Property Get ValorFinal()
		ValorFinal = m_valorFinal
	End Property
	Public Property Let ValorFinal(p_Data)
		m_valorFinal = p_Data
	End Property
	
	Public Property Get ResultadoPrevisto()
		ResultadoPrevisto = m_resultadoPrevisto
	End Property
	Public Property Let ResultadoPrevisto(p_Data)
		m_resultadoPrevisto = p_Data
	End Property
	
	Public Property Get TipoAcao()
		TipoAcao = m_tipoAcao
	End Property
	Public Property Let TipoAcao(p_Data)
		m_tipoAcao = p_Data
	End Property
	
	Public Property Get DataCadastro()
		DataCadastro = m_dataCadastro
	End Property
	Public Property Let DataCadastro(p_Data)
		m_dataCadastro = p_Data
	End Property
	
	Public Property Get ObjetoPrincipal()
		ObjetoPrincipal = m_objetoPrincipal
	End Property
	Public Property Let ObjetoPrincipal(p_Data)
		m_objetoPrincipal = p_Data
	End Property
	
	Public Property Get DataCitacao()
		DataCitacao = m_dataCitacao
	End Property
	Public Property Let DataCitacao(p_Data)
		m_dataCitacao = p_Data
	End Property
	
	Public Property Get CampoLivre3()
		CampoLivre3 = m_campoLivre3
	End Property
	Public Property Let CampoLivre3(p_Data)
		m_campoLivre3 = p_Data
	End Property
	
	Public Property Get CampoLivre4()
		CampoLivre4 = m_campoLivre4
	End Property
	Public Property Let CampoLivre4(p_Data)
		m_campoLivre4 = p_Data
	End Property
	
	Public Property Get HabilitaTribunal()
		HabilitaTribunal = m_habilitaTribunal
	End Property
	Public Property Let HabilitaTribunal(p_Data)
		m_habilitaTribunal = p_Data
	End Property

	Public Property Get Periodicidade()
		Periodicidade = m_periodicidade
	End Property
	Public Property Let Periodicidade(p_Data)
		m_periodicidade = p_Data
	End Property
	
	Public Property Get TipoConsultaProcesso()
		TipoConsultaProcesso = m_tipoConsultaProcesso
	End Property
	Public Property Let TipoConsultaProcesso(p_Data)
		m_tipoConsultaProcesso = p_Data
	End Property
	
	Public Property Get FlagNovaNumeracao()
		FlagNovaNumeracao = m_flagNovaNumeracao
	End Property
	Public Property Let FlagNovaNumeracao(p_Data)
		m_flagNovaNumeracao = p_Data
	End Property


'#############  Funções Públicas ##############

	Public Sub ObterPeloCodigo(p_Codigo)

		if len(trim(p_Codigo)) > 0 then

			sSQL = "SELECT * FROM Contencioso.dbo.TabProcCont WHERE id_processo = " & p_Codigo
			SET rsProcesso = db.execute(sSQL)
			FillProcessoFromRS(rsProcesso)
			SET rsProcesso = nothing

		end if

	End Sub

	Public Function ObterFlagNovaNumeracaoPeloCodigo()

		Dim flagNovaNumercao

		if len(trim(Me.IdProcesso)) > 0 then

			sSQL = "SELECT COALESCE(flgNovaNumeracao, '') AS flgNovaNumeracao FROM Contencioso.dbo.TabProcCont WHERE id_processo = " & Me.IdProcesso

			SET rsProcesso = db.execute(sSQL)

			if NOT rsProcesso.EOF then

				flagNovaNumercao = UCase(rsProcesso("flgNovaNumeracao"))

			end if

			SET rsProcesso = nothing

		end if

		ObterFlagNovaNumeracaoPeloCodigo = flagNovaNumercao

	End Function

	Public Function GravarFlagNovaNumeracao()

		Dim booRetorno

		booRetorno = false

		if(Not IsEmpty2(Me.FlagNovaNumeracao)) then

			sSQL = "UPDATE Contencioso.dbo.TabProcCont SET flgNovaNumeracao = '" & Me.FlagNovaNumeracao & "' WHERE id_processo = " & Me.IdProcesso
			db.Execute(sSQL)

			booRetorno = true

		end if

		GravarFlagNovaNumeracao = booRetorno

	End Function


	'TODO: Implementar função de salvar
	Public Function Salvar()

		Dim rsRetorno, codigoRetorno

		Salvar = codigoRetorno

	End Function

'############# Funções Privadas ##############

	Private Function FillProcessoFromRS(p_RS)

		if  not p_RS.EOF then

			m_idProcesso = p_RS("id_processo")
			m_usuario = p_RS("usuario")
			m_processo = p_RS("processo")
			m_natureza = p_RS("natureza")
			m_pasta = p_RS("pasta")
			m_descObjeto = p_RS("desc_res")
			m_tipo = p_RS("tipo")
			m_competencia = p_RS("competencia")
			m_situacao = p_RS("situacao")
			m_situacaoEncerramento = p_RS("situacaoenc")
			m_cliente = p_RS("cliente")
			m_outraParte = p_RS("outraparte")
			m_vinculados = p_RS("vinculados")
			m_instancia = p_RS("instancia")
			m_rito = p_RS("rito")
			m_orgao = p_RS("orgao")
			m_juizo = p_RS("juizo")
			m_comarca = p_RS("comarca")
			m_distribuicao = p_RS("distribuicao")
			m_dataEncerramento = p_RS("dt_encerra")
			m_responsavel = p_RS("responsavel")
			m_descDetalhada = p_RS("desc_det")
			m_obs = p_RS("obs")
			m_participante = p_RS("participante")
			m_principal = p_RS("principal")
			m_arquivo = p_RS("arquivo")
			m_tribunalSync = p_RS("tribunal_sync")
			m_campoLivre1 = p_RS("cmp_livre_1")
			m_campoLivre2 = p_RS("cmp_livre_2")
			m_acordo = p_RS("acordo")
			m_valorCausa = p_RS("valor_causa")
			m_valorProvavel = p_RS("valor_provavel")
			m_valorFinal = p_RS("valor_final")
			m_resultadoPrevisto = p_RS("resultado_previsto")
			m_tipoAcao = p_RS("tipo_acao")
			m_dataCadastro = p_RS("dt_cad")
			m_objetoPrincipal = p_RS("objeto_principal")
			m_dataCitacao = p_RS("dt_citacao")
			m_campoLivre3 = p_RS("cmp_livre_3")
			m_campoLivre4 = p_RS("cmp_livre_4")
			'EnviaSMS
			'tel
			m_habilitaTribunal = p_RS("habilitatrib")
			m_periodicidade = p_RS("periodicidade")
			m_tipoConsultaProcesso = p_RS("tipo_consulta_processo")
			m_flagNovaNumeracao = p_RS("flgNovaNumeracao")

		end if

	End Function

End Class

%>