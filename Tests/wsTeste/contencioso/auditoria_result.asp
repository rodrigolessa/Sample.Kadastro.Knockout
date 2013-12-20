<% bt_imprimir = true %>
<%'session("voltar") = "/apol/contencioso/rel_andamentos_tribunais.asp"%>
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
<title>APOL Jurídico<% If Request.Querystring("imprimir") <> "" then %> - Impressão de Informações<% End If %></title>
<!--#include file="rel_func.asp"-->
<%

Dim msgSinc
Dim strFiltros

msgSinc = "Sincronizado com sucesso."
Set rel = new clsRelatorio
rel.addRel "Relatório Detalhado",	"../Relatorio_Apol.aspx?tipo_rel=2005"
rel.addRel "Relatório Resumido",	"../Relatorio_Apol.aspx?tipo_rel=2006"
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

menu_onde = "div"
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

ordem 				= tplic(0, trim(request("ordem")))
ordenacao			= trim(request("ordenacao"))
processo 			= tplic(1,request("ftabproccont.processo_c"))
ddt_cad 			= request("ddt_cad")
adt_cad				= request("adt_cad")
periodo				= tplic(1, request("fperiodicidade_c"))
orgao 				= tplic(1,request("ftribunal_sync_c"))
desc1 				= tplic(1,request("desc1_c0"))
status	 			= tplic(0,request("fstatus"))
ultimo_proc			= request("chk_ultimo_processo")

'Filtro para ordenação
if ordem = "" or ordem = "tbConexaoTribunais_Andamentos.processo" then
	FiltroOrdem = "tbConexaoTribunais_Andamentos.processo " & ordenacao & ", data DESC"
end if

if ordem = "tbConexaoTribunais_Andamentos.data" then
	FiltroOrdem = "tbConexaoTribunais_Andamentos.data " & ordenacao & ", tbConexaoTribunais_Andamentos.processo ASC" 
end if

if ordem = "tbConexaoTribunais_Andamentos.qtd_andamentos_baixados" then
	FiltroOrdem = "tbConexaoTribunais_Andamentos.qtd_andamentos_baixados " & ordenacao & ", tbConexaoTribunais_Andamentos.processo ASC, tbConexaoTribunais_Andamentos.data ASC" 

end if

'Controle de filtros para exibir em impressão'
if len(ordem) > 0 then
	
	strFiltros = strFiltros &" Ordenação: " 
	strFiltros = strFiltros & "<b>" &RetornaTipoConculta(ordem) &"</b>"
	strFiltros = strFiltros & " (" & RetornaDescricaoOrdem(ordenacao) & "),"
	


end if

sql = " 1 = 1 "
if not isnull(processo) and not IsEmpty(processo) and len(trim(processo)) > 0 then
	sql = sql & " and tbConexaoTribunais_Andamentos.processo like '%" & processo & "%'"

	'aqui eu estou pegando a variavel criada concatenando e printando ela na tela'
	'com o html '
	strFiltros = strFiltros & " Processo: <b>" & trim(processo) & "</b>,"

end if

if isdate(request("ddt_cad")) then
	sql= sql & " and (data >= "&rdata(ddt_cad)&") "

	strFiltros = strFiltros & " Data de Sincronização:  <b>" & ddt_cad & " </b>"

end if

if isdate(request("adt_cad")) then
	sql= sql & " and (data < "&rdata(DateAdd("d", 1, request("adt_cad")))&") "

	strFiltros = strFiltros & "  até <b>" & adt_cad  & "</b>,"

end if

if not isnull(periodo) and not IsEmpty(periodo) and len(trim(periodo)) > 0 then
	if periodo = 5 then
		sql = sql & " and fl_ping_feitopor_botao_online = 1 "
	else
		sql = sql & " and tbConexaoTribunais_Andamentos.periodo_consulta = '" & periodo & "' and fl_ping_feitopor_botao_online = 0 "
	end if
	strFiltros = strFiltros & " Período: <b>" & retornaDescricaoPeriodicidade(periodo) & "</b>,"
end if

