<% lista_pg = "PG-AJU" %>
<% paginacao = true %>
<!--#include file="../include/funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/conn_intra.asp"-->
<!--#include file="../usuario_logado.asp"-->
<html>
<head>
	<title>APOL <%if request("modulo") = "" then%>Marcas<%else%>Jurídico<%end if%></title>
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
<% menu_onde = "ajuda" %>
<%
if Request.Querystring("modulo") = "" then
	modulo = "M"
else
	modulo = Request.Querystring("modulo")
end if

	'rodrigo
	if modulo = "M" then%>
		<link HREF="style.css" type="text/css" REL="STYLESHEET">
		<!--#include file="header.asp"-->
	<%else%>
		<link HREF="contencioso\style2.css" type="text/css" REL="STYLESHEET">
		<!--#include file="contencioso\header.asp"-->
	<%end if%>
<table class="preto12" width="100%" align="center" cellpadding="0" cellspacing="0">
<tr bgcolor="#ffffff">
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr>
	<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
	<td height="16" valign="middle" class="titulo">&nbsp;Ajuda&nbsp;&nbsp;</td>
	<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
	<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
</tr>
</table>
	</td>
</tr>
<tr><td>
<table class="preto12" bgcolor="#efefef" width="100%">
<form action="ajuda.asp" method="get" name="frm">
<input type="hidden" name="modulo" value="<%= modulo %>">
<tr>
	<td colspan="2" height="40">Busca: <input type="text" name="busca" class="cfrm"> <input type="submit" class="cfrm" value="Pesquisar">&nbsp;&nbsp;<input type="reset" class="cfrm" value="Limpar"></td>
</tr>
</form>
<%
busca = Request.Querystring("busca")
if busca = "" then
	busca = "Introdução ao APOL"
	ini = 1
end if
sql = "SELECT id, titulo, descricao, tipo, sistema, somente_intra FROM Documentos WHERE (somente_intra = 0) AND (tipo = 5) AND (sistema = 1) and (pchave = '#"&tplic(1,modulo)&"#') and (titulo like '%"&tplic(1,busca)&"%' or descricao like '%"&tplic(1,busca)&"%')"
'Response.Write(sql)
set rs = conn_intra.execute(sql)
if not rs.eof then
	if ini = 1 then
		%>
		<tr>
			<td height="30" bgcolor="#00578F" class="branco12" colspan="2"><b><%= rs("titulo") %></b></td>
		</tr>
		<tr>
			<td height="30" bgcolor="#EFEFEF" class="preto12"><%= rs("descricao") %></td>
		</tr>
		<%
	else
		while not rs.eof
		%>
		<tr>
			<td height="1" bgcolor="#FFFFFF" class="preto12" align="center" colspan="2"></td>
		</tr>
		<tr>
			<td height="30" bgcolor="#EFEFEF" class="preto12" colspan="2"><a class="preto12" style="text-decoration: none" href="detalhe_ajuda.asp?id=<%= rs("id") %>"><b><%= rs("titulo") %></b></a></td>
		</tr>
		<%
		rs.movenext
		wend
	end if
else
%>
<tr>
	<td height="1" bgcolor="#FFFFFF" class="preto12" align="center" colspan="2"></td>
</tr>
<tr>
	<td height="30" bgcolor="#EFEFEF" class="preto12" align="center" colspan="2"><b>Nenhum resultado foi encontrado.</b></td>
</tr>
<% End If %>
</table>
</td>
</tr>
</td></tr>
</table>
</body>
</html>
