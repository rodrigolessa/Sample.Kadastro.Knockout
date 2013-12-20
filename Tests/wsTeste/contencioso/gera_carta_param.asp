<!--#include file="../include/funcoes.asp"-->
<!--#include file="db_open.asp"-->
<!--#include file="../include/conn.asp"-->

<LINK href="style.css" rel=STYLESHEET title=StyleSheet>
<%
Dim mem_carta, arquivo

'campo = ""
'if request.querystring("origem") = "M" then
'	campo = "comunicacao"
'else
'	campo = "cobranca"
'end if

campo = "comunicacao"

sql = "SELECT "&tplic(1,campo)&" as carta FROM Parametros WHERE usuario = '"&session("vinculado")&"'"
set rst = db.execute(sql)

'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Pega dados do escritorio
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	sql = "select empresa from usuarios_apol.dbo.usuario where nomeusu = '"&session("vinculado")&"'"
	set rst_env = db.execute(sql)
	if rst_env.eof then
		response.write "Não foi possível obter o nome do Escritório"
		response.end
	end if

'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Pega dados do Cliente
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	'sql = "select razao, contato1, logradouro1, bairro1, cidade1, estado1, cep1, end_corr1, logradouro2, bairro2, cidade2, estado2, cep2, end_corr2 from processos, envolvidos where processos.processo = '"&request.querystring("processo_proprio")&"' and processos.usuario = '"&session("vinculado")&"' and processos.cliente = envolvidos.id"
	''Response.Write(sql)
	'set rst_cli = db_apol.execute(sql)
	'if rst_cli.eof then
	'	cliente = "Cliente não cadastrado"
	'	contato1 = "Cliente não cadastrado"
	''	response.write "Problemas no cadastro do Processo"
	''	response.end
	''end if
	'else
	'	cliente = rst_cli("razao")
	'	contato1 = rst_cli("contato1")
	'	if (rst_cli("end_corr2")) then
	'	 	logradouro = rst_cli("logradouro2")
	'		bairro = rst_cli("bairro2")
	'		cidade = rst_cli("cidade2")
	'		estado = rst_cli("estado2")
	'		cep = rst_cli("cep2")
	'	 else
	'	 	logradouro = rst_cli("logradouro1")
	'		bairro = rst_cli("bairro1")
	'		cidade = rst_cli("cidade1")
	'		estado = rst_cli("estado1")
	'		cep = rst_cli("cep1")
	'	 end if
	'end if
	'
	'if isnull(cliente) then
	'	cliente = ""
	'end if

'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Dados do processo
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF trim(request.querystring("id_processo")) <> "" then
	sql = "select id_processo, processo, pasta, responsavel, situacao, dt_encerra, instancia, orgao, juizo, comarca, participante, desc_det from TabProcCont where id_processo="&tplic(1,request("id_processo"))
	set rs_proc = db.execute(sql)
	if rs_proc.eof then
		response.write "processo nao encontrado"
		response.end
	end if
	processo 	= rs_proc("processo")
	
	descricao = rs_proc("desc_det")		
	if isnull(descricao) then
		descricao = ""
	end if
	
	pasta 		= rs_proc("pasta")	
	if isnull(pasta) then
		pasta = ""
	end if
	
	situacao 		= rs_proc("situacao")	
	if isnull(situacao) then
		situacao = ""
	end if
	
	dt_encerra 		= rs_proc("dt_encerra")	
	if isnull(dt_encerra) then
		dt_encerra = ""
	end if
	
	instancia 		= rs_proc("instancia")	
	if isnull(instancia) then
		instancia = ""
	end if
	
	
	if rs_proc("orgao") <> "" and not isnull(rs_proc("orgao")) then 
		set rs = db.execute("Select * from auxiliares where codigo = "&tplic(1,cint(rs_proc("orgao"))))		
		if not rs.eof then
			orgao = rs("descricao")
		else
			orgao = "não encontrado"
		end if
	end if
	
	if rs_proc("juizo") <> "" and not isnull(rs_proc("juizo")) then 
		set rs = db.execute("Select * from auxiliares where codigo = "&tplic(1,cint(rs_proc("juizo"))))		
		if not rs.eof then
			juizo = rs("descricao")
		else
			juizo = "não encontrado"
		end if
	end if
	
	if rs_proc("comarca") <> "" and not isnull(rs_proc("comarca")) then 
		set rs = db.execute("Select * from auxiliares where codigo = "&tplic(1,cint(rs_proc("comarca"))))		
		if not rs.eof then
			comarca = rs("descricao")
		else
			comarca = "não encontrado"
		end if
	end if		
	
	posicao 		= rs_proc("participante")	
	if isnull(posicao) then
		posicao = ""
	end if
	
	cliente = "Cliente: "
	set rs = conn.execute("Select c.codigo, c.processo, id, apelido from contencioso.dbo.TabProcCont p, envolvidos, contencioso.dbo.TabCliCont c where envolvidos.usuario = '"&Session("vinculado")&"' and envolvidos.tipo = 'cliente' and c.usuario = '"&Session("vinculado")&"' and c.tipo = 'cliente' and envolvidos.id = c.envolvido and c.processo = p.id_processo and p.id_processo = "&rs_proc("id_processo")&" order by apelido")
	do while not rs.eof
		cliente = cliente & "\par            " & rs("apelido")
		rs.movenext
	loop
	
	outraparte = "Outra Parte: "
	set rs = conn.execute("Select c.codigo, c.processo, id, apelido from contencioso.dbo.TabProcCont p, envolvidos, contencioso.dbo.TabCliCont c where envolvidos.usuario = '"&Session("vinculado")&"' and envolvidos.tipo = 'outraparte' and c.usuario = '"&Session("vinculado")&"' and c.tipo = 'outraparte' and envolvidos.id = c.envolvido and c.processo = p.id_processo and p.id_processo = "&rs_proc("id_processo")&" order by apelido")
	do while not rs.eof
		outraparte = outraparte & "\par            " & rs("apelido")
		rs.movenext
	loop
	
	'<<CLIENTE>>
	'<<OUTRAPARTE>>

	
