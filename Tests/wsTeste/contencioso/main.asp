<script language="JavaScript1.2">
<!--
if (screen.width == 800){
	top.window.moveTo(0,0);
	if (document.all) {
		top.window.resizeTo(screen.availWidth,screen.availHeight);
	}
	else if (document.layers||document.getElementById) {
		if (top.window.outerHeight<screen.availHeight||top.window.outerWidth<screen.availWidth){
			top.window.outerHeight = screen.availHeight;
			top.window.outerWidth = screen.availWidth;
		}
	}
}
//-->
</script>
<% lista_pg = "PG-INI" %>
<!--#include file="../include/conn.asp"-->
<!--#include file="include/funcoes.asp"-->
<!--#include file="include/conn_webseek.asp"-->
<!--#include file="usuario_logado.asp"-->
<%
sql = "select ult_rpi from setup"
set rstx = cws.execute(sql)
urpi = rstx("ult_rpi")

sql = "SELECT TOP 1 DTRPI FROM HIST_M WHERE (RPI = '"&tplic(0,urpi)& "')"
set rstx = cws.execute(sql)
dt_urpi = fdata( rstx("DTRPI"))

sql = "SELECT COUNT(processo) AS qt FROM Processos GROUP BY usuario HAVING (usuario = '" &Session("vinculado")& "')"
set rstx = conn.execute(sql)
if not rstx.eof then
	pcad = rstx("qt")
else
	pcad = 0
end if

sql = "SELECT COUNT(processo) AS qt FROM Processos WHERE (terceiros = 0) GROUP BY usuario HAVING (usuario = '" &Session("vinculado")& "')"
set rstx = conn.execute(sql)
if not rstx.eof then
	pprop = rstx("qt")
else
	pprop = 0
end if

sql = "SELECT COUNT(processo) AS qt FROM Processos WHERE (terceiros = 1) GROUP BY usuario HAVING (usuario = '" &Session("vinculado")& "')"
set rstx = conn.execute(sql)
if not rstx.eof then
	pterc = rstx("qt")
else
	pterc = 0
end if

if Request.Querystring("tipo_visu") = "ofi" then
	set rs = conn.execute("update parametros set tipo_visu = 'prazo_ofi' where usuario = '"&Session("vinculado")&"'")
end if
if Request.Querystring("tipo_visu") = "ger" then
	set rs = conn.execute("update parametros set tipo_visu = 'prazo_ger' where usuario = '"&Session("vinculado")&"'")
end if

set rs = conn.execute("select tipo_visu from parametros where usuario = '"&Session("vinculado")&"'")
if not rs.eof then
	tipo_visu = rs("tipo_visu")
else
	tipo_visu = "prazo_ger"
end if
%>
<html>
<head>
	<title>APOL Marcas</title>
<link rel="STYLESHEET" type="text/css" href="style.css">
<link rel="STYLESHEET" type="text/css" href="include/style.css">
<script src="basiccalendar.js" type="text/javascript"></script>
<script>
function limpar(){
	document.frm_busca.processo.value = "";
	document.frm_busca.marca.value = "";
	document.frm_busca.ncl.value = "";
	document.frm_busca.tipo_rad.selectedIndex = 2;
	document.frm_busca.ordem.selectedIndex = 0;
}

function verifica(){
	if (document.frm_busca.processo.value == ""){
		if (document.frm_busca.marca.value.length < 3){
			alert('Tamanho mínimo de 3 caracteres.');
			document.frm_busca.marca.focus();
			return false;
		}
	}
	return true;
}
</script>
</head>

<body leftmargin="0" topmargin="0">
<% menu_onde = "" %>
<!--#include file="header.asp"-->
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr>
	<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
	<td height="16" valign="middle" class="titulo">&nbsp;<%= replace(mostra_label("titulo", "", ""), " ", "&nbsp;") %>&nbsp;</td>
	<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
	<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
</tr>
<tr bgcolor="#F3F3F3" class="preto12">
	<td colspan="4" align="center" height="8"><img src="imagem/1px-transp.gif" width="1" height="8" border="0"></td>
