<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn_webseek.asp"-->
<!--#include file="../usuario_logado.asp"-->
<!--#include file="../include/conn_intra.asp"-->
<!--#include file="conn.asp"--> 

<title>APOL Jurídico</title>

<body leftmargin=0 topmargin=0>
<%
sub bloqueia
	%>
	<script language="JavaScript">
	alert('Usuário sem permissão de acesso, favor entrar em contato com o administrador do sistema.');
	history.back();
	</script>
	<%
	response.end
end sub


vdir = ""
vdir2 = ""
if instr(Request.ServerVariables("url"),"contencioso") = 0 then
	vdir = "contencioso/"
end if

if instr(Request.ServerVariables("url"),"contencioso") <> 0 then
	vdir2 = "../"
end if

pg_help = split(Request.ServerVariables("PATH_INFO"),"/")

ds = array("-","Domingo","Segunda-Feira","Terça-Feira","Quarta-Feira","Quinta-Feira","Sexta-Feira","Sabado")
data = date
%>
<script language="JavaScript">
<!--
var date = new Date() ;
var unique = date.getTime() ;
var url = '<%= Request.ServerVariables("REMOTE_ADDR") %>' ;
var request_url = "http://online1.chatlive.com.br/portalintelectual/request.php?l=portalintelect&x=1&deptid=0&page="+url ;
function launch_support()
{
	newwin = window.open( request_url, unique, 'scrollbars=no,menubar=no,resizable=0,location=no,screenX=50,screenY=100,width=450,height=350' ) ;
	newwin.focus() ;
}

function abrem()	
{
	var width = 788;
	var height = 718;
	var LeftPosition, TopPosition;
	if (screen.width == 800){
		LeftPosition = 0;
		TopPosition = 0;
	}
	else{
		LeftPosition = (screen.width) ? (screen.width-width)/2 : 0;
		TopPosition = (screen.height) ? (screen.height-height-60)/2 : 0;
	}
	
	newwin = window.open("<%=vdir2%>main.asp?modulo=M","popmar",'width='+width+',height='+height+',resizable=0,top='+TopPosition+',left='+LeftPosition+',scrollbars=yes,status=no');
	newwin.focus() ;
}	

function abreadm()	
{
	var width = 788;
	var height = 718;
	var LeftPosition, TopPosition;
	if (screen.width == 800){
		LeftPosition = 0;
		TopPosition = 0;
	}
	else{
		LeftPosition = (screen.width) ? (screen.width-width)/2 : 0;
		TopPosition = (screen.height) ? (screen.height-height-60)/2 : 0;
	}
	
	newwin = window.open("<%=vdir2%>modcomum/main.asp","popadm",'width='+width+',height='+height+',resizable=0,top='+TopPosition+',left='+LeftPosition+',scrollbars=yes,status=no');
	newwin.focus() ;
}

function abrever()	
{
	var width = 788;
	var height = 718;
	var LeftPosition, TopPosition;
	if (screen.width == 800){
		LeftPosition = 0;
		TopPosition = 0;
	}
	else{
		LeftPosition = (screen.width) ? (screen.width-width)/2 : 0;
		TopPosition = (screen.height) ? (screen.height-height-60)/2 : 0;
	}
	
	newwin = window.open("<%=vdir2%>main.asp?modulo=V","popver",'width='+width+',height='+height+',resizable=0,top='+TopPosition+',left='+LeftPosition+',scrollbars=yes,status=no');
	newwin.focus() ;
}

function abrepat()	
{
	var width = 788;
	var height = 718;
	var LeftPosition, TopPosition;
	if (screen.width == 800){
		LeftPosition = 0;
		TopPosition = 0;
	}
	else{
		LeftPosition = (screen.width) ? (screen.width-width)/2 : 0;
		TopPosition = (screen.height) ? (screen.height-height-60)/2 : 0;
	}
	
	newwin = window.open("<%=vdir2%>main.asp?modulo=P","poppat",'width='+width+',height='+height+',resizable=0,top='+TopPosition+',left='+LeftPosition+',scrollbars=yes,status=no');
	newwin.focus() ;
}

