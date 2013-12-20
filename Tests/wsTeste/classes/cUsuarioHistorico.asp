<%

Class cUsuarioHistorico	

'#############  Constructors and Destructors ##############

	Sub Class_Initialize()
	End Sub

	Sub Class_Terminate()
	End Sub

'#############  Public Functions, accessible to the web pages ##############

	Public Function Inserir(p_NomeUsuarioAlterado, p_NovoStatus, p_NomeUsuarioLogado)
            
        Dim arr1, arr2
        Dim Id

        arr1 = Array("Usuario", "Status", "Quem")
        arr2 = Array(p_NomeUsuarioAlterado,  p_NovoStatus, p_NomeUsuarioLogado)

        Id = InsertRecord("hist", "Id", arr1, arr2)
        
        Inserir =  Id

	End Function


End Class
%>
