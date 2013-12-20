<% lista_pg = "PG-P05" %>
<% paginacao = true %>
<%' If Request("tipo_post") <> "" then %>
<% bt_imprimir = true %>
<% 'End If %>
<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn_webseek.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<!--#include file='../include/Db_open_webseek_teste.asp'-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<%
if (not Session("cont_rel_stat")) and (not Session("adm_adm_sys")) then
	bloqueia
	response.end
end if
%>

<!--#include file='../classes/clsWebServiceIsis.asp'-->
<!--#include file="json2.asp"-->
<%
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Consome serviço do Isis para obter a lista de todos os Orgãos Oficiais '
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim objWSIsis
Set objWSIsis = new clsWebServiceIsis
objWSIsis.URL = url_base() & "/utilitarios/ServicoIsis/ServicoIsis.asmx"
objWSIsis.Metodo = "obtemTodosOrgaosOficiais"
objWSIsis.Executar

' Cria um objeto JSON para o retorno com a lista de orgãos oficiais '
Dim jsonOrgaoOficial
Set jsonOrgaoOficial = JSON.parse(objWSIsis.Retorno)
%>

<html>
<head>
	<title>APOL Jurídico<% If Request("imprimir") <> "" then %> - Impressão de Informações<% End If %></title>
	<link rel="STYLESHEET" type="text/css" href="style.css">
</head>

<body leftmargin="0" topmargin="0" class="preto11">
<% If Request("imprimir") = "" then %>
<% menu_onde = "div" 
bcor = "345C46"%>
<!--#include file="header.asp"-->
<%
Else 
bcor = "000000"
l_imp = "_p"
%>
<!--#include file='../include/Db_open_usuarios.asp'-->
<table cellpadding="0" cellspacing="0" width="100%" border="0">
<tr>
	<td><%
SQL = "select logotipo from usuario where vinculado='"&session("vinculado")&"' and nomeusu='"& session("vinculado") &"'"
set rsy = conn_usu.execute(SQL)

if rsy("logotipo") <> "" then
%>
<img src="../logo_cliente/<%=rsy("logotipo")%>" border="0">
<% end if %></td>
	<td align="right" valign="top"><span class="preto11"><%= now() %></span></td>
</tr>
</table>
<% End If %>

<%
pcad = 0
sql = "SELECT COUNT(processo) AS qt FROM TabProcCont GROUP BY usuario HAVING (usuario = '" &Session("vinculado")& "')"
set rstx = db.execute(sql)
if not rstx.eof then
	pcad = rstx("qt")
end if

pcad_ativo = 0
sql = "SELECT COUNT(processo) AS qt FROM TabProcCont WHERE situacao = 'A' GROUP BY usuario HAVING (usuario = '" &Session("vinculado")& "')"
set rstx = db.execute(sql)
if not rstx.eof then
	pcad_ativo = rstx("qt")
end if

pcad_encerrado = 0
sql = "SELECT COUNT(processo) AS qt FROM TabProcCont WHERE situacao = 'E' GROUP BY usuario HAVING (usuario = '" &Session("vinculado")& "')"
set rstx = db.execute(sql)
if not rstx.eof then
	pcad_encerrado = rstx("qt")
end if

pcad_acordo = 0
sql = "SELECT COUNT(processo) AS qt FROM TabProcCont WHERE situacao = 'C' GROUP BY usuario HAVING (usuario = '" &Session("vinculado")& "')"
set rstx = db.execute(sql)
if not rstx.eof then
	pcad_acordo = rstx("qt")
end if

pcad_inativo = 0
sql = "SELECT COUNT(processo) AS qt FROM TabProcCont WHERE situacao = 'I' GROUP BY usuario HAVING (usuario = '" &Session("vinculado")& "')"
set rstx = db.execute(sql)
if not rstx.eof then
	pcad_inativo = rstx("qt")
end if

pcad_fed = 0
sql = "SELECT COUNT(processo) AS qt FROM TabProcCont WHERE competencia = 'F' GROUP BY usuario HAVING (usuario = '" &Session("vinculado")& "')"
set rstx = db.execute(sql)
if not rstx.eof then
	pcad_fed = rstx("qt")
end if

pcad_est = 0
sql = "SELECT COUNT(processo) AS qt FROM TabProcCont WHERE competencia = 'E' GROUP BY usuario HAVING (usuario = '" &Session("vinculado")& "')"
set rstx = db.execute(sql)
if not rstx.eof then
	pcad_est = rstx("qt")
end if

pcad_mun = 0
sql = "SELECT COUNT(processo) AS qt FROM TabProcCont WHERE competencia = 'M' GROUP BY usuario HAVING (usuario = '" &Session("vinculado")& "')"
set rstx = db.execute(sql)
if not rstx.eof then
	pcad_mun = rstx("qt")