function bloqueia(bt,frm){
bt.disabled='true';
frm.submit();
}
//-->
</script>
<%
sqlM = "select cad_livre_id, titulo from cad_livre_setup where modulo ='C' and usuario = '" & session("vinculado") & "' and ativo=1"
set rsM = conn.execute(sqlM)

if not rsM.eof then
	while not rsM.eof
		cadastro = cadastro & " | <a href=""" & vdir2 & "cad_livre_rel.asp?cad_id=" & rsM("cad_livre_id") & "&modulo=C"" class=""branco11"">" & rsM("titulo") & "</a>"
	rsM.MoveNext
	wend
end if
%>
<%
sql_dias = "SELECT dias, andamentos, campo3, campo4 FROM contencioso.dbo.parametros WHERE usuario = '"&session("vinculado")&"'"
set rspar = conn.execute(sql_dias)
campo3 = ""
campo4 = ""
andamentos_c = "Andamentos"
If not rspar.eof then
	if not isnull(rspar("dias")) then
		dias = rspar("dias")
		if dias = 0 then
			dias = 7
		end if
	else
		dias = 7
	end if
	campo3 = rspar("campo3")
	campo4 = rspar("campo4")
	if trim(rspar("andamentos")) = "" or isnull(rspar("andamentos")) then
		andamentos_c = "Andamentos"
	else
		andamentos_c = rspar("andamentos")
	end if

Else
	dias = 7
End if
if isnull(campo3) or isempty(campo3) or len(trim(campo3)) = 0 then campo3 = "Campo 3"
if isnull(campo4) or isempty(campo4) or len(trim(campo4)) = 0 then campo4 = "Campo 4"
%>
<script>
function abre_ajuda(url_ajuda){
	var width = 788;
	var height = 718;
	var LeftPosition, TopPosition;
	LeftPosition = (screen.width) ? (screen.width-width)/2 : 0;
	TopPosition = (screen.height) ? (screen.height-height-60)/2 : 0;
	window.open(url_ajuda,"popup_ajuda",'width='+width+',height='+height+',resizable=1,top='+TopPosition+',left='+LeftPosition+',scrollbars=yes,status=no');
}
function abre_ajuda_down(url_ajuda){
	var width = 10;
	var height = 10;
	var LeftPosition, TopPosition;
	//LeftPosition = (screen.width) ? (screen.width-width)/2 : 0;
	//TopPosition = (screen.height) ? (screen.height-height-60)/2 : 0;
	window.open(url_ajuda,"popup_ajuda",'width='+width+',height='+height+',resizable=1,top=1200,left=0,scrollbars=yes,status=no');
}

function imprime() 
	{	
		var width = 788;
		var height = 718;
		var LeftPosition, TopPosition;
		if (screen.width == 800){
			LeftPosition = 0;
			TopPosition = 0;
		}
		else{
			LeftPosition = (screen.width) ? (screen.width-width)/2 : 0;
			TopPosition = (screen.height) ? (screen.height-height-60)/2 : 0;
		}
		window.open("","popup_prn",'width='+width+',height='+height+',resizable=0,top='+TopPosition+',left='+LeftPosition+',scrollbars=yes,status=no');
		document.frm_prn.submit();
	}
                
var ns4 = (document.layers)? true:false;
var ie4 = (document.getElementById)? true:false;
var my_array = new Array('proc','agenda','link','tabela','ajuda','div');

