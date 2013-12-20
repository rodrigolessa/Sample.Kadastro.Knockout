<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../patente/include/funcoes.asp"-->
<!--#include file="../contrato/conn_v.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<%
vid_processo = request("id_processo")
sql = "select codigo as [id], (select processo from contencioso.dbo.TabProcCont where id_processo = v.processo1) as processo, processo2 as vinculado, sigla_pais as sigla_pais_processo, 'C' as tipo_origem, tipo, case tipo WHEN 'C' THEN 'Jurídico' WHEN 'M' THEN 'Marca' WHEN 'MI' THEN 'Marca Inter.' WHEN 'P' THEN 'Patente' WHEN 'PI' THEN 'Patente Inter.' WHEN 'V' THEN 'Contratos' WHEN 'D' THEN 'Domínios' END as ordem, case tipo WHEN 'C' THEN (select processo from contencioso.dbo.TabProcCont where id_processo = v.processo2) WHEN 'M' THEN processo2 WHEN 'P' THEN processo2 WHEN 'V' THEN (select codigo from apol_contratos.dbo.contrato where id_contrato = v.processo2) WHEN 'D' THEN (select dominio from apol.dbo.Dominios where [id] = v.processo2) END as ordem_proc, obs from contencioso.dbo.tabvincproc v where usuario = '" &Session("vinculado")& "' and processo1 = '"&tplic(0,vid_processo)&"' union "
sql = sql & "select [id], vinculado, processo, sigla_pais, 'M' as tipo_origem, 'M' as tipo, 'Marca' as ordem, processo as ordem_proc, obs from apol.dbo.vinculado v  where usuario = '"&session("vinculado")&"' and vinculado = '"&tplic(0,vid_processo)&"' union "
sql = sql & "select [id], naturezav+vinculado, naturezap+processo, sigla_pais, 'P' as tipo_origem, 'P' as tipo, 'Patente' as ordem, naturezap+processo, obs from apol_patentes.dbo.vinculado v where usuario = '"&session("vinculado")&"' and vinculado = '"&tplic(0,vid_processo)&"' union "
sql = sql & "select codigo as [id], vinculado, processo, sigla_pais_processo, 'PI' as tipo_origem, 'PI' as tipo, 'Patente Inter.' as ordem, processo, obs from apol_patentes.dbo.pi_vinculado v where usuario = '"&session("vinculado")&"' and vinculado = '"&tplic(0,vid_processo)&"' and ISNULL(sigla_pais_vinculado, '') = '" & request("pais") & "' union "
sql = sql & "select codigo as [id], vinculado, processo, sigla_pais_processo, 'MI' as tipo_origem, 'MI' as tipo, 'Marca Inter.' as ordem, processo, obs from apol.dbo.mi_vinculado v where usuario = '"&session("vinculado")&"' and vinculado = '"&tplic(0,vid_processo)&"' and ISNULL(sigla_pais_vinculado, '') = '" & request("pais") & "' union "
sql = sql & "select codigo as [id], vinculado, id_dominio, sigla_pais_dominio, 'D' as tipo_origem, 'D' as tipo, 'Domínios' as ordem, id_dominio, obs from apol.dbo.dominios_vinculado v  where usuario = '"&session("vinculado")&"' and vinculado = '"&tplic(0,vid_processo)&"' and ISNULL(sigla_pais_vinculado, '') = '" & request("pais") & "' union "
sql = sql & "select codigo, processo2, processo1, sigla_pais, 'C' as tipo_origem, 'C' as tipo, 'Jurídico' as ordem, (select processo from contencioso.dbo.TabProcCont where id_processo = v.processo1) as ordem_proc, obs from contencioso.dbo.tabvincproc v where usuario = '"&session("vinculado")&"' and processo2 = '"&tplic(0,vid_processo)&"' union "
sql = sql & "select id_vinculado, contrato_anexo, contrato_principal, sigla_pais, 'V' as tipo_origem, 'V' as tipo, 'Contratos' as ordem, (select codigo from apol_contratos.dbo.contrato where id_contrato = v.contrato_principal) as ordem_proc, obs from apol_contratos.dbo.vincula_contrato v  where usuario = '"&session("vinculado")&"' and contrato_anexo = '"&tplic(0,vid_processo)&"' "
sql = sql & "order by ordem, ordem_proc"

