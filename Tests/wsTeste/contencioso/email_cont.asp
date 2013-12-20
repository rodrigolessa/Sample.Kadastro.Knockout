<% Server.ScriptTimeout = 60 
lista_pg = "PG-P01" %>
<!--#include file="db_open.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/funcoes.asp"-->
<!--#include file='../usuario_logado.asp'-->


<html>
<header>
<title>Envio de email</title>
<link rel="STYLESHEET" type="text/css" href="style.css"> 
<script language="JavaScript" src="../include/funcoes.js"></script>
<script type="text/javascript">
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


function countlimit(maxlength,e,placeholder){
var theform=eval(placeholder)
var lengthleft=maxlength-theform.value.length
var placeholderobj=document.all? document.all[placeholder] : document.getElementById(placeholder)
if (window.event||e.target&&e.target==eval(placeholder)){
if (lengthleft<0)
theform.value=theform.value.substring(0,maxlength)
placeholderobj.innerHTML=lengthleft
}
}

function displaylimit(thename, theid, thelimit){
var theform=theid!=""? document.getElementById(theid) : thename
var limit_text='<b><span id="'+theform.toString()+'">'+thelimit+'</span></b> caracteres restantes até o limite.'
if (document.all||ns6)
document.write(limit_text)
if (document.all){
eval(theform).onkeypress=function(){ return restrictinput(thelimit,event,theform)}
eval(theform).onkeyup=function(){ countlimit(thelimit,event,theform)}
}
else if (ns6){
document.body.addEventListener('keypress', function(event) { restrictinput(thelimit,event,theform) }, true); 
document.body.addEventListener('keyup', function(event) { countlimit(thelimit,event,theform) }, true); 
}
}

function valida(){
	var vazio = true;
	if (document.frm.email_usu.selectedIndex != 0){
		vazio = false;
	}
	
	if (total_env == 1){
		if (document.frm.email_envolvido.checked){
			vazio = false;
		}
	}else{
		for(var i=0;i<total_env;i++){
			if (document.frm.email_envolvido[i].checked){
				vazio = false;
			}
		}
	}
	
	if (document.frm.email_externo.value != ''){
		if (doEmail(document.frm.email_externo.value, 1)){
			vazio = false;
		}else{
			alert('Preencha o email corretamente.');
			document.frm.email_externo.focus();
			return false;
		}
	}
	
	if (vazio){
		alert('Escolha pelo menos um destinatário para o email.');
		return false;
	}else{
		document.frm.bts.disabled = true;
		return true;
	}
	
	alert("E-mail enviado com sucesso! ")
	window.close();
}

function troca(env){
	var crossobj=document.all? eval("document.all.div_"+env) : document.getElementById("div_"+env)
	var divc = eval("!"+env)
	if (divc) {
		crossobj.style.color = 'black';
	}
	else{
		crossobj.style.color = 'gray';
	}
	eval(env+' = divc');
}

function limpa(){
	var crossobj
	for (i=1;i<=total_env+2;i++){
		crossobj=document.all? eval("document.all.div_env"+i) : document.getElementById("div_env"+i);
		eval("env"+i+" = false;");
		crossobj.style.color = 'gray';
	}
	document.frm.reset();
}
</script>
</header>		
<%
sqlC = "select andamentos from parametros where usuario = '" & Session("vinculado") & "'"
set rsC = db.execute(sqlC)
if not rsC.EOF then
	andamentos_C = rsC("andamentos")
else
	andamentos_C = "Andamentos"
end if%>

<body>
<% if Request("local") = "" then %>
<table width='100%' class='preto11' border=0 cellpadding=2 cellspacing=0 bgcolor='#efefef'>
<tr bgcolor='#ffffff'>
	<td align=center colspan="7">
	<table cellpadding='0' cellspacing='0' border='0' width='100%'>
		<tr>
		<td height='16' valign='middle'>&nbsp;<img src='imagem/tit_le.gif' width='19' height='18'>&nbsp;</td>
		<td height='16' valign='middle' class="titulo">&nbsp;Envio&nbsp;de&nbsp;Informações&nbsp;do&nbsp;Processo&nbsp;Via&nbsp;Email&nbsp;&nbsp;</td>
		<td height='16' width='100%'><img src="imagem/tit_ld.gif" width='100%' height='18' border='0'></td>
		<td height='16' valign='middle'><img src='imagem/tit_fim.gif' width='21' height='16'></td>
		</tr>
	</table>
	</td>
</tr>
<% processo = request.querystring("id_processo") %>
<form action="email_cont.asp?local=envio" method="post" name="frm"  onsubmit="return valida()">
<input type="hidden" name="id_processo" value="<%=request.querystring("id_processo")%>">

<tr>
<td bgcolor='#efefef'>

<table class='preto11' bgcolor='#efefef' align='left' cellpadding='0' cellspacing='0' border=0>

<tr>
	<td>
	
