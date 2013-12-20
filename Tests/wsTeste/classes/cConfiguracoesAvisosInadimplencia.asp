<%
Class cConfiguracoesAvisosInadimplencia

    Private m_Id
    Private m_Aviso_Tela_Login
    Private m_Aviso_Tela_Modulos
    Private m_Conteudo_Comunicado1
    Private m_Conteudo_Comunicado2
    Private m_Conteudo_Comunicado3
    Private m_Conteudo_Comunicado4
    Private m_Assunto_Comunicado1
    Private m_Assunto_Comunicado2
    Private m_Assunto_Comunicado3
    Private m_Assunto_Comunicado4

    Dim sTmp
    
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

    'Aviso_Tela_Login
    Public Property Get Aviso_Tela_Login()
        sTmp = Trim(m_Aviso_Tela_Login)
        If Trim(sTmp) = "" Then sTmp = null 
        Aviso_Tela_Login=stmp
    End Property
    Public Property Let Aviso_Tela_Login(x_Aviso_Tela_Login)
        sTmp = Trim(x_Aviso_Tela_Login)
        If Trim(sTmp) = "" Then sTmp = Null
        m_Aviso_Tela_Login=stmp
    End Property

    'Aviso_Tela_Modulos
    Public Property Get Aviso_Tela_Modulos()
        sTmp = Trim(m_Aviso_Tela_Modulos)
        If Trim(sTmp) = "" Then sTmp = null 
        Aviso_Tela_Modulos=stmp
    End Property
    Public Property Let Aviso_Tela_Modulos(x_Aviso_Tela_Modulos)
        sTmp = Trim(x_Aviso_Tela_Modulos)
        If Trim(sTmp) = "" Then sTmp = Null
        m_Aviso_Tela_Modulos=stmp
    End Property

    'Conteudo_Comunicado1
    Public Property Get Conteudo_Comunicado1()
        sTmp = Trim(m_Conteudo_Comunicado1)
        If Trim(sTmp) = "" Then sTmp = null 
        Conteudo_Comunicado1=stmp
    End Property
    Public Property Let Conteudo_Comunicado1(x_Conteudo_Comunicado1)
        sTmp = Trim(x_Conteudo_Comunicado1)
        If Trim(sTmp) = "" Then sTmp = Null
        m_Conteudo_Comunicado1=stmp
    End Property

    'Conteudo_Comunicado2
    Public Property Get Conteudo_Comunicado2()
        sTmp = Trim(m_Conteudo_Comunicado2)
        If Trim(sTmp) = "" Then sTmp = null 
        Conteudo_Comunicado2=stmp
    End Property
    Public Property Let Conteudo_Comunicado2(x_Conteudo_Comunicado2)
        sTmp = Trim(x_Conteudo_Comunicado2)
        If Trim(sTmp) = "" Then sTmp = Null
        m_Conteudo_Comunicado2=stmp
    End Property

    'Conteudo_Comunicado3
    Public Property Get Conteudo_Comunicado3()
        sTmp = Trim(m_Conteudo_Comunicado3)
        If Trim(sTmp) = "" Then sTmp = null 
        Conteudo_Comunicado3=stmp
    End Property
    Public Property Let Conteudo_Comunicado3(x_Conteudo_Comunicado3)
        sTmp = Trim(x_Conteudo_Comunicado3)
        If Trim(sTmp) = "" Then sTmp = Null
        m_Conteudo_Comunicado3=stmp
    End Property

    'Conteudo_Comunicado4
    Public Property Get Conteudo_Comunicado4()
        sTmp = Trim(m_Conteudo_Comunicado4)
        If Trim(sTmp) = "" Then sTmp = null 
        Conteudo_Comunicado4=stmp
    End Property
    Public Property Let Conteudo_Comunicado4(x_Conteudo_Comunicado4)
        sTmp = Trim(x_Conteudo_Comunicado4)
        If Trim(sTmp) = "" Then sTmp = Null
        m_Conteudo_Comunicado4=stmp
    End Property

    'Assunto_Comunicado1
    Public Property Get Assunto_Comunicado1()
        sTmp = Trim(m_Assunto_Comunicado1)
        If Trim(sTmp) = "" Then sTmp = null 
        Assunto_Comunicado1=stmp
    End Property
    Public Property Let Assunto_Comunicado1(x_Assunto_Comunicado1)
        sTmp = Trim(x_Assunto_Comunicado1)
        If Trim(sTmp) = "" Then sTmp = Null
        m_Assunto_Comunicado1=stmp
    End Property

    'Assunto_Comunicado2
    Public Property Get Assunto_Comunicado2()
        sTmp = Trim(m_Assunto_Comunicado2)
        If Trim(sTmp) = "" Then sTmp = null 
        Assunto_Comunicado2=stmp
    End Property
    Public Property Let Assunto_Comunicado2(x_Assunto_Comunicado2)
        sTmp = Trim(x_Assunto_Comunicado2)
        If Trim(sTmp) = "" Then sTmp = Null
        m_Assunto_Comunicado2=stmp
    End Property

    'Assunto_Comunicado3
    Public Property Get Assunto_Comunicado3()
        sTmp = Trim(m_Assunto_Comunicado3)
        If Trim(sTmp) = "" Then sTmp = null 
        Assunto_Comunicado3=stmp
    End Property
    Public Property Let Assunto_Comunicado3(x_Assunto_Comunicado3)
        sTmp = Trim(x_Assunto_Comunicado3)
        If Trim(sTmp) = "" Then sTmp = Null
        m_Assunto_Comunicado3=stmp
    End Property

    'Assunto_Comunicado4
    Public Property Get Assunto_Comunicado4()
        sTmp = Trim(m_Assunto_Comunicado4)
        If Trim(sTmp) = "" Then sTmp = null 
        Assunto_Comunicado4=stmp
    End Property
    Public Property Let Assunto_Comunicado4(x_Assunto_Comunicado4)
        sTmp = Trim(x_Assunto_Comunicado4)
        If Trim(sTmp) = "" Then sTmp = Null
        m_Assunto_Comunicado4=stmp
    End Property    

