<% tem_xls = false 'Atualizando controle de relatorio em xls (.csv) 'TKT 1511 - em andamento com albino %>
<% bt_imprimir = true %>
<% bt_export = true %>

<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<!--#include file='../include/Db_open_usuarios.asp'-->
<!--#include file="../include/adovbs.inc"-->
<!DOCTYPE HTML>

<html>

	<head>

		<title>APOL Jurídico<% If Request.Querystring("imprimir") <> "" then %> - Impressão de Informações<% End If %></title>
<link rel="STYLESHEET" type="text/css" href="style.css"> 
		<link rel="stylesheet" type="text/css" href="css/jquery-ui.css" />
		<link rel="stylesheet" type="text/css" href="css/style_tribunais.css">

		<script type="text/javascript" language="JavaScript" src="js/jquery-1.10.2.min.js"></script>
		<script type="text/javascript" language="JavaScript" src="js/jquery-ui-1.10.3.custom.min.js"></script>
		<script type="text/javascript" language="JavaScript" src="js/json2.js"></script>
		<script type="text/javascript" language="JavaScript" src="js/tribunais.js"></script>

<script language="javascript" src="valida.js"></script>
<script language="javascript" src="../include/funcoes.js"></script>

	</head>

<!--#include file="rel_func.asp"-->

	<div id="dlgExibeLinks" title="Links do Andamento">
		<span id="listaLinks"></span>
	</div>
<%

	Dim strFiltros
Set rel = new clsRelatorio
rel.addRel "Relatório Detalhado",	"../Relatorio_Apol.aspx?tipo_rel=2006"
rel.RenderRel "400","70"

menu_onde = "proc"
if request("imprimir") = "S" then
	l_imp = "_p"
end if
bt_imprimir = true
	if request("imprimir") = "" then
%>	
	<!--#include file="header.asp"-->
<%
	Else
%>
	<table cellpadding="0" cellspacing="0" width="100%" border="0">	
	<tr>
		<td><%
			SQL = "select logotipo from usuario where vinculado='"&session("vinculado")&"' and nomeusu='"& session("vinculado") &"' "
			set rsy = conn_usu.execute(SQL)

			if rsy("logotipo") <> "" then
			%>
			<img src="../logo_cliente/<%=rsy("logotipo")%>" border="0">
			<% end if %></td>
		<td align="right" valign="top"><span class="preto11"><%= now() %></span></td>
	</tr>
	</table>
<%
End If

'Variáveis dos campos trazidos pelo request no form - arquivo rel_andamentos_tribuanis.asp
ordem				= tplic(1,request("ordem"))
ordenacao			= tplic(1,request("ordenacao"))
processo 			= tplic(1,request("ftabproccont.processo_c"))
tipo 				= tplic(1,request("ftabproccont.tipo_c"))
objeto				= tplic(1,request("ftabproccont.desc_res"))
competencia			= tplic(1,request("fcompetencia_c"))
tipo_envolvido 		= tplic(1,request("tipo_env"))
envolvido 			= tplic(1,request("apelido"))
pasta 				= tplic(1,request("fpasta_c"))
pastaexata 			= request("pastaexata")
descricao			= tplic(1,request("desc1_c0")) 
orgaos				= tplic(1,request("forgao_n"))
oculto				= request("andamentosocultos")
participante		= tplic(1,request("fparticipante_c"))
responsavel			= tplic(1,request("txt_responsavel"))
ddt_cad 			= request("ddt_cad")
adt_cad				= request("adt_cad") 

'Filtro para ordenação
if  ordem = "p.processo" then
	FiltrOrdem = "p.processo " & ordenacao & ", tA.data ASC"
end if

if ordem = "" or ordem = "o.data" then
	FiltrOrdem = "tA.data " & ordenacao & ", p.processo ASC" 
end if

if ordem = "p.situacao" then
	FiltrOrdem = "p.situacao " & ordenacao & ", p.processo ASC, tA.data ASC" 
end if

if ordem = "p.pasta" then
	FiltrOrdem = "p.pasta " & ordenacao & ", p.processo ASC, tA.data ASC" 
end if

if len(ordem) > 0 then
	strFiltros = strFiltros &"Ordenação: "
	strFiltros = strFiltros &"<b>"& RetornaTipoConculta(ordem)&"</b>"
	strFiltros = strFiltros & " (" & RetornaDescricaoOrdem(ordenacao) & "), "
