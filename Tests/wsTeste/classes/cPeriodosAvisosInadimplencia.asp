<%
Class cPeriodosAvisosInadimplencia

    Dim sTmp

	Private m_Id
    Private m_Cliente_Id
    Private m_Aviso_Tela_Login_QtdDias
    Private m_Aviso_Tela_Modulos_QtdDias
    Private m_Envio_Comunicado1_QtdDias
    Private m_Envio_Comunicado2_QtdDias
    Private m_Envio_Comunicado3_QtdDias
    Private m_Envio_Comunicado4_QtdDias
    Private m_Envio_Comunicado4_QtdSemanas
    Private m_Destinatarios_Em_Copia_Envio_Comunicado

    'Id
    Public Property Get Id()
        If Not IsNumeric(m_Id) OR isEmpty(m_Id) Then
            Id=null
        Else
            Id=m_Id
        End If
    End Property
    Public Property Let Id(x_Id)
        sTmp = x_Id
        If Not IsNumeric(sTmp) Then
             sTmp = Null
        Else
            sTmp = CLng(sTmp)
        End If
        m_Id=stmp
    End Property

    'Cliente_Id
    Public Property Get Cliente_Id()
        If Not IsNumeric(m_Cliente_Id) OR isEmpty(m_Cliente_Id) Then
            Cliente_Id=null
        Else
            Cliente_Id=m_Cliente_Id
        End If
    End Property
    Public Property Let Cliente_Id(x_Cliente_Id)
        sTmp = x_Cliente_Id
        If Not IsNumeric(sTmp) Then
             sTmp = Null
        Else
            sTmp = CLng(sTmp)
        End If
        m_Cliente_Id=stmp
    End Property

    'Aviso_Tela_Login_QtdDias
    Public Property Get Aviso_Tela_Login_QtdDias()
        If Not IsNumeric(m_Aviso_Tela_Login_QtdDias) OR isEmpty(m_Aviso_Tela_Login_QtdDias) Then
            Aviso_Tela_Login_QtdDias=null
        Else
            Aviso_Tela_Login_QtdDias=m_Aviso_Tela_Login_QtdDias
        End If
    End Property
    Public Property Let Aviso_Tela_Login_QtdDias(x_Aviso_Tela_Login_QtdDias)
        sTmp = x_Aviso_Tela_Login_QtdDias
        If Not IsNumeric(sTmp) Then
             sTmp = Null
        Else
            sTmp = CLng(sTmp)
        End If
        m_Aviso_Tela_Login_QtdDias=stmp
    End Property

    'Aviso_Tela_Modulos_QtdDias
    Public Property Get Aviso_Tela_Modulos_QtdDias()
        If Not IsNumeric(m_Aviso_Tela_Modulos_QtdDias) OR isEmpty(m_Aviso_Tela_Modulos_QtdDias) Then
            Aviso_Tela_Modulos_QtdDias=null
        Else
            Aviso_Tela_Modulos_QtdDias=m_Aviso_Tela_Modulos_QtdDias
        End If
    End Property
    Public Property Let Aviso_Tela_Modulos_QtdDias(x_Aviso_Tela_Modulos_QtdDias)
        sTmp = x_Aviso_Tela_Modulos_QtdDias
        If Not IsNumeric(sTmp) Then
             sTmp = Null
        Else
            sTmp = CLng(sTmp)
        End If
        m_Aviso_Tela_Modulos_QtdDias=stmp
    End Property

    'Envio_Comunicado1_QtdDias
    Public Property Get Envio_Comunicado1_QtdDias()
        If Not IsNumeric(m_Envio_Comunicado1_QtdDias) OR isEmpty(m_Envio_Comunicado1_QtdDias) Then
            Envio_Comunicado1_QtdDias=null
        Else
            Envio_Comunicado1_QtdDias=m_Envio_Comunicado1_QtdDias
        End If
    End Property
    Public Property Let Envio_Comunicado1_QtdDias(x_Envio_Comunicado1_QtdDias)
        sTmp = x_Envio_Comunicado1_QtdDias
        If Not IsNumeric(sTmp) Then
             sTmp = Null
        Else
            sTmp = CLng(sTmp)
        End If
        m_Envio_Comunicado1_QtdDias=stmp
    End Property

    'Envio_Comunicado2_QtdDias
    Public Property Get Envio_Comunicado2_QtdDias()
        If Not IsNumeric(m_Envio_Comunicado2_QtdDias) OR isEmpty(m_Envio_Comunicado2_QtdDias) Then
            Envio_Comunicado2_QtdDias=null
        Else
            Envio_Comunicado2_QtdDias=m_Envio_Comunicado2_QtdDias
        End If
    End Property
    Public Property Let Envio_Comunicado2_QtdDias(x_Envio_Comunicado2_QtdDias)
        sTmp = x_Envio_Comunicado2_QtdDias
        If Not IsNumeric(sTmp) Then
             sTmp = Null
        Else
            sTmp = CLng(sTmp)
        End If
        m_Envio_Comunicado2_QtdDias=stmp
    End Property

    'Envio_Comunicado3_QtdDias
    Public Property Get Envio_Comunicado3_QtdDias()
        If Not IsNumeric(m_Envio_Comunicado3_QtdDias) OR isEmpty(m_Envio_Comunicado3_QtdDias) Then
            Envio_Comunicado3_QtdDias=null
        Else
            Envio_Comunicado3_QtdDias=m_Envio_Comunicado3_QtdDias
        End If
    End Property
    Public Property Let Envio_Comunicado3_QtdDias(x_Envio_Comunicado3_QtdDias)
        sTmp = x_Envio_Comunicado3_QtdDias
        If Not IsNumeric(sTmp) Then
             sTmp = Null
        Else
            sTmp = CLng(sTmp)
        End If
        m_Envio_Comunicado3_QtdDias=stmp
    End Property

    'Envio_Comunicado4_QtdDias
    Public Property Get Envio_Comunicado4_QtdDias()
        If Not IsNumeric(m_Envio_Comunicado4_QtdDias) OR isEmpty(m_Envio_Comunicado4_QtdDias) Then
            Envio_Comunicado4_QtdDias=null
        Else
            Envio_Comunicado4_QtdDias=m_Envio_Comunicado4_QtdDias
        End If
    End Property
    Public Property Let Envio_Comunicado4_QtdDias(x_Envio_Comunicado4_QtdDias)
        sTmp = x_Envio_Comunicado4_QtdDias
        If Not IsNumeric(sTmp) Then
             sTmp = Null
        Else
            sTmp = CLng(sTmp)
        End If
        m_Envio_Comunicado4_QtdDias=stmp
    End Property

    'Envio_Comunicado4_QtdSemanas
    Public Property Get Envio_Comunicado4_QtdSemanas()
        If Not IsNumeric(m_Envio_Comunicado4_QtdSemanas) OR isEmpty(m_Envio_Comunicado4_QtdSemanas) Then
            Envio_Comunicado4_QtdSemanas=null
        Else
            Envio_Comunicado4_QtdSemanas=m_Envio_Comunicado4_QtdSemanas
        End If
    End Property
    Public Property Let Envio_Comunicado4_QtdSemanas(x_Envio_Comunicado4_QtdSemanas)
        sTmp = x_Envio_Comunicado4_QtdSemanas
        If Not IsNumeric(sTmp) Then
             sTmp = Null
        Else
            sTmp = CLng(sTmp)
        End If
        m_Envio_Comunicado4_QtdSemanas=stmp
    End Property

    'Destinatarios_Em_Copia_Envio_Comunicado'
    Public Property Get Destinatarios_Em_Copia_Envio_Comunicado()
        Destinatarios_Em_Copia_Envio_Comunicado = m_Destinatarios_Em_Copia_Envio_Comunicado
    End Property

    Public Property Let Destinatarios_Em_Copia_Envio_Comunicado(p_Data)
        m_Destinatarios_Em_Copia_Envio_Comunicado = p_Data
    End Property

