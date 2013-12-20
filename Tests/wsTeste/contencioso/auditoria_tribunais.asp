<% session("voltar") = "../main.asp?modulo=C" %>
<!--#include file="db_open.asp"-->
<!--#include file="../usuario_logado.asp"-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<!--#include file="../include/conn.asp"-->
<!--#include file="funcoes.asp"-->

<!--#include file="../include/dbconn.asp"-->
<%
menu_onde = "div" 

if (not Session("cont_rel_audi")) and (not Session("adm_adm_sys")) then
	bloqueia
	response.end
end if
%>
<html>
<head>
	<title>APOL Jurídico</title>
	<link rel="STYLESHEET" type="text/css" href="style.css">
	<link href="../adm/css/jquery-ui-1.10.3.custom.css" type="text/css" rel="stylesheet">
	<!--#include file="header.asp"-->
	<script language="JavaScript" src="../include/funcoes.js"></script>
	<script type="text/javascript" src="../include/jquery-latest.js"></script>
		
	<script language="JavaScript" src="../adm/js/jquery-1.4.4.min.js" type="text/javascript"></script>
	<script language="JavaScript" src="../adm/js/jquery-ui-1.8.9.custom.min.js" type="text/javascript"></script>
	<script language="JavaScript" src="../adm/js/jquery.ui.datepicker-pt-BR.js" type="text/javascript"></script>
	<script language="JavaScript" src="../adm/js/jquery.maskedinput-1.2.2.js" type="text/javascript"></script>
</head>
<body>
<table cellpadding="0" cellspacing="0" border="0" width="100%" class="titulo">
	<tr>				
		<td height="16px" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19px" height="18px">&nbsp;</td>
		<td height="16px" valign="middle" class="titulo">&nbsp;Auditoria&nbsp;de&nbsp;Conexões&nbsp;&nbsp;</td>
		<td height="16px" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18px" border="0"></td>
		<td height="16px" valign="middle"><img src="imagem/tit_fim.gif" width="21px" height="16px"></td>
	</tr>
	</table>

					 
		 	<table class="preto11" id="tabela" bgcolor="#efefef" width="99%" border="0" height="152">
	
		<form action="auditoria_result.asp" name="frm" method="get" onsubmit="return valida()">
		<input type="hidden" name="mod" value="contencioso">
			<tr>
				<td width="29%">Ordena&ccedil;&atilde;o:</td>
				<td width="22%">
					<select name="ordem" class="cfrm">
						<option value="tbConexaoTribunais_Andamentos.data" selected>Data</option>
						<option value="tbConexaoTribunais_Andamentos.processo">Processo</option>
						<option value="tbConexaoTribunais_Andamentos.qtd_andamentos_baixados">Quantidade</option>
					</select>
					<select class="cfrm" name="ordenacao" style="width:98">
						<option value="ASC" >Crescente</option>
						<option value="DESC" selected>Decrescente</option>
					</select>
				</td>
			</tr>
			<tr>
				<td align="left">Processo:</td>
				<td align="left">
					<input class="cfrm" type="text" name="ftabproccont.processo_c" maxlength="35" style="width:283">
				</td>
				<td align="left" width="7%">&nbsp;</td>
				<td align="left" nowrap width="41%">
					&nbsp; </td>
			</tr>		
			<tr>
				<td align="left">Data de Sincronização:</td>
				<td align="left" colspan="2">	
					<input type="text" class="cfrm data" name="ddt_cad" size="10" maxlength="10"> -> 
					<input type="text" class="cfrm data" name="adt_cad" size="10" maxlength="10">
				</td>
				<td align="left" nowrap width="41%">
					&nbsp;</td>
			</tr>
			<tr>
				<td align="left">Periodicidade:</td>
				<td align="left" colspan="2">	
					<a name=dados>
					<select class="cfrm" name="fperiodicidade_c" style="width:175; height:11">
										<option value=""> </option>
										<option value="5" >Manual</option>
										<option value="1" >Diária</option>
										<option value="2" >Semanal</option>
										<option value="3" >Quinzenal</option>
										<option value="4" >Mensal</option>
								</select>
				<td align="left" nowrap width="41%">
					&nbsp;&nbsp;
					&nbsp;</td>
			</tr>
			<tr>
				<td align="left" nowrap>Órgão:</td>
				<td align="left" colspan="2">
								<select class="cfrm" name="ftribunal_sync_c"  style="width:330">
								<option value=""></option>
								<%
								sqlT = "SELECT id,sigla, nome FROM Orgao where sigla <> 'INPI' order by sigla, id, nome"
								set rsT = dbconn.execute(sqlT)
								do while not rsT.eof%>
									<option value="<%=rsT("sigla")%>" <%if trim(tribunal_sync) = trim(rsT("sigla")) then%>selected<%end if%>><%=rsT("nome")%></option>
										<%rsT.MoveNext
								loop
								%>
									</select>
								</td>
				<td align="left" width="41%">
	<a name=dados>
								&nbsp; </td>	
			</tr>
			<tr>
				<td align="left" nowrap>Mensagem:</td>
				<td align="left" colspan="3">
					<input type="text" class="cfrm" id="desc1_c0" name="desc1_c0" size="25" maxlength="25" style="width:331; height:19"> 
				</td>
			</tr>
			<tr>
				<td align="left">Status da Sincronização:</td>
				<td align="left" nowrap>
					<select name="fstatus" class="cfrm">
						<option value="" selected>Todos</option>
						<option value="1">Com erro</option>
						<option value="0">Sem erro</option>
					</select>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="chk_ultimo_processo" value="1">Somente o último de cada processo
				</td>
			</tr>
			<tr>
				<td colspan="4" align="center" height="27">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="4" align="center" height="27"><input name="bts" class="cfrm" type="submit" value="Pesquisar">&nbsp;&nbsp;<input type="reset" class="cfrm" value="Limpar"></td>
			</tr>
		
				</form>
		</table>
	
<script language="javascript">
		
		function somente_numero(campo) {
			var digits="0123456789";
			var campo_temp;
	
			for (var i=0;i<campo.value.length;i++) {
				campo_temp=campo.value.substring(i,i+1);
				if (digits.indexOf(campo_temp)==-1) {
					campo.value = campo.value.substring(0,i);
					break;
				}	   
			}
		}		
		
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
		
		//Configurando calendarios 
		jQuery(".data").mask("9?9/99/9999",{placeholder:" "}).datepicker(); 	
		
		</script>
	</body>
</html>