</tr>
<form name="frm_busca" action="pesquisa_webseek.asp" method="get" onsubmit="return verifica()">
<tr bgcolor="#F3F3F3" class="preto12">
	<td colspan="4" align="center"><%= mostra_label("processo", "", "") %>: <input class="cfrm" type="text" name="processo" size="9" maxlength="9" align="middle">&nbsp;&nbsp;
	<%= mostra_label("rmarca", "", "") %>: <input class="cfrm" type="text" name="marca" size="15" maxlength="18" align="middle"><% mostra_campo "tipo_rad","combo","%[pc]%",1 %>&nbsp;&nbsp;
	<%= mostra_label("ncl", "", "") %>: <input class="cfrm" type="text" name="ncl" size="1" maxlength="2">&nbsp;&nbsp;
	<%= mostra_label("ordem", "", "") %>: <% mostra_campo "ordem","combo","",1 %>&nbsp;&nbsp;
	<input type="image" alt="Pesquisar" src="imagem/botao_busca.gif" align="middle">&nbsp;&nbsp;&nbsp;<a href="javascript: limpar()"><img src="imagem/botao_limpar.gif" align="absmiddle" alt="Limpar" width="20" height="20" border="0"></a></td>
</tr>
</form>
<tr bgcolor="#F3F3F3" class="preto12">
	<td colspan="4" align="center" height="8"><img src="imagem/1px-transp.gif" width="1" height="8" border="0"></td>
</tr>
</table>
<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0"><tr>
<td valign="top" width="90%" bgcolor="#f4f4f4">
<table width="100%" class=texto_webseek border="0" cellspacing="0" cellpadding="0">
<!-- <tr>
<td bgcolor="darkslategray"></td>
</tr>
<tr bgcolor="#00578F" height=25 valign=middle>
<%
if Request.Querystring("dia") = "" then
data = date
else
data = Request.Querystring("dia")&"/"&request.querystring("mes")&"/"&request.querystring("ano")
end if
%>
<td align=left valign=middle align=center width="100%" class=texto_webseek><font color=whitesmoke><b>&nbsp;<%= mostra_label("lista_pr", "", "") %> - <%= fdata(data) %></b></font></td>
</tr>
<tr> -->
<tr bgcolor="#ffffff" valign=middle>
<%
if Request.Querystring("dia") = "" then
data = date
else
data = Request.Querystring("dia")&"/"&request.querystring("mes")&"/"&request.querystring("ano")
end if
%>
<td align=left valign=middle align=center width="100%" class=texto_webseek>
<table cellpadding="0" cellspacing="0" border="0" width="100%">
<tr>
	<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
	<td height="16" valign="middle" class="titulo"><%= fdata(data) %>&nbsp;<%= replace(mostra_label("lista_pr", "", ""), " ", "&nbsp;") %>&nbsp;<%= replace(mostra_label("pr_"&replace(tipo_visu, "prazo_", ""), "", ""), " ", "&nbsp;") %>&nbsp;&nbsp;</td>
	<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
	<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
