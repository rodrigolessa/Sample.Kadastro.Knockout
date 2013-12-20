<%
if request("id") = "" then
	%>
	<script>window.close()</script>
	<%
	response.end
end if
%>
<% lista_pg = "PG-P06" %>
<!--#include file="../include/funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="db_open.asp"-->
<!--#include file="../usuario_logado.asp"-->
<html>
<head>
	<title>Vinculação de Registros - Observação</title>
	<%
	if request("modulo") = "" or ucase(request("modulo")) = "M" then%>
		<link HREF="../style.css" type="text/css" REL="STYLESHEET">
	<%elseif ucase(request("modulo")) = "P" then%>
			<link HREF="../patente/style.css" type="text/css" REL="STYLESHEET">
	<%elseif ucase(request("modulo")) = "V" then%>
			<link HREF="../contrato/style.css" type="text/css" REL="STYLESHEET">
	<% Else %>
			<link HREF="style.css" type="text/css" REL="STYLESHEET">
	<% End If %>
	<script language="javascript" src="valida.js"></script>
	<script language="JavaScript" src="../include/funcoes.js"></script>
	<script language="JavaScript" src="../include/jquery-1.3.1.js" type="text/javascript"></script>
	
	<script type="text/javascript">
	
	jQuery.noConflict();
	
	var ns4 = (document.layers)? true:false;
	var ie4 = (document.all)? true:false;
	function escrevelyr(id_div,text) {
		if (ns4) {
			var lyr = document.layers[id].document
			lyr.open()
			lyr.write(text)
			lyr.close()
		}
		else if (ie4) document.all[id_div].innerHTML = text
		else document.getElementById(id_div).innerHTML = text
	}
	
	var ns6=document.getElementById&&!document.all
	
	function restrictinput(maxlength,e,placeholder){
	if (window.event&&event.srcElement.value.length>=maxlength)
	return false
	else if (e.target&&e.target==eval(placeholder)&&e.target.value.length>=maxlength){
	var pressedkey=/[a-zA-Z0-9\.\,\/]/ //detect alphanumeric keys
	if (pressedkey.test(String.fromCharCode(e.which)))
	e.stopPropagation()
	}
	}
	
	function countlimit(maxlength,e,placeholder,nome){
	var theform=eval(placeholder)
	var lengthleft=maxlength-theform.value.length
	var placeholderobj=document.all? document.all[placeholder] : document.getElementById(placeholder)
	if (window.event||e.target&&e.target==eval(placeholder)){
	if (lengthleft<0)
	theform.value=theform.value.substring(0,maxlength)
	//placeholderobj.innerHTML=lengthleft
	escrevelyr(nome,lengthleft);
	}
	}
	
	var primeira = 1;
	
	function displaylimit(thename, theid, thelimit){
	var theform=theid!=""? document.getElementById(theid) : thename
	if (primeira == 1){
		var limit_text='<b><span id="'+thename+'">'+(thelimit-diminui)+'</span></b> caracteres restantes até o limite.'
	}
	else{
		var limit_text='<b><span id="'+thename+'">'+thelimit+'</span></b> caracteres restantes até o limite.'
	}
	var prim = 0;
	if (document.all||ns6)
	document.write(limit_text)
	if (document.all){
	eval(theform).onkeypress=function(){ return restrictinput(thelimit,event,theform)}
	eval(theform).onkeyup=function(){ countlimit(thelimit,event,theform,thename)}
	}
	else if (ns6){
	document.body.addEventListener('keypress', function(event) { restrictinput(thelimit,event,theform) }, true); 
	document.body.addEventListener('keyup', function(event) { countlimit(thelimit,event,theform) }, true); 
	}
	}	
	
	function valida()
	{
	
	if (document.frm.obs.value.length > 200)
	{
		alert("O campo Obs excedeu a quantidade limite de 200 caracteres.");
		document.frm.obs.focus();
		return false;
	}	 	
	
	/*
	if (document.frm.obs.value == "")
	{
		alert("Digite uma observação para este contrato vinculado.")
		frm.obs.focus();
		return false;
	}
	*/
			
	document.frm.bts.disabled = true;
	return true;
	}		
	
</script>
</head>

<body leftmargin="0" topmargin="0"  class="preto11" bgcolor="#efefef">
<table align="center" class="preto11" width="100%">
<tr>
	<td bgcolor="#FFFFFF">
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
<tr>
	<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
	<td height="16" valign="middle" class="titulo">&nbsp;Vincula&nbsp;Processo&nbsp;&nbsp;</td>
	<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
	<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
</tr>
</table>
	</td>
</tr>
</table>
<%
sql = "SELECT * FROM TabVincProc WHERE codigo = '"&tplic(0,request("id"))&"'"
set rsv = db.execute(sql) 
%>
<table align="left" class="preto11" width="100%" border="0">
<form action="vinculados_edita.asp" method="get" name="frm" onsubmit="return valida()">
<input type="hidden" name="id" value="<%= request("id") %>">
<input type="hidden" name="processo" value="<%= request("processo") %>">
<input type="hidden" name="janela" value="">
<input type="hidden" name="modulo_vinculado" value="<%= request("modulo_vinculado") %>">
<input type="hidden" name="vinculado" value="<%= request("vinculado") %>">
<% If ucase(rsv("tipo")) = "C" then %>
<tr bgcolor="#efefef"><td align="left" colspan="4"><input type="checkbox" name="apenso" value="S"<% If ucase(rsv("apenso")) = "S" then %> checked<% End If %>>Apenso</td></tr>
<% End If %>
<tr bgcolor="#efefef" align="left">
<td align="left" width="1%">&nbsp;&nbsp;Obs:&nbsp;</td>
<td align="left" width="63%"><textarea class="cfrm" name="obs" id="obs" rows="5" cols="50" style="width:410"><%=rsv("obs")%></textarea><br>
<script>
var diminui = <%= len(rsv("obs")) %>;
displaylimit("id9","obs",200);
</script>
</td>
</tr>
<tr bgcolor="#efefef"><td align="center" colspan="4"><input type="submit" name="bts" class="cfrm" value="Gravar"></td></tr>
</form>
</table>
<script>
	limitaCampo('bts','obs');
</script>
</body>
</html>
