<% lista_pg = "PG-CPR" %>
<% paginacao = true %>
<% bt_imprimir = true %>
<% bt_imprimir_tipo = "post" %>
<%Session("voltar") = "javascript:history.back();"%>
<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<!--#include file='../include/Db_open_webseek_teste.asp'-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<!--#include file="../include/adovbs.inc"-->

<link rel="STYLESHEET" type="text/css" href="style.css"> 
<script language="javascript" src="../include/funcoes.js"></script>
<script language="javascript" src="valida.js"></script>

<script>
ns4 = (document.layers)? true:false
ie4 = (document.all)? true:false

var objsub;

function trimAll(sString) {
	while (sString.substring(0,1) == ' '){
		sString = sString.substring(1, sString.length);
	}
	while (sString.substring(sString.length-1, sString.length) == ' '){
		sString = sString.substring(0,sString.length-1);
	}
	return sString;
}

function layerWrite(id,nestref,text) {
	if (ns4) {
		var lyr = (nestref)? eval('document.'+nestref+'.document.'+id+'.document') : document.layesers[id].document
		lyr.open()
		lyr.write(text)
		lyr.close()
	}
	else if (ie4) document.all[id].innerHTML = text
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

function mostra_exc()
		{
		MM_showHideLayers('pergunta_exc','','show');
		}

function fecha_exc()
		{
		MM_showHideLayers('pergunta_exc','','hide');
		}

function verifica_cont(){
	
	if ((trimAll(document.frm_buscacont.processocont.value) == "") && (trimAll(document.frm_buscacont.radicalcont.value) == "") && (trimAll(document.frm_buscacont.envolvidocont.value) == "")){
		alert('Preencha pelo menos um campo.');
		document.frm_buscacont.processocont.focus();
		return false;
	}
	if (trimAll(document.frm_buscacont.radicalcont.value) != ""){
		if (trimAll(document.frm_buscacont.radicalcont.value).length < 3){
			alert('Tamanho mínimo de 3 caracteres.');
			document.frm_buscacont.radicalcont.focus();
			return false;
		}
	}
	if (trimAll(document.frm_buscacont.envolvidocont.value) != ""){
		if (trimAll(document.frm_buscacont.envolvidocont.value).length < 3){
			alert('Tamanho mínimo de 3 caracteres.');
			document.frm_buscacont.envolvidocont.focus();
			return false;
		}
	}
	
	window.scroll(0,0)
	MM_showHideLayers('processando_div','','show');
	var txt_div = '<table width="100%" height="100%"><tr valign="middle"><td align="center"><img src="../imagem/processando.gif" width="201" height="60"></td></tr></table>';
	layerWrite('processando_div',null,txt_div);
	
	objsub.disabled = 'true';
	return true;
}	
</script>

<title>APOL Jurídico<% If Request("imprimir") <> "" then %> - Impressão de Informações<% End If %></title>
<!--#include file="../include/clsPesquisa.asp"-->
<%
Set pesq = new clsPesquisa
pesq.cor_titulo "#345C46"
pesq.Create "Selecionar Envolvido","Envolvido","../img_comp/","../busca_env_normal.asp","0","0"

if request("imprimir") = "S" then
	l_imp = "_p"
end if

if request("imprimir") = "" then%>	
	<!--#include file="header.asp"-->
<script>
function limpar_cont(){
	document.frm_buscacont.processocont.value = "";
	document.frm_buscacont.radicalcont.value = "";
	<%=pesq.limpa_campo_pesq("pesc_env_div", "envolvidocont") %>;
}
</script>
<div id="processando_div" style="position: absolute; top: 0px; width: 99%; left: 0px; height: 99%; visibility: hidden;"></div>
<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
<tr>
	<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
	<td height="16" valign="middle" class="titulo">&nbsp;Pesquisa&nbsp;de&nbsp;Processos&nbsp;</td>
	<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
	<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
</tr>
<tr bgcolor="#F3F3F3" class="preto11">
	<td colspan="4" align="center" height="8"><img src="imagem/1px-transp.gif" width="1" height="8" border="0"></td>
</tr>
<form name="frm_buscacont" action="consulta_main.asp" method="get" onsubmit="return verifica_cont()">
<input type="hidden" name="cria" value="1">
<tr bgcolor="#F3F3F3" class="preto11">
	<td colspan="4" align="center"><%= mostra_label("processo", "", "") %>: <input class="cfrm" type="text" name="processocont" value="<%= Request("processocont") %>" style="width:182px" maxlength="25" align="middle">&nbsp;&nbsp;
	Palavra: <input class="cfrm" type="text" name="radicalcont" value="<%= Request("radicalcont") %>" size="15" maxlength="25" align="middle">&nbsp;&nbsp;
	<%
	If Request("envolvidocont") <> "" then 
		set rs_cli = conn.execute("Select apelido from envolvidos where id = "&tplic(0,Request("envolvidocont")))
		if not rs_cli.eof then
			pesq.preenche_campo rs_cli("apelido"), tplic(0,Request("envolvidocont"))
		end if
	End If
	%>
	Envolvido: <% pesq.campo_pesq "pesc_env_div", "envolvidocont", "200" %>&nbsp;&nbsp;
	<input type="image" onclick="objsub=this" alt="Pesquisar" src="imagem/botao_busca.gif" align="middle">&nbsp;&nbsp;&nbsp;<a href="javascript: limpar_cont()"><img src="imagem/botao_limpar.gif" align="absmiddle" alt="Limpar" width="20" height="20" border="0"></a></td>
</tr>
</form>
<tr bgcolor="#F3F3F3" class="preto11">
	<td colspan="4" align="center" height="8"><img src="imagem/1px-transp.gif" width="1" height="8" border="0"></td>
</tr>
</table>

<% Else %>
	<table cellpadding="0" cellspacing="0" width="100%" border="0">	
	<tr>
		<td><%
			SQL = "select logotipo from usuario where vinculado='"&session("vinculado")&"' and nomeusu='"& session("vinculado") &"'"
			set rsy = conn_usu.execute(SQL)

			if rsy("logotipo") <> "" then
			%>
			<img src="../logo_cliente/<%=rsy("logotipo")%>" border="0">
			<% end if %></td>
		<td align="right" valign="top"><span class="preto11<%=l_imp%>"><%= now() %></span></td>
	</tr>
	</table>
<% End If %>	

<table class="preto11" bgcolor="#ffffff" width="100%">
<%
if Request("filtrar") = "ok" then
	pmarcados = replace(tplic(1,Request("pmarcados")),"#","'")
	pmarcados = replace(pmarcados,"''","','")
	pmarcados = replace(pmarcados,"_",".")
	sql_filtro = " and id_processo in (" &pmarcados& ")"
end if

if Request("filtrar1") = "ok" then
	pmarcados1 = replace(Request("pmarcados1"),"#","'")
	pmarcados1 = replace(pmarcados1,"''","','")
	pmarcados1 = replace(pmarcados1,"_",".")
	sql_filtro = " and id_processo in (" &tplic(1,pmarcados1)& ")"
end if

if request("radicalcont") <> "" then
	sql1 = sql1 & " and (( TabProcCont.desc_res like '%"&tplic(1,request("radicalcont"))&"%' or TabProcCont.desc_det like '%"&tplic(1,request("radicalcont"))&"%' or TabProcCont.obs like '%"&tplic(1,request("radicalcont"))&"%'))"
end if

if request("processocont") <> "" then
	sql1 = sql1 & " and TabProcCont.processo like '%"&tplic(1,request("processocont"))&"%'"
end if

if request("envolvidocont") <> "" then
	sql1 = sql1 & " and (APOL.dbo.Envolvidos.id = " &tplic(1,request("envolvidocont"))& ")"
end if

if request("exc") = 1 then
	session("sqlmain") = session("sqlmain")
	if isnull(session("sqlmain")) or isempty(session("sqlmain")) or len(trim(session("sqlmain"))) = 0 then
		Response.Redirect "processo.asp?modulo=C&cadproc=inclusao"
	end if
else
	sql = "SELECT DISTINCT TabProcCont.id_processo, TabProcCont.processo, TabProcCont.desc_res, TabProcCont.situacao, "&_
	" TabProcCont.pasta FROM TabProcCont LEFT OUTER JOIN "&_
	" TabCliCont ON TabProcCont.id_processo = TabCliCont.processo AND TabProcCont.id_processo = TabCliCont.processo AND "&_
    " TabProcCont.id_processo = TabCliCont.processo LEFT OUTER JOIN APOL.dbo.Envolvidos ON APOL.dbo.Envolvidos.id = TabCliCont.envolvido "&_
	" where TabProcCont.usuario = '"&session("vinculado")&"' "& sql1 & sql_filtro &" "&_
	" order by TabProcCont.processo "

	session("sqlmain") = sql
end if

if isnull(request("atual")) or request("atual")="" then
	pagAtual = 1
else
    pagAtual = cInt(right(request("atual"), 2))
end if

if request("imprimir") = "" then
	qtdReg  = 15
else
	qtdReg  = 10000
end if
set session("C_rs") = Server.CreateObject("ADODB.Recordset")
session("C_rs").CursorType     = adOpenStatic
session("C_rs").CacheSize      = qtdReg
session("C_rs").Open (session("sqlmain")), Db ,,,adCmdText

totReg = session("C_rs").recordcount

if totReg = 0 then%>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
		<tr>
			<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
			<td height="16" valign="middle" class="titulo">&nbsp;&nbsp;Resultado&nbsp;da&nbsp;Pesquisa&nbsp;&nbsp;</td>
			<td height="16" background="imagem/tit_ld.gif" width="90%">&nbsp;</td>
			<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
		</tr></table>
		<table width="100%" class="tabela<%=l_imp%>" border="0" cellspacing="2" cellpadding="3">					
		<tr bgcolor=<%=cor%>>
			<td width="100%" align="center" colspan=3><b>Não foram encontrados processos que atendam às condições estabelecidas</b></td>
		</tr>
		</table>
	<%
	response.end
end if

session("C_rs").PageSize = qtdReg

if cInt(pagAtual) > session("C_rs").PageCount then
	pagAtual = session("C_rs").PageCount
end if

session("C_rs").AbsolutePage = cInt(pagAtual)

Current_page = cInt(pagAtual)
%>		

<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
		<form action=consulta_main.asp name=frm method=post onsubmit="return valida()" >				
			<input type="hidden" name="vindo" value="1" > 
			<input type="hidden" name="direcao" value="" > 			
			<input type="hidden" name="filtrar" value="" >			
			<input type="hidden" name="atual" value="<%=pagAtual%>" >			
			<input type="hidden" name="pg" value="<%=pagAtual%>" >			
			<input type="hidden" name="resultado" value="S" >			
			<input type="hidden" name="pmarcados" value="<%=request("pmarcados")%>">
			<input type="hidden" name="processocont" value="<%=request("processocont")%>">
			<input type="hidden" name="radicalcont" value="<%= Request("radicalcont") %>">
			<input type="hidden" name="envolvidocont" value="<%= Request("envolvidocont") %>">
	<tr>		
			<td height="16" valign="middle" width=23px>&nbsp;<img src="imagem/tit_le.gif" width="19" height="18"></td>
			<td height="16" valign="middle" align=center class="titulo">&nbsp;Resultado&nbsp;da&nbsp;Pesquisa&nbsp;</td>
			<td height="16" width=820px background="imagem/tit_ld.gif"></td>
			<td height="16" valign="middle" width=20px><img src="imagem/tit_fim.gif" width="21" height="16"></td>

	<%if not session("C_rs").eof then%>
		<% If Request("imprimir") = "" then %><td height="16" valign="middle">&nbsp;<a href="javascript: excluir_conf()" class="linkp11"><img src="imagem/lixeira.gif" alt="Excluir" width="13" height="17" border="0" align="absmiddle"></a></td><% End If %>	
	<%end if%>					
			
		</tr>		
	</table>	
		
		<%if request("imprimir") = "" then%>
		<table bgcolor="#FFFFFF" width="100%" border="0" class=preto11 cellpadding="0" cellspacing="0">
			<tr>
				<td width="30%"><b>Processos = <%= session("C_rs").RecordCount %></b></td>
				<td align="center" width="50%"><table class="linkp11">
				<tr>
					<td background="imagem/botao_limpo.gif" width="82" height="21" align="center"><a href="javascript: filtrar()" class="linkp11">&nbsp;&nbsp;Selecionar&nbsp;&nbsp;</a></td>
				</tr>
				</table></td>
				<% If pagatual > 1 then %>
				<td align="right"><table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td><a href="javascript: mprim()"><img src="imagem/setas_navegacao_04.gif" alt="Primeira Página" border="0"></a></td>
				<td><a href="javascript: mante()"><img src="imagem/setas_navegacao_02.gif" alt="Página Anterior" border="0"></a></td>
			</tr>
			</table></td>
	<% Else %>
				<td align="right"><table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td><img src="imagem/setas_navegacao_04_desat.gif" border="0"></td>
				<td><img src="imagem/setas_navegacao_02_desat.gif" border="0"></td>
			</tr>
			</table>
	<% End If %>
	<td align="center" width="10%"><b><input type="text" name="pg_escolha" size="3" maxlength="4" onkeypress="return handleEnter(this, event, this.value)" class="cfrm" onfocus="this.select()" style="text-align: center; font-weight: bold;" value="<%= pagAtual %>">&nbsp;de&nbsp;<%= session("C_rs").PageCount %></b></td>
	<% If pagAtual < session("C_rs").PageCount then %>
	<td align="right"><table cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td><a href="javascript: mprox()"><img src="imagem/setas_navegacao_12.gif" alt="Próxima Página" border="0"></a></td>
		<td><a href="javascript: multi()"><img src="imagem/setas_navegacao_10.gif" alt="Última Página" border="0"></a></td>
	</tr>
	</table></td>
		<% Else %>
		<td align="right"><table cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td><img src="imagem/setas_navegacao_12_desat.gif" border="0"></td>
		<td><img src="imagem/setas_navegacao_10_desat.gif" border="0"></td>
	</tr>
	</table></td>
	<% End If %>
	</tr>
	</table>
	<%end if%>
	<script>
	function handleEnter(field, eventi, npg) {
	var keyCode = eventi.keyCode ? eventi.keyCode : eventi.which ? eventi.which : eventi.charCode;
	if (keyCode == 13) {
		if ((npg > <%= session("C_rs").PageCount %>) || (npg == 0)){
			alert('Coloque uma página existente.');
return false;
		}else{
			muda_pg(npg);
		}
	} 
	else
		if ((keyCode >= 48) && (keyCode < 58)){
			return true;
		}else{
			return false;
		}
}

function muda_pg(num){
	if (doDigits(num)){
		document.frm.action='consulta_main.asp';
		document.frm.atual.value=num;
		document.frm.filtrar.value='<%= Request("filtrar") %>';
		document.frm.submit();
	}else{
		alert('Esse campo só aceita digitos.');
	}
}
	</script>
	<table width="100%" class="tabela<%=l_imp%>" border="0" cellspacing="2" cellpadding="3">					
		<tr bgcolor="#00578F" class="tit1<%=l_imp%>">
			<%if request("imprimir") = "" then%><td align="center"><a href="javascript: marcar()"><img src="imagem/check_xp.gif" width="13" height="13" border="0"></a></td><%end if%>
			
			<%if request("imprimir") = "" then%><td width=4%></td><%end if%>
			<td width=18%><b>Processo</b></td>
			<td width=32%><b>Objeto</b></td>
			<td width=17%><b>Pasta</b></td>
			<td width=17%><b>Clientes</b></td>
			<td width=8%><b>Situação</b></td>			
		</tr>
		
		<%

		if not session("C_rs").eof then			
			if (qtdReg > 0) and (totReg > 0) then
		     	totPag = cint(totReg / qtdReg)
		     	mInt_Total_pages = totpag
				if (totReg / qtdReg) > totPag then totPag = totPag + 1
				else
					totPag = 0
					mInt_Total_pages = 0
				end if
				
				mInt_Total_pages = totpag
				session("C_rs").AbsolutePage = cInt(pagAtual)
				Current_page = cInt(pagAtual)
				
				for k = 1 to session("C_rs").PageSize
					if cor = "#FFFFFF" then
						cor = "#EFEFEF"
					else
						cor = "#FFFFFF"
					end if
					mostra_desc = ""
					descricao_total = ""
					if session("C_rs")("desc_res") <> "" then descricao_total = Replace(session("C_rs")("desc_res"), """", "&quot;")
					descricao_resumida = descricao_total
					if (len(descricao_resumida) > 50) and request("imprimir") = "" then
						descricao_resumida = left(descricao_resumida, 50) & " ..."
						mostra_desc = "onmouseout=""hideMe('descricao"& k & "')"" onmouseover=""showMe('descricao" & k & "', 'span_descr" & k &"')"" onClick=""DisableHide()"""
					end if
				%>
				
					<tr bgcolor=<%=cor%>>
						<%if request("imprimir") = "" then%><td width="13" align="center"><input type="checkbox" name="nproc<%= session("C_rs")("id_processo") %>" value="<%= session("C_rs")("id_processo") %>" onclick="marca_check('<%=session("C_rs")("id_processo") %>')"<% If instr(Request("pmarcados"),session("C_rs")("id_processo")) > 0 then %> checked<% End If %>></td><%end if%>
						<%If Request.Querystring("imprimir") = "" then %><td align="center"><%
							set rst_carta = db.execute("Select comunicacao from Parametros WHERE usuario = '"&session("vinculado")&"'")
							if trim(rst_carta("comunicacao")) <> "" then
								Response.write "<a href=""javascript:abrirjanela('gera_carta_contencioso.asp?origem=M&id_processo=" & session("C_rs")("id_processo") & "',350,110)"">"
							end if%>
							<img src="imagem/carta.gif" alt="<% if trim(rst_carta("comunicacao")) = "" then %>Gerar carta. Padrão não definido.<% Else %>Gerar carta<% End If %>" width="19" height="21" border="0"></a></td>
						<% End If %>
						<td nowrap><a class="preto11" href="processo.asp?id_processo=<%=session("C_rs")("id_processo")%>&modulo=C"><%=session("C_rs")("processo")%></a></td>
						<td><span id="span_descr<%=k%>" class="preto11" href="javascript:void(0)" <%=mostra_desc%>><%=descricao_resumida%></span>
							<div id="descricao<%=k%>" style="background-color:#ffffff; height:20px; position:absolute; width:300px; z-index:10; layer-background-color:#FFFFFF; top:0; left:0; visibility:hidden;"> 
								<div style="background:#ffffff; border:3px solid #345C46;" >
									<div class="tit1<%=l_imp%>" style="background:#345C46; padding:2px">
										<div style="position: absolute;"><strong>Objeto</strong></div><div style="text-align:right;"><a href="javascript:EnableHide('descricao<%=k%>');" title="Fechar" style="text-decoration:none"><img src="../img_comp/fechar.gif" border="0"></a></div>
									</div>
									<div style="text-align:justify; padding-left:10px; padding-right:10px;"><%=descricao_total%></div>
								</div>
							</div>
						</td>
						<td><%=session("C_rs")("Pasta")%></td>
						<td width=150px>
						<%
						sql = "SELECT apelido FROM TabCliCont LEFT OUTER JOIN APOL.dbo.Envolvidos ON TabCliCont.envolvido = APOL.dbo.Envolvidos.[id] WHERE (TabCliCont.processo = " & session("C_rs")("id_processo") & ") AND (TabCliCont.usuario = '" & session("vinculado") & "')"
						set rst2 = db.execute(sql)
						if not rst2.eof then
							apelido_env = rst2.GetString(,,," | ","&nbsp;")
							if Right(apelido_env, 3) = " | " then
								apelido_env = Left(apelido_env, len(apelido_env) - 3)
							end if
							response.write apelido_env
						end if
						%>
						</td>
						<td align=center>
							<%if session("C_rs")("situacao") = "A" then
								response.write "Ativo"
							elseif session("C_rs")("situacao") = "E" then
								response.write "Encerrado"
							elseif session("C_rs")("situacao") = "C" then
								response.write "Acordo"
							elseif session("C_rs")("situacao") = "I" then
								response.write "Inativo"
							end if%>
						</td>
					</tr>
					<%				
					session("C_rs").movenext
					if session("C_rs").eof then exit for
				next%>
	</table>
	<%if request("imprimir") = "" then%>
		<table bgcolor="#FFFFFF" width="100%" border="0" class=preto11 cellpadding="0" cellspacing="0">
			<tr>
				<td width="30%"><b>Processos = <%= session("C_rs").RecordCount %></b></td>
				<td align="center" width="50%"><table class="linkp11">
				<tr>
					<td background="imagem/botao_limpo.gif" width="82" height="21" align="center"><a href="javascript: filtrar()" class="linkp11">&nbsp;&nbsp;Selecionar&nbsp;&nbsp;</a></td>
				</tr>
				</table></td>
				<% If pagatual > 1 then %>
				<td align="right"><table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td><a href="javascript: mprim()"><img src="imagem/setas_navegacao_04.gif" alt="Primeira Página" border="0"></a></td>
				<td><a href="javascript: mante()"><img src="imagem/setas_navegacao_02.gif" alt="Página Anterior" border="0"></a></td>
			</tr>
			</table></td>
	<% Else %>
				<td align="right"><table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td><img src="imagem/setas_navegacao_04_desat.gif" border="0"></td>
				<td><img src="imagem/setas_navegacao_02_desat.gif" border="0"></td>
			</tr>
			</table>
	<% End If %>
	<td align="center" width="10%"><b><input type="text" name="pg_escolha" size="3" maxlength="4" onkeypress="return handleEnter(this, event, this.value)" class="cfrm" onfocus="this.select()" style="text-align: center; font-weight: bold;" value="<%= pagAtual %>">&nbsp;de&nbsp;<%= session("C_rs").PageCount %></b></td>
	<% If pagAtual < session("C_rs").PageCount then %>
	<td align="right"><table cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td><a href="javascript: mprox()"><img src="imagem/setas_navegacao_12.gif" alt="Próxima Página" border="0"></a></td>
		<td><a href="javascript: multi()"><img src="imagem/setas_navegacao_10.gif" alt="Última Página" border="0"></a></td>
	</tr>
	</table></td>
		<% Else %>
		<td align="right"><table cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td><img src="imagem/setas_navegacao_12_desat.gif" border="0"></td>
		<td><img src="imagem/setas_navegacao_10_desat.gif" border="0"></td>
	</tr>
	</table></td>
	<% End If %>
	</tr>
	</table>
	<%end if%>
	<%
		else
			%>
			<tr bgcolor=<%=cor%>>
				<td width="100%" align="center" colspan=3 class="preto11"><b>Não foram encontrados processos que atendam às condições estabelecidas</b></td>
			</tr>	</table>	
			<%
	end if%>

<%'end if%>	
<script>
	function abrirjanela(url, width,  height) {
		varwin=window.open(url,"openscript",'width='+width+',height='+height+',resizable=0,scrollbars=yes,status=yes');
	}

	var marcado = true;
	
	function marca_check(num_proc){
		if (document.frm.pmarcados.value == document.frm.pmarcados.value.replace('#'+num_proc+'#','')){
			document.frm.pmarcados.value = document.frm.pmarcados.value+'#'+num_proc+'#';
		}
		else {
			document.frm.pmarcados.value = document.frm.pmarcados.value.replace('#'+num_proc+'#','')
		}
	}
	
	function mprox(){
		document.frm.action='consulta_main.asp';
		document.frm.atual.value=<%= pagAtual+1 %>;
		document.frm.filtrar.value='<%= Request("filtrar") %>';
		document.frm.direcao.value='proxima';
		document.frm.submit();
	}
		
	function multi(){
		document.frm.action='consulta_main.asp';
		document.frm.atual.value=<%= session("C_rs").PageCount %>;
		document.frm.filtrar.value='<%= Request("filtrar") %>';
		document.frm.submit();
	}
	
	function mante(){
		document.frm.action='consulta_main.asp';
		document.frm.atual.value=<%= pagAtual-1 %>;
		document.frm.filtrar.value='<%= Request("filtrar") %>';
		document.frm.submit();
	}
		
	function mprim(){
		document.frm.action='consulta_main.asp';
		document.frm.atual.value=1;
		document.frm.filtrar.value='<%= Request("filtrar") %>';
		document.frm.submit();
	}
		
		
	function marcar() {
		var i
		for (i=0;i<document.frm.elements.length;i++){
			if (document.frm.elements[i].name.substr(0, 5) == "nproc"){
				if (document.frm.elements[i].checked != marcado){
					marca_check(document.frm.elements[i].value)
				}
				document.frm.elements[i].checked = marcado;
			}
		}
		marcado = !marcado;
	}
	
	function filtrar(){
		if(document.frm.pmarcados.value != ""){
			document.frm.action='consulta_main.asp';
			document.frm.resultado.value='';
			document.frm.filtrar.value='ok';
			document.frm.atual.value=1;
			document.frm.pg.value='1';		
			document.frm.submit();
		}
		else{
			alert("Selecione pelo menos um processo.")
		}
	}
	
	function excluir_conf(){
		if(document.frm.pmarcados.value != ""){
			mostra_exc();
		}
		else{
			alert("Selecione pelo menos um processo.");
		}
	}
	
	function excluir(){
		fecha_exc();
		if(document.frm.pmarcados.value != ""){		
			document.frm.action='processos_excluir.asp?vindo=1';
			document.frm.submit();
		}
		else{
			alert("Selecione pelo menos um processo.");
		}
	}

	function valida(){		
		return true;
	}
</script>

<div id="pergunta_exc" style="position: absolute; top: 60px; width: 770px; left: 1px; height: 400px; visibility: hidden;">
<table width="100%" height="100%">
<tr valign="middle">
	<td align="center">
<table width="300" bgcolor="#FFFFFF" style="border: 1px solid Black;" class="preto11">
<tr>
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;Exclusão&nbsp;de&nbsp;Processo&nbsp;&nbsp;</td>
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
	<td align="center"><img src="imagem/pergunta.gif" width="35" height="33" border="0" align="absmiddle">&nbsp;&nbsp;<b style="color:red;">Confirma exclusão de todos os registros selecionados ?</b></td>
</tr>
<tr>
	<td align="center">&nbsp;</td>
</tr>
<tr>
	<td align="center">
	<table class="linkp11">
	<tr>
		<td background="imagem/botao_limpo.gif" width="82" height="21" align="center"><a href="javascript: fecha_exc()" class="linkp11">&nbsp;&nbsp;&nbsp;Não&nbsp;&nbsp;&nbsp;</a></td>
		<td>&nbsp;&nbsp;</td>
		<td background="imagem/botao_limpo.gif" width="82" height="21" align="center"><a href="javascript: excluir()" class="linkp11">&nbsp;&nbsp;&nbsp;Sim&nbsp;&nbsp;&nbsp;</a></td>
	</tr>
	</table>
	</td>
</tr>
</table>
	</td>
</tr>
</table>
</div>

