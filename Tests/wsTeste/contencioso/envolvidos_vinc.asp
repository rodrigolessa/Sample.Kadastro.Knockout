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
	<link rel="STYLESHEET" type="text/css" href="style.css">

<script>
	function valida()
	{
	if (document.frm2.tipo.value == "")
	{
		alert("Indique o Tipo de Envolvido.")
		frm2.tipo.focus();
		return false;
	}	

	if (document.frm2.apelido.value == "")
	{
		alert("Indique o Apelido de Envolvido.")
		frm2.apelido.focus();
		return false;
	}			
	document.frm2.bts.disabled = true;
	return true;
	}		
	
</script>

</head>

<body leftmargin="0" topmargin="0"  class="preto11" bgcolor="#efefef" <%if request("erro") = 1 then%>onLoad="carregar_apelido();"<%end if%>>
<table align="center" class="preto11" width="100%">
<tr>
	<td bgcolor="#FFFFFF">
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
<tr>
	<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
	<td height="16" valign="middle" class="titulo">&nbsp;Envolvidos&nbsp;&nbsp;</td>
	<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
	<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
</tr>
</table>
	</td>
</tr>
</table>

<table align="left" class="preto11" width="100%" border="0">

<form action="envolvidos_vinc_grava.asp" method="get" name="frm2" onsubmit="return valida()">
<input type="hidden" name="proc" value="<%= request.querystring("id_proc") %>">
<input type="hidden" name="processo" value="<%=request.querystring("processo") %>">
<input type="hidden" name="janela" value="">

<tr bgcolor="#efefef" align="left">

<td align="left" width="1%">Tipo:&nbsp;</td>
<td align="left"  width="1%">
	<select class="cfrm" name="tipo" size="1" style="width:130" onChange="carregar_apelido();">
	<option value=""></option>
	<%set rs = conn.execute("SELECT * FROM Tipo_Envolvido WHERE usuario = '"&Session("vinculado")&"' ORDER BY nome_tipo_env")
	while not rs.eof
		%>
		<option value="<%= rs("id_tipo_env") %>" <%if trim(request("tipo_env")) = trim(rs("id_tipo_env")) then%>selected<%end if%>><%= rs("nome_tipo_env") %></option>
		<%
	rs.movenext
	wend
	%>
</select>&nbsp;&nbsp;&nbsp;
</td>

<td align="left" width="1%">Apelido:&nbsp;</td>
<td align="left" width="63%">
<select name="apelido" id="apelido" style="width:200" class="preto11">
<option value="">Escolher um Tipo</option>	
</select>		
<div style="DISPLAY: none; POSITION: absolute" align="left">
<IfRAME src="blank.htm" name="myIframe_apelido" id="myIframe_apelido" style="width:250" marginwidth="0" marginheight="0"></IfRAME>    
</div>&nbsp;&nbsp;&nbsp;
<input type="checkbox" name="principal" value="1">&nbsp;Principal
</td>


</tr>
<tr bgcolor="#efefef"><td align="center" colspan="4"><input type="submit" name="bts" class="cfrm" value="Gravar"></td></tr>
</form>
</table>

<script>
var Combo1 = document.frm2.tipo;
var Combo2 = document.frm2.apelido;

function carregar_apelido(){
	var url;    
	url = '../remote_apelido.asp?tipo='+Combo1[Combo1.selectedIndex].value;    
	Combo2.options.length = 0;
	myIframe_apelido.location = url;    
	Combo2.focus()
}
</script>
</body>
</html>