end if 

sql = " 1 = 1 "

'Filtro para processo
if not isnull(processo) and not IsEmpty(processo) and len(trim(processo)) > 0 then
	sql = sql & " and p.processo like '%" & processo & "%'"
	strFiltros = strFiltros &" Processo: <b>" &trim(processo)& "</b>,"
end if

'Filtro para Tipo do Processo
if not isnull(tipo) and not IsEmpty(tipo) and len(trim(tipo)) > 0 then
	sql = sql & " and p.tipo like '%" & tipo & "%'"
	strFiltros = strFiltros& " Tipo do Processo: <b>" & TipoProcesso(tipo)&"</b>,"
end if

'Filtro para Andamentos Ocultos
if oculto <> "on" then
	sql = sql & " and tA.ocultar = 0 "
elseif oculto = "on" then
	strFiltros = strFiltros &" Mostrar :&nbsp;<b>Ocultos</b>, "
end if

'Filtro para Objeto 
if not isnull(objeto) and not IsEmpty(objeto) and len(trim(objeto)) > 0 then
	sql = sql & " and p.desc_res like '%"&objeto&"%'"
	strFiltros = strFiltros &" Objeto: <b>"&objeto&"</b>, "
end if
	
'Filtro para Competência
if not isnull(competencia) and not IsEmpty(competencia) and len(trim(competencia)) > 0 then
	sql = sql & " and p.competencia like '%" & competencia & "%'"
	strFiltros = strFiltros &"Competência: <b>"&FunCompetencia(competencia)&"</b>, "
end if

'Filtro para Tipo do Envolvido
if not isnull(tipo_envolvido) and not IsEmpty(tipo_envolvido) and len(trim(tipo_envolvido)) > 0 then
	sqlTipoEnv = "select	processo " &_
					"from TabCliCont t " &_
					"join apol.dbo.Tipo_Envolvido te " &_
						"on te.id_tipo_env = t.tipo_env " &_
					"where t.usuario = '"&session("vinculado")&"' and t.tipo_env = '"&tipo_envolvido&"'"
	
	sql = sql & " and (p.id_processo in ("&sqlTipoEnv&")) "

	'meu código'
	strFiltros = strFiltros &"Tipo do Envolvido: <b>"&FuncTipoEnvolvido(tipo_envolvido)&"</b>,"

end if

'Filtro para Posição (Participante)
if not isnull(participante) and not IsEmpty(participante) and len(trim(participante)) > 0 then
	sql = sql & " and p.participante like '%" &participante & "%' "
	strFiltros = strFiltros&" Posição: <b>"&FuncPosicao(participante)&"</b>,"
end if

'Filtro para Envolvidos
if not isnull(envolvido) and not IsEmpty(envolvido) and len(trim(envolvido)) > 0 then
	sqlEnv = "select	processo " &_
					"from TabCliCont t " &_
					"where t.envolvido = '"&envolvido&"'"
	
	sql = sql & " and (p.id_processo in ("&sqlEnv&")) "
	strFiltros = strFiltros &" Envolvido: <b>"&FuncEnvolvido(envolvido)&"</b>,"
end if

'Filtro para Responsável
if not isnull(responsavel) and not IsEmpty(responsavel) and len(trim(responsavel)) > 0 then
	if cint(responsavel) > 0 then
		sql = sql & " and p.responsavel  = '" &responsavel & "' "
		strFiltros = strFiltros &" Responsável: <b>"&FuncResponsavel(responsavel)&"</b>,"
	end if
end if

'Filtro para Pasta e Exata
if not isnull(pasta) and not IsEmpty(pasta) and len(trim(pasta)) > 0 then
	if pastaexata = "0" then
		sql = sql & " and p.pasta = '" &pasta& "'"
		strFiltros = strFiltros &" Pasta Exata: <b>"&pasta&"</b>,"
	else
		sql = sql & " and p.pasta like '%" &pasta& "%'"
		strFiltros = strFiltros &" Pasta: <b>"&pasta&"</b>,"
	end if
end if

