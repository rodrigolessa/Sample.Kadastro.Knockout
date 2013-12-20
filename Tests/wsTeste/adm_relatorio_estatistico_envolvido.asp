<%@  language="VBScript" %>
<%
	'Option Explicit
%>
<%
	Dim lista_pg
	lista_pg = "PG-RES"

	'------------------------------------------------------------------------------------'
	'Declara as váriáveis de includes'
	Dim idioma, conn, conn_usu, conn_intra, DataSource, cnnSQLCLR, sql, rs_par, rs_pg, rst, ocorrencia_M, itp, cws, sem_timeout
	Dim campo1, campo2, campo3, campo1_adm_label, campo2_adm_label, campo1_marca_int, campo2_marca_int, campo1_processo_int, campo2_processo_int
	Dim campo1_dominios, campo2_dominios, rs_manut, manutencao, badChars, badChars1, dt2, menu_onde, num_versao
	Dim vdir, vdir2, vdirMovimentacao, vDirMovimentacaoImagem, pg_help, ds, data, sqlM, rsM, rshelp, versao_verifica
	Dim cadastro, pgh, bt_imprimir, bt_imprimir_tipo, bt_export, campo, fvalor, ncampo, bt_voltar, bt_editar, voltar_pesq
	Dim email_proc, tem_xls, altura, PDF, Download_PDF, sHTML, bGalo, bEtiqueta, fsoversao, MyFileversao, ReadLineTextFile
	'patente/include/conn_apol_pat.asp'
	Dim conn_pat, ocorrencia_P, campo_data
	'contencioso/db_open.asp'
	Dim db, ocorrencia_C
	'contrato/conn_v.asp'
	Dim conn_v, ocorrencia_V