var txt_proc = '&nbsp;&nbsp;&nbsp;<a href="<%=vdir%>processo_list.asp?modulo=C" class="branco11">Manutenção e Relatório</a> | <a href="<%=vdir%>rel_andamentos_tribunais.asp?modulo=C" class="branco11">Relatório de <%=andamentos_C%></a>';
var txt_agenda = '&nbsp;&nbsp;&nbsp;';
var txt_tabela = '&nbsp;&nbsp;&nbsp;<a href="<%=vdir%>auxiliares_list.asp?tipo=N&modulo=C" class="branco11">Natureza</a> | <a href="<%=vdir%>auxiliares_list.asp?tipo=O&modulo=C" class="branco11">Órgão</a> | <a href="<%=vdir%>auxiliares_list.asp?tipo=R&modulo=C" class="branco11">Rito</a> | <a href="<%=vdir%>auxiliares_list.asp?tipo=J&modulo=C" class="branco11">Juízo</a> | <a href="<%=vdir%>auxiliares_list.asp?tipo=C&modulo=C" class="branco11">Comarca</a> | <a href="<%=vdir%>auxiliares_list.asp?tipo=T&modulo=C" class="branco11">Tipo de Ação</a> | <a href="<%=vdir%>auxiliares_list.asp?tipo=F&modulo=C" class="branco11">Referência Financeira</a> | <a href="<%=vdir%>auxiliares_list.asp?tipo=L&modulo=C" class="branco11">Objeto Principal</a> | <a href="<%=vdir%>auxiliares_list.asp?tipo=3&modulo=C&campo=<%=campo3%>" class="branco11"><%=campo3%></a> | <a href="<%=vdir%>auxiliares_list.asp?tipo=4&modulo=C&campo=<%=campo4%>" class="branco11"><%=campo4%></a>';
var txt_link = '&nbsp;&nbsp;&nbsp;<a href="javascript: abrem()" class="branco11">Marcas</a> | <a href="javascript: abrepat()" class="branco11">Patentes</a> | <a href="javascript: abrever()" class="branco11">Contratos</a> | <a href="javascript: abreadm()" class="branco11">Administração</a>';
var txt_div = '&nbsp;&nbsp;&nbsp;<a href="<%=vdir%>param.asp?modulo=C" class="branco11">Parâmetros</a> | <a href="<%=vdir%>rel_stats.asp" class="branco11">Relatório Estatístico</a> | <a href="<%=vdir%>auditoria_tribunais.asp?modulo=C" class="branco11">Auditoria de Conexões</a> | <a href="<%=vdir%>cad_param_Tribunais.asp?modulo=C" class="branco11">Parâmetros de Conexão</a>  <%=cadastro%>';
<%
If tplic(1,pg_help(ubound(pg_help))) = "processo_redirect.asp" then
	pag_help_atual = "processo.asp"
Else
	pag_help_atual = tplic(1,pg_help(ubound(pg_help)))
End If

sql = "SELECT titulo, descricao FROM Documentos WHERE pchave = '#C#"&pag_help_atual&"#'"
set rshelp = conn_intra.execute(sql)
pgh = ""
if not rshelp.eof then
	pgh = pag_help_atual
end if
%>
var txt_ajuda = '&nbsp;&nbsp;&nbsp;<a href="javascript: abre_ajuda(\'<%=vdir2%>ajuda.asp?modulo=C\')" class="branco11">Tire sua Dúvida</a> | <a href="javascript: launch_support()" class="branco11">Atendimento On-Line</a><% If pgh <> "" then %> | <a href="javascript: abre_ajuda(\'<%=vdir2%>detalhe_ajuda_pg.asp?pg=<%= pgh %>&modulo=C\')" class="branco11">Ajuda desta Página</a><% End If %> | <a href="javascript: abre_ajuda_down(\'<%=vdir2%>force_down.asp?file=/apol/manual/Manual_Apol.pdf\')" class="branco11">Manual</a>';
function pop_header(url, width,  height) 
	{
		varwin=window.open(url,"openscript",'width='+width+',height='+height+',resizable=0,scrollbars=yes,status=no');
	}

function escrevelyr(id_div,text) {
	if (ns4) {
		var lyr = document.layers[id].document
		lyr.open()
		lyr.write(text)
		lyr.close()
	}
	else if (ie4) document.getElementById(id_div).innerHTML = text
	else document.getElementById(id_div).innerHTML = text
}

function limpam(){
	for (i = 0; i < 6; i++)
	    {
		objl = eval("document.getElementById('l"+my_array[i]+"')");
		objt = eval("document.getElementById('td_"+my_array[i]+"')");
		
		objt.style.backgroundImage='url(imagem/aba_accont.gif)';
		objl.style.font = '12px Verdana';
		escrevelyr('menu_div','')
	    }
}

