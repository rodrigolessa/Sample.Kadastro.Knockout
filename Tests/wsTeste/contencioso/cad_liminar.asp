<!--#include file="db_open.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../usuario_logado.asp"-->
<%
tipo = ""
data = ""
valor = ""
tipo_multa = ""
estado_liminar = ""
edita = ""
novo = "ok"

if tplic(1, request.querystring("id_liminar")) <> "" then
	strSQL = "SELECT id_processo, id_usuario, tipo, data_intimacao, tipo_multa, valor_multa, estado_liminar FROM Liminares "
	strSQL = strSQL & "WHERE id_usuario = " & session("codigo_vinculado") & " AND [id] = " & tplic(1, request.querystring("id_liminar"))
	set rs_existe_liminar = db.execute(strSQL)
	if not rs_existe_liminar.eof then
		tipo = rs_existe_liminar("tipo")
		data = rs_existe_liminar("data_intimacao")
		tipo_multa = rs_existe_liminar("tipo_multa")
		valor = rs_existe_liminar("valor_multa")
		estado_liminar = rs_existe_liminar("estado_liminar")

		edita = "ok"
		novo = ""
	end if
end if
if request.form("gravar") = "ok" then
	id_processo = tplic(1, request.form("id_processo"))
	num_proc = tplic(1, request.form("num_proc"))
	tipo = tplic(1, request.form("tipo"))
	data = tplic(1, request.form("data"))
	tipo_multa = tplic(1, request.form("tipo_multa"))
	valor = tplic(1, request.form("valor"))
	estado_liminar = tplic(1, request.form("estado"))
	
	strSQL = "INSERT INTO Liminares(id_processo, id_usuario, tipo, data_intimacao, tipo_multa, valor_multa, estado_liminar) VALUES("
	strSQL = strSQL & id_processo & ", " & session("codigo_vinculado") & ", '" & tipo & "', " & rdata(data) & ", '" & tipo_multa
	strSQL = strSQL & "', '" & replace(valor, ",", ".") & "', '" & estado_liminar & "')"
	db.execute(strSQL)
	
	ok = grava_log_c(session("nomeusu"), "INCLUSÃO", "LIMINAR", "Processo: " & num_proc)
	%>
	<script>
		opener.frame_liminares.location.reload();
		window.close();
	</script>
	<%
	response.end
elseif request.form("editar") = "ok" then
	id_processo = tplic(1, request.form("id_processo"))
	num_proc = tplic(1, request.form("num_proc"))
	id_liminar = tplic(1, request.form("id_liminar"))

	tipo = tplic(1, request.form("tipo"))
	data = tplic(1, request.form("data"))
	tipo_multa = tplic(1, request.form("tipo_multa"))
	valor = tplic(1, request.form("valor"))
	estado_liminar = tplic(1, request.form("estado"))
	
	strSQL = "UPDATE Liminares SET tipo = '" & tipo & "', data_intimacao = " & rdata(data) & ", tipo_multa = '" & tipo_multa & "', "
	strSQL = strSQL & "valor_multa = '" & replace(valor, ",", ".") & "', estado_liminar = '" & estado_liminar & "' "
	strSQL = strSQL & "WHERE id_usuario = " & session("codigo_vinculado") & " AND [id] = " & id_liminar
	db.execute(strSQL)
	
	ok = grava_log_c(session("nomeusu"), "ALTERAÇÃO", "LIMINAR", "Processo: " & num_proc)
	%>
	<script>
		opener.top.frame_liminares.location.reload();
		window.close();
	</script>
	<%
	response.end
elseif request.querystring("excluir") = "ok" then
	id_processo = tplic(1, request.querystring("id_processo"))
	num_proc = tplic(1, request.querystring("num_proc"))
	id_liminar = tplic(1, request.querystring("id_liminar"))
	
	strSQL = "DELETE FROM Liminares WHERE id_usuario = " & session("codigo_vinculado") & " AND [id] = " & id_liminar
	db.execute(strSQL)
	
	ok = grava_log_c(session("nomeusu"), "EXCLUSÃO", "LIMINAR", "Processo: " & num_proc)
	
	response.redirect("proc_liminares.asp?id_processo="& id_processo & "&num_proc=" & num_proc)
	response.end