%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/funcoes.asp"-->
<!--#include file="include/conn.asp"-->
<!--#include file='include/Db_open_usuarios.asp'-->
<!--#include file="patente/include/conn_apol_pat.asp"-->
<!--#include file="contencioso/db_open.asp"-->
<!--#include file="contrato/conn_v.asp"-->
<!--#include file="usuario_logado.asp"-->
<!--#include file="include/funcoes/fnConverteDataSQL.asp"-->
<!--#include file="include/funcoes/fnExecuteScalar.asp"-->
<%
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma","no-cache"
	Response.Expires = 0
	Response.Buffer = True

	Server.ScriptTimeout = 999

	if (not Session("adm_cons_checagem")) and (not Session("adm_adm_sys")) then
		bloqueia
		response.end
	end if

	'------------------------------------------------------------------------------------'
	'Declara as váriáveis da página'
	Dim paginaImpressao, tamanhoPagina, pagina, paginaAtual, linhaAtual, paginacao, ultimaPagina, totalEnvolvidos
	Dim rsEnv, sSQL, sSQLWhere
	Dim filApelido, filTipo, filTipoProcesso, filGrupo, filDataCadastro1, filDataCadastro2, filPasta, filCNPJ, filStatusEnvolvido, filPastaExata
	Dim logoUsuario, descricaoFiltros

	'------------------------------------------------------------------------------------'
	'Declara as váriáveis de resultado para os valores estatísticos'
	'Marca BR'
	Dim marcaBRTotal
	Dim marcaBRPropControlado, marcaBRPropAbandonado, marcaBRPropMorto, marcaBRPropAtivos, marcaBRPropDesativados, marcaBRPropPedido, marcaBRPropRegistro
	Dim marcaBRTercControlado, marcaBRTercAbandonado, marcaBRTercMorto, marcaBRTercAtivos, marcaBRTercDesativados, marcaBRTercPedido, marcaBRTercRegistro
	'Marca Int.'
	Dim marcaIntTotal
	Dim marcaIntPropControlado, marcaIntPropAbandonado, marcaIntPropMorto, marcaIntPropPedido, marcaIntPropRegistro
	Dim marcaIntTercControlado, marcaIntTercAbandonado, marcaIntTercMorto, marcaIntTercPedido, marcaIntTercRegistro
	'Marca Domínio.'
	Dim dominioTotal, dominioAtivo, dominioInativo
	'Patente BR'
	Dim patenteBRTotal
	Dim patenteBRPropControlado, patenteBRPropAbandonado, patenteBRPropMorto, patenteBRPropAtivos, patenteBRPropDesativados, patenteBRPropPedido, patenteBRPropRegistro
	Dim patenteBRTercControlado, patenteBRTercAbandonado, patenteBRTercMorto, patenteBRTercAtivos, patenteBRTercDesativados, patenteBRTercPedido, patenteBRTercRegistro
	'Patente Int.'
	Dim patenteIntTotal
	Dim patenteIntPropControlado, patenteIntPropAbandonado, patenteIntPropMorto, patenteIntPropPedido, patenteIntPropConcedido
	Dim patenteIntTercControlado, patenteIntTercAbandonado, patenteIntTercMorto, patenteIntTercPedido, patenteIntTercConcedido
	'Contrato e Contencioso'
	Dim contratoTotal, contenciosoTotal
	Dim contratoAtivos, contratoCancelados, contratoExpirados, contratoPendentes, contratoSemStatus
	Dim contenciosoAtivos, contenciosoEncerrados, contenciosoAcordos, contenciosoInativos, contenciosoSemSituacao

	'------------------------------------------------------------------------------------'
	'Controla a exibição da página para a versão de impressão'
	if Request("imprimir") = "" then
		paginaImpressao = false
		menu_onde = "div"
	elseif Request("imprimir") = "S" then
		paginaImpressao = true
	else
		paginaImpressao = false
	end if

	tamanhoPagina = 2
	if paginaImpressao then
		tamanhoPagina = 99999
	end if

	if Len(Trim(Request("pagina"))) > 0 and IsNumeric(Trim(Request("pagina"))) then
		pagina = CInt(Trim(Request("pagina")))
	else
		pagina = 1
	end if
	paginaAtual = 1
	linhaAtual = 0
	ultimaPagina = 1

	'------------------------------------------------------------------------------------'
	'Recupera os parametros do formulário de filtro'
	filApelido = tplic(0, Trim(Request("apelido")))
	filTipo = tplic(0, Trim(Request("tipo")))
	filTipoProcesso = tplic(0, Trim(Request("tproc")))
	filGrupo = tplic(0, Trim(Request("grupo")))
	filDataCadastro1 = tplic(0, Trim(Request("cadastro_de")))
	filDataCadastro2 = tplic(0, Trim(Request("cadastro_ate")))
	filPasta = tplic(0, Trim(Request("pasta")))
	filPastaExata = tplic(0, Trim(Request("pastaexata")))
	filCNPJ = tplic(0, Trim(Request("cnpj_cpf")))
	filStatusEnvolvido = tplic(0, Trim(Request("statusEnvolvido")))

	'------------------------------------------------------------------------------------'
	descricaoFiltros = ""

	if pagina = 1 then

		Session("local_voltar") = ("adm_relatorio_estatistico_envolvido")
		Session("local_filtro") = ("adm_relatorio_estatistico_envolvido_filtro.asp?" & _
			"apelido=" & filApelido & _
			"&tipo=" & filTipo & _
			"&tproc=" & filTipoProcesso & _
			"&grupo=" & filGrupo & _
			"&cadastro_de=" & filDataCadastro1 & _
			"&cadastro_ate=" & filDataCadastro2 & _
			"&pasta=" & filPasta & _
			"&pastaexata=" & filPastaExata & _
			"&cnpj_cpf=" & filCNPJ & _
			"&statusEnvolvido=" & filStatusEnvolvido)

	else

		Session("local_voltar") = ""

	end if

	'------------------------------------------------------------------------------------'
	'Filtros'
	sSQLWhere =	""

	if len(filApelido) > 0 then
		sSQLWhere = sSQLWhere & " AND e.apelido LIKE '%" & filApelido & "%' "
	end if

	if len(filTipo) > 0 then
		sSQLWhere = sSQLWhere & " AND EXISTS (SELECT ret.id_rel FROM Rel_Env_Tipo ret WHERE ret.id_env = e.id AND ret.id_tipo_env = '" & filTipo & "') "
	end if

	'if len(filTipoProcesso) > 0 then
	'end if

	if len(filGrupo) > 0 then
		sSQLWhere = sSQLWhere & " AND e.grupo LIKE '%" & filGrupo & "%' "
	end if

	if len(filDataCadastro1) > 0 then
		sSQLWhere = sSQLWhere & " AND e.dt_cadastro >= '" & fnConverteDataSQL(filDataCadastro1) & "' "
	end if

	if len(filDataCadastro2) > 0 then
		sSQLWhere = sSQLWhere & " AND e.dt_cadastro <= '" & fnConverteDataSQL(filDataCadastro2) & "' "
	end if

	if len(filPasta) > 0 then
		if filPastaExata = "0" then
			sSQLWhere = sSQLWhere & " AND e.pasta = '" & filPasta & "' "
		else
			sSQLWhere = sSQLWhere & " AND e.pasta LIKE '%" & filPasta & "%' "
		end if
	end if

	if len(filCNPJ) > 0 then
		sSQLWhere = sSQLWhere & " AND e.cnpj_cpf = '" & filCNPJ & "' "
	end if

	if len(filStatusEnvolvido) > 0 then
		sSQLWhere = sSQLWhere & " AND e.statusEnvolvido = '" & filStatusEnvolvido & "' "
	end if

	'------------------------------------------------------------------------------------'
	'Consulta'
	sSQL =	"SELECT " & _
			"	  e.id " & _
			"	, e.apelido " & _
			"	, e.pasta " & _
			"	, e.email " & _
			"	, e.dt_cadastro " & _
			"	, CASE e.statusEnvolvido WHEN 'N' THEN 'Não efetivo' WHEN 'P' THEN 'Perspectiva' ELSE 'Efetivo' END AS descStatusEnvolvido " & _
			"	, stuff( " & _
			"		(SELECT ', ' + te.nome_tipo_env " & _
			"			FROM Rel_Env_Tipo ret  " & _
			"			INNER JOIN Tipo_Envolvido te ON ret.id_tipo_env = te.id_tipo_env  " & _
			"			WHERE ret.id_env = e.id " & _
			"			ORDER BY te.nome_tipo_env " & _
			"			for XML path('')), 1, 1, '' " & _
			"	) AS descTipoEnvolvido " & _
			"FROM Envolvidos e " & _
			"WHERE e.usuario = '" & Session("vinculado") & "' " & sSQLWhere & _
			"ORDER BY e.apelido "

	'------------------------------------------------------------------------------------'
	'Executa consulta'
	Set rsEnv = server.CreateObject("ADODB.Recordset")
		rsEnv.PageSize = tamanhoPagina
		rsEnv.CacheSize = tamanhoPagina

	'response.write "<br />" & sSQL & "<br />"

	rsEnv.Open sSQL, conn, 3, 3
	'------------------------------------------------------------------------------------'
	if NOT rsEnv.EOF then

		ultimaPagina = rsEnv.PageCount
		totalEnvolvidos = rsEnv.RecordCount

		'Exibe link para versão de impressão'
		bt_imprimir = true
		bt_export = false

	end if
