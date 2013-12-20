<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn_webseek.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<!--#include file='../include/Db_open_webseek_teste.asp'-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<!--#include file='../include/db_open_apol.asp'-->

<LINK href="style.css" rel=STYLESHEET title=StyleSheet>
<%
Dim mem_carta, arquivo
DIM telefone_contato_principal
DIM telefone_endereco_principal
DIM fax_endereco_principal
DIM caixa_postal

campo = ""

if idioma = "portugues" then
	idioma_carta = "PT"
elseif idioma = "ingles" then
	idioma_carta = "EN"
else
	idioma_carta = "PT"
end if

if request.querystring("origem") = "M" then

	campo = "comunicacao"

	sql = "SELECT "&campo&" as carta FROM Parametros WHERE usuario = '"&session("vinculado")&"'"
	set rst = db.execute(sql)
	
	id_processo = request.querystring("id_processo")%>
	
	<!--#include file="carta_dados.asp"-->

	<%
	if outrapartex = "" then
		outraparte_carta = "Outra Parte não cadastrado"
	else
		outraparte_carta = mid(outrapartex,4,len(outrapartex))
	end if

	if clientex = "" then
		cliente_carta = "Cliente não cadastrado"
		contato_carta = "Cliente não cadastrado"
	 	logradouro_carta = ""
		bairro_carta = ""
		cidade_carta =  ""
		estado_carta = ""
		cep_carta = ""

		telefone_contato_principal = ""
		telefone_endereco_principal = ""
		fax_endereco_principal = ""
		caixa_postal = ""
%>
		<!--#include file="carta_cliente_nulo.asp"-->
	<% Else%>	
	
	<%	
