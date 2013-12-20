<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn_webseek.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<!--#include file='../include/Db_open_webseek_teste.asp'-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<%
vid_processo = request("id_processo")
rowcount = 0
sql = "SELECT id, prazo_ger, prazo_ofi, desp, rpi, descricao, executada, hora, advogado, id_item_checagem FROM Providencias "
sql = sql & "WHERE (processo COLLATE SQL_Latin1_General_CP1_CI_AS = (SELECT processo FROM Contencioso.dbo.TabProcCont WHERE id_processo = " & vid_processo & ")) "
sql = sql & "and (usuario = '"&session("vinculado")&"' or usuario = '"&session("vinculado")&"##"&session("nomeusu")&"') "
sql = sql & "and (tipo = 'C' or tipo = 'T') order by prazo_ofi desc, prazo_ger desc, id desc"

%>
<html>
	<head>
		<title>APOL Jurídico</title>
		<link rel="STYLESHEET" type="text/css" href="style.css"> 
		<script language="javascript" src="valida.js"></script>
		<script language="JavaScript" src="../include/funcoes.js"></script>
		<script language="JavaScript" src="../include/jquery-1.3.1.js"></script>
		<script>
			jQuery.noConflict();
			jQuery(function(){
				var altura_table = jQuery("table").height();
				var qtd = document.frmpro.qtd_linhas.value;
				if (qtd > 0) {
					if(altura_table == 0){
						altura_table = (qtd * 28) + 5;
					}
				}
				jQuery("#frame_providencia", top.document).css("height", altura_table);
			});
			
			function fecha_prov(){
				window.scroll(0, temp);
				MM_showHideLayers('exclui_prov','','hide');
			}
			
			var x1, x2;		
			function conf_excluir_prov(x1,pid){
				salva_ocor = document.frmpro.salva_ocor.checked;
				window.location='../grava_provid.asp?tipo=del&onde=detproc&pmarcados='+pid+'&salva_ocor='+salva_ocor+'&id_processo='+x1+'&modulo=c&cabeca=exc';
				fecha_prov();	
			}
			
			function abrirjanela(url, width,  height){
				varwin=window.open(url,"openscript",'width='+width+',height='+height+',resizable=0,scrollbars=yes,status=yes');
			}			
		</script>
	</head>
	<body leftmargin="0" topmargin="0" bgcolor="#efefef">
		<form name="frmpro" method="post">
		<%
		if (Session("cont_cons_prov")) or (Session("adm_adm_sys")) then
			set rs_pro = conn.execute(sql)%>
			<a name="hist">
			<table width="100%" class="tabela" border="0" cellspacing="2" cellpadding="3" bgcolor="#efefef">
			<%
			do while not rs_pro.eof	
				rowcount = rowcount+1%>	 			
				<tr>
					<td class="preto11" align="left" width="4%"><% if (Session("cont_exc_prov")) or (Session("adm_adm_sys")) then %><a href="javascript: top.mostra_prov(<%=rs_pro("id")%>, '<%=rs_pro("advogado")%>')" class="linkp11"><%if vid_processo <> "" then %><img src="imagem/lixeira.gif" alt="Excluir" width="13px" height="17px" border="0"><%end if%></a><% Else %><img src="imagem/1px-transp.gif" width="13px" height="17px" border="0"><% End If %></td>
					<td class="preto11" width="4%" align="left"><% If rs_pro("executada") then %><img src="imagem/check.gif" width="15px" height="13px"><% Else %><% End If %></td>
					<td class="preto11" width="3%" align="left"><% If ((not isnull(rs_pro("id_item_checagem"))) and trim(rs_pro("id_item_checagem")) <> "") then %><img src="../imagem/item_chec/9.jpg" alt="Item de Checagem" width="15px" height="13px"><% Else %><% End If %></td>
					<td class="preto11" width="15%" align="center"><% If (rs_pro("prazo_ger") = "") OR (isnull(rs_pro("prazo_ger"))) then %>--<% Else %><%= fdata(rs_pro("prazo_ger"))%><% End If %></b></td>
					<td class="preto11" width="15%" align="center"><% If (rs_pro("prazo_ofi") = "") OR (isnull(rs_pro("prazo_ofi"))) then %>--<% Else %><%= fdata(rs_pro("prazo_ofi"))%><% End If %></b></td>
					<td class="preto11" width="64%"><a href="javascript: abrirjanela('../edit_providencia.asp?id_processo=<%=id_processo%>&cabeca=nao&onde=detproc&id=<%= rs_pro("id") %>&modulo=C',560,465)" class="preto11<%=l_imp%>" target="_top"><% If (rs_pro("hora") <> "") and (not isnull(rs_pro("hora"))) then %><%= rs_pro("hora") %> - <% End If %><% If (rs_pro("rpi") <> "") and (not isnull(rs_pro("rpi"))) then %><%= rs_pro("rpi") %> - <% End If %><% If (rs_pro("desp") <> "") and (not isnull(rs_pro("desp"))) then %><%= rs_pro("desp") %> - <% End If %><%=rs_pro("descricao")%></b></a></td>
				</tr>
				<%
				rs_pro.movenext
			loop
			%>
			</table>
	
		<%
		Else
			rowcount = 1 %>
			<table width="748" class="tabela<%=l_imp%>" border="0" cellspacing="2" cellpadding="3" bgcolor="#efefef">					
				<tr><td>&nbsp;&nbsp;Usuário sem permissão de acesso a providências.</td></tr>
			</table>
		<% End If %>
		<input type="hidden" name="qtd_linhas" value="<%=rowcount%>">
		</form>
	</body>
</html>