%>
<html>

	<head>

		<title>APOL Administração | Relatório estatístico por envolvido</title>
		<link HREF="modcomum/style.css" type="text/css" REL="STYLESHEET">
		<style type="text/css">

<%
	if NOT paginaImpressao then
%>

			@media screen {

				body
				{
					margin-left: 0;
					margin-top: 0;
					font-size: 100%;
				}

				.listaEstatistica, .listaEstatisticaTitulo {
					font-weight: normal;
					font-family: Verdana;
					font-size: 11px;
				    border-spacing:1px;
				    border-collapse:separate;
				}

				.listaEstatisticaTitulo th {
					font-weight: normal;
					background-color: #333333;
					color: #fff;
					text-align: left;
					padding: 8px;
				}

				.listaEstatistica th {
					background-color: #CCCCCC;
					font-weight: normal;
					color: #000;
					text-align: left;
					padding: 3px;
				}

				.listaEstatistica td {
					background-color: #EFEFEF;
					text-align: center;
					padding: 3px;
				}

				.estatisticaSubTitulo {
					font-weight: bold;
				}

				.listaNula{
					font-weight: normal;
					font-family: Verdana;
					font-size: 11px;
				}

				.listaNula th {
					font-weight: normal;
					background-color: #EFEFEF;
					color: #000;
					text-align: center;
					padding: 20px;
				}

				.linhaBase{
					padding: 3px;
					border-top: 1px solid #000;
				}

			}

<%
	else