end if

pcad_jud = 0
sql = "SELECT COUNT(processo) AS qt FROM TabProcCont WHERE tipo = 'J' GROUP BY usuario HAVING (usuario = '" &Session("vinculado")& "')"
set rstx = db.execute(sql)
if not rstx.eof then
	pcad_jud = rstx("qt")
end if

pcad_adm = 0
sql = "SELECT COUNT(processo) AS qt FROM TabProcCont WHERE tipo = 'A' GROUP BY usuario HAVING (usuario = '" &Session("vinculado")& "')"
set rstx = db.execute(sql)
if not rstx.eof then
	pcad_adm = rstx("qt")
end if
%>


<table class="preto11" bgcolor="#FFFFFF" align="center" width="100%">
<tr>
	<td class="branco12">
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo<%=l_imp%>">&nbsp;Total&nbsp;por&nbsp;Situação&nbsp;</td>
		<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
	</td>
</tr>

<tr bgcolor="#EFEFEF">
	<td>		
	<table cellpadding="2" cellspacing="2" border="0" class="preto11" align="center" width="60%">
		<tr bgcolor="#<%=bcor%>" class="branco11"><td>&nbsp;</td><td align="center"><strong>Total</strong></td></tr>
		<tr bgcolor="#FFFFFF"><td>&nbsp;Processos: </td><td align="center"  style="width:100"><b><%= pcad %></b></td></tr>
	</table><br>

	<table cellpadding="2" cellspacing="2" border="0" class="preto11" align="center" width="60%">
	<tr bgcolor="#<%=bcor%>" class="branco11"><td><b>Situação</b></td><td style="width:100" align="center"><b>Quantidade</b></td></tr>
	<tr bgcolor="#FFFFFF" class="preto11"><td>Ativos</td><td align="center"><%= pcad_ativo %></td></tr>
	<tr bgcolor="#EFEFEF" class="preto11"><td>Encerrados</td><td align="center"><%= pcad_encerrado %></td></tr>
	<tr bgcolor="#FFFFFF" class="preto11"><td>Acordos</td><td align="center"><%= pcad_acordo %></td></tr>
	<tr bgcolor="#EFEFEF" class="preto11"><td>Inativos</td><td align="center"><%= pcad_inativo %></td></tr>
	<tr bgcolor="#FFFFFF" class="preto11"><td>Sem Situação</td><td align="center"><%= pcad-(pcad_ativo+pcad_encerrado+pcad_acordo+pcad_inativo) %></td></tr>
	</table><br></td>
</tr>
</table>


<table class="preto11" bgcolor="#FFFFFF" align="center" width="100%">
<tr>
	<td class="branco12">
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo<%=l_imp%>">&nbsp;Total&nbsp;por&nbsp;Competência&nbsp;</td>
		<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
	</td>
</tr>

<tr bgcolor="#EFEFEF">
	<td><table cellpadding="2" cellspacing="2" border="0" class="preto11" align="center" width="60%">
	<tr bgcolor="#<%=bcor%>" class="branco11"><td><b>Competência</b></td><td style="width:100" align="center"><b>Quantidade</b></td></tr>
	<tr bgcolor="#FFFFFF" class="preto11"><td>Federal</td><td align="center"><%= pcad_fed %></td></tr>
	<tr bgcolor="#EFEFEF" class="preto11"><td>Estadual</td><td align="center"><%= pcad_est %></td></tr>
	<tr bgcolor="#FFFFFF" class="preto11"><td>Municipal</td><td align="center"><%= pcad_mun %></td></tr>				
	<tr bgcolor="#EFEFEF" class="preto11"><td>Sem Competência</td><td align="center"><%= pcad-(pcad_fed+pcad_est+pcad_mun) %></td></tr>				
	</table><br></td>
</tr>
</table>

<table class="preto11" bgcolor="#FFFFFF" align="center" width="100%">
<tr>
	<td class="branco12">
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo<%=l_imp%>">&nbsp;Total&nbsp;por&nbsp;Tipo&nbsp;</td>
		<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
	</td>
</tr>

<tr bgcolor="#EFEFEF">
	<td><table cellpadding="2" cellspacing="2" border="0" class="preto11" align="center" width="60%">
	<tr bgcolor="#<%=bcor%>" class="branco11"><td><b>Tipo</b></td><td style="width:100" align="center"><b>Quantidade</b></td></tr>
	<tr bgcolor="#FFFFFF" class="preto11"><td>Judicial</td><td align="center"><%= pcad_jud %></td></tr>
	<tr bgcolor="#EFEFEF" class="preto11"><td>Administrativo</td><td align="center"><%= pcad_adm %></td></tr>
	<tr bgcolor="#FFFFFF" class="preto11"><td>Sem Tipo</td><td align="center"><%= pcad-(pcad_jud+pcad_adm) %></td></tr>				
	</table><br></td>
