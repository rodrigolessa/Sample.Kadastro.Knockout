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

mostrartudo = request.querystring("mostrartudo")

sqland = ""
if mostrartudo = 0 then  '0=mostra tudo - 1=ocultar
	sqland = " and (ocultar is null or ocultar = 0) "
end if

if vid_processo = "" and processo <> "" then
	set rsProc = conn.execute("select id_processo from Contencioso.dbo.TabProcCont where processo = '"&processo&"' and usuario = '"&session("vinculado")&"'")
	if not rsProc.eof then
		vid_processo = rsProc("id_processo")
	end if
end if

sql = "SELECT id, data, ocultar, full_ocorrencia = descricao_andamento, descricao as nome, protocolo, CASE WHEN LEN(LTRIM(RTRIM(CAST(descricao_andamento AS VARCHAR (2000))))) > 100 THEN CAST(descricao_andamento AS VARCHAR (100)) + '...' ELSE CAST(descricao_andamento AS VARCHAR(2000)) END as ocorrencia, descricao_outro_idioma, detalhe_outro_idioma "
sql = sql & " FROM Contencioso..tb_Andamentos WHERE (id_processo = '"&tplic(0,vid_processo)& "') "
sql = sql & sqland
sql = sql & " order by data desc, id DESC"

set rs_pro = server.createobject("ADODB.Recordset")  
rs_pro.open sql, conn, 3, 3 

quantanda  = 0

if not rs_pro.eof then
	if mostrartudo = 1 then
		quantanda = rs_pro.recordcount
	else
		sqly = "SELECT quantanda FROM Parametros WHERE usuario = '"&session("vinculado")&"'"
		set rsC= db.execute(sqly)
		quantanda= 0
		if not rsC.EOF then
			if trim(rsC("quantanda")) <> "" or not isnull(rsC("quantanda")) then
				quantanda= rsC("quantanda")	
			else
				quantanda = 10
			end if
		end if
	end if
end if

rowcount = 1

'Nome do parâmetro Andamento
par_andam = "Andamento"
set rsParam = conn.execute("select andamentos from Contencioso.dbo.Parametros where usuario = '"&session("vinculado")&"' ")
if not rsParam.eof then
	if len(trim(rsParam("andamentos"))) > 0 then
		par_andam = trim(rsParam("andamentos"))
	end if
end if
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
			function MostraEscondeOculto(faz, tipocor, proc )
			{
				window.location.href='proc_andamento.asp?id_processo='+proc+'&processo='+proc+'&tipo_ocorr=T&mostrartudo='+faz;
				//document.frmanda.submit();
			}
	
			jQuery.noConflict();
				jQuery(function(){
				var altura_table = jQuery("table").height();
				var qtd = document.frmanda.qtd_linhas.value;
				if (qtd > 0) {
					if(altura_table == 0){
						altura_table = (qtd * 28) + 5;
					}
				}
				jQuery("#frame_ocorrenciaT", top.document).css("height", altura_table);

				//jQuery("#frame_ocorrenciaT<%=Replace(request("tipo_ocorr"), "T", "")%>", top.document).css("height", altura_table);
			});
		
			function conf_excluir(a01,a11,a21,a31,a41,a51){
				if (a01=='ocor'){
					document.frmanda.action='ocorrencia_excluir.asp?id_processo='+proc+'&mostrartudo='+faz+'&processo='+proc+'&tipo_ocorr='+tipocor;
				}
				document.frmanda.submit();
			}
		
			function abrirjanela(url, width,  height) {
				varwin=window.open(url,"openscript",'width='+width+',height='+height+',resizable=0,scrollbars=yes,status=yes');
			}			


		</script>
	</head>
	
	<body leftmargin="0" topmargin="0" bgcolor="#efefef">
			<table width="748" class="tabela" border="0" cellspacing="2" cellpadding="3" bgcolor="#efefef">
				<form name="frmanda" method="post" >
					<%if not rs_pro.eof then
						For i = 1 to quantanda
							rowcount = rowcount+1%>	 
							<tr valign="top">
								<td class="preto11" align="left" width="2%" valign="top"><a href="javascript: top.conf_gerar_prov('ocor','<%=rs_pro("id")%>','<%=processo%>','<%=rs_pro("ocorrencia")%>','','frame_ocorrenciaT<%=Replace(request("tipo_ocorr"), "T", "")%>')" class="linkp11"><img src="imagem/clonar.jpg" alt="Gerar Providência a partir desse <%=par_andam%>" border="0"></a></td>			
								<td class="preto11" width="1%" align="center" valign="top"><%if rs_pro("ocultar") then %><img src="imagem/andamento_oculto.png" alt="<%=par_andam%> oculto" border="0"><%else%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%end if%></td>
								<td class="preto11" width="8%" align="center" valign="top"><%= fdata(rs_pro("data")) %></td>
								<td class="preto11" width="17%" align="left" valign="top">&nbsp;<%= rs_pro("nome") %></td>
								<td class="preto11" width="52%" valign="top"><%if Len(rs_pro("full_ocorrencia")) > 100 then%><img src="imagem/mais.gif" style="cursor:hand" title="Expandir Detalhe" id="altura_<%= rs_pro("id") %>" onclick="javascript:top.mostra_andamento('<%=Replace(request("tipo_ocorr"), "C", "")%>', '<%=rs_pro("id")%>', '<%=rowcount%>', jQuery('#altura_<%= rs_pro("id") %>').position().top)">&nbsp;<%end if%><a href="javascript:abrirjanela('../edit_ocorrencia.asp?id=<%= rs_pro("id") %>&modulo=T&vid=<%=vid_processo%>&id_proc=<%=processo%>&contrib=T&txtanda=<%=request("textoanda")%>',560,300)" class="preto11"><%=rs_pro("ocorrencia")%></a></td>
							</tr>
							<%
						rs_pro.movenext
						if rs_pro.eof then								
							exit for
							end if
						Next
					end if%>
	 				<%
					'Verifica se possui andamentos ocultos
					set rsOculto = conn.execute("select 1 from ocorrencias where ocorrencias.processo = '"&tplic(0,processo)& "'" &_
					" and ocorrencias.usuario = '"&Session("vinculado")&"' " &_
					" and ocorrencias.tipo = 'T' and visivelresp = 1 ")
					ocultos = 0
					if not rsOculto.eof then
						ocultos = 1
					end if
					%>
					<input type="hidden" name="qtd_linhas" value="<%=rowcount%>">
						<td colspan="6">	
							<%if (quantanda > 0 and rowcount > 0) or (quantanda = 0 and rowcount > 0 and ocultos > 0) then
								if  mostrartudo <> 1 then%>
									<img src="../imagem/tit_ld.gif" width="95%" height="18" border="0"><img src="../imagem/tit_fim.gif" width="21" height="16"><a id="olholink" href="javascript: MostraEscondeOculto(1,'T','<%=vid_processo%>')"><img id="olhoimg" src="../imagem/exibe.png" alt="Exibir Andamentos Ocultos" border=0></a>
								<%end if
								if  mostrartudo = 1 then%>
									<img src="../imagem/tit_ld.gif" width="95%" height="18" border="0"><img src="../imagem/tit_fim.gif" width="21" height="16"><a id="olholink" href="javascript: MostraEscondeOculto(0,'T','<%=vid_processo%>')"><img id="olhoimg" src="../imagem/esconde.png" alt="Esconder Andamentos Ocultos"  border=0></a>
								<%end if
							end if%>
						</td>
				</form>
			</table>
	</body>
</html>