%>

				body
				{
					margin-left: 0;
					margin-top: 0;
					font-size: 100%;
					-webkit-print-color-adjust:exact;
				}

				.listaEstatistica, .listaEstatisticaTitulo {
					font-weight: normal;
					font-family: Arial;
					font-size: 10px;
				    border-spacing:0;
				    border-collapse:collapse;
				}

				.listaEstatisticaTitulo th {
					text-align: left;
					padding-top: 8px;
					padding-bottom: 4px;
					border-top: 2px solid #B2B2B2;
				}

				.listaEstatistica th {
					text-align: left;
					padding: 1px;
					border-bottom: 1px solid #B2B2B2;
					border-left: 1px dotted #B2B2B2;
				}

				.listaEstatistica td {
					text-align: center;
					padding: 1px;
					border-bottom: 1px solid #B2B2B2;
					border-left: 1px dotted #B2B2B2;
					border-right: 1px dotted #B2B2B2;
				}

				.linhaTotal{
					font-weight: bold;
					font-family: Arial;
					font-size: 11px;
					border-top: 1px solid #000;
					border-bottom: 1px solid #000;
					padding:8px;
				}

<%
	end if
%>

		</style>
		<script language="JavaScript" src="include/jquery-1.4.2.min.js" type="text/javascript"></script>
		<script language="JavaScript" src="include/funcoes.js"></script>
		<script language="Javascript">

			function handleEnter(field, eventi, npg) {
				var keyCode = eventi.keyCode ? eventi.keyCode : eventi.which ? eventi.which : eventi.charCode;
				if (keyCode == 13) {
					if ((npg > <%=ultimaPagina%>) || (npg == 0)){
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
					document.frmRelatorio.pagina.value=num;
					document.frmRelatorio.envia.value='ok';
					document.frmRelatorio.submit();
				}else{
					alert('Esse campo só aceita digitos.');
				}
			}

			function mprox(){
				document.frmRelatorio.action="adm_relatorio_estatistico_envolvido.asp"
				document.frmRelatorio.pagina.value=<%=(pagina + 1)%>;
				document.frmRelatorio.submit();
			}
				
			function multi(){
				document.frmRelatorio.action="adm_relatorio_estatistico_envolvido.asp"
				document.frmRelatorio.pagina.value=<%=ultimaPagina%>;
				document.frmRelatorio.submit();
			}

			function mante(){
				document.frmRelatorio.action="adm_relatorio_estatistico_envolvido.asp"
				document.frmRelatorio.pagina.value=<%=(pagina - 1)%>;
				document.frmRelatorio.submit();
			}
				
			function mprim(){
				document.frmRelatorio.action="adm_relatorio_estatistico_envolvido.asp"
				document.frmRelatorio.pagina.value=1;
				document.frmRelatorio.submit();
			}
		</script>

	</head>

	<body leftmargin="0" topmargin="0" style="overflow-x:hidden">
<%
	if NOT paginaImpressao then

		'Request dos dados postados pelo filtro'
		bt_imprimir_tipo = "get"
%>
	<!--#include file="modcomum\header.asp"-->
<%
	end if
%>
	<table width="770" cellpadding="0" cellspacing="0" border="0">

	<form name="frmRelatorio" id="frmRelatorio" method="get" action="adm_relatorio_estatistico_envolvido.asp">
		<input type="hidden" name="pmarcados" value="">
		<input type="hidden" name="filtrar" value="">
		<input type="hidden" name="envia" value="">
		<input type="hidden" name="pagina" value="<%=pagina%>">
		<input type="hidden" name="ordem" value="">
		<input type="hidden" name="tipo_func" value="">
		<input type="hidden" name="volta" value="0">
<%
	for each campo in request.querystring
		If (campo <> "pg") and (campo <> "pagina") and (campo <> "envia") and (instr(campo, "env") = 0) and (campo <> "ordem") and (campo <> "pmarcados") and (campo <> "filtrar") and (campo <> "tipo_func") and (campo <> "volta") then 
%>
		<input type="hidden" name="<%=campo%>" value="<%=request(campo)%>">
<%
		End If
	next 
%>

	<tr>
		<td>
<%
	if paginaImpressao then

		logoUsuario = fnExecuteScalar("SELECT logotipo FROM usuario WHERE vinculado = '" & session("vinculado") & "' AND nomeusu = '" & session("vinculado") & "'", conn_usu)
%>
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td><img src="logo_cliente/<%=logoUsuario%>" height="100" border="0"></td>
				<td align="right" valign="top" class="preto11"><%=now()%></td>
			</tr>
			</table>
<%
	end if
%>
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
				<td height="16" valign="middle" class="titulo" nowrap>Relatório Estatístico por Envolvido &nbsp;</td>
				<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
				<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
			</tr>
			</table>

		</td>
	</tr>

	<tr>
		<td>
<%
	if NOT rsEnv.EOF then

		'Valida número de página selecionado'
		if NOT pagina = "" and isnumeric(pagina) then
			if(ultimaPagina >= cint(pagina) and (cint(pagina) > 0)) then
				paginaAtual = cint(pagina)
			end if
		end if

		rsEnv.AbsolutePage = paginaAtual

		'------------------------------------------------------------------------------------'
		'Exibe controle de paginação, Se não for Versão de Impressão'
		if NOT paginaImpressao then
%>
			<table bgcolor="#FFFFFF" width="100%" class="preto11" border="0" cellpadding="0" cellspacing="0" style="padding: 3px;">
			<tr>
				<td width="30%"><b>Envolvidos = <%=totalEnvolvidos%></b></td>
				<td width="50%">&nbsp;</td>
<%
			'Controle anterior'
			If paginaAtual > 1 then
%>
				<td align="right">
					<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><a href="javascript: mprim()"><img src="imagem/setas_navegacao_04.gif" alt="Primeira Página" border="0"></a></td>
						<td><a href="javascript: mante()"><img src="imagem/setas_navegacao_02.gif" alt="Página Anterior" border="0"></a></td>
					</tr>
					</table>
				</td>
<%
			Else
%>
				<td align="right">
					<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><img src="imagem/setas_navegacao_04_desat.gif" border="0"></td>
						<td><img src="imagem/setas_navegacao_02_desat.gif" border="0"></td>
					</tr>
					</table>
				</td>
<%
			End If
%>
				<td align="center" width="10%">
					<b>
						<input type="text" name="pg_escolha" size="3" maxlength="4" onkeypress="return handleEnter(this, event, this.value)" class="cfrm" onfocus="this.select()" style="text-align: center; font-weight: bold;" value="<%=paginaAtual%>">&nbsp;de&nbsp;<%=ultimaPagina%>
					</b>
				</td>
<%
			'Controle próximo'
			If paginaAtual < ultimaPagina then
%>
				<td align="right">
					<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><a href="javascript: mprox()"><img src="imagem/setas_navegacao_12.gif" alt="Próxima Página" border="0"></a></td>
						<td><a href="javascript: multi()"><img src="imagem/setas_navegacao_10.gif" alt="Última Página" border="0"></a></td>
					</tr>
					</table>
				</td>
<%
			Else
%>
				<td align="right">
					<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><img src="imagem/setas_navegacao_12_desat.gif" border="0"></td>
						<td><img src="imagem/setas_navegacao_10_desat.gif" border="0"></td>
					</tr>
					</table>
				</td>
<%
			End If
%>
			</tr>
			</table>
<%
		end if

		'------------------------------------------------------------------------------------'
		'Exibe quando houver resultados e no limite de linhas por página'
		do while NOT rsEnv.EOF and (linhaAtual < tamanhoPagina)

			'Variáveis da consulta para as informações do ENVOLVIDO'
			'--------------------------------------------------------------------------------
			envID = rsEnv("id")


			'Chamada de procedimento para calcular os totais por envolvido'
			'--------------------------------------------------------------------------------
			SET  cmd = Server.CreateObject("ADODB.Command")
			with cmd

				'Utiliza a conexão com o Apol, onde o procedimento foi criado
				.ActiveConnection = conn
				.CommandType = adCmdStoredProc
				.CommandText = "dbo.Spr_EstatisticaPorEnvolvidos" ' nome da Stored Procedure

				'Adiciona parametro do nome do usuário logado
				.Parameters.Append .CreateParameter("@usuario", adVarChar, adParamInput, 50)
				.Parameters("@usuario") = Session("vinculado")

				'Adiciona parametro do código do envolvido
				.Parameters.Append .CreateParameter("@id_envolvido", adInteger, adParamInput)
				.Parameters("@id_envolvido") = rsEnv("id")

				'AdicionaAdd a integer parameter, then pass the value of the variable userID to it
				.Parameters.Append .CreateParameter("@tipo_processo", adInteger, adParamInput)
				if Len(Trim(filTipoProcesso)) = 1 then
					.Parameters("@tipo_processo") = CInt(filTipoProcesso)
				else
					.Parameters("@tipo_processo") = VBNULL
				end if

				'Executa o procedimento
				SET rsTotais = .Execute

			end with

			'Clean up
			SET cmd = nothing

			if NOT rsTotais.EOF then
%>

			<table width="100%" class="listaEstatisticaTitulo">
			<thead>
				<tr>
					<th>
						<strong><%=rsEnv("apelido")%></strong>
						-
						Situação: <%=rsEnv("descStatusEnvolvido")%>
						-
						<span class="tipoLabel">Tipo(s): </span><%=rsEnv("descTipoEnvolvido")%>
					</th>
				</tr>
			</thead>
			</table>

			<!-- Marca BR //-->

			<table width="100%" class="listaEstatistica">
				<thead>
				<tr>
					<th colspan="8">
						<strong>
							Marca BR = <%=rsTotais("marcaBRTotal")%>
						</strong>
					</th>
				</tr>
				</thead>
				<tbody>
				<tr>
					<td>&nbsp;</td>
					<td>Controlado</td>
					<td>Abandonado</td>
					<td>Morto</td>

					<td>Pedido</td>
					<td>Registro</td>

					<td>Ativos</td>
					<td>Desativados</td>
				</tr>
<%
			if filTipoProcesso = "0" or len(filTipoProcesso) = 0 then
%>
				<tr>
					<td>P</td>
					<td><%=rsTotais("marcaBRPropControlado")%></td>
					<td><%=rsTotais("marcaBRPropAbandonado")%></td>
					<td><%=rsTotais("marcaBRPropMorto")%></td>

					<td><%=rsTotais("marcaBRPropPedido")%></td>
					<td><%=rsTotais("marcaBRPropRegistro")%></td>

					<td><%=rsTotais("marcaBRPropAtivos")%></td>
					<td><%=rsTotais("marcaBRPropDesativados")%></td>
				</tr>
<%
			end if

			if filTipoProcesso = "1" or len(filTipoProcesso) = 0 then
%>
				<tr>
					<td>3º</td>
					<td><%=rsTotais("marcaBRTercControlado")%></td>
					<td><%=rsTotais("marcaBRTercAbandonado")%></td>
					<td><%=rsTotais("marcaBRTercMorto")%></td>

					<td><%=rsTotais("marcaBRTercPedido")%></td>
					<td><%=rsTotais("marcaBRTercRegistro")%></td>

					<td><%=rsTotais("marcaBRTercAtivos")%></td>
					<td><%=rsTotais("marcaBRTercDesativados")%></td>
				</tr>
				</tbody>
<%
			end if
%>
				<!-- Marca Internacional e Domínio //-->
				<thead>
				<tr>
					<th colspan="6">
						<strong>
							Marca Int. = <%=rsTotais("marcaIntTotal")%>
						</strong>
					</th>
					<th colspan="2">
						<strong>
							Domínio = <%=rsTotais("dominioTotal")%>
						</strong>
					</th>
				</tr>
				</thead>
				<tbody>
				<tr>
					<td>&nbsp;</td>
					<td>Controlado</td>
					<td>Abandonado</td>
					<td>Morto</td>
					
					<td>Pedido</td>
					<td>Registro</td>

					<td>Ativo</td>
					<td>Inativo</td>
				</tr>
<%
			if filTipoProcesso = "0" or len(filTipoProcesso) = 0 then
%>
				<tr>
					<td>P</td>
					<td><%=rsTotais("marcaIntPropControlado")%></td>
					<td><%=rsTotais("marcaIntPropAbandonado")%></td>
					<td><%=rsTotais("marcaIntPropMorto")%></td>
					
					<td><%=rsTotais("marcaIntPropPedido")%></td>
					<td><%=rsTotais("marcaIntPropRegistro")%></td>

					<td><%=rsTotais("dominioAtivo")%></td>
					<td><%=rsTotais("dominioInativo")%></td>
				</tr>
<%
			end if

			if filTipoProcesso = "1" or len(filTipoProcesso) = 0 then
%>
				<tr>
					<td>3º</td>
					<td><%=rsTotais("marcaIntTercControlado")%></td>
					<td><%=rsTotais("marcaIntTercAbandonado")%></td>
					<td><%=rsTotais("marcaIntTercMorto")%></td>

					<td><%=rsTotais("marcaIntTercPedido")%></td>
					<td><%=rsTotais("marcaIntTercRegistro")%></td>

					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				</tbody>
<%
			end if
%>
				<!-- Patente BR //-->
				<thead>
				<tr>
					<th colspan="8">
						<strong>
							Patente BR = <%=rsTotais("patenteBRTotal")%>
						</strong>
					</th>
				</tr>
				</thead>
				<tbody>
				<tr>
					<td>&nbsp;</td>
					<td>Controlado</td>
					<td>Abandonado</td>
					<td>Morto</td>

					<td>Pedido</td>
					<td>Concedido</td>

					<td>Ativos</td>
					<td>Desativados</td>
				</tr>
<%
			if filTipoProcesso = "0" or len(filTipoProcesso) = 0 then
%>
				<tr>
					<td>P</td>
					<td><%=rsTotais("patenteBRPropControlado")%></td>
					<td><%=rsTotais("patenteBRPropAbandonado")%></td>
					<td><%=rsTotais("patenteBRPropMorto")%></td>

					<td><%=rsTotais("patenteBRPropPedido")%></td>
					<td><%=rsTotais("patenteBRPropRegistro")%></td>

					<td><%=rsTotais("patenteBRPropAtivos")%></td>
					<td><%=rsTotais("patenteBRPropDesativados")%></td>
				</tr>
<%
			end if

			if filTipoProcesso = "1" or len(filTipoProcesso) = 0 then
%>
				<tr>
					<td>3º</td>
					<td><%=rsTotais("patenteBRTercControlado")%></td>
					<td><%=rsTotais("patenteBRTercAbandonado")%></td>
					<td><%=rsTotais("patenteBRTercMorto")%></td>

					<td><%=rsTotais("patenteBRTercPedido")%></td>
					<td><%=rsTotais("patenteBRTercRegistro")%></td>

					<td><%=rsTotais("patenteBRTercAtivos")%></td>
					<td><%=rsTotais("patenteBRTercDesativados")%></td>
				</tr>
				</tbody>
<%
			end if
%>
				<!-- Patente Internacional //-->
				<thead>
				<tr>
					<th colspan="8">
						<strong>
							Patente Int. = <%=rsTotais("patenteIntTotal")%>
						</strong>
					</th>
				</tr>
				</thead>
				<tbody>
				<tr>
					<td>&nbsp;</td>
					<td>Controlado</td>
					<td>Abandonado</td>
					<td>Morto</td>

					<td>Pedido</td>
					<td>Concedido</td>

					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
<%
			if filTipoProcesso = "0" or len(filTipoProcesso) = 0 then
%>
				<tr>
					<td>P</td>
					<td><%=rsTotais("patenteIntPropControlado")%></td>
					<td><%=rsTotais("patenteIntPropAbandonado")%></td>
					<td><%=rsTotais("patenteIntPropMorto")%></td>

					<td><%=rsTotais("patenteIntPropPedido")%></td>
					<td><%=rsTotais("patenteIntPropConcedido")%></td>

					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
<%
			end if

			if filTipoProcesso = "1" or len(filTipoProcesso) = 0 then
%>
				<tr>
					<td>3º</td>
					<td><%=rsTotais("patenteIntTercControlado")%></td>
					<td><%=rsTotais("patenteIntTercAbandonado")%></td>
					<td><%=rsTotais("patenteIntTercMorto")%></td>

					<td><%=rsTotais("patenteIntTercPedido")%></td>
					<td><%=rsTotais("patenteIntTercConcedido")%></td>

					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				</tbody>
			</table>
<%
			end if
%>
			<!-- Contrato e Jurídico //-->
			<table width="100%" class="listaEstatistica">
				<thead>
				<tr>
					<th colspan="6">
						<strong>
							Contrato = <%=rsTotais("contratoTotal")%>
						</strong>
					</th>
					<th colspan="5">
						<strong>
							Contencioso = <%=rsTotais("contenciosoTotal")%>
						</strong>
					</th>
				</tr>
				</thead>
				<tbody>
				<tr>
					<td>&nbsp;</td>
					<td>Ativos</td>
					<td>Cancelados</td>
					<td>Expirados</td>
					<td>Pendentes</td>
					<td nowrap>Sem Status</td>
					<td>Ativos</td>
					<td>Encerrados</td>
					<td>Acordos</td>
					<td>Inativos</td>
					<td nowrap>Sem Situação</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><%=rsTotais("contratoAtivos")%></td>
					<td><%=rsTotais("contratoCancelados")%></td>
					<td><%=rsTotais("contratoExpirados")%></td>
					<td><%=rsTotais("contratoPendentes")%></td>
					<td><%=rsTotais("contratoSemStatus")%></td>
					<td><%=rsTotais("contenciosoAtivos")%></td>
					<td><%=rsTotais("contenciosoEncerrados")%></td>
					<td><%=rsTotais("contenciosoAcordos")%></td>
					<td><%=rsTotais("contenciosoInativos")%></td>
					<td><%=rsTotais("contenciosoSemSituacao")%></td>
				</tr>
				</tbody>
			</table>

			<br />
<%
			end if

				rsTotais.Close
			SET rsTotais = Nothing

			rsEnv.MoveNext

			'Controla as linha para não exibir mais que o tamanho definido para a página'
			linhaAtual = linhaAtual + 1

			Response.Flush

		loop

		'------------------------------------------------------------------------------------'
		'Exibe controle de paginação, Se não for Versão de Impressão'
		if NOT paginaImpressao then
%>
			<table bgcolor="#FFFFFF" width="100%" class="preto11 linhaBase" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="30%"><b>Envolvidos = <%=totalEnvolvidos%></b></td>
				<td width="50%">&nbsp;</td>
<%
			'Controle anterior'
			If paginaAtual > 1 then
%>
				<td align="right">
					<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><a href="javascript: mprim()"><img src="imagem/setas_navegacao_04.gif" alt="Primeira Página" border="0"></a></td>
						<td><a href="javascript: mante()"><img src="imagem/setas_navegacao_02.gif" alt="Página Anterior" border="0"></a></td>
					</tr>
					</table>
				</td>
<%
			Else
%>
				<td align="right">
					<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><img src="imagem/setas_navegacao_04_desat.gif" border="0"></td>
						<td><img src="imagem/setas_navegacao_02_desat.gif" border="0"></td>
					</tr>
					</table>
				</td>
<%
			End If
%>
				<td align="center" width="10%">
					<b>
						<input type="text" name="pg_escolha" size="3" maxlength="4" onkeypress="return handleEnter(this, event, this.value)" class="cfrm" onfocus="this.select()" style="text-align: center; font-weight: bold;" value="<%=paginaAtual%>">&nbsp;de&nbsp;<%=ultimaPagina%>
					</b>
				</td>
<%
			'Controle próximo'
			If paginaAtual < ultimaPagina then
%>
				<td align="right">
					<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><a href="javascript: mprox()"><img src="imagem/setas_navegacao_12.gif" alt="Próxima Página" border="0"></a></td>
						<td><a href="javascript: multi()"><img src="imagem/setas_navegacao_10.gif" alt="Última Página" border="0"></a></td>
					</tr>
					</table>
				</td>
<%
			Else
%>
				<td align="right">
					<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td><img src="imagem/setas_navegacao_12_desat.gif" border="0"></td>
						<td><img src="imagem/setas_navegacao_10_desat.gif" border="0"></td>
					</tr>
					</table>
				</td>
<%
			End If
%>
			</tr>
			</table>
<%
		end if

		if paginaImpressao then
%>
			<div class="linhaTotal">
				<strong>Total: <%=totalEnvolvidos%></strong>
			</div>
<%
		end if

	else
			'------------------------------------------------------------------------------------'
			'A consulta não retornou resultados'
%>
			<table width="100%" class="listaNula">
			<thead>
				<tr>
					<th>
						<strong>Não foi encontrado nenhum resultado.</strong>
					</th>
				</tr>
			</thead>
			</table>
<%
	end if

	Set rsEnv = Nothing
%>
		</td>
	</tr>

	</form>

	</table>

	</body>

</html>