<%session("voltar") = "../main.asp?modulo=C"%>

<!--#include file="db_open.asp"-->
<!--#include file="../include/Db_open_apol.asp"-->
<link rel="STYLESHEET" type="text/css" href="style.css"> 
<link rel="STYLESHEET" type="text/css" href="style2.css">
<% menu_onde = "link" %>
<!--#include file="header.asp"-->
<table align="center" width="100%" border="0" cellpadding="0" cellspacing="0">
<tr bgcolor="#ffffff">
	<td class="branco12">
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;Links&nbsp;de&nbsp;Tribunais&nbsp;&nbsp;</td>
		<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
	</td>
</tr>
<tr bgcolor="#efefef"><td valign="top" align="center">

<table width="100%" class="tabela<%=l_imp%>" border="0" cellspacing="2" cellpadding="3">					

	<%
	sql = "select * from tribunais order by tribunal"
	set rst = db_apol.execute(sql)

	if rst.eof then%>
	<tr><td height="30" align="center" class="preto12" bgcolor="#EFEFEF"><b>Nenhum Tribunal foi encontrada.</b></td></tr>
	<%response.end
	else
	%>
	<tr bgcolor="#00578F" class="tit1">			
		<td width=30%><b>Tribunal</b></td>
		<td width=100%><b>Descrição</b></td>
	</tr>
	<%
	do while not rst.eof		
		if cor = "#FFFFFF" then
			cor = "#EFEFEF"
		else
			cor = "#FFFFFF"
		end if
		%>		
		<tr bgcolor=<%=cor%>>	
			<td width=20%><a href="<%=rst("link")%>" class=preto10 target=_blank><%=rst("tribunal")%></a></td>
			<td width=100%><%=rst("descricao")%></td>
		</tr>
		<%
		rst.movenext
	loop
		end if%>
</table>