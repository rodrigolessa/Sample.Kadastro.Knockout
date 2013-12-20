<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn_webseek.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<!--#include file='../include/Db_open_webseek_teste.asp'-->
<!--#include file='../include/Db_open_usuarios.asp'-->

<!--#include file="../include/helpers/inc_StringHelper.asp"-->
<%
'================
'Page Variables'
'================
Dim strUrlCadastroClienteExterno, CodigoCadastroExterno 

Sub CarregarParametros()

	Dim sqlC
	Dim rsC
	
	CodigoCadastroExterno = ""
	
	sqlC = "select campo1_adm, campo2_adm, exibe_inventor_adm, UrlCadastroClienteExterno, UrlPastaClienteExterno from parametros where usuario = '" & session("vinculado") & "'"
	'response.Write("sqlC "&sqlC&"<br><br>")
	set rsC = conn.execute(sqlC)	
	
    if not rsC.EOF then

    	strUrlCadastroClienteExterno = rsC("UrlCadastroClienteExterno")
	    'response.Write("strUrlCadastroClienteExterno "&strUrlCadastroClienteExterno&"<br><br>")
	    
	end if

end sub

call CarregarParametros 


%>

<%
vid_processo = request("id_processo")
sql = "SELECT    contencioso.dbo.TabCliCont.principal,APOL.dbo.Tipo_Envolvido.id_tipo_env,contencioso.dbo.TabCliCont.codigo,APOL.dbo.Envolvidos.apelido, APOL.dbo.Envolvidos.pasta, APOL.dbo.Envolvidos.id, "&_
	" APOL.dbo.Tipo_Envolvido.nome_tipo_env FROM contencioso.dbo.TabCliCont LEFT OUTER JOIN APOL.dbo.Envolvidos ON "&_
	" APOL.dbo.Envolvidos.id = contencioso.dbo.TabCliCont.envolvido LEFT OUTER JOIN APOL.dbo.Tipo_Envolvido ON "&_
	" APOL.dbo.Tipo_Envolvido.id_tipo_env = contencioso.dbo.TabCliCont.tipo_env WHERE (contencioso.dbo.TabCliCont.usuario = '"&Session("vinculado")&"') "&_
	" AND contencioso.dbo.TabCliCont.processo = '"&tplic(0,vid_processo)&"' ORDER BY APOL.dbo.Tipo_Envolvido.nome_tipo_env, APOL.dbo.Envolvidos.apelido"

	'response.write sql
	set rs = db.execute(sql)
	rowcount = 0