'		sql = "SELECT DISTINCT APOL.dbo.Envolvidos.apelido, APOL.dbo.Endereco_Env.logradouro, APOL.dbo.Endereco_Env.bairro, APOL.dbo.Endereco_Env.cidade, "&_
'		" APOL.dbo.Endereco_Env.estado, APOL.dbo.Endereco_Env.cep, APOL.dbo.Envolvidos.id, APOL.dbo.Contato_Env.nome "&_
'		" FROM TabCliCont LEFT OUTER JOIN "&_
'		" APOL.dbo.Envolvidos ON TabCliCont.envolvido = APOL.dbo.Envolvidos.id LEFT OUTER JOIN "&_
'		" APOL.dbo.Endereco_Env ON APOL.dbo.Endereco_Env.id_env = APOL.dbo.Envolvidos.id LEFT OUTER JOIN "&_
'		" APOL.dbo.Contato_Env ON APOL.dbo.Contato_Env.id_env = APOL.dbo.Envolvidos.id "&_
'		" WHERE (TabCliCont.usuario = 'loback') AND (TabCliCont.codigo IN ("&tplic(1,mid(clientex,1,len(clientex)-1))&")) AND (APOL.dbo.Endereco_Env.end_corr = 1) AND  "&_
'		" (APOL.dbo.Contato_Env.principal = 1)"

	sql = "SELECT DISTINCT " & _
	"  apol.dbo.Envolvidos.id " & _
	", apol.dbo.Envolvidos.apelido " & _
	", apol.dbo.Envolvidos.razao " & _
	", apol.dbo.Endereco_Env.logradouro " & _
	", apol.dbo.Endereco_Env.bairro "&_
	", apol.dbo.Endereco_Env.cidade " & _
	", apol.dbo.Endereco_Env.estado " & _
	", apol.dbo.Endereco_Env.cep " & _
	", COALESCE(apol.dbo.Endereco_Env.tel, ' ') telefonePrincipal " & _
	", COALESCE(apol.dbo.Endereco_Env.fax, ' ') faxPrincipal " & _
	", COALESCE(apol.dbo.Envolvidos.cxpostal, ' ') caixaPostal " & _
	", apol.dbo.Envolvidos.id " & _
	", apol.dbo.Endereco_Env.end_corr " & _
	", pais = (CASE WHEN apol.dbo.Endereco_Env.pais <> '' THEN (SELECT pais FROM apol.dbo.pais_iso_br WHERE ISO_code = apol.dbo.Endereco_Env.pais) END) " & _
	", apol.dbo.Envolvidos.pasta " & _
	" FROM TabCliCont " & _
	" LEFT OUTER JOIN apol.dbo.Envolvidos ON TabCliCont.envolvido = apol.dbo.Envolvidos.id " & _
	" LEFT OUTER JOIN apol.dbo.Endereco_Env ON apol.dbo.Endereco_Env.id_env = apol.dbo.Envolvidos.id " & _
	" WHERE (TabCliCont.usuario = '"&session("vinculado")&"') " & _
	" AND (TabCliCont.codigo IN ("&tplic(1,mid(clientex,1,len(clientex)-1))&")) " & _
	" AND (apol.dbo.Endereco_Env.end_corr = 1) " & _
	" AND apol.dbo.Endereco_Env.modulo_recebe IN (0,3)"

	'response.write sql:Response.end
	
		set rst_clix = db.execute(sql)

		if rst_clix.eof then
			cliente_carta = "Cliente não cadastrado"
			contato1_carta = "Cliente não cadastrado"
		else

		cont = 0
		
		mem_carta_db = rst("carta")
		var_processo = "sim"
		var_cliente = "sim"
		dim arr_cliente()
		do while not rst_clix.eof

			cont = cont +1
			
			cliente_carta =  rst_clix("razao")
			pasta = rst_clix("pasta")
			redim preserve arr_cliente(cont)
			arr_cliente(cont) = rst_clix("apelido")

			'Variável para o campo "Telefone" no cadastro do Endereço Principal do envolvido.
			telefone_endereco_principal = rst_clix("telefonePrincipal")
			'Variável para o campo "Fax" no cadastro do Endereço Principal do envolvido.
			fax_endereco_principal = rst_clix("faxPrincipal")
			'Variável para o campo "Caixa Postal" no cadastro do envolvido.
			caixa_postal = rst_clix("caixaPostal")

			sql = "SELECT " & _
			"  Contato_Env.nome " & _
			", Contato_Env.principal " & _
			", Contato_Env.email " & _
			", COALESCE(Contato_Env.telefone, ' ') telefoneContatoPrincipal " & _
			" FROM Contato_Env " & _
			" LEFT OUTER JOIN Envolvidos ON Contato_Env.id_env = Envolvidos.id " & _
			" WHERE Contato_Env.id_env = '"&rst_clix("id")&"' " & _
			"  AND (Contato_Env.principal = 1) " & _
			"  AND Contato_Env.modulo_recebe IN (0,3) " & _
			"  AND (Envolvidos.usuario = '"&session("vinculado")&"')"

			set rst_cont = db_apol.execute(sql)
			
			if not rst_cont.eof then
				contato_carta = rst_cont("nome")
				email = rst_cont("email")

				'Variável para o campo "Telefone" no cadastro do Contato Principal do envolvido.
				telefone_contato_principal = rst_cont("telefoneContatoPrincipal")
			else	
				contato_carta = ""
				telefone_contato_principal = ""
			end if

			
		 	logradouro_carta = rst_clix("logradouro"):if isnull(logradouro_carta) or isempty(logradouro_carta) or len(trim(logradouro_carta)) = 0 then logradouro_carta = " "
			bairro_carta = rst_clix("bairro"):if isnull(bairro_carta) or isempty(bairro_carta) or len(trim(bairro_carta)) = 0 then bairro_carta = " "
			cidade_carta = rst_clix("cidade"):if isnull(cidade_carta) or isempty(cidade_carta) or len(trim(cidade_carta)) = 0 then cidade_carta = " "
			estado_carta = rst_clix("estado"):if isnull(estado_carta) or isempty(estado_carta) or len(trim(estado_carta)) = 0 then estado_carta = " "
			cep_carta = rst_clix("cep"):if isnull(cep_carta) or isempty(cep_carta) or len(trim(cep_carta)) = 0 then cep_carta = " "
			pais = rst_clix("pais"):if isnull(pais) or isempty(pais) or len(trim(pais)) = 0 then pais = " "
			
			'-------------------------MESCLAGEM------------------------------------
			%><!--#include file="mem_carta.asp"--><%
			'----------------------------------------------------------------------

			str_arquivo = campo&session("vinculado")&id_processo&cont&".rtf"

			a = cria_arquivo(str_arquivo,mem_carta)

		rst_clix.movenext
		loop


		end if	

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
	<table  width="100%" class=preto11 border="0" cellspacing="2" cellpadding="3">
			<tr class="preto11">
				<td align=center>
			<%zz = 1
			while not zz > cont
				zz = zz+1
			wend%>

			<%IF zz > 1 THEN%>
				<b><font color=red>Carta gerada com sucesso.</b>	
				<br><br>
			<%END IF%>	
							

			<%i = 1
			while not i > cont%>	
			<a class="preto11" onclick="NewWindow(this.href,'mywin','450','450','yes','center');return false;" onfocus="this.blur()" href="cartas/<%=campo&session("vinculado")&request.querystring("id_processo")&i&".rtf"%>">Visualizar arquivo (cliente <%=arr_cliente(i)%>)</a></font></b><br>
			<%
			i = i+1
			wend%>
			</tr>
	</table>	

			<%'IF I = 1 THEN%>
				<!--<font class="preto11">Não existe endereço de correspondência cadastrado para nenhum cliente deste processo.</font>-->
			<%'END IF%>		
	
	<% End If %>
<% End If %>	