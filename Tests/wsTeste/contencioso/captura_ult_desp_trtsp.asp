<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>
<% If Request.Querystring("processo1") = "" then %>
<form name="form1" method="get" action="captura_ult_desp_trtsp.asp">
	<input type="text" size="20" name="processo1" value="" maxlength="17">
	<input type="submit" value="Enviar" class="botao">
</form>
<% Else %>
<%
dim txt

Sub pega_desp()
    On Error Resume Next
    Set xml = Server.CreateObject("Microsoft.XMLHTTP")
	xvLink = "http://trt.srv.trt02.gov.br/cie1?processo1="&request.querystring("processo1")
	xml.Open "GET", xvLink, False
	xml.Send
	If Err.Number <> 0 Then
        response.write "Erro de comunicação com o Servidor!"
		response.end
    End If
	txt=xml.responseText
	set xml = Nothing
End Sub

pega_desp()

dir = server.mappath("captura/")&"\" &request.querystring("processo1")& ".txt"

Set fso = CreateObject("Scripting.FileSystemObject")

Set MyFile = fso.OpenTextFile(dir, 2, True)

temp = replace(txt,chr(10),"#%@!!@%#")
texto = split(temp,"#%@!!@%#")

for i= 0 to ubound(texto)-1
MyFile.WriteLine texto(i)
next

Set MyFile = fso.OpenTextFile(dir, 1)
fim = false
if MyFile.AtEndOfStream then
	response.write "Processo não encontrado!"
else
	if instr(temp,"Processo Inexistente!") > 0 then
		response.write "Processo não encontrado!"
	else
		while (not fim) and (not MyFile.AtEndOfStream)
			linha = replace(MyFile.ReadLine,"<br>","")
			if (mid(linha,3,1) = "/") and comeca then
				if data then
					data = false
					datat = left(linha,10)
					linha = trim(mid(linha,11,len(linha)))
				else
					comeca = false
					fim = true
				end if
			end if
			if comeca then
				txt_saida = txt_saida & trim(linha) & " "
			end if
			if left(linha,7) = "Data(s)" then
				comeca = true
				data = true
			end if
		wend
		%>
		<br>------<br>
		<%= datat %><br>
		------<br>
		<%= txt_saida %><br>
		------
		<%
	end if
end if
%>
<% End If %>
</body>
</html>