%>
<html>
	<head>
		<title>APOL Jurídico</title>
		<link rel="STYLESHEET" type="text/css" href="style.css"> 

        <script language="JavaScript" src="../include/javascripts/main.js" type="text/javascript"></script>
        <link href="../include/stylesheets/main.css" type="text/css" rel="Stylesheet" />

		<script language="javascript" src="valida.js"></script>
		<script language="JavaScript" src="../include/funcoes.js"></script>
		<script language="JavaScript" src="../include/jquery-1.3.1.js" type="text/javascript"></script>
		<script language="JavaScript" src="../include/jquery-ui-1.7.2.custom.min.js"></script>
		<script>
			jQuery.noConflict();
			jQuery(function(){
				var altura_table = jQuery("table").height();
				var qtd = document.frmcli.qtd_linhas.value;
				top.document.all.frame_envolvidos.height = 0;
				if (qtd > 0) {
					if(altura_table == 0){
						altura_table = (qtd * 28) + 1;
					}
					jQuery("#frame_envolvidos", top.document).css("height", altura_table);
				}
			});
			
			function conf_excluir(a01,a11,a21,a31,a41,a51){
				if (a01=='cli'){
					document.frmcli.action='envolvidos_del.asp?id_processo=<%=request("id_processo")%>&codigo='+a11+'&processo='+a21+'&tipo='+a31+'&id='+a41;
				}
				document.frmcli.submit();
			}

			function abrirjanela(url, width,  height) {
				varwin=window.open(url,"openscript",'width='+width+',height='+height+',resizable=0,scrollbars=yes,status=no');
			}		
		</script>
	</head>
	<body leftmargin="0" topmargin="0" bgcolor="#efefef">
		<table width="748" class="tabela" border="0" cellspacing="2" cellpadding="3" bgcolor="#efefef">	
		<form name="frmcli" method="post">
		<%
		do while not rs.eof	
			set rs_end = conn.execute("SELECT * FROM Endereco_Env WHERE id_env = '"&rs("id")&"'")
			set rs_cont = conn.execute("SELECT * FROM Contato_Env WHERE id_env = '"&rs("id")&"'")
			
    			
		    sql_cod_cad_ext = " SELECT coalesce(CodigoCadastroExterno,null,'') as CodigoCadastroExterno FROM Envolvidos  where id = '"&rs("id")&"' "
		    'response.Write("sql_cod_cad_ext "&sql_cod_cad_ext&"<br><br>")		
            set rs_cadastro_externo = conn.execute(sql_cod_cad_ext) 
            
            if not rs_cadastro_externo.eof then
                CodigoCadastroExterno = rs_cadastro_externo("CodigoCadastroExterno")
            end if			
    			
			rowcount = rowcount+1%>
			<tr bgcolor="<%= cor %>">
				<td width="3%" align="center"><a href="javascript: top.mostra_exc('cli','<%=rs("codigo")%>','<%=vid_processo%>','<%=rs("id_tipo_env")%>','<%=rs("id")%>','frame_envolvidos')" class="preto11<%=l_imp%>"><%if vid_processo <> "" then %><img src="imagem/lixeira.gif" alt="Excluir" width="13" height="17" border="0"><%end if%></a></td>
				<td class="preto11" width="25%"><a href="javascript: abrirjanela('../edit_cliente.asp?id=<%=rs("codigo")%>&id_proc=<%=vid_processo%>&modulo=C&processo=<%=processo%>',400,300)" class="preto11<%=l_imp%>"><%=rs("nome_tipo_env")%></a><%If rs("principal") = true Then%>&nbsp;<img src="../imagem/principal.gif" alt="Principal" width="12" height="11" border="0"><%End If%>

    		    <%If Not IsEmpty2(strUrlCadastroClienteExterno) Then %>
    		        <%If Not IsEmpty2(CodigoCadastroExterno) Then %>
				        <!-- Cadastro Cliente Externo -->
				        <a href="javascript:void(0);" title="Clique aqui para abrir o link externo do cliente" class="cliente_externo" onclick="javascript:abrirCadastroExterno('<%=strUrlCadastroClienteExterno%>', '<%=CodigoCadastroExterno %>');"></a>
                    <%End If%>
                <%End If%>				
				
				</td>
				<td class="preto11" width="37%"><%= rs("apelido") %></td>
				<td class="preto11" width="25%"><% If rs("pasta") = "" or isnull(rs("pasta")) then %><% Else %><%= rs("pasta") %><% End If %></td>
				<td class="preto11" align="center" width="7%">
				<%if not rs_end.eof then%>&nbsp;<a href="javascript: abrirjanela('../ficha_env.asp?modulo=C&tipo=end&id_env=<%=rs("id")%>',700,235)" class="preto11"><img src="../imagem/endereco.gif" alt="Endereços" width="14" height="14" border="0"></a>&nbsp;<%End If%><%if not rs_cont.eof then%>&nbsp;<a href="javascript: abrirjanela('../ficha_env.asp?modulo=C&tipo=cont&id_env=<%=rs("id")%>',700,235)" class="preto11"><img src="../imagem/contato.gif" alt="Contatos" width="16" height="15" border="0"></a>&nbsp;<%End If%></td>
			</tr>
		<%	rs.movenext
		loop%>
			<input type="hidden" name="qtd_linhas" value="<%=rowcount%>">
		</form>
		</table>
	</body>
</html>