if not isnull(orgao) and not IsEmpty(orgao) and len(trim(orgao)) > 0 then
	sql = sql & " and id_tribunal = '" &orgao& "' "

	dim varOrgao 

	if isnumeric(orgao) then 
		varOrgao = ObterDescricaoOrgaoGerencial(orgao)

		else 
			varOrgao = ObterDescricaoOrgaoOficial(orgao)
	end if 
	
	strFiltros = strFiltros &" Órgão: <b>" &varOrgao& "</b>,"

end if

if not isnull(desc1) and not IsEmpty(desc1) and len(trim(desc1)) > 0 then
	sql= sql & " and (texto like '%"& desc1 &"%' or (case when fl_erro = 1 then '' else 'Sincronizado com sucesso.' end like '%"& desc1 &"%')) "
	strFiltros = strFiltros &" Mensagem: <b>"&desc1&"</b>,"
end if

if not isnull(status) and not IsEmpty(status) and len(trim(status)) > 0 then
	sql = sql & " and fl_erro = '" & status & "'"
	strFiltros = strFiltros &" Status da Sincronização: <b>"&retornaStatus(status)&" </b>,"
end if
if not isnull(ultimo_proc) and not IsEmpty(ultimo_proc) and len(trim(ultimo_proc)) > 0 then
	sql = sql & " and tbConexaoTribunais_Andamentos.id in (select MAX(ID) as ultimo_id FROM tbConexaoTribunais_Andamentos where usuario = '"&session("vinculado")&"' and (fl_aguarda_robo_baixar_andamento = 0 or fl_aguarda_robo_baixar_andamento is null) group by usuario, processo, id_tribunal) "
	strFiltros = strFiltros & "<b> "&ultProcesso(ultimo_proc)&" </b>,"
end if

sql = "SELECT id_processo, tbConexaoTribunais_Andamentos.id, tbConexaoTribunais_Andamentos.processo, texto, id_tribunal, qtd_andamentos_baixados, data, CONVERT(varchar(8), data, 114) as hora, TabProcCont.pasta, case when fl_erro = 1 then  '' else '" & msgSinc & "' end as msg_sinc, " & _
	 	"case when fl_erro = '1' then 'Sim' else 'Não' end as fl_erro, fl_erro as err, id_tribunal, tbConexaoTribunais_Andamentos.usuario, " &_
		"case when fl_ping_feitopor_botao_online = 1 then 'Manual' else (case tbConexaoTribunais_Andamentos.periodo_consulta when '1' then 'Diária' when '2' then 'Semanal' when '3' then 'Quinzenal' when '4' then 'Mensal' end) end as periodicidade, nomeorgao = o.nome, TabProcCont.desc_res, TabProcCont.situacao " & _
		"from tbConexaoTribunais_Andamentos " & _
		"join TabProcCont on TabProcCont.processo = tbConexaoTribunais_Andamentos.processo " & _
		"and tbConexaoTribunais_Andamentos.usuario = TabProcCont.usuario " & _
		"join Isis.dbo.ORGAO o on o.sigla = tbConexaoTribunais_Andamentos.id_tribunal " & _
		"where tbConexaoTribunais_Andamentos.usuario = '"&session("vinculado")&"' and (fl_aguarda_robo_baixar_andamento = 0 or fl_aguarda_robo_baixar_andamento is null) " & _
		" and " & sql & "order by " & ordem
		
if Request("filtrar") = "ok" then
	pmarcados = replace(tplic(1,Request("pmarcados")),"#","'")
	pmarcados = replace(pmarcados,"''","','")
	sql2 = replace(replace(sql,"and order"," order"),"order by", " and tbConexaoTribunais_Andamentos.id in (" &pmarcados& ") order by ")
	strFiltros = strFiltros &"<b> Seleção Manual</b>,"
else
	sql2 = replace(sql,"and order"," order")
end if

session("sql2") = sql2

'Log ao retirar o relatório
ok = grava_log_c(session("nomeusu"),"LISTAGEM", "AUDITORIA DE CONEXÕES","Relatório de Auditoria de Conexões")