<table class='preto11' bgcolor='#efefef' align='left' cellpadding='0' cellspacing='0' border=0>
<tr>
	<td bgcolor='#efefef'>&nbsp;</td>
	<td bgcolor='#efefef'>&nbsp;</td>
</tr>
<tr>
	<td bgcolor='#efefef' width="25%"><b>Responsável:&nbsp;</b></td>
	<td  width="74%"><select class="cfrm" name="email_usu" size="1" style="width:333">
	<option value="" SELECTED></option>
	<%
	sql = "SELECT responsavel FROM TabProcCont WHERE id_processo = '"&tplic(0,processo)&"' and usuario = '"&Session("vinculado")&"'"
	set rs = db.execute(sql)
	if not rs.eof then
		resp = rs("responsavel")
	else
		tipo = "WS"
	end if
	set rs = conn.execute("SELECT id, nome, email FROM Responsaveis WHERE (tipo <> 'cliente') AND (usuario = '" &Session("vinculado")& "') AND (email <> '') ORDER BY nome")
	while not rs.eof
	%>
	<option value="<%= rs("email") %>"<% If trim(resp) = trim(rs("id"))then %> style="color:blue"<% End If %>><%= rs("nome") %><% If resp = rs("id") then %> (Responsável)<% End If %></option>
	<%
	rs.movenext
	wend
	%>
	</select>
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td bgcolor='#efefef'><b>Envolvidos:&nbsp;</b></td>
	<td>
	<%
	if tipo <> "WS" then
	sql = "SELECT ce.email, e.apelido, em.envolvido, ce.nome "&_
	"FROM TabCliCont em INNER JOIN "&_
	"apol.dbo.Envolvidos e ON em.envolvido = e.id AND em.usuario = e.usuario INNER JOIN "&_
	"apol.dbo.Contato_Env ce ON e.id = ce.id_env INNER JOIN "&_
	"apol.dbo.Tipo_Envolvido te ON em.tipo_env = te.id_tipo_env AND em.usuario = te.usuario "&_
	"WHERE (em.processo = '"&tplic(0,processo)&"') AND (em.usuario = '"&session("vinculado")&"') AND (ce.email <> '') AND (ce.email is not null) "&_
	"ORDER BY e.apelido"
	
	set rstp = db.execute(sql)
	cont = 1
	if not rstp.eof then
		while not rstp.eof
			If not isnull(rstp("envolvido")) OR rstp("envolvido") <> "" then %>
			<% email = rstp("email") %>
			<div id="div_env<%= cont %>" class="preto11" style="color:gray"><input type="checkbox" name="email_envolvido" onclick="troca('env<%= cont %>')" value="<%= email %>"><B><%= rstp("apelido") %></B> / <%= rstp("nome") %></div>
			<script>var env<%= cont %> = false;</script>
			<% Else %>
				<% response.write "Nenhum" %>
			<% End If
			cont = cont+1
			rstp.movenext
		wend
		%>
	<% Else %>
		<input type="hidden" name="email_envolvido" value="">
		<% response.write "Nenhum" %>
	<% End If %>
	<% Else %>
		<input type="hidden" name="email_envolvido" value="">
		<% response.write "Nenhum" %>
	<% End If %>
	<script>var total_env = <%= cont-1 %>;</script>
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td bgcolor='#efefef'><b>E-mail externo:&nbsp;</b></td>
	<td><input class="cfrm" type="text" name="email_externo" style="width:333" maxlength="80"></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>
<% if tipo <> "WS" then %>
<tr>
	<td><b>Envia:</b></td>
	<td><div id="div_env<%= cont %>" class="preto11" style="color:gray"><input type="checkbox" name="provid" onclick="troca('env<%= cont %>')" value="1"><B>Providências</B></div>
	<script>var env<%= cont %> = false;</script>
	<% cont = cont+1%>
	<div id="div_env<%= cont %>" class="preto11" style="color:gray"><input type="checkbox" name="ocor" onclick="troca('env<%= cont %>')" value="1"><B><%= ocorrencia_c %></B></div>
	<script>var env<%= cont %> = false;</script>
	<% cont = cont+1%>
	<div id="div_env<%= cont %>" class="preto11" style="color:gray"><input type="checkbox" name="anda" onclick="troca('env<%= cont %>')" value="1"><B><%= request("andamentos_c") %></B></div>
	<script>var env<%= cont %> = false;</script>
	<%cont = cont+1%>
	


	</td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>
<% End If %>
<%
set rs = db.execute("SELECT processo FROM TabProcCont WHERE id_processo = "&tplic(0,processo))
nproc = rs("processo")
%>
<tr>
	<td><b>Assunto:</b></td>
	<td><input class="cfrm" type="text" name="subject" style="width:333" maxlength="100" value="APOL: Informações do Processo <%= nproc %>"></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td bgcolor='#efefef'><b>Observação:&nbsp;</b></td>
	<td><textarea name="obs" rows=5 cols=52 class=cfrm></textarea><BR>
	<script>
	displaylimit("","obs",1000)
	</script>
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
</tr>

</table>