'#############  Constructors and Destructors ##############

	Sub Class_Initialize()
        Me.Id = 0
	End Sub

	Sub Class_Terminate()
	End Sub

'#############  Public Functions, accessible to the web pages ##############

    Public Function FindByCliente(p_NomeUsu)

        Call FindByNomeUsu(p_NomeUsu)

        'Caso não tenha encontrado registro no banco de dados'
        If(Me.Id < 1) Then 
            Call GetFirst()
        End If

        FindByCliente = Me.Id

    End Function

    Public Function GetById(p_Id) 'Objeto Scriting Dictinary
        if not isnumeric(p_Id) or isEmpty(p_Id) then
            p_Id=0
        else
            p_Id=clng(p_Id)
        End if
        
        Dim strSQL
        strSQL = "SELECT [Id], [Cliente_Id],[Aviso_Tela_Login_QtdDias],[Aviso_Tela_Modulos_QtdDias],[Envio_Comunicado1_QtdDias],[Envio_Comunicado2_QtdDias],[Envio_Comunicado3_QtdDias],[Envio_Comunicado4_QtdDias],[Envio_Comunicado4_QtdSemanas], [Destinatarios_Em_Copia_Envio_Comunicado] "
        strSQL = strSQL & " FROM Periodos_Avisos_Inadimplencia "
        strSQL = strSQL & " WHERE Id=" & p_Id
        
        GetById = LoadData (strSQL)

     End Function

    Public Function FindByCliente_Id(p_ClienteId) 'Objeto Scriting Dictinary
        
        if not isnumeric(p_ClienteId) or isEmpty(p_ClienteId) then
            p_ClienteId=0
        else
            p_ClienteId=clng(p_ClienteId)
        End if
        
        Dim strSQL
        strSQL = "SELECT " & (_
            "   [Id], " & _
            "   [Cliente_Id], " & _
            "   [Aviso_Tela_Login_QtdDias], " & _
            "   [Aviso_Tela_Modulos_QtdDias], " & _
            "   [Envio_Comunicado1_QtdDias], " & _
            "   [Envio_Comunicado2_QtdDias], " & _
            "   [Envio_Comunicado3_QtdDias], " & _
            "   [Envio_Comunicado4_QtdDias], " & _
            "   [Envio_Comunicado4_QtdSemanas], " & _
            "   [Destinatarios_Em_Copia_Envio_Comunicado] " & _
            " FROM " & _
            "   Periodos_Avisos_Inadimplencia " & _
            " WHERE " & _
            " Cliente_Id=" & p_ClienteId & vbCrLf _
        )
        
        FindByCliente_Id = LoadData(strSQL)

     End Function

     Public Function FindByNomeUsu(p_NomeUsu) 'Objeto Scriting Dictinary
                
        Dim strSQL

       strSQL =" SELECT " & (_
            "   pai.[Id], " & _
            "   pai.[Cliente_Id], " & _
            "   pai.[Aviso_Tela_Login_QtdDias], " & _
            "   pai.[Aviso_Tela_Modulos_QtdDias], " & _
            "   pai.[Envio_Comunicado1_QtdDias], " & _
            "   pai.[Envio_Comunicado2_QtdDias], " & _
            "   pai.[Envio_Comunicado3_QtdDias], " & _
            "   pai.[Envio_Comunicado4_QtdDias], " & _
            "   pai.[Envio_Comunicado4_QtdSemanas], " & _
            "   pai.[Destinatarios_Em_Copia_Envio_Comunicado] " & _
            " FROM " & _
            "   Periodos_Avisos_Inadimplencia pai " & _
            "   INNER JOIN usuario u on pai.Cliente_Id=u.codigo " & _
            " WHERE " & _
            "   u.nomeusu= '" & p_NomeUsu & "'" & vbCrLf _
        )
        
        FindByNomeUsu = LoadData(strSQL)

     End Function
    
    Public Function GetFirst() 'Objeto Scriting Dictinary
        
        Dim strSQL
        strSQL = "SELECT TOP 1 [Id], [Cliente_Id],[Aviso_Tela_Login_QtdDias],[Aviso_Tela_Modulos_QtdDias],[Envio_Comunicado1_QtdDias],[Envio_Comunicado2_QtdDias],[Envio_Comunicado3_QtdDias],[Envio_Comunicado4_QtdDias],[Envio_Comunicado4_QtdSemanas],[Destinatarios_Em_Copia_Envio_Comunicado] "
        strSQL = strSQL & " FROM Periodos_Avisos_Inadimplencia "
        
        GetFirst = LoadData (strSQL)

     End Function     
    
    Public Function DeleteByUsuarioCodigo(p_UsuarioCodigo)
        Dim strSQL
        strSQL = "DELETE "
        strSQL = strSQL & " FROM Periodos_Avisos_Inadimplencia "
        strSQL = strSQL & " WHERE (Cliente_Id = " & p_UsuarioCodigo & ") "

        RunSQL(strSQL)
    End Function

    Public Function Store()
        Dim strSQL
        
        If(IsNull(Me.Id) Or IsEmpty(Me.Id) Or Me.Id < 1) then
            
            Dim ArrFlds, ArrValues

            ArrFlds = Array("Cliente_Id", "Aviso_Tela_Login_QtdDias", "Aviso_Tela_Modulos_QtdDias", "Envio_Comunicado1_QtdDias", "Envio_Comunicado2_QtdDias", "Envio_Comunicado3_QtdDias", "Envio_Comunicado4_QtdDias", "Envio_Comunicado4_QtdSemanas", "Destinatarios_Em_Copia_Envio_Comunicado")
            ArrValues = Array(Me.Cliente_Id, Me.Aviso_Tela_Login_QtdDias, Me.Aviso_Tela_Modulos_QtdDias, Me.Envio_Comunicado1_QtdDias, Me.Envio_Comunicado2_QtdDias, Me.Envio_Comunicado3_QtdDias, Me.Envio_Comunicado4_QtdDias, Me.Envio_Comunicado4_QtdSemanas, Me.Destinatarios_Em_Copia_Envio_Comunicado)

            Me.Id = InsertRecord("Periodos_Avisos_Inadimplencia", "Id", ArrFlds, ArrValues)       

        'Otherwise run an update
        Else                    

            strSQL = strSQL & " UPDATE Periodos_Avisos_Inadimplencia SET "
            
            If(Not IsEmpty2(Me.Cliente_Id)) Then
                strSQL = strSQL & " Cliente_Id = " & Me.Cliente_Id & ", "
            Else
                strSQL = strSQL & " Cliente_Id = NULL, "
            End If

            If(Not IsEmpty2(Me.Aviso_Tela_Login_QtdDias)) Then
                strSQL = strSQL & " Aviso_Tela_Login_QtdDias = " & Me.Aviso_Tela_Login_QtdDias & ", "
            Else
                strSQL = strSQL & " Aviso_Tela_Login_QtdDias = NULL, "
            End If

            strSQL = strSQL & " Aviso_Tela_Modulos_QtdDias = " & Me.Aviso_Tela_Modulos_QtdDias & ", "
            strSQL = strSQL & " Envio_Comunicado1_QtdDias = " & Me.Envio_Comunicado1_QtdDias & ", "
            strSQL = strSQL & " Envio_Comunicado2_QtdDias = " & Me.Envio_Comunicado2_QtdDias & ", "
            strSQL = strSQL & " Envio_Comunicado3_QtdDias = " & Me.Envio_Comunicado3_QtdDias & ", "
            strSQL = strSQL & " Envio_Comunicado4_QtdDias = " & Me.Envio_Comunicado4_QtdDias & ", "
            strSQL = strSQL & " Envio_Comunicado4_QtdSemanas = " & Me.Envio_Comunicado4_QtdSemanas & ", "

            If(Not IsEmpty2(Me.Destinatarios_Em_Copia_Envio_Comunicado)) Then
                strSQL = strSQL & " Destinatarios_Em_Copia_Envio_Comunicado = '" & Me.Destinatarios_Em_Copia_Envio_Comunicado & "' "
            Else
                strSQL = strSQL & " Destinatarios_Em_Copia_Envio_Comunicado = NULL "
            End If

            strSQL = strSQL & " WHERE Id = " & Me.Id

            RunSQL strSQL            

        End if
        
        Store =  Me.Id

    End Function