</tr>
</table>

<table class="preto11" bgcolor="#FFFFFF" align="center" width="100%">
<tr>
	<td class="branco12">
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo<%=l_imp%>">&nbsp;Total&nbsp;por&nbsp;Natureza&nbsp;</td>
		<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
	</td>
</tr>
<tr bgcolor="#EFEFEF">
	<td><table cellpadding="2" cellspacing="2" border="0" class="preto11" align="center" width="60%">
	<tr bgcolor="#<%=bcor%>" class="branco11"><td><b>Natureza</b></td><td style="width:100" align="center"><b>Quantidade</b></td></tr>
	<%
	cor = "FFFFFF"
	sql = "SELECT COUNT(TabProcCont.processo) AS qt, Auxiliares.descricao FROM TabProcCont INNER JOIN "&_
	" Auxiliares ON TabProcCont.natureza = Auxiliares.codigo WHERE (Auxiliares.Tipo = 'N') "&_
	" GROUP BY TabProcCont.usuario, Auxiliares.descricao HAVING (TabProcCont.usuario = '" &Session("vinculado")& "')"
	set rs = db.execute(sql)
	while not rs.eof
	%>
		<tr bgcolor="#<%= cor %>" class="preto11"><td><%= rs("descricao") %></td><td align="center"><%= rs("qt") %></td></tr>
	<%
	if cor = "EFEFEF" then
		cor = "FFFFFF"
	else
		cor = "EFEFEF"
	end if
	tot_sem = rs("qt")+tot_sem
	rs.movenext
	wend%>
	<tr bgcolor="#<%= cor %>" class="preto11"><td>Sem Natureza</td><td align="center"><%= pcad-tot_sem %></td></tr>
	</table><br></td>
</tr>
</table>




<table class="preto11" bgcolor="#FFFFFF" align="center" width="100%">
<tr>
	<td class="branco12">
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo<%=l_imp%>">&nbsp;Total&nbsp;por&nbsp;Órgão&nbsp;</td>
		<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
	</td>
</tr>
<tr bgcolor="#EFEFEF">
	<td><table cellpadding="2" cellspacing="2" border="0" class="preto11" align="center" width="60%">
	<tr bgcolor="#<%=bcor%>" class="branco11"><td><b>Órgão</b></td><td style="width:100" align="center"><b>Quantidade</b></td></tr>
	<%
	cor = "FFFFFF"
	sql = "SELECT COUNT(TabProcCont.processo) AS qt, Auxiliares.descricao FROM TabProcCont INNER JOIN "&_
	" Auxiliares ON TabProcCont.orgao = Auxiliares.codigo WHERE (Auxiliares.Tipo = 'O') "&_
	" GROUP BY TabProcCont.usuario, Auxiliares.descricao HAVING (TabProcCont.usuario = '" &Session("vinculado")& "')"
	set rs = db.execute(sql)
	while not rs.eof
	%>
		<tr bgcolor="#<%= cor %>" class="preto11"><td><%= rs("descricao") %></td><td align="center"><%= rs("qt") %></td></tr>
	<%
	if cor = "EFEFEF" then
		cor = "FFFFFF"
	else
		cor = "EFEFEF"
	end if
	tot_org = rs("qt")+tot_org	
	rs.movenext
	wend
	%>

<%
	cor = "FFFFFF"
	sqlTribunal = "SELECT COUNT(p.processo) AS qtd, p.tribunal_sync FROM TabProcCont p WHERE p.usuario = '" &Session("vinculado")& "' AND p.tribunal_sync IS NOT NULL GROUP BY p.tribunal_sync"
	Set rsTribunal = db.execute(sqlTribunal)
	While NOT rsTribunal.eof
%>
		<tr bgcolor="#<%=cor%>" class="preto11">
			<td><%=ObterDescricaoOrgaoOficialProSigla(rsTribunal("tribunal_sync"), jsonOrgaoOficial)%></td>
			<td align="center"><%=rsTribunal("qtd")%></td>
</tr>
<%
		if cor = "EFEFEF" then
			cor = "FFFFFF"
		else
			cor = "EFEFEF"
		end if

		tot_org = rsTribunal("qtd") + tot_org

		rsTribunal.movenext

	Wend
	Set rsTribunal = Nothing
	%>
		<tr bgcolor="#<%=cor%>" class="preto11">
			<td>Sem Orgão</td>
			<td align="center"><%=pcad-tot_org%></td>
		</tr>	
	</table>
	<br>
</td>
</tr>
</table>

</body>
</html>