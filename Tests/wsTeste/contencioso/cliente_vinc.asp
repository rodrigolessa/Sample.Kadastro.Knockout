<%
if request("id_proc") = "" then
	%>
	<script>window.close()</script>
	<%
	response.end
end if
%>
<% lista_pg = "PG-P06" %>
<!--#include file="../include/funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/conn_webseek.asp"-->
<!--#include file="../usuario_logado.asp"-->
<html>
<head>
	<title>APOL Jurídico</title>
	<link rel="STYLESHEET" type="text/css" href="style2.css">
</head>

<body leftmargin="0" topmargin="0"  class="preto12" bgcolor="#efefef">
<table align="center" class="preto12" width="100%">
<tr>
	<td bgcolor="#FFFFFF">
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr>
	<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
	<td height="16" valign="middle" class="titulo">&nbsp;<%if request("tipo") = "cliente" then%>Cliente<%else%>Outra&nbsp;Parte<%end if%>&nbsp;&nbsp;</td>
	<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
	<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
</tr>
</table>
	</td>
</tr>
<form action="cliente_vinc_grava.asp" method="get" name="frm2">
<input type="hidden" name="proc" value="<%= request.querystring("id_proc") %>">
<input type="hidden" name="processo" value="<%=request.querystring("processo") %>">
<input type="hidden" name="tipo" value="<%=request("tipo")%>">
<input type="hidden" name="x" value="<%=request("x")%>">
<input type="hidden" name="janela" value="">
<tr bgcolor="#efefef"><td align="left" height="30">
	&nbsp;&nbsp;&nbsp;<select class="cfrm" name="cliente" size="1" style="width:350">
	<option value="0">--</option>
	<%	
	set rs = conn.execute("Select id, apelido from envolvidos where usuario = '"&Session("vinculado")&"' and tipo = '"&tplic(0,request("tipo"))&"' order by apelido")
	while not rs.eof
		%>
		<option value="<%= rs("id") %>"><%= rs("apelido") %></option>
		<%
	rs.movenext
	wend
	%>
</select></td></tr>
<tr bgcolor="#efefef"><td align="left">&nbsp;&nbsp;&nbsp;<input type="submit" class="cfrm" value="Gravar"></td></tr>
</form>
</table>

</body>
</html>
