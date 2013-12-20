<% session("voltar") = "../main.asp?modulo=C" %>
<!--#include file="db_open.asp"-->
<!--#include file="../usuario_logado.asp"-->

<%
if (not Session("cont_cons_param")) and (not Session("adm_adm_sys")) then
	bloqueia
	response.end
end if
%>
<% menu_onde = "div" %>
<link rel="STYLESHEET" type="text/css" href="style.css">
<!--#include file="header.asp"-->

<html>
<head>
	<title>APOL Jurídico</title>
	<style>
<!--
		P { margin-bottom: 0cm; direction: ltr; color: #000000; line-height: 0.46cm; widows: 2; orphans: 2 }
		P.western { font-family: "Frutiger 45 Light", "Arial", sans-serif; font-size: 10pt; so-language: de-DE; font-style: italic }
-->
</style>
</head>
<body>
<%
set rsp = db.execute("SELECT resp_proc_provid, dias, parado, prov_processo_retroativo, quantanda FROM Parametros WHERE usuario = '"&session("vinculado")&"'")
dias = rsp("dias")
parado = rsp("parado")
quantanda= rsp("quantanda")
%>
<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<form action="grava_param.asp" method="post" name="frm" onsubmit="javascript:return valida(this);">		
	<tr>				
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;Parâmetros&nbsp;Gerais&nbsp;&nbsp;</td>
		<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
<tr>

<%

set rsp2 = db.execute("SELECT ocorrencia, andamentos, campo1, campo2, campo3, campo4 FROM Parametros WHERE usuario = '"&session("vinculado")&"'")

If not rsp2.eof then
	ocorrencia = rsp2("ocorrencia")
	andamentos_C = rsp2("andamentos")
	campo1 = rsp2("campo1")
	campo2 = rsp2("campo2")
	campo3 = rsp2("campo3")
	campo4 = rsp2("campo4")
Else
	ocorrencia = ""
	andamentos_C = "Andamentos"
End If		
%>

<table bgcolor="#EFEFEF" width="100%" class=preto11 border="0" cellspacing="2" cellpadding="1">		
	<tr><td><label><input type="checkbox" name="resp_proc_provid" value="1"<% If rsp("resp_proc_provid") then %> checked<% End If %>> Usar responsável do processo para as providências.</label></td></tr>
	<tr><td><label><input type="checkbox" name="prov_processo_retroativo" value="1"<% If rsp("prov_processo_retroativo") then %> checked<% End If %>> Gerar providências criadas a partir de um item de checagem para processos retroativos.</label></td></tr>
	<tr>
		<td height="22">&nbsp;Exibir na agenda providências dos próximos <input type="text" name="dias" class="cfrm" size="2" maxlength="3" value="<%=dias%>"> dias.</td>
	</tr>	
	<tr>
		<td> 
		&nbsp;Exibir no detalhe do processo 
		<input type="text" name="quantanda" class="cfrm" size="2" maxlength="3" onKeyUp="somente_numero(this);" value="<%=quantanda%>"><font face="Arial Narrow, sans-serif" size="2">
		<%  If (andamentos_C  <> "") and (not isnull(andamentos_C )) then%>
			</font><%=andamentos_C%></td>
		<%else%>
			</font>andamentos</td>
		<% end if%>

	</tr>
	<tr>
		<td>&nbsp;<input type="submit"<% if not ((Session("cont_manut_param")) or (Session("adm_adm_sys"))) then %> disabled<% End If %> class="cfrm" value="Gravar"></td>
	</tr>
	</form>
</table>



<tr bgcolor="#ffffff">
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;Nome&nbsp;de&nbsp;Campos&nbsp;&nbsp;</td>
		<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
	</td>
</tr>

<table bgcolor="#EFEFEF" width="100%" class=preto11 border="0">
<tr>
<td>
<table class="preto11" bgcolor="#EFEFEF">

<table class="preto11">
<form action="grava_campo.asp" method="post" name="frm4" onSubmit="return valida_ocorrencia()">	
	<tr>
		<td>Nome para "Ocorrências":</td>
		<td><input class="cfrm" type="text" name="ocorrencia" size="20" maxlength="20" value="<%=ocorrencia%>"></td>
	</tr>
	<tr>
		<td>Nome para "Andamentos":</td>
		<td><input class="cfrm" type="text" name="andamentos" size="20" maxlength="20" value="<%=andamentos_C%>"></td>
	</tr>
	<tr>
		<td>Nome para "Campo 1":</td>
		<td><input class="cfrm" type="text" name="campo1" size="20" maxlength="20" value="<%=campo1%>"></td>
	</tr>
	<tr>
		<td>Nome para "Campo 2":</td>
		<td><input class="cfrm" type="text" name="campo2" size="20" maxlength="20" value="<%=campo2%>"></td>
	</tr>
	<tr>
		<td>Nome para "Campo 3":</td>
		<td><input class="cfrm" type="text" name="campo3" size="20" maxlength="20" value="<%=campo3%>"></td>
	</tr>
	<tr>
		<td>Nome para "Campo 4":</td>
		<td><input class="cfrm" type="text" name="campo4" size="20" maxlength="20" value="<%=campo4%>"></td>
	</tr>
	<tr>
		<td><input type="submit"<% if not ((Session("cont_manut_param")) or (Session("adm_adm_sys"))) then %> disabled<% End If %> class="cfrm" value="Gravar"></td></tr>
		</td>
	</tr>
</form>
</table>
</td>
</tr>




<%set rsp1 = db.execute("SELECT arq_comunicacao, comunicacao FROM Parametros WHERE usuario = '"&session("vinculado")&"'")%>


<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>		
		<td height="16" valign="middle" width=23px>&nbsp;<img src="imagem/tit_le.gif" width="19" height="18"></td>
		<td height="16" valign="middle" align=center class="titulo" width=150px>&nbsp;&nbsp;Personalização&nbsp;de&nbsp;Cartas&nbsp;&nbsp;</td>
		<td height="16" width=607px background="imagem/tit_ld.gif"></td>
		<td height="16" valign="middle" width=20px><img src="imagem/tit_fim.gif" width="21" height="16"></td>											
	</tr>
</table>
	
<table bgcolor="#EFEFEF" width="100%" class=preto11 border="0" cellspacing="2" cellpadding="3">		
		<tr>
			<td align="left">Todos os arquivos devem estar em extensão RTF. (Tamanho máximo de 3MB.)</td>
		</tr>

		<table bgcolor="#EFEFEF" width="100%" class=preto11 border="0" cellspacing="2" cellpadding="3">

		<form action="grava_rtf_param.asp?origem=CM" method="post" enctype="multipart/form-data" name="frm_rtf" onSubmit="return valida_rtf()">		
		<tr>
			<td>Comunicação:</td>
			<td><input type="file" class="cfrm" style="font: 12px;width:250" name="rtf">&nbsp;&nbsp;<input type="submit"<% if not ((Session("cont_manut_param")) or (Session("adm_adm_sys"))) then %> disabled<% End If %> name="bts" value="Incluir" class="cfrm"></td>
		</form>
		<% modulo = "C" %>
		<%If not isnull(rsp1("comunicacao")) then%>
		<form action="javascript: mostra_proc()" method="post" enctype="multipart/form-data" name="frm_rtfx">		
			<td width="98%"><input type="submit"<% if not ((Session("cont_manut_param")) or (Session("adm_adm_sys"))) then %> disabled<% End If %> name="bts" value="Excluir" class="cfrm">&nbsp;<a href="javascript:abrirjanela('../down_rtf.asp?modulo=<%= modulo %>&tipo=com',350,110)"><img src="../imagem/down_rtf.gif" alt="Download do RTF" width="16" height="16" border="0" align="absmiddle"></a>&nbsp;<strong><%=Replace(rsp1("arq_comunicacao"), "<", "&lt;")%></strong></td>
		</form>
		<%Else%>
		<td width="98%">&nbsp;</td>
		</tr>
		<%End If%>

</table>
</body>
</html>

<div id="exclui_procx" style="position: absolute; top: 1px; width: 770px; left: 1px; height: 498px; visibility: hidden;">
<table width="100%" height="100%">
<tr valign="middle">
	<td align="center">
<table width="300" bgcolor="#FFFFFF" style="border: 1px solid Black;" class="preto11">
<tr>
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;Exclusão&nbsp;de&nbsp;Carta&nbsp;&nbsp;</td>
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
	<td align="center"><img src="imagem/pergunta.gif" width="35" height="33" border="0" align="absmiddle">&nbsp;&nbsp;<b style="color:red;">Confirma exclusão ?</b></td>
</tr>
<tr>
	<td align="center">&nbsp;</td>
</tr>
<tr>
	<td align="center">
	<table class="linkp11">
	<tr>
		<td background="imagem/botao_limpo.gif" width="82" height="21" align="center"><a href="javascript: fecha_proc()" class="linkp11">&nbsp;&nbsp;&nbsp;Não&nbsp;&nbsp;&nbsp;</a></td>
		<td>&nbsp;&nbsp;</td>
		<td background="imagem/botao_limpo.gif" width="82" height="21" align="center"><a href="excluir_rtf_param.asp?origem=CM" class="linkp11">&nbsp;&nbsp;&nbsp;Sim&nbsp;&nbsp;&nbsp;</a></td>
	</tr>
	</table>
	</td>
</tr>
</table>
	</td>
</tr>
</table>
</div>

<script>
	function abrirjanela(url, width, height){
		varwin=window.open(url,"openscript12",'width='+width+',height='+height+',resizable=1,scrollbars=yes,status=yes');
	}
	
	function trimAll(sString)
	{
		while (sString.substring(0,1) == ' ')
		{
			sString = sString.substring(1, sString.length);
		}
		while (sString.substring(sString.length-1, sString.length) == ' ')
		{
			sString = sString.substring(0,sString.length-1);
		}
	return sString;
	}
	
	
	function valida_ocorrencia()
	{
		if (document.frm4.ocorrencia.value != "" && trimAll(document.frm4.ocorrencia.value) == "")
		{
			alert("Não é permitido apenas espaço.")
			document.frm4.ocorrencia.focus();
			return false;		
		}
	
		if (document.frm4.andamentos.value != "" && trimAll(document.frm4.andamentos.value) == "")
		{
			alert("Não é permitido apenas espaço.")
			document.frm4.andamentos.focus();
			return false;		
		}
	}

	function somente_numero(campo) {
			var digits="0123456789";
			var campo_temp;
	
			for (var i=0;i<campo.value.length;i++) {
				campo_temp=campo.value.substring(i,i+1);
				if (digits.indexOf(campo_temp)==-1) {
					campo.value = campo.value.substring(0,i);
					break;
				}	   
			}
		}

	function valida(){
		<% if not ((Session("cont_manut_param")) or (Session("adm_adm_sys"))) then %>return false;<% End If %>
		if (isNaN(frm.dias.value))
		{
			alert("Informe para este campo somente valores numéricos.")
			frm.dias.focus();	
			return false;
		}

		if (isNaN(frm.quantanda.value))
		{
			alert("Informe para este campo somente valores numéricos.")
			frm.quantanda.focus();	
			return false;
		}
	
	//	if (isNaN(frm.parado.value))
	//	{
	//		alert("Informe para este campo somente valores numéricos.")
	//		frm.parado.focus();	
	//		return false;
	//	}
		return true;
			
	}

	function HabilitaPend(recebe_provid, campo){
		if(recebe_provid){
			campo.disabled = false;
		}
		else{
			campo.disabled = true;
			campo.checked = false;
		}
	}
</script>

<script>
function valida_rtf(){
	<% if not ((Session("cont_manut_param")) or (Session("adm_adm_sys"))) then %>return false;<% End If %>
	if (document.frm_rtf.rtf.value == ""){
		alert("Preencha os campos corretamente.")
		return false;
	}
	else{
		var arq = document.frm_rtf.rtf.value;
		if (arq.indexOf(",") != -1)
		{
			alert("O arquivo a ser anexado não pode conter vírgulas no nome.")
			return false;
		}
		var tamanho = arq.length;
		var ext = arq.substr(tamanho-4, 4);
		if (ext == ".rtf"){
			document.frm_rtf.bts.disabled=true;
			return true;
		}
		else{
			alert("Só são permitidos arquivos do tipo RTF")
			return false;
		}
	}
	
	return true;
}

function valida_rtf2(){
	<% if not ((Session("cont_manut_param")) or (Session("adm_adm_sys"))) then %>return false;<% End If %>
	if (document.frm_rtf2.rtf.value == ""){
		alert("Preencha os campos corretamente.")
		return false;
	}
	else{
		var arq = document.frm_rtf2.rtf.value;
		if (arq.indexOf(",") != -1)
		{
			alert("O arquivo a ser anexado não pode conter vírgulas no nome.")
			return false;
		}
		var tamanho = arq.length;
		var ext = arq.substr(tamanho-4, 4);
		if (ext == ".rtf"){
			document.frm_rtf2.bts.disabled=true;
			return true;
		}
		else{
			alert("Só são permitidos arquivos do tipo RTF")
			return false;
		}
	}
	
	return true;
}


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
	
function mostra_proc()
		{
		MM_showHideLayers('exclui_procx','','show');
		}

function fecha_proc()
		{
		MM_showHideLayers('exclui_procx','','hide');
		}	

</script>
