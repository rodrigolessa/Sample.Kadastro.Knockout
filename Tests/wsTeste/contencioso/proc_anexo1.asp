<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn_webseek.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<!--#include file='../include/Db_open_webseek_teste.asp'-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<html>
<head>
	<title>APOL Jurídico<% If Request.Querystring("imprimir") <> "" then %> - Impressão de Informações<% End If %></title>
	<link rel="STYLESHEET" type="text/css" href="style.css"> 
	<link rel="STYLESHEET" type="text/css" href="style2.css">

	<script language="javascript" src="valida.js"></script>
	<script language="JavaScript" src="../include/funcoes.js"></script>

</head>

<%
vid_processo = request("id_processo")

if request("id_proc") <> "" then
	sql = "select id_processo, responsavel, usuario, processo, natureza, pasta, desc_res, tipo, competencia, situacao, situacaoenc, cliente, outraparte, vinculados, instancia, rito, orgao, juizo, comarca, distribuicao,  dt_encerra, desc_det, obs, participante, principal from TabProcCont where usuario = '"&session("vinculado")&"' and processo = '"&tplic(0,request("id_proc"))&"'"
	set rst = db.execute(sql)
	if not rst.eof then
		vid_processo = rst("id_processo")		
		processo = rst("processo")
	end if
end if

if vid_processo <> "" then
	bt_imprimir = true 
	email_cont = true
	if request("imprimir") = "S" then
		l_imp = "_p"
	end if
	sql = "select id_processo, responsavel, usuario, processo, natureza, pasta, desc_res, tipo, competencia, situacao, situacaoenc, cliente, outraparte, vinculados, instancia, rito, orgao, juizo, comarca, distribuicao,  dt_encerra, desc_det, obs, participante, principal from TabProcCont where id_processo = "&tplic(1,vid_processo)
	set rst = db.execute(sql)			
	if not rst.eof then
		id_processo = rst("id_processo")
		pasta = rst("pasta")
		distribuicao = fdata(rst("distribuicao"))
		processo = rst("processo")
		natureza = rst("natureza")
		dt_encerra = fdata(rst("dt_encerra"))
		juizo = rst("juizo")
		desc_res = rst("desc_res")
		situacao = rst("situacao")
		situacaoenc = rst("situacaoenc")		
		tipo = rst("tipo")
		instancia = rst("instancia")
		comarca = rst("comarca")
		competencia = rst("competencia")
		rito = rst("rito")
		orgao = rst("orgao")		
		responsavel = rst("responsavel")		
		desc_det = rst("desc_det")
		obs = rst("obs")
		participante = rst("participante")
		principal = rst("principal")
	end if	
end if

if request("x") = "1" then
	pasta = request("fpasta_c")
	distribuicao = fdata(request("fdistribuicao_d"))
	processo = request("fprocesso_c")
	natureza = request("fnatureza_n")	
	dt_encerra = fdata(request("fdt_encerra_d"))
	juizo = request("fjuizo_n")
	if juizo = "" then
		juizo = 0
	end if
	desc_res = request("fdesc_res_c")
	situacao = request("fsituacao_c")
	situacaoenc = request("fsituacaoenc_c")	
	tipo = request("ftipo_c")
	instancia = request("finstancia_c")
	comarca = request("fcomarca_n")
	if comarca = "" then
		comarca = 0
	end if
	competencia = request("fcompetencia_c")
	rito = request("frito_n")
	if rito = "" then
		rito = 0
	end if
	orgao = request("forgao_n")		
	if orgao = "" then
		orgao = 0
	end if
	responsavel = request("fresponsavel_n")		
	if responsavel = "" then
		responsavel = 0
	else
		responsavel = int(responsavel)
	end if
	desc_det = request("fdesc_det_c")
	obs = request("fobs_c")
	participante = request("fparticipante_c")
	principal = request("fprincipal_c")
end if

if isnull(natureza) or  natureza = "" then
	natureza=0
end if%>

<body leftmargin="0" topmargin="0" bgcolor="#efefef">
<%
	set rs_cm = db.execute("SELECT arquivo FROM TabProcCont WHERE usuario = '"&session("vinculado")&"' and id_processo = "&tplic(1,cint(vid_processo)))								
	if not rs_cm.eof then
		varquivo = rs_cm("arquivo")
		If (not isnull(varquivo)) and (varquivo <> "") then
			arqs = true	
		end if
		%>
		<tr bgcolor="#efefef">
			<td class="preto10" align=left height=25>&nbsp;&nbsp;<% If (not isnull(varquivo)) and (varquivo <> "") then %><a class="preto10" href="javascript:abrirjanela('../controle_arquivo.asp?modulo=C&id_proc=<%=vid_processo%>',350,140)">Ver Anexo(s)</a><%rowcount = 1%><% Else %><%rowcount = 0%><% End If %></td>
		</tr>						
		<% 
	else
		%>
		<tr>
			<td align="left" colspan=3 width=20%>&nbsp;</td>
		</tr>		
		<%
	end if
%>
<script>
if (<%=rowcount%>!='0') {
top.document.all.frame_anexo.style.height = <%= rowcount+23%>;
}
else
{
top.document.all.frame_anexo.style.height = 0;
}


	function abrirjanela(url, width,  height) 
		{
			varwin=window.open(url,"openscript",'width='+width+',height='+height+',resizable=0,scrollbars=yes,status=yes');
		}
</script>
</BODY>
</HTML>