'Filtro para Data do Andamento (Inicial e Final)
if isdate(request("ddt_cad")) then
	sql= sql & " and (tA.data >= "&rdata(ddt_cad)&") "
	strFiltros = strFiltros &" Data de [@andamentos]: <b>" &ddt_cad&"</b>"
end if

if isdate(request("adt_cad")) then
	sql= sql & " and (tA.data < "&rdata(DateAdd("d", 1, request("adt_cad")))&") "
	strFiltros = strFiltros &" até <b>"&adt_cad& "</b>,"
end if

'Filtro para Descrição do Andamento 

if not isnull(descricao) and not IsEmpty(descricao) and len(trim(descricao)) > 0 then
	sql = sql & " and tA.descricao_andamento like '%"&descricao&"%'"
	strFiltros = strFiltros &" Descrição de [@andamentos]: <b>" &descricao&"</b>,"
end if

'Filtro para Órgão
if not isnull(orgaos) and not IsEmpty(orgaos) and len(trim(orgaos)) > 0 then
	sql = sql & " and p.tribunal_sync = '" &orgaos& "' "

	dim varOrgao

	if isnumeric(orgaos) then 
		varOrgao = ObterDescricaoOrgaoGerencial(orgaos)

		else 
			varOrgao = ObterDescricaoOrgaoOficial(orgaos)
	end if 
	strFiltros = strFiltros & " Órgão: <b>"& varOrgao&"</b>,"

end if

'Query principal da página
sql = "SELECT	DISTINCT tA.id as id_andamento, tA.id_processo, p.processo, p.tribunal_sync, " &_
				"case p.situacao when 'A' then 'Ativo' when 'C' then 'Em Acordo' when 'E' then 'Encerrado' when 'I' then 'Inativo' end as situacao, " &_
				"p.tipo, p.desc_res, p.competencia, " &_
				"p.participante, p.pasta, " &_
				"p.responsavel, r.nome, " &_
				"tA.data, tA.descricao_andamento, " &_
				"tA.ocultar, " &_
				"dbo.ApelidoDoEnvolvido(p.id_processo,'C',p.usuario,', ') as envolvidos, tA.links " &_
			"FROM TabProcCont p " &_
			"join tbConexaoTribunais_Andamentos a " &_
				"on a.processo = p.processo and a.usuario = p.usuario " &_
			"join tb_Andamentos tA on tA.id_processo = p.id_processo " &_
			"left join apol.dbo.Responsaveis r on r.id = p.responsavel " &_
			"where p.usuario = '"&session("vinculado")&"' " &_
				" and " & sql & "order by " & FiltrOrdem 

if Request("filtrar") = "ok" then
	pmarcados = replace(tplic(1,Request("pmarcados")),"#","'")
	pmarcados = replace(pmarcados,"''","','")
	sql2 = replace(replace(sql,"and order"," order"),"order by", " and tA.id in (" &pmarcados& ") order by ")
	strFiltros = strFiltros &"<b> Seleção Manual</b>,"
else
	sql2 = replace(sql,"and order"," order")
end if

session("sql2") = sql2
session("sqlContencioso") = mid(session("sql2"), instr(session("sql2"), "FROM"), len(session("sql2")))

'Log ao retirar o relatório
if request("imprimir") = "" then
	ok = grava_log_c(session("nomeusu"),"LISTAGEM", andamentos_C,"Relatório de " &andamentos_C)
end if

set rst = server.createobject("ADODB.Recordset")

'response.write session("sql2")

if request("DO") then 'Verificando se a pagina foi "chamada" pelo aviso de DO
	if  instr(lcase(session("sql2")),"order by p.processo") then
		sqlDO = "USE contencioso "& replace(lcase(session("sql2")),"order by p.processo"," AND p.id_processo IN ("& request("processo") &") ORDER BY p.processo ") 'SQL responsavel pela listagem dos itens na tela
	else
		response.end
	end if
	rst.open sqlDO, db, 3, 3
else 'Caso tenha sido chamado por outra tela, efetua o sql diferente.
	rst.open session("sql2"), db, 3, 3
end if
'response.write sqlDO
'*'TKT 1511 - em andamento com albino
'*'Armazenando os id dos processos apresentados na pagina (sera usada para criacao de relatorios em xls)
if not rst.eof then
	id_procs = rst.GetRows(-1, 1, "id_processo")
	procs = ""
	
	for w=0 to ubound(id_procs, 2)
		procs = procs & id_procs(0, w) & "/"
	next
	
	if procs <> "" then 
		procs = left(procs, len(procs)-1) 'Remover a ultima barra
	end if
