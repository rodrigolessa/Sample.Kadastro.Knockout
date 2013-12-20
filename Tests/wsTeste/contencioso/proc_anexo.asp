<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn_webseek.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<!--#include file='../include/Db_open_webseek_teste.asp'-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<%
sql = "SELECT  Documentos.id_processo,Tipo_anexo.nome as tipo_anexo, Tipo_anexo.contrato, Documentos.dt_cadastro, Documentos.nome, Documentos.descricao, Documentos.id_doc "&_
	" FROM Documentos LEFT OUTER JOIN Tipo_anexo ON Documentos.id_tipo_anexo = Tipo_anexo.id_tipo_anexo "&_
	" WHERE (Documentos.id_processo = '"&tplic(0,request("id_processo"))& "') AND (Documentos.usuario = '"&session("vinculado")&"') "&_
	" AND (Documentos.modulo = 'C') ORDER BY Documentos.dt_cadastro DESC"
set rs_pro = conn.execute(sql)%>
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
				var qtd = document.frmanexo.qtd_linhas.value;
				top.document.all.frame_anexo.height = 0;
				if (qtd > 0) {
					if(altura_table == 0){
						altura_table = (qtd * 30) + 10;
					}
					jQuery("#frame_anexo", top.document).css("height", altura_table);
				}
			});
			
			function conf_excluir(a01,a11,a21){
				if (a01=='anexo'){
					document.frmanexo.action='../apaga_anexo.asp?modulo=C&id_processo='+a21+'&id_doc='+a11;
				}
				document.frmanexo.submit();
			}

			function abrirjanela(url, width,  height,tam) {
				varwin=window.open(url,"openscript",'width='+width+',height='+height+',resizable='+tam+',scrollbars=yes,status=yes');
			}		
	</script>
	</head>



	<body leftmargin="0" topmargin="0" bgcolor="#efefef">
		<table width="748" class="tabela" border="0" cellspacing="2" cellpadding="3" bgcolor="#efefef">
		<form name="frmanexo" method="post">	
		<%rowcount = 0
		do while not rs_pro.eof	
		rowcount = rowcount+1%>	 			
		<tr>
			<td width="3%" align="center"><% if ((Session("cont_manut_proc")) or (Session("adm_adm_sys"))) then %><a href="javascript: top.mostra_exc('anexo','<%=rs_pro("id_doc")%>','<%=rs_pro("id_processo")%>','','','frame_anexo')" class="preto11<%=l_imp%>"><%if request("id_processo") <> "" then %><img src="imagem/lixeira.gif" alt="Excluir" width="13" height="17" border="0"><%end if%></a><%end if%></td>
			<td class="preto11" width="13%" align="center"><%= fdata(rs_pro("dt_cadastro"))%></td>
			<td width="3%"><a href="#" onclick="window.open('../ver_anexo.asp?id_doc=<%=rs_pro("id_doc")%>&id_processo=<%=rs_pro("id_processo")%>&download=ok', 'down', 'width=10,height=10,top=1000');"><img src="../imagem/down_rtf.gif" alt="Download Anexo" width="16" height="16" border="0" align="absmiddle"></a></td>
			<td class="preto11" width="28%" align="left"><a title="Abrir Anexo<%if len(rs_pro("nome")) > 30 then%> - <%=rs_pro("nome")%><%end if%>" href="javascript:abrirjanela('../ver_anexo.asp?id_doc=<%=rs_pro("id_doc")%>&id_processo=<%=rs_pro("id_processo")%>',640,480,'yes')" class="preto11"><%if len(rs_pro("nome")) > 30 then%><%= Left(rs_pro("nome"), 20) & "... " & right(rs_pro("nome"), 4)%><%else%><%=rs_pro("nome")%><%end if%></a></td>
			<td class="preto11" width="19%" align="left"><%=rs_pro("tipo_anexo")%></td>			
			<td class="preto11" width="34%" align="left"><% if ((Session("cont_manut_proc")) or (Session("adm_adm_sys"))) then %><a href="javascript:abrirjanela('../edit_anexo.asp?modulo=C&id_cont=<%=rs_pro("id_processo")%>&id_doc=<%=rs_pro("id_doc")%>',550,210,'no')" class="preto11"><%end if%><%if rs_pro("descricao") <> "" then%><%=rs_pro("descricao")%><%else%>(Sem Descrição)<%end if%></a></td>
		</tr>
			<%
			rs_pro.movenext
		loop
		%>
			<input type="hidden" name="qtd_linhas" value="<%=rowcount%>">
		</form>
		</table>
	</body>
</html>