function muda(onde){
	a = limpam();
	
	objl = eval("document.getElementById('l"+onde+"')");
	objt = eval("document.getElementById('td_"+onde+"')");
	
	objt.style.backgroundImage='url(imagem/aba_aecont.gif)';
	objl.style.font = 'bold 12px Verdana';
	txt = eval("txt_"+onde);
	escrevelyr('menu_div',txt);
	}
	
	function abreCalc_Data(modulo){
		var Left_Position, Top_Position;
		var width = 500, height = 390;
		Left_Position = (screen.width) ? (screen.width-width)/2 : 0;
		Top_Position = (screen.height) ? (screen.height-height-60)/2 : 0;
		var janela = window.open('<%=Mid(Request.ServerVariables("PATH_INFO"), 1, Instr(2, Request.ServerVariables("PATH_INFO"), "/"))%>calcData.asp?modulo='+modulo, 'cal_data', 'width='+width+', height='+height+', top='+Top_Position+', left='+Left_Position+', rezise=0');
		janela.focus();
	}
	
	document.onkeydown = function (event){
		if(window.event.keyCode == 113){
			abreCalc_Data('C');
		}
	}
</script>

<table width="770" cellspacing="0" cellpadding="0" border="0">
<form action="<%= Request.ServerVariables("url") %>" method="get" name="frm_prn" target="popup_prn">
<input type="hidden" name="imprimir" value="S">
<% for each campo in request.querystring %>
	<% If campo <> "pg" then %>
		<input type="hidden" name="<%= campo %>" value="<%= Replace(request.querystring(campo),chr(34),chr(147)) %>">
	<% End If %>
<% next %>
<% for each campo in request.form %>
	<% If campo <> "pg" then %>
		<input type="hidden" name="<%= campo %>" value="<%= Replace(request(campo),chr(34),chr(147)) %>">
	<% End If %>
<% next %>
</form>

<tr>
	<td colspan="3" width="770" height="5" align="right" class="preto11"><img src="imagem/1px-transp.gif" width="1" height="5" border="0"></td>
</tr>
<tr>
	<td rowspan="2" width="176"><img src="<%=vdir%>imagem/logo.gif" width="176" height="59" alt="APOL"></td>
	<td rowspan="2" width="1"><img src="imagem/1px-transp.gif" width="1" height="59" border="0"></td>
	<td width="602" class="branco11" height="29"><table cellpadding="0" cellspacing="0" border="0" class="branco12">
<tr>
	<td class="bgtd<% If menu_onde = "proc" then %>s<% End If %>" width="99" height="29" align="center" id="td_proc"><a id="lproc" href="javascript: muda('proc')" class="branco12<% If menu_onde = "proc" then %>b<% End If %>">Processos</a></td>
	<td width="1" height="29"><img src="imagem/1px-transp.gif" width="1" height="29" border="0"></td>
	<td class="bgtd<% If menu_onde = "tabela" then %>s<% End If %>" width="99" height="29" align="center" id="td_tabela"><a id="ltabela" href="javascript: muda('tabela')" class="branco12<% If menu_onde = "tabela" then %>b<% End If %>">Tabelas</a></div></td>
	<td width="1" height="29"><img src="imagem/1px-transp.gif" width="1" height="29" border="0"></td>
	<td class="bgtd<% If menu_onde = "agenda" then %>s<% End If %>" width="99" height="29" align="center" id="td_agenda"><a id="lagenda" href="<%=vdir2%>lista_providencia.asp?modulo=C&cria=1&dias=<%=dias%>" class="branco12<% If menu_onde = "agenda" then %>b<% End If %>">Agenda</a></div></td>
	<td width="1" height="29"><img src="imagem/1px-transp.gif" width="1" height="29" border="0"></td>
	<td class="bgtd<% If menu_onde = "div" then %>s<% End If %>" width="99" height="29" align="center" id="td_div"><a id="ldiv" href="javascript: muda('div')" class="branco12<% If menu_onde = "div" then %>b<% End If %>">Diversos</a></div></td>
	<td width="1" height="29"><img src="imagem/1px-transp.gif" width="1" height="29" border="0"></td>
	<td class="bgtd<% If menu_onde = "link" then %>s<% End If %>" width="99" height="29" align="center" id="td_link"><a id="llink" href="javascript: muda('link')" class="branco12<% If menu_onde = "link" then %>b<% End If %>">Links</a></div></td>
	<td width="1" height="29"><img src="imagem/1px-transp.gif" width="1" height="29" border="0"></td>
	<td class="bgtd<% If menu_onde = "ajuda" then %>s<% End If %>" width="99" height="29" align="center" id="td_ajuda"><a id="lajuda" href="javascript: muda('ajuda')" class="branco12<% If menu_onde = "ajuda" then %>b<% End If %>">Ajuda</a></div></td>
