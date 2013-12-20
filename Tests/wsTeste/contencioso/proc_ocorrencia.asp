<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn_webseek.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<!--#include file='../include/Db_open_webseek_teste.asp'-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<%
vid_processo = request("id_processo")
processo = request("processo")
sql = "SELECT ocorrencias.id, ocorrencias.data, full_ocorrencia = ocorrencias.ocorrencia, ocorrencias.tipo, ocorrencias.tipo_ocorrencia,  ocorrencias.descricao as nome, ocorrencias.protocolo, CASE WHEN LEN(LTRIM(RTRIM(CAST(ocorrencias.ocorrencia AS VARCHAR (2000))))) > 100 THEN CAST(ocorrencias.ocorrencia AS VARCHAR (100)) + '...' ELSE CAST(ocorrencias.ocorrencia AS VARCHAR(2000)) END as ocorrencia, ocorrencias.descricao_outro_idioma, ocorrencias.detalhe_outro_idioma "&_
" FROM ocorrencias LEFT OUTER JOIN Tipo_Ocorrencia ON ocorrencias.tipo_ocorrencia = Tipo_Ocorrencia.id_tipo_ocorrencia WHERE (ocorrencias.processo = '"&tplic(0,processo)& "') AND (ocorrencias.usuario = '"&Session("vinculado")&"') and ocorrencias.tipo = '" & request("tipo_ocorr") & "' order by ocorrencias.data desc, ocorrencias.id DESC"

set rs_pro = server.createobject("ADODB.Recordset")  
rs_pro.open sql, conn, 3, 3 
 
rowcount = 0
%>
<html>
	<head>
		<title>APOL Jurídico</title>
		<link rel="stylesheet" type="text/css" href="style.css"> 
		<script language="javascript" src="valida.js"></script>
		<script language="JavaScript" src="../include/funcoes.js"></script>
		<script language="JavaScript" src="../include/jquery-1.3.1.js" type="text/javascript"></script>
		<script language="JavaScript" src="../include/jquery-ui-1.7.2.custom.min.js"></script>
		<script>
			jQuery.noConflict();
			jQuery(function(){
				var altura_table = jQuery("table").height();
				var qtd = document.frmocor.qtd_linhas.value;
				if (qtd > 0) {
					if(altura_table == 0){
						altura_table = (qtd * 28) + 5;
					}
				}
				jQuery("#frame_ocorrencia<%=Replace(request("tipo_ocorr"), "C", "")%>", top.document).css("height", altura_table);
			});
		
			function conf_excluir(a01,a11,a21,a31,a41,a51){
				if (a01=='ocor'){
					document.frmocor.action='ocorrencia_excluir.asp?id_processo=<%=request("id_processo")%>&codigo='+a11+'&processo='+a21+'&tipo_ocorr=<%=request("tipo_ocorr")%>';
				}
				document.frmocor.submit();
			}
		
			function abrirjanela(url, width,  height) {
				varwin=window.open(url,"openscript",'width='+width+',height='+height+',resizable=0,scrollbars=yes,status=yes');
			}			
		</script>
	</head>
	
	<body leftmargin="0" topmargin="0" bgcolor="#efefef">
		<table width="748" class="tabela" border="0" cellspacing="2" cellpadding="3" bgcolor="#efefef">
		<form name="frmocor" method="post">
		<%
		do while not rs_pro.eof
		rowcount = rowcount+1%>	 			
		<tr valign="top">
			<td class="preto11" align="left" width="3%" valign="top"><% if (Session("cont_exc_ocor")) or (Session("adm_adm_sys")) then %><a href="javascript: top.mostra_exc('ocor','<%=rs_pro("id")%>','<%=processo%>','','','frame_ocorrencia<%=Replace(request("tipo_ocorr"), "C", "")%>')" class="linkp11"><%if vid_processo <> "" then %><img src="imagem/lixeira.gif" alt="Excluir" width="13" height="17" border="0"><%end if%></a><% Else %><img src="imagem/1px-transp.gif" width="13" height="17" border="0"><% End If %></td>
			<td class="preto11" width="3%" align="center" valign="top">
			<%
			if not isnull(rs_pro("descricao_outro_idioma")) and _
				not trim(rs_pro("descricao_outro_idioma")) = "" or _
				not isnull(rs_pro("detalhe_outro_idioma")) and _
				not trim(rs_pro("detalhe_outro_idioma")) = "" then
				%><img src="../imagem/icon_idioma3.png" alt="Possui descrição em outro idioma" width="16" height="16" border="0"><%
			end if 
			%>
			</td>
			<td class="preto11" width="16%" align="center" valign="top"><%= fdata(rs_pro("data")) %></td>
			<td class="preto11" width="20%" align="left" valign="top">&nbsp;<%= rs_pro("nome") %></td>
			<td class="preto11" width="21%" align="left" valign="top">&nbsp;<%= rs_pro("protocolo") %></td>
			<td class="preto11" width="55%" valign="top"><%if Len(rs_pro("full_ocorrencia")) > 100 then%><img src="imagem/mais.gif" style="cursor:hand" title="Expandir Detalhe" id="altura_<%= rs_pro("id") %>" onclick="javascript:top.mostra_ocorrencia('<%=Replace(request("tipo_ocorr"), "C", "")%>', '<%=rs_pro("id")%>', '<%=rowcount%>', jQuery('#altura_<%= rs_pro("id") %>').position().top)">&nbsp;<%end if%><a href="javascript:abrirjanela('../edit_ocorrencia.asp?id=<%= rs_pro("id") %>&modulo=C&vid=<%=vid_processo%>&id_proc=<%=processo%>',560,300)" class="preto11"><% If rs_pro("tipo") = "T" then %><img src="imagem/simb_sync.gif" align="absmiddle" width="16" height="16" border="0"><% End If %><%=rs_pro("ocorrencia")%></a></td>
		</tr>
		<%
			rs_pro.movenext
		loop%>			
		<input type="hidden" name="qtd_linhas" value="<%=rowcount%>">
		</form>
		</table>
	</body>
</html>