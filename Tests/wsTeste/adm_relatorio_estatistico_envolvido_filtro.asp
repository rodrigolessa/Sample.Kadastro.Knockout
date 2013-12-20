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
<!--#include file="include/funcoes/fnExecuteScalar.asp"-->
<%
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

	'------------------------------------------------------------------------------------'
	'Recupera os parametros do formulário de filtro'
	filApelido = Trim(Request("apelido"))
	filTipo = Trim(Request("tipo"))
	filTipoDefault = ""
	filTipoProcesso = Trim(Request("tproc"))
	filGrupo = Trim(Request("grupo"))
	filDataCadastro1 = Trim(Request("cadastro_de"))
	filDataCadastro2 = Trim(Request("cadastro_ate"))
	filPasta = Trim(Request("pasta"))
	filPastaExata = Trim(Request("pastaexata"))
	filCNPJ = Trim(Request("cnpj_cpf"))
	filStatusEnvolvido = Trim(Request("statusEnvolvido"))

	filTipoDefault = fnExecuteScalar("SELECT MIN(id_tipo_env) AS codTipo FROM Tipo_Envolvido WHERE usuario = '"&session("vinculado")&"' AND nome_tipo_env LIKE '%Cliente%'", conn)

	if len(filTipo) = 0 then
			filTipo = filTipoDefault
	elseif isNumeric(filTipo) then
		filTipo = cInt(filTipo)
	end if

	if len(filStatusEnvolvido) = 0 then
		filStatusEnvolvido = "E"
	end if
%>
<html>

	<head>

		<title>APOL Administração | Relatório estatístico por envolvido</title>
		<link HREF="modcomum/style.css" type="text/css" REL="STYLESHEET">
		<link href="adm/css/jquery-ui-1.10.3.custom.css" type="text/css" rel="stylesheet">	
		<style type="text/css">
			body
			{
				margin-left: 0;
				margin-top: 0;
			}
		</style>

		<script language="JavaScript" src="include/funcoes.js"></script>
		<script language="JavaScript" src="adm/js/jquery-1.4.4.min.js" type="text/javascript"></script>
		<script language="JavaScript" src="adm/js/jquery-ui-1.8.9.custom.min.js" type="text/javascript"></script>
		<script language="JavaScript" src="adm/js/jquery.ui.datepicker-pt-BR.js" type="text/javascript"></script>
		<script language="JavaScript" src="adm/js/jquery.maskedinput-1.2.2.js" type="text/javascript"></script>	
		<script language="Javascript">

			function processando(){
				window.scroll(0,0);
				var txt_div = '<table width="100%" height="100%"><tr valign="middle"><td align="center"><img src="imagem/processando.gif" width="201" height="60"></td></tr></table>';
				jQuery('#processando_div').html(txt_div);
				jQuery('#processando_div').show();
			}

			//Valida o que foi informado nos campos de filtro
			function validarPost(){

				//Verificando filtros selecionados
				var filApelido = $('#apelido').val();
				var filTipo = $('#tipo').val();
				var filGrupo = $('#grupo').val();
				var filPasta = $('#pasta').val();
				var filCNPJ = $('#cnpj_cpf').val();
				var filStatus = $('#statusEnvolvido').val();
				var filDataCadastro1 = $('#cadastro_de').val();
				var filDataCadastro2 = $('#cadastro_ate').val();

				//Verifica se a primeira data é valida
				if(filDataCadastro1!=""){
					if (!doDate(filDataCadastro1,5)){
						alert("Preencha os campos corretamente.");
						$('#cadastro_de').focus();
						return false;
					}
				}

				//Verifica se a segunda data é valida
				if(filDataCadastro2!=""){
					if (!doDate(filDataCadastro2,5)){
						alert("Preencha os campos corretamente.");
						$('#cadastro_ate').focus();
						return false;
					}
				}

				//Valida intervalo de datas
				if((filDataCadastro1!="")&&(filDataCadastro2!="")){
					data1 = filDataCadastro1.split("/");
					data2 = filDataCadastro2.split("/");
					primeira = new Date(data1[2],data1[1],data1[0]);
					ultima = new Date(data2[2],data2[1],data2[0]);
					diferenca = ultima - primeira
					if(diferenca < 0){
						alert("Data inicial deve ser menor do que a data final de Cadastro.")
						$('#cadastro_de').focus();
						return false;
					}
				}

				if(filApelido!=""&&filApelido!=undefined){
					if(filApelido.length<3){
						alert('O campo "Apelido" deve conter no mínimo 3 caracteres.');
						$('#apelido').focus();
						return false;
					}
				}

				if((filApelido==""||filApelido==undefined)&&(filTipo==""||filTipo==undefined)&&(filGrupo==""||filGrupo==undefined)&&(filPasta==""||filPasta==undefined)&&(filCNPJ==""||filCNPJ==undefined)&&(filStatus==""||filStatus==undefined)&&(filDataCadastro1==""||filDataCadastro1==undefined)&&(filDataCadastro2==""||filDataCadastro2==undefined)){
					alert("Selecione pelo menos um filtro para pesquisa!");
					return false;
				}

				processando();
			}

			function limpar(){
				document.frmFiltro.apelido.value = "";
				document.frmFiltro.tipo.value = "<%=filTipoDefault%>";
				document.frmFiltro.tproc.value = "";
				document.frmFiltro.grupo.value = "";
				document.frmFiltro.cadastro_de.value = "";
				document.frmFiltro.cadastro_ate.value = "";
				document.frmFiltro.pasta.value = "";
				document.frmFiltro.pastaexata.checked = false;
				document.frmFiltro.cnpj_cpf.value = "";
				document.frmFiltro.statusEnvolvido.value = "E";
			}

		</script>

	</head>

	<body leftmargin="0" topmargin="0" style="overflow-x:hidden">

	<div id="processando_div" style="position: absolute; top: 1px; width: 99%; left: 1px; height:450px; display:none;"></div>

	<!--#include file="modcomum\header.asp"-->

	<table width="770" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td>

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
		<td bgcolor="#efefef">

			<table class="preto11" cellpadding="2" cellspacing="2" border="0" style="margin-left: 20px; width: 90%;">

			<form id="frmFiltro" name="frmFiltro" action="adm_relatorio_estatistico_envolvido.asp" method="get" onSubmit="JavaScript: return validarPost();">
			<input type="hidden" name="modulo" value="<%=request("modulo")%>">

			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td>Apelido:</td>
				<td><input type="text" name="apelido" id="apelido" maxlength="25" class="cfrm" value="<%=filApelido%>" style="width:200px;"></td>
				<td>Tipo:</td>
				<td>
