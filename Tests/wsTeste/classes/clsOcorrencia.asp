<%
'--------------------------------------------------------------------------'
'Author: Rodrigo Lessa
'Create: 2013-10-22
'
'Dependences Parameters:
'	N/A
'
'Dependences Files:
'	/include/adovbs.inc
'	/include/helpers/inc_ADOHelper.asp
'	/include/conn.asp
'
'Methods:
'	Sub Class_Initialize
'	Sub Class_Terminate
'
'--------------------------------------------------------------------------'

Class clsOcorrencia

	Private m_Codigo
	Private m_Usuario
	Private m_Ocorrencia
	Private m_Processo
	Private m_Data
	Private m_Tipo
	Private m_Prorroga
	Private m_TipoOcorrencia
	Private m_Conversao
	Private m_SiglaPais
	Private m_Protocolo
	Private m_RPI
	Private m_Despacho
	Private m_Descricao
	Private m_DescricaoOutroIdioma
	Private m_DetalheOutroIdioma
	Private m_Idioma
	Private m_VisivelResp
	Private m_HistoricoIsis
	Private m_ModuloConsulta

	Public Property Get Codigo()
		Codigo = m_Codigo
	End Property

	Public Property Let Codigo(p_Data)
		m_Codigo = p_Data
	End Property

	Public Property Get Usuario()
		Usuario = m_Usuario
	End Property
	Public Property Let Usuario(p_Data)
		m_Usuario = p_Data
	End Property

	Public Property Get Ocorrencia()
		Ocorrencia = m_Ocorrencia
	End Property
	Public Property Let Ocorrencia(p_Data)
		m_Ocorrencia = p_Data
	End Property

	Public Property Get Processo()
		Processo = m_Processo
	End Property
	Public Property Let Processo(p_Data)
		m_Processo = p_Data
	End Property

	Public Property Get Data()
		Data = m_Data
	End Property
	Public Property Let Data(p_Data)
		m_Data = p_Data
	End Property

	Public Property Get Tipo()
		Tipo = m_Tipo
	End Property
	Public Property Let Tipo(p_Data)
		m_Tipo = p_Data
	End Property

	Public Property Get Prorroga()
		Prorroga = m_Prorroga
	End Property
	Public Property Let Prorroga(p_Data)
		m_Prorroga = p_Data
	End Property

	Public Property Get TipoOcorrencia()
		TipoOcorrencia = m_TipoOcorrencia
	End Property
	Public Property Let TipoOcorrencia(p_Data)
		m_TipoOcorrencia = p_Data
	End Property

	Public Property Get Conversao()
		Conversao = m_Conversao
	End Property
	Public Property Let Conversao(p_Data)
		m_Conversao = p_Data
	End Property

	Public Property Get SiglaPais()
		SiglaPais = m_SiglaPais
	End Property
	Public Property Let SiglaPais(p_Data)
		m_SiglaPais = p_Data
	End Property

	Public Property Get Protocolo()
		Protocolo = m_Protocolo
	End Property
	Public Property Let Protocolo(p_Data)
		m_Protocolo = p_Data
	End Property

	Public Property Get RPI()
		RPI = m_RPI
	End Property
	Public Property Let RPI(p_Data)
		m_RPI = p_Data
	End Property

	Public Property Get Despacho()
		Despacho = m_Despacho
	End Property
	Public Property Let Despacho(p_Data)
		m_Despacho = p_Data
	End Property

	Public Property Get Descricao()
		Descricao = m_Descricao
	End Property
	Public Property Let Descricao(p_Data)
		m_Descricao = p_Data
	End Property

	Public Property Get DescricaoOutroIdioma()
		DescricaoOutroIdioma = m_DescricaoOutroIdioma
	End Property
	Public Property Let DescricaoOutroIdioma(p_Data)
		m_DescricaoOutroIdioma = p_Data
	End Property

	Public Property Get DetalheOutroIdioma()
		DetalheOutroIdioma = m_DetalheOutroIdioma
	End Property
	Public Property Let DetalheOutroIdioma(p_Data)
		m_DetalheOutroIdioma = p_Data
	End Property

	Public Property Get Idioma()
		Idioma = m_Idioma
	End Property
	Public Property Let Idioma(p_Data)
		m_Idioma = p_Data
	End Property

	Public Property Get VisivelResp()
		VisivelResp = m_VisivelResp
	End Property
	Public Property Let VisivelResp(p_Data)
		m_VisivelResp = p_Data
	End Property

	Public Property Get HistoricoIsis()
		HistoricoIsis = m_HistoricoIsis
	End Property
	Public Property Let HistoricoIsis(p_Data)
		m_HistoricoIsis = p_Data
	End Property

	Public Property Get ModuloConsulta()
		ModuloConsulta = m_ModuloConsulta
	End Property
	Public Property Let ModuloConsulta(p_Data)
		m_ModuloConsulta = p_Data
	End Property

