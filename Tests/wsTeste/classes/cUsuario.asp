<%

'--------------------------------------------------------------------------'
'Author: Leandro Ribeiro
'Create: Fev/2013
'
'Dependences Parameters: 
'	N/A
'
'Dependences Files: 
'	inc_ADOHelper.asp
'
'Methods:
'	Sub Class_Initialize
'	Sub Class_Terminate
'
'--------------------------------------------------------------------------'

Class cUsuario

	Private m_Codigo
	Private m_NomeUsu
	Private m_Empresa
	Private m_Vinculado
	Private m_Status
	Private m_StatusApol
	Private m_TabelaInadimplencia
	Private m_EmailResponsavelCobranca
	Private m_dtInadimplencia
	Private m_Email

	Private p_strStatus


	Public Property Get Codigo()
		Codigo = m_Codigo
	End Property

	Public Property Let Codigo(p_Data)	
		m_Codigo = p_Data
	End Property	

	public Property Get NomeUsu()
		NomeUsu = m_NomeUsu
	End Property

	Public Property Let NomeUsu(p_Data)	
		m_NomeUsu = p_Data
	End Property	
		
	Public Property Get Empresa()
		Empresa = m_Empresa
	End Property

	Public Property Let Empresa(p_Data)
		m_Empresa = p_Data
	End Property

	Public Property Get Vinculado()
		Vinculado = m_Vinculado
	End Property

	Public Property Let Vinculado(p_Data)
		m_Vinculado = p_Data
	End Property

	Public Property Get Status()
		Status = m_Status
	End Property

	Public Property Let Status(p_Data)
		m_Status = p_Data
	End Property	

	Public Property Get StatusApol()
		StatusApol = m_StatusApol
	End Property	

	Public Property Let StatusApol(p_Data)
		m_StatusApol = p_Data
	End Property	

	'Campos incluído para controle de Inadimplencia/Bloqueio'
	Public Property Get TabelaInadimplencia()
		TabelaInadimplencia = m_TabelaInadimplencia
	End Property

	Public Property Let TabelaInadimplencia(p_Data)
		m_TabelaInadimplencia = p_Data
	End Property	

	Public Property Get EmailResponsavelCobranca()
		EmailResponsavelCobranca = m_EmailResponsavelCobranca
	End Property

	Public Property Let EmailResponsavelCobranca(p_Data)	
		m_EmailResponsavelCobranca = p_Data
	End Property

	Public Property Get DataInadimplencia()
		DataInadimplencia = m_dtInadimplencia
	End Property

	Public Property Let DataInadimplencia(p_Data)
		m_dtInadimplencia = p_Data
	End Property

	Public Property Get Email()
		Email = m_Email
	End Property

	Public Property Let Email(p_Data)
		m_Email = p_Data
	End Property

'#############  Constructors and Destructors ##############

	Sub Class_Initialize()
	End Sub

	Sub Class_Terminate()
	End Sub