<%
					set rs2 = conn.execute("SELECT * FROM Tipo_Envolvido WHERE usuario = '"&session("vinculado")&"' ORDER BY nome_tipo_env")
%>
					<select name="tipo" id="tipo" style="width:180px;" class="preto11">
					<option></option>
<%
					If Not rs2.Eof Then

						Do While Not rs2.Eof

							If rs2("id_tipo_env") = filTipo Then
								selected = "selected"
							Else
								selected = ""
							End If
%>
					<option <%=selected%> value="<%=rs2("id_tipo_env")%>"><%=rs2("nome_tipo_env")%></option> 
<%
							rs2.MoveNext

						Loop

					End If

					rs2.Close
%>
					</select>
				</td>
			</tr>

			<tr>
				<td><%=mostra_label("processo", "", "")%>:</td>
				<td><% mostra_campo "tproc", "combo", filTipoProcesso, 1 %>
				</td>
				<td>Grupo:</td>
				<td><input type="text" id="grupo" name="grupo" maxlength="15" class="cfrm" value="<%=filGrupo%>" style="width:111px;"></td>
			</tr>

			<tr>
				<td>Data de Cadastrado</td>
				<td>
					<input type="text" name="cadastro_de" id="cadastro_de" maxlength="10" size="10" class="cfrm data" value="<%=filDataCadastro1%>">
					&nbsp;até:&nbsp;
					<input type="text" name="cadastro_ate" id="cadastro_ate" maxlength="10" size="10" class="cfrm data" value="<%=filDataCadastro2%>">
				</td>
				<td>Pasta:</td>
				<td>
					<input type="text" id="pasta" name="pasta" style="width:111px;" maxlength="30" class="cfrm" value="<%=filPasta%>">
					&nbsp;<input type="Checkbox" name="pastaexata" value="0">Exata
				</td>
			</tr>

			<tr>
				<td>CNPJ/CPF/INPI:</td>
				<td><input type="text" id="cnpj_cpf" name="cnpj_cpf" maxlength="14" class="cfrm" value="<%=filCNPJ%>" style="width:108px;"></td>
				<td>Status:</td>
				<td>
	        		<select id="statusEnvolvido" name="statusEnvolvido" class="cfrm">
	        			<option value="">Todos</option>
	        			<option value="E" <% if filStatusEnvolvido = "E" then response.write("selected") end if %>>Efetivo</option>
	        			<option value="N" <% if filStatusEnvolvido = "N" then response.write("selected") end if %>>Não efetivo</option>
	        			<option value="P" <% if filStatusEnvolvido = "P" then response.write("selected") end if %>>Perspectiva</option>
	        		</select>
				</td>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="4" align="center">
					<input type="submit" value="Pesquisar" class="cfrm">
					&nbsp;&nbsp;
					<input type="button" value="Limpar" class="cfrm" onClick="javascript: limpar();">
				</td>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>

			</form>

			</table>

		</td>
	</tr>
	</table>

	<script type="text/javascript">
		//Configurando calendarios 
		jQuery(".data").mask("9?9/99/9999",{placeholder:" "}).datepicker();

		jQuery("#aVoltar").click(function(){
			var backlen = history.length;
    		history.go(-2);
		});
	</script>

	</body>

</html>