<% session("voltar") = "../main.asp?modulo=C" %>
<!--#include file="db_open.asp"-->
<!--#include file="../usuario_logado.asp"-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<!--#include file="../include/conn.asp"-->
<%

menu_onde = "div" 

if (not Session("cont_cons_contrib")) and (not Session("adm_adm_sys")) then
	bloqueia
	response.end
end if

%>
<link rel="STYLESHEET" type="text/css" href="style.css">
<!--#include file="header.asp"-->
<script language="JavaScript" src="../include/jquery-1.3.1.js" type="text/javascript"></script>
<script language="JavaScript" src="../include/jquery-ui-1.7.2.custom.min.js"></script>


<html>
<head>
	<title>APOL Jurídico</title>
</head>
<body>
<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>				
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;Parâmetros&nbsp;de&nbsp;Conexão&nbsp;&nbsp;</td>
		<td height="16" width="100%">
		<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle">
		<img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
<script type="text/javascript">

var $  = jQuery.noConflict();



$(function(){
	$('#termoaceite').css('display','none');
	$('#HabilitaCon').click(function(){
        checkIt();
    });
});

function checkIt(){
    if ($('#habilitadoComl').val() == 'L'){
		if ($('#nroconscom1').val() <=  $('#itotal1').val()){
	    	if ($('#HabilitaCon:checked').val() == 1){
		        $('#termoaceite').css('display','');
				$('#tabela').hide();
		   	} else {
	        	$('#termoaceite').css('display','none');
		        $('#tabela').show();
	    	}
	    }
    }
}