end if
'*'fim do armazenamendo
	
'*'response.Write(procs)

set rsp2 = conn.execute("SELECT ocorrencia, andamentos, campo1, campo2, campo3, campo4 FROM Contencioso.dbo.Parametros WHERE usuario = '"&session("vinculado")&"' ")

ocorrencia = ""
andamentos_C = "Andamentos"
If not rsp2.eof then
	if (not isnull(rsp2("ocorrencia")) and (rsp2("ocorrencia") <> "")) then
		ocorrencia = rsp2("ocorrencia")
	end if
	
	if (not isnull(rsp2("andamentos")) and (rsp2("andamentos") <> "")) then
		andamentos_C = rsp2("andamentos")
	end if
End If		
%>
<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">		
		<tr>		
			<td height="16" valign="middle" width=23px>&nbsp;<img src="imagem/tit_le.gif" width="19" height="18"></td>
			<td height="16" valign="middle" align=center class="titulo" nowrap>&nbsp;Relatório&nbsp;de&nbsp;<%=andamentos_C%>&nbsp;</td>
			<td height="16" width=820px background="imagem/tit_ld.gif"></td>
			<td height="16" valign="middle" width=20px><img src="imagem/tit_fim.gif" width="21" height="16"></td>

	<% if rst.eof then%>
		<% If Request.Querystring("imprimir") = "" then %><% if (Session("cont_exc_proc")) or (Session("adm_adm_sys")) then %><td height="16" valign="middle">&nbsp;</td><% End If %><% End If %>	
	<%end if%>					
			
		</tr>		
	</table>	
<%
	'aqui eu removo a virgula'
		strFiltros = trim(strFiltros)
	If request("imprimir") <> "" then
		if len(strFiltros) > 0 then 
			strFiltros = left(strFiltros,len(strFiltros)-1) 
			strFiltros = replace(strFiltros,"[@andamentos]",andamentos_C)
		end if 
	end if 
