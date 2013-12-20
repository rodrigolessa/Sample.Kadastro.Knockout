<%
if session("voltar") = "/apol/contencioso/processo_list.asp" then
	session("voltar") = "../main.asp?modulo=C"
else
	session("voltar") = Request.ServerVariables("HTTP_REFERER")
end if
%>
<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn_webseek.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="../usuario_logado.asp"-->
<%
if (not Session("cont_cons_proc")) and (not Session("adm_adm_sys")) then
	bloqueia
	response.end
end if

sqlC = "select campo1, campo2, campo3, campo4, andamentos from parametros where usuario = '" & session("vinculado") & "'"
set rsC = db.execute(sqlC)
if not rsC.EOF then
	label_campo1 = rsC("campo1")
	label_campo2 = rsC("campo2")
	label_campo3 = rsC("campo3")
	label_campo4 = rsC("campo4")
	if isnull(label_campo1) or isempty(label_campo1) or len(trim(label_campo1)) = 0 then label_campo1 = "Campo 1"
	if isnull(label_campo2) or isempty(label_campo2) or len(trim(label_campo2)) = 0 then label_campo2 = "Campo 2"
	if isnull(label_campo3) or isempty(label_campo3) or len(trim(label_campo3)) = 0 then label_campo3 = "Campo 3"
	if isnull(label_campo4) or isempty(label_campo4) or len(trim(label_campo4)) = 0 then label_campo4 = "Campo 4"
	andamentos_T = rsC("andamentos")
else
	label_campo1 = "Campo 1"
	label_campo2 = "Campo 2"
	label_campo3 = "Campo 3"
	label_campo4 = "Campo 4"
	andamentos_T = "Andamento"
end if