set rst = server.createobject("ADODB.Recordset")

'response.write session("sql2")

if request("DO") then 'Verificando se a pagina foi "chamada" pelo aviso de DO
	if  instr(lcase(session("sql2")),"order by p.processo") then
		sqlDO = "USE contencioso "& replace(lcase(session("sql2")),"order by tbConexaoTribunais_Andamentos.processo"," AND tbConexaoTribunais_Andamentos.id IN ("& request("processo") &") ORDER BY tbConexaoTribunais_Andamentos.processo ") 'SQL responsavel pela listagem dos itens na tela
	else
		response.end
	end if
	rst.open sqlDO, db, 3, 3
else 'Caso tenha sido chamado por outra tela, efetua o sql diferente.
	rst.open session("sql2"), db, 3, 3
end if
%>
<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">		
		<tr>		
			<td height="16px" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19px" height="18px">&nbsp;</td>
			<td height="16px" valign="middle" class="titulo">&nbsp;Relatório&nbsp;de&nbsp;Auditoria&nbsp;de&nbsp;Conexões&nbsp;&nbsp;</td>
			<td height="16px" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18px" border="0"></td>
			<td height="16px" valign="middle"><img src="imagem/tit_fim.gif" width="21px" height="16px"></td>

		</tr>		
</table>

<%
	'aqui eu removo a virgula'
		strFiltros = trim(strFiltros)
	If request("imprimir") <> "" then
	if len(strFiltros) > 0 then 
		strFiltros = left(strFiltros,len(strFiltros)-1) 
	end if 
%>

<table border="0" class="preto11" bgcolor="#ffffff" width="100%" align="center" >
	<tr><td colspan="10" >
		<span class="preto11">
			<b>Filtro(s):</b><br><%=strFiltros%>
		</span>
	</td>
	</tr>
</table>
	
<%
	End If
%>
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
		        document.getElementById('link_imp').disabled = 'disabled';
		        document.getElementById('link_imp').onmouseover = '';		
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
		<table bgcolor="#FFFFFF" width="100%" border="0" class="preto11" cellpadding="0" cellspacing="0">
			<tr>
				<td width="25%"><b>Processos = <%= rst.RecordCount %></b></td>
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
	<form action="auditoria_result.asp" name="frm" method="post" >				
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
			<% If Request("imprimir") <> "" then %>
			<tr>
				<td colspan="8">
					<img src="imagem/1px-preto.gif" width="100%" height="1" border="0">
				</td>
			</tr>
			<% end if%>
		<tr bgcolor="#00578F" class="tit1<%=l_imp%>">
			<%if request("imprimir") = "" then%>
			    <td align="center" width=4%><a href="javascript: marcar()"><img src="imagem/check_xp.gif" width="13" height="13" border="0"></a></td>
			<%end if%>
			<td width=20% align="center" nowrap><b>Data</b></td>
			<td width=6% align="center"><b>Erro</b></td>
			<td width=25%><b>Processo</b></td>
			<td width=3%><b>Órgão</b></td>
			<td width=30%><b>Mensagem</b></td>
			<td width=5% align="center"><b>Qtd</b></td>
			<td width=8% align="center"><b>Periodicidade</b></td>			
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
				%>
				<tr bgcolor=<%=cor%>>
					<%if request("imprimir") = "" then%><td width="13" align="center"><input type="checkbox" name="nproc<%= rst("id") %>" value="<%= rst("id") %>" onclick="marca_check('<%=rst("id") %>')"<% If instr(Request("pmarcados"),rst("id")) > 0 then %> checked<% End If %>></td><%end if%>
					<%If Request.Querystring("imprimir") = "" then %><% End If %>
					<td align="center"><%=fdata(rst("data")) & " " & rst("hora")%></td>
					<td align="center"><%=rst("fl_erro")%></td>
					<td nowrap><%if request("imprimir") <> "" then%><%=rst("processo")%><%else%><a class="preto11" href="processo.asp?id_processo=<%=rst("id_processo")%>&modulo=C&processo='<%=rst("processo")%>'&pasta=<%=rst("pasta")%>"><%=rst("processo")%></a><%End if%></td>
					<td align="center" title="<%=rst("nomeorgao")%>"><%=rst("id_tribunal")%></td>
					<td>
						<% if rst("err") = 1 then %>
							<%=rst("texto")%>
						<%else%>
							<%=msgSinc%>
						<%end if%>
					</td>
					<td align="center"><%=rst("qtd_andamentos_baixados")%></td>
					<td align="center"><%=rst("periodicidade")%>
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