set rs_pro = db.execute(sql)
rowcount = 0
tipo_origem = "C"
%>
<html>
	<head>
		<title>APOL Jurídico</title>
		<link rel="STYLESHEET" type="text/css" href="style.css"> 
		<script language="javascript" src="valida.js"></script>
		<script language="JavaScript" src="../include/funcoes.js"></script>
		<script language="JavaScript" src="../include/funcoes.js"></script>
		<script language="JavaScript" src="../include/jquery-1.3.1.js"></script>
		<script>
			jQuery.noConflict();
			jQuery(function(){
				var altura_table = jQuery("table").height();
				var qtd = document.frmvinc.qtd_linhas.value;
				top.document.all.frame_vinculado.height = 0;
				if (qtd > 0) {
					if(altura_table == 0){
						altura_table = (qtd * 25) + 5;
					}
					jQuery("#frame_vinculado", top.document).css("height", altura_table);
				}
			});
			
			function conf_excluir(a01,a11,a21,a31,a41){
				if (a01=='vinc'){	
					document.frmvinc.action='processo_vinculo_excluir.asp?tipo_modulo=' +a41+ '&id_processo=<%=request("id_processo")%>&codigo='+a11+'&modulo_vinculo=' + a21 +'&vinculado='+a31;
				}
				document.frmvinc.submit();
			}
			
			function abrirjanela(url, width,  height) {
				varwin=window.open(url,"openscript",'width='+width+',height='+height+',resizable=0,scrollbars=yes,status=yes');
			}	
			
			function abrirjanela_mod(url, nome) {
				var width = 788;
				var height = 718;
				var LeftPosition, TopPosition;
				if (screen.width == 800){
					LeftPosition = 0;
					TopPosition = 0;
				}
				else{
					LeftPosition = (screen.width) ? (screen.width-width)/2 : 0;
					TopPosition = (screen.height) ? (screen.height-height-60)/2 : 0;
				}
				varwin=window.open(url,nome,'width='+width+',height='+height+',resizable=0,top='+TopPosition+',left='+LeftPosition+',scrollbars=yes,status=no');
				varwin.focus();
			}		
		</script>
	</head>

	<body leftmargin="0" topmargin="0" bgcolor="#efefef">
		<table width="748" class="tabela" border="0" cellspacing="2" cellpadding="3" bgcolor="#efefef">		
		<form name="frmvinc" method="post">
		<%
		do while not rs_pro.eof
			rowcount = rowcount+1%>
		<tr>
			<td width="4%" valign="middle"><a href="javascript: top.mostra_exc('vinc','<%=rs_pro("id")%>','<%=rs_pro("ordem")%>', document.frmvinc.proc_<%=rowcount%>.value,'<% If rs_pro("tipo_origem") = tipo_origem then %><%= tipo_origem %><% Else %><%= rs_pro("tipo") %><% End If %>','frame_vinculado')" class="linkp11"><%if vid_processo <> "" then %><img src="imagem/lixeira.gif" alt="Excluir" width="13" height="17" border="0"><%end if%></a></td>
			<%if rs_pro("tipo") = "V" then%>
				<%sql = "SELECT id_contrato, codigo FROM Contrato WHERE id_contrato = '"&rs_pro("vinculado")&"' AND usuario = '"&session("vinculado")&"'"
				set rs_v = conn_v.execute(sql)
				if not rs_v.eof then
				%>
				<td class="preto11" width="17%" align="left"><a href="javascript:abrirjanela('<% If rs_pro("tipo_origem") = tipo_origem then %>edit_vinculados.asp?id=<%= rs_pro("id") %>&processo=<%=rs_pro("processo")%>&vinculado=<%= rs_v("codigo") %>&modulo_vinculado=<%=rs_pro("ordem")%><% Else %>../contrato/edit_vinculados.asp?id_vinculado=<%= rs_pro("id") %>&processo=<%= rs_v("codigo") %>&vinculado=<%=rs_pro("processo")%>&modulo_vinculado=Juridico<% End If %>&modulo=C',600,170)" class="preto11<%=l_imp%>">Contratos</a></td>
				<td class="preto11" width="26%" align="left"><a href="javascript:abrirjanela_mod('../contrato/contrato.asp?modulo=V&id_contrato=<%=rs_v("id_contrato")%>','popver')" class="preto11<%=l_imp%>"><%= rs_v("codigo") %></a></b></td>
				<input type="hidden" name="proc_<%=rowcount%>" value="<%= rs_v("codigo") %>">
				<% Else %>
				<td class="preto11" width="17%" align="left">Contratos</td>
				<td class="preto11" width="26%" align="left">Vinculação Incorreta</td>
				<% End If %>
			<%elseif rs_pro("tipo") = "P" then%>
				<td class="preto11" width="17%" align="left"><a href="javascript:abrirjanela('<% If rs_pro("tipo_origem") = tipo_origem then %>edit_vinculados.asp?id=<%= rs_pro("id") %>&processo=<%=rs_pro("processo")%>&vinculado=<%=rs_pro("vinculado")%>&modulo_vinculado=<%=rs_pro("ordem")%><% Else %>../patente/edit_vinculados.asp?id=<%= rs_pro("id") %>&processo=<%=rs_pro("vinculado")%>&vinculado=<%=rs_pro("processo")%>&modulo_vinculado=Juridico<% End If %>&modulo=C',600,170)" class="preto11<%=l_imp%>">Patente</a></td>
				<td class="preto11" width="26%" align="left"><a href="javascript:abrirjanela_mod('../patente/detalhe_pat.asp?modulo=P&id_proc=<%= mid(rs_pro("vinculado"),3,len(rs_pro("vinculado"))) %>&nat=<%= left(rs_pro("vinculado"),2) %>','poppat')" class="preto11<%=l_imp%>"><% If left(rs_pro("vinculado"),2) <> "ND" then %><%= left(rs_pro("vinculado"),2) %>&nbsp;<% End If %><%= mid(rs_pro("vinculado"),3,len(rs_pro("vinculado"))) %><% If left(rs_pro("vinculado"),2) <> "ND" then %>-<%= geradigito(mid(rs_pro("vinculado"),3,len(rs_pro("vinculado")))) %><% End If %></a></b></td>
				<input type="hidden" name="proc_<%=rowcount%>" value="<%= rs_pro("vinculado") %>">
			<%elseif rs_pro("tipo") = "PI" then
				sql = "SELECT codigo FROM apol_patentes.dbo.pi_processos WHERE natureza+numero_processo = '"&rs_pro("vinculado")&"' AND usuario = '"&session("vinculado")&"' and codigo_pais_deposito = '" & rs_pro("sigla_pais_processo") &"'"
				set rs_p = conn.execute(sql)
				if not rs_p.eof then
			%>
				<td class="preto11" width="17%" align="left"><a href="javascript:abrirjanela('<% If rs_pro("tipo_origem") = tipo_origem then %>edit_vinculados.asp?id=<%= rs_pro("id") %>&processo=<%=rs_pro("processo")%>&vinculado=<%=rs_pro("vinculado")%>&modulo_vinculado=<%=rs_pro("ordem")%><% Else %>../patente/edit_vinculados.asp?id=<%= rs_pro("id") %>&processo=<%=rs_pro("vinculado")%>&vinculado=<%=rs_pro("processo")%>&modulo_vinculado=Juridico<% End If %>&pais=<%=request("pais")%>&tipo=PI&modulo=<%=rs_pro("tipo_origem")%>',600,170)" class="preto11<%=l_imp%>"><%=rs_pro("ordem")%></a></td>
				<td class="preto11" width="26%" align="left"><a href="javascript:abrirjanela_mod('../patente/pi_processodados.asp?pch=res&pcod=<%= rs_p("codigo") %>','poppat')" class="preto11<%=l_imp%>"><%= left(rs_pro("vinculado"),2) %>&nbsp;<%= mid(rs_pro("vinculado"),3, len(rs_pro("vinculado"))) %></a></b></td>
				<input type="hidden" name="proc_<%=rowcount%>" value="<%= rs_pro("vinculado") %>">
				<% Else %>
				<td class="preto11" width="17%" align="left">Patente Inter.</td>
				<td class="preto11" width="26%" align="left">Vinculação Incorreta</td>
				<% End If %>
			<%elseif rs_pro("tipo") = "M" or rs_pro("tipo") = "" then%>
				<td class="preto11" width="17%" align="left"><a href="javascript:abrirjanela('<% If rs_pro("tipo_origem") = tipo_origem then %>edit_vinculados.asp?id=<%= rs_pro("id") %>&processo=<%=rs_pro("processo")%>&vinculado=<%=rs_pro("vinculado")%>&modulo_vinculado=<%=rs_pro("ordem")%><% Else %>../edit_vinculados.asp?id=<%= rs_pro("id") %>&processo=<%=rs_pro("vinculado")%>&vinculado=<%=rs_pro("processo")%>&modulo_vinculado=Juridico<% End If %>&modulo=C',600,170)" class="preto11<%=l_imp%>">Marca</a></td>
				<td class="preto11" width="26%" align="left"><a href="javascript:abrirjanela_mod('../detalhe_proc.asp?modulo=M&id_proc=<%= rs_pro("vinculado") %>','popmar')" class="preto11<%=l_imp%>"><%= rs_pro("vinculado") %></a></b></td>
				<input type="hidden" name="proc_<%=rowcount%>" value="<%= rs_pro("vinculado") %>">
			<%elseif rs_pro("tipo") = "MI" then
				sql = "SELECT codigo FROM mi_processos WHERE numero_processo = '"&rs_pro("vinculado")&"' AND usuario = '"&session("vinculado")&"' and codigo_pais_deposito = '" & rs_pro("sigla_pais_processo") &"'"
				set rs_m = conn.execute(sql)
				if not rs_m.eof then
			%>
				<td class="preto11" width="17%" align="left"><a href="javascript:abrirjanela('<% If rs_pro("tipo_origem") = tipo_origem then %>edit_vinculados.asp?id=<%= rs_pro("id") %>&processo=<%=rs_pro("processo")%>&vinculado=<%=rs_pro("vinculado")%>&modulo_vinculado=<%=rs_pro("ordem")%><% Else %>../edit_vinculados.asp?id=<%= rs_pro("id") %>&processo=<%=rs_pro("vinculado")%>&vinculado=<%=rs_pro("processo")%>&modulo_vinculado=Juridico<% End If %>&pais=<%=request("pais")%>&tipo=MI&modulo=<%=rs_pro("tipo_origem")%>',600,170)" class="preto11<%=l_imp%>"><%=rs_pro("ordem")%></a></td>
				<td class="preto11" width="26%" align="left"><a target="_top" href="../mi_processodados.asp?pch=res&pcod=<%= rs_m("codigo") %>" class="preto11<%=l_imp%>"><%= rs_pro("vinculado") %></a></b></td>
				<input type="hidden" name="proc_<%=rowcount%>" value="<%= rs_pro("vinculado") %>">
				<% Else %>
				<td class="preto11" width="17%" align="left">Marca Inter.</td>
				<td class="preto11" width="26%" align="left">Vinculação Incorreta</td>
				<% End If %>
			<%elseif rs_pro("tipo") = "D" then
				sql = "SELECT dominio FROM Dominios WHERE id = "&rs_pro("vinculado")&" AND usuario = '"&session("vinculado")&"'"
				set rs_m = conn.execute(sql)
				if not rs_m.eof then%>
				<td class="preto11" width="17%" align="left"><a href="javascript:abrirjanela('<% If rs_pro("tipo_origem") = tipo_origem then %>edit_vinculados.asp?id=<%= rs_pro("id") %>&processo=<%=rs_pro("processo")%>&vinculado=<%= rs_m("dominio") %>&modulo_vinculado=<%=rs_pro("ordem")%><%else%>../edit_vinculados.asp?id=<%= rs_pro("id") %>&processo=<%= rs_m("dominio") %>&vinculado=<%=rs_pro("processo")%>&modulo_vinculado=Juridico<% End If %>&pais=<%=request("pais")%>&tipo=D&modulo=<%=rs_pro("tipo_origem")%>',600,170)" class="preto11<%=l_imp%>"><%=rs_pro("ordem")%></a></td>
				<td class="preto11" width="26%"	align="left"><a target="_top" href="../detalhe_dominio.asp?pch=res&pcod=<%= rs_pro("vinculado") %>" class="preto11<%=l_imp%>"><%= rs_m("dominio") %></a></b></td>
				<input type="hidden" name="proc_<%=rowcount%>" value="<%= rs_m("dominio") %>">
				<% Else %>
				<td class="preto11" width="17%" align="left">Dom&iacute;nio</td>
				<td class="preto11" width="26%" align="left">Vinculação Incorreta</td>
				<% End If %>
			<%elseif rs_pro("tipo") = "C" then%>
				<%sql = "SELECT id_processo,processo FROM TabProcCont WHERE id_processo = '"&rs_pro("vinculado")&"' AND usuario = '"&session("vinculado")&"'"
				set rs_v = db.execute(sql)
				if not rs_v.eof then
				%>
				<td class="preto11" width="17%" align="left"><a href="javascript:abrirjanela('<% If rs_pro("tipo_origem") = tipo_origem then %>edit_vinculados.asp?id=<%= rs_pro("id") %>&processo=<%=rs_pro("processo")%>&vinculado=<%= rs_v("processo") %>&modulo_vinculado=<%=rs_pro("ordem")%><% Else %>../contencioso/edit_vinculados.asp?id=<%= rs_pro("id") %>&processo=<%= rs_v("processo") %>&vinculado=<%=rs_pro("processo")%><% End If %>&modulo_vinculado=Juridico&modulo=C',600,170)" class="preto11<%=l_imp%>">Jurídico</a></td>		
				<td class="preto11" width="26%" align="left"><a target="_top" href="processo.asp?modulo=C&id_processo=<%=rs_v("id_processo")%>" class="preto11<%=l_imp%>"><%= rs_v("processo") %></a></b></td>
				<input type="hidden" name="proc_<%=rowcount%>" value="<%= rs_v("processo") %>">
				<% Else %>
				<td class="preto11" width="17%" align="left">Jurídico</td>
				<td class="preto11" width="26%"align="left">Vinculação Incorreta</td>
				<% End If %>
			<%end if%>
			<td class="preto11" align="left" width="50%"><%=rs_pro("obs")%></td>
			<td align="right" width="1%">
			<%
			if rs_pro("tipo") = "C" then
				set rstp = db.execute("select apenso from tabvincproc where codigo = '"&tplic(0,rs_pro("id"))&"' and processo1 = '"&tplic(0,vid_processo)&"'")
				if not rstp.eof then
					apenso_sql = trim(rstp("apenso"))
				else
					apenso_sql = "N"
				end if
			end if%>
			
			<%if apenso_sql <> "" then%>
				<%= replace(replace(apenso_sql,"S","Sim"),"N","Não") %>
			<% Else %>
				<% response.write "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" %>
			<% End If %>
			</td>
		</tr>
			<%
			apenso_sql = ""
			rs_pro.movenext
		loop
		%>
			<input type="hidden" name="qtd_linhas" value="<%=rowcount%>">
		</form>
		</table>
	</body>
</html>