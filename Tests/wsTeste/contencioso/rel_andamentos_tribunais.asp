<%
if session("voltar") = "/apol/contencioso/processo_list.asp" then
	session("voltar") = "../main.asp?modulo=C"
else
	session("voltar") = Request.ServerVariables("HTTP_REFERER")
end if
%>
<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="../usuario_logado.asp"-->
<!--#include file="../include/dbconn.asp"-->
<%

if (not Session("cont_rel_anda")) and (not Session("adm_adm_sys")) then
	bloqueia
	response.end
end if

menu_onde = "proc"

set rsp2 = db.execute("SELECT ocorrencia, andamentos, campo1, campo2, campo3, campo4 FROM Parametros WHERE usuario = '"&session("vinculado")&"'")

If not rsp2.eof then
	ocorrencia = rsp2("ocorrencia")
	andamentos_T = rsp2("andamentos")
Else
	ocorrencia = ""
	andamentos_T = "Andamento"
End If		

%>
<html>
	<head>
		<title>APOL Jurídico</title>
		<%
			 Dim strFiltros
		%>
		<link rel="STYLESHEET" type="text/css" href="style.css">
		<link href="../adm/css/jquery-ui-1.10.3.custom.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="valida.js"></script>
		<script language="javascript" src="../include/funcoes.js"></script>

		<script language="JavaScript" src="../adm/js/jquery-1.4.4.min.js" type="text/javascript"></script>
		<script language="JavaScript" src="../adm/js/jquery-ui-1.8.9.custom.min.js" type="text/javascript"></script>
		<script language="JavaScript" src="../adm/js/jquery.ui.datepicker-pt-BR.js" type="text/javascript"></script>
		<script language="JavaScript" src="../adm/js/jquery.maskedinput-1.2.2.js" type="text/javascript"></script>
		<script>
			var fixo = true;
			var posiX = 300;
			var posiY = 340;
			
			 var $ = jQuery.noConflict();
			
			//Configurando calendarios 
	        jQuery(document).ready(function(){
	           jQuery(".data").mask("9?9/99/9999",{placeholder:" "}).datepicker(); 
	        });
			
			function txtBoxFormat(objForm, strField, sMask, evtKeyPress) {
				var i, nCount, sValue, fldLen, mskLen,bolMask, sCod, nTecla;
				if(document.all) { // Internet Explorer
					nTecla = evtKeyPress.keyCode; 
				}
				else if(document.layers) { // Nestcape
					nTecla = evtKeyPress.which;
				}
			
				sValue = objForm[strField].value;
			
				// Limpa todos os caracteres de formatação que
				// já estiverem no campo.
				sValue = sValue.toString().replace( "-", "" );
				sValue = sValue.toString().replace( "-", "" );
				sValue = sValue.toString().replace( ".", "" );
				sValue = sValue.toString().replace( ".", "" );
				sValue = sValue.toString().replace( "/", "" );
				sValue = sValue.toString().replace( "/", "" );
				sValue = sValue.toString().replace( "(", "" );
				sValue = sValue.toString().replace( "(", "" );
				sValue = sValue.toString().replace( ")", "" );
				sValue = sValue.toString().replace( ")", "" );
				sValue = sValue.toString().replace( " ", "" );
				sValue = sValue.toString().replace( " ", "" );
				fldLen = sValue.length;
				mskLen = sMask.length;
			
				i = 0;
				nCount = 0;
				sCod = "";
				mskLen = fldLen;
			
				while (i <= mskLen) {
					bolMask = ((sMask.charAt(i) == "-") || (sMask.charAt(i) == ".") || (sMask.charAt(i) == "/"))
					bolMask = bolMask || ((sMask.charAt(i) == "(") || (sMask.charAt(i) == ")") || (sMask.charAt(i) == " "))
			
					if (bolMask) {
						sCod += sMask.charAt(i);
						mskLen++; 
					}
					else {
						sCod += sValue.charAt(nCount);
						nCount++;
					}
					i++;
				}
			
				objForm[strField].value = sCod;
			
				if (nTecla != 8) { // backspace
					if (sMask.charAt(i-1) == "9") { // apenas números...
						return ((nTecla > 47) && (nTecla < 58)); 
					}
					else { // qualquer caracter...
						return true;
					} 
				}
				else {
					return true;
				}
			}
			
			function valida(){
					
				
				if ((document.frm.ddt_cad.value != "") && (document.frm.adt_cad.value != "")){
					data1 = document.frm.ddt_cad.value.split("/");
					data2 = document.frm.adt_cad.value.split("/");
					primeira = new Date(data1[2],data1[1],data1[0]);
					ultima = new Date(data2[2],data2[1],data2[0]);
		
					diferenca = ultima - primeira;
					if (diferenca < 0){
						alert("Data inicial deve ser menor do que a data final.");
						document.frm.ddt_cad.focus();
						return false;
					}
				}

				if (document.frm.ddt_cad.value != ""){
					if (!doDate(document.frm.ddt_cad.value,5)){
						alert("Preencha os campos corretamente.");
						frm.ddt_cad.focus();
						return false;
					}		
				}

				if (document.frm.adt_cad.value != ""){
					if (!doDate(document.frm.adt_cad.value,5)){
						alert("Preencha os campos corretamente.");
						frm.adt_cad.focus();
						return false;
					}		
				}				
				
				return true;
			}	
		</script>	
	</head>


	<body leftmargin="0" topmargin="0" class="preto11">
		
		<!--#include file="../include/clsPesquisa.asp"-->
		<%
		Set pesq = new clsPesquisa
		pesq.cor_titulo "#345C46"
		pesq.addparam "mod|tipo_env"
		pesq.Create "Selecionar Envolvido","Envolvido","../img_comp/","../busca_env_tipo.asp","-90","0"
		%>
		<!--#include file="header.asp"-->
		<table cellpadding="0" cellspacing="0" border="0" width="100%" class="titulo">
			<tr>		
				<td height="16" valign="middle" width="23">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18"></td>
				<td height="16" valign="middle" align=center nowrap>&nbsp;Relatório&nbsp;de&nbsp;<%=andamentos_C%>&nbsp;</td> 
				<td height="16" width=820px background="imagem/tit_ld.gif"><img src="imagem/1px-transp.gif" width="1" height="16"></td>
				<td height="16" valign="middle" width=20px><img src="imagem/tit_fim.gif" width="21" height="16"></td>
				<td height="16" valign="middle">&nbsp;</td>
			</tr>


		</table>
		<table width="99%" class="tabela" border="0" cellspacing="2" cellpadding="2">
		<form action="processo_anda_result.asp" name="frm" method="post" onsubmit="return valida()">
		<input type="hidden" id="mod" name="mod" value="contencioso">
			<tr>
				<td width="10%">Ordena&ccedil;&atilde;o:</td>
				<td>
					<select name="ordem" class="cfrm">
						<option value="o.data" selected>Data</option>
						<option value="p.pasta">Pasta</option>	
						<option value="p.processo" >Processos</option>					
						<option value="p.situacao">Situa&ccedil;&atilde;o</option>
					</select>
					<select class="cfrm" name="ordenacao">
						<option value="ASC" >Crescente</option>
						<option value="DESC" selected>Decrescente</option>
					</select>
				</td>
				<td align="left">Mostrar:</td>
				<td align="left" nowrap >
					&nbsp;<input type="Checkbox" name="andamentosocultos" value="on">Ocultos&nbsp;
				</td>
			</tr>
			<tr>
				<td align="left">Processo:</td>
				<td align="left">
					<input class="cfrm" type="text" name="ftabproccont.processo_c" maxlength="35" style="width:230">
				</td>
				<td align="left" width="8%" nowrap>Tipo Processo:</td>
				<td align="left" nowrap>
					&nbsp;&nbsp;<select class="cfrm" name="ftabproccont.tipo_c" style="width:110">
						<option value=""></option>
						<option value="J" title="Judicial">Judicial</option>
						<option value="A" title="Administrativo">Administrativo</option>
					</select>
				</td>
			</tr>		
			<tr>
				<td align="left">Objeto:</td>
				<td align="left">
					<input class="cfrm" type="text" name="ftabproccont.desc_res" maxlength="30" style="width:230">
				</td>
				<td align="left">Competência:</td>
				<td align="left" colspan="3">
					&nbsp;&nbsp;<select class="cfrm" name="fcompetencia_c" style="width:110">
						<option value=""></option>
						<option value="F" title="Federal">Federal</option>
						<option value="E" title="Estadual">Estadual</option>
						<option value="M" title="Municipal">Municipal</option>
					</select>
			</tr>
			<tr>
				<td align="left">Tipo do Envolvido:</td>
				<td align="left">
					<%					
						set rsEnv = conn.execute("Select id_tipo_env, nome_tipo_env from Tipo_Envolvido where usuario = '"&Session("vinculado")&"' and contencioso = 1 order by nome_tipo_env")
					%>
					<select name="tipo_env" class="cfrm" style="width:187px;" onchange="limpa_pesq();">
						<option value=""></option>
						<%					
						do while not rsEnv.eof
							%>
							<option value="<%= rsEnv("id_tipo_env") %>"><%= rsEnv("nome_tipo_env") %></option>
							<%
							rsEnv.movenext
						loop
						%>
					</select>
				</td>
				<td align="left">Posição:</td>
				<td align="left" nowrap>
					&nbsp;&nbsp;<select class="cfrm" name="fparticipante_c" style="width:110">
						<option value=""></option>
						<option value="A" title="Autor">Autor</option>
						<option value="R" title="Réu">Réu</option>
					</select>
				 </td>
			</tr>
			<tr>
				<td align="left">Envolvido:</td>
				<td align="left">
					<% pesq.campo_pesq_per "pesc_cli_div", "apelido", "sel_apelido()", "230" %><input type="hidden" name="env">
				</td>
				<td>Responsável:</td>
				<td>
				<%					
					set rs = conn.execute("Select id, nome from responsaveis where tipo <> 'cliente' and usuario = '"&Session("vinculado")&"' order by nome")
				%>
				&nbsp;&nbsp;<select name="txt_responsavel" class="cfrm" style="width:174px;">
					<option value=""></option>
					<%					
					do while not rs.eof
						%>
						<option title="<%= rs("nome") %>" value="<%= rs("id") %>"><%= rs("nome") %></option>
						<%
						rs.movenext
					loop
					%>
				</select>
				</td>
			</tr>
			<tr>
				<td align="left">Pasta:</td>
				<td align="left">
					<input type="text" name="fpasta_c" maxlength="30" style="width:125" class="cfrm">&nbsp;&nbsp;<input type="Checkbox" name="pastaexata" value="0">Exata
				</td>
				<%  If (andamentos_T <> "") and (not isnull(andamentos_T )) then%>
					<td align="left">Data de <%=andamentos_T%>:</td>
				<%else%>
					<td align="left" nowrap>Data de Andamento:</td>
				<% end if%>
				<td align="left" colspan="3">	
					&nbsp;&nbsp;<input type="text" class="cfrm data" name="ddt_cad" size="10" maxlength="10"> -> 
					<input type="text" class="cfrm data" name="adt_cad" size="10" maxlength="10">
				</td>
			</tr>
			<tr>
				<%  If (andamentos_T  <> "") and (not isnull(andamentos_T)) then%>
					<td align="left">Descrição de <%=andamentos_T%>:</td>
				<%else%>
					<td align="left" nowrap>Descrição de Andamento:</td>
				<% end if%>
				<td align="left" colspan="3">
					<input type="text" class="cfrm" id="desc1_c0" name="desc1_c0" size="25" maxlength="45" style="width:330; height:19"> 
				</td>
			</tr>
			<tr>
				<td align="left" nowrap>Órgãos:</td>
				<td align="left" colspan="2">
								<select class="cfrm" name="forgao_n"  style="width:330">
									<option value=""></option>
									<%
									sqlT = "SELECT id, sigla, nome FROM ORGAO where ind_ativo = 1 and sigla <> 'INPI' order by nome, sigla "
									set rsT = dbconn.execute(sqlT)
									do while not rsT.eof%>
										<option value="<%=rsT("sigla")%>"><%=rsT("sigla")%> - <%=rsT("nome")%></option>
											<%rsT.MoveNext
									loop
									%>
								</select>
								</td>
								<td align="left">
								&nbsp; </td>	
			</tr>
			<tr>
				<td colspan="4" align="center" height="20">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="4" align="center" height="27"><input name="bts" class="cfrm" type="submit" value="Pesquisar">&nbsp;&nbsp;<input type="reset" onclick="<%= pesq.limpa_campo_pesq("pesc_cli_div", "apelido") %>" class="cfrm" value="Limpar"></td>
			</tr>
		</form>
		</table>
		<p>&nbsp;</p>
	</body>
</html>
<script language="Javascript">
	function sel_apelido(){
		<%= pesq.link_pesq("pesc_cli_div", "apelido") %>
	}	
	
	function limpa_pesq(){
		$('res_div_<%= pesq.identidade %>').update('');
		$('res_div_<%= pesq.identidade %>').innerHtml;
		$('busca_cli_<%= pesq.identidade %>').value = '';
		<%= pesq.limpa_campo_pesq("pesc_cli_div", "apelido") %>
	}
</script>