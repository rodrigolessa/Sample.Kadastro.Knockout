<% lista_pg = "PG-AJU" %>
<% paginacao = true %>
<!--#include file="../include/funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/conn_intra.asp"-->
<!--#include file="../usuario_logado.asp"-->
<html>
<head>
	<title>APOL <%if (request("modulo") = "") or (ucase(request("modulo")) = "M") then%>Marcas<%else%>Jurídico<%end if%></title>
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

<body class="preto11" leftmargin="0" topmargin="0">
<% menu_onde = "ajuda" %>
<!--#include file="header.asp"-->
<table class="preto11" width="100%" align="center" cellpadding="0" cellspacing="0">
<tr bgcolor="#ffffff">
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
<tr>
	<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
	<td height="16" valign="middle" class="titulo">&nbsp;AJUDA&nbsp;&nbsp;</td>
	<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
	<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
</tr>
</table>
	</td>
</tr>
<tr><td>
<table class="preto11" bgcolor="#efefef" width="100%">
<%
sql = "SELECT titulo, descricao FROM Documentos WHERE pchave = '#C#"&tplic(1,Request.Querystring("pg"))&"#'"
'Response.Write(sql)
set rs = conn_intra.execute(sql)
%>
<tr>
	<td height="30" bgcolor="#345C46" class="branco12" colspan="2"><b><%= rs("titulo") %></b></td>
</tr>
<tr>
	<td height="30" bgcolor="#EFEFEF" class="preto11"><%= rs("descricao") %></td>
</tr>
</table>
</td>
</tr>
</td></tr>
</table>
</body>
</html>
