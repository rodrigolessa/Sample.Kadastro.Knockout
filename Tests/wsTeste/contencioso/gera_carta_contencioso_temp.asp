<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn_webseek.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<!--#include file='../include/Db_open_webseek_teste.asp'-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<!--#include file='../include/db_open_apol.asp'-->

<LINK href="style4.css" rel=STYLESHEET title=StyleSheet>
<%
Dim mem_carta, arquivo

campo = ""

if request.querystring("origem") = "M" then

	campo = "comunicacao"

	sql = "SELECT "&campo&" as carta FROM Parametros WHERE usuario = '"&session("vinculado")&"'"
	set rst = db.execute(sql)

	id_processo = request.querystring("id_processo")%>
	
	<!--#include file="carta_dados.asp"-->
	
	<%if clientex = "" then

		cliente_carta = "Cliente não cadastrado"
		contato1_carta = "Cliente não cadastrado"
	 	logradouro_carta = ""
		bairro_carta = ""
		cidade_carta =  ""
		estado_carta = ""
		cep_carta = ""%>
		<!--#include file="carta_cliente_nulo.asp"-->

	<% Else  %>	
	
	<%	sql = "SELECT DISTINCT Contato_Env.nome FROM Contato_Env LEFT OUTER JOIN Envolvidos ON "&_
	" Contato_Env.id_env = Envolvidos.id WHERE (Contato_Env.id_env = "&id_env&") AND "&_
	" (Envolvidos.usuario = '"&session("vinculado")&"')  AND (Contato_Env.principal = 1)"
	set rs_cont = conn.execute(sql)
	'response.write sql

	If not rs_cont.eof then
		contato_carta =  rs_cont("nome")
	Else
		contato_carta =  ""
	End If

		cliente_carta =  apelido

		mem_carta_db = rst("carta")
		var_processo = "sim"
		var_cliente = "sim"

		'-------------------------MESCLAGEM------------------------------------
		%><!--#include file="mem_carta.asp"--><%
		'----------------------------------------------------------------------

		str_arquivo = campo&session("vinculado")&id_processo&cont&".rtf"

		a = cria_arquivo(str_arquivo,mem_carta)

	Function cria_arquivo(arquivo,mem_cartax)
		arquivo = server.mappath("cartas")&"\"&arquivo
	
		Const forReading = 1, forWriting = 2, forAppending = 8
		Const TriDef = -2, TriTrue = -1, TriFalse = 0
		Dim fso, msg, f
	  
		Set fso = CreateObject("Scripting.FileSystemObject")              
		If not fso.FileExists(arquivo) then
	  	Set ObjArquivo = fso.CreateTextFile(arquivo, True)  	
	  	ObjArquivo.close 
			Set ObjArquivo = nothing  
	  	End if
	  	Set ObjArquivo = fso.GetFile(arquivo)
	  	Set objStream = ObjArquivo.OpenAsTextStream(forWriting,TriDef) 

	  	ObjStream.WriteLine mem_cartax

		ObjStream.close 
		Set ObjStream = nothing
	End Function

%>
	
	<center>
	<title>APOL Jurídico - Arquivo gerado</title>
	<script language="JavaScript1.2">
	<!--
	var win=null;
	function NewWindow(mypage,myname,w,h,scroll,pos){
	if(pos=="random"){LeftPosition=(screen.width)?Math.floor(Math.random()*(screen.width-w)):100;TopPosition=(screen.height)?Math.floor(Math.random()*((screen.height-h)-75)):100;}
	if(pos=="center"){LeftPosition=(screen.width)?(screen.width-w)/2:100;TopPosition=(screen.height)?(screen.height-h)/2:100;}
	else if((pos!="center" && pos!="random") || pos==null){LeftPosition=0;TopPosition=20}
	settings='width='+w+',height='+h+',top='+TopPosition+',left='+LeftPosition+',scrollbars='+scroll+',location=no,directories=no,status=yes,menubar=no,toolbar=yes,resizable=yes';
	win=window.open(mypage,myname,settings);
//	window.close();
	}
	// -->
	</script>
	<body bgcolor="#EFEFEF">
	<table  width="70%" class=preto12 border="0" cellspacing="2" cellpadding="3">
			<tr class="preto12">
				<td align=center>
				<b><font color=red>Carta gerada com sucesso.			
				<br><br>

			<a class="preto12" onclick="NewWindow(this.href,'mywin','450','450','yes','center');return false;" onfocus="this.blur()" href="cartas/<%=campo&session("vinculado")&request.querystring("id_processo")&i&".rtf"%>">Visualizar arquivo</a></font></b><br>
			</tr>
	</table>	
	
	<% End If %>
<% End If %>	