</td>
</tr>
<tr>
<td colspan="2" align='center'><input type="submit" class="cfrm" name="bts" value="Enviar">&nbsp;<input type="button" onclick="limpa()" class="cfrm" value="Limpar"></td>
</tr>
</form>
<tr>
	<td colspan="2">&nbsp;</td>
</tr>
</table>
<%
else

	Set fso = CreateObject("Scripting.FileSystemObject")
	diremail = Server.MapPath("/apol/automatico/email_proc.htm")
	Set f = fso.OpenTextFile(diremail, 1)
	ReadAllTextFile =  f.ReadAll
	
	logo_ld = "<IMG height=""43"" src=""http://www.ldsoft.com.br/img_email/simboloLD.gif"" width=""270"">"
	
	SQL = "SELECT Clientes.dbo.cliente.razao, logotipo FROM usuario "&_
		"LEFT JOIN Clientes.dbo.cliente ON cod_cli_scli = LTrim(RTrim(Clientes.dbo.cliente.cod_cli)) "&_
		"WHERE vinculado = '" & session("vinculado") & "' AND nomeusu = '" & session("vinculado") & "'"
	set rsy = conn_usu.execute(SQL)
	
	url = url_base()
	empresa = rsy("razao")
	logo = ""
	if rsy("logotipo") <> "" then
		logo = "<img src=""" &url& "/apol/logo_cliente/"&rsy("logotipo")&""" border=""0"">"
	end if
	ReadAllTextFile = replace(ReadAllTextFile,logo_ld,logo)
	
	Function BinaryToString(strBinary) 
	    Dim intCount, xBinaryToString 
	    xBinaryToString ="" 
	    For intCount = 1 to LenB(strBinary) 
	        xBinaryToString = xBinaryToString & chr(AscB(MidB(strBinary,intCount,1))) 
	    Next
	    BinaryToString = xBinaryToString
	End Function
	
	Randomize
	nrnd = Int((99999999 - 11111111 + 1) * rnd + 11111111)
	
	Set xml = Server.CreateObject("MSXML2.ServerXMLHTTP")
	xvLink = url & "/apol/contencioso/processo.asp?modulo=C&imprimir=S&env_email=S&id_processo="&Request("id_processo")&"&rnd="&nrnd&"&provid=" &Request("provid")& "&ocor=" &Request("ocor")& "&anda=" &Request("anda")& "&codauto="&session("codauto")&"&nomeusu="&session("nomeusu")&"&codigo_vinculado="&session("codigo_vinculado")
	
	xml.setOption 2, 13056
	xml.Open "GET", xvLink, False
	xml.Send
	body=BinaryToString(xml.responseBody)
	set xml = Nothing
	
	body = "<table border=""0"" bgcolor=""#ffffff"" cellpadding=""0"" cellspacing=""0"" width=""100%""><tr><td>" & body & "</td></tr></table>"
	if empresa <> "" and len(empresa) > 0 then
		body = body & "<br><table width=""100%"" border=""0""><tr><td style=""font-family: verdana; font-size: 10px; color: black;"">O respectivo e-mail foi enviado por " & empresa & "</td></tr></table>"
	end if
	body_email = replace(ReadAllTextFile,"[email]", body)
	
	servidor = request.servervariables("server_name")
	stitulo = ""
	if lcase(servidor) = "terra" OR lcase(servidor) = "marte" then
		stitulo = " - "&ucase(servidor)
	end if
	
	body_email = replace(body_email," background=""imagem"," background="""&url&"/apol/contencioso/imagem")
	body_email = replace(body_email,"<img src=""imagem","<img src="""&url&"/apol/contencioso/imagem")
	body_email = replace(body_email,"<img src=""..","<img src="""&url&"/apol")
	body_email = replace(body_email,"<LINK href=""","<LINK href="""&url&"/apol/contencioso/")
	
	if Request("obs") = "" then
		body_email = replace(body_email,"[obs_email]","")
	else
		body_email = replace(body_email,"[obs_email]","<span style=""font: 11px Verdana;""><b>Observação:</b> " & Request("obs")&"</span><BR><br>")
	end if
	
	emails = Request("email_usu")
	
	if Request("email_envolvido") <> "" then
		if emails <> "" then
			emails = emails & ";" & replace(Request("email_envolvido"),", ",";")
		else
			emails = replace(Request("email_envolvido"),", ",";")
		end if
	end if
	
	
	if Request("email_externo") <> "" then
		if emails <> "" then
			emails = emails & ";" & replace(Request("email_externo"),"'","")
		else
			emails = replace(Request("email_externo"),"'","")
		end if
	end if
	
	'Response.Write(xvLink)
	'Response.Write(body_email)
	'Response.end
	
	send_email_3 "C", emails, "apol@LDsoft.com.br", Request("subject"), body_email
	
	'ok = grava_log_v(session("nomeusu"),"E-MAIL","processo","Nº "&codigo&" / E-mail para: "&emails)
	%>
<%End if%>
</body>
</html>