end if
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Fim Processo RPI
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Mesclagem de Dados
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	mem_carta = rst("carta")	
	
'	**** Bloco com variáveis do sistema *************
	MEM_CARTA = REPLACE(MEM_CARTA,"<<PROCESSO>>",processo)
	MEM_CARTA = REPLACE(MEM_CARTA,"<<DESCRICAO>>",descricao)
	MEM_CARTA = REPLACE(MEM_CARTA,"<<PASTA>>",pasta)	
	MEM_CARTA = REPLACE(MEM_CARTA,"<<ENCERRAMENTO>>",dt_encerra)	
	MEM_CARTA = REPLACE(MEM_CARTA,"<<SITUACAO>>",SITUACAO)
	MEM_CARTA = REPLACE(MEM_CARTA,"<<INSTANCIA>>",INSTANCIA)
	MEM_CARTA = REPLACE(MEM_CARTA,"<<ORGAO>>",ORGAO)
	MEM_CARTA = REPLACE(MEM_CARTA,"<<JUIZO>>",JUIZO)
	MEM_CARTA = REPLACE(MEM_CARTA,"<<COMARCA>>",COMARCA)
	MEM_CARTA = REPLACE(MEM_CARTA,"<<POSICAO>>",replace(replace(POSICAO,"R","Réu"),"A","Autor"))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<CLIENTE>>",CLIENTE)
	MEM_CARTA = REPLACE(MEM_CARTA,"<<OUTRAPARTE>>",OUTRAPARTE)
	
	
	'MEM_CARTA = REPLACE(MEM_CARTA,"PROCESSO",processo)
	'MEM_CARTA = REPLACE(MEM_CARTA,"DESCRICAO",descricao)
	'MEM_CARTA = REPLACE(MEM_CARTA,"PASTA",pasta)
	'MEM_CARTA = REPLACE(MEM_CARTA,"RESPONSAVEL",responsavel)	
	
	mem_carta = replace(mem_carta,"<<aspas>>","'")
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Fim Mesclagem de Dados
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

str_arquivo = campo&session("vinculado")&request.querystring("processo")&".rtf"
'response.write mem_carta

cria_arquivo(str_arquivo)


Function cria_arquivo(arquivo)
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
  ObjStream.WriteLine mem_carta		
	ObjStream.close 
	Set ObjStream = nothing
End Function

%>
<center>
<title>Apol - Marcas - Arquivo gerado</title>
<script language="JavaScript1.2">
<!--
var win=null;
function NewWindow(mypage,myname,w,h,scroll,pos){
if(pos=="random"){LeftPosition=(screen.width)?Math.floor(Math.random()*(screen.width-w)):100;TopPosition=(screen.height)?Math.floor(Math.random()*((screen.height-h)-75)):100;}
if(pos=="center"){LeftPosition=(screen.width)?(screen.width-w)/2:100;TopPosition=(screen.height)?(screen.height-h)/2:100;}
else if((pos!="center" && pos!="random") || pos==null){LeftPosition=0;TopPosition=20}
settings='width='+w+',height='+h+',top='+TopPosition+',left='+LeftPosition+',scrollbars='+scroll+',location=no,directories=no,status=yes,menubar=no,toolbar=yes,resizable=yes';
win=window.open(mypage,myname,settings);
window.close();
}
// -->
</script>
<body bgcolor="#EFEFEF">
<table  width="70%" class=preto11 border="0" cellspacing="2" cellpadding="3">
		<tr class="preto11">
			<td align=center>
			<b><font color=red>Carta gerada com sucesso.			
			<br><br>
		<a class="preto11"onclick="NewWindow(this.href,'mywin','450','450','yes','center');return false;" onfocus="this.blur()" href="cartas/<%=campo&session("vinculado")&request.querystring("processo_colid")&request.querystring("desp")&".rtf"%>">Visualizar arquivo</a></font></b>
		</tr>
</table>