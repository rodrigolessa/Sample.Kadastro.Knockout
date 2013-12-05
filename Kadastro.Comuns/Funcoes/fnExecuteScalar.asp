<%

function fnExecuteScalar(strRSSource, connSource)

	Dim scalarRetorno
	Dim rsScalar, arrScalar

	'response.write("SQL = " & strRSSource & "<br />")
	
	SET rsScalar = Server.CreateObject("ADODB.RecordSet")
		rsScalar.source = strRSSource
		rsScalar.activeconnection = connSource
		rsScalar.CursorType = 2   ' Use 2 instead of adCmdTable
		rsScalar.LockType = 3     ' Use 3 instead of adLockOptimistic
		rsScalar.open

	If Err.Number <> 0 then
		'response.write "Erro no sistema <br> Descrição do Erro: " & Err.Description & VbCrLf & "Fonte: " & Err.Source & VbCrLf & "Arquivo: " & Request.ServerVariables("SCRIPT_NAME") & VbCrLf & "ID do Usuário: " & Session("vinculado") & VbCrLf & "String SQL: " & strRSSource & ""
		'response.flush
	End If

	If NOT rsScalar.EOF Then

		arrScalar = rsScalar.GetRows

		if isArray(arrScalar) then
			scalarRetorno = arrScalar(0,0)
		end if

	End If

		rsScalar.Close
	SET rsScalar = Nothing

	fnExecuteScalar = scalarRetorno

end function

%>