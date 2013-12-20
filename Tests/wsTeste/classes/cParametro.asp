<%

'--------------------------------------------------------------------------'
'Author: Leandro Ribeiro
'Create: Julho/2013
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

Class cParametro

	'TODO LEANDRO RIBEIRO'
	'Dim dbConnectionString : dbConnectionString = "DRIVER={SQL Server};Server="&Application("nome_servidor_dados")&";Database=Apol;UID="&Application("usuario")&";PWD="&Application("senha")

'#############  Constructors and Destructors ##############

	Sub Class_Initialize()
	End Sub

	Sub Class_Terminate()
	End Sub

'#############  Public Functions, accessible to the web pages ##############

	Public Function GetRsByUsuario(p_NomeUsuario)

		Dim strSQL

		strSQL = "select UrlCadastroClienteExterno, UrlPastaClienteExterno FROM parametros WHERE usuario = '" & p_NomeUsuario & "'"

		Set GetRsByUsuario = LoadRSFromDB(strSQL)

	End Function

End Class

%>