</tr>
</table>
</td>
</tr>
<tr>
	<td width="603" class="branco12m" height="30"><div id="menu_div" style="position: relative; font-family: Verdana; font-size: 12px;"><% If menu_onde <> "" then %>	
<script>
document.write(txt_<%= menu_onde %>);
</script>
<% End If %></div></td>
</tr>
<tr>
	<td height="22" valign="middle"><img src="imagem/logo_ld_pequeno.gif" align="absmiddle" alt="LDSOFT - Informática especializada em Propriedade Intelectual" width="128" height="18" border="0"></td>
	<td colspan="2" height="22" align="right" class="linkp11">
	<!--- <%' If pgh <> "" then %><a href="detalhe_ajuda_pg.asp?pg=<%'= pgh %>&modulo=C" class="linkp11">Ajuda</a>&nbsp;&nbsp;|&nbsp;&nbsp;<%' End If %> --->
	<a class="linkp11" href="<%=vdir2%>main.asp?modulo=C">Inicial</a><% If ((menu_onde <> "") and (bt_voltar <> "false")) then %>&nbsp;&nbsp;|&nbsp;&nbsp;<a class="linkp11" <%if session("voltar")<> "" then%>href="<%=session("voltar")%>" <%else%>href="javascript: history.back()"<%end if%>>Voltar</a><% End If %>
	<% If bt_imprimir then %>
		<% If bt_export then %>
			&nbsp;&nbsp;|&nbsp;&nbsp;<a id="link_imp_exp" class="linkp11" onmouseover="imp_export()" class=preto11>Impressão/Exportação</a>
		<% Else %>
			&nbsp;&nbsp;|&nbsp;&nbsp;<a id="link_imp" class="linkp11" href="javascript: imprime()" class=preto11>Versão para Impressão</a>
		<% End If %>
	<% End If %>
	<% If email_cont then %><% if (Session("cont_env_email_proc")) or (Session("adm_adm_sys")) then %>&nbsp;&nbsp;|&nbsp;&nbsp;<a class="linkp11" href="javascript:abrirjanela('email_cont.asp?id_processo=<%=request.querystring("id_processo")%>&andamentos_c=<%=andamentos_c %>',525,530)">Enviar E-mail</a><% End If %><% End If %><%if aparece_sair = "" then%>&nbsp;&nbsp;|&nbsp;&nbsp;<a class="linkp11" href="javascript: mostra_sair()">Sair</a><%end if%>&nbsp;&nbsp;</td>
</tr>
<tr>
	<td colspan="3" width="770"><img src="imagem/linha_dupla.gif" width="770" height="3"></td>
</tr>
</table>

<div id="confirma_sair" style="position: absolute; top: 60px; width: 770px; left: 1px; height: 400px; visibility: hidden;">
<table width="100%" height="100%">
<tr valign="middle">
	<td align="center">
<table width="300" bgcolor="#FFFFFF" style="border: 1px solid Black;" class="preto11">
<tr>
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;APOL&nbsp;&nbsp;</td>
		<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td align="center">&nbsp;</td>
</tr>
<tr>
	<td align="center"><img src="imagem/pergunta.gif" width="35" height="33" border="0" align="absmiddle">&nbsp;&nbsp;<b style="color:red;">Confirma saída do sistema ?</b></td>