</script>


		<%
		sqlR = "SELECT fl_Habilita_Conexao_coml,fl_Habilita_Conexao_Processo,id_periodicidade,ds_EnviaEmail,nr_consultas_permitidas,fl_Avisa_Resp_Conexao_limite,fl_des_Conexao_status_proc" &_
				",dataativacao,nrolimiteconsultas_coml,nroconsultas_teste_feitas FROM tbConexaoTribunais_Parametros WHERE usuario = '"&session("vinculado")&"'"

		set rsR = db.execute(sqlR)
		periodo  = 2
		
		mostra = "enabled"	
		mostracheckhabilita = "enabled"												
		mostraraceite = "nao"
		nrolimiteconsultas = 0
		if not rsR.eof then
			habilitadoComl 	= rsR("fl_Habilita_Conexao_coml")
			habilitadocli   = rsR("fl_Habilita_Conexao_Processo")
			
			if trim(habilitadocli) = "" or isnull(habilitadocli) or trim(habilitadocli) = " " then
				habilitadocli= 0
			end if	
	
			if habilitadoComl = "T" then
				periodo  		= 0
			else
				periodo  		= rsR("id_periodicidade")
			end if
			
			EnviaEmail	    	= rsR("ds_EnviaEmail")
			AvisaLimite    	 	= rsR("fl_Avisa_Resp_Conexao_limite")
			desstatus    		= rsR("fl_des_Conexao_status_proc")
			nrolimiteconsultas 	= rsR("nr_consultas_permitidas")
			nroconscom			= rsR("nrolimiteconsultas_coml")
			itotal 				= rsR("nroconsultas_teste_feitas")
			
			if trim(itotal) = "" or isnull(itotal) or trim(itotal) = " " then
				itotal = 0
			end if

		end if 						

		if habilitadoComl = "T" or habilitadoComl = "B" then
			if nroconscom = 0 then
				mostracheckhabilita = "disabled"
			end if
			if nroconscom <= itotal then
				mostra = "disabled"
				mostracheckhabilita = "disabled"
			end if
			mostra = "disabled"
		elseif habilitadoComl = "L" then
			if nroconscom <= itotal  then
				mostracheckhabilita = "disabled"
			end if
			if habilitadocli = 0 then
				mostra = "disabled"
			end if
		end if
		
		if nroconscom > 0 then
			mostra = "disabled"
		end if
  		
		'-- =========================================================================	
		 'response.write habilitadoComl &"-"&nroconscom &"-"&itotal &"-"&mostra%>

					 
		 	<table class="preto11" id="tabela" bgcolor="#efefef" width="99%" border="0" height="152">
	
			<form name="frm" action="Grava_param_Tribunais.asp" method="post" onsubmit="javascript:return valida(this);">	
				<tr>
					<input type="hidden" id="habilitadoComl" name="habilitadoComl" value="<%=habilitadoComl%>">
					<input type="hidden" id="periodi" name="periodi" value="<%=periodo %>">
					<input type="hidden" id="nroconscom1" name="nroconscom1" value="<%=nroconscom%>">
					<input type="hidden" id="itotal1" name="itotal1" value="<%=itotal %>">
					<td width="99%">
					<p>
					<% if habilitadoComl = "T" or habilitadoComl = "B" then%>
						<input type="checkbox"  <%=mostracheckhabilita%>  id="HabilitaCon" onclick="checkIt();" name="HabilitaCon"  value="1" <% if habilitadocli = 1 then %> checked<% End If %>> Habilitar a conexão para todos os processos do Jurídico. Periodicidade:&nbsp;
					<%else%>
						<input type="checkbox" id="HabilitaCon" name="HabilitaCon"  onclick="checkIt();" value="1" <% if habilitadocli = 1 then %> checked<% End If %>> Habilitar a conexão para todos os processos do Jurídico. Periodicidade:&nbsp;
					<%end if
							if request("imprimir") = "" then%>
								<select class="cfrm" name="periodo" <%=mostra%> style="width:145; height:11">
									<% if habilitadoComl = "B" or habilitadoComl = "T" or nroconscom > 0 then%>
										<option value="0" <%if periodo  = "0" then%>selected<%end if%>>Não Possui</option>
									<%else%>
										<option value="2" <%if periodo  = "2" then%>selected<%end if%>>Semanal</option>
										<option value="1" <%if periodo  = "1" then%>selected<%end if%>>Diária</option>
										<option value="3" <%if periodo  = "3" then%>selected<%end if%>>Quinzenal</option>
										<option value="4" <%if periodo  = "4" then%>selected<%end if%>>Mensal</option>
									<%end if%>
								</select>
							<%else%>&nbsp;
							<%
									if trim(periodo ) <> "" or not isnull(periodo ) then
										select case periodo 
											case "1" response.write "<span class=""preto11"">Diária</span>"
											case "2" response.write "<span class=""preto11"">Semanal</span>"
											case "3" response.write "<span class=""preto11"">Quinzenal</span>"
											case "4" response.write "<span class=""preto11"">Mensal</span>"
										end select
									end if
							%>
							<%end if%>
						</td>
				</tr>
				<tr>
				<td  cellpadding="0" cellspacing="0" align="left">
				<img border="0" src="../imagem/hl.gif" width="20" height="20"><input type="checkbox" <%=mostra%> name="desstatus" id="desstatus" value="1"<% If desstatus then%> checked<% End If %>>Desabilitar 
				a Conexão aos Tribunais para os processos com situação Inativo 
				ou Encerrado.</td>
				</tr>
				<tr>
				<td align="left">
				&nbsp;<p><input type="checkbox" <%=mostra%> name="AvisaLimite" value="1"<% If AvisaLimite then%> checked<% End If %>>Avisar quando 
				atingir 
					<input class="cfrm" size="5" maxlength="5" name="nrolimiteconsultas" <%=mostra%> value="<%=nrolimiteconsultas %>" onKeyUp="somente_numero(this);" type="text" > 
				consultas por mês, enviando e-mail para
					<input class="cfrm" type="text" size="29" name="EnviaEmail" maxlength="50" <%=mostra%> value="<%=EnviaEmail%>" name="cep1">.</p>
				<p>&nbsp;</td>
				</tr>
				
				<tr>
					<td width="99%" height="24">
					<% if nroconscom > 0 then%>
						<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Consultas Executadas:   <b><%=itotal%> </b>&nbsp;&nbsp;&nbsp;de um total de <b><%=nroconscom%> </b>permitidas para teste.&nbsp;&nbsp;
					<%end if%>
					<p>&nbsp;</td>
				</tr>
				<tr>
				<td width="99%" align="center">
					 <input type="submit" <% if not ((Session("cont_manut_contrib")) or (Session("adm_adm_sys"))) then %> disabled<% End If %> class="cfrm" name="btGravar" value="Gravar" />&nbsp;&nbsp;
					<input type="reset" <% if not ((Session("cont_manut_contrib")) or (Session("adm_adm_sys"))) then %> disabled<% End If %> class="cfrm" name="btReset" value="Restaurar"/>
					<p>&nbsp;</td>
				</tr>
				</form>
		</table>
	
			<table  id="termoaceite" name="termoaceite" width="100%" height="100%" style="display:none;">
				<form name="frm1" action="Grava_param_Tribunais.asp?HabilitaCon=1&aceite=1" method="post" onsubmit="return valida1();">	
					<tr valign="middle">
						<td align="center">
					<table width="560" bgcolor="#FFFFFF" style="border: 1px solid Black;" class="preto11">
					<tr>
						<td>
						<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
						<tr>
							<td height="16" valign="middle" class="titulo"><img src="imagem/tit_le.gif" width="19" height="16">&nbsp;
							Conexões aos Tribunais&nbsp;
							<img src="imagem/tit_ld.gif" width="60%" height="16" border="0">
								<img src="imagem/tit_fim.gif" width="21" height="16"></td>
						</tr>
						</table>
						</td>
					</tr>
					<tr>
						<td align="center">
						<a name=desc0>
						<b><br>
						TERMO ADITIVO<br>
						CONTRATO DE LICENÇA DE USO E GARANTIA LIMITADA</b></td>
					</tr>
					<tr>
						<td align="justify" style="padding-left:10px; padding-right: 15px;"><br>
						<p align="justify">Ao aceitar os termos e condições abaixo, o presente Termo Aditivo de Contrato de Licença e Garantia Limitada (“Aditivo”) passará a constituir um compromisso jurídico e formal entre você (Licenciado), pessoa física ou jurídica, e a LCD Consultoria LTDA (Licenciante), da seguinte forma: </p>
						<p align="justify"><b>Cláusula 1ª:</b> A partir da aceitação do presente Aditivo, o Licenciado poderá cadastrar no software Apol, quantos processos judiciais desejar, para que na periodicidade programada pelo próprio Licenciado, o Apol faça uma verificação automática (Captura) de cada processo junto aos sites dos Tribunais disponíveis, permitindo o seu acompanhamento. </p>
						<p align="justify"><b>Cláusula 2ª:</b> O processo de Captura será realizado automaticamente pelo Apol, na periodicidade definida a qualquer tempo pelo Licenciado, independentemente de haver ou não movimentação no(s) processo(s) cadastrado(s), gerando a cobrança correspondente.</p>
						<p align="justify"><b>Cláusula 3ª:</b> O Licenciado, neste ato, autoriza a Licenciante a proceder a cobrança mensal do montante apurado com a captura do andamento dos processos cadastrados, realizado com sucesso para os processos cadastrados em sua base, no mesmo período, independente de terem ocorrido novos andamentos processuais desde a última captura, ao preço de R$ 0,02 (Dois centavos) por Captura.</p>
						<p align="justify"><b>Cláusula 4ª:</b> A Licenciante não se responsabiliza pela inoperância da captura de andamento dos processos junto aos tribunais / órgãos que possam dificultar e em alguns casos impedir a captura automatizada de informações, dificultando ou impedindo o perfeito funcionamento do sistema.</p>
						<p align="justify"><b>Cláusula 5ª:</b> A Licenciante não se responsabiliza pela veracidade das informações disponibilizadas pelos tribunais / órgãos. </p>
						<p align="justify"><b>Cláusula 6ª:</b> O valor acima será reajustado anualmente conforme a variação do IGP-M, ou, na sua falta, por outro índice que reflita a inflação no período. </p>
						<p align="justify"><b>Cláusula 7ª:</b> O Licenciado terá direito a todas as atualizações, às novas versões do APOL e ao Suporte Técnico de acordo com o Contrato vigente. </p>
						<p align="justify"><b>Cláusula 8ª:</b> Esse aditivo vigorará pelo mesmo prazo do Contrato inicial, dele fazendo parte integrante para todos os fins de direito, podendo ser rescindido pela Licenciante de acordo com os termos definidos no referido negócio jurídico. </p>
						<p align="justify"><b>Cláusula 9ª:</b> Permanecem inalteradas e em vigor as demais cláusulas e condições avençadas no Contrato, que não modificadas pelo presente instrumento. </p>
						</a>
						<p align="justify">
									<input type="checkbox" id="aceite" name="aceite" value="0" class="cfrm"/>
									 <b>Aceito os Termos Descritos Acima</b></td></p>
					</tr>
						<a name=desc>
					<tr>
						<td align="center">
						<table class="linkp11">
						<tr>
							<td width="99%" align="center"><br>
								<input type="submit" class="cfrm" name="btGravar0" value="Gravar"> 
								<input type="button" class="cfrm" name="btSair" value="Voltar" onclick="javascript:history.go(-1);">
							</td>
						</tr>
						</table>
						</td>
					</tr>
					</table>
						</td>
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
		
		function valida1(){
			var vazio = true;
			if (frm1.aceite.checked){
			}
			else
			{
				alert("Preencha o Termo de Aceite.");
				frm1.aceite.focus();
				return false;

			}
		}

		function valida(frm){
			if (frm.AvisaLimite.checked){
				if(frm.EnviaEmail.value.indexOf('@', 0) == -1) {
				    alert("Preencha o campo E-mail corretamente. Ex.: nome@dominio.com.br");
				    frm.EnviaEmail.focus();
				    return false;
				}
				if (frm.EnviaEmail.value ==""){
					alert("Preencha o campo e-mail corretamente.");
					frm.EnviaEmail.focus();
					return false;
				}
				
				if (frm.EnviaEmail.value !=""){
					if (frm.nrolimiteconsultas.value =="0" || frm.nrolimiteconsultas.value ==""){
						alert("Preencha o campo Número de Consultas.");
						frm.nrolimiteconsultas.focus();
						return false;
					}
				}
				
			}else{
				frm.nrolimiteconsultas.value = 0;
				frm.EnviaEmail.value ="";
			}

		return true;
		}	 
		
   	
	</script>

			</body>
</html>