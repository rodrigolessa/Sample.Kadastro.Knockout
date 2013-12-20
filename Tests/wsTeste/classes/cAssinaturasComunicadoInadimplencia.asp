<%

Class cAssinaturasComunicadoInadimplencia

	Private m_Id
	Private m_Nome	
	Private m_Conteudo
	Private m_Principal

	Public Property Get Id()
		Id = m_Id
	End Property

	Public Property Let Id(p_Data)
		m_Id = p_Data
	End Property

	Public Property Get Nome()
		Nome = m_Nome		
	End Property

	Public Property Let Nome(p_Data)	
		m_Nome = p_Data
	End Property	

	Public Property Get Conteudo()
		Conteudo = m_Conteudo		
	End Property

	Public Property Let Conteudo(p_Data)	
		m_Conteudo = p_Data
	End Property	

	Public Property Get Principal()
		Principal = m_Principal		
	End Property

	Public Property Let Principal(p_Data)	
		m_Principal = p_Data
	End Property		

'#############  Constructors and Destructors ##############

	Sub Class_Initialize()
		Me.Id = 0
	End Sub

	Sub Class_Terminate()
	End Sub

'#############  Public Functions, accessible to the web pages ##############

	Public Function GetRSAll()
		dim strSQL
		strSQL = "SELECT Id, Nome, Conteudo, Principal FROM Assinaturas_Comunicado_Inadimplencia ORDER BY Nome"
		Set GetRSAll = LoadRSFromDB(strSQL)
	End Function	

	Public Function GetRSByNome(p_Nome)
		dim strSQL
		strSQL = "SELECT Id, Nome, Conteudo, Principal FROM Assinaturas_Comunicado_Inadimplencia WHERE (Nome = '" & SingleQuotes(p_Nome) & "');"

		Set GetRSByNome = LoadRSFromDB(strSQL)
	End Function

	Public Function FindAllRSByNome(p_Nome)
		dim strSQL
		strSQL = "SELECT Id, Nome, Conteudo, Principal FROM Assinaturas_Comunicado_Inadimplencia WHERE (Nome LIKE '%" & SingleQuotes(p_Nome) & "%');"

		Set FindAllRSByNome = LoadRSFromDB(strSQL)
	End Function


	Public Function GetById(p_Id)
		Dim strSQL
		strSQL = "SELECT Id, Nome, Conteudo, Principal "
		strSQL = strSQL & " FROM Assinaturas_Comunicado_Inadimplencia "
		strSQL = strSQL & " WHERE (Id = " & p_Id & ") "

		GetById = LoadData (strSQL)
	End Function

	Public Function Delete(p_Id)
		Dim strSQL
		strSQL = "DELETE "
		strSQL = strSQL & " FROM Assinaturas_Comunicado_Inadimplencia "
		strSQL = strSQL & " WHERE (Id = " & p_Id & ") "

		RunSQL(strSQL)
	End Function

	Public Function Store()
		Dim strSQL
        
        If(IsNull(Me.Id) Or IsEmpty(Me.Id) Or Me.Id < 1) then
            
			If(Me.Principal=1)Then
            	strSQL = "UPDATE Assinaturas_Comunicado_Inadimplencia SET Principal=0;"
            	RunSQL strSQL
            End If

            Dim arr1, arr2
            arr1 = Array("Nome", "Conteudo", "Principal")
            arr2 = Array(Me.Nome,   Me.Conteudo, Me.Principal)
            Me.Id = InsertRecord("Assinaturas_Comunicado_Inadimplencia", "Id", arr1, arr2)       

        'Otherwise run an update
        Else                	

        	If(Me.Principal=1)Then
            	strSQL = "UPDATE Assinaturas_Comunicado_Inadimplencia SET Principal=0;"
            	RunSQL strSQL
            End If

            strSQL = strSQL & " UPDATE Assinaturas_Comunicado_Inadimplencia SET "
            
            'If(Not IsEmpty2(Nome)) Then
            	strSQL = strSQL & " Nome = '" & Me.Nome & "' "
            'Else'
            	'strSQL = strSQL & " Nome = NULL "
            'End If

			'If(Not IsEmpty2(Conteudo)) Then
            	strSQL = strSQL & " , Conteudo = '" & Me.Conteudo & "' "
            'Else'
            	'strSQL = strSQL & " , Conteudo = NULL "
            'End If

            strSQL = strSQL & " , Principal = '" & Me.Principal & "' "

            strSQL = strSQL & " WHERE Id = " & Me.Id

            RunSQL strSQL      

        End if
        
        Store =  Me.Id

	End Function

'#############  Private Functions                           ##############
	
	'Takes a recordset
	'Fills the object's properties using the recordset
	Private Function FillFromRS(p_RS)

		select case p_RS.recordcount
		case 1

			Me.Id = p_RS.fields("Id").Value
			Me.Nome = p_RS.fields("Nome").Value
			Me.Conteudo = p_RS.fields("Conteudo").Value
			Me.Principal = p_RS.fields("Principal").Value

			FillFromRS          = Me.Id
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