'#############  Public Functions, accessible to the web pages ##############

	'OBSERVACOES:'
	'1. Quando for retornar OBJETO ou TIPO PRIMITIVO nao precisa usar SET'
	'2. Quando for retornar RECORDSET ou DICTIONARY precisa usar o SET'

	Public Function GetByCodigo(p_Codigo)

		Dim strSQL
		strSQL = "SELECT " & (_
				" 	codigo " & _
				" 	, nomeusu " & _
				" 	, empresa " & _
				" 	, vinculado " & _
				" 	, status " & _
				" 	, " & GetSQLStatusAPOL() & _
				" 	, email " & _
				" 	, TabelaInadimplencia " & _
				" 	, EmailResponsavelCobranca " & _
				" 	, dtInadimplencia" & _
				" FROM " & _
				" 	usuarios_apol..usuario " & _
				" WHERE " & _
				" (codigo = " & p_Codigo & ") " )

		GetByCodigo = LoadData (strSQL)

	End Function

	Public Function GetRSEmpresas()
		
		Dim strSQL, strSelect, strWhere, strOrderBy

		'------------
		'SELECT
		'------------
		strSelect = " SELECT " & (_
				" 	codigo " & _
			 	" 	,  rtrim(ltrim(coalesce(empresa,''))) as empresa " & _
				" 	, vinculado " & _
				" 	, dtInadimplencia " & _
				" 	, " & GetSQLStatusAPOL() & _
				" 	, CASE " & _
				" 		WHEN status_apol='" & LIBERADO_VALOR & "' AND (dtInadimplencia is not null OR dtInadimplencia<>'') THEN 1 " & _
				" 		WHEN status_apol='" & LIBERADO_VALOR & "' AND (dtInadimplencia is null OR dtInadimplencia='') THEN 2 " & _
				" 		WHEN status_apol='" & BLOQUEADO_VALOR & "' THEN 3 " & _
				" 		ELSE 3 " & _
				" 		END as status_ordem " & _
				" FROM " & _
				"	usuario ")


		'------------
		'WHERE
		'------------
		strWhere = " WHERE " & _
				" 	nomeusu = vinculado "

		If (Not IsEmpty2(p_strStatus)) Then

			Select Case p_strStatus
				Case INADIMPLENTE_VALOR
					strWhere = strWhere & "AND (status_apol='" & LIBERADO_VALOR & "' AND (dtInadimplencia is not null OR dtInadimplencia<>'')) "
				Case Else
					strWhere = strWhere & "AND status_apol='" & p_strStatus & "'"
			End Select

		End If


		'------------
		'ORDER BY
		'------------
		strOrderBy = " ORDER BY " & _
				" 	status_ordem, empresa, vinculado "


		'--------------------------------------
		'QUERY SQL = SELECT + WHERE + ORDER BY
		'--------------------------------------
		strSQL = strSelect & strWhere & strOrderBy

		Set GetRSEmpresas = LoadRSFromDB(strSQL)

	End Function

	Public Function GetRSEmpresasInadimplentes(p_Status)

		p_strStatus = p_Status

		Set GetRSEmpresasInadimplentes = GetRSEmpresas()

	End Function

	Public Function GetRSUsuarioLoginByNomeUsu(p_NomeUsu)

		Dim strSQL

		strSQL =  " SELECT " & (_
				"   usuario.num_tentativas_logon " & _
				" , usuario.max_tentativas_logon " & _
				" , usuario.prazo_expiracao_senha " & _
				" , usuario.dt_expiracao_senha " & _
				" , usuario.acesso_bloqueado " & _
				" , usuario.excluido " & _
				" , usuario.senha " & _
				" , usuario_1.codigo as codigo_vinculado " & _
				" , usuario.vinculado " & _
				" , usuario.modulo " & _
				" , usuario.codigo " & _
				" , usuario.nomeusu " & _
				" , usuario.email " & _
				" , usuario.senha " & _
				" , usuario.empresa " & _
				" , usuario.dtInadimplencia " & _
				" , usuario_1.DT_BL1_apol " & _
				" , usuario_1.status_apol " & _
			" FROM " & _
				" usuario " & _
				" INNER JOIN usuario usuario_1 ON usuario.vinculado = usuario_1.nomeusu " & _
			" WHERE " & _
				" usuario.nomeusu = '" & p_NomeUsu & "' " & _
				" AND usuario.apol = 1 ")

		Set GetRSUsuarioLoginByNomeUsu = LoadRSFromDB(strSQL)
		
	End Function

	Public Sub AtualizarTentativaLogin(p_NomeUsu)
		Dim strSQL : strSQL = "UPDATE usuario SET num_tentativas_logon = num_tentativas_logon + 1 WHERE nomeusu = '" & p_NomeUsu & "'"
		RunSQL strSQL

	End Sub

	'/* ------------------------------------------------------------------------------------------- *\
  	'	Nome    : BloquearUsuario
  	'	Descrição : Bloqueia o acesso do usuário por máximo de tentativas de autenticacao excedidas
  	'	Quem utiliza : login_apol.asp
	'/* ------------------------------------------------------------------------------------------- *\
	Public Sub BloquearUsuario(p_NomeUsu)
		Dim strSQL : strSQL = "UPDATE usuario SET acesso_bloqueado = 1, num_tentativas_logon = 0 WHERE nomeusu = '" & p_NomeUsu & "'"
		RunSQL strSQL
		
	End Sub

	'/* ------------------------------------------------------------------------------------------- *\
  	'	Nome    : MudarParaAdimplente
  	'	Descrição : Altera a situação do Cliente Titular para Adimplente (sem dívidas)
  	'	Quem utiliza : adm\bloqueio\altera_situacao_cliente.asp
	'/* ------------------------------------------------------------------------------------------- *\
	Public Function MudarParaAdimplente()
		'Limpando controle de inadimplencia'

		Me.StatusApol = LIBERADO_VALOR
		Me.TabelaInadimplencia = ""
		Me.DataInadimplencia = ""

		Call AtualizarDadosDeInadimplencia()

		MudarParaAdimplente = True
		
	End Function

	'/* ------------------------------------------------------------------------------------------- *\
  	'	Nome    : MudarParaInadimplente
  	'	Descrição : Altera a situação do Cliente Titular para Inadimplente (com dívidas)
  	'	Quem utiliza : adm\bloqueio\altera_situacao_cliente.asp
	'/* ------------------------------------------------------------------------------------------- *\
	Public Function MudarParaInadimplente()

		' ***** ATENCAO *****
		' Nao remova isto, foi feita dessa forma para permitir controlar inadimplentes sem ter que alterar todo o sistema. 
		' Eh feio eu sei, mas foi solicitado ser feito assim para causar menor impacto no sistema (vbs e etc)'

		Me.StatusApol = LIBERADO_VALOR
		Me.DataInadimplencia = Date()

		Call AtualizarDadosDeInadimplencia()

		MudarParaInadimplente = True

	End Function


	'Atualiza campos [status_apol, EmailResponsavelCobranca, TabelaInadimplencia, dtInadimplencia]'
    Public Function AtualizarDadosDeInadimplencia()

    	Dim strSQL
        
        strSQL = strSQL & " UPDATE usuarios_apol..usuario SET "

        strSQL = strSQL & " status_apol = '" & SingleQuotes(Me.StatusApol) & "' "

        If(Not IsEmpty2(Me.EmailResponsavelCobranca)) Then
			strSQL = strSQL & " , EmailResponsavelCobranca = '" & SingleQuotes(Me.EmailResponsavelCobranca) & "' "
		Else
			strSQL = strSQL & " , EmailResponsavelCobranca = NULL "
		End If

        If(Not IsEmpty2(Me.TabelaInadimplencia)) Then
        	strSQL = strSQL & " , TabelaInadimplencia = '" & SingleQuotes(Me.TabelaInadimplencia) & "' "
        Else
        	strSQL = strSQL & " , TabelaInadimplencia = NULL "
        End If

        If(Not IsEmpty2(Me.DataInadimplencia)) Then
        	strSQL = strSQL & " , dtInadimplencia = " & rdata(Me.DataInadimplencia) & " "
        Else
        	strSQL = strSQL & " , dtInadimplencia = NULL "
        End If

        strSQL = strSQL & " WHERE codigo = " & Me.Codigo

        RunSQL strSQL            

        AtualizarDadosDeInadimplencia =  Me.Codigo

    End Function 


