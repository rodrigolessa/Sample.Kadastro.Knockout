<%

if (request.TotalBytes) > 3000000 then 
	%>		
	<script>
	alert('S�o permitidos apenas arquivos menores que 3MB.')
	history.back();
	</script>
	<%
	response.end
end if

if (request.TotalBytes) < 1 then 
	%>		
	<script>
	alert('Arquivo est� vazio ou inexistente.')
	history.back();
	</script>
	<%
	response.end
end if

'Upload do arquivo
Set mySmartUpload = Server.CreateObject("aspSmartUpload.SmartUpload")
mySmartUpload.Upload

arquivo = mySmartUpload.Files.Item(1).FileName
tamanho = mySmartUpload.Files.Item(1).Size
origem = request.querystring("origem")

mySmartUpload.Save(server.mappath("rtf_cli"))

response.redirect "grava_modelo_carta_param.asp?file="&arquivo&"&origem="&origem
%>