menu_onde = "proc"
%>
<html>
	<head>
		<title>APOL Jurídico</title>
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


				// Validação para Ocorrências
				//-------------------------------------------------------------------------------------------
				var frmApol = document.frm;
				var OcorrenciaData1 = document.getElementById('ddt_ocorrencia_data').value;
				var OcorrenciaData2 = document.getElementById('adt_ocorrencia_data').value;
				var OcorrenciaDescricao = document.getElementById('descricaoOcorrencia').value;

				if(OcorrenciaData1!=""){
					if (!doDate(OcorrenciaData1,5)){
						alert("Preencha os campos corretamente.");
						frmApol.ddt_ocorrencia_data.focus();
						return false;
					}
				}

				if(OcorrenciaData2!=""){
					if (!doDate(OcorrenciaData2,5)){
						alert("Preencha os campos corretamente.");
						frmApol.adt_ocorrencia_data.focus();
						return false;
					}
				}

				if((OcorrenciaData1!="")&&(OcorrenciaData2!="")){
					data1 = OcorrenciaData1.split("/");
					data2 = OcorrenciaData2.split("/");
					primeira = new Date(data1[2],data1[1],data1[0]);
					ultima = new Date(data2[2],data2[1],data2[0]);
					diferenca = ultima - primeira
					if(diferenca < 0){
						alert("Data inicial deve ser menor do que a data final da Ocorrência.")
						frmApol.ddt_ocorrencia_data.focus();
						return false;
					}
				}

				if(OcorrenciaDescricao!=''){
					if(OcorrenciaDescricao.length<3){
						alert('O campo "Descrição/Detalhe" deve conter no mínimo 3 caracteres.');
						frmApol.descricaoOcorrencia.focus();
						return false;
					}
				}
				//-------------------------------------------------------------------------------------------


				var desc1, desc2, desc3;
				var eou1, eou2;
				desc1 = document.getElementById('|desc1_c');
				desc2 = document.getElementById('|desc2_c');
				desc3 = document.getElementById('|desc3_c');
				
				eou1 = document.getElementById('eou_1');
				eou2 = document.getElementById('eou_2');

				if(desc1.value == ''){
					if(desc2.value != ''){
						desc1.value = desc2.value;
						desc2.value = desc3.value;
						desc3.value = '';
						eou1.value = eou2.value;
					}
					if(desc3.value != ''){
						desc1.value = desc3.value;
						desc3.value = '';
					}
				}
				
				if(desc2.value == ''){
					if(desc3.value != ''){
						desc2.value = desc3.value;
						desc3.value = '';
						eou1.value = eou2.value;
					}
				}
		
				if (document.frm._dt_encerra1_d.value != ""){
					if (!doDate(document.frm._dt_encerra1_d.value, 5)){
						alert("Preencha os campos corretamente.");
						frm._dt_encerra1_d.focus();
						return false;
					}		
				}
					
				if (document.frm._dt_encerra2_d.value != ""){
					if (!doDate(document.frm._dt_encerra2_d.value,5)){
						alert("Preencha os campos corretamente.");
						frm._dt_encerra2_d.focus();
						return false;
					}		
				}
				
				if ((document.frm._dt_encerra1_d.value != "") && (document.frm._dt_encerra2_d.value != "")){		
					data1 = document.frm._dt_encerra1_d.value.split("/");
					data2 = document.frm._dt_encerra2_d.value.split("/");
					primeira = new Date(data1[2],data1[1],data1[0]);
					ultima = new Date(data2[2],data2[1],data2[0]);
		
					diferenca = ultima - primeira;
					if (diferenca < 0){
						alert("Data inicial deve ser menor do que a data final.");
						document.frm._dt_encerra1_d.focus();
						return false;
					}
				}
							
				if (document.frm._distribuicao1_d.value != ""){
					if (!doDate(document.frm._distribuicao1_d.value,5)){
						alert("Preencha os campos corretamente.");
						frm._distribuicao1_d.focus();
						return false;
					}		
				}
				
				if (document.frm._distribuicao2_d.value != ""){
					if (!doDate(document.frm._distribuicao2_d.value,5)){
						alert("Preencha os campos corretamente.");
						frm._distribuicao2_d.focus();
						return false;
					}		
				}
				
				if ((document.frm._distribuicao1_d.value != "") && (document.frm._distribuicao2_d.value != "")){
					data1 = document.frm._distribuicao1_d.value.split("/");
					data2 = document.frm._distribuicao2_d.value.split("/");
					primeira = new Date(data1[2],data1[1],data1[0]);
					ultima = new Date(data2[2],data2[1],data2[0]);
		
					diferenca = ultima - primeira;
					if (diferenca < 0){
						alert("Data inicial deve ser menor do que a data final.");
						document.frm._distribuicao1_d.focus();
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
				
				
				if (document.frm._citacao1_d.value != ""){
					if (!doDate(document.frm._citacao1_d.value,5)){
						alert("Preencha os campos corretamente.");
						frm._citacao1_d.focus();
						return false;
					}		
				}
				
				if (document.frm._citacao2_d.value != ""){
					if (!doDate(document.frm._citacao2_d.value,5)){
						alert("Preencha os campos corretamente.");
						frm._citacao2_d.focus();
						return false;
					}		
				}
					
				if ((document.frm._citacao1_d.value != "") && (document.frm._citacao2_d.value != "")){
					data1 = document.frm._citacao1_d.value.split("/");
					data2 = document.frm._citacao2_d.value.split("/");
					primeira = new Date(data1[2],data1[1],data1[0]);
					ultima = new Date(data2[2],data2[1],data2[0]);
		
					diferenca = ultima - primeira;
					if (diferenca < 0){
						alert("Data inicial deve ser menor do que a data final.");
						document.frm._citacao1_d.focus();
						return false;
					}
				}
				
				if (document.frm._dt_ult_sinc_d.value != ""){
					if (!doDate(document.frm._dt_ult_sinc_d.value, 5)){
						alert("Preencha os campos corretamente.");
						frm._dt_ult_sinc_d.focus();
						return false;
					}		
				}
					
				if (document.frm._dt_ult_sinc2_d.value != ""){
					if (!doDate(document.frm._dt_ult_sinc2_d.value,5)){
						alert("Preencha os campos corretamente.");
						frm._dt_ult_sinc2_d.focus();
						return false;
					}		
				}
				
				if ((document.frm._dt_ult_sinc_d.value != "") && (document.frm._dt_ult_sinc2_d.value != "")){		
					data1 = document.frm._dt_ult_sinc_d.value.split("/");
					data2 = document.frm._dt_ult_sinc2_d.value.split("/");
					primeira = new Date(data1[2],data1[1],data1[0]);
					ultima = new Date(data2[2],data2[1],data2[0]);
		
					diferenca = ultima - primeira;
					if (diferenca < 0){
						alert("Data inicial deve ser menor do que a data final.");
						document.frm._dt_ult_sinc_d.focus();
						return false;
					}
				}
				
				document.frm.bts.disabled = true;
				return true;
			}		
		</script>	
		
		<!--#include file="../include/clsPesquisa.asp"-->
		<%
		Set pesq = new clsPesquisa
		pesq.addParam "mod"
		pesq.cor_titulo "#345C46"
		pesq.Create "Selecionar Envolvido","Envolvido","../img_comp/","../busca_env_normal.asp","0","0"
		%>
		
		<!--#include file="header.asp"-->
		<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
			<tr>
				<td height="16px" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19px" height="18px">&nbsp;</td>
				<td height="16px" valign="middle" class="titulo">&nbsp;Relatório&nbsp;de&nbsp;Processos&nbsp;&nbsp;</td>
				<td height="16px" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18px" border="0"></td>
				<td height="16px" valign="middle"><img src="imagem/tit_fim.gif" width="21px" height="16px"></td>
				<td height="16px" valign="middle">&nbsp;<a href="processo.asp?modulo=C&cadproc=inclusao"><img src="imagem/add-proc.gif" alt="Cadastrar novo Processo" width="15px" height="20px" border="0"></a></td>
			</tr>			
		</table>
		<table width="100%" class="tabela" border="0" cellspacing="2" cellpadding="2">
		<form action="processo_result.asp" name="frm" method="get" onsubmit="return valida()">
		<input type="hidden" name="mod" value="contencioso">
			<tr>
				<td width="120px">Ordena&ccedil;&atilde;o:</td>
				<td width="200px">
					<select name="ordem" class="cfrm">
						<option value="TabProcCont.pasta">Pasta</option>
						<option value="TabProcCont.processo" selected>Processos</option>
						<option value="TabProcCont.situacao">Situa&ccedil;&atilde;o</option>
						<option value="TabProcCont.cmp_livre_1"><%=label_campo1%></option>
						<option value="TabProcCont.cmp_livre_2"><%=label_campo2%></option>
					</select>
					<select class="cfrm" name="ordenacao" style="width:86px">
						<option value="ASC" >Crescente</option>
						<option value="DESC">Decrescente</option>
					</select>
				</td>
				<td align="left" width="90px">Tipo Processo:</td>
				<td align="left" nowrap>
					<select class="cfrm" name="ftabproccont.tipo_c" style="width:100px">
						<option value=""></option>
						<option value="J" title="Judicial">Judicial</option>
						<option value="A" title="Administrativo">Administrativo</option>
					</select>
					&nbsp;&nbsp;&nbsp;Instância:&nbsp;<input class="cfrm" type="text" name="finstancia_c" size="1" maxlength="2" style="width:25px">
				</td>
			</tr>
			<tr>
				<td align="left">Processo:</td>
				<td align="left" colspan="3">
					<input class="cfrm" type="text" name="ftabproccont.processo_c" maxlength="35" style="width:296px;">
				</td>
			</tr>		
			<tr>
				<td align="left">Competência:</td>
				<td align="left" colspan="3">
					<select class="cfrm" name="fcompetencia_c" style="width:110px">
						<option value=""></option>
						<option value="F" title="Federal">Federal</option>
						<option value="E" title="Estadual">Estadual</option>
						<option value="M" title="Municipal">Municipal</option>
					</select>
					&nbsp;&nbsp;&nbsp;Posição:&nbsp;&nbsp;
					<select class="cfrm" name="fparticipante_c" style="width:110px">
						<option value=""></option>
						<option value="A" title="Autor">Autor</option>
						<option value="R" title="Réu">Réu</option>
					</select>
				</td>
			</tr>
			<tr>
				<td align="left">Objeto:</td>
				<td align="left" colspan="3">
					<input type="text" class="cfrm" id="|desc1_c" name="|desc1_c" size="25" maxlength="25" style="width:174px"> <select class="cfrm" id="eou_1" name="eou_1"><option value="and">e</option><option value="or">ou</option></select>&nbsp;<input type="text" class="cfrm" id="|desc2_c" name="|desc2_c" value="<%=desc_res%>" size="25" maxlength="25" style="width:172px"> <select class="cfrm" id="eou_2" name="eou_2"><option value="and">e</option><option value="or">ou</option></select> <input type="text" class="cfrm" id="|desc3_c" name="|desc3_c" value="<%=desc_res%>" size="25" maxlength="25"  style="width:170px">
				</td>
			</tr>
			<tr>
				<td align="left">Tipo de Env.:</td>
				<td align="left">	
					<select class="cfrm" name="tipo_env" size="1" style="width:174px">
						<option value=""></option>
						<%set rs = conn.execute("SELECT * FROM Tipo_Envolvido WHERE usuario = '"&Session("vinculado")&"' and contencioso= '1' ORDER BY nome_tipo_env")
						while not rs.eof
						%>
						<option value="<%= rs("id_tipo_env") %>" title="<%= rs("nome_tipo_env") %>"><%= rs("nome_tipo_env") %></option>
						<%
						rs.movenext
						wend
						%>
					</select>
				</td>
				<td align="left">Objeto Principal:</td>
				<td align="left">
					<select class="cfrm" name="objeto_principal" style="width:312px">
						<option value=""></option>
						<%
						sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'L' order by descricao"
						set rst = db.execute(sql)
						do while not rst.eof
							%>
							<option value="<%=rst("codigo")%>" title="<%=rst("descricao")%>"><%=left(rst("descricao"), 50)%></option>
							<%
							rst.movenext
						loop
						%>
					</select>
				</td>
			</tr>
			<tr>
				<td align="left">Envolvido:</td>
				<td align="left"><% pesq.campo_pesq "pesc_env_div", "envolvido", "174" %></td>
				<td align="left">Tipo Ação:</td>
				<td align="left">
					<select class="cfrm" name="ftipo_acao_n" style="width:312px;">
						<option value="0"></option>
						<%
						sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'T' order by descricao"
						set rst = db.execute(sql)
						do while not rst.eof
							%>
							<option value="<%=rst("codigo")%>" title="<%=rst("descricao")%>"><%=left(rst("descricao"), 50)%></option>
							<%
							rst.movenext
						loop
						%>
					</select>
				</td>
			</tr>		
			<tr>
				<td align="left">Situação:</td>
				<td align="left">	
					<select class="cfrm" name="fsituacao_c" style="width:174px">
						<option value=""></option>
						<option value="A">Ativo</option>
						<option value="C">Em Acordo</option>
						<option value="E">Encerrado</option>
						<option value="I">Inativo</option>
					</select>
				</td>
				<td align="left">Rito:</td>
				<td align="left">
					<select class="cfrm" name="frito_n" style="width:312px">
						<option value="0"></option>
						<%
						sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'R' order by descricao"
						set rst = db.execute(sql)
						do while not rst.eof
							%>
							<option value="<%=rst("codigo")%>" title="<%=rst("descricao")%>"><%=left(rst("descricao"), 50)%></option>
							<%
							rst.movenext
						loop
						%>
					</select>
				</td>
			</tr>		
			
			<tr>
				<td>Resultado Previsto:</td>
				<td>
					<select class="cfrm" name="resultado_previsto" style="width:174px">
						<option value=""></option>
						<option value="P">Perdida</option>
						<option value="R">Remota</option>
						<option value="S">Possível</option>
						<option value="V">Provável</option>
						<option value="G">Ganha</option>
					</select>
				</td>
				<td align="left">Comarca:</td>
				<td align="left">
					<select class="cfrm" name="fcomarca_n" style="width:312px">
						<option value=""></option>
						<%
						sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'C' order by descricao"
						set rst = db.execute(sql)
						do while not rst.eof
							%>
							<option value="<%=rst("codigo")%>" title="<%=rst("descricao")%>"><%=left(rst("descricao"), 50)%></option>
							<%
							rst.movenext
						loop
						%>
					</select>
				</td>	
			</tr>	
			<tr>
				<td>Responsável:</td>
				<td>
					<%set rs = conn.execute("Select * from responsaveis where tipo <> 'cliente' and usuario = '"&Session("vinculado")&"' order by nome")%>
					<select class="cfrm" name="fresponsavel_n" size="1" style="width:174px">
						<option value="0"></option>
						<%do while not rs.eof%>
							<option value="<%= rs("id") %>" title="<%=rs("nome")%>"><%= rs("nome") %></option>
							<%rs.movenext
						loop%>
					</select>
				</td>
				<td align="left">Juízo:</td>
				<td align="left">
					<select class="cfrm" name="fjuizo_n" style="width:312px">
						<option value=""></option>
						<%
						sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'J' order by descricao"
						set rst = db.execute(sql)
						do while not rst.eof
							%>
							<option value="<%=rst("codigo")%>" title="<%=rst("descricao")%>"><%=left(rst("descricao"), 50)%></option>
							<%
							rst.movenext
						loop
						%>
					</select>
				</td>	
			</tr>	
			<tr>
				<td align="left">Pasta:</td>
				<td align="left">
					<input type="text" class="cfrm" name="fpasta_c" maxlength="30" style="width:111px">&nbsp;<input type="Checkbox" name="pastaexata" value="0">Exata
				</td>
				<td align="left">Órgão:</td>
				<td align="left">
					<select class="cfrm" name="forgao_n" style="width:312px">
						<option value="0"></option>
						<%
						sql = "select cast(codigo as varchar(5))   as codigo , " & _
							  "       descricao as descricao    		     " & _
							  "  from auxiliares                		     " & _
							  " where usuario = '"&session("vinculado") & "' " & _
							  "   and tipo = 'O' 							 " & _
						      "union                                         " &_
						      "select sigla     as codigo       , 			 " & _
							  "       nome      as descricao 				 " & _
							  "  from isis..orgao where sigla <> 'INPI'		 " & _
							  " order by descricao "
 
						set rst = db.execute(sql)
						do while not rst.eof
							%>
							<option value="<%=rst("codigo")%>" title="<%=rst("descricao")%>"><%=left(rst("descricao"), 50)%></option>
							<%
							rst.movenext
						loop
						%>
					</select>
				</td>
			</tr>
			<tr>
				<td align="left">Grupo do Envolvido:</td>
				<td align="left"><input type="text" name="grupo" size="16" maxlength="15" class="cfrm" style="width:174px"></td>
				<td align="left">Natureza:</td>
				<td align="left">
					<select class="cfrm" name="fnatureza_n" style="width:312px">
						<option value="0"></option>
						<%
						sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'N' order by descricao"
						set rst = db.execute(sql)
						do while not rst.eof
							%>
							<option value="<%=rst("codigo")%>" title="<%=rst("descricao")%>"><%=left(rst("descricao"), 50)%></option>
							<%
							rst.movenext
						loop
						%>
					</select>
				</td>
			</tr>
			<tr>
				<td align="left">Data de Citação:</td>
				<td align="left">
					<input type="text" class="cfrm data" name="_citacao1_d" size="10" maxlength="10"> -> <input type="text" class="cfrm data" name="_citacao2_d" size="10" maxlength="10">
				</td>
				<td nowrap><%=label_campo1%>:</td><td><input type="text" class="cfrm" name="fcmp_livre_1_c" maxlength="30" style="width:312px"></td>
			</tr>
			<tr>
				<td nowrap>Data de Cadastro:</td><td><input type="text" name="ddt_cad" size="10" maxlength="10" class="cfrm data" > -> <input type="text" name="adt_cad" size="10" maxlength="10" class="cfrm data"></td>
				<td nowrap><%=label_campo2%>:</td><td><input type="text" class="cfrm" name="fcmp_livre_2_c" maxlength="30" style="width:330"></td>
			</tr>
			<tr>
				<td align="left" nowrap>Data de Distribuição:</td>
				<td align="left">
					<input type="text" class="cfrm data" name="_distribuicao1_d" size="10" maxlength="10"> -> <input type="text" class="cfrm data" name="_distribuicao2_d" size="10" maxlength="10">
				</td>
				<td nowrap><%=label_campo3%>:</td>
				<td>
					<select class="cfrm" name="fcmp_livre_3_c" style="width:312px">
						<option value=""></option>
						<%
						sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = '3' order by descricao"
						set rst = db.execute(sql)
						do while not rst.eof
							%>
							<option value="<%=rst("codigo")%>" title="<%=rst("descricao")%>"><%=left(rst("descricao"), 50)%></option>
							<%
							rst.movenext
						loop
						%>
					</select>
				</td>
			</tr>
			<tr>
				<td align="left" nowrap>Data de Encerramento:</td>
				<td align="left">
					<input type="text" class="cfrm data" name="_dt_encerra1_d" size="10" maxlength="10"> -> 
					<input type="text" class="cfrm data" name="_dt_encerra2_d" size="10" maxlength="10">
				</td>
				<td nowrap><%=label_campo4%>:</td>
				<td>
					<select class="cfrm" name="fcmp_livre_4_c" style="width:312px">
						<option value=""></option>
						<%
						sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = '4' order by descricao"
						set rst = db.execute(sql)
						do while not rst.eof
							%>
							<option value="<%=rst("codigo")%>" title="<%=rst("descricao")%>"><%=left(rst("descricao"), 50)%></option>
							<%
							rst.movenext
						loop
						%>
					</select>
				</td>
			</tr>
			<tr>
				<td valign="top" align="left" nowrap>
				<%  If (andamentos_T <> "") and (not isnull(andamentos_T )) then%>
					Data de <%=andamentos_T%>:
				<%else%>
					Data de Andamento:
				<% end if%></td>
				<td valign="top" align="left">
					<input type="text" class="cfrm data" name="_dt_ult_sinc_d" size="10" maxlength="10"> -> 
					<input type="text" class="cfrm data" name="_dt_ult_sinc2_d" size="10" maxlength="10">
				</td>
				<td colspan="2">
		    		<fieldset>
		    			<legend style="color:#000;"> Ocorrências </legend>
		    			<table width="100%" border="0" class="preto11" cellpadding="2" cellspacing="2">
		    				<tr>
		    					<td>
		    						Data:
		    					</td>
		    					<td>
									<input type="text" name="ddt_ocorrencia_data" id="ddt_ocorrencia_data" maxlength="10" size="10" class="cfrm data"> -> 
									<input type="text" name="adt_ocorrencia_data" id="adt_ocorrencia_data" maxlength="10" size="10" class="cfrm data">
		    					</td>
		    				</tr>
		    				<tr>
		    					<td>
		    						Descrição/Detalhe:
		    					</td>
		    					<td>
		    						<input type="text" id="descricaoOcorrencia" name="descricaoOcorrencia" maxlength="100" class="cfrm" style="width:100%;">
		    					</td>
		    				</tr>
		    				<tr>
		    					<td>
		    						Protocolo:
		    					</td>
		    					<td>
		    						<input type="text" id="protocoloOcorrencia" name="protocoloOcorrencia" maxlength="50" class="cfrm" style="width:100%;">
		    					</td>
		    				</tr>
		    			</table>
		    		</fieldset>
				</td>
			</tr>	
			<tr><td colspan="4">&nbsp;&nbsp;</td>	
			<tr>
				<td colspan="4" align="center"><input name="bts" class="cfrm" type="submit" value="Pesquisar">&nbsp;&nbsp;<input type="reset" onclick="<%= pesq.limpa_campo_pesq("pesc_env_div", "envolvido") %>" class="cfrm" value="Limpar"></td>
			</tr>
		</form>
		</table>
	</body>
</html>