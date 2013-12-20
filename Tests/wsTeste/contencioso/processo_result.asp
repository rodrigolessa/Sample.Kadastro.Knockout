<% tem_xls = true 'Atualizando controle de relatorio em xls (.csv) 'TKT 1511 - em andamento com albino %>
<% bt_imprimir = true %>
<% bt_export = true %>
<%'session("voltar") = "/apol/contencioso/processo_list.asp"%>
<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<!--#include file='../include/Db_open_webseek_teste.asp'-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<!--#include file="../include/adovbs.inc"-->
<link rel="STYLESHEET" type="text/css" href="style.css"> 
<script language="javascript" src="valida.js"></script>
<script language="javascript" src="../include/funcoes.js"></script>
<script language="javascript" src="../include/jquery-latest.js" type="text/javascript"></script>
<script language="javascript">

	    var jq = jQuery.noConflict();
		
		function downloadCSV(){
			document.formCSV.submit();
		}
		function downloadXLS(){
			document.formXLS.submit();
		}

		function verificaSolicitacoes(tipo, processo) {
	        //return false;       
	        var erro = 0;
	        if (window.XMLHttpRequest) {
	            req = new XMLHttpRequest();
	        }
	        // Internet Explorer
	        else if (window.ActiveXObject) {
	            req = new ActiveXObject("Microsoft.XMLHTTP");
	        }

	        procs = processo.replace(/##/g, ',');
	        procs = procs.replace(/#/g, '');
	        var url = "../solicitacao_verifica_solicitacoes.asp?tipo='" + tipo + "'&procs='" + procs + "' ";

	        req.open("Get", url, false);
	        req.onreadystatechange = function() {
	            if (req.readyState == 4 && req.status == 200) {
	                var resposta = req.responseText;

	                if (resposta != '') {
	                    jq("#msg_exc").text(resposta);
	                    return true;
	                } else
						jq("#msg_exc").text('Confirma exclusão de todos os registros selecionados ?');
	                    return false;
	            }
	        }
	        req.send(null);
	    }
</script>
<title>APOL Jurídico<% If Request("imprimir") <> "" then %> - Impressão de Informações<% End If %></title>
<!--#include file="rel_func.asp"-->
<%

	Dim strFiltro
	Dim label_campo1, label_campo2, label_campo3, label_campo4, andamentos_T, tituloOcorrencia

	strFiltro = ""

	
	sqlC = "SELECT campo1, campo2, campo3, campo4, andamentos, COALESCE(ocorrencia, '') AS ocorrencia FROM parametros where usuario = '" & session("vinculado") & "'"
	set rsC = db.execute(sqlC)
	if not rsC.EOF then
		label_campo1 = rsC("campo1")
		label_campo2 = rsC("campo2")
		label_campo3 = rsC("campo3")
		label_campo4 = rsC("campo4")
		if isnull(label_campo1) or isempty(label_campo1) or len(trim(label_campo1)) = 0 then label_campo1 = "Campo 1"
		if isnull(label_campo2) or isempty(label_campo2) or len(trim(label_campo2)) = 0 then label_campo2 = "Campo 2"
		if isnull(label_campo3) or isempty(label_campo3) or len(trim(label_campo3)) = 0 then label_campo3 = "Campo 3"
		if isnull(label_campo4) or isempty(label_campo4) or len(trim(label_campo4)) = 0 then label_campo4 = "Campo 4"
		andamentos_T = rsC("andamentos")
		tituloOcorrencia = trim(rsC("ocorrencia"))
	else
		label_campo1 = "Campo 1"
		label_campo2 = "Campo 2"
		label_campo3 = "Campo 3"
		label_campo4 = "Campo 4"
		andamentos_T = "Andamento"
	end if

	if len(tituloOcorrencia) = 0 then
		tituloOcorrencia = "Ocorrências"
	end if


Set rel = new clsRelatorio
rel.addRel "Relatório Resumido",	"../Relatorio_Apol.aspx?tipo_rel=2001"
rel.addRel "Relatório Detalhado",	"../Relatorio_Apol.aspx?tipo_rel=2002"
rel.addRel "Relatório Detalhado 2",	"../Relatorio_Apol.aspx?tipo_rel=2003"
rel.RenderRel "400","70"

function datasql2(data)
	data = tplic(1,data)
	if (data = "") or (data = "//") or (isnull(data)) then
		datasql = "NULL"
	else
		dia = Right("0" & day(data), 2)
		mes = Right("0" & month(data), 2)
		ano = year(data)

		datasql2 = ano&mes&dia
	end if
end function

menu_onde = "proc"
if request("imprimir") = "S" then
	l_imp = "_p"
end if
bt_imprimir = true
if request("imprimir") = "" then %>	
	<!--#include file="header.asp"-->
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
		<td align="right" valign="top"><span class="preto11"><%= now() %></span></td>
	</tr>
	</table>
<% End If

'tabproccont.processo_c = tplic(1,request("ftabproccont.processo_c"))
'tabproccont.tipo_c = tplic(1,request("ftabproccont.tipo_c"))
processo 			= tplic(1,request("ftabproccont.processo_c"))
tipo 				= tplic(1,request("ftabproccont.tipo_c"))
situacao 			= tplic(1,request("fsituacao_c"))
desc1 				= tplic(1,request("|desc1_c"))
eou_1 				= tplic(1,request("eou_1"))
natureza 			= tplic(1,request("fnatureza_n"))
tipo_acao 			= tplic(1,request("ftipo_acao_n"))
tipo_env 			= tplic(1,request("tipo_env"))
distribuicao1 		= tplic(1,request("_distribuicao1_d"))
distribuicao2 		= tplic(1,request("_distribuicao2_d"))
pasta 				= tplic(1,request("fpasta_c"))
pastaexata 			= request("pastaexata")
eou_2 				= tplic(1,request("eou_2"))
competencia 		= tplic(1,request("fcompetencia_c"))
envolvido 			= tplic(1,request("envolvido"))
rito 				= tplic(1,request("frito_n"))
juizo 				= tplic(1,request("fjuizo_n"))
desc2 				= tplic(1,request("|desc2_c"))
parado2 			= tplic(1,request("parado2"))
orgao 				= tplic(1,request("forgao_n"))
responsavel 		= tplic(1,request("fresponsavel_n"))
instancia 			= tplic(1,request("finstancia_c"))
comarca 			= tplic(1,request("fcomarca_n"))
participante 		= tplic(1,request("fparticipante_c"))
desc3 				= tplic(1,request("|desc3_c"))
dt_encerra1 		= tplic(1,request("_dt_encerra1_d"))
dt_encerra2 		= tplic(1,request("_dt_encerra2_d"))
parado1 			= tplic(1,request("parado1"))
cmp_livre_1 		= tplic(1,request("fcmp_livre_1_c"))
cmp_livre_2 		= tplic(1,request("fcmp_livre_2_c"))
cmp_livre_3 		= tplic(1,request("fcmp_livre_3_c"))
cmp_livre_4 		= tplic(1,request("fcmp_livre_4_c"))
grupo 				= tplic(1,request("grupo"))
ddt_cad 			= request("ddt_cad")
adt_cad				= request("adt_cad")
ordem 				= tplic(0, trim(request("ordem")))
ordenacao			= trim(request("ordenacao"))
resultado_previsto 	= tplic(0, trim(request("resultado_previsto")))
dt_citacao1 		= tplic(1, request("_citacao1_d"))
dt_citacao2 		= tplic(1, request("_citacao2_d"))
objeto_principal	= tplic(1, request("objeto_principal"))



if ordem = "" then
	ordem = "TabProcCont.processo"
end if

if len(ordem) > 0 then
	
	strFiltro = strFiltro & " Ordena&ccedil;&atilde;o: <b>" & ObterDescricaoOrdem(ordem) & "</b>"

	if len(ordenacao) > 0 then
		strFiltro = strFiltro & " (<b>" & ObterDescricaoSentidoOrdem(ordenacao) & "</b>)"
	end if

	strFiltro = strFiltro & ","

end if

if ordem <> "TabProcCont.processo" then
	ordenacao = ordenacao & " , TabProcCont.processo " & ordenacao
end if

'orderm = ordem & ", TabProcCont.id_processo"

sql = " 1 = 1 "
if not isnull(processo) and not IsEmpty(processo) and len(trim(processo)) > 0 then
	sql = sql & " and tabproccont.processo like '%" & processo & "%'"
	strFiltro = strFiltro & " Processo: <b>" & processo & "</b>,"
end if

if not isnull(tipo) and not IsEmpty(tipo) and len(trim(tipo)) > 0 then
	sql = sql & " and tabproccont.tipo like '%" & tipo & "%'"
	strFiltro = strFiltro & " Tipo Processo: <b>" & ObterDescricaoTipoProcesso(tipo) & "</b>,"
end if

if not isnull(competencia) and not IsEmpty(competencia) and len(trim(competencia)) > 0 then
	sql = sql & " and competencia like '%" & competencia & "%'"
	strFiltro = strFiltro & " Competência: <b>" & ObterDescricaoCompetencia(competencia) & "</b>,"
end if

if not isnull(situacao) and not IsEmpty(situacao) and len(trim(situacao)) > 0 then
	sql = sql & " and situacao like '%" & situacao & "%'"
	strFiltro = strFiltro & " Situação: <b>" & ObterDescricaoSituacao(situacao) & "</b>,"
end if

if not isnull(natureza) and not IsEmpty(natureza) and len(trim(natureza)) > 0 then
	if cint(natureza) > 0 then
		sql = sql & " and natureza =" &natureza & " "
		strFiltro = strFiltro & " Natureza: <b>" & ObterDescricaoNatureza(natureza) & "</b>,"
	end if
end if

if not isnull(tipo_acao) and not IsEmpty(tipo_acao) and len(trim(tipo_acao)) > 0 then
	if cint(tipo_acao) > 0 then
		sql = sql & " and tipo_acao = " & tipo_acao & " "
		strFiltro = strFiltro & " Tipo Ação: <b>" & ObterDescricaoTipoAcao(tipo_acao) & "</b>,"
	end if
end if

if not isnull(pasta) and not IsEmpty(pasta) and len(trim(pasta)) > 0 then
	if pastaexata = "0" then
		sql = sql & " and pasta = '" &pasta& "'"
		strFiltro = strFiltro & " Pasta Exata: <b>" & pasta & "</b>,"
	else
		sql = sql & " and pasta like '%" &pasta& "%'"
		strFiltro = strFiltro & " Pasta: <b>" & pasta & "</b>,"
	end if
end if

if not isnull(rito) and not IsEmpty(rito) and len(trim(rito)) > 0 then
	if cint(rito) > 0 then
		sql = sql & " and rito = " &rito& " "
		strFiltro = strFiltro & " Rito: <b>" & ObterDescricaoRito(rito) & "</b>,"
	end if
end if

if not isnull(orgao) and not IsEmpty(orgao) and len(trim(orgao)) > 0 then
	if orgao <> "0" then
		if IsNumeric(orgao) then
			sql = sql & " and orgao = '" &orgao& "' "
		end if
		
		if Not IsNumeric(orgao) then
			sql = sql & " and tribunal_sync = '" &orgao& "' "
		end if
		strFiltro = strFiltro & " Órgão: <b>" & ObterDescricaoOrgao(orgao) & "</b>,"
	end if
end if

if not isnull(instancia) and not IsEmpty(instancia) and len(trim(instancia)) > 0 then
	sql = sql & " and instancia like '%" &instancia& "%' "
	strFiltro = strFiltro & " Instância: <b>" & instancia & "</b>,"
end if

if not isnull(juizo) and not IsEmpty(juizo) and len(trim(juizo)) > 0 then
	sql = sql & " and juizo =" &juizo& " "
	strFiltro = strFiltro & " Juízo: <b>" & ObterDescricaoJuizo(juizo) & "</b>,"
end if

if not isnull(comarca) and not IsEmpty(comarca) and len(trim(comarca)) > 0 then
	sql = sql & " and comarca =" &comarca& " "
	strFiltro = strFiltro & " Comarca: <b>" & ObterDescricaoComarca(comarca) & "</b>,"
end if

if not isnull(participante) and not IsEmpty(participante) and len(trim(participante)) > 0 then
	sql = sql & " and participante like '%" &participante & "%' "
	strFiltro = strFiltro & " Posição: <b>" & ObterDescricaoPosicao(participante) & "</b>,"
end if

if not isnull(objeto_principal) and not IsEmpty(objeto_principal) and len(trim(objeto_principal)) > 0 then
	sql = sql & " and objeto_principal = " &objeto_principal& " "
	strFiltro = strFiltro & " Objeto Principal: <b>" & ObterDescricaoObjetoPrincipal(objeto_principal) & "</b>,"
end if

if not isnull(tipo_env) and not IsEmpty(tipo_env) and len(trim(tipo_env)) > 0 then
	sql = sql & " and TabCliCont.tipo_env =" &tipo_env & " "
	strFiltro = strFiltro & " Tipo de Envolvido: <b>" & ObterDescricaoTipoEnvolvido(tipo_env) & "</b>,"
end if

if not isnull(envolvido) and not IsEmpty(envolvido) and len(trim(envolvido)) > 0 then
	sql = sql & " and APOL.dbo.Envolvidos.id = " & envolvido & " "
	strFiltro = strFiltro & " Envolvido: <b>" & ObterDescricaoEnvolvido(envolvido) & "</b>,"
end if

if not isnull(grupo) and not IsEmpty(grupo) and len(trim(grupo)) > 0 then
	sql = sql & " and APOL.dbo.Envolvidos.grupo like '%" & grupo & "%'"
	strFiltro = strFiltro & " Grupo do Envolvido: <b>" & grupo & "</b>,"
end if

if not isnull(responsavel) and not IsEmpty(responsavel) and len(trim(responsavel)) > 0 then
	if cint(responsavel) > 0 then
		sql = sql & " and responsavel  =" &responsavel & " "
		strFiltro = strFiltro & " Responsável: <b>" & ObterDescricaoResponsavel(responsavel) & "</b>,"
	end if
end if

cont = 0
if (isnull(desc1) or IsEmpty(desc1) or len(trim(desc1)) = 0) and (isnull(desc2) or IsEmpty(desc2) or len(trim(desc2)) = 0) and (isnull(desc3) or IsEmpty(desc3) or len(trim(desc3)) = 0)then
	'sql= sql & " and (desc_res is null or desc_det is null or TabProcCont.obs is null) "
else
	sql = sql & "and ("
	if not isnull(desc1) and not IsEmpty(desc1) and len(trim(desc1)) > 0 then
		sql = sql & " (desc_res like '%"&desc1&"%' or desc_det like '%"&desc1&"%' or TabProcCont.obs like '%"&desc1&"%') "
		cont = cont + 1
	end if

	if not isnull(desc2) and not IsEmpty(desc2) and len(trim(desc2)) > 0 then
		if cont > 0 then sql = sql & eou_1
		sql = sql & " (desc_res like '%"&desc2&"%' or desc_det like '%"&desc2&"%' or TabProcCont.obs like '%"&desc2&"%') "
		cont = cont + 1
	end if

	if not isnull(desc3) and not IsEmpty(desc3) and len(trim(desc3)) > 0 then
		if cont > 0 then sql = sql & eou_2
		sql = sql & " (desc_res like '%"&desc3&"%' or desc_det like '%"&desc3&"%' or TabProcCont.obs like '%"&desc3&"%') "
	end if
	
	sql = sql & ")"

	strFiltro = strFiltro & " Objeto: <b>" & ObterDescricaoObjetivo(desc1, eou_1, desc2, eou_2, desc3) & "</b>,"

end if

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
if not isnull(dt_encerra1) and not IsEmpty(dt_encerra1) and len(trim(dt_encerra1)) > 0 then
	strFiltro = strFiltro & " Data de Encerramento: <b>" & dt_encerra1 & "</b>,"
	sql = sql & " and dt_encerra  >='" &datasql2(dt_encerra1) & "' "
end if

if not isnull(dt_encerra2) and not IsEmpty(dt_encerra2) and len(trim(dt_encerra2)) > 0 then
	sql = sql & " and dt_encerra  <='" &datasql2(dt_encerra2) & " 23:59:59' "
	if InStr(strFiltro, "Data de Encerramento:") > 0 then
		strFiltro = left(strFiltro, len(strFiltro) -1)
		strFiltro = strFiltro & " até <b>" & dt_encerra2 & "</b>,"
	else
		strFiltro = strFiltro & " Data de Encerramento até <b>" & dt_encerra2 & "</b>,"
	end if
end if

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
if not isnull(dt_citacao1) and not IsEmpty(dt_citacao1) and len(trim(dt_citacao1)) > 0 then
	sql = sql & " and dt_citacao  >='" &datasql2(dt_citacao1) & "' "
	strFiltro = strFiltro & " Data de Citação: <b>" & dt_citacao1 & "</b>,"
end if

if not isnull(dt_citacao2) and not IsEmpty(dt_citacao2) and len(trim(dt_citacao2)) > 0 then
	sql = sql & " and dt_citacao  <='" &datasql2(dt_citacao2) & " 23:59:59' "
	if InStr(strFiltro, "Data de Citação:") > 0 then
		strFiltro = left(strFiltro, len(strFiltro) -1)
		strFiltro = strFiltro & " até <b>" & dt_citacao2 & "</b>,"
	else
		strFiltro = strFiltro & " Data de Citação até <b>" & dt_citacao2 & "</b>,"
	end if
end if

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
if not isnull(distribuicao1) and not IsEmpty(distribuicao1) and len(trim(distribuicao1)) > 0 then
	sql = sql & " and distribuicao  >='" &datasql2(distribuicao1) & "' "
	strFiltro = strFiltro & " Data de Distribuição: <b>" & distribuicao1 & "</b>,"
end if

if not isnull(distribuicao2) and not IsEmpty(distribuicao2) and len(trim(distribuicao2)) > 0 then
	sql = sql & " and distribuicao  <='" &datasql2(distribuicao2) & " 23:59:59' "
	if InStr(strFiltro, "Data de Distribuição:") > 0 then
		strFiltro = left(strFiltro, len(strFiltro) -1)
		strFiltro = strFiltro & " até <b>" & distribuicao2 & "</b>,"
	else
		strFiltro = strFiltro & " Data de Distribuição até <b>" & distribuicao2 & "</b>,"
	end if
end if

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
if isdate(request("ddt_cad")) then
	sql= sql & " AND (dt_cad >= "&rdata(request("ddt_cad"))&")"
	strFiltro = strFiltro & " Data de Cadastro: <b>" & request("ddt_cad") & "</b>,"
end if

if isdate(request("adt_cad")) then
	sql= sql & " AND (dt_cad <= "&rdata(DateAdd("d", 1, request("adt_cad")))&")"
	if InStr(strFiltro, "Data de Cadastro:") > 0 then
		strFiltro = left(strFiltro, len(strFiltro) -1)
		strFiltro = strFiltro & " até <b>" & request("adt_cad") & "</b>,"
	else
		strFiltro = strFiltro & " Data de Cadastro até <b>" & request("adt_cad") & "</b>,"
	end if
end if

if not isnull(cmp_livre_1) and not isempty(cmp_livre_1) and len(trim(cmp_livre_1)) > 0 then
	sql = sql & "and TabProcCont.cmp_livre_1 like '%" & cmp_livre_1 & "%' "
	strFiltro = strFiltro & " " & label_campo1 & ": <b>" & cmp_livre_1 & "</b>,"
end if

if not isnull(cmp_livre_2) and not isempty(cmp_livre_2) and len(trim(cmp_livre_2)) > 0 then
	sql = sql & "and TabProcCont.cmp_livre_2 like '%" & cmp_livre_2 & "%' "
	strFiltro = strFiltro & " " & label_campo2 & ": <b>" & cmp_livre_2 & "</b>,"
end if

if not isnull(cmp_livre_3) and not isempty(cmp_livre_3) and len(trim(cmp_livre_3)) > 0 then
	sql = sql & "and TabProcCont.cmp_livre_3 = '" & cmp_livre_3 & "' "
	strFiltro = strFiltro & " " & label_campo3 & ": <b>" & ObterDescricaoCampo3(cmp_livre_3) & "</b>,"
end if

if not isnull(cmp_livre_4) and not isempty(cmp_livre_4) and len(trim(cmp_livre_4)) > 0 then
	sql = sql & "and TabProcCont.cmp_livre_4 like '" & cmp_livre_4 & "' "
	strFiltro = strFiltro & " " & label_campo4 & ": <b>" & ObterDescricaoCampo4(cmp_livre_4) & "</b>,"
end if

if not isnull(resultado_previsto) and not isempty(resultado_previsto) and len(trim(resultado_previsto)) > 0 then
	sql = sql & "and TabProcCont.resultado_previsto like '" & resultado_previsto & "' "
	strFiltro = strFiltro & " Resultado Previsto: <b>" & ObterDescricaoResultadoPrevisto(resultado_previsto) & "</b>,"
end if

' Validação de ocorrências'
'------------------------------------------------------------------------------------------------'
ocorrenciaData1 = trim(request("ddt_ocorrencia_data"))
ocorrenciaData2 = trim(request("adt_ocorrencia_data"))
ocorrenciaDescricao = tplic(0,trim(request("descricaoOcorrencia")))
protocoloOcorrencia = tplic(0,trim(request("protocoloOcorrencia")))

if len(ocorrenciaDescricao) > 2 then

	sql = sql & " AND (oc.descricao LIKE '%" & ocorrenciaDescricao & "%' OR oc.ocorrencia LIKE '%" & ocorrenciaDescricao & "%') "
	strFiltro = strFiltro & " Descrição/Detalhe de " & tituloOcorrencia & ": <b>" & ocorrenciaDescricao & "</b>,"

end if

if len(ocorrenciaData1) > 9 and isdate(ocorrenciaData1) then

	strFiltro = strFiltro & " Data de " & tituloOcorrencia & ": <b>" & ocorrenciaData1 & "</b>,"

	ocorrenciaData1 = tplic(1,ocorrenciaData1)
	ocorrenciaData1 = mid(ocorrenciaData1,7,4) & "-" & mid(ocorrenciaData1,4,2) & "-" & mid(ocorrenciaData1,1,2)

	sql = sql & " AND (oc.data >= '" & ocorrenciaData1 & "') "

end if

if len(ocorrenciaData2) > 9 and isdate(ocorrenciaData2) then

	if InStr(strFiltro, "Data de " & tituloOcorrencia & ":") > 0 then
		strFiltro = left(strFiltro, len(strFiltro) -1)
		strFiltro = strFiltro & " até <b>" & ocorrenciaData2 & "</b>,"
	else
		strFiltro = strFiltro & " Data de " & tituloOcorrencia & " até <b>" & ocorrenciaData2 & "</b>,"
	end if

	ocorrenciaData2 = tplic(1,ocorrenciaData2)
	ocorrenciaData2 = mid(ocorrenciaData2,7,4) & "-" & mid(ocorrenciaData2,4,2) & "-" & mid(ocorrenciaData2,1,2)

	sql = sql & " AND (oc.data <= '" & ocorrenciaData2 & "') "

end if

if len(protocoloOcorrencia) > 0 then
	sql = sql & " AND (oc.protocolo LIKE '%" & protocoloOcorrencia & "%') "
	strFiltro = strFiltro & " Protocolo de " & tituloOcorrencia & ": <b>" & protocoloOcorrencia & "</b>,"
end if
'------------------------------------------------------------------------------------------------'

'Filtro de data de andamentos
if isdate(request("_dt_ult_sinc_d")) and isdate(request("_dt_ult_sinc2_d")) then
	sql= sql & " AND id_processo in (select tc.id_processo from tb_Andamentos t join TabProcCont tc on tc.id_processo = t.id_processo where tc.usuario = '" & session("vinculado") & "' and data >= '" &datasql2(request("_dt_ult_sinc_d")) & "' and data  <= '" &datasql2(request("_dt_ult_sinc2_d")) & " 23:59:59') "
	strFiltro = strFiltro & " " & andamentos_T & ": <b>" & request("_dt_ult_sinc_d") & "</b> até <b>" & request("_dt_ult_sinc2_d") & "</b>,"
end if

if isdate(request("_dt_ult_sinc_d")) and (not isdate(request("_dt_ult_sinc2_d"))) then
	sql= sql & " AND id_processo in (select tc.id_processo from tb_Andamentos t join TabProcCont tc on tc.id_processo = t.id_processo where tc.usuario = '" & session("vinculado") & "' and data >= '" &datasql2(request("_dt_ult_sinc_d")) & "') "
	strFiltro = strFiltro & " " & andamentos_T & ": <b>" & request("_dt_ult_sinc_d") & "</b>,"
end if

if (not isdate(request("_dt_ult_sinc_d"))) and isdate(request("_dt_ult_sinc2_d")) then
	sql= sql & " AND id_processo in (select tc.id_processo from tb_Andamentos t join TabProcCont tc on tc.id_processo = t.id_processo where tc.usuario = '" & session("vinculado") & "' and data  <= '" &datasql2(request("_dt_ult_sinc2_d")) & " 23:59:59') " 
	strFiltro = strFiltro & " " & andamentos_T & ": até <b>" & request("_dt_ult_sinc2_d") & "</b>,"
end if

'if request("resultado") <> "S" then
	If request("tipo_env") <> "" Then
		sqlX = " AND (TabCliCont.tipo_env = "&request("tipo_env")&")"
	End If


	sql = "SELECT DISTINCT TabProcCont.id_processo, TabProcCont.processo, TabProcCont.tipo_consulta_processo, "&_
	" TabProcCont.desc_res, TabProcCont.situacao, TabProcCont.pasta, TabProcCont.cmp_livre_1, TabProcCont.cmp_livre_2 "&_	
	",case when i1.status=200 then (select nomeusu from usuarios_apol.dbo.usuario where codigo=s1.id_usuario_para) else NULL end as 'disponivel' "&_
	" FROM TabCliCont RIGHT OUTER JOIN "&_
	" APOL.dbo.Envolvidos ON TabCliCont.envolvido = APOL.dbo.Envolvidos.id RIGHT OUTER JOIN "&_
	" TabProcCont ON TabCliCont.processo = TabProcCont.id_processo "&_
	" FULL OUTER JOIN TabCliCont TabCliCont_1 ON TabProcCont.id_processo = TabCliCont_1.processo "&_
	    " LEFT JOIN apol.dbo.item_solicitacao i1 ON  "&_
	    " TabProcCont.id_Processo = i1.id_documento_solicitado and i1.tipo_processo='C' and i1.status=200 and i1.id_usuario_principal="&session("codigo_vinculado") &" "&_
	    " left join apol.dbo.solicitacao s1 on i1.id_solicitacao = s1.id_solicitacao  and s1.id_usuario_principal=i1.id_usuario_principal "&_
	" LEFT JOIN APOL.dbo.ocorrencias oc ON (oc.usuario = '" &session("vinculado")& "' AND oc.processo COLLATE Latin1_General_CI_AS = TabProcCont.processo) " & _
	" WHERE TabProcCont.usuario = '"&session("vinculado")&"' "&sqlX&" and " & sql & "order by " & ordem & " " & ordenacao

'else
'	sql = request("sql")
'end if

if Request("filtrar") = "ok" then
	pmarcados = replace(tplic(1,Request("pmarcados")),"#","'")
	pmarcados = replace(pmarcados,"''","','")
	sql2 = replace(replace(sql,"and order"," order"),"order by", " and TabProcCont.id_processo in (" &pmarcados& ") order by ")
	strFiltro = strFiltro &" <strong>Seleção Manual</strong>,"
else
	sql2 = replace(sql,"and order"," order")
end if

if request("vindo") = "" then
	session("sql2") = sql2
end if

if request("parado1") <> "" then
	if request("parado2") <> "" then
		parado_prov = " having (max(apol.dbo.providencias.prazo_ofi) BETWEEN '"&datasql2(request("parado1"))&"' AND '"&datasql2(request("parado2"))&" 23:59:59')"
		parado_ocor = " having (max(apol.dbo.ocorrencias.data) BETWEEN '"&datasql2(request("parado1"))&"' AND '"&datasql2(request("parado2"))&" 23:59:59')"
		parado1 = ""
		parado2 = ""
	else
		parado1 = " having (max(apol.dbo.providencias.prazo_ofi) < '"&datasql2(request("parado1"))&"')"
		parado2 = " having (max(apol.dbo.ocorrencias.data) < '"&datasql2(request("parado1"))&"')"
		parado_prov = ""
		parado_ocor = ""
	end if
	x = split(session("sql2"),"order by")
	session("sql2") = x(0) & " AND (tabproccont.processo in (select apol.dbo.providencias.processo "&_
	" COLLATE Latin1_General_CI_AS from apol.dbo.providencias where apol.dbo.providencias.usuario = '"&session("vinculado")&"' and "&_
	" apol.dbo.providencias.tipo = 'C' AND (apol.dbo.Providencias.executada = 0)  "&_
	" group by apol.dbo.providencias.processo, apol.dbo.providencias.tipo "&parado1&_
	" "&parado_prov&" "&_
	" union select apol.dbo.ocorrencias.processo from apol.dbo.ocorrencias "&_
	" where apol.dbo.ocorrencias.usuario = '"&session("vinculado")&"' and apol.dbo.ocorrencias.tipo = 'C'  "&_
	" group by apol.dbo.ocorrencias.processo, apol.dbo.ocorrencias.tipo  "&parado2&_
	" "&parado_ocor&" )) order by " & x(1)
end if

session("sql2") = replace(session("sql2")," obs"," TabProcCont.obs")
session("sql2") = replace(session("sql2")," pasta"," TabProcCont.pasta")

session("sqlContencioso") = mid(session("sql2"), instr(session("sql2"), "FROM"), len(session("sql2")))

set rst = server.createobject("ADODB.Recordset")

'response.write session("sql2")
'response.end

if request("DO") then 'Verificando se a pagina foi "chamada" pelo aviso de DO
	if  instr(lcase(session("sql2")),"order by tabproccont.processo") then
		sqlDO = "USE contencioso "& replace(lcase(session("sql2")),"order by tabproccont.processo"," AND contencioso.dbo.TabProcCont.id_processo IN ("& request("processo") &") ORDER BY contencioso.dbo.TabProcCont.processo ") 'SQL responsavel pela listagem dos itens na tela
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

%>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
			<tr>
				<td height="16px" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19px" height="18px">&nbsp;</td>
				<td height="16px" valign="middle" class="titulo">&nbsp;Relatório&nbsp;de&nbsp;Processos&nbsp;</td>
				<td height="16px" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18px" border="0"></td>
				<td height="16px" valign="middle"><img src="imagem/tit_fim.gif" width="21px" height="16px"></td>
				<% if procs <> "" then%>
					<% If Request("imprimir") = "" then %><% if (Session("cont_exc_proc")) or (Session("adm_adm_sys")) then %><td height="16" valign="middle">&nbsp;<a href="javascript: excluir_conf()" class="linkp11"><img src="imagem/lixeira.gif" alt="Excluir" width="13" height="17" border="0" align="absmiddle"></a></td><% End If %><% End If %>
				<%end if%>
			</tr>
		</table>
		<%
		totReg = rst.recordcount
		if totReg = 0 then
			%>
			<table width="100%" class="tabela<%=l_imp%>" border="0" cellspacing="2" cellpadding="3">
			<tr bgcolor=<%=cor%>>
				<td width="100%" align="center" colspan="3"><b>Não foram encontrados processos que atendam às condições estabelecidas</b></td>
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
		rst.CursorType = adOpenStatic
		
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

<%
	if len(strFiltro) > 0 and request("imprimir") <> "" then
		strFiltro = left(strFiltro, len(strFiltro) -1)
%>
		<table bgcolor="#FFFFFF" width="100%" border="0" class="preto11" cellpadding="5" cellspacing="0">
		<tr>
			<td><b>Filtro(s):</b><br /><%=strFiltro%></td>
		</tr>
		</table>
<%
	end if
%>
		
		<%if request("imprimir") = "" then%>
		<table bgcolor="#FFFFFF" width="100%" border="0" class=preto11 cellpadding="0" cellspacing="0">
			<tr>
				<td width="30%"><b>Processos = <%=rst.RecordCount%></b></td>
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
	<form action="processo_result.asp" name="frm" method="post" onsubmit="return valida()">
			<input type="hidden" name="vindo" value="1">
			<input type="hidden" name="direcao" value="">
			<input type="hidden" name="filtrar" value="">
			<input type="hidden" name="resultado" value="S">
			<input type="hidden" name="pmarcados" value="<%=request("pmarcados")%>">
			<input type="hidden" name="atual" value="<%=pagAtual%>">
			<input type="hidden" name="pagAtual" value="">
			<!--input type="hidden" name="sql" value="<%=sql%>"-->
			<input type="hidden" name="chaveProcesso" value="">
			
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
<%
	if request("imprimir") <> "" then
%>
		<tr>
			<td colspan="5"><img src="imagem/1px-preto.gif" width="100%" height="1" border="0"></td>
		</tr>
<%
	end if
%>
		<tr bgcolor="#00578F" class="tit1<%=l_imp%>">
			<%if request("imprimir") = "" then%>
			    <td align="center" width=4%><a href="javascript: marcar()"><img src="imagem/check_xp.gif" width="13" height="13" border="0"></a></td>
			<%end if%>
			
			<%if request("imprimir") = "" then%><td width=4%></td><td></td><%end if%>
			<td width=18%><b>Processo</b></td>
			<td width=32%><b>Objeto</b></td>
			<td width=17%><b>Pasta</b></td>
			<td width=17%><b>Envolvidos</b></td>
			<td width=8%><b>Situação</b></td>
		</tr>
<%
	if request("imprimir") <> "" then
%>
		<tr>
			<td colspan="5"><img src="imagem/1px-preto.gif" width="100%" height="1" border="0"></td>
		</tr>
<%
	end if
%>
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
					<%if request("imprimir") = "" then%><td width="13" align="center"><input type="checkbox" name="nproc<%= rst("id_processo") %>" value="<%= rst("id_processo") %>" onclick="marca_check('<%=rst("id_processo") %>')"<% If instr(Request("pmarcados"),rst("id_processo")) > 0 then %> checked<% End If %>></td><%end if%>
					<%If Request("imprimir") = "" then %><td align="center"><%
						set rst_carta = db.execute("Select comunicacao from Parametros WHERE usuario = '"&session("vinculado")&"'")
						if trim(rst_carta("comunicacao")) <> "" then
							Response.write "<a href=""javascript:abrirjanela('gera_carta_contencioso.asp?origem=M&id_processo=" & rst("id_processo") & "',350,110)"">"
						end if%>
						<img src="imagem/carta.gif" alt="<% if trim(rst_carta("comunicacao")) = "" then %>Gerar carta. Padrão não definido.<% Else %>Gerar carta<% End If %>" width="19" height="21" border="0"></a></td>
					<% End If %>
					<% If Request("imprimir") = "" then %>	
					    <td align="center">
					        <span style="cursor:hand;" class="preto11" onclick="javascript:abrirjanela('../solicitacao_popup.asp?id=<%=rst("id_processo")%>&tipo=C',605,200)">
					        <% if isnull(rst("disponivel")) then %><img src="../imagem/folder_green.png" alt="Solicitar pasta" width="13px" height="13px"/>
					        <% else %><img src="../imagem/folder_red.png" alt="Est&aacute; com <%=rst("disponivel") %>" width="13px" height="13px"/><%end if %>
					        </span>
					    </td>
					<%end if %>
					<td nowrap><%if request("imprimir") <> "" then%><%=rst("processo")%><%else%><a class="preto11" href="processo.asp?id_processo=<%=rst("id_processo")%>&modulo=C&processo='<%=rst("processo")%>'&pasta=<%=rst("pasta")%>"><%=rst("processo")%></a><%End if%></td>
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
					<td><%=rst("Pasta")%></td>
					<td width="150px">
						<%
						sql = "SELECT apelido FROM TabCliCont LEFT OUTER JOIN APOL.dbo.Envolvidos ON TabCliCont.envolvido = APOL.dbo.Envolvidos.[id] WHERE (TabCliCont.processo = " & rst("id_processo") & ") AND (TabCliCont.usuario = '" & session("vinculado") & "')"
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
					<%if rst("situacao") = "A" then
						response.write "Ativo"
					elseif rst("situacao") = "E" then
						response.write "Encerrado"
					elseif rst("situacao") = "C" then
						response.write "Acordo"
					elseif rst("situacao") = "I" then
						response.write "Inativo"
					end if%>
					</td>
				</tr>
				<%				
				rst.movenext
				if rst.eof then exit for
			next
		else
%>
			<tr bgcolor=<%=cor%>>
				<td width="100%" align="center" colspan=3 class="preto11"><b>Não foram encontrados processos que atendam às condições estabelecidas</b></td>
			</tr>
<%
		end if
%>

	</form>

	</table>
</tr>
<%
	If Request("imprimir") <> "" then
%>
<tr>
	<td>
		<table bgcolor="#FFFFFF" width="100%" border="0" class="preto11" cellpadding="5" cellspacing="0" >
		<tr>
			<td><img src="imagem/1px-preto.gif" width="100%" height="1" border="0"></td>
		</tr>
		<tr>
			<td height="1"><strong>Total = <%=rst.RecordCount%></strong></td>
		</tr>
		<tr>
			<td><img src="imagem/1px-preto.gif" width="100%" height="1" border="0"></td>
		</tr>
		</table>
	</td>
</tr>
<%
	end if
%>
<tr>
<%
	if request("imprimir") = "" then
%>
		<table bgcolor="#FFFFFF" width="100%" border="0" class=preto11 cellpadding="0" cellspacing="0">
			<tr>
				<td width="30%"><b>Processos = <%=rst.RecordCount%></b></td>
				<td align="center" width="50%">
					<table class="linkp11">
					<tr>
						<td background="imagem/botao_limpo.gif" width="82" height="21" align="center"><a href="javascript: filtrar()" class="linkp11">&nbsp;&nbsp;Selecionar&nbsp;&nbsp;</a></td>
					</tr>
					</table>
				</td>
<%
		If pagatual > 1 then
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
	<td align="center" width="10%"><b><input type="text" name="pg_escolha" size="3" maxlength="4" onkeypress="return handleEnter(this, event, this.value)" class="cfrm" onfocus="this.select()" style="text-align: center; font-weight: bold;" value="<%= pagatual %>">&nbsp;de&nbsp;<%= rst.PageCount %></b></td>
<%
		If pagAtual < rst.PageCount then
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
		<td align="right"><table cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td><img src="imagem/setas_navegacao_12_desat.gif" border="0"></td>
		<td><img src="imagem/setas_navegacao_10_desat.gif" border="0"></td>
	</tr>
	</table></td>
<%
		End If
%>
	</tr>
	</table>
<%
	end if
%>

	
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
	document.frm.action='processo_result.asp';
	document.frm.atual.value=<%= pagAtual+1 %>;
	document.frm.filtrar.value='<%= Request("filtrar") %>';
	document.frm.direcao.value='proxima';
	document.frm.submit();
}
	
function multi(){
	document.frm.action='processo_result.asp';
	document.frm.atual.value=<%= rst.PageCount %>;
	document.frm.filtrar.value='<%= Request("filtrar") %>';
	document.frm.submit();
}

function mante(){
	document.frm.action='processo_result.asp';
	document.frm.atual.value=<%= pagAtual-1 %>;
	document.frm.filtrar.value='<%= Request("filtrar") %>';
	document.frm.submit();
}
	
function mprim(){
	document.frm.action='processo_result.asp';
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
		document.frm.action='processo_result.asp';
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

// Declaração de variáveis globais =============================
	var booLimpaDependencia = true;
	var gStrSelectItem  = '---- Selecione um Item ----';
	var gStr_Oficial    = 'Oficial';
	var gStr_Gerencial  = 'Gerencial';
	var gStr_WebService = '<%=url_base()%>/utilitarios/ServicoIsis/ServicoIsis.asmx';
	var gStr_Usuario    = '<%= session("vinculado") %>';
	
// Exclui processo da ADM ISIS e esvazia a lixeira 
	function excluiProcessoISIS(vIdProc)
	{	
		var lStr_Erro = '';
		var vChave = '';
		
		jQuery.get('busca_chave_processo.asp?idproc='+vIdProc, function(data){
			jQuery("input[name='chaveProcesso']").val(jQuery.trim(data)).attr('readonly', false).css("color", "#000000");
		});

		vChave = document.frm.chaveProcesso.value;
					
		jQuery.ajax({
			type: "POST",
			url: gStr_WebService + "/excluiProcesso",
			data: "{'vStr_ChaveVinculo':'"+vChave+"', 'vStr_Usuario':'"+gStr_Usuario+"'}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			async: false,
			success: function(jsonResult) {
				if (jsonResult.d != ''){
					//alert(jsonResult.d);
					lStr_Erro = jsonResult.d;
				}
			},
			error: function (msg) {
			    lStr_Erro = 'Não foi possível excluir o Processo. Contacte a LDSoft.';
			}
		});
		return lStr_Erro;
	}

function excluir(){
	
	var arrIdProc = document.frm.pmarcados.value.split("##");
	var proc = "";
	var i = 0;
	
	fecha_exc();	
	if(document.frm.pmarcados.value != ""){	
		document.frm.action='processos_excluir.asp?vindo=2';
		if (arrIdProc.length == 1){
			proc = arrIdProc[0].substring(1,arrIdProc[0].length - 1);
		    excluiProcessoISIS(proc);
		}
		else{
			for(i = 0; i < arrIdProc.length; i++){
				proc = arrIdProc[i].replace("#","");
		    	excluiProcessoISIS(proc);
			}
		}
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
	
	 jq.ajaxSetup({
       cache: false,
       async: false
   });
</script>

<div id="pergunta_exc" style="position: absolute; top: 60px; width: 770px; left: 1px; height: 400px; display: none;">
<table width="100%" height="100%">
<tr valign="middle">
	<td align="center">
<table width="300" bgcolor="#FFFFFF" style="border: 1px solid Black;" class="preto11">
<tr>
	<td>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
		<tr>
			<td height="16px" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19px" height="18px">&nbsp;</td>
			<td height="16px" valign="middle" class="titulo">&nbsp;Exclusão&nbsp;de&nbsp;Processo&nbsp;&nbsp;</td>
			<td height="16px" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18px" border="0"></td>
			<td height="16px" valign="middle"><img src="imagem/tit_fim.gif" width="21px" height="16px"></td>
		</tr>			
		</table>
	</td>
</tr>
<tr>
	<td align="center">&nbsp;</td>
</tr>
<tr>
	<td align="center"><img src="imagem/pergunta.gif" width="35" height="33" border="0" align="absmiddle">&nbsp;&nbsp;<b style="color:red;"><span id="msg_exc">Confirma exclusão de todos os registros selecionados ?</span></b></td>
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

function mostra_exc() {
        verificaSolicitacoes('C', document.frm.pmarcados.value);
        jq("#pergunta_exc").show();
		//MM_showHideLayers('pergunta_exc','','show');
		}

function fecha_exc() {
        jq("#pergunta_exc").hide();
		//MM_showHideLayers('pergunta_exc','','hide');
		}
</script>

<%
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Funções Para Filtro '
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'Ordena&ccedil;&atilde;o: 
'request("ordem")
Function ObterDescricaoOrdem(prmOrdem)

	r_Descricao = ""

	Select Case prmOrdem
	Case "TabProcCont.pasta"
		r_Descricao = "Pasta"
	Case "TabProcCont.processo"
		r_Descricao = "Processos"
	Case "TabProcCont.situacao"
		r_Descricao = "Situa&ccedil;&atilde;o"
	Case "TabProcCont.cmp_livre_1"
		r_Descricao = label_campo1
	Case "TabProcCont.cmp_livre_2"
		r_Descricao = label_campo2
	End Select

	ObterDescricaoOrdem = r_Descricao

End Function

'request("ordenacao")
Function ObterDescricaoSentidoOrdem(prmOrdenacao)

	r_Descricao = ""

	Select Case prmOrdenacao
	Case "ASC"
		r_Descricao = "Crescente"
	Case "DESC"
		r_Descricao = "Decrescente"
	End Select

	ObterDescricaoSentidoOrdem = r_Descricao
					
End Function

'Tipo Processo: 
'request("ftabproccont.tipo_c")
Function ObterDescricaoTipoProcesso(prmTipoProcesso)
				
	r_Descricao = ""

	Select Case prmTipoProcesso
	Case "J"
		r_Descricao = "Judicial"
	Case "A"
		r_Descricao = "Administrativo"
	End Select

	ObterDescricaoTipoProcesso = r_Descricao

End Function

'Processo: 
'request("ftabproccont.processo_c")

'Instância: 
'request("finstancia_c")

'Competência:
'request("fcompetencia_c")
Function ObterDescricaoCompetencia(prmFiltro)

	r_Descricao = ""

	Select Case prmFiltro
	Case "F"
		r_Descricao = "Federal"
	Case "E"
		r_Descricao = "Estadual"
	Case "M"
		r_Descricao = "Municipal"
	End Select

	ObterDescricaoCompetencia = r_Descricao

End Function

'Posição:
'request("fparticipante_c")
Function ObterDescricaoPosicao(prmFiltro)

	r_Descricao = ""

	Select Case prmFiltro
	Case "A"
		r_Descricao = "Autor"
	Case "R"
		r_Descricao = "Réu"
	End Select

	ObterDescricaoPosicao = r_Descricao

End Function

'Objeto:
'request("|desc1_c")
'request("eou_1"
'request("|desc2_c")
'request("eou_2")
'request("|desc3_c")
Function ObterDescricaoObjetivo(prmFiltro1, prmFiltro2, prmFiltro3, prmFiltro4, prmFiltro5)

	r_Descricao = ""

	if len(prmFiltro1) > 0 then

		r_Descricao = r_Descricao & prmFiltro1

		if len(prmFiltro3) > 0 then

			r_Descricao = r_Descricao & " " & ObterDescricaoLigacao(prmFiltro2) & " " & prmFiltro3

			if len(prmFiltro5) > 0 then

				r_Descricao = r_Descricao & " " & ObterDescricaoLigacao(prmFiltro4) & " " & prmFiltro5

			end if

		end if

	end if

	ObterDescricaoObjetivo = r_Descricao

End Function

Function ObterDescricaoLigacao(prmLigacao)

	r_Descricao2 = ""

	Select Case prmLigacao
	Case "and"
		r_Descricao2 = "e"
	Case "or"
		r_Descricao2 = "ou"
	End Select

	ObterDescricaoLigacao = r_Descricao2

End Function

'Tipo de Envolvido
'request("tipo_env")
Function ObterDescricaoTipoEnvolvido(prmFiltro)

	Set rs = conn.execute("SELECT nome_tipo_env FROM Tipo_Envolvido WHERE usuario = '"&Session("vinculado")&"' and contencioso= '1' and id_tipo_env = " & prmFiltro)
	if not rs.eof then
		ObterDescricaoTipoEnvolvido = rs("nome_tipo_env")
	end if

End Function

'Envolvido:
'envolvido
function ObterDescricaoEnvolvido(prmFiltro)

	r_Descricao = ""

	Set rs = conn.execute("select apelido from Envolvidos where usuario= '"&Session("vinculado")&"'and id="&prmFiltro&" order by apelido")

	if not rs.eof  then 
		r_Descricao = rs("apelido")
	end if

	ObterDescricaoEnvolvido = r_Descricao
	
end function

'Tipo Ação
'ftipo_acao_n
function ObterDescricaoTipoAcao(prmFiltro)

	r_Descricao = ""
	Set rs = db.execute("select descricao from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'T' and codigo = " & prmFiltro)

	if not rs.eof  then 
		r_Descricao = rs("descricao")
	end if

	ObterDescricaoTipoAcao = r_Descricao

end function

'Situação:
'fsituacao_c
Function ObterDescricaoSituacao(prmFiltro)

	r_Descricao = ""

	Select Case prmFiltro
	Case "A"
		r_Descricao = "Ativo"
	Case "C"
		r_Descricao = "Em Acordo"
	Case "E"
		r_Descricao = "Encerrado"
	Case "I"
		r_Descricao = "Inativo"
	End Select

	ObterDescricaoSituacao = r_Descricao

End Function

'Rito:
'frito_n
function ObterDescricaoRito(prmFiltro)

	r_Descricao = ""

	Set rs = db.execute("select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'R' and codigo = " & prmFiltro)
	if not rs.eof then
		r_Descricao = rs("descricao")
	end if

	ObterDescricaoRito = r_Descricao

end function

'Resultado Previsto:
'resultado_previsto
Function ObterDescricaoResultadoPrevisto(prmFiltro)

	r_Descricao = ""

	Select Case prmFiltro
	Case "P"
		r_Descricao = "Perdida"
	Case "R"
		r_Descricao = "Remota"
	Case "S"
		r_Descricao = "Possível"
	Case "V"
		r_Descricao = "Provável"
	Case "G"
		r_Descricao = "Ganha"
	End Select

	ObterDescricaoResultadoPrevisto = r_Descricao

End Function

'Comarca:
'fcomarca_n
Function ObterDescricaoComarca(prmFiltro)

	r_Descricao = ""

	Set rs = db.execute("select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'C' and codigo = " & prmFiltro)
	if not rst.eof then
		r_Descricao = rs("descricao")
	end if

	ObterDescricaoComarca = r_Descricao

End Function

'Responsável:
'fresponsavel_n
Function ObterDescricaoResponsavel(prmFiltro)

	r_Descricao = ""

	Set rs = conn.execute("Select * from responsaveis where tipo <> 'cliente' and usuario = '"&Session("vinculado")&"' and id = " & prmFiltro)
	if not rst.eof then
		r_Descricao = rs("nome")
	end if

	ObterDescricaoResponsavel = r_Descricao

End Function

'Juízo:
'fjuizo_n
Function ObterDescricaoJuizo(prmFiltro)

	r_Descricao = ""

	Set rs = db.execute("select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'J' and codigo = " & prmFiltro)
	if not rst.eof then
		r_Descricao = rs("descricao")
	end if

	ObterDescricaoJuizo = r_Descricao

End Function

'Pasta:
'fpasta_c
'pastaexata - Exata

'Órgão:
'forgao_n
Function ObterDescricaoOrgao(prmFiltro)

	r_Descricao = ""

	if len(trim(prmFiltro)) > 0 and trim(cStr(prmFiltro)) <> "0" then
		if isNumeric(prmFiltro) then
			r_Descricao = ObterDescricaoOrgaoGerencial(prmFiltro)
		else
			r_Descricao = ObterDescricaoOrgaoOficial(prmFiltro)
		end if
	end if

	ObterDescricaoOrgao = r_Descricao

End Function

'Grupo do Envolvido:
'grupo

'Natureza:
'fnatureza_n
Function ObterDescricaoNatureza(prmFiltro)

	r_Descricao = ""

	Set rs = db.execute("select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'N' and codigo = " & prmFiltro)
	if not rs.eof then
		r_Descricao = rs("descricao")
	end if

	ObterDescricaoNatureza = r_Descricao

End Function

'Data de Citação:
'_citacao1_d
'_citacao2_d

'Data de Cadastro:
'ddt_cad
'adt_cad

'Data de Encerramento:
'_dt_encerra1_d
'_dt_encerra2_d

'Data de Distribuição:
'_distribuicao1_d
'_distribuicao2_d

'label_campo1
'fcmp_livre_1_c

'label_campo2
'fcmp_livre_2_c

'label_campo3
'fcmp_livre_3_c
Function ObterDescricaoCampo3(prmFiltro)

	r_Descricao = ""

	Set rs = db.execute("select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = '3' and codigo = " & prmFiltro)
	if not rs.eof then
		r_Descricao = rs("descricao")
	end if

	ObterDescricaoCampo3 = r_Descricao

End Function

'label_campo4
'fcmp_livre_4_c
Function ObterDescricaoCampo4(prmFiltro)

	r_Descricao = ""

	Set rs = db.execute("select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = '4' and codigo = " & prmFiltro)
	if not rs.eof then
		r_Descricao = rs("descricao")
	end if

	ObterDescricaoCampo4 = r_Descricao

End Function

'Ocorrências
'Data:
'ddt_ocorrencia_data
'adt_ocorrencia_data
'Descrição/Detalhe:
'descricaoOcorrencia
'Protocolo:
'protocoloOcorrencia

'Objeto Principal
Function ObterDescricaoObjetoPrincipal(prmFiltro)

	r_Descricao = ""

	Set rs = db.execute("select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'L' and codigo = " & prmFiltro)
	if not rs.eof then
		r_Descricao = rs("descricao")
	end if

	ObterDescricaoObjetoPrincipal = r_Descricao

End Function

%>