end if
%>
<html>
	<head>
		<link href="../adm/css/jquery-ui-1.10.3.custom.css" type="text/css" rel="stylesheet">

		<script language="javascript" src="valida.js"></script>
		<script language="JavaScript" src="../include/funcoes.js"></script>

		<script language="JavaScript" src="../adm/js/jquery-1.4.4.min.js" type="text/javascript"></script>
		<script language="JavaScript" src="../adm/js/jquery-ui-1.8.9.custom.min.js" type="text/javascript"></script>
		<script language="JavaScript" src="../adm/js/jquery.ui.datepicker-pt-BR.js" type="text/javascript"></script>
		<script language="JavaScript" src="../adm/js/jquery.maskedinput-1.2.2.js" type="text/javascript"></script>
		<script>
			var fixo = true;
			var posiX = 250; 
			var posiY = 50;

	        //Configurando calendarios 
	        jQuery(document).ready(function(){
	           jQuery(".data").mask("9?9/99/9999",{placeholder:" "}).datepicker(); 
	        });
			
			function decimal(campo){
				var digits="0123456789,";
				var campo_temp;
				for (var i=0;i<campo.value.length;i++){
				  campo_temp=campo.value.substring(i, i+1);
				  if (digits.indexOf(campo_temp) == -1){
					    campo.value = campo.value.substring(0, i);
					    break;
				   }
				}
			}
		
			function valida(){			
				if (document.frm.tipo.value == ""){
					alert("Preencha o campo Tipo.");
					document.frm.tipo.focus();
					return false;
				}
	
				if (document.frm.data.value == ""){
					alert("Preencha o campo Data.");
					document.frm.data.focus();
					return false;
				}
				else{
					if (document.frm.data.value != ""){			
						if (!doDate(document.frm.data.value, 5)){
							alert("Preencha o campo Data corretamente.");
							document.frm.data.focus();
							return false;
						}
					}
				}
	
				if (document.frm.tipo_multa.value == ""){
					alert("Preencha o campo Tipo da Multa.");
					document.frm.tipo_multa.focus();
					return false;
				}
	
				if (document.frm.valor.value == ""){
					alert("Preencha o campo Valor da Multa.");
					document.frm.valor.focus();
					return false;
				}
				return true;
			}		
		</script>
		<title>APOL Jurídico</title>
		<link rel="STYLESHEET" type="text/css" href="style.css"> 
	</head>
	<body leftmargin="0" topmargin="0">
		<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
		<tr>
			<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
			<td height="16" valign="middle" class="titulo">&nbsp;Cadastro&nbsp;de&nbsp;Liminares&nbsp;</td>
			<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
			<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
		</tr>
		</table>
		<table width="100%" class="tabela<%=l_imp%>" border="0" cellspacing="2" cellpadding="3">		
			<form name="frm" action="cad_liminar.asp" method="post" onsubmit="return valida()">	
			<input type="hidden" name="id_processo" value="<%=request("id_processo")%>">
			<input type="hidden" name="num_proc" value="<%=request("num_proc")%>">
			<input type="hidden" name="id_liminar" value="<%=request("id_liminar")%>">
			<input type="hidden" name="editar" value="<%=edita%>">
			<input type="hidden" name="gravar" value="<%=novo%>">
			<tr>
				<td width="10%">Tipo:</td>
				<td><input type="text" class="cfrm" name="tipo" size="27" maxlength="50" value="<%=tipo%>"></td>
			</tr>
			<tr>
				<td nowrap>Data Intimação:</td>
				<td><input type=text class="cfrm data" name="data" size="10" maxlength="10" value="<%=fdata(data)%>"></td>
			</tr>
			<tr>
				<td nowrap>Tipo da Multa:</td>
				<td><input type=text class="cfrm" name="tipo_multa" size="27" maxlength="50" value="<%=tipo_multa%>"></td>
			</tr>
			<tr>
				<td nowrap>Valor da Multa:</td>
				<td><input type=text class="cfrm" name="valor" size="11" maxlength="11" onKeyUp="decimal(this);" value="<%=valor%>" style="text-align:right"></td>
			</tr>
				<td nowrap>Estado da Liminar:</td>
				<td>
					<select class="cfrm" name="estado" size="1" style="width:180">
						<option value="V" <%if estado_liminar = "V" then%>selected<%end if%>>Vigor</option>
						<option value="S" <%if estado_liminar = "S" then%>selected<%end if%>>Suspenso</option>
						<option value="D" <%if estado_liminar = "D" then%>selected<%end if%>>Definitivo</option>
						<option value="O" <%if estado_liminar = "O" then%>selected<%end if%>>Outros</option>
					</select>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="2" align="center">
					<input type="submit" class="cfrm" name="btGravar" value="Gravar">&nbsp;&nbsp;
					<input type="reset" class="cfrm" name="btReset" value="Limpar">
				</td>
			</tr>
			</form>
		</table>
	</body>
</html>