</tr>
<tr>
	<td align="center">&nbsp;</td>
</tr>
<tr>
	<td align="center">
	<table class="linkp11">
	<tr>
		<td background="imagem/botao_limpo.gif" width="82" height="21" align="center"><a href="javascript: fecha_sair()" class="linkp11">&nbsp;&nbsp;&nbsp;Não&nbsp;&nbsp;&nbsp;</a></td>
		<td>&nbsp;&nbsp;</td>
		<td background="imagem/botao_limpo.gif" width="82" height="21" align="center"><a href="javascript: executar_sair()" class="linkp11">&nbsp;&nbsp;&nbsp;Sim&nbsp;&nbsp;&nbsp;</a></td>
	</tr>
	</table>
	</td>
</tr>
</table>
	</td>
</tr>
</table>
</div>
<%
If tem_xls then
	altura = 55
else
	altura = 40
end if
%>
<iframe id="if_imp_exp" src="branco.htm" style="position: absolute; display:none; top: -1000px; width: 180px; height: <%= altura %>px; left: -1000px; z-index: 10;"></iframe>
<div id="div_imp_exp" onmouseover="imp_export()" style="border: 1px solid Black; position: absolute; display:none; top: -1000px; width: 180px; height: <%= altura %>px; left: -1000px; z-index: 99;">
<table width="100%" border="0" cellspacing="2" cellpadding="0" bgcolor="#ffffff" class="preto11" onmouseover="imp_export()" onmouseout="fecha_imp_export()">
	<tr>
		<td><a href="javascript: imprime()" onmouseover="imp_export()" onmouseout="" onclick="fecha_imp_export()" class="preto11"><img src="../imagem/html.gif" width="16" height="16" border="0" align="absmiddle"> Versão para Impressão</a></td>
	</tr>
	<tr>
		<td><a href="javascript: downloadPDF()" onmouseover="imp_export()" onmouseout="fecha_imp_export()" onclick="fecha_imp_export()" class="preto11"><img src="../imagem/pdf-document.gif" width="16" height="16" border="0" align="absmiddle"> Download PDF</a></td>
	</tr>
<% If tem_xls then %>
	<tr>
		<td><a href="javascript: downloadCSV()" onmouseover="imp_export()" onmouseout="fecha_imp_export()" onclick="fecha_imp_export()" class="preto11"><img src="../imagem/excel.gif" alt="" width="16" height="16" border="0" align="absmiddle"> Relatório BrOffice</a></td>
	</tr>
	<tr>
		<td><a href="javascript: downloadXLS()" onmouseover="imp_export()" onmouseout="fecha_imp_export()" onclick="fecha_imp_export()" class="preto11"><img src="../imagem/excel.gif" alt="" width="16" height="16" border="0" align="absmiddle"> Relatório Excel</a></td>
	</tr>
<% End If %>
</table>
</div>
<!--#include virtual="/apol/versao.asp"-->
<script>
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_showHideLayers() { //v3.0
  var i,p,v,obj,args=MM_showHideLayers.arguments;
  for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v='hide')?'hidden':v; }
    obj.visibility=v; }
}

function executar_sair(){
		location='<%=dir2%>login_apol.asp?logout=1';
	}
	
function mostra_sair()
		{
		MM_showHideLayers('confirma_sair','','show');
		}

function fecha_sair()
		{
		MM_showHideLayers('confirma_sair','','hide');
		}
		
function imp_export(){
	var element = $('link_imp_exp');
	var s = Position.cumulativeOffset(element)
	$('if_imp_exp').setStyle({left: (s[0])+'px', top: (s[1]-10)+'px'});
	$('div_imp_exp').setStyle({left: (s[0])+'px', top: (s[1]-10)+'px'});
	$('if_imp_exp').show();
	$('div_imp_exp').show();
}

function fecha_imp_export(){
	$('if_imp_exp').hide();
	$('div_imp_exp').hide();
}		
</script>
<% Session("voltar") = "" %>