'#############  Constructors and Destructors ##############

	Sub Class_Initialize()
        Me.Id = 0
	End Sub

	Sub Class_Terminate()
	End Sub

'#############  Public Functions, accessible to the web pages ##############

	Public Function Store()
		Dim strSQL
        
        If(IsNull(Me.Id) Or IsEmpty(Me.Id) Or Me.Id < 1) then
            	
            Dim ArrFlds, ArrValues
            ArrFlds= array("Aviso_Tela_Login","Aviso_Tela_Modulos","Conteudo_Comunicado1","Conteudo_Comunicado2","Conteudo_Comunicado3","Conteudo_Comunicado4", "Assunto_Comunicado1", "Assunto_Comunicado2", "Assunto_Comunicado3", "Assunto_Comunicado4")
        	ArrValues = array(Me.Aviso_Tela_Login,Me.Aviso_Tela_Modulos,Me.Conteudo_Comunicado1,Me.Conteudo_Comunicado2,Me.Conteudo_Comunicado3,Me.Conteudo_Comunicado4, Me.Assunto_Comunicado1, Me.Assunto_Comunicado2, Me.Assunto_Comunicado3, Me.Assunto_Comunicado4)

            Me.Id = InsertRecord("Configuracoes_Avisos_Inadimplencia", "Id", ArrFlds, ArrValues)       

        'Otherwise run an update
        else                	

			strSQL = " UPDATE Configuracoes_Avisos_Inadimplencia " & (_
                    " SET " & _
            			" Aviso_Tela_Login ='"& m_Aviso_Tela_Login &"' " & _
            			" , Aviso_Tela_Modulos ='"& m_Aviso_Tela_Modulos &"' " & _
            			" , Conteudo_Comunicado1 ='"& m_Conteudo_Comunicado1 &"' " & _
            			" , Conteudo_Comunicado2 ='"& m_Conteudo_Comunicado2 &"' " & _
            			" , Conteudo_Comunicado3 ='"& m_Conteudo_Comunicado3 &"' " & _
            			" , Conteudo_Comunicado4 ='"& m_Conteudo_Comunicado4 &"' " & _
                        " , Assunto_Comunicado1 ='"& m_Assunto_Comunicado1 &"' " & _
                        " , Assunto_Comunicado2 ='"& m_Assunto_Comunicado2 &"' " & _
                        " , Assunto_Comunicado3 ='"& m_Assunto_Comunicado3 &"' " & _
                        " , Assunto_Comunicado4 ='"& m_Assunto_Comunicado4 &"' " & _
         			" WHERE Id= " & m_Id )

            RunSQL strSQL

        End if
        
        Store =  Me.Id

	End Function

	Public Function GetById(p_Id)
		Dim strSQL
		strSQL = "SELECT Id, Aviso_Tela_Login, Aviso_Tela_Modulos, Conteudo_Comunicado1, Conteudo_Comunicado2, Conteudo_Comunicado3, Conteudo_Comunicado4, Assunto_Comunicado1, Assunto_Comunicado2, Assunto_Comunicado3, Assunto_Comunicado4 "
		strSQL = strSQL & " FROM Configuracoes_Avisos_Inadimplencia "
		strSQL = strSQL & " WHERE (Id = " & p_Id & ") "

		GetById = LoadData (strSQL)
	End Function

    Public Function GetFirst()
        Dim strSQL
        strSQL = "SELECT TOP 1 Id, Aviso_Tela_Login, Aviso_Tela_Modulos, Conteudo_Comunicado1, Conteudo_Comunicado2, Conteudo_Comunicado3, Conteudo_Comunicado4, Assunto_Comunicado1, Assunto_Comunicado2, Assunto_Comunicado3, Assunto_Comunicado4 "
        strSQL = strSQL & " FROM Configuracoes_Avisos_Inadimplencia "

        'Response.Write(strSQL)
        'Response.Flush

        GetFirst = LoadData (strSQL)
    End Function

'#############  Private Functions                           ##############
	
	'Takes a recordset
	'Fills the object's properties using the recordset
	Private Function FillFromRS(p_RS)

		select case p_RS.recordcount
		case 1

			Me.Id = p_RS.fields("Id").Value
			Me.Aviso_Tela_Login = p_RS.fields("Aviso_Tela_Login").Value
			Me.Aviso_Tela_Modulos = p_RS.fields("Aviso_Tela_Modulos").Value
			Me.Conteudo_Comunicado1 = p_RS.fields("Conteudo_Comunicado1").Value
			Me.Conteudo_Comunicado2 = p_RS.fields("Conteudo_Comunicado2").Value
			Me.Conteudo_Comunicado3 = p_RS.fields("Conteudo_Comunicado3").Value
			Me.Conteudo_Comunicado4 = p_RS.fields("Conteudo_Comunicado4").Value

            Me.Assunto_Comunicado1 = p_RS.fields("Assunto_Comunicado1").Value
            Me.Assunto_Comunicado2 = p_RS.fields("Assunto_Comunicado2").Value
            Me.Assunto_Comunicado3 = p_RS.fields("Assunto_Comunicado3").Value
            Me.Assunto_Comunicado4 = p_RS.fields("Assunto_Comunicado4").Value

			FillFromRS          = Me.Id
        'TODO LEANDRO RIBEIRO'
		'case -1, 0
			'err.raise 2, "Item was not found"
		'case else
			'err.raise 3, "Item was not unique"            
		end select
        
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