'#############  Funções Públicas ##############

	Public Function ObterPeloCodigo(p_Codigo)
		'spr_Ocorrencia_Obter
	End Function

	Public Function Salvar()

		Dim rsRetorno, codigoRetorno

		SET  cmd = Server.CreateObject("ADODB.Command")
		with cmd

			.ActiveConnection = conn
			.CommandType = adCmdStoredProc
			.CommandText = "dbo.spr_Ocorrencia_Salvar"

			.Parameters.Append .CreateParameter("@id", adInteger, adParamInputOutput)
			.Parameters.Append .CreateParameter("@usuario", adVarChar, adParamInput, 50)
			.Parameters.Append .CreateParameter("@ocorrencia", adVarChar, adParamInput, -1)
			.Parameters.Append .CreateParameter("@processo", adVarChar, adParamInput, 50)
			.Parameters.Append .CreateParameter("@data", adDBTimeStamp, adParamInput)
			.Parameters.Append .CreateParameter("@tipo", adVarChar, adParamInput, 2)
			.Parameters.Append .CreateParameter("@prorroga", adBoolean, adParamInput)
			.Parameters.Append .CreateParameter("@tipo_ocorrencia", adInteger, adParamInput)
			.Parameters.Append .CreateParameter("@conversao", adBoolean, adParamInput)
			.Parameters.Append .CreateParameter("@sigla_pais", adVarChar, adParamInput, 2)
			.Parameters.Append .CreateParameter("@protocolo", adVarChar, adParamInput, 50)
			.Parameters.Append .CreateParameter("@rpi", adVarChar, adParamInput, 4)
			.Parameters.Append .CreateParameter("@desp", adVarChar, adParamInput, 10)
			.Parameters.Append .CreateParameter("@descricao", adVarChar, adParamInput, 100)
			.Parameters.Append .CreateParameter("@descricao_outro_idioma", adVarChar, adParamInput, -1)
			.Parameters.Append .CreateParameter("@detalhe_outro_idioma", adVarChar, adParamInput, -1)
			.Parameters.Append .CreateParameter("@idioma", adVarChar, adParamInput, 2)
			.Parameters.Append .CreateParameter("@visivelresp", adBoolean, adParamInput)
			.Parameters.Append .CreateParameter("@historico_isis_FK", adInteger, adParamInput)
			.Parameters.Append .CreateParameter("@mod_consulta", adInteger, adParamInput)

			if(Not IsEmpty2(Me.Codigo)) then
				.Parameters("@id") = Me.Codigo
			else
				.Parameters("@id") = VBNULL
			end if

			if(Not IsEmpty2(Me.Usuario)) then
				.Parameters("@usuario") = Me.Usuario
			'else
				'.Parameters("@usuario") = VBNULL
			end if

			if(Not IsEmpty2(Me.Ocorrencia)) then
				.Parameters("@ocorrencia") = Me.Ocorrencia
			'else
				'.Parameters("@ocorrencia") = VBNULL
			end if

			if(Not IsEmpty2(Me.Processo)) then
				.Parameters("@processo") = Me.Processo
			'else
				'.Parameters("@processo") = VBNULL
			end if

			if(Not IsEmpty2(Me.Data)) then
				.Parameters("@data") = Me.Data
			'else
				'.Parameters("@data") = VBNULL
			end if

			if(Not IsEmpty2(Me.Tipo)) then
				.Parameters("@tipo") = Me.Tipo
			'else
				'.Parameters("@tipo") = VBNULL
			end if

			if(Not IsEmpty2(Me.Prorroga)) then
				.Parameters("@prorroga") = Me.Prorroga
			'else
				'.Parameters("@prorroga") = VBNULL
			end if

			if(Not IsEmpty2(Me.TipoOcorrencia)) then
				.Parameters("@tipo_ocorrencia") = Me.TipoOcorrencia
			'else
				'.Parameters("@tipo_ocorrencia") = VBNULL
			end if

			if(Not IsEmpty2(Me.Conversao)) then
				.Parameters("@conversao") = Me.Conversao
			'else
				'.Parameters("@conversao") = VBNULL
			end if

			if(Not IsEmpty2(Me.SiglaPais)) then
				.Parameters("@sigla_pais") = Me.SiglaPais
			'else
				'.Parameters("@sigla_pais") = VBNULL
			end if

			if(Not IsEmpty2(Me.Protocolo)) then
				.Parameters("@protocolo") = Me.Protocolo
			'else
				'.Parameters("@protocolo") = VBNULL
			end if

			if(Not IsEmpty2(Me.RPI)) then
				.Parameters("@rpi") = Me.RPI
			'else
				'.Parameters("@rpi") = VBNULL
			end if

			if(Not IsEmpty2(Me.Despacho)) then
				.Parameters("@desp") = Me.Despacho
			'else
				'.Parameters("@desp") = VBNULL
			end if

			if(Not IsEmpty2(Me.Descricao)) then
				.Parameters("@descricao") = Me.Descricao
			'else
				'.Parameters("@descricao") = VBNULL
			end if

			if(Not IsEmpty2(Me.DescricaoOutroIdioma)) then
				.Parameters("@descricao_outro_idioma") = Me.DescricaoOutroIdioma
			'else
				'.Parameters("@descricao_outro_idioma") = VBNULL
			end if

			if(Not IsEmpty2(Me.DetalheOutroIdioma)) then
				.Parameters("@detalhe_outro_idioma") = Me.DetalheOutroIdioma
			'else
				'.Parameters("@detalhe_outro_idioma") = VBNULL
			end if

			if(Not IsEmpty2(Me.Idioma)) then
				.Parameters("@idioma") = Me.Idioma
			'else
				'.Parameters("@idioma") = VBNULL
			end if

			if(Not IsEmpty2(Me.VisivelResp)) then
				.Parameters("@visivelresp") = Me.VisivelResp
			'else
				'.Parameters("@visivelresp") = VBNULL
			end if

			if(Not IsEmpty2(Me.HistoricoIsis)) then
				.Parameters("@historico_isis_FK") = Me.HistoricoIsis
			'else
				'.Parameters("@historico_isis_FK") = VBNULL
			end if

			if(Not IsEmpty2(Me.ModuloConsulta)) then
				.Parameters("@mod_consulta") = Me.ModuloConsulta
			'else
				'.Parameters("@mod_consulta") = VBNULL
			end if

			
			SET rsRetorno = .Execute

		end with

		SET cmd = nothing

		if not rsRetorno.EOF then
			codigoRetorno = rsRetorno(0)
		end if

		Salvar = codigoRetorno

	End Function

'############# Funções Privadas ##############

	Private Function FillFromRS(p_RS)

		'id	int
		'usuario	varchar(50) NOT
		'ocorrencia	varchar(-1
		'processo	varchar(50) NOT
		'data	datetime NOT
		'tipo	varchar(2) NOT
		'prorroga	bit NOT
		'tipo_ocorrencia	int
		'conversao	bit
		'sigla_pais	varchar(2
		'protocolo	varchar(50
		'rpi	varchar(4
		'desp	varchar(10
		'descricao	varchar(100
		'descricao_outro_idioma	varchar(-1
		'detalhe_outro_idioma	varchar(-1
		'idioma	varchar(2
		'visivelresp	bit
		'historico_isis_FK int
		'mod_consulta int

	End Function

End Class

%>