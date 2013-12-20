<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn_webseek.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<!--#include file='../include/Db_open_webseek_teste.asp'-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<%
vid_processo = request("id_processo")
sql = "SELECT * FROM TabValCont WHERE processo = "&tplic(1,vid_processo)&" ORDER BY data DESC, codigo DESC"
set rstv = db.execute(sql)
rowcount = 0
%>
<html>
	<head>
		<title>APOL Jurídico</title>
		<link rel="STYLESHEET" type="text/css" href="style.css"> 
	
		<script language="javascript" src="valida.js"></script>
		<script language="JavaScript" src="../include/funcoes.js"></script>
		<script language="JavaScript" src="../include/jquery-1.3.1.js" type="text/javascript"></script>
		<script language="JavaScript" src="../include/jquery-ui-1.7.2.custom.min.js"></script>
		<script>
			jQuery.noConflict();
			jQuery(function(){
				var altura_table = jQuery("table").height();
				top.document.all.frame_valores.style.height = 0;
				if (document.frmval.qtd_linhas.value > 0) {
					if(altura_table == 0){
						altura_table = (document.frmval.qtd_linhas.value*28) + 5;
					}
					jQuery("#frame_valores", top.document).css("height", altura_table);
				}
			});
		
			function conf_excluir(a01,a11,a21,a31,a41,a51){
				if (a01=='val'){
					document.frmval.action='valores_excluir.asp?id_processo=<%=request("id_processo")%>&codigo='+a11+'&processo='+a21;
				}
				document.frmval.submit();
			}
				
			function abrirjanela(url, width,  height) {
				varwin=window.open(url,"openscript",'width='+width+',height='+height+',resizable=0,scrollbars=yes,status=yes');
			}
		</script>
	</head>
	<body leftmargin="0" topmargin="0" bgcolor="#efefef">
		<table width="748" class="tabela<%=l_imp%>" border="0" cellspacing="1" cellpadding="1" bgcolor="#efefef">
		<form name="frmval" method="post">
		<%
		do while not rstv.eof
			rowcount = rowcount+1
			vreferencia = rstv("referencia")
			moeda = rstv("moeda")%>
			<tr>				
				<td class="preto11" width="4%" align="left"><a href="javascript: top.mostra_exc('val','<%=rstv("codigo")%>','<%=processo%>','','','frame_valores')" class="linkp11"><%if vid_processo <> "" then %><img src="imagem/lixeira.gif" alt="Excluir" width="13" height="17" border="0"><%end if%></a></td>
				<td class="preto11" width="12%" align="center"><a href="javascript: abrirjanela('valores.asp?modulo=C&codigo=<%=rstv("codigo")%>&id=<%=vid_processo%>&id_proc=<%= processo %>',640,190)" class="preto11<%=l_imp%>"><%=fdata(rstv("data"))%></a></td>
				<td class="preto11" width="15%" align="right"><% If (rstv("valor") <> "") and (not isnull(rstv("valor"))) then %><%=formatNumber(rstv("valor"),2)%><% End If %>&nbsp;</td>
				<td class="preto11" width="7%" align="center"><%=rstv("moeda")%></td>
				<td class="preto11" width="35%" align="left">
				<%if trim(vreferencia) = "" or isnull(vreferencia) then
					response.write "&nbsp;"
				else
					sql = "Select descricao from Auxiliares where codigo = '"&trim(vreferencia)&"'"
					set rstv1 = db.execute(sql)
					if not rstv1.eof then
					response.write rstv1("descricao")
					end if%>
				<%end if%>
				</td>
				<td class="preto11" width="30%" align="left"><%=rstv("obs")%></td>				
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