<% 'linha q divide o form'%>
<% If Request("imprimir") <> "" then %>
<table bgcolor="#FFFFFF" width="100%" border="0" class="preto11" cellpadding="0" cellspacing="0" >
		
		<tr>
			<td>
				<img src="imagem/1px-preto.gif" width="100%" height="1" border="0">
			</td>
			
		</tr>
		
		<tr>
			<td height="1">&nbsp;<b>Total = <%= rst.RecordCount %></b></td>
		</tr>
		<tr>
			<td>
				<img src="imagem/1px-preto.gif" width="100%" height="1" border="0">
			</td>
		</tr>
		<%end if %>
	
</table>

	<%if request("imprimir") = "" then%>
		<table bgcolor="#FFFFFF" width="100%" border="0" class=preto11 cellpadding="0" cellspacing="0">
			<tr>
				<td width="25%"><b>Processos = <%= rst.RecordCount %></b></td>
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
	document.frm.action='auditoria_result.asp';
	document.frm.atual.value=<%= pagAtual+1 %>;
	document.frm.filtrar.value='<%= Request("filtrar") %>';
	document.frm.direcao.value='proxima';
	document.frm.submit();
}
	
function multi(){
	document.frm.action='auditoria_result.asp';
	document.frm.atual.value=<%= rst.PageCount %>;
	document.frm.filtrar.value='<%= Request("filtrar") %>';
	document.frm.submit();
}

function mante(){
	document.frm.action='auditoria_result.asp';
	document.frm.atual.value=<%= pagAtual-1 %>;
	document.frm.filtrar.value='<%= Request("filtrar") %>';
	document.frm.submit();
}
	
function mprim(){
	document.frm.action='auditoria_result.asp';
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
		document.frm.action='auditoria_result.asp';
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
'funções do filtro'
Function RetornaDescricaoOrdem(prmOrdem)

	'RetornaDescricaoOrdem = "Ordenação: <b>" & prmOrdem & "</b><br> "
	select case prmOrdem
		case "ASC"
			retorno = "Crescente"
		case "DESC"
			retorno = "Decrescente"
	end select
	RetornaDescricaoOrdem =  retorno 

end function

function RetornaTipoConculta(prmTipo)

	retorno = "Data"
	
	select case prmTipo

		case "tbConexaoTribunais_Andamentos.processo"

			retorno = "Processo"

		case "tbConexaoTribunais_Andamentos.qtd_andamentos_baixados"

			retorno = "Quantidade"
	end select 

		RetornaTipoConculta = retorno 
		
end function

'essa função retorna Descricao Periodicidade'
Function retornaDescricaoPeriodicidade (prmPeriodicidade)
	
	select case prmPeriodicidade
	 case "5" 
	 	retorno = "Manual"
	 case "1"
	 	retorno = "Diária"
	 case "2"
	 	retorno = "Semanal"
	 case "3"
	 	retorno = "Quinzenal"
	 case "4"
	 	retorno = "Mensal"
	end select
		retornaDescricaoPeriodicidade = retorno								
end function

'Função para status da sincronização'
Function retornaStatus (prmStastus)

		retorno = "Todos"
	select case prmStastus
	case "1"
		retorno = "Com erro"
	case "0"
		retorno = "Sem erro"
	end select 
	retornaStatus = retorno

end function 

function ultProcesso (prmUltProcesso)
	
	select case prmUltProcesso
	case "1"

		retorno = " Somente o último de cada processo"
	
	end select
		ultProcesso = retorno

end function
%>