%>
	<% If request("imprimir") <> "" then%>
	
	<table border="0" class="preto11" bgcolor="#ffffff" width="100%" align="center" >
		<tr><td colspan="10" >
				<span class="preto11">
				<b>Filtro(s):</b><br><%=strFiltros%>
				</span>
			</td>
		</tr>
	</table>
	<% end if %>

	<% If Request("imprimir") <> "" then %>
			<tr>
				<td colspan="8">
					<img src="imagem/1px-preto.gif" width="100%" height="1" border="0">
				</td>
			</tr>
	<% end if %>

		<%
		totReg = rst.recordcount
		if totReg = 0 then
			%>
			<table width="100%" class="tabela<%=l_imp%>" border="0" cellspacing="2" cellpadding="3">					
			<tr bgcolor=<%=cor%>>
				<td width="100%" align="center" colspan=3><b>Não foram encontrados Processos que atendam às condições estabelecidas</b></td>
			</tr>
			</table>
			<script>
		        document.getElementById('link_imp_exp').disabled = 'disabled';
		        document.getElementById('link_imp_exp').onmouseover = '';		
	        </script>
			<%
			response.end
		end if
		'---------------------------------------------------------------------------------
		' Define a página de exibição 
		'---------------------------------------------------------------------------------
		pagAtual = 1
		if not isnull(request("atual")) and request("atual") <> "" and request("imprimir") = "" then
			pagAtual = cInt(request("atual"))
		end if

		' -------------------------------------------------------------------------
		' prepara o Recordset para paginação escolhendo um padrão de qtdRegistros 
		' -------------------------------------------------------------------------
		qtdReg  = 15
		if request("imprimir") <> "" then
			qtdReg  = 10000
		end if
		set rst = Server.CreateObject("ADODB.Recordset")
		rst.CursorLocation = adUseClient
		rst.CursorType		= adOpenStatic
		
		session("sqlmain") = session("sql2")

		if request("DO") then
			rst.Open sqlDO, Db ,,,adCmdText
		else
			rst.Open session("sql2"), Db ,,,adCmdText
		end if

		Set Session("C_nvgc_prcss") = Server.CreateObject("ADODB.recordset")
		Set Session("C_nvgc_prcss") = rst.Clone(-1)

		'response.end
		rst.CacheSize		= qtdReg
		rst.PageSize 		= qtdReg
		rst.AbsolutePage 	= cInt(pagAtual)
		
		Current_page 		= cInt(pagAtual)
		%>		

		<%if request("imprimir") = "" then%>
		<table bgcolor="#FFFFFF" width="100%" border="0" class=preto11 cellpadding="0" cellspacing="0">
			<tr>
				<td width="30%"><b>&nbsp;Registros = <%= rst.RecordCount %></b></td>
				<td align="center" width="50%"><table class="linkp11">
				<tr>
					<td background="imagem/botao_limpo.gif" width="82" height="19" align="center"><a href="javascript: filtrar()" class="linkp11">&nbsp;&nbsp;Selecionar&nbsp;&nbsp;</a></td>
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
	<td align="center" width="10%"><b><input type="text" name="pg_escolha" size="3" maxlength="4" onkeypress="return handleEnter(this, event, this.value)" class="cfrm" onfocus="this.select()" style="text-align: center; font-weight: bold;" value="<%= pagatual %>">&nbsp;de&nbsp;<%= rst.PageCount %></b></td>
	<% If pagAtual < rst.PageCount then %>
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
	
	<table width="100%" class="tabela<%=l_imp%>" border="0" cellspacing="2" cellpadding="3">	
		<form action="rlt_xls_contencioso.asp" name="formCSV" method="post">
			<input type="hidden" name="procs" value="<%=procs%>"> <%' Campo usado para passar os id dos processo listados na tela para criacao de relatorio em .csv (xls) %>
			<input type="hidden" name="ordem" value="<%=request("ordem")%>">
		</form>

		<form action="rlt_xls_contencioso.asp" name="formXLS" method="post">
			<input type="hidden" name="procs" value="<%=procs%>"> <%' Campo usado para passar os id dos processo listados na tela para criacao de relatorio em .csv (xls) %>
			<input type="hidden" name="ordem" value="<%=request("ordem")%>">
			<input type="hidden" name="tipo_rlt" value="excel">
		</form>

		<form action="processo_anda_result.asp" name="frm" method="post" onsubmit="return valida()">				
			<input type="hidden" name="vindo" value="1" > 
			<input type="hidden" name="direcao" value="" > 			
			<input type="hidden" name="filtrar" value="" >			
			<input type="hidden" name="resultado" value="S" >			
			<input type="hidden" name="pmarcados" value="<%=request("pmarcados")%>">
			<input type="hidden" name="atual" value="<%=pagAtual%>" >
			<input type="hidden" name="pagAtual" value="" >	
			<input type="hidden" name="sql" value="<%=sql%>">
			
			<% for each campo in request.form %>
			<% If (campo <> "vindo") and (campo <> "direcao")  and (campo <> "filtrar") and (campo <> "resultado") and (campo <> "pmarcados") and (campo <> "atual") and (campo <> "pagAtual") and (campo <> "sql") and (left(campo, 5) <> "nproc") and (campo <> "procs") then %>
			<input type="hidden" name="<%= campo %>" value="<%= request(campo) %>">
			<% End If %>
			<% next %>
			<% for each campo in request.querystring %>
			<% If (campo <> "vindo") and (campo <> "direcao")  and (campo <> "filtrar") and (campo <> "resultado") and (campo <> "pmarcados") and (campo <> "atual") and (campo <> "pagAtual") and (campo <> "sql") and (left(campo, 5) <> "nproc") and (campo <> "procs") then %>
			<input type="hidden" name="<%= campo %>" value="<%= request(campo) %>">
			<% End If %>
			<% next %>
			<script>//frm.action = frm.action + "?sql2='<%=sql2%>'"</script>

		<tr bgcolor="#00578F" class="tit1<%=l_imp%>">
			<%if request("imprimir") = "" then%>
			    <td align="center" width=4%><a href="javascript: marcar()"><img src="imagem/check_xp.gif" width="13" height="13" border="0"></a></td>
			<%end if%>
			
			<td width=10% align="center"><b>Data</b></td>
			<td width=25%><b>Processo/Responsável/<i>Pasta</i></b></td>
			<td width=35%><b>Detalhe</b></td>
