<% lista_pg = "PG-P01" %>
<!--#include file="include/funcoes.asp"-->
<!--#include file="include/conn.asp"-->
<!--#include file="include/conn_webseek.asp"-->
<!--#include file="usuario_logado.asp"-->
<html>
<head>
	<title>APOL Marcas</title>
	<link rel="STYLESHEET" type="text/css" href="style.css">
	<script>
	function del(cod){
	if (window.confirm("<%= mostra_label("alert_del", "", "") %> "+cod+")")){
		location="grava_proc.asp?tipo=del&proc="+cod}
	}
	
	function valida(){
		if (document.frm1.inc_cnpj.value == ""){
			alert("Preencha os campos corretamente.");
			document.frm1.inc_cnpj.focus();
			return false;
		}
		else{
			if (isNaN(document.frm1.inc_cnpj.value)){
				alert("Preencha os campos corretamente. (Apenas números)");
				document.frm1.inc_cnpj.focus();
				return false;
			}
		}
		document.frm1.bts.disabled = true;
		return true;
	}
	
	function valida_proc(){
		if (document.frm.inc_proc[0].value == ""){
			alert("Preencha os campos corretamente.");
			document.frm.inc_proc[0].focus();
			return false;
		}
		else{
			if (isNaN(document.frm.inc_proc[0].value)){
				alert("Preencha os campos corretamente. (Apenas números)");
				document.frm.inc_proc[0].focus();
				return false;
			}
		}
		var obj
		for (i=1;i<10;i++){
			//obj = eval("document.frm.inc_proc"+i)
			obj = document.frm.inc_proc[i]
			if (obj.value != ""){
				if (isNaN(obj.value)){
					alert("Preencha os campos corretamente. (Apenas números)");
					obj.focus();
					return false;
				}
			}
		} 
		document.frm.bts.disabled = true;
		return true;
	}
	</script>
</head>

<body class="preto12" leftmargin="0" topmargin="0">
<% menu_onde = "proc" %>
<!--#include file="header.asp"-->
<table align="center" width="100%" border="0" cellpadding="0" cellspacing="0">
<tr bgcolor="#ffffff">
	<td class="branco12">
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;<%= replace(mostra_label("titulo", "", "")," ","&nbsp;") %>&nbsp;</td>
		<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
	</td>
</tr>
<form action="grava_proc.asp" method="post" name="frm" onsubmit="return valida_proc()">
<input type="hidden" name="tipo" value="proc">
<tr bgcolor="#efefef"><td valign="top" align="center">
<table align="center" border="0" bgcolor="#efefef" class="preto12" cellpadding="2" cellspacing="2">
<tr>
	<td bgcolor="#efefef"><b><%= mostra_label("processo", "combo", "0") %></b></td>
	<td bgcolor="#efefef"><b><%= mostra_label("terceiro", "combo", "0") %></b></td>
	<td bgcolor="#efefef"><b><%= mostra_label("responsavel", "combo", "0") %></b></td>
	<td bgcolor="#efefef"><b><%= mostra_label("cliente", "combo", "0") %></b></td>
</tr>
<% for i=1 to 10 %>
<tr>
	<td><input class="cfrm" type="text" name="inc_proc" size="9" maxlength="9"></td>
	<td align="center"><input type="checkbox" name="terceiros<%= i %>" value="1"></td>
	<td><select class="cfrm" name="resp<%= i %>" size="1">
	<option value="null">--</option>
	<%
	set rs1 = conn.execute("Select * from responsaveis where tipo <> 'cliente' and usuario = '"&Session("vinculado")&"' order by nome")
	while not rs1.eof
	%>
	<option value="<%= rs1("id") %>"><%= rs1("nome") %></option>
	<%
	rs1.movenext
	wend
	%>
</select></td>
	<td><select class="cfrm" name="cliente<%= i %>" size="1">
	<option value="null">--</option>
	<%
	set rs1 = conn.execute("Select id, apelido from envolvidos where tipo = 'cliente' and usuario = '"&Session("vinculado")&"' order by apelido")
	while not rs1.eof
	%>
	<option value="<%= rs1("id") %>"><%= rs1("apelido") %></option>
	<%
	rs1.movenext
	wend
	%>
</select></td>
</tr>
<% next %>
</table>
</td>
</tr>
<tr bgcolor="#EFEFEF">
<td align="center"><input type="submit" name="bts" class="cfrm" value="<%= mostra_label("grava", "", "") %>"></td>
</tr></form>
<tr bgcolor="#EFEFEF">
<td align="center"><hr width="98%" size="1 " noshade></td>
</tr>
<tr bgcolor="#EFEFEF">
<td align="center">
<table align="center" border="0" bgcolor="#efefef" class="preto12" cellpadding="2" cellspacing="2">
<form action="grava_proc.asp" method="post" name="frm1" onsubmit="return valida()">
<input type="hidden" name="tipo" value="cnpj">
<tr>
	<td bgcolor="#efefef"><b><%= mostra_label("cnpj", "", "") %></b></td>
	<td bgcolor="#efefef"><b><%= mostra_label("terceiro", "combo", "0") %></b></td>
	<td><b><%= mostra_label("responsavel", "combo", "0") %></b></td>
	<td><b><%= mostra_label("cliente", "combo", "0") %></b></td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td><input class="cfrm" type="text" name="inc_cnpj" size="15" maxlength="18"></td>
	<td align="center"><input type="checkbox" name="terceiros_cnpj" value="1"></td>
	<td><select class="cfrm" name="resp" size="1">
	<option value="null">--</option>
	<%
	set rs1 = conn.execute("Select * from responsaveis where usuario = '"&Session("vinculado")&"' order by nome")
	while not rs1.eof
	%>
	<option value="<%= rs1("id") %>"><%= rs1("nome") %></option>
	<%
	rs1.movenext
	wend
	%>
</select></td>
<td><select class="cfrm" name="cliente" size="1">
	<option value="null">--</option>
	<%
	set rs1 = conn.execute("Select id, apelido from envolvidos where tipo = 'cliente' and usuario = '"&Session("vinculado")&"' order by apelido")
	while not rs1.eof
	%>
	<option value="<%= rs1("id") %>"><%= rs1("apelido") %></option>
	<%
	rs1.movenext
	wend
	%>
</select></td>
	<td align="center"><input type="submit" name="bts" class="cfrm" value="<%= mostra_label("grava", "", "") %>"></td>
</tr>
</form>
</table>
</td>
</tr>
<tr bgcolor="#EFEFEF">
<td colspan="2" align="center">&nbsp;</td>
</tr>
</table>
<%' response.write(procs) %>

</body>
</html>