'#############  Private Functions                           ##############

	'Takes a recordset
	'Fills the object's properties using the recordset
	Private Function FillFromRS(p_RS)
		'select case p_RS.recordcount
		'case 1

        If (p_RS.recordcount>0) Then

            Me.Id = p_RS.fields("Id").Value
            Me.Cliente_Id = p_RS.fields("Cliente_Id").Value
            Me.Aviso_Tela_Login_QtdDias = p_RS.fields("Aviso_Tela_Login_QtdDias").Value
            Me.Aviso_Tela_Modulos_QtdDias = p_RS.fields("Aviso_Tela_Modulos_QtdDias").Value
            Me.Envio_Comunicado1_QtdDias = p_RS.fields("Envio_Comunicado1_QtdDias").Value
            Me.Envio_Comunicado2_QtdDias = p_RS.fields("Envio_Comunicado2_QtdDias").Value
            Me.Envio_Comunicado3_QtdDias = p_RS.fields("Envio_Comunicado3_QtdDias").Value
            Me.Envio_Comunicado4_QtdDias = p_RS.fields("Envio_Comunicado4_QtdDias").Value
            Me.Envio_Comunicado4_QtdSemanas = p_RS.fields("Envio_Comunicado4_QtdSemanas").Value
            Me.Destinatarios_Em_Copia_Envio_Comunicado = p_RS.fields("Destinatarios_Em_Copia_Envio_Comunicado").Value

			FillFromRS          = Me.Id

        End If
        
		'case -1, 0
			'err.raise 2, "Item was not found"
		'case else
			'err.raise 3, "Item was not unique"            
		'end select
	End Function


	Private Function LoadData(p_strSQL)
		dim rs
		set rs = LoadRSFromDB(p_strSQL)
		LoadData = FillFromRS(rs)
		rs.Close
		set rs = nothing
	End Function

End Class
%>