<%
	if request("imprimir") = "" then
%>
			<td width=5%><strong>Link</strong></td>
<%
	end if
%>
			<td width=5%><b>Envolvidos</b></td>
			<td width=8% align="center"><b>Situação</b></td>
		</tr>
		<% If Request("imprimir") <> "" then %>
			<tr>
				<td colspan="8">
					<img src="imagem/1px-preto.gif" width="100%" height="1" border="0">
				</td>
			</tr>
	<% end if %>
		<%

		if not rst.eof then			
			if (qtdReg > 0) and (totReg > 0) then
		     	totPag = cint(totReg / qtdReg)
		     	mInt_Total_pages = totpag
				if (totReg / qtdReg) > totPag then totPag = totPag + 1
			else
				totPag = 0
				mInt_Total_pages = 0
			end if
				
			mInt_Total_pages = totpag
			rst.AbsolutePage = cInt(pagAtual)
			Current_page = cInt(pagAtual)
			for k = 1 to rst.PageSize
				if cor = "#FFFFFF" then
					cor = "#EFEFEF"
				else
					cor = "#FFFFFF"
				end if
				mostra_desc = ""
				descricao_total = ""
				if rst("desc_res") <> "" then descricao_total = Replace(rst("desc_res"), """", "&quot;")
				descricao_resumida = descricao_total
				if (len(descricao_resumida) > 50) and request("imprimir") = "" then
					descricao_resumida = left(descricao_resumida, 50) & " ..."
					mostra_desc = "onmouseout=""hideMe('descricao"& k & "')"" onmouseover=""showMe('descricao" & k & "', 'span_descr" & k &"')"" onClick=""DisableHide()"""
				end if
				%>
				<tr bgcolor=<%=cor%>>
					<%if request("imprimir") = "" then%>
						<td width="13" align="center">
							<input type="checkbox" name="nproc<%= rst("id_andamento") %>" value="<%= rst("id_andamento") %>" onclick="marca_check('<%=rst("id_andamento") %>')"<% If instr(Request("pmarcados"),rst("id_andamento")) > 0 then %> checked<% End If %>>
						</td>
					<%end if%>
					<td align="center"><%=fdata(rst("data"))%></td>
					<td align="center" nowrap><%if request("imprimir") <> "" then%>
							<%=rst("processo")%>
						<%else%>
							<a class="preto11" href="processo.asp?id_processo=<%=rst("id_processo")%>&modulo=C&processo='<%=rst("processo")%>'&pasta=<%=rst("pasta")%>"><%=rst("processo")%></a>
						<%End if%><%if rst("processo") <> "" then%><br><%end if%>
						<%=rst("nome")%><%if rst("nome") <> "" then%><br><%end if%>
						<i><%=rst("pasta")%></i>
					</td>
					<td><%=rst("descricao_andamento")%></td>
<%
	if request("imprimir") = "" then
%>
					<td valign="middle" align="center">
<%
		if len(rst("links")) > 0 then
%>
					<img class="lnkAndamento" src="imagem/icon_page_white_link.png" alt="Link" border="0" data-links-json='<%=rst("links")%>'>
<%
		end if
%>
					</td>
<%
	end if
%>
					<td><%=rst("envolvidos")%></td>
					<td align="center"><%=rst("situacao")%></td>
				</tr>
				</tr>
				<%				
				rst.movenext
				if rst.eof then exit for
			next
		else%>
			<tr bgcolor=<%=cor%>>
				<td width="100%" align="center" colspan=3 class="preto11"><b>Não foram encontrados processos que atendam às condições estabelecidas</b></td>
			</tr>
		<%end if%>
		</form>
	</table>	
</tr>
</form>
<%
	If Request("imprimir") <> "" then
%>
	<table bgcolor="#FFFFFF" width="100%" border="0" class="preto11" cellpadding="0" cellspacing="0" >
	<tr>
		<td><img src="imagem/1px-preto.gif" width="100%" height="1" border="0"></td>
	</tr>
	<tr>
		<td height="1">&nbsp;<b>Total = <%= rst.RecordCount %></b></td>
	</tr>
	<tr>
		<td><img src="imagem/1px-preto.gif" width="100%" height="1" border="0"></td>
	</tr>
	</table>
<%
	end if
%>
<tr>
	<%if request("imprimir") = "" then%>
		<table bgcolor="#FFFFFF" width="100%" border="0" class=preto11 cellpadding="0" cellspacing="0">
			<tr>
				<td width="30%"><b>&nbsp;Registros = <%= rst.RecordCount %></b></td>
				<td align="center" width="50%"><table class="linkp11">
				<tr>
					<td background="imagem/botao_limpo.gif" width="82" height="19" align="center"><a href="javascript: filtrar()" class="linkp11">&nbsp;&nbsp;Selecionar&nbsp;&nbsp;</a></td>
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
	<td align="center" width="10%"><b><input type="text" name="pg_escolha" size="3" maxlength="4" onkeypress="return handleEnter(this, event, this.value)" class="cfrm" onfocus="this.select()" style="text-align: center; font-weight: bold;" value="<%= pagatual %>">&nbsp;de&nbsp;<%= rst.PageCount %></b></td>
	<% If pagAtual < rst.PageCount then %>
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
	function del(cod){
	if (window.confirm("Confirma exclusão?")){
		location="processo_salvar.asp?tipo=del&proc="+cod}
	}
	
	function abrirjanela(url, width,  height) 
		{
			varwin=window.open(url,"openscript",'width='+width+',height='+height+',resizable=0,scrollbars=yes,status=yes');
		}
	function downloadPDF(){
		mostra_relat()
	}
</script>
<br>
<div id="exclui" style="position: absolute; top: 60px; width: 770px; left: 1px; height: 400px; visibility: hidden;">
<br>
<table width="100%" height="100%">
<tr valign="middle">
	<td align="center">
<table width="300" bgcolor="#FFFFFF" style="border: 1px solid Black;" class="preto11">
<tr>
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;Exclusão&nbsp;de&nbsp;Responsáveis&nbsp;&nbsp;</td>
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
		<td background="imagem/botao_limpo.gif" width="82" height="21" align="center"><a href="javascript: fecha_exc()" class="linkp11">&nbsp;&nbsp;&nbsp;Não&nbsp;&nbsp;&nbsp;</a></td>
		<td>&nbsp;&nbsp;</td>
		<td background="imagem/botao_limpo.gif" width="82" height="21" align="center"><a href="javascript: conf_excluir(pid)" class="linkp11">&nbsp;&nbsp;&nbsp;Sim&nbsp;&nbsp;&nbsp;</a></td>																																																									 
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
var pid = 0;

function mostra_exc(id)
		{
		pid=id;
		MM_showHideLayers('exclui','','show');
		}
		
function fecha_exc()
		{
		MM_showHideLayers('exclui','','hide');
		}

function conf_excluir(pid2){			
		document.frm.action='processo_salvar.asp?tipo=del&vindo=1&proc='+pid2;
		document.frm.submit();
		fecha_exc();
}
</script>

<script>
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
	document.frm.action='processo_anda_result.asp';
	document.frm.atual.value=<%= pagAtual+1 %>;
	document.frm.filtrar.value='<%= Request("filtrar") %>';
	document.frm.direcao.value='proxima';
	document.frm.submit();
}
	