'############# Private Functions ##############

	
	'Monta SQL CASE que simula o STATUS I - INADIMPLENTE para a aplicação
	Private Function GetSQLStatusAPOL()

		Dim strSQL

		strSQL = " CASE " & (_
		" 	WHEN status_apol='" & LIBERADO_VALOR & "' AND (dtInadimplencia is null or dtInadimplencia='') THEN '" & LIBERADO_VALOR & "' " & _
		" 	WHEN status_apol='" & LIBERADO_VALOR & "' AND (dtInadimplencia is not null or dtInadimplencia<>'') THEN '" & INADIMPLENTE_VALOR & "' " & _
		" 	ELSE '" & BLOQUEADO_VALOR & "' " & _
		" END as status_apol ")

		GetSQLStatusAPOL = strSQL

	End Function

	'Takes a recordset
	'Fills the object's properties using the recordset
	Private Function FillFromRS(p_RS)
		select case p_RS.recordcount
		case 1
			Me.Codigo 			= p_RS.fields("codigo").Value
			Me.Email 			= p_RS.fields("email").Value
			Me.NomeUsu 			= p_RS.fields("nomeusu").Value
			Me.Empresa          = p_RS.fields("empresa").Value
			'Vinculado'
			If FieldExists(p_RS, "vinculado") Then 
				Me.vinculado = p_RS.fields("vinculado").Value
			End If
			Me.Status           = p_RS.fields("status").Value
			Me.StatusApol       = p_RS.fields("status_apol").Value
			'TabelaInadimplencia'
			If FieldExists(p_RS, "TabelaInadimplencia") Then 
				Me.TabelaInadimplencia = p_RS.fields("TabelaInadimplencia").Value
			End If
			'EmailResponsavelCobranca'
			If FieldExists(p_RS, "EmailResponsavelCobranca") Then
				Me.EmailResponsavelCobranca = p_RS.fields("EmailResponsavelCobranca").Value
			End If
			'DataInadimplencia'
			If FieldExists(p_RS, "dtInadimplencia") Then
				Me.DataInadimplencia = p_RS.fields("dtInadimplencia").Value
			End If

			FillFromRS          = Me.NomeUsu
		case -1, 0
			err.raise 2, "Item was not found"
		case else
			err.raise 3, "Item was not unique"            
		end select
	End Function


	Private Function LoadData(p_strSQL)
		Dim rs
		set rs = LoadRSFromDB(p_strSQL)
		LoadData = FillFromRS(rs)
		rs.Close
		set rs = nothing
	End Function
   

End Class

%>