<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<%
vid_processo = request("id_processo")
processo = request("num_proc")

sql = "SELECT id, tipo, data_intimacao, tipo_multa, valor_multa, estado_liminar FROM Liminares WHERE id_processo = '"&tplic(0, vid_processo)& "' and id_usuario = '"&session("codigo_vinculado")&"' order by data_intimacao desc, [id] desc"
set rstv = db.execute(sql)
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
				var qtd = document.frmval.qtd_linhas.value;
				top.document.all.frame_liminares.height = 0;
				if (qtd > 0) {
					if(altura_table == 0){
						altura_table = (qtd * 30) + 10;
					}
					jQuery("#frame_liminares", top.document).css("height", altura_table);
				}
			});
		
			function conf_excluir(a01,a11,a21,a31,a41,a51){
				if (a01 == 'liminar'){
					document.frmval.action='cad_liminar.asp?excluir=ok&id_processo=<%=vid_processo%>&id_liminar='+a11+'&num_proc=<%=processo%>';
				}
				document.frmval.submit();
			}
				
			function abrirjanela(url, width,  height) {
				varwin=window.open(url,"openscript",'width='+width+',height='+height+',resizable=0,scrollbars=yes,status=yes');
			}		
		</script>
	</head>
	<body leftmargin="0" topmargin="0" bgcolor="#efefef">
		<table width="748" class="tabela" border="0" cellspacing="1" cellpadding="1" bgcolor="#efefef">
		<form name="frmval" method="post">
		<%
		rowcount = 0
		do while not rstv.eof
			rowcount = rowcount+1%>
			<tr>				
				<td class="preto11" width="4%" align="left"><a href="javascript: top.mostra_exc('liminar','<%=rstv("id")%>','<%=vid_processo%>','','','frame_liminares')" class="linkp11"><%if vid_processo <> "" then %><img src="imagem/lixeira.gif" alt="Excluir" width="13" height="17" border="0"><%end if%></a></td>
				<td class="preto11" width="22%" align="left"><a href="javascript: abrirjanela('cad_liminar.asp?id_liminar=<%=rstv("id")%>&id_processo=<%=vid_processo%>&num_proc=<%= processo %>', 470, 230)" class="preto11<%=l_imp%>"><%=rstv("tipo")%></a></td>
				<td class="preto11" width="16%" align="center"><%=fdata(rstv("data_intimacao"))%></td>
				<td class="preto11" width="22%" align="left">&nbsp;<%=rstv("tipo_multa")%></td>
				<td class="preto11" width="17%" align="right"><% If (rstv("valor_multa") <> "") and (not isnull(rstv("valor_multa"))) then %><%=formatNumber(rstv("valor_multa"),2)%><% End If %>&nbsp;</td>
				<td class="preto11" width="21%" align="left">
				<%
				select case rstv("estado_liminar")
					case "V"
						Response.Write "Vigor"
					case "S"
						Response.Write "Suspenso"
					case "D"
						Response.Write "Definitivo"
					case "O"
						Response.Write "Outros"
				end select
				%>
				</td>				
			</tr>
			<%
			rstv.movenext
		loop
		%>		
			<input type="hidden" name="qtd_linhas" value="<%=rowcount%>">
		</form>
		</table>
	</body>
</html>