function multi(){
	document.frm.action='processo_anda_result.asp';
	document.frm.atual.value=<%= rst.PageCount %>;
	document.frm.filtrar.value='<%= Request("filtrar") %>';
	document.frm.submit();
}

function mante(){
	document.frm.action='processo_anda_result.asp';
	document.frm.atual.value=<%= pagAtual-1 %>;
	document.frm.filtrar.value='<%= Request("filtrar") %>';
	document.frm.submit();
}
	
function mprim(){
	document.frm.action='processo_anda_result.asp';
	document.frm.atual.value=1;
	document.frm.filtrar.value='<%= Request("filtrar") %>';
	document.frm.submit();
}

function handleEnter(field, eventi, npg) {
	var keyCode = eventi.keyCode ? eventi.keyCode : eventi.which ? eventi.which : eventi.charCode;
	if (keyCode == 13) {
		if ((npg > <%= rst.PageCount %>) || (npg == 0)){
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
		document.frm.action='processo_anda_result.asp';
		document.frm.atual.value=num;
		document.frm.filtrar.value='<%= Request("filtrar") %>';
		document.frm.submit();
	}else{
		alert('Esse campo só aceita digitos.');
	}
}

function marcar() {
	var i;
	for (i=0;i<document.frm.elements.length;i++){
		//alert(document.frm.elements[i].name.substr(0, 5))
		if (document.frm.elements[i].name.substr(0, 5) == "nproc"){
			if (document.frm.elements[i].checked != marcado){
				marca_check(document.frm.elements[i].value);
			}
			document.frm.elements[i].checked = marcado;
		}
	}
	marcado = !marcado;
}

function filtrar(){
	if(document.frm.pmarcados.value != ""){
		document.frm.filtrar.value='ok';
		document.frm.resultado.value='';
		document.frm.vindo.value='';
		document.frm.atual.value=1;
		document.frm.pagAtual.value=1;		
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
		document.frm.action='processos_excluir.asp?vindo=2';
		document.frm.submit();
	}
	else{
		alert("Selecione pelo menos um processo.");
	}
}

function valida()
	{		
	return true;
	}
</script>

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

</script>
</body>
</html>
<%

'funções do filtro'
function RetornaTipoConculta(prmTipo)

	
	select case prmTipo

		case "p.processo"

			retorno = "Processo"

		case "p.pasta"

			retorno = "Pasta"

		case "o.data"
			retorno = "Data"

		case "p.situacao"
			retorno = "Situação"
	end select 

		RetornaTipoConculta = retorno 
		
end function

Function RetornaDescricaoOrdem(prmOrdem)

	
	select case prmOrdem
		case "ASC"
			retorno = "Crescente"
		case "DESC"
			retorno = "Decrescente"
	end select
	RetornaDescricaoOrdem =  retorno 

end function
'função para exibir Tipo Processo'
Function TipoProcesso (prmTipoProcesso)

	select case prmTipoProcesso

	case ""
		retorno = ""

	case "J" 
		retorno = "Judicial"

	case "A"
		retorno = "Administrativo"

	end select
		TipoProcesso = retorno

end function
'função para exibir oculto ou não'
Function FuncaoOculto(prmOculto)
	select case prmOculto
	
	case "on"
		retorno = "Oculto"


	end select

	FuncaoOculto = retorno

end function
'-----------------------------------------------------------------------------'
Function FunCompetencia(prmCompetencia)
	
	select case prmCompetencia
	
	case "F"
		retorno = "Federal"

	case "E"
		retorno = "Estadual"

	case "M"
		retorno = "Municipal"
	end select

	FunCompetencia = retorno

end function
'------------------------------------------------------------------------------'
function FuncTipoEnvolvido(frmTipoenvolvido)

	set rsTipoEnvolvido = conn.execute("Select nome_tipo_env from Tipo_Envolvido where usuario = '"&Session("vinculado")&"' and contencioso = 1 and id_tipo_env = "&frmTipoenvolvido&" order by nome_tipo_env ")

		if not rsTipoEnvolvido.eof then 

			retorno = rsTipoEnvolvido("nome_tipo_env")

			else 
			retorno = ""

		end if 

		FuncTipoEnvolvido = retorno

end function

'---------------------------------------------------------------------------'
'função que busca o envolvido '
function FuncEnvolvido(frmEnvolvido)

	set rsEnvolvido = conn.execute("select apelido from Envolvidos where usuario= '"&Session("vinculado")&"'and id="&frmEnvolvido&" order by apelido")

	if not rsEnvolvido.eof  then 

		retorno = rsEnvolvido("apelido")

	else 
		retorno =""
	end if 

	FuncEnvolvido = retorno
	
end function

function FuncPosicao(frmPosicao)

	select case frmPosicao
		case "A"

		retorno = "Autor"

		case "R"

		retorno = "Réu"

	end select

		FuncPosicao = retorno

end function

function FuncResponsavel(frmResponsavel)
		
		SET rsResponsavel = conn.execute("Select id, nome from responsaveis where tipo <> 'cliente' and usuario = '"&Session("vinculado")&"' and id="&frmResponsavel&" order by nome")

		if not rsResponsavel.EOF then 

			retorno = rsResponsavel("nome")
			
			else 
				retorno = ""	

		end if
		FuncResponsavel = retorno
End function
%>