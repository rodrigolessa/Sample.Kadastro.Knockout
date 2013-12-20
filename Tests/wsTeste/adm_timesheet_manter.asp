<%@  language="VBScript" %>
<%
	'Option Explicit
%>
<%
	Dim lista_pg
	lista_pg = "PG-RES"
%>
<!--#include file="include/funcoes.asp"-->
<!--#include file="include/conn.asp"-->
<!--#include file="usuario_logado.asp"-->
<%
	Response.Charset = "ISO-8859-1"
	Response.CacheControl="no-cache"
	Response.AddHeader "Pragma","no-cache"
	Response.Expires = 0
	Response.Buffer = True

	menu_onde = "div"

	Session("local_voltar") = ""

	if (not Session("adm_cons_checagem")) and (not Session("adm_adm_sys")) then
		bloqueia
		response.end
	end if
%>

<!DOCTYPE html>

<html>

	<head>

		<title>APOL Administração | Lançamentos</title>

		<meta name="description" content="APOL Administração" />

		<!--Google+ Metadata /-->
		<meta itemprop="name" content="Apol" />
		<meta itemprop="description" content="Apol, Marca, Patente" />
		<meta name="Keywords" content="Apol, Marca, Patente" />

		<script src="../js/libs/modernizr-2.6.2.js"></script>

		<link rel="stylesheet" type="text/css" href="modcomum/style.css">
		<link rel="stylesheet" type="text/css" href="adm/css/jquery-ui-1.10.3.custom.css">

		<style type="text/css">
			body
			{
				margin-left: 0;
				margin-top: 0;
			}
		</style>

	</head>

	<body leftmargin="0" topmargin="0" style="overflow-x:hidden">

		<!-- CABEÇALHO PADRÃO DO MÓDULO ADMINISTRATIVO //-->
		<!--#include file="modcomum\header.asp"-->

		<table width="770" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td>

				<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td height="16" valign="middle"><img src="imagem/tit_le.gif" width="19" height="18"></td>
					<td height="16" valign="middle" class="titulo" nowrap data-bind="text: lblTitulo"></td>
					<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
					<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
				</tr>
				</table>

			</td>
		</tr>

		<tr>
			<td bgcolor="#efefef">

				<table class="preto11" cellpadding="2" cellspacing="2" border="0" style="margin-top:10px;margin-left:20px;width:90%;">

				<!-- FORMULÁRIO PRINCIPAL DE CADASTRO //-->
				<form id="frmTimeSheet" name="frmTimeSheet" method="post">
				<input type="hidden" name="modulo" value="<%=request("modulo")%>">
				<input type="hidden" name="id" value="<%=request("id")%>">

				<tr>
					<td>Módulo:</td>
					<td colspan="5">
						<select class="cfrm" id="modulo" name="modulo" data-bind="options: $root.modulosDisponiveis, value: 'sigla', optionsText: 'descricao'"></select>
					</td>
				</tr>

				<tr>
					<td>Tipo:</td>
					<td>
						<select class="cfrm" id="tipo" name="tipo" data-bind="options: $root.tiposDisponiveis, value: 'sigla', optionsText: 'descricao'"></select>
						<img src="imagem/lupa_p.gif" border="0" title="Pesquisar Custos">
					</td>
					<td>Grupo:</td>
					<td>
						<input type="text" id="grupo" name="grupo" class="preto11" maxlength="2" style="width:20px;" />
					</td>
					<td>Item:</td>
					<td>
						<input type="text" id="custo" name="custo" class="preto11" maxlength="5" style="width:50px;" />
					</td>
				</tr>

				<tr>
					<td>Data de Lançamento:</td>
					<td colspan="5">
						<input type="text" data-bind="value: dataLancamento" class="cfrm date" />
					</td>
				</tr>

				<tr>
					<td>Título:</td>
					<td colspan="5">
						<input type="text" id="titulo" name="titulo" class="preto11" maxlength="50" style="width:450px;" data-bind="value: titulo" />
					</td>
				</tr>

				<tr>
					<td>Moeda:</td>
					<td colspan="5">
						<input type="text" id="moeda" name="moeda" class="preto11" maxlength="5" />
					</td>
				</tr>

				<tr>
					<td>Valor:</td>
					<td colspan="5">
						<input type="text" data-bind="value: valor" class="cfrm money" maxlength="10" />
					</td>
				</tr>

				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6" align="center">
						<button class="cfrm">Pesquisar</button>
						&nbsp;&nbsp;
						<button class="cfrm">Limpar</button>
					</td>
				</tr>
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>

				</form>

				</table>

			</td>
		</tr>
		</table>


		<!-- SCRIPTS COMUNS //-->
		<script src="js/libs/jquery-1.10.2.min.js"></script>
		<script src="js/libs/jquery-ui-1.10.3.custom.min.js"></script>
		<script src="js/libs/json2.js"></script>
		
		<script src="js/libs/knockout-2.2.1.js"></script>

		<script src="js/libs/jquery.mask.min.js"></script>

		<script src="js/libs/jquery.blockUI.js"></script>

		<script src="js/comuns.js"></script>

		<script src="js/extensions.js"></script>

		<script type="text/javascript">
			jQuery.ajax({
				type: "POST",
				url: "http://ld-rlessa.lcdinterno.com.br/timesheet/TimesheetServiceHost.svc?wsdl/Obter",
				data: "{'id':'1'}",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				async: false,
				success: function(jsonResult){
					if (jsonResult.d != ''){
						alert(jsonResult.d);
					}
				},
				error: function(msg){
				    alert(msg);
				}
			});
		</script>


		<!-- VIEW MODEL COM BINDINGS DA PÁGINA //-->
		<script src="js/ViewModel/ManterTimesheetViewModel.js"></script>

	</body>

</html>