<% lista_pg = "PG-RES" %>
<% paginacao = true %>
<html>
<head>
	<title>APOL <%if (request("modulo") = "") or (ucase(request("modulo")) = "M") then%>Marcas<%else%>Contencioso<%end if%></title>
	<link rel="STYLESHEET" type="text/css" href="style.css">
	<script>
	function valida(){
		if (document.frm.nome.value == ""){
			alert("Preencha os campos corretamente.");
			document.frm.nome.focus();
			return false;
		}
		else{
			return true;
		}
	}
	</script>
</head>

<body class="preto12" leftmargin="0" topmargin="0">
<% menu_onde = "div" %>
<!--#include file="header.asp"-->
<table class="preto12" width="100%" align="center" cellpadding="0" cellspacing="0">
<tr bgcolor="#ffffff">
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr>
	<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
	<td height="16" valign="middle" class="titulo">&nbsp;Backup&nbsp;&nbsp;</td>
	<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
	<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
</tr>
</table>
	</td>
</tr>
<tr><td>
<table class="preto12" bgcolor="#efefef" width="100%">
<tr>
	<td align="center">O Backup do APOL é um procedimento de segurança que salva todos os dados inseridos pelo usuário no sistema até o momento da operação.<br>
	<br>
	A LDSOFT armazena automaticamente uma cópia com os dados do dia corrente.<br></td>
</tr>
<form action="bkp.asp" method="get" name="frm" onsubmit="document.frm.bt.disabled='true'">
<%
dir = server.mappath("bkp")&"\"
s = ""
Set fso = CreateObject("Scripting.FileSystemObject")
Set f = fso.GetFolder(dir)
Set fc = f.Files
For Each f1 in fc
	if Instr(1, f1.name, "bkp_" &Session("vinculado")& "_") > 0 then
		s = s & f1.name
		Set f = fso.GetFile(dir&f1.name)
	end if
Next
%>
<% If s <> "" then %>
<tr>
	<td align="center"><br>
	<a class="preto12" href="bkp/<%= s %>"><b>Clique aqui</b></a> e faça o download do Backup (<%= fdata(f.DateCreated) %>)<br>
	<br><input type="submit" name="bt" class="cfrm" value="Gerar Backup"></td>
</tr>
<% Else %>
<tr>
	<td align="center"><br><input name="bt" type="submit" class="cfrm" value="Gerar Backup"></td>
</tr>
<% End If %>
</form>
</table>
</td>
</tr>
</td></tr>
</table>
</body>
</html>
