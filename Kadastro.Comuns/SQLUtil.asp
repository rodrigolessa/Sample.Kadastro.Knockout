<!--#include file="Funcoes/fnConverteDataSQL.asp"-->
<%

Function PrmSQL(prmValor, prmTipoSQL)

	Dim r_valorFormatado

	prmValor = Trim(Replace(prmValor, "'", ""))

	Select Case prmTipoSQL
	Case "int"
		r_valorFormatado = prmValor
	Case "bigint"
		r_valorFormatado = prmValor
	Case "smalldatetime"
		r_valorFormatado = "'" & prmValor & "'"
	Case "time"
		r_valorFormatado = "'" & prmValor & "'"
	Case Else
		r_valorFormatado = "'" & prmValor & "'"
	End Select

	PrmSQL = r_valorFormatado

End Function

%>