</tr></table></td>
</tr>
<tr>
<td valign="top">
<%
set rs = conn.execute("SELECT * FROM Providencias WHERE ((usuario = '"&session("vinculado")&"') or (usuario = '"&session("vinculado")&"##"&session("nomeusu")&"')) AND " &tplic(1,tipo_visu)& " = "&rdata(data)&" ORDER BY prazo_ger DESC")
if not rs.eof then
%>
<table width="100%" cellpadding="1" cellspacing="1">
<tr bgcolor="#00578F" class="branco12">
<td width="5%" align="center">&nbsp;</td>
<% If tipo_visu = "prazo_ger" then %>
<td width="13%" align="center"><b style="color: yellow"><%= mostra_label("pr_ger", "", "") %></b></td>
<td width="13%" align="center"><b><%= mostra_label("pr_ofi", "", "") %></b></td>
<% Else %>
<td width="13%" align="center"><b style="color: yellow"><%= mostra_label("pr_ofi", "", "") %></b></td>
<td width="13%" align="center"><b><%= mostra_label("pr_ger", "", "") %></b></td>
<% End If %>
<td width="10%" align="center"><b><%= mostra_label("processo", "", "") %></b></td>
<td width="67%"><b><%= mostra_label("descricao", "", "") %></b></td>
</tr>
<%
while not rs.eof
%>
<tr bgcolor="<%=fundo%>" class="preto10">
<td width="5%" align="center"><% If rs("executada") then %><img src="imagem/check.gif" width="15" height="13"><% Else %>&nbsp;<% End If %></td>
<% If tipo_visu = "prazo_ger" then %>
<td width="13%" align="center"><% If (rs("prazo_ger") = "") OR (isnull(rs("prazo_ger"))) then %>--<% Else %><%= fdata(rs("prazo_ger"))%><% End If %></td>
<td width="13%" align="center"><% If (rs("prazo_ofi") = "") OR (isnull(rs("prazo_ofi"))) then %>--<% Else %><%= fdata(rs("prazo_ofi"))%><% End If %></td>
<% Else %>
<td width="13%" align="center"><% If (rs("prazo_ofi") = "") OR (isnull(rs("prazo_ofi"))) then %>--<% Else %><%= fdata(rs("prazo_ofi"))%><% End If %></td>
<td width="13%" align="center"><% If (rs("prazo_ger") = "") OR (isnull(rs("prazo_ger"))) then %>--<% Else %><%= fdata(rs("prazo_ger"))%><% End If %></td>
<% End If %>
<td width="10%" align="center"><% If (rs("processo") = "") OR (isnull(rs("processo"))) then %>--<% Else %><a href="detalhe_proc.asp?id_proc=<%= rs("processo") %>" class="link_processo"><%= rs("processo") %></a><% End If %></td>
<td width="67%"><a href="edit_providencia.asp?id=<%= rs("id") %>" class="link_processo"><% If (rs("hora") <> "") and (not isnull(rs("hora"))) then %><%= rs("hora") %> - <% End If %><% If (rs("rpi") <> "") and (not isnull(rs("rpi"))) then %><%= rs("rpi") %> - <% End If %><% If (rs("desp") <> "") and (not isnull(rs("desp"))) then %><%= rs("desp") %> - <% End If %><%= rs("descricao") %></a></td>
</tr>
<%
if fundo ="#ffffff" then
	fundo ="#efefef"
else
	fundo ="#ffffff"
end if
rs.movenext
wend
%>
</table>
<% else %>
<br>
<br>
<div class="preto12" align="center"><b><%= mostra_label("nenhuma_"&tipo_visu, "", "") %>.</b></div>
<% end if %>
</table>
</td>
<td>&nbsp;</td>
<td align="right" valign="top">
<script type="text/javascript">
<%
data_hj = date()
if request.querystring("mes") = "" then
	data = data_hj
else
	if request.querystring("dia") = "" then
		data = cdate("1/"&request.querystring("mes")&"/"&request.querystring("ano"))
	else
		data = cdate(request.querystring("dia")&"/"&request.querystring("mes")&"/"&request.querystring("ano"))
	end if
end if
pdata = dateadd("m", 1, data)
adata = dateadd("m", -1, data)
%>
var aa=<%= year(adata) %>;
var am=<%= month(adata) %>;
var pa=<%= year(pdata) %>;
var pm=<%= month(pdata) %>;
<%if request.querystring("mes") = "" then %>
var curmonth=<%= month(data) %>;<% mes = month(data) %>
var md = true;
<% Else %>
var curmonth=<%= request.querystring("mes") %>;<% mes = request.querystring("mes") %>
<% If cint(request.querystring("mes")) = month(data_hj) then %>
var md = true;
<% Else %>
var md = false;
<% End If %>
<% End If %>
var todaydate=new Date(<%= year(data) %>,<%= month(data) %>,<%= day(data) %>);
<%if request.querystring("ano") = "" then %>
var curyear=<%= year(data) %>;<% ano = year(data) %>
<% Else %>
var curyear=<%= request.querystring("ano") %>;<% ano = request.querystring("ano") %>
<% End If %>
<%
set rs = conn.execute("SELECT DISTINCT day(" &tplic(1,tipo_visu)& ") AS dia FROM providencias WHERE ((usuario = '"&session("vinculado")&"') or (usuario = '" &session("vinculado")&"##"&session("nomeusu")&"')) AND month(" &tplic(1,tipo_visu)& ") = "&tplic(1,mes)&" and year(" &tplic(1,tipo_visu)& ") = "& tplic(1,ano) & " order by dia")
dias = ""
while not rs.eof
dias = dias & rs("dia")
rs.movenext
if not rs.eof then
	dias = dias & ","
end if
wend
%>
<% If (LEN(dias) = 1) or (LEN(dias) = 2) THEN %>
var provs = new Array(1);
provs[0] = <%= dias %>;
<% Else %>
var provs = new Array(<%= dias %>);
<% End If %>
var qtp = provs.length;

document.write(buildCal(curmonth ,curyear, "main", "month", "daysofweek", "days", 0));
</script>
<%
complemento = ""
for each campo in Request.Querystring
	if campo <> "tipo_visu" then
		complemento = complemento & "&" & campo & "=" & Request.Querystring(campo)
	end if
next
%>
<div align="center" class="preto10"><% If tipo_visu = "prazo_ger" then %><b>Prazos Gerenciais</b><% Else %><a href="main.asp?tipo_visu=ger<%= complemento %>" class="preto10">Prazos Gerenciais</a><% End If %> | <% If tipo_visu = "prazo_ofi" then %><b>Prazos Oficiais</b><% Else %><a href="main.asp?tipo_visu=ofi<%= complemento %>" class="preto10">Prazos Oficiais</a><% End If %></div>
</td></tr></table>
<table width="100%">
<tr>
	<td width="50%" valign="top" bgcolor="#F3F3F3">
	<table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#ffffff">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;<%= replace(mostra_label("info", "", "")," ","&nbsp;") %>&nbsp;&nbsp;</td>
		<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	<tr bgcolor="#F3F3F3" class="preto12">
		<td colspan="4" align="center" height="8"><img src="imagem/1px-transp.gif" width="1" height="8" border="0"></td>
	</tr>
	<tr bgcolor="#F3F3F3" class="preto12">
		<td colspan="4">
			<table cellpadding="1" cellspacing="1" border="0" class="preto12">
				<tr><td>&nbsp;<img src="imagem/bullet.gif" width="6" height="6" border="0" align="absmiddle"></td><td>&nbsp;Última RPI: <b><%= urpi %></b> - <b><%= dt_urpi %></b></td></tr>
				<tr><td>&nbsp;<img src="imagem/bullet.gif" width="6" height="6" border="0" align="absmiddle"></td><td>&nbsp;Processos Cadastrados: <b><%= pcad %></b></td></tr>
				<tr><td>&nbsp;<img src="imagem/bullet.gif" width="6" height="6" border="0" align="absmiddle"></td><td>&nbsp;Processos Próprios: <b><%= pprop %></b></td></tr>
				<tr><td>&nbsp;<img src="imagem/bullet.gif" width="6" height="6" border="0" align="absmiddle"></td><td>&nbsp;Processos de Terceiros: <b><%= pterc %></b></td></tr>
			</table>
		</td>
	</tr>
	<tr bgcolor="#F3F3F3" class="preto12">
		<td colspan="4" align="center" height="8"><img src="imagem/1px-transp.gif" width="1" height="8" border="0"></td>
	</tr>
	</table>
	</td>
	<td width="50%" valign="top" bgcolor="#F3F3F3">
	<table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#ffffff">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;<%= replace(mostra_label("aviso", "", "")," ","&nbsp;") %>&nbsp;&nbsp;</td>
		<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	<tr bgcolor="#F3F3F3" class="preto12">
		<td colspan="4" align="center" height="8"><img src="imagem/1px-transp.gif" width="1" height="8" border="0"></td>
	</tr>
	<tr bgcolor="#F3F3F3" class="preto12">
		<td colspan="4" align="center">
			<table cellpadding="1" cellspacing="1" border="0" class="preto12">
				<%
				set rs = conn.execute("SELECT b_vermelho, aviso FROM Avisos WHERE ((usuario = '" &Session("vinculado")& "') OR (usuario = 'zz-ld')) AND (ativo = 1) and dateadd(day, dias, data) > getdate() ORDER BY usuario, id DESC")
				while not rs.eof
				%>
				<tr><td valign="baseline">&nbsp;<img src="imagem/bullet<% If rs("b_vermelho") then %>_vermelho<% End If %>.gif" width="6" height="6" border="0" align="middle"></td><td>&nbsp;</td><td style="text-align: justify;"><%= rs("aviso") %></td></tr>
				<%
				rs.movenext
				wend
				%>
			</table>
		</td>
	</tr>
	<tr bgcolor="#F3F3F3" class="preto12">
		<td colspan="4" align="center" height="8"><img src="imagem/1px-transp.gif" width="1" height="8" border="0"></td>
	</tr>
	</table>
	</td>
</tr>
</table>
</body>
</html>
