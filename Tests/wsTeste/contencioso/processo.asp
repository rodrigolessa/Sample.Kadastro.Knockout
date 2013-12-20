<%
	Dim operacao
	Dim objProcessoJuridico
	Dim novaNumeracao, flgNovaNumeracao

	operacao = Trim(Request("cadproc"))
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!--#include file="../include/adovbs.inc" -->
<!--#include file='../usuario_logado.asp'-->  
<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn_webseek.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="../contrato/conn_v.asp"-->
<!--#include file='../include/Db_open_webseek_teste.asp'-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<!--#include file="../include/verifica_modulo.asp"-->
<!--#include file="../include/helpers/inc_ADOHelper.asp"-->
<!--#include file="../include/helpers/inc_StringHelper.asp"-->
<!--#include file="../classes/cParametro.asp"-->
<!--#include file="processo_numeracao.asp"-->
<%
	Response.CacheControl="no-cache"
	Response.AddHeader "Pragma","no-cache"
	Response.Expires = 0
	Response.Buffer = True

	'TODO: Excluir para produÁ„o
	Dim dbConnectionString
	dbConnectionString = "DRIVER={SQL Server};Server="&Application("nome_servidor_dados")&";Database=Apol;UID="&Application("usuario")&";PWD="&Application("senha")
	'Dim strUrlCadastroClienteExterno
	Dim strUrlPastaClienteExterno
	
	Call Main()

	Sub Main()
		Call CarregarParametrosGerais()
	End Sub

	Sub CarregarParametrosGerais()

		Dim objParametrosGerais, objRS
		Dim strVinculado

		Set objParametrosGerais = new cParametro

		strVinculado = Session("vinculado")
		'TODO: Excluir para produÁ„o
		'strUrlCadastroClienteExterno = ""
		strUrlPastaClienteExterno = ""

		Set objRS = objParametrosGerais.GetRsByUsuario(strVinculado)

		If Not objRS.eof Then
			'TODO: Excluir para produÁ„o
			'strUrlCadastroClienteExterno = objRS("UrlCadastroClienteExterno")
			strUrlPastaClienteExterno = objRS("UrlPastaClienteExterno")
		End If

	End Sub

	session("voltar") = Request.ServerVariables("HTTP_REFERER")


	if request("sqlupload") <> "" and request("sqlupload") then

		sqlAux = "UPDATE contencioso.dbo.tbProcInPDF SET aviso = 'true' WHERE id_processo ='"& request("id_processo") &"'"
		set rsAux = server.createobject("ADODB.Recordset")
		set rsAux = conn.execute(sqlAux)
		Set rsAux = Nothing

	end if

	if (not Session("cont_cons_proc")) and (not Session("adm_adm_sys")) then
		bloqueia
		response.end
	end if

	if (not Session("cont_manut_proc")) and (not Session("adm_adm_sys")) and (Request("cadproc") = "inclusao") then
		bloqueia
		response.end
	end if

	sqlC = "select andamentos, campo1, campo2, campo3, campo4 from parametros where usuario = '" & session("vinculado") & "'"
	set rsC = db.execute(sqlC)
	if not rsC.EOF then
		label_campo1 = rsC("campo1")
		label_campo2 = rsC("campo2")
		label_campo3 = rsC("campo3")
		label_campo4 = rsC("campo4")
		andamentos_C = rsC("andamentos")

		if isnull(andamentos_C) or isempty(andamentos_C) or len(trim(andamentos_C)) = 0 then andamentos_C = "Andamentos"
		if isnull(label_campo1) or isempty(label_campo1) or len(trim(label_campo1)) = 0 then label_campo1 = "Campo 1"
		if isnull(label_campo2) or isempty(label_campo2) or len(trim(label_campo2)) = 0 then label_campo2 = "Campo 2"
		if isnull(label_campo3) or isempty(label_campo3) or len(trim(label_campo3)) = 0 then label_campo3 = "Campo 3"
		if isnull(label_campo4) or isempty(label_campo4) or len(trim(label_campo4)) = 0 then label_campo4 = "Campo 4"
	else
		andamentos_C = "Andamentos"
		label_campo1 = "Campo 1"
		label_campo2 = "Campo 2"
		label_campo3 = "Campo 3"
		label_campo4 = "Campo 4"
	end if

	vid_processo = tplic(0,request("id_processo"))

	'NAVEGACAO
	pg = 0

	bPossui = false

	if instr(Request.ServerVariables("HTTP_REFERER"),"processo_result.asp") < 1 and Request("pg") = "" and request("imprimir") = "" then 
		if isobject(session("C_nvgc_prcss")) then session("C_nvgc_prcss") = null
	end if


	if isobject(session("C_nvgc_prcss")) then

		if not Request("pg") = "" and isnumeric(Request("pg")) then

			pg = cdbl(request("pg"))

			if isobject(session("C_nvgc_prcss")) then
				if session("C_nvgc_prcss").recordcount >= pg then
					session("C_nvgc_prcss").AbsolutePosition = pg
				end if
			end if

		elseif not vid_processo = "" then

			if session("C_nvgc_prcss").recordcount > 0 then

				session("C_nvgc_prcss").MoveFirst

				do while not session("C_nvgc_prcss").eof
					pg = pg + 1
					if session("C_nvgc_prcss")("id_processo") = int(vid_processo) then 
						bPossui = true
						exit do
					end if

					session("C_nvgc_prcss").movenext
				loop

			end if

			if bPossui then	
				session("C_nvgc_prcss").AbsolutePosition = pg
			else
				pg = 0
				Session.Contents.Remove("C_nvgc_prcss")
			end if 	

		end if

	end if

	if vid_processo = "" and not pg = 0 then 
		vid_processo = session("C_nvgc_prcss")("id_processo")
	end if

	'FIM NAVEGACAO

	'if len(trim(vid_processo)) > 0 then
	'SET objProcessoJuridico = new clsProcessoJuridico()
	'call objProcessoJuridico.ObterPeloCodigo vid_processo
	'end if
%>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title>APOL JurÌdico<% If Request("imprimir") <> "" then %> - Impress„o de InformaÁıes<% End If %></title>
	<meta http-equiv="CACHE-CONTROL" content="public">
	<link href="../include/stylesheets/main.css" type="text/css" rel="Stylesheet" />
	<link href="style.css" type="text/css" rel="Stylesheet" title="StyleSheet" />
	<link href="css/jquery-ui.css" type="text/css" rel="stylesheet" /> 
	<link href="css/style_tribunais.css" type="text/css" rel="stylesheet" /> 
	<link href="../adm/css/jquery-ui-1.10.3.custom.css" type="text/css" rel="stylesheet">
<%
	if ucase(request("env_email")) <> "S" then
%>
	<script language="javascript" src="valida.js"></script>
	<script language="JavaScript" src="../include/funcoes.js"></script>
	<script language="JavaScript" src="../include/pupdate.js"></script>
	<script language="JavaScript" src="../include/jquery-1.3.1.js" type="text/javascript"></script>
	<script language="JavaScript" src="../include/navegacao_proc.js"></script>		
	<script src="../include/javascripts/main.js" type="text/javascript"></script>
	<script src="js/jquery-1.9.1.min.js" type="text/javascript"></script>
	<script src="js/jquery.maskedinput.min.js" type="text/javascript"></script>
    <script src="js/jquery-ui.min.js" type="text/javascript"></script>
	<script>
	    var fixo = true;
	    var posiX = 530;
	    var posiY = 365;
	</script>
	<script language="javascript">

	    var jq = jQuery.noConflict();
		
        //Configurando calendarios 
        jQuery(document).ready(function(){
           jQuery(".data").mask("9?9/99/9999",{placeholder:" "}).datepicker(); 
		   
		   jQuery.ajaxSetup({
				cache: false,
				dataType: 'text'
			});
        });
		
		jq(function(){
			jq.ajaxSetup({
				cache: false,
				async: false
			});
			jq("#divPerguntaConfirmaPasta").hide();
			
			jq('#cadNumPasta').click(function(){
				<%
				set rsPasta = conn.execute("select pasta from contencioso.dbo.TabProcCont where id_processo = '" & request("id_processo") & "' ")

				if not rsPasta.eof then 
					if trim(rsPasta("pasta")) = "" or (isnull(trim(rsPasta("pasta"))))  then %>
						jq.get('../gera_seq_pasta.asp?tipo=C', function(data){
							jq("input[name='fpasta_c']").val(jq.trim(data)).attr('readonly', false).css("color", "#000000");
						});
						jq("input[name='valor_pasta']").val('S');
						document.frm.fpasta_c.focus();
					<%
					else
					%>
						jq("#altera_pasta").css("top", jq("#cadNumPasta").offset().top);
						jq("#altera_pasta").show();
					<%
					end if
				else
					%>
					jq.get('../gera_seq_pasta.asp?tipo=C', function(data){
							jq("input[name='fpasta_c']").val(jq.trim(data)).attr('readonly', false).css("color", "#000000");
						});
						jq("input[name='valor_pasta']").val('S');
				<%
				end if
				%>
				
				jq('html, body').animate({ scrollTop: jq("#cadNumPasta").offset().top }, 500);
			});
			
			jq("input[name='fpasta_c']").keypress(function(){
				jq("input[name='valor_pasta']").val('M');
			});
		});
		
		function AltPasta(){
			jq.get('../gera_seq_pasta.asp?tipo=C', function(data){
					jq("input[name='fpasta_c']").val(jq.trim(data)).attr('readonly', false).css("color", "#000000");
				});
			jq("input[name='valor_pasta']").val('S');
			document.frm.fpasta_c.focus();
		}
		
		function fecha_alt_pasta()
		{
			jq("#altera_pasta").hide();
		}

	    function verificaSolicitacoes(tipo, processo) {
	        //return false;       
	        var erro = 0;
	        if (window.XMLHttpRequest) {
	            req = new XMLHttpRequest();
	        }
	        // Internet Explorer
	        else if (window.ActiveXObject) {
	            req = new ActiveXObject("Microsoft.XMLHTTP");
	        }

	        procs = processo.replace(/##/g, ',');
	        procs = procs.replace(/#/g, '');
	        var url = "../solicitacao_verifica_solicitacoes.asp?tipo='" + tipo + "'&procs='" + procs + "' ";

	        req.open("Get", url, false);
	        req.onreadystatechange = function() {
	            if (req.readyState == 4 && req.status == 200) {
	                var resposta = req.responseText;

	                if (resposta != '') {
	                    jq("#msg_exc").text(resposta);
	                    return true;
	                } else
	                    return false;
	            }
	        }
	        req.send(null);
	    }

	</script>	
	<script language="JavaScript" src="../adm/js/jquery-1.4.4.min.js" type="text/javascript"></script>
	<script language="JavaScript" src="../adm/js/jquery-ui-1.8.9.custom.min.js" type="text/javascript"></script>
	<script language="JavaScript" src="../adm/js/jquery.ui.datepicker-pt-BR.js" type="text/javascript"></script>
	<script language="JavaScript" src="../adm/js/jquery.maskedinput-1.2.2.js" type="text/javascript"></script>
	<script src="../include/jquery.maskMoney.0.2.js" type="text/javascript"></script>

	<script type="text/javascript">
		//inserido mascaras nos campos
		$(document).ready(function (){

			$('.mascaraValor').maskMoney({symbol:'',decimal:',',thousands:'.'});

		});
	
	    var ns6=document.getElementById&&!document.all
	
	    function restrictinput(maxlength,e,placeholder){
	    if (window.event&&event.srcElement.value.length>=maxlength)
	    return false
	    else if (e.target&&e.target==eval(placeholder)&&e.target.value.length>=maxlength){
	    var pressedkey=/[a-zA-Z0-9\.\,\/]/ //detect alphanumeric keys
	    if (pressedkey.test(String.fromCharCode(e.which)))
	    e.stopPropagation()
	    }
	    }
	
	    function countlimit(maxlength,e,placeholder,nome){
	    var theform=eval(placeholder)
	    var lengthleft=maxlength-theform.value.length
	    var placeholderobj=document.all? document.all[placeholder] : document.getElementById(placeholder)
	    if (window.event||e.target&&e.target==eval(placeholder)){
	    if (lengthleft<0)
	    theform.value=theform.value.substring(0,maxlength)
	    //placeholderobj.innerHTML=lengthleft
	    escrevelyr(nome,lengthleft);
	    }
	    }
	
	    function displaylimit(thename, theid, thelimit) {
            var theform = theid != "" ? document.getElementById(theid) : thename
            var limit_text = '<b><span id="' + thename + '">' + thelimit + '</span></b> caracteres restantes atÈ o limite.'
            if (document.all || ns6)
                document.write(limit_text)
            if (document.all) {
                eval(theform).onkeypress = function () { return restrictinput(thelimit, event, theform) }
                eval(theform).onkeyup = function () { countlimit(thelimit, event, theform, thename) }
            }
            else if (ns6) {
                document.body.addEventListener('keypress', function (event) { restrictinput(thelimit, event, theform) }, true);
                document.body.addEventListener('keyup', function (event) { countlimit(thelimit, event, theform) }, true);
            }
        }
	
	    function valida(){
		    if (document.frm.nome.value == ""){
			    alert("Preencha os campos corretamente.");
			    document.frm.nome.focus();
			    return false;
		    }
		    else{
			    return true;
		    }
	    }

        function valor(campo)
        {
	        var digits="0123456789,."
	        var campo_temp 
	        for (var i=0;i<campo.value.length;i++){
	          campo_temp=campo.value.substring(i,i+1)	
  
	          if (digits.indexOf(campo_temp)==-1){
		            campo.value = campo.value.substring(0,i);
		            break;
	           }	   
	        }
        }	

	    <% 'NAVEGAVAO JS %>
	    function mprox(a){
		    a = a + 1;
		    muda_pg(a);
	    }

	    function mante(a){
		    a = a - 1;
		    muda_pg(a);
	    }
		
	    function mprim(a){
		    muda_pg(a);
	    }	
	
	    function multi(a){
		    muda_pg(a);
	    }
        <%
	    if isobject(session("C_nvgc_prcss")) then
        %>
	    function handleEnter2(field, eventi, npg) {
		    var keyCode = eventi.keyCode ? eventi.keyCode : eventi.which ? eventi.which : eventi.charCode;
		    if (keyCode == 13) {
			    if ((npg > <%= session("C_nvgc_prcss").RecordCount %>) || (npg == 0)){
				    alert('Coloque uma p·gina existente.');
				    return false;
			    }
			    else{
				    muda_pg(npg);
				    return false;
			    }
		    } 
		    else {
			    if ((keyCode >= 48) && (keyCode < 58)) {
				    return true;
			    }
			    else {
				    return false;
			    }
		    }
	    }
	    function muda_pg(num){
		    var navega_url = 'processo.asp?';
		    if (doDigits(num)) {
				    navega_url += BuscaUrlNavegacao(6,num);
				    navega_url = jQuery.trim(navega_url);
				    document.location.href = navega_url;
		    }
		    else
			    alert('Esse campo sÛ aceita digitos.');
	    }
        <%
	    end if
        %>		
	    <% 'FIM NAVEGAVAO JS %>	
		
        function muda_habilita(){
	        document.frm.fperiodicidade_c.disabled = false;
			var x= document.getElementById("fperiodicidade_c");
			x.remove(0);
		}

        function muda_desabilita() {
	        document.frm.fperiodicidade_c.disabled = true;
	    }
		
        function muda_sit(sit){

        <%if request("imprimir") = "" then

	        %>	

	        if (eval("document.frm.fsituacao_c.value") == 'E')
		        {
		        document.getElementById("encerrado_label").style.color = "#000000" 
		        document.getElementById("dt_encerrado_label").style.color = "#000000" 

		        document.frm.fsituacaoenc_c.disabled = false;
		        document.frm.fsituacaoenc_c.style.backgroundColor = '#ffffff';
		
		        document.frm.facordo_c.disabled = false;
		        document.frm.facordo_c.style.backgroundColor = "#F3F3F3"
		
		        document.frm.fdt_encerra_d.disabled = false;
		        document.frm.fdt_encerra_d.style.backgroundColor = '#ffffff';	
		
		        document.frm.fvalor_final_n.disabled = false;
		        document.frm.fvalor_final_n.style.backgroundColor = '#ffffff';	
		
		        document.getElementById("acordo_label").innerHTML = '<font color="black">Acordo</font>'
		
		        }
	        else
		        {
		        document.getElementById("encerrado_label").style.color = "#808080" 
		        document.getElementById("dt_encerrado_label").style.color = "#808080" 
		
		        document.frm.fsituacaoenc_c.disabled = true;
		        document.frm.fsituacaoenc_c.style.backgroundColor = '#CCCCCC';
		        document.frm.fsituacaoenc_c.value = '';
		
		        document.frm.facordo_c.disabled = true;
		        document.frm.facordo_c.style.backgroundColor = "#F3F3F3"
		        document.frm.facordo_c.checked = false;		
		
		        document.frm.fdt_encerra_d.disabled = true;
		        document.frm.fdt_encerra_d.style.backgroundColor = '#CCCCCC';
		        document.frm.fdt_encerra_d.value = '';

		        document.frm.fvalor_final_n.disabled = true;
		        document.frm.fvalor_final_n.style.backgroundColor = '#CCCCCC';	
		        document.frm.fvalor_final_n.value = '';
				
		        document.frm.fdt_encerra_d.style.font = '11px Verdana;';	
		        document.frm.fdt_encerra_d.style.borderRight = '1px solid #A5ACB2';	
		        document.frm.fdt_encerra_d.style.borderLeft = '1px solid #A5ACB2';	
		        document.frm.fdt_encerra_d.style.borderTop = '1px solid #A5ACB2';	
		        document.frm.fdt_encerra_d.style.borderBottom = '1px solid #A5ACB2';	

		        document.getElementById("acordo_label").innerHTML = '<font color="#808080">Acordo</font>'
		        }		

        <%end if%>
        }			

        function validaprocessorio(processo)
        {
	        if (processo.value !="")
	        {
		        var expressao = /^\d{5}-\d{4}-\d{3}-\d{2}$/;
		        if (!expressao.test(processo.value))
		        {
			        alert('Para processos do TRT Rio os processos deve estar cadastrados com o seguinte critÈrio\nxxxxx-xxxx-xxx-xx, onde x È n˙merico.');
			        return false;
		        }
	        }
        }

    </script>
<% End If %>
</head>

<%
if request("imprimir") = "S" and request("env_email") <> "S" then
	l_impx = "_p"
	l_imp = "_p"
end if

if request("id_proc") <> "" then
	sql = 	" SELECT	id_processo, " & _
			"			tribunal_sync, " & _
			"			responsavel, " & _
			"			usuario, " & _
			"			processo, " & _
			"			natureza, " & _
			"			tipo_acao, " & _
			"			pasta, " & _
			"			desc_res, tipo, competencia, situacao, situacaoenc, cliente, outraparte, vinculados, " & _
			"			instancia, rito, orgao, juizo, comarca, distribuicao,  dt_encerra, desc_det, obs, " & _
			"			participante, principal, dt_cad " & _
			"			habilitatrib, periodicidade, tipo_consulta_processo " & _
			" FROM	TabProcCont " & _
			" WHERE	usuario = '" & session("vinculado") & "' " & _
			"	AND	processo = '" & tplic(0,request("id_proc")) & "'"
	'response.write(sql)
	set rst = db.execute(sql)
	if not rst.eof then
		vid_processo = rst("id_processo")
		processo = rst("processo")
	end if
end if

if vid_processo <> "" then
	bt_imprimir = true 
	email_cont = true

	sql = "SELECT id_processo " & _
		", pasta " & _
		", distribuicao " & _
		", processo " & _
		", natureza " & _
		", tipo_acao " & _
		", acordo " & _
		", valor_causa " & _
		", flgNovaNumeracao " & _
		", novaNumeracao " & _
		", novoTipoConsulta " & _
		", valor_provavel " & _
		", resultado_previsto " & _
		", valor_final " & _
		", dt_encerra " & _
		", juizo " & _
		", desc_res " & _
		", situacao " & _
		", situacaoenc " & _
		", tipo " & _
		", instancia " & _
		", comarca " & _
		", competencia " & _
		", rito " & _
		", orgao " & _
		", CASE WHEN ISNUMERIC(tribunal_sync) > 0 then '' ELSE tribunal_sync END AS tribunal_sync " & _
		", responsavel " & _
		", desc_det " & _
		", obs " & _
		", participante " & _
		", principal " & _
		", cmp_livre_1 " & _
		", cmp_livre_2 " & _
		", dt_cad " & _
		", tipo_consulta_processo " & _
		", habilitatrib " & _
		", periodicidade " & _
		", objeto_principal " & _
		", dt_citacao " & _
		", cmp_livre_3 " & _
		", cmp_livre_4 " & _
		" FROM Contencioso.dbo.TabProcCont " & _
		" WHERE usuario = '" & session("vinculado") & "' " & _
		" AND id_processo = " & vid_processo

	SET rst = db.execute(sql)

	if not rst.eof then

		id_processo = rst("id_processo")
		pasta = rst("pasta")
		distribuicao = fdata(rst("distribuicao"))
		processo = rst("processo")
		natureza = rst("natureza")
		tipo_acao = rst("tipo_acao")
		acordo = rst("acordo")
		valor_causa = rst("valor_causa")
		flgNovaNumeracao = UCase(rst("flgNovaNumeracao"))
		novaNumeracao = trim(rst("novaNumeracao"))
		novoTipoConsulta = trim(rst("novoTipoConsulta"))

		valor_provavel = rst("valor_provavel")

		resultado_previsto = rst("resultado_previsto")

		valor_final = rst("valor_final")

		dt_encerra = fdata(rst("dt_encerra"))

		juizo = rst("juizo")
		desc_res = rst("desc_res")
		situacao = rst("situacao")
		situacaoenc = rst("situacaoenc")
		tipo = rst("tipo")
		instancia = rst("instancia")
		comarca = rst("comarca")
		competencia = rst("competencia")
		rito = rst("rito")
		orgao = rst("orgao")
		tribunal_sync = rst("tribunal_sync")
		responsavel = rst("responsavel")
		desc_det = rst("desc_det")
		obs = rst("obs")
		participante = rst("participante")
		principal = rst("principal")
		cmp_livre_1 = rst("cmp_livre_1")
		cmp_livre_2 = rst("cmp_livre_2")
		
		dt_cad = rst("dt_cad")

		tipo_consulta_processo = trim(rst("tipo_consulta_processo"))

		if trim(rst("habilitatrib")) = "" or isnull(rst("habilitatrib")) then
			habilitatrib = 0
		else
			habilitatrib = rst("habilitatrib")
		end if

		periodicidade = rst("periodicidade")
		objeto_principal = rst("objeto_principal")
		dt_citacao = fdata(rst("dt_citacao"))
		cmp_livre_3 = rst("cmp_livre_3")
		cmp_livre_4 = rst("cmp_livre_4")

		if len(valor_causa) > 2 then
			valor_causa = formatNumber(valor_causa)
		end if 

		if len(valor_provavel) > 2 then
			valor_provavel = formatNumber(valor_provavel)
		end if 

		if len(valor_final) > 2 then
			valor_final = formatNumber(valor_final)
		end if

		if instr(valor_causa,",") = 0 then
			valor_causa = valor_causa&",00"
		End If
		
		if instr(valor_provavel,",") = 0 then
			valor_provavel = valor_provavel&",00"
		End If
		
		if instr(valor_final,",") = 0 then
			valor_final = valor_final&",00"
		End If
		
		'======MOVIMENTACAO DE PASTAS +++++++++++++++++++++++++++		
		if request("imprimir")="" then
            sqlEmprestimoProcesso = " select (select nomeusu from usuarios_apol.dbo.usuario where codigo=id_usuario_para) as comUsuario from solicitacao s1 inner join item_solicitacao i1 on i1.id_solicitacao=s1.id_solicitacao where status=200 "
            sqlEmprestimoProcesso = sqlEmprestimoProcesso & " and id_documento_solicitado = " & vid_processo & " and tipo_processo='C' and s1.id_usuario_principal="&session("codigo_vinculado")

            set rsEmprestimoProcesso = server.CreateObject("ADODB.Recordset")
            rsEmprestimoProcesso.Open sqlEmprestimoProcesso, conn, 3, 3

            comUsuario =  ""
            if not rsEmprestimoProcesso.EOF then
                if not isnull(rsEmprestimoProcesso("comUsuario")) then comUsuario = rsEmprestimoProcesso("comUsuario")
            end if
        end if
        '++++++++++++++++++++++++++++++++++++++++++++++++++++++
		
	else
%>
        <script>
	        alert('Processo n„o encontrado.');
	        history.back();
        </script>
<%
		Response.end

	end if

	'SET rst = nothing
	
end if


'BUSCA SE O USU¡RIO DESEJA QUE O RESPONS¡VEL DAS PROVID NCIAS SEJA O MESMO DO PROCESSO
sql_resp = "SELECT resp_proc_provid FROM Parametros WHERE usuario = '" & Session("vinculado") & "'"
set rs_resp = db.execute(sql_resp)
if not rs_resp.eof then
	mesmo_resp = rs_resp("resp_proc_provid")
end if
rs_resp.close
set rs_resp = nothing

'BUSCA OS RESPONS¡VEIS DAS PROVID NCIAS

sql_resp = "SELECT advogado FROM Providencias WHERE ISNULL(advogado, '') <> '' AND (processo = '"&tplic(0, processo)&"') AND (usuario = '"&session("vinculado")&"' or usuario = '"&session("vinculado")&"##"&session("nomeusu")&"') and (tipo = 'C')"
set rs_resp = conn.execute(sql_resp)
if not rs_resp.eof then
	do while not rs_resp.eof
		resps = resps & rs_resp("advogado") & "," 
		rs_resp.movenext
	loop
	resps = left(resps, len(resps) - 1)
end if
'response.write resps & " - " & mesmo_resp

if request("x") = "1" then
	pasta = request("fpasta_c")
	distribuicao = fdata(request("fdistribuicao_d"))
	processo = request("fprocesso_c")
	natureza = request("fnatureza_n")	
	tipo_acao = request("ftipo_acao_n")		
	dt_encerra = fdata(request("fdt_encerra_d"))
	juizo = request("fjuizo_n")

	if juizo = "" then juizo = 0

	desc_res = request("fdesc_res_c")
	situacao = request("fsituacao_c")
	situacaoenc = request("fsituacaoenc_c")	
	tipo = request("ftipo_c")
	instancia = request("finstancia_c")
	comarca = request("fcomarca_n")

	if comarca = "" then comarca = 0

	competencia = request("fcompetencia_c")
	rito = request("frito_n")

	if rito = "" then rito = 0

	orgao = request("forgao_n")

	if orgao = "" then orgao = 0

	responsavel = request("fresponsavel_n")
	if responsavel = "" then
		responsavel = 0
	else
		responsavel = int(responsavel)
	end if
	desc_det = request("fdesc_det_c")
	obs = request("fobs_c")
	participante = request("fparticipante_c")
	principal = request("fprincipal_c")
end if

if isnull(natureza) or natureza = "" then
	natureza = 0
end if

if isnull(tipo_acao) or tipo_acao = "" then
	tipo_acao = 0
end if
%>

<body leftmargin="0" topmargin="0">
	<div id="processando_div" style="position: absolute; top: 1px; width: 99%; left: 1px; height:450px; display:none;"></div>
<%
menu_onde = "proc" 
if request("imprimir") = "" then
%>
	<!--#include file="header.asp"-->
<%
Else
	if request("env_email") = "S" then
%>
[obs_email] 
<%
	Else
%>
	<table cellpadding="0" cellspacing="0" width="100%" border="0" class="preto11">	
	<tr>
		<td><%
			SQL = "select logotipo from usuario where vinculado='"&session("vinculado")&"' and nomeusu='"& session("vinculado") &"'"
			set rsy = conn_usu.execute(SQL)

			if rsy("logotipo") <> "" then
			%>
			<img src="../logo_cliente/<%=rsy("logotipo")%>" border="0">
			<% end if %></td>
		<td align="right" valign="top"><span class="preto11<%=l_imp%>"><%= now() %></span></td>
	</tr>
	</table>
<% End If %>
<% End If  %>
	<a name="dados">
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
		<form name="frm" action="processo_salvar.asp" method="post" onsubmit="return valida()">	
		<input type="hidden" name="tipo_vinc" value="" />
		<input type="hidden" name="id" value="<%=vid_processo%>" />
		<input type="hidden" name="troca_campo" value="N"/>
		<input type="hidden" name="codigo" value="<%=vid_processo%>"/>
		<input type="hidden" name="alt_todos_resp" value=""/>
		<input type="hidden" name="resp_provid" value="<%=resps%>"/>
		<input type="hidden" name="mesmo_resp" value="<%=mesmo_resp%>"/>
		<input type="hidden" name="pg" value="<%=pg%>"/>
		<input type="hidden" name="chaveProcesso" value="<%=tribunal_sync & "_" & tipo_consulta_processo & "." & processo %>"/>
		<input type="hidden" name="chaveProcessoAntigo" value="<%=tribunal_sync & "_" & tipo_consulta_processo & "." & processo %>"/>
		<tr>		
			<td height="16" valign="middle" width="23px">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18"/></td>
			<td height="16" valign="middle" align="center" class="titulo">&nbsp;Dados&nbsp;Principais&nbsp;</td>
			<td height="16" width="100%">
			<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"/></td>
<% 
	if not pg = 0 and request("imprimir") = "" then
		if session("C_nvgc_prcss").AbsolutePosition > 1 and pg <> 0 then 
%>
			<td height="16" ><a href="javascript: mprim(1)"><img src="imagem/setas_navegacao_04.gif" alt="Primeira P·gina" border="0"/></a></td>
			<td height="16" ><a href="javascript: mante(<%=pg%>)"><img src="imagem/setas_navegacao_02.gif" alt="P·gina Anterior" border="0"/></a></td>
<% 	
		else 
%>
			<td><img src="imagem/setas_navegacao_04_desat.gif" border="0"/></td>
			<td><img src="imagem/setas_navegacao_02_desat.gif" border="0"/></td>
<% 
		end if 
%>		
			<td align="center" width="10%"><b><input type="text" name="pg_escolha" size="3" maxlength="4" onkeypress="return handleEnter2(this, event, this.value)" class="cfrm" onfocus="this.select()" style="text-align: center; font-weight: bold;" value="<%= pg %>">&nbsp;de&nbsp;<%= session("C_nvgc_prcss").RecordCount %></b></td>
<%	
		if session("C_nvgc_prcss").AbsolutePosition < Session("C_nvgc_prcss").RecordCount And pg <> 0 then 
%>
			<td><a href="javascript: mprox(<%=pg%>)"><img src="imagem/setas_navegacao_12.gif" alt="PrÛxima P·gina" border="0"></a></td>
			<td><a href="javascript: multi(<%=Session("C_nvgc_prcss").RecordCount%>)"><img src="imagem/setas_navegacao_10.gif" alt="⁄ltima P·gina" border="0"></a></td>						
<%
		else 
%>
			<td><img src="imagem/setas_navegacao_12_desat.gif" border="0"/></td>	
			<td><img src="imagem/setas_navegacao_10_desat.gif" border="0"/></td>					
<% 
		end if
	end if

%>			
			<td height="16" valign="middle" width=20px>
			<img src="imagem/tit_fim.gif" width="21" height="16"></td>
<%
	if request("cadproc") = "" then
%>
<%
		if not rst.eof then
%>
<%
			If Request("imprimir") = "" then
%>
			<td height="16" valign="middle">
<%
				if (Session("cont_exc_proc")) or (Session("adm_adm_sys")) then
%>
				&nbsp;<a href="javascript: exc_proc()" class="linkp11"><img src="imagem/lixeira.gif" alt="Excluir" width="13" height="17" border="0" align="absmiddle"></a>
<%
				End If
%>
<%
			End If
%>
<%
		end if
%>
<%
	end if
%>
			<% If vid_processo <> "" then%><%If Request("imprimir") = "" then %><td align="center"><%set rst_carta = db.execute("Select comunicacao from Parametros WHERE  usuario = '"&session("vinculado")&"'")%><%if trim(rst_carta("comunicacao")) <> "" then %>&nbsp;<a href="javascript:abrirjanela('gera_carta_contencioso.asp?origem=M&id_processo=<%=id_processo%>',350,110)"><img src="imagem/carta.gif" alt="<% if trim(rst_carta("comunicacao")) = "" then %>Gerar carta. Padr„o n„o definido.<% Else %>Gerar carta<% End If %>" border="0"></a>&nbsp;</td><% End If %><%end if%><%end if%>
				<% If Request("imprimir") = "" and vid_processo <> "" then %>	
	            <td height="16" valign="bottom" class="titulo" align="center">
	                &nbsp;<span style="cursor:hand;" class="preto11" onclick="javascript:abrirjanela('../solicitacao_popup.asp?id=<%=id_processo%>&tipo=C',605,200);">
		                    <% if comUsuario="" then %>
		                        <img src="../imagem/folder_green.png" alt="Solicitar pasta" width="13px" height="13px"/>
		                    <% else %>
		                        <img src="../imagem/folder_red.png" alt="Est&aacute; com <%=comUsuario %>" width="13px" height="13px"/>
		                    <%end if %>
		            </span></td>
	            <%end if %>
		</tr>
	</table>
	<table width="100%" class="preto11" <%if request("imprimir") = "" then%>bgcolor="#efefef"<%end if%>  border="0" cellspacing="2" cellpadding="3">
		<tr>
			<td align="left" width="110px">Processo:</td>
			<td colspan="3" width="600px">
				<table width="100%" class="preto11" <%if request("imprimir") = "" then%>bgcolor="#efefef"<%end if%>  border="0" cellspacing="0" cellpadding="2">
					<tr>
						<td style="text-align:left;padding-left:0;" width="52%">
<%
							if request("imprimir") = "" then
%>
								<span id="numero_processo"><%=processo%></span>

								<input type="hidden" name="fprocesso_c" id="fprocesso_c" value="<%=processo%>">
								<input type="hidden" name="numero_processo_antigo" id="numero_processo_antigo" value="<%=processo%>">
								<input type="hidden" name="numero_processo_novo" id="numero_processo_novo" value="">

								<img src="../imagem/cad_num_processo.GIF" id="imgProc" border="0" align="absmiddle" style="cursor: pointer;" onclick="abrirPopup();" alt="<% if len(trim(vid_processo)) = 0 then response.write("Gerar N˙mero do Processo") else response.write("Editar N˙mero do Processo") end if %>"/>

								<input type="hidden" name="ftipo_consulta_processo_c" value="<%=tipo_consulta_processo%>">
								<input type="hidden" name="novo_tipo_consulta" value="<%=novoTipoConsulta%>">

								&nbsp;&nbsp;
								<img id="btnNovaNumeracao" src="../imagem/proc_sem_num_juridico.png" border="0" alt="Alterar o processo para a nova numeraÁ„o do Tribunal" align="absmiddle" style="cursor: pointer;">
								<script language="javascript">
									$('#btnNovaNumeracao').hide();
								</script>
<%
							else
%>
								<%=processo%>
<%
							end if
%>
						</td>
						<td width="18%" nowrap>Data de Cadastro:</td>
							<%if isnull(dt_cad) or dt_cad = "" then	
									dt_cad 	= now()
							end if%>
						<td align="left" width="30%"><%=fdata(dt_cad)%></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="left" width="5%">
				Pasta:
				<%If Not IsEmpty2(strUrlPastaClienteExterno) and request("imprimir") = "" Then%>
					<!-- Pasta Externa -->
					<a href="javascript:void(0);" style="display:block;" title="Clique aqui para abrir o link externo da pasta" class="pasta_externa" onclick="javascript:abrirCadastroExterno(jQuery('#hid_url_pasta_externa').val(), jQuery('#fpasta_c').val());">[ver]</a>
					<input type="hidden" id="hid_url_pasta_externa" name="hid_url_pasta_externa" value="<%=strUrlPastaClienteExterno%>" />
				<%End If%>
			</td>
			<td align="left" width="18%" colspan="3">
				<%if request("imprimir") = "" then%>	
					<input class="cfrm" type="text" id="fpasta_c" name="fpasta_c" value="<%=pasta%>" maxlength=30 style="width:225">
					<input type="hidden" name="pasta_old" value="<%=pasta%>">
					<input type="hidden" name="valor_pasta" value="M"><a href="#" id="cadNumPasta" class="preto11"><img src="../imagem/cad_num_pasta.GIF"  border="0" align="absmiddle" alt="Gerar N˙mero Sequencial de Pasta"></a>
					<input type="hidden" name="valida_pasta" value="0">
					<input type="hidden" name="pastaJaCadastrada" value=""/>
				<%else%>
					<%=pasta%>
				<%end if%>
			</td>
		</tr>
		<tr>
			<td align="left">Objeto Principal:</td>
			<td colspan="3">
				<%if request("imprimir") = "" then%>
					<select class="cfrm" name="fobjeto_principal_n" style="width:320px">
						<option value="">
						<%
 						sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'L' order by descricao"
						set rst = db.execute(sql)
						do while not rst.eof
							%>
							<option value="<%=rst("codigo")%>" title="<%=rst("descricao")%>" <%if rst("codigo") = int(objeto_principal) then%>selected<%end if%>><%=rst("descricao")%></option>
							<%
							rst.movenext
						loop
						%>
					</select>
				<%else
					if trim(objeto_principal) = "" or isnull(objeto_principal) then
						objeto_principal = "0"
					end if
					sql = "select * from auxiliares where tipo = 'L' and codigo = "&tplic(1, objeto_principal)&" order by descricao"
					set rst = db.execute(sql)
					if not rst.eof then
						response.write rst("descricao")
					end if
				end if%>
			</td>
		</tr>
		<tr>
			<td align="left">Objeto:</td>
			<td align="left" colspan="3">
				<%if request("imprimir") = "" then%>
					<textarea class="cfrm" name="fdesc_res_c" id="fdesc_res_c" rows="3" cols="108" style="width:625px;s"><%=desc_res%></textarea><br/>
					<script>
					    displaylimit("id0", "fdesc_res_c", 1000);
					</script>
				<%else%>
					<%=desc_res%>
				<%end if%>
			</td>
		</tr>

		<tr>			
			<td align="left">Principal:</td>
			<td align="left">
				<%if request("imprimir") = "" then%>
					<select class="cfrm" name="fprincipal_c" style="width:60px">
						<option value="">
						<option value="S" <%if principal = "S" then%>selected<%end if%>>Sim</option>
						<option value="N" <%if principal = "N" then%>selected<%end if%>>N„o</option>
					</select>
				<%
				else
					if not isnull(principal) then
						response.write replace(replace(principal,"S","Sim"),"N","N„o")
					end if
				end if%>				
				&nbsp;&nbsp;&nbsp;&nbsp;PosiÁ„o:&nbsp;
				<%if request("imprimir") = "" then%>
					<select class="cfrm" name="fparticipante_c" style="width:90px">
						<option value="">	
						<option value="A" <%if participante = "A" then%>selected<%end if%>>Autor
						<option value="R" <%if participante = "R" then%>selected<%end if%>>RÈu
					</select>
				<%
				else
					if not isnull(participante) then
						response.write replace(replace(participante,"R","RÈu"),"A","Autor")
					end if
				end if
				%>
			</td>
			<td align="left">Natureza:</td>
			<td align="left">
				<%if request("imprimir") = "" then%>
					<select class="cfrm" name="fnatureza_n" style="width:320px">
						<option value="">
						<%
 						sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'N' order by descricao"
						set rst = db.execute(sql)
						do while not rst.eof
							%>
							<option value="<%=rst("codigo")%>" title="<%=rst("descricao")%>" <%if rst("codigo") = int(natureza) then%>selected<%end if%>><%=rst("descricao")%></option>
							<%
							rst.movenext
						loop
						%>
					</select>
				<%else
					if trim(natureza) = "" or isnull(natureza) then
						natureza = "0"
					end if
					sql = "select * from auxiliares where tipo = 'N' and codigo = "&tplic(1,natureza)&" order by descricao"
					set rst = db.execute(sql)
					if not rst.eof then
						response.write rst("descricao")
					end if
				end if%>
			</td>
		</tr>
		<tr>
			<td align="left">CompetÍncia:</td>
			<td align="left">			
			
				<%if request("imprimir") = "" then%>
					<select class="cfrm" name="fcompetencia_c" style="width:225px">
						<option value="">
						<option value="F" <%if competencia = "F" then%>selected<%end if%>>Federal
						<option value="E" <%if competencia = "E" then%>selected<%end if%>>Estadual
						<option value="M" <%if competencia = "M" then%>selected<%end if%>>Municipal
					</select>
				<%else%>
					<%
					if trim(competencia) = "" or isnull(competencia) then
						competencia = ""
					end if
					%>
					<%=replace(replace(replace(competencia,"E","Estadual"),"F","Federal"),"M","Municipal")%>
				<%end if%>
			</td>
			<td>Tipo AÁ„o:</td>
			<td>
				<%if request("imprimir") = "" then%>
					<select class="cfrm" name="ftipo_acao_n" style="width:320px">
						<option value="">
						<%
 						sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'T' order by descricao"
						set rst = db.execute(sql)
						do while not rst.eof
							%>
							<option value="<%=rst("codigo")%>" title="<%=rst("descricao")%>" <%if rst("codigo") = int(tipo_acao) then%>selected<%end if%>><%=rst("descricao")%></option>
							<%
							rst.movenext
						loop
						%>
					</select>
				<%else
					if trim(tipo_acao) = "" or isnull(tipo_acao) then
						tipo_acao = "0"
					end if
					sql = "select * from auxiliares where tipo = 'T' and codigo = "&tplic(1,tipo_acao)&" order by descricao"
					set rst = db.execute(sql)
					if not rst.eof then
						response.write rst("descricao")
					end if
				end if%>
			</td>

		</tr>
		<tr>
			<td align="left">Tipo Processo:</td>
			<td align="left">
				<%if request("imprimir") = "" then%>
					<select class="cfrm" name=ftipo_c>
						<option value="">
						<option value="J" <%if tipo = "J" then%>selected<%end if%>>Judicial</option>
						<option value="A" <%if tipo = "A" then%>selected<%end if%>>Administrativo</option>
					</select>
				<%else%>
					<%
					if trim(tipo) = "" or isnull(tipo) then
						tipo = ""
					end if
					%>
					<%=replace(replace(tipo,"J","Judicial"),"A","Administrativo")%>
				<%end if%>
			&nbsp;&nbsp;&nbsp;Inst‚ncia:&nbsp;
				<%if request("imprimir") = "" then%>	
					<input class="cfrm" type="text" name="finstancia_c" value="<%=instancia%>" style="width:35px" maxlength="2" class=>
				<%else%>
					<%=instancia%>
				<%end if%>
			</td>
			<td align="left">Rito:</td>
			<td align="left">
				<%if request("imprimir") = "" then%>	
					<select class="cfrm" name="frito_n" style="width:320px">
						<option value="">
						<%
						sql = "select * from auxiliares where tipo = 'R' AND usuario = '"&session("vinculado")&"' order by descricao"
						set rst = db.execute(sql)
						do while not rst.eof
							%>
							<option value="<%=rst("codigo")%>" title="<%=rst("descricao")%>" <%if rst("codigo") = int(rito) then%>selected<%end if%>><%=rst("descricao")%></option>
							<%
							rst.movenext
						loop
						%>
					</select>
				<%else
					if trim(rito) = "" or isnull(rito) then
						rito = 0
					end if
					sql = "select * from auxiliares where tipo = 'R' and codigo = "&tplic(1,rito)&" AND usuario = '"&session("vinculado")&"' order by descricao"
					set rst = db.execute(sql)
					if not rst.eof then
						response.write rst("descricao")
					end if
				end if%>
			</td>
		</tr>
		<tr>
			<td align="left">SituaÁ„o:</td>
			<td align="left" id="encerrado_label" colspan="3">
				<%if request("imprimir") = "" then%>
					<select class="cfrm" name="fsituacao_c" onchange="muda_sit()" style="width:100px">
						<option value=""></option>
						<option value="A" <%if situacao = "A" then%>selected<%end if%> <%if request("fsituacao_c") = "A" then%>selected<%end if%>>Ativo</option>
						<option value="C" <%if situacao = "C" then%>selected<%end if%> <%if request("fsituacao_c") = "C" then%>selected<%end if%>>Em Acordo</option>
						<option value="E" <%if situacao = "E" then%>selected<%end if%> <%if request("fsituacao_c") = "E" then%>selected<%end if%>>Encerrado</option>
						<option value="I" <%if situacao = "I" then%>selected<%end if%> <%if request("fsituacao_c") = "I" then%>selected<%end if%>>Inativo</option>
					</select>
				<%else%>
					<%
					if trim(situacao) = "" or isnull(situacao) then
						situacao = ""
					end if
					Response.write "<span class=""preto11"">"
					Select Case situacao
						Case "A"
							Response.Write "Ativo"
						Case "C"
							Response.Write "Em Acordo"
						Case "E"
							Response.write "Encerrado"
						Case "I"
							Response.write "Inativo"
					End Select
					Response.write "</span>"
				end if%>
			&nbsp;Causa:&nbsp;
			<%if request("imprimir") = "" then%>
				<select class="cfrm" name="fsituacaoenc_c" style="width:70px" style="border-right:1px solid #A5ACB2;border-left:1px solid #A5ACB2;border-top:1px solid #A5ACB2;border-bottom:1px solid #A5ACB2">
					<option value=""></option>
					<option value="G" <%if situacaoenc = "G" then%>selected<%end if%>>Ganha</option>
					<option value="P" <%if situacaoenc = "P" then%>selected<%end if%>>Perdida</option>
				</select>
				<%If acordo = true then
					acordo_check = "checked"
					Else
					acordo_check = ""
					End If%>
				
				&nbsp;<input class="cfrm" type="checkbox" <%=acordo_check%> name="facordo_c" value="1" style="background-color:'#F3F3F3'">
				<%if trim(situacao) <> "E" OR (isnull(situacao) Or isempty(situacao) or len(trim(situacao)) = 0) then%><font color="#808080"><%else%><font color="#000000"><%end if%><span id="acordo_label">Acordo</span></font>

				<%else
					if not isnull(situacaoenc) and not isempty(situacaoenc) and len(trim(situacaoenc)) > 0 then
						situacaoenc = replace(replace(situacaoenc,"G","Ganha"),"P","Perdida")
					end if%>
					<font class="preto11"><%=situacaoenc%></font>
				<%end if%>
			
			<span id="dt_encerrado_label">Dt Encerramento:</span>
			<%if request("imprimir") = "" then%>	
				<input class="cfrm data" type=text name=fdt_encerra_d value="<%=dt_encerra%>" size="10"  maxlength="10" style="height:19;border-right:1px solid #A5ACB2;border-left:1px solid #A5ACB2;border-top:1px solid #A5ACB2;border-bottom:1px solid #A5ACB2">
			<%else%>
				<%=dt_encerra%>
			<%end if%>
			</td>
		</tr>
		<tr>
			<td align="left">Respons·vel:</td>
			<td>
				<%if request("imprimir") = "" then%>
					<%					
					set rs = conn.execute("Select * from responsaveis where tipo <> 'cliente' and usuario = '"&Session("vinculado")&"' order by nome")				
					%>
					
					<select class="cfrm" name="fresponsavel_n" size="1" style="width:228px">
						<option value="0"></option>
						<%
						do while not rs.eof
							%>
							<option value="<%= rs("id") %>" title="<%= rs("nome") %>" <% If rs("id") = responsavel then %> SELECTED<% End If %>><%= rs("nome") %></option>
							<%
							rs.movenext
						loop
						%>
					</select>
				<%
				else
					if responsavel = "" then responsavel = 0
					set rs = conn.execute("Select * from responsaveis where tipo <> 'cliente' and usuario = '"&Session("vinculado")&"' and id = '"&tplic(1,responsavel)&"' order by nome")						
					if not rs.eof then
						response.write rs("nome")
					end if
				end if%>
			</td>
			<td align="left">”rg„o:</td>
			<td align="left">
				<input type="hidden" name="forgao_c" value="<%=orgao%>">
  			    <input type="hidden" name="ftribunal_sync_c" value="<%=tribunal_sync%>">

				<input type="hidden" id="orgao_antigo" name="orgao_antigo" value="<%=orgao%>">
				<input type="hidden" id="orgao_novo" name="orgao_novo" value="">
  			    <input type="hidden" id="tribunal_sync_antigo" name="tribunal_sync_antigo" value="<%=tribunal_sync%>">
  			    <input type="hidden" id="tribunal_sync_novo" name="tribunal_sync_novo" value="">
				<%
					dim codTribunal
					codTribunal = trim(tribunal_sync)
	
					if isnull(tribunal_sync) or trim(tribunal_sync) = "" then
						codTribunal = orgao
						sql = "select codigo    as codigo       , 			 " & _
							  "       codigo    as sigla_codigo ,  		     " & _
							  "       descricao as descricao    		     " & _
							  "  from auxiliares                		     " & _
							  " where usuario = '"&session("vinculado") & "' " & _
							  "   and tipo = 'O' 							 " 
					else
						sql = "select ''        as codigo       , 			 " & _
							  "       sigla     as sigla_codigo ,			 " & _
							  "       nome      as descricao 				 " & _
							  "  from isis..orgao 		     				 " & _
							  "  where sigla = '" & tribunal_sync& "'"
					end if
					
				if request("imprimir") = "" then%>
					 <select class="cfrm" id="forgao_n" disabled = "true" name="forgao_n" style="width:320px" >
					 	<option value=""></option>
						<%
						set rst = db.execute(sql)
		
						do while not rst.eof
						%>
							<option value="<%=rst("codigo")%>" <%if trim(rst("sigla_codigo")) = codTribunal then%>selected<%end if%>><%=UCASE(rst("descricao"))%></option>
						<%
							rst.movenext
						loop
						%>
					</select>
				<%else	
					if trim(orgao) = "" or isnull(orgao) then
						orgao = 0
					end if
					set rst = db.execute(sql)
					if not rst.eof then
						if isnull(tribunal_sync) or trim(tribunal_sync) = "" then
							do while not rst.eof
								if trim(rst("sigla_codigo")) = orgao then
									response.write rst("descricao")
								end if
								rst.movenext
							loop
						else
							response.write rst("descricao")
						end if
					end if
				end if%>
			</td>
		</tr>
		<tr>
			<td align="left">Dt CitaÁ„o:</td>
			<td>
				<%if request("imprimir") = "" then%>	
					<input class="cfrm data" type="text" name="fdt_citacao_d" value="<%=dt_citacao%>" size="10" maxlength="10">
				<%else%>
					<%=dt_citacao%>
				<%end if%>
			</td>
			<td align="left">JuÌzo:</td>
			<td align="left">
				<%if request("imprimir") = "" then%>	
					<select class="cfrm" name="fjuizo_n" style="width:320px">
						<option value="">
						<%
						sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'J' order by descricao"
						set rst = db.execute(sql)
						do while not rst.eof
							%>
							<option value="<%=rst("codigo")%>" title="<%=rst("descricao")%>" <%if rst("codigo") = int(juizo) then%>selected<%end if%>><%=rst("descricao")%></option>
							<%
							rst.movenext
						loop
						%>
					</select>
				<%else	
					if trim(juizo) = "" or isnull(juizo) then
						juizo = 0
					end if
					sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'J' and codigo = "&tplic(1,juizo)&" order by descricao"
					set rst = db.execute(sql)
					if not rst.eof then
						response.write rst("descricao")
					end if
				end if%>
			</td>
		</tr>
		<tr>
			<td align="left">Dt DistribuiÁ„o:</td>
			<td align="left">
				<%if request("imprimir") = "" then%>	
					<input class="cfrm data" type=text name=fdistribuicao_d value="<%=distribuicao%>" size="10" maxlength="10">
				<%else%>
					<%=distribuicao%>
				<%end if%>
			</td>
			<td align="left">Comarca:</td>
			<td align="left">
				<%if request("imprimir") = "" then%>
					<select class="cfrm" name="fcomarca_n" style="width:320px">
						<option value="">
						<%
						sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = 'C' order by descricao"
						set rst = db.execute(sql)
						do while not rst.eof
							%>
							<option value="<%=rst("codigo")%>" title="<%=rst("descricao")%>" <%if rst("codigo") = int(comarca) then%>selected<%end if%>><%=rst("descricao")%></option>
							<%
							rst.movenext
						loop
						%>
					</select>
				<%else	
					if trim(comarca) = "" or isnull(comarca) then
						comarca = 0
					end if
					sql = "select * from auxiliares where tipo = 'C' and codigo = "&tplic(1,comarca)&" order by descricao"
					set rst = db.execute(sql)
					if not rst.eof then
						response.write rst("descricao")
					end if
				end if%>
			</td>
		</tr>
		<tr>
		<%if request("imprimir") = "" then%>
			<td align="left" nowrap><%=label_campo1%>:</td>
			<td><input type=text class="cfrm" name="fcmp_livre_1_c" value="<%=cmp_livre_1%>" size="30" maxlength="30" style="width:225px"></td>
			<td nowrap><%=label_campo3%>:</td>
			<td>
				<select class="cfrm" name="fcmp_livre_3_c" style="width:320px">
					<option value=""></option>
					<%
					sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = '3' order by descricao"
					set rst = db.execute(sql)
					do while not rst.eof
						%>
						<option value="<%=rst("codigo")%>" title="<%=rst("descricao")%>" <%if rst("codigo") = int(cmp_livre_3) then%>selected<%end if%>><%=rst("descricao")%></option>
						<%
						rst.movenext
					loop
					%>
				</select>
			</td>
		<%else%>
			<td nowrap><%=label_campo1%>:</td><td><%=cmp_livre_1%></td>
			<td nowrap><%=label_campo3%>:</td>
			<td>
				<%
				if trim(cmp_livre_3) = "" or isnull(cmp_livre_3) then
					cmp_livre_3 = 0
				end if
				sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = '3' and codigo = "&tplic(1, cmp_livre_3)&" order by descricao"
				set rst = db.execute(sql)
				if not rst.eof then
					response.write rst("descricao")
				end if
				%>
			</td>
		<%end if%>
	</tr>
	<tr>
		<%if request("imprimir") = "" then%>
		<td align="left"><%=label_campo2%>:</td>
		<td><input type=text class="cfrm" name="fcmp_livre_2_c" value="<%=cmp_livre_2%>" size="30" maxlength="30" style="width:225px"></td>
		<td><%=label_campo4%>:</td>
		<td>
			<select class="cfrm" name="fcmp_livre_4_c" style="width:320px">
				<option value=""></option>
				<%
				sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = '4' order by descricao"
				set rst = db.execute(sql)
				do while not rst.eof
					%>
					<option value="<%=rst("codigo")%>" title="<%=rst("descricao")%>" <%if rst("codigo") = int(cmp_livre_4) then%>selected<%end if%>><%=rst("descricao")%></option>
					<%
					rst.movenext
				loop
				%>
			</select>
		</td>
		<%else%>
		<td><%=label_campo2%>:</td><td><%=cmp_livre_2%></td>
		<td><%=label_campo4%>:</td>
		<td>
		<%
			if trim(cmp_livre_4) = "" or isnull(cmp_livre_4) then
				cmp_livre_4 = 0
			end if
			sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = '4' and codigo = "&tplic(1, cmp_livre_4)&" order by descricao"
			set rst = db.execute(sql)
			if not rst.eof then
				response.write rst("descricao")
			end if
		end if%>
		</td>
	</tr>
    <table width=100% cellpadding=0 cellspacing=0 class=preto11>
		<tr><td height="20"></td></tr>
	</table>
	
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;Conex„o&nbsp;Tribunais&nbsp;</td>
		<td height="16" width="100%">
		<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle">
		<img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
		
	<%'-- =========================================================================
		'-- Author: Marcos Muller   -  OS : 4159		'-- Create date: 24-10-2012
		'-- Description: inclus„o de campos para conex„o com tribunais
		'-- =========================================================================%>
		
		<%	set rs = conn_usu.execute("select ddd, telefone, contato, empresa, email from usuario where nomeusu = '"&session("vinculado")&"'")
			if not rs.eof then
				session("telefone")		=	"(" & rs("ddd") &") " & rs("telefone")
				session("contato")		=	rs("contato")	
				session("empresa")		=	rs("empresa")	
				session("email")		=	rs("email")
			end if
			
			'------------------------------------------------------------------------------------
			' par‚metros da conex„o aos tribunais - Marcos Muller 22/12/2012
			'------------------------------------------------------------------------------------
			sqlR = "SELECT fl_Habilita_Conexao_coml,fl_Habilita_Conexao_Processo,id_periodicidade,ds_EnviaEmail,nr_consultas_permitidas,fl_Avisa_Resp_Conexao_limite,fl_des_Conexao_status_proc" &_
					",dataativacao,nrolimiteconsultas_coml,nroconsultas_teste_feitas FROM tbConexaoTribunais_Parametros WHERE usuario = '"&session("vinculado")&"'"

			set rsR = db.execute(sqlR)
			habilitadocli = 0
			periodicidadecli  = 0
			desconexaostatus = 0
			AvisaLimite = 0
			nroconscom = 0
			if not rsR.eof then
				habilitadoComl 	= rsR("fl_Habilita_Conexao_coml")
				habilitadocli   = rsR("fl_Habilita_Conexao_Processo")
				
				if trim(habilitadocli) = "" or isnull(habilitadocli) or trim(habilitadocli) = " " then
					habilitadocli= 0
				end if				
				
				if habilitadoComl <> "L"  then
					periodicidadecli  		= 0
				else
					periodicidadecli  		= rsR("id_periodicidade")
				end if

				EnviaEmail	    	= rsR("ds_EnviaEmail")
				AvisaLimite    	 	= rsR("fl_Avisa_Resp_Conexao_limite")
				desconexaostatus 	= rsR("fl_des_Conexao_status_proc")
				nrolimiteconsultas 	= rsR("nr_consultas_permitidas")
				nroconscom			= rsR("nrolimiteconsultas_coml")
				itotal 				= rsR("nroconsultas_teste_feitas")

				if trim(itotal) = "" or isnull(itotal) or trim(itotal) = " " then
					itotal = 0
				end if
	
			end if						

			if desconexaostatus = 1 then
				if situacao = "E" or situacao = "I"  then
					habilitatrib = 0
					habilitadocli = 0
				end if
			end if	

			if request("cadproc") = "inclusao" then
				if habilitadocli = 1 then
					habilitatrib = 1
				end if
			end if

			session("nrolimiteconsultas")=nrolimiteconsultas  
			session("itotal")=itotal 
			session("data") = now()
			session("nroconscom")=nroconscom 
	
			'----------------------------------------------------------------------------------------
			
			'response.write habilitatrib & "-" & habilitadocli &"="& habilitadoComl 
			'response.end
			%>

						
		<table width="100%" class="preto11" <%if request("imprimir") = "" then%>bgcolor="#efefef"<%end if%> border="0" cellspacing="2" cellpadding="3">		
			<tr>
				<td width="100px" align="left" height="27">Status Conex„o:</td>
				<td width="227px" align="left" height="27">
						<%if request("imprimir") = "" then%>
							<input type="radio" onclick="muda_habilita();" <% if habilitadocli = 0 then%> disabled <%end if%>name="fhabilitatrib_n" value=1
							<% if habilitatrib <> 0  then
								%>checked<%
								end if 	%>> 
							Habilitado
							<input type="radio" onclick="muda_desabilita();" <% if  habilitadocli = 0  then%> disabled <%end if%> name="fhabilitatrib_n" value=0<% 
							If habilitatrib = 0  then 
								%> checked<% 
							end if 
							%>> Desabilitado
						<%else%>
							<% if habilitatrib <> 0  then%>
								Habilitado						
							<%elseif habilitatrib = 0  then %> 
								Desabilitado
							<%end if%>
						<%end if%>
				</td> 
				<td align="left" height="27">Periodicidade:&nbsp;
					<%	diario = 0
						semanal = 0
						quinzenal = 0
						mensal = 0
						if trim(periodicidade) = "" then
							periodicidadecli = periodicidadecli 
						else
							periodicidadecli = periodicidade 
						end if
						 
					if request("imprimir") = "" then%>
						<select class="cfrm" name="fperiodicidade_c" <% if habilitatrib = 0  or habilitadocli = 0 or session("nroconscom") > 0 then%>disabled <%end if %> style="width:155px" size="1">
							<% if habilitatrib = 0 or habilitadocli = 0 or habilitadoComl = "T" or session("nroconscom") > 0 then%>
								<option value="0" <% if periodicidadecli = 0 then%>	selected<%end if%>>
								N„o Possui</option>
							<%end if%>
							<%if habilitadoComl = "L" and (session("nroconscom") <= 0 or session("nroconscom") = "") then%> 
								<option value="1" <% if periodicidadecli = 1 then%>	selected<%end if%>>
								Di·ria</option>
								<option value="2" <%if periodicidadecli = 2 or (periodicidadecli = "" or isnull(periodicidadecli)) then%>selected<%end if%>>
								Semanal</option>
								<option value="3" <%if periodicidadecli = 3  then%>selected<%end if%>>
								Quinzenal</option>
								<option value="4" <%if periodicidadecli = 4 then%>selected<%end if%>>
								Mensal</option>
							<%end if%>
						</select>
					<%else%>
					<%
							if trim(periodicidade) <> "" or not isnull(periodicidade) then
								select case periodicidade
									case "0" response.write "<span class=""preto11"">N„o Possui</span>"
									case "1" response.write "<span class=""preto11"">Di·ria</span>"
									case "2" response.write "<span class=""preto11"">Semanal</span>"
									case "3" response.write "<span class=""preto11"">Quinzenal</span>"
									case "4" response.write "<span class=""preto11"">Mensal</span>"
								end select
							end if
					%>
					<%end if%>
				</td>
			</tr>
		</table>
	</table>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="preto11">
	<tr bgcolor="#ffffff"><td colspan="2">
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;Riscos&nbsp;&nbsp;</td>
		<td height="16" width="100%">
		<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle">
		<img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
	</td></tr>

	<tr><td colspan="2">
		<table width="100%" class="preto11" <%if request("imprimir") = "" then%>bgcolor="#efefef"<%end if%> border="0" cellspacing="2" cellpadding="3">		
	<tr>
		<td width="16%">Valor da Causa:</td>
		<td width="22%">
<%
	if request("imprimir") = "" then
%>
			<input size="19" maxlength="20" type="text" id="fvalor_causa_n" name="fvalor_causa_n" style="width:150px;border-right:1px solid #A5ACB2;border-left:1px solid #A5ACB2;border-top:1px solid #A5ACB2;border-bottom:1px solid #A5ACB2;text-align:right" value="<%= valor_causa %>" class="cfrm mascaraValor" onKeyUp="valor(this);">
		</td>
<%
	else
%>
		<%=valor_causa%>
<%
	end if
%>
		<td width="18%">Valor Prov·vel:</td>
		<td width="44%">
<%
	if request("imprimir") = "" then
%>
			<input size="19" maxlength="20" style="width:150px;" type="text" name="fvalor_provavel_n" style="border-right:1px solid #A5ACB2;border-left:1px solid #A5ACB2;border-top:1px solid #A5ACB2;border-bottom:1px solid #A5ACB2;text-align:right" value="<%= valor_provavel %>" class="cfrm mascaraValor" onKeyUp="valor(this);">
		</td>
<%
	else
%>
		<%=valor_provavel%>
<%
	end if
%>
	</tr>
	<tr>
		<td>Resultado Previsto:</td>
		<td><%if request("imprimir") = "" then%>
		<select class="cfrm" name=fresultado_previsto_c style="width:150px" style="border-right:1px solid #A5ACB2;border-left:1px solid #A5ACB2;border-top:1px solid #A5ACB2;border-bottom:1px solid #A5ACB2">
			<option value=""></option>
			<option value="P" <%if resultado_previsto = "P" then%>selected<%end if%>>Perdida</option>
			<option value="R" <%if resultado_previsto = "R" then%>selected<%end if%>>Remota</option>
			<option value="S" <%if resultado_previsto = "S" then%>selected<%end if%>>PossÌvel</option>
			<option value="V" <%if resultado_previsto = "V" then%>selected<%end if%>>Prov·vel</option>
			<option value="G" <%if resultado_previsto = "G" then%>selected<%end if%>>Ganha</option>
		</select>
		<%else%>
			<%
			if trim(resultado_previsto) <> "" or not isnull(resultado_previsto) then
				select case resultado_previsto
					case "P" response.write "<span class=""preto11"">Perdida</span>"
					case "R" response.write "<span class=""preto11"">Remota</span>"
					case "S" response.write "<span class=""preto11"">PossÌvel</span>"
					case "V" response.write "<span class=""preto11"">Prov·vel</span>"
					case "G" response.write "<span class=""preto11"">Ganha</span>"
				end select
			end if
			%>
		<%end if%>
		</td>
		<td width="130">Valor Final:</td>
		<td width="80">
<%
	if request("imprimir") = "" then
%>
		<input size="19" maxlength="15" style="width:150px;" type="text" name="fvalor_final_n" style="border-right:1px solid #A5ACB2;border-left:1px solid #A5ACB2;border-top:1px solid #A5ACB2;border-bottom:1px solid #A5ACB2;text-align:right" value="<%=valor_final%>" class="cfrm mascaraValor" onKeyUp="valor(this);"></td>
<%
	else
%>
		<%=valor_final%>
<%
	end if
%>
	</tr>
	</table>
	</td></tr>
	</table>
<%'-----------------------------------------------------------------------------------------------------------%>	
	
<%if request("cadproc") = "" then%>	

<%'-----------------------------------------------------------------------------------------------------------%>
	
	<%sql = "SELECT contencioso.dbo.TabCliCont.principal, APOL.dbo.Tipo_Envolvido.id_tipo_env,contencioso.dbo.TabCliCont.codigo,APOL.dbo.Envolvidos.apelido, APOL.dbo.Envolvidos.pasta, APOL.dbo.Envolvidos.id, "&_
	" APOL.dbo.Tipo_Envolvido.nome_tipo_env FROM contencioso.dbo.TabCliCont LEFT OUTER JOIN APOL.dbo.Envolvidos ON "&_
	" APOL.dbo.Envolvidos.id = contencioso.dbo.TabCliCont.envolvido LEFT OUTER JOIN APOL.dbo.Tipo_Envolvido ON "&_
	" APOL.dbo.Tipo_Envolvido.id_tipo_env = contencioso.dbo.TabCliCont.tipo_env WHERE (contencioso.dbo.TabCliCont.usuario = '"&Session("vinculado")&"') "&_
	" AND contencioso.dbo.TabCliCont.processo = '"&tplic(0,vid_processo)&"' ORDER BY APOL.dbo.Tipo_Envolvido.nome_tipo_env, APOL.dbo.Envolvidos.apelido"
	set rstp = db.execute(sql)
	
	if (Request("imprimir") = "") or  (not rstp.eof AND Request("imprimir") = "S") then
	libera = "sim"

	%>
	<table width=100% cellpadding=0 cellspacing=0 class=preto11>
		<tr><td height=20></td></tr>
	</table>
	<a name=vinc class="preto11"></a>
	<div id="div_envolvido" style="visibility:hidden"></div>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
		<tr>		
			<td height="16px" valign="middle" width=23px>&nbsp;<img src="imagem/tit_le.gif" width="19" height="18"></td>
			<td height="16px" valign="middle" align=center class="titulo">&nbsp;Envolvidos&nbsp;</td>
			<td height="16px" width="100%">
			<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
			<td height="16px" valign="middle" width=20px>
			<img src="imagem/tit_fim.gif" width="21" height="16"></td>											
			<td><% If Request("imprimir") = "" then %><% if (Session("cont_manut_proc")) or (Session("adm_adm_sys")) then %><a href="javascript: abrirjanela('../cliente.asp?id_proc=<%=vid_processo%>&modulo=C&processo=<%=processo%>',400,300)" class="preto11<%=l_imp%>"><img src="imagem/add-proc.gif" alt="Cadastrar Envolvidos" align="absmiddle" width="15" height="20" border="0"></a><% End If %><%end if%></td>
		</tr>
	</table>
	<table width="100%" class="preto11" <%if request("imprimir") = "" then%>bgcolor="#efefef"<%end if%> border="0" cellspacing="2" cellpadding="3">					
	<%if vid_processo <> "" then%>

		<tr class="tit1<%=l_imp%>">
			<td align="left" width=4%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td width="24%"><b>Tipo</b></td>
			<td width="38%"><b>Apelido</b></td>
			<td width="25%"><b>Pasta</b></td>
			<%if libera = "sim" AND Request("imprimir") = "" then%><td width="10%"><b>&nbsp;</b></td><%End If%>
		</tr>

		<%if libera = "sim" AND Request("imprimir") = "" then%>	
		<tr><td colspan="5">
		<iframe src="proc_envolvidos.asp?id_processo=<%=vid_processo%>" name="frame_envolvidos" id="frame_envolvidos" width="766" height="80" align="left" frameborder="0" leftmargin="0"></iframe>
		</td></tr>
		<%else%>
		<tr>			
			<%do while not rstp.eof%>
			<td width=3% align="center">&nbsp;</td>
			<td class="preto11" width=25%><%=rstp("nome_tipo_env")%><%If rstp("principal") = true Then%>&nbsp;<img src="../imagem/principal.gif" alt="Principal" width="12" height="11" border="0"><%End If%></td>
			<td class="preto11" width=37%><%= rstp("apelido") %></td>
			<td class="preto11" width=25%><%= rstp("pasta") %></td>
		</tr>
				<%
				rstp.movenext
			loop
			%>

			<tr>
				<td align="left" colspan=3 width=20%>
				</td>
			</tr>
			<%end if%>
		
	<%end if%>
	</table>
<%end if%>

<%'-----------------------------------------------------------------------------------------------------------%>
	
	<%
	if request("env_email") = "S" then
		session("codigo_vinculado") = request("codigo_vinculado")
	end if
	sql = "SELECT id, tipo, data_intimacao, tipo_multa, valor_multa, estado_liminar FROM Liminares WHERE id_processo = "&tplic(0, vid_processo)& " and id_usuario = '" & session("codigo_vinculado") & "' order by data_intimacao desc, [id] desc"
	set rs_liminar = db.execute(sql)

	if (Request("imprimir") = "") or (not rs_liminar.eof AND Request("imprimir") = "S") then
		libera = "sim"%>
		<table width=100% cellpadding=0 cellspacing=0 class=preto11>
			<tr><td height=20></td></tr>
		</table>	
		<a name="liminar"></a>
		<div id="div_liminar" style="visibility:hidden"></div>
		<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
		<tr>		
			<td height="16" valign="middle" width=23px>&nbsp;<img src="imagem/tit_le.gif" width="19" height="18"></td>
			<td height="16" valign="middle" align=center class="titulo">&nbsp;Liminares&nbsp;</td>
			<td height="16" width="100%">
			<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
			<td height="16" valign="middle" width=20px>
			<img src="imagem/tit_fim.gif" width="21" height="16" /></td>
			<td><% If Request("imprimir") = "" then %><a href="javascript: abrirjanela('cad_liminar.asp?id_processo=<%=id_processo%>&num_proc=<%=processo%>', 470, 230)" class="linkp11"><img src="imagem/add-proc.gif" alt="Cadastrar Liminar" align="absmiddle" width="15" height="20" border="0"></a><%end if%></td>
		</tr>
		</table>
		<table width="100%" class="preto11" <%if request("imprimir") = "" then%>bgcolor="#efefef"<%end if%> border="0" cellspacing="2" cellpadding="3">				
		<%if vid_processo <> "" then %>
			<tr class="tit1<%=l_imp%>">
				<%if Request("imprimir") = "" then%><td align="left" width="4%">&nbsp;</td><%End If%>
				<td align="left" width="20%"><strong>Tipo</strong></td>
				<td align="center" width="15%"><strong>Data IntimaÁ„o</strong></td>
				<td align="left" width="20%"><strong>Tipo Multa</strong></td>
				<td align="center" width="15%"><strong>Valor Multa</strong></td>
				<td align="left" width="20%"><strong>Estado Liminar</strong></td>
			</tr>		
			<%if libera = "sim" and Request("imprimir") = "" then%>	
			<tr><td colspan="6">
			<iframe src="proc_liminares.asp?id_processo=<%=vid_processo%>&num_proc=<%=processo%>" name="frame_liminares" id="frame_liminares" width="766" height="80" align="left" frameborder="0" leftmargin="0"></iframe>
			</td></tr>
			<%else%>
					
			<%do while not rs_liminar.eof%>	 			
				<tr>
					<td class="preto11" align="left"><%=rs_liminar("tipo")%></td>
					<td class="preto11" align="center"><%=fdata(rs_liminar("data_intimacao"))%></td>
					<td class="preto11" align="left"><%=rs_liminar("tipo_multa")%></td>
					<td class="preto11" align="right"><% If (rs_liminar("valor_multa") <> "") and (not isnull(rs_liminar("valor_multa"))) then %><%=formatNumber(rs_liminar("valor_multa"),2)%><% End If %></td>
					<td class="preto11" align="left">
					<%
					select case rs_liminar("estado_liminar")
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
				rs_liminar.movenext
			loop
			end if%>
			
		<%else%>
			<tr>
				<td align="center" colspan=4 class=aviso>&nbsp;</td>
			</tr>
		<%end if%>
		</table>
	<%end if%>
<%'-----------------------------------------------------------------------------------------------------------%>	
	
	<%
	sql = "select codigo as [id], (select processo from contencioso.dbo.TabProcCont where id_processo = v.processo1) as processo, processo2 as vinculado, sigla_pais as sigla_pais_processo, 'C' as tipo_origem, tipo, case tipo WHEN 'C' THEN 'JurÌdico' WHEN 'M' THEN 'Marca' WHEN 'MI' THEN 'Marca Inter.' WHEN 'P' THEN 'Patente' WHEN 'PI' THEN 'Patente Inter.' WHEN 'V' THEN 'Contratos' WHEN 'D' THEN 'DomÌnio' END as ordem, case tipo WHEN 'C' THEN (select processo from contencioso.dbo.TabProcCont where id_processo = v.processo2) WHEN 'M' THEN processo2 WHEN 'P' THEN processo2 WHEN 'V' THEN (select codigo from apol_contratos.dbo.contrato where id_contrato = v.processo2) WHEN 'D' THEN (select dominio from apol.dbo.Dominios where [id] = v.processo2) END as ordem_proc, obs from contencioso.dbo.tabvincproc v where usuario = '" &Session("vinculado")& "' and processo1 = '"&tplic(0,vid_processo)&"' union "
	sql = sql & "select [id], vinculado, processo, sigla_pais, 'M' as tipo_origem, 'M' as tipo, 'Marca' as ordem, processo as ordem_proc, obs from apol.dbo.vinculado v  where usuario = '"&session("vinculado")&"' and vinculado = '"&tplic(0,vid_processo)&"' union "
	sql = sql & "select [id], naturezav+vinculado, naturezap+processo, sigla_pais, 'P' as tipo_origem, 'P' as tipo, 'Patente' as ordem, naturezap+processo, obs from apol_patentes.dbo.vinculado v where usuario = '"&session("vinculado")&"' and vinculado = '"&tplic(0,vid_processo)&"' union "
	sql = sql & "select codigo as [id], vinculado, processo, sigla_pais_processo, 'PI' as tipo_origem, 'PI' as tipo, 'Patente Inter.' as ordem, processo, obs from apol_patentes.dbo.pi_vinculado v where usuario = '"&session("vinculado")&"' and vinculado = '"&tplic(0,vid_processo)&"' and ISNULL(sigla_pais_vinculado, '') = '" & request("pais") & "' union "
	sql = sql & "select codigo as [id], vinculado, processo, sigla_pais_processo, 'MI' as tipo_origem, 'MI' as tipo, 'Marca Inter.' as ordem, processo, obs from apol.dbo.mi_vinculado v where usuario = '"&session("vinculado")&"' and vinculado = '"&tplic(0,vid_processo)&"' and ISNULL(sigla_pais_vinculado, '') = '" & request("pais") & "' union "
	sql = sql & "select codigo as [id], vinculado, id_dominio, sigla_pais_dominio, 'D' as tipo_origem, 'D' as tipo, 'DomÌnios' as ordem, id_dominio, obs from apol.dbo.dominios_vinculado v  where usuario = '"&session("vinculado")&"' and vinculado = '"&tplic(0,vid_processo)&"' and ISNULL(sigla_pais_vinculado, '') = '" & request("pais") & "' union "
	sql = sql & "select codigo, processo2, processo1, sigla_pais, 'C' as tipo_origem, 'C' as tipo, 'JurÌdico' as ordem, (select processo from contencioso.dbo.TabProcCont where id_processo = v.processo1) as ordem_proc, obs from contencioso.dbo.tabvincproc v where usuario = '"&session("vinculado")&"' and processo2 = '"&tplic(0,vid_processo)&"' union "
	sql = sql & "select id_vinculado, contrato_anexo, contrato_principal, sigla_pais, 'V' as tipo_origem, 'V' as tipo, 'Contratos' as ordem, (select codigo from apol_contratos.dbo.contrato where id_contrato = v.contrato_principal) as ordem_proc, obs from apol_contratos.dbo.vincula_contrato v  where usuario = '"&session("vinculado")&"' and contrato_anexo = '"&tplic(0,vid_processo)&"' "
	sql = sql & "order by ordem, ordem_proc"
	set rs_pro = db.execute(sql)
	
	if (Request("imprimir") = "") or  (not rs_pro.eof AND Request("imprimir") = "S") then
	libera = "sim"
	%>
	<table width=100% cellpadding=0 cellspacing=0 class=preto11>
		<tr><td height=20></td></tr>
	</table>
	<a name=vinc class=preto11></a>
	<div id="div_vinculado" style="visibility:hidden"></div>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
		<tr>
			<td height="16" valign="middle" width=23px>&nbsp;<img src="imagem/tit_le.gif" width="19" height="18"></td>
			<td height="16" valign="middle" class="titulo">&nbsp;Registros&nbsp;Vinculados&nbsp;</td>
			<td height="16" width="100%">
			<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
			<td height="16" valign="middle" width=20px>
			<img src="imagem/tit_fim.gif" width="21" height="16"></td>
			<td><% If Request("imprimir") = "" then %><% if (Session("cont_manut_proc")) or (Session("adm_adm_sys")) then %><a href="javascript: abrirjanela('../vinculados.asp?id_cont=<%=vid_processo%>&modulo=C',600,200)" class="linkp11"><img src="imagem/add-proc.gif" alt="Cadastrar VÌnculo de Processo" align="absmiddle" width="15" height="20" border="0"></a><% End If %><%end if%></td>
		</tr>
	</table>
	<table width="100%" class="preto11" <%if request("imprimir") = "" then%>bgcolor="#efefef"<%end if%> border="0" cellspacing="2" cellpadding="3">
		<%if vid_processo <> "" then%>
			<tr class="tit1<%=l_imp%>">
				<td align="left" width="4%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td align="left" width="16%"><strong>Tipo</strong></td>
				<td align="left" width="27%"><strong>Processo</strong></td>
				<td align="left" width="50%"><strong>ObservaÁ„o</strong></td>
				<td align="left" width="3%"><strong>Apenso?</strong></td>
			</tr>		
		<%if libera = "sim" AND Request("imprimir") = "" then%>	
		<tr><td colspan="5">
		<iframe src="proc_vinculado.asp?id_processo=<%=vid_processo%>" name="frame_vinculado" id="frame_vinculado" width="766" height="80" align="left" frameborder="0" leftmargin="0"></iframe>
		</td></tr>
		<%else
			do while not rs_pro.eof
				rowcount = rowcount+1
				%>				
				<tr>
					<td width=3% align="center">&nbsp;</td>
					<%if rs_pro("tipo") = "V" then
						sql = "SELECT id_contrato, codigo FROM Contrato WHERE id_contrato = '"&rs_pro("vinculado")&"' AND usuario = '"&session("vinculado")&"'"
						set rs_v = conn_v.execute(sql)
						if not rs_v.eof then
						%>
						<td class="preto11" width="10%" align=left>Contratos</td>
						<td class="preto11" width="25%"align=left><%= rs_v("codigo") %></td>
						<% Else %>
						<td class="preto11" width="10%" align=left>Contratos</td>
						<td class="preto11" width="25%"align=left>VinculaÁ„o Incorreta</td>
						<% End If %>
					<%elseif rs_pro("tipo") = "P" then%>
						<td class="preto11" width="10%" align=left>Patente</td>
						<td class="preto11" width="25%"align=left><% If left(rs_pro("vinculado"),2) <> "ND" then %><%= left(rs_pro("vinculado"),2) %>&nbsp;<% End If %><%= mid(rs_pro("vinculado"),3,7) %><% If left(rs_pro("vinculado"),2) <> "ND" then %>-<%= geradigito(mid(rs_pro("vinculado"),3,7)) %><% End If %></td>
					<%elseif rs_pro("tipo") = "PI" then
						sql = "SELECT codigo FROM apol_patentes.dbo.pi_processos WHERE natureza+numero_processo = '"&rs_pro("vinculado")&"' AND usuario = '"&session("vinculado")&"' and codigo_pais_deposito = '" & rs_pro("sigla_pais_processo") &"'"
						set rs_p = conn.execute(sql)
						if not rs_p.eof then
					%>
						<td class="preto11" width="12%" align=left><%=rs_pro("ordem")%></td>
						<td class="preto11" width="29%"align=left><%= left(rs_pro("vinculado"),2) %>&nbsp;<%= mid(rs_pro("vinculado"),3,len(rs_pro("vinculado"))) %></td>
						<% Else %>
						<td class="preto11" width="12%" align=left>Patente Inter.</td>
						<td class="preto11" width="29%"align=left>VinculaÁ„o Incorreta</td>
						<% End If %>
					<%elseif rs_pro("tipo") = "M" or rs_pro("tipo") = "" then%>
						<td class="preto11" width="10%" align=left>Marca</td>
						<td class="preto11" width="25%"align=left><%= rs_pro("vinculado") %></td>
					<%elseif rs_pro("tipo") = "MI" then
						sql = "SELECT codigo FROM mi_processos WHERE numero_processo = '"&rs_pro("vinculado")&"' AND usuario = '"&session("vinculado")&"' and codigo_pais_deposito = '" & rs_pro("sigla_pais_processo") &"'"
						set rs_m = conn.execute(sql)
						if not rs_m.eof then
					%>
						<td class="preto11" width="12%" align=left><%=rs_pro("ordem")%></td>
						<td class="preto11" width="29%"align=left><%= rs_pro("vinculado") %></td>
						<% Else %>
						<td class="preto11" width="12%" align=left>Marca Inter.</td>
						<td class="preto11" width="29%"align=left>VinculaÁ„o Incorreta</td>
						<% End If %>
					<%elseif rs_pro("tipo") = "D" then
						sql = "SELECT dominio FROM Dominios WHERE id = "&rs_pro("vinculado")&" AND usuario = '"&session("vinculado")&"'"
						set rs_m = conn.execute(sql)
						if not rs_m.eof then%>
						<td class="preto11" width="17%" align=left><%=rs_pro("ordem")%></td>
						<td class="preto11" width="26%"align=left><%= rs_m("dominio") %></td>
						<% Else %>
						<td class="preto11" width="17%" align=left>Dom&iacute;nio</td>
						<td class="preto11" width="26%"align=left>VinculaÁ„o Incorreta</td>
						<% End If %>
					<%elseif rs_pro("tipo") = "C" then%>
						<%sql = "SELECT id_processo,processo FROM TabProcCont WHERE id_processo = '"&rs_pro("vinculado")&"' AND usuario = '"&session("vinculado")&"'"
						set rs_v = db.execute(sql)
						if not rs_v.eof then
						%>
						<td class="preto11" width="10%" align=left>JurÌdico</td>
						<td class="preto11" width="25%"align=left><%= rs_v("processo") %></td>
						<% Else %>
						<td class="preto11" width="10%" align=left>JurÌdico</td>
						<td class="preto11" width="25%"align=left>VinculaÁ„o Incorreta</td>
						<% End If %>
					<%end if%>
					<td class="preto11" align="left" width=50%><%=rs_pro("obs")%></td>
					<td align="right" width=1%>
					<%
					if rs_pro("tipo") = "C" then
						set rstp = db.execute("select apenso from tabvincproc where codigo = '"&tplic(0,rs_pro("id"))&"' and processo1 = '"&tplic(0,vid_processo)&"'")
						if not rstp.eof then
							apenso_sql = trim(rstp("apenso"))
						else
							apenso_sql = "N"
						end if
					end if%>
					
					<%if apenso_sql <> "" then%>
						<%= replace(replace(apenso_sql,"S","Sim"),"N","N„o") %>
					<% Else %>
						<% response.write "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" %>
					<% End If %>
					</td>
				</tr>
				<%
				apenso_sql = ""
				rs_pro.movenext
			loop
			%>	
			<tr>
				<td align="left" colspan=3 width=20%>					
				</td>
			</tr>
			<%end if%>
	<%end if%>
	</table>	
<%end if

'-----------------------------------------------------------------------------------------------------------
	If Request("env_email") <> "S" or Request("anda") = "1" then 
	
	'Exibir todos os andamentos na vers„o pra impress„o
	AndamOcultos = ""
	if request("imprimir") = "" then
		AndamOcultos = "and ocultar = 0 "
	end if

	sql = "SELECT  id, data, descricao_andamento, protocolo, "&_
		" descricao as nome, descricao_outro_idioma, detalhe_outro_idioma, id_processo FROM Contencioso..tb_andamentos WHERE (id_processo = '"&tplic(1,vid_processo)& "')" &_
		" " & AndamOcultos & " order by data desc, id DESC "

	set rs_pro = server.CreateObject("ADODB.recordset")
	rs_pro.Open sql, conn, 3, 3
	if (Request("imprimir") = "") or  (not rs_pro.eof AND Request("imprimir") = "S") or Request("anda") = "1" then%>
	<script>
	    function anima_sync() {
	        escrevelyr('bt_sync', vbtsa);
	        frame_ocorrenciaT.location = "captura_tribunais_online.asp?processo1=<%=processo%>&id_tribunal=<%=tribunal_sync%>";
	    }

	    function para_anima_sync() {
	        escrevelyr('bt_sync', vbts);
	    }
	    var vbts = '<% If Request("imprimir") = "" then %><% if (Session("cont_manut_proc")) or (Session("adm_adm_sys")) then %><a href="javascript:anima_sync()"><img src="imagem/sync.gif" alt="SincronizaÁ„o com Tribunal" width="16" height="16" hspace="3" border="0" align="absmiddle"></a><% End If %><% End If %>';
	    var vbtsa = '<% If Request("imprimir") = "" then %><% if (Session("cont_manut_proc")) or (Session("adm_adm_sys")) then %><img src="imagem/sync_animado.gif" width="16" height="16" hspace="3" border="0"><% End If %><% End If %>';
	</script>
	<a name="desp"></a>
    <div id="div_andamento" style="visibility:hidden"></div>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
		<tr>		
			<td height="16" valign="middle" width=23px>&nbsp;<img src="imagem/tit_le.gif" width="19" height="18"></td>
				<td nowrap height="16" valign="middle" align=center class="titulo">&nbsp;<%=andamentos_C%>&nbsp;</td>

			<td height="16" width="100%">
			<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
			<td height="16" valign="middle" width=20px>
			<img src="imagem/tit_fim.gif" width="21" height="16"></td>

			<%if habilitatrib <> 0 and habilitadocli <> 0 then 
				If (tribunal_sync <> "") and (not isnull(tribunal_sync)) then%>
					<td>
					    <div id="bt_sync">
					        <script>
						       document.write(vbts);
							</script>
						</div>
					</td>
				<%end if
			end if%>
		</tr>
	</table>
	<table width="100%" class="preto11" <%if request("imprimir") = "" then%>bgcolor="#efefef"<%end if%> border="0" cellspacing="2" cellpadding="3">
	<%
		sql2 = "SELECT data, texto, fl_aguarda_robo_baixar_andamento, qtd_andamentos_baixados FROM tbConexaoTribunais_Andamentos CTA WHERE CTA.processo = '" & tplic(1,processo)& "' AND usuario = '"&session("vinculado")&"'"& " ORDER BY data DESC"
		'response.write sql2
		'response.end
		set rsanda = server.CreateObject("ADODB.recordset")
		rsanda.Open sql2, db, 3, 3
		texto  = ""
		if not rsanda.eof then
			dataanda = rsanda("data")
			texto  = rsanda("texto")
		end if
	%>
	<tr class="tit1<%=l_imp%>">
	<td align="left" colspan="6"><div id="dt_atu_trib" class="tit1<%=l_imp%>">
<%
	If (rsanda.eof) then
%>
		<b>
<%
		if Request("imprimir") = "" then
%>
		<font color="#FFFF00">
<%
		end if
%>
		Nenhuma sincronizaÁ„o foi feita com o tribunal.
<%
		if Request("imprimir") = "" then
%>
		</font>
<%
		end if
%></b>
<%
	Else
%>
<%
		if rsanda("fl_aguarda_robo_baixar_andamento") = 0 then
%>
			<b>
<%
			if Request("imprimir") = "" then
%>
			<font color="#FFFF00">
<%
			end if
%>
			⁄ltima sincronizaÁ„o 
<%
			if instr(texto ,"ERRO") > 0 then 
%>
			[Com erro]: <%= dataanda %> - <%= texto %>
<%
			Else
%>
			[Com sucesso]: <%= dataanda %> - 
<%
			if rsanda("qtd_andamentos_baixados") > 0 then
%> 
			Total de <%=rsanda("qtd_andamentos_baixados")%> andamento(s) encontrado(s).
<%
			else
%>
			Andamento n„o encontrado.
<%
			end if
%>
<%
			End If
%>
<%
			if Request("imprimir") = "" then
%>
			</font>
<%
			end if
%>
			</b>
<%
			else
%>
			<b>
<%
			if Request("imprimir") = "" then
%>
			<font color="#FFFF00">
<%
			end if
%>
			<%=texto%>: <%=dataanda%>
<%
			if Request("imprimir") = "" then
%>
			</font>
<%
			end if
%></b>
<%
		end if
%>
<%
	End If
%>
	</div></td>
	</tr>
	<%	if vid_processo <> "" then	%>
		<tr class="tit1<%=l_imp%>">
<%
	if libera = "sim" AND Request("imprimir") = "" then
%>
			<td align="left" width="4%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
<%
	End If
%>
			<td align="left" width="2%">&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td align="center" width="11%"><strong>Data</strong></td>
			<td align="left" width="18%"><strong>DescriÁ„o</strong></td>
			<td align="left" width="58%"><strong>Detalhe</strong></td>
<%
	If Request("imprimir") = "" then
%>
			<td align="left" width="8%"><strong>Link</strong></td>
<%
	end if
%>
		</tr>
		<%if libera = "sim"  AND Request("imprimir") = "" then %>	
			<tr><td colspan="5">
			<iframe src="proc_andamento.asp?id_processo=<%=vid_processo%>&processo=<%=processo%>&tipo_ocorr=T&mostrartudo=0&textoanda=<%=andamentos_C%>" name="frame_ocorrenciaT" id="frame_ocorrenciaT" width="766" height="300" align="left" frameborder="0" leftmargin="0" scrolling="no"></iframe>			</td></tr>
		
			<div class="preto11" id="full_andamento" style="position: absolute; width: 350px; height: 50px; left: 340px; display: none; border:0px solid #000000;">
				<div style="background:#ffffff; border:3px solid #345C46;" >
					<div class="tit1<%=l_imp%>; background:#345C46;">
						<div style="position: absolute;"><strong>Detalhe</strong></div><div style="text-align:right;"><a href="javascript:top.esconde_andamento();"><img title="Fechar" border="0" src="../img_comp/fechar.gif"></a></div>
					</div>
					<div id="full_andamento_detalhe" style="text-align: justify; padding-left:10px; padding-right:10px;"></div>
				</div>
			</div>
	
			<div id="novos_objetos_tribunal"></div>
		<%else%>
			
		<%do while not rs_pro.eof%>	 			
			<tr>
			<td class="preto11" width="3%" align="center" valign="top"></td>
			<td width="8%" align=center valign="top"><%= rs_pro("data") %></b></td>
			<td align="left" width="20%" valign="top"><%= rs_pro("nome") %></td>
			<td width="60%" valign="top"><% If Request("imprimir") = "" then %><a href="javascript:abrirjanela('../edit_ocorrencia.asp?id=<%= rs_pro("id") %>&modulo=C&vid=<%=vid_processo%>&id_proc=<%=vid_processo%>',560,180)" class="preto11<%=l_imp%>"><%end if%><%=rs_pro("descricao_andamento")%></a></td>
			</tr>
			<%
			rs_pro.movenext
		loop		
		end if			
		
		else%>
		<tr>
			<td align="center" colspan=5 class=aviso>&nbsp;</td>
		</tr>
	</table>
	<%end if
	end if
		end if
	 If Request("env_email") <> "S" or Request("ocor") = "1" then %>
		<%sql = "SELECT ocorrencias.id, ocorrencias.data, ocorrencias.ocorrencia, ocorrencias.tipo, ocorrencias.tipo_ocorrencia, ocorrencias.protocolo, "&_
	" ocorrencias.descricao as nome, ocorrencias.descricao_outro_idioma, ocorrencias.detalhe_outro_idioma FROM ocorrencias LEFT OUTER JOIN Tipo_Ocorrencia ON ocorrencias.tipo_ocorrencia = Tipo_Ocorrencia.id_tipo_ocorrencia WHERE (ocorrencias.processo = '"&tplic(0,processo)& "') AND (ocorrencias.usuario = '"&Session("vinculado")&"') and ocorrencias.tipo in ('C') order by ocorrencias.data desc, ocorrencias.id DESC"
	set rs_pro = server.CreateObject("ADODB.recordset")
	rs_pro.Open sql, conn, 3, 3


	if (Request("imprimir") = "") or  (not rs_pro.eof AND Request("imprimir") = "S") or Request("ocor") = "1" then%>
	<table width=100% cellpadding=0 cellspacing=0 class=preto11>
		<tr><td height=20></td></tr>
	</table>
	<a name="hist"></a>
	<div id="div_ocorrencia" style="visibility:hidden"></div>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
		<tr>		
			<td height="16" valign="middle" width=23px>&nbsp;<img src="imagem/tit_le.gif" width="19" height="18"></td>
			<td height="16" valign="middle" align=center class="titulo">&nbsp;<%= ocorrencia_C %>&nbsp;</td>
			<td height="16" width="100%">
			<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
			<td height="16" valign="middle" width=20px>
			<img src="imagem/tit_fim.gif" width="21" height="16"></td>
			<td><% If Request("imprimir") = "" then %><% if (Session("cont_manut_prov") and Session("cont_cons_prov")) or (Session("adm_adm_sys")) then %><a href="javascript: abrirjanela2('../cad_ocorrencia.asp?modulo=C&id=<%=vid_processo%>&id_proc=<%= processo %>',560,300)" class="linkp11"><img src="imagem/add-proc.gif" alt="Cadastrar <%= ocorrencia_C %>" align="absmiddle" width="15" height="20" border="0"></a><%end if%><%end if%></td>
		</tr>
	</table>
	<table width="100%" class="preto11" <%if request("imprimir") = "" then%>bgcolor="#efefef"<%end if%> border="0" cellspacing="2" cellpadding="3">
	<%	if vid_processo <> "" then	%>
		<tr class="tit1<%=l_imp%>">
			<%if libera = "sim" AND Request("imprimir") = "" then%><td align="left" width=4%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><%End If%>
			<td align="center" width="3%">&nbsp;</td>	
			<td align="center" width="15%"><strong>Data</strong></td>
			<td align="left" width="20%"><strong>DescriÁ„o</strong></td>
			<td align="left" width="20%"><strong>Protocolo</strong></td>
			<td align="left" width="55%"><strong>Detalhe</strong></td> 
		</tr>
		<%if libera = "sim"  AND Request("imprimir") = "" then%>	
			<tr><td colspan="6">
			<iframe src="proc_ocorrencia.asp?id_processo=<%=vid_processo%>&processo=<%=processo%>&tipo_ocorr=C" name="frame_ocorrencia" id="frame_ocorrencia" width="766" height="300" align="left" frameborder="0" leftmargin="0"></iframe>
			</td></tr>
			<%			
			id_ocorr = ""
			do while not rs_pro.eof
				id_ocorr = id_ocorr & rs_pro("id") & ","
			%>
			<div class="preto11" id="full_ocorrencia<%=rs_pro("id")%>" style="position: absolute; width: 350px; height: 50px; left: 100px; display: none; border:0px solid #000000;">
				<div style="background:#ffffff; border:3px solid #345C46;" >
					<div class="tit1<%=l_imp%>"; background:#345C46;">
						<div style="position: absolute;"><strong>Detalhe</strong></div><div style="text-align:right;"><a href="javascript:esconde_ocorrencia('<%= rs_pro("id") %>')"><img title="Fechar" border="0" src="../img_comp/fechar.gif"></a></div>
					</div>
					<div style="text-align: justify; padding-left:10px; padding-right:10px;"><%=rs_pro("ocorrencia")%></div>
				</div>
			</div>
			<%
				rs_pro.movenext
			loop%>
			<div id="novos_objetos"></div>
		<%else
			
		do while not rs_pro.eof%>	 			
			<tr>
			<td class="preto11" width="3%" align="center" valign="top">
			<%
			if not isnull(rs_pro("descricao_outro_idioma")) and _
				not trim(rs_pro("descricao_outro_idioma")) = "" or _
				not isnull(rs_pro("detalhe_outro_idioma")) and _
				not trim(rs_pro("detalhe_outro_idioma")) = "" then
				%><img src="../imagem/icon_idioma3.png" alt="Possui descriÁ„o em outro idioma" width="16" height="16" border="0"><%
			end if 
			%>
			</td>
			<td width="16%" align=center valign="top"><%= fdata(rs_pro("data")) %></b></td>
			<td align="left" width="20%" valign="top"><%= rs_pro("nome") %></td>
			<td align="left" width="21%" valign="top">&nbsp;<%= rs_pro("protocolo") %></td>
			<td width="55%" valign="top"><% If Request("imprimir") = "" then %><a href="javascript:abrirjanela('../edit_ocorrencia.asp?id=<%= rs_pro("id") %>&modulo=C&vid=<%=vid_processo%>&id_proc=<%=processo%>',560,180)" class="preto11<%=l_imp%>"><%end if%><%=rs_pro("ocorrencia")%></a></td>
			</tr>
			<%
			rs_pro.movenext
		loop		
		end if			
		
		else%>
		<tr>
			<td align="center" colspan=5 class=aviso>&nbsp;</td>
		</tr>
	<%end if%>
	</table>
<% End If %>
<% End If %>
<%'-----------------------------------------------------------------------------------------------------------%>
<% If Request("env_email") <> "S" or Request("provid") = "1" then %>
	<%sql = "SELECT id, prazo_ger, prazo_ofi, desp, rpi, descricao, executada, hora, id_item_checagem FROM Providencias WHERE (processo = '"&tplic(0,processo)& "') and (usuario = '"&session("vinculado")&"' or usuario = '"&session("vinculado")&"##"&session("nomeusu")&"') and tipo = 'C' order by prazo_ofi desc"
	set rs_pro = conn.execute(sql)
	if (Request("imprimir") = "") or (not rs_pro.eof AND Request("imprimir") = "S") then%>
	<a name="prov"></a>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
		<tr>		
			<td height="16px" valign="middle" width="23px">&nbsp;<img src="imagem/tit_le.gif" width="19px" height="18px"></td>
			<td height="16px" valign="middle" class="titulo">&nbsp;ProvidÍncias&nbsp;</td>
			<td height="16px" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18px" border="0"></td>
			<td height="16px" valign="middle"><img src="imagem/tit_fim.gif" width="21px" height="16px"></td>
			<td><% If Request("imprimir") = "" then %>&nbsp;<% if (Session("cont_manut_prov") and Session("cont_cons_prov")) or (Session("adm_adm_sys")) then %><a href="javascript: abrirjanela2('../cria_providencia.asp?cabeca=nao&onde=detproc&id_processo=<%=id_processo%>&id_proc=<%=processo%>&modulo=C&responsavel=<%=responsavel%>',500,500)" class="linkp11"><img src="imagem/add-proc.gif" alt="Cadastrar ProvidÍncias" align="absmiddle" width="15px" height="20px" border="0"></a>&nbsp;<%End If%><%End If%></td>
		</tr>
	</table>
	<div id="div_prov" style="visibility:hidden"></div>
	<table width="100%" class="preto11" <%if request("imprimir") = "" then%>bgcolor="#efefef"<%end if%> border="0" cellspacing="2" cellpadding="3">				
	<%if vid_processo <> "" then 
		%>
		<tr class="tit1<%=l_imp%>">
			<%if libera = "sim" AND Request("imprimir") = "" then%>
			<td align="left" width="4%"></td><%End If%>
			<td align="left" width="4%"></td>					
			<td align="left" width="3%"></td>		
			<td align="center" width="15%" nowrap><strong>Data Gerencial</strong></td>			
			<td align="center" width="15%" nowrap><strong>Data Oficial</strong></td>
			<td align="left" width="64%"><strong>DescriÁ„o</strong></td>
		</tr>		
		<%if libera = "sim" AND Request("imprimir") = "" then%>	
		<tr><td colspan="6">
		<iframe src="proc_providencia.asp?id_processo=<%=vid_processo%>&processo=<%=processo%>" name="frame_providencia" id="frame_providencia" width="100%" height="80px" align="left" frameborder="0" leftmargin="0"></iframe>
		</td></tr>
		<%else%>
				
		<%do while not rs_pro.eof%>	 			
			<tr>
			<td width="4%" align="center"><% If rs_pro("executada") then %><img src="imagem/check.gif" width="15px" height="13px"><% Else %><% End If %></td>
			<td width="3%" align="center"><% If (not isnull(rs_pro("id_item_checagem")) and rs_pro("id_item_checagem") <> "") then %><img src="../imagem/item_chec/9.jpg" width="15" height="13"><% Else %><% End If %></td>
			<td width="15%" align="center"><% If (rs_pro("prazo_ger") = "") OR (isnull(rs_pro("prazo_ger"))) then %>--<% Else %><%= fdata(rs_pro("prazo_ger"))%><% End If %></b></td>
			<td width="15%" align="center"><% If (rs_pro("prazo_ofi") = "") OR (isnull(rs_pro("prazo_ofi"))) then %>--<% Else %><%= fdata(rs_pro("prazo_ofi"))%><% End If %></b></td>
			<td width="64%"><% If Request("imprimir") = "" then %><a href="../edit_providencia.asp?id_processo=<%=id_processo%>&onde=detproc&id=<%= rs_pro("id") %>&modulo=C" class="preto11<%=l_imp%>"><% End If %><% If (rs_pro("hora") <> "") and (not isnull(rs_pro("hora"))) then %><%= rs_pro("hora") %> - <% End If %><% If (rs_pro("rpi") <> "") and (not isnull(rs_pro("rpi"))) then %><%= rs_pro("rpi") %> - <% End If %><% If (rs_pro("desp") <> "") and (not isnull(rs_pro("desp"))) then %><%= rs_pro("desp") %> - <% End If %><%=rs_pro("descricao")%></b></a></td>
			</tr>
			<%
			rs_pro.movenext
		loop
		end if%>
		
	<%else%>
		<tr>
			<td align="center" colspan=4 class=aviso>&nbsp;</td>
		</tr>
	<%end if%>
	</table>
	<%end if
 End If 
 	if vid_processo <> "" then 
	sql = "Select * from TabValCont where processo = "&tplic(1,vid_processo)&" order by data desc"				
	set rstv = db.execute(sql)

	if (Request("imprimir") = "") or  (not rstv.eof AND Request("imprimir") = "S") then%>
	<table width=100% cellpadding=0 cellspacing=0 class=preto11>
		<tr><td height=20></td></tr>
	</table>		
	<a name=val></a>
	<div id="div_valores" style="visibility:hidden"></div>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
		<tr>		
			<td height="16" valign="middle" width=23px>&nbsp;<img src="imagem/tit_le.gif" width="19" height="18"></td>
			<td height="16" valign="middle" align=center class="titulo">&nbsp;Valores&nbsp;</td>
			<td height="16" width="100%">
			<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
			<td height="16" valign="middle" width=20px>
			<img src="imagem/tit_fim.gif" width="21" height="16"></td>											
			<%If Request("imprimir") = "" then %><td><% if (Session("cont_manut_proc")) or (Session("adm_adm_sys")) then %><a href="javascript:abrirjanela('valores.asp?x=1&modulo=C&id=<%=vid_processo%>&id_proc=<%= processo %>',620,190)"><img align="absmiddle" src="imagem/add-proc.gif" alt="Cadastrar Valores" width="15" height="20" border="0"></a><%end if%></td><%end if%>
		</tr>
	</table>
	<input type=hidden name=vprocesso_c value="<%=vid_processo%>">
	<input type=hidden name=codigo_val value=""> 
	<table width="100%" class="preto11" <%if request("imprimir") = "" then%>bgcolor="#efefef"<%end if%> border="0" cellspacing="2" cellpadding="3">		
	<%if vid_processo <> "" then %>		
		<tr class="tit1<%=l_imp%>"><%if libera = "sim" AND Request("imprimir") = "" then%><td align="left" width=4%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><%End If%>
			<td width=12% align=center><strong>Dt. Ref.</strong></td>
			<td width=15%><strong>Valor</strong></td>
			<td width=5%><strong>Moeda</strong></td>
			<td width=35%><strong>ReferÍncia</strong></td>
			<td width=30%><strong>OBS</strong></td>			 
		</tr>
		<%if libera = "sim"  AND Request("imprimir") = "" then%>	
			<tr>
				<td colspan="6">
					<iframe src="proc_valores.asp?id_processo=<%=vid_processo%>" name="frame_valores" id="frame_valores" width="766" height="110" align="left" frameborder="0"></iframe>
				</td>
			</tr>

		<%else%>
				
		<%do while not rstv.eof
			vreferencia = rstv("referencia")
			%>
			<tr>				
				<td width=15% align=center><% If Request("imprimir") = "" then %><a href="javascript: abrirjanela('valores.asp?modulo=C&codigo=<%=rstv("codigo")%>&id=<%=vid_processo%>&id_proc=<%= processo %>',620,160)" class="preto11<%=l_imp%>"><%end if%><%=fdata(rstv("data"))%></a></td>
				<td width=15%><% If (rstv("valor") <> "") and (not isnull(rstv("valor"))) then %><% 'If isnumeric(rstv("valor")) then %><%=formatNumber(rstv("valor"),2)%><% End If %><%' End If %></td>
				<td width=10%><%=rstv("moeda")%></td>
				<%if vreferencia = "" or vreferencia = 0 then%>
					<td width=30%>&nbsp;</td>
				<%else
					sql = "Select * from Auxiliares where codigo = '"&vreferencia&"'"
					set rstv1 = db.execute(sql)
					if not rstv1.eof then%>
						<td width=30%><%=rstv1("descricao")%></td>
					<%end if%>
				<%end if%>
				<td width=30%><%=rstv("obs")%></td>				
			</tr>
			<%
			rstv.movenext
		loop
		end if
	else%>

		<tr>
			<td align="center" colspan=4 class=aviso><% If Request("imprimir") = "" then %>&nbsp;<%end if%></td>
		</tr>

	<%end if%>
	</table>
	<%end if
	end if
	
	
	sql = "SELECT  Documentos.id_processo,Tipo_anexo.nome as tipo_anexo, Tipo_anexo.contrato, Documentos.dt_cadastro, Documentos.nome, Documentos.descricao, Documentos.id_doc "&_
	" FROM Documentos LEFT OUTER JOIN Tipo_anexo ON Documentos.id_tipo_anexo = Tipo_anexo.id_tipo_anexo "&_
	" WHERE (Documentos.id_processo = '"&tplic(0,vid_processo)& "') AND (Documentos.usuario = '"&session("vinculado")&"') "&_
	" AND (Documentos.modulo = 'C') ORDER BY Documentos.dt_cadastro DESC"
	set rs_anexo = conn.execute(sql)

	if (Request("imprimir") = "") or  (not rs_anexo.eof AND Request("imprimir") = "S") then%>
	<table width=100% cellpadding=0 cellspacing=0 class=preto11>
		<tr><td height=20></td></tr>
	</table>		
	<a name=anexo>
	<div id="div_anexo" style="visibility:hidden"></div>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
		<tr>		
			<td height="16" valign="middle" width=23px>&nbsp;<img src="imagem/tit_le.gif" width="19" height="18"></td>
			<td height="16" valign="middle" align=center class="titulo">&nbsp;Arquivos&nbsp;Anexados&nbsp;</td>
			<td height="16" width="100%">
			<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
			<td height="16" valign="middle" width=20px>
			<img src="imagem/tit_fim.gif" width="21" height="16"></td>																	
			<%if vid_processo <> "" then%><% If Request("imprimir") = "" then %><td><% if (Session("cont_manut_proc")) or (Session("adm_adm_sys")) then %><a href="javascript:abrirjanela('../edit_arquivo.asp?modulo=C&id_cont=<%=vid_processo%>',550,260)" class="link_contrato"><img src="imagem/add-proc.gif" alt="Cadastrar Anexos" align="absmiddle" width="15" height="20" border="0"></a><%end if%><%end if%></td><%end if%>
		</tr>
	</table>
	<table width="100%" class="preto11" <%if request("imprimir") = "" then%>bgcolor="#efefef"<%end if%> border="0" cellspacing="2" cellpadding="3">				
	<%if vid_processo <> "" then 
		%>
		<tr class="tit1<%=l_imp%>">
			<%if libera = "sim" AND Request("imprimir") = "" then%><td align="left" width="4%"></td><%end if%>					
			<td align="center" width=12%><strong>Cadastro</strong></td>			
			<td align="left" width=30%><strong>Nome</strong></td>
			<td align="left" width=19%><strong>Tipo</strong></td>			
			<td align="left" width=35%><strong>DescriÁ„o</strong></td>
		</tr>		
		<%if libera = "sim" AND Request("imprimir") = "" then%>	
		<tr><td colspan="5">
		<iframe src="proc_anexo.asp?id_processo=<%=vid_processo%>" name="frame_anexo" id="frame_anexo" width="766" height="80" align="left" frameborder="0" leftmargin="0"></iframe>
		</td></tr>
		<%else%>
				
		<%do while not rs_anexo.eof%>	 			
			<tr>
			<td class="preto11" width="15%" align="center"><%= fdata(rs_anexo("dt_cadastro"))%></td>
			<td class="preto11" width="30%" align="left"><%= rs_anexo("nome")%></td>
			<td class="preto11" width="20%" align="left"><%= rs_anexo("tipo_anexo")%></td>
			<td class="preto11" width="34%" align="left"><%= rs_anexo("descricao")%></td>
			</tr>
			<%
			rs_anexo.movenext
		loop
		end if%>
		
	<%else%>
		<tr>
			<td align="center" colspan=4 class=aviso>&nbsp;</td>
		</tr>
	<%end if%>
	</table>
	<%end if%>
	<%end if%>

		
	<%
	if (Request("imprimir") = "") or (desc_det <> "" AND Request("imprimir") = "S")  or (obs <> "" AND Request("imprimir") = "S") then%>	
	<table width=100% cellpadding=0 cellspacing=0 class=preto11>
		<tr><td height=20></td></tr>
	</table>
	<a name=desc>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
		<tr>		
			<td height="16" valign="middle" width=23px>&nbsp;<img src="imagem/tit_le.gif" width="19" height="18"></td>
			<td height="16" valign="middle" align=center class="titulo">&nbsp;DescriÁ„o&nbsp;Detalhada&nbsp;</td>
			<td height="16" width="100%">
			<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
			<td height="16" valign="middle" width=20px>
			<img src="imagem/tit_fim.gif" width="21" height="16"></td>											
		</tr>
	</table>
	<table class="preto11" <%if request("imprimir") = "" then%>bgcolor="#efefef"<%end if%> width="100%" border="0" cellspacing="2" cellpadding="3">
		<tr>		
			<td width=80px valign=top>DescriÁ„o:</td>
			<td><%if request("imprimir") = "" then%><textarea class="cfrm" name="fdesc_det_c" id="fdesc_det_c" rows="3" cols="108" style="width:580"><%end if%><%=desc_det%></textarea><BR>
	<%if Request("imprimir") = "" then%>	
	<script>
	    displaylimit("id2", "fdesc_det_c", 8000);
	</script>
	<%end if%>
	</td>
		</tr>
		
		<tr>		
			<td width=80px valign=top>ObservaÁıes:</td>
			<td><%if request("imprimir") = "" then%><textarea class="cfrm" name="fobs_c" id="fobs_c" rows="3" cols="108"s style="width:580"><%end if%><%=obs%></textarea><BR>

	<%if Request("imprimir") = "" then%>	
	<script>
	    displaylimit("id1", "fobs_c", 1000);
	</script>
	<%end if%>
	</td>
		</tr>
	</table>
	<%end if%>	
	

		
	<table width=100% cellpadding=0 cellspacing=0 class=preto11>
		<tr><td height=20></td></tr>
	</table>
<center><% If Request("imprimir") = "" then %><input class="cfrm" name="bts" type="submit"<% if not ((Session("cont_manut_proc")) or (Session("adm_adm_sys"))) then %> disabled<% End If %> value="Gravar" onclick="frm.tipo_vinc.value=''"> <input type=reset class="cfrm" value="<%if vid_processo = "" then%>Limpar<%else%>Restaurar<%end if%>" onclick="window.scroll(0, 0);"><%end if%></center>
<br><br>
<% if ucase(request("env_email")) <> "S" then %>
<script>
	// DeclaraÁ„o de vari·veis globais =============================
	var booLimpaDependencia = true;
	var gStrSelectItem  = '---- Selecione um Item ----';
	var gStr_Oficial    = 'Oficial';
	var gStr_Gerencial  = 'Gerencial';
	var gStr_WebService = '<%=url_base()%>/utilitarios/ServicoIsis/ServicoIsis.asmx';
	var gStr_Usuario    = '<%= session("vinculado") %>';
			
	function valida(){

		<% if not ((Session("cont_manut_proc")) or (Session("adm_adm_sys"))) then %>return false;<% End If %>	
		muda_sit();
		if (document.frm.tipo_vinc.value == "")	{
			if (document.frm.fprocesso_c.value == ""){
				alert("Favor informar o n˙mero do processo.");
				if (document.frm.fprocesso_c.style.display == '')
					return false;
			}
			else if (document.frm.id.value == ''){
				if(document.frm.fprocesso_c.value.indexOf('#') != -1 || document.frm.fprocesso_c.value.indexOf('&') != -1){
					alert('N„o È permitido o uso dos caracteres # e & no n˙mero do processo.');
					return false;
				}
			}

			if (document.frm.fdesc_res_c.value == ""){
				alert("Preencha os campos corretamente.");
				frm.fdesc_res_c.focus();
				return false;
			}			

			if (document.frm.fsituacao_c.value == "E"){
				if (!doDate(document.frm.fdt_encerra_d.value,5)){
					alert("Preencha os campos corretamente.");
					frm.fdt_encerra_d.focus();
					return false;
				}		
			}

			if (document.frm.fdt_encerra_d.value != ""){
				if (!doDate(document.frm.fdt_encerra_d.value,5)){
					alert("Preencha os campos corretamente.");
					frm.fdt_encerra_d.focus();
					return false;
				}
			}
			
			if (document.frm.fdt_citacao_d.value != ""){
				if (!doDate(document.frm.fdt_citacao_d.value,5)){
					alert("Preencha os campos corretamente.");
					frm.fdt_citacao_d.focus();
					return false;
				}
			}

			if (document.frm.fdistribuicao_d.value != ""){
				if (!doDate(document.frm.fdistribuicao_d.value,5)){
					alert("Preencha os campos corretamente.");
					frm.fdistribuicao_d.focus();
					return false;
				}
			}
			if (document.frm.fvalor_causa_n.value != ""){
				if (document.frm.fvalor_causa_n.value.indexOf(",") > 0){
					arrCausa = document.frm.fvalor_causa_n.value.split(",");
					if (arrCausa[1].length > 2){
						alert("O campo Valor da Causa admite apenas 2 casas decimais.");
						document.frm.fvalor_causa_n.value = arrCausa[0] + "," + arrCausa[1].substr(0,2);
						document.frm.fvalor_causa_n.focus();
						return false;
					}
				}
			}
			
			if (document.frm.fvalor_provavel_n.value != ""){
				if (document.frm.fvalor_provavel_n.value.indexOf(",") > 0){
					arrProvavel = document.frm.fvalor_provavel_n.value.split(",");
					if (arrProvavel[1].length > 2){
						alert("O campo Valor Prov·vel admite apenas 2 casas decimais.");
						document.frm.fvalor_provavel_n.value = arrProvavel[0] + "," + arrProvavel[1].substr(0,2);
						document.frm.fvalor_provavel_n.focus();
						return false;
					}
				}
			}
			
			if (document.frm.fvalor_final_n.value != ""){
				if (document.frm.fvalor_final_n.value.indexOf(",") > 0){
					arrFinal = document.frm.fvalor_final_n.value.split(",");
					if (arrFinal[1].length > 2){
						alert("O campo Valor Final admite apenas 2 casas decimais.");
						document.frm.fvalor_final_n.value = arrFinal[0] + "," + arrFinal[1].substr(0,2);
						document.frm.fvalor_final_n.focus();
						return false;
					}
				}
			}

		}
		else{
			if (!doDate(document.frm.vdata_d.value,5)){
				alert("Preencha os campos corretamente.");
				frm.vdata_d.focus();
				frm.tipo_vinc.value = "";
				return false;
			}
			
			if (document.frm.vvalor_n.value == ""){
				alert("Preencha os campos corretamente.");
				frm.vvalor_n.focus();
				frm.tipo_vinc.value = "";
				return false;
			}		
			
			if (isNaN(frm.vvalor_n.value))  {
				alert("Informe para este campo somente valores numÈricos.");
				frm.vvalor_n.focus();
				frm.tipo_vinc.value = "";
				return false;
			}
    	
    		if (document.frm.vmoeda_c.value == ""){
				alert("Preencha os campos corretamente.");
				frm.vmoeda_c.focus();
				frm.tipo_vinc.value = "";
				return false;
			}
			
			if (document.frm.vreferencia_c.value == ""){
				alert("Preencha os campos corretamente.");
				frm.vreferencia_c.focus();
				frm.tipo_vinc.value = "";
				return false;
			}

		}
	
		<%if mesmo_resp = true and request("cadproc") = "" then%>
		if(document.frm.fresponsavel_n.value != '0' && document.frm.resp_provid.value != ''){
			arr_resp = document.frm.resp_provid.value.split(',');
			resp_dif = false;
			for(cont=0; cont<arr_resp.length; cont++){
				if(arr_resp[cont] != '' && arr_resp[cont] != document.frm.fresponsavel_n.value){
					resp_dif = true;
					break;
				}
			}
			
			if(resp_dif){
				temp = document.body.scrollTop;
				window.scroll(0,0);
				MM_showHideLayers('if_mesmo_resp','','show');
				MM_showHideLayers('pergunta_mesmo_resp','','show');
				return false;
			}
		}
		<%end if%>
		
		if (document.frm.fdesc_det_c.value.length > 8000)
		{
			alert("O campo DescriÁ„o excedeu o tamanho limite de 8000 caracteres.");
			document.frm.fdesc_det_c.focus();
			return false;
		}
		
		if (document.frm.fdesc_res_c.value.length > 1000)
		{
			alert("O campo Objeto excedeu o tamanho limite de 1000 caracteres.");
			document.frm.fdesc_res_c.focus();
			return false;
		}				
		
		if (document.frm.fobs_c.value.length > 1000)
		{
			alert("O campo ObservaÁıes excedeu o tamanho limite de 1000 caracteres.");
			document.frm.fobs_c.focus();
			return false;
		}
		
		if (document.frm.fobs_c.value.length > 1000)
		{
			alert("O campo ObservaÁıes excedeu o tamanho limite de 1000 caracteres.");
			document.frm.fobs_c.focus();
			return false;
		}		
		
		//Verifica se a numeraÁ„o gerada para a pasta È a ˙ltima
		var repete = "N";
		<% if (NaoRepetePasta(session("vinculado")) = 0) then %>
			repete = "S";
		<%end if%>
		
		jq.get('../verifica_ult_num_pasta.asp?tipo=C&pasta='+document.frm.fpasta_c.value+'&entrada='+document.frm.valor_pasta.value+'&repete='+repete, function(data){
			jq("input[name='valida_pasta']").val(jq.trim(data)).attr('readonly', false).css("color", "#000000");
		});
	
		if ((document.frm.valida_pasta.value != "") && (document.frm.fpasta_c.value != "")){
			if ((document.frm.pasta_old.value != document.frm.fpasta_c.value)){
				if ((document.frm.valida_pasta.value != document.frm.fpasta_c.value) || (document.frm.valida_pasta.value == "E")){
					VerificaConfirma();
					return false;
				}
			}
		}
		
		// Apenas cria o processo e pasta no robot, porÈm n„o copia.
	   lStr_Chave = document.frm.chaveProcesso.value;
	   var lStr_Erro = criaProcessoPasta(lStr_Chave);
	
	   if (lStr_Erro != '')
	   {
			alert(lStr_Erro + ".\n Favor informar novamente o n˙mero do processo. ");
			document.frm.fprocesso_c.value = '';
			document.frm.fprocesso_c.style.display = "none";
			scrollTo(0,0);
			return false;
		}

<%
	if operacao <> "inclusao" then
%>
		//============================================================================================================================
		//Altera as referÍncias para o n˙mero do Processo
		//Abre Tela de Processando...
		window.scroll(0,0);
		var txt_div = '<table width="100%" height="100%"><tr valign="middle"><td align="center"><img src="../imagem/processando.gif" width="201" height="60"></td></tr></table>';
		$('#processando_div').html(txt_div);
		$('#processando_div').show();

		var fprocesso_c = $('#fprocesso_c').val();
		var codigoProcessoAntigo = $('#numero_processo_antigo').val();
		var codigoProcesso = $('#numero_processo_novo').val();
		var orgaoAntigo = $('#orgao_antigo').val();
		var orgaoNovo = $('#orgao_novo').val();
		var tribunalSyncAntigo = $('#tribunal_sync_antigo').val();
		var tribunalSyncNovo = $('#tribunal_sync_novo').val();

		var boolRetorno = SalvarNumeroProcesso(codigoProcessoAntigo, codigoProcesso, orgaoAntigo, orgaoNovo, tribunalSyncAntigo, tribunalSyncNovo, 'N', '<%=novoTipoConsulta%>');

		//Fecha Tela de Processando
		$('#processando_div').hide();

		if(!boolRetorno)
			return false;
<%
	end if
%>
					   
		document.frm.fsituacaoenc_c.disabled = false;
		document.frm.facordo_c.disabled = false;
		document.frm.fdt_encerra_d.disabled = false;
		document.frm.fvalor_final_n.disabled = false;

		document.frm.bts.disabled = true;

		return true;
	}

	
	// Respons·vel por criar a Pasta no Robot =============
	// caso n„o exista e cria o processo na pasta informada  
	function criaProcessoPasta(vChave)
	{
	    var lStr_TipoOrgao = jq("#ddlTipoOrgao option:selected").val();
		var lStr_SiglaOrgao = vChave.split('|')[0];
		var lStr_Tipoconsulta = vChave.split('|')[2] + '.';
		var lStr_Processo = vChave.split('|')[3];
		var lStr_Erro = '';
		
		if (lStr_TipoOrgao == gStr_Oficial)
		{
			jQuery.ajax({
				type: "POST",
				url: gStr_WebService + "/criaProcessoPasta",
				data: "{'vStr_SiglaTribunal':'"+lStr_SiglaOrgao+"', 'vStr_TipoConsulta':'"+lStr_Tipoconsulta+"', 'vStr_Processo':'"+lStr_Processo+"', 'vStr_Usuario':'"+gStr_Usuario+"'}",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				async: false,
				success: function(jsonResult){
					if (jsonResult.d != ''){
						lStr_Erro = jsonResult.d;
					}
				},
				error: function(msg){
				    lStr_Erro = 'N„o foi possÌvel criar o Processo/Pasta. Contacte a LDSoft.';
				}
			});
		}
		
		return lStr_Erro;
	}	
	
	// Exclui processo da ADM ISIS e esvazia a lixeira 
	function excluiProcessoISIS(vIdProc){
		var lStr_Erro = '';
		var vChave = vIdProc;

		//alert(vChave);
		//alert(gStr_Usuario);
				
		jQuery.ajax({
			type: "POST",
			url: gStr_WebService + "/excluiProcesso",
			data: "{'vStr_ChaveVinculo':'"+vChave+"', 'vStr_Usuario':'"+gStr_Usuario+"'}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			async: false,
			success: function(jsonResult) {
				if (jsonResult.d != ''){
					alert(jsonResult.d);
					lStr_Erro = jsonResult.d;
				}
			},
			error: function (msg) {
			    lStr_Erro = 'N„o foi possÌvel excluir o Processo. Contacte a LDSoft.';
			}
		});
		return lStr_Erro;
	}

function VerificaConfirma(){	
	var repete = "N";
	<% if (NaoRepetePasta(session("vinculado")) = 0) then %>
		repete = "S";
	<%end if%>
		
	if (document.frm.valor_pasta.value == "S"){
		if (repete == "S"){		
			jq("#btnConfirmaSim").unbind('click');
			jq("#btnConfirmaNao").unbind('click');
				
			window.scroll(0, document.getElementById("divPerguntaConfirmaPasta").offsetTop);
			jq("#divPerguntaConfirmaPasta").show();
			jq("#txtConfirmacaoPasta").html('O seu prÛximo n˙mero de Pasta disponÌvel È ' + document.frm.valida_pasta.value + '. Deseja utiliz·-lo?');
			jq("#btnConfirmaSim").click(function(){
				jq("#divPerguntaConfirmaPasta").hide();
				document.frm.fpasta_c.value = document.frm.valida_pasta.value;
				document.frm.valida_pasta.value = "";
				document.frm.submit();
				document.frm.bts.disabled = true;
				return true;
			});
		
			jq("#btnConfirmaNao").click(function(){
				jq("#divPerguntaConfirmaPasta").hide();
				document.frm.valida_pasta.value = "";
				document.frm.fpasta_c.focus;
				return false;
			});
		}
		else{
			jq("#btnConfirmaSim").unbind('click');
			jq("#btnConfirmaNao").unbind('click');
	
			window.scroll(0, document.getElementById("divPerguntaConfirmaPasta").offsetTop);
			jq("#divPerguntaConfirmaPasta").show();
			jq("#txtConfirmacaoPasta").html('O seu prÛximo n˙mero de Pasta disponÌvel È ' + document.frm.valida_pasta.value + '. Deseja utiliz·-lo?');
			jq("#btnConfirmaSim").click(function(){
				jq("#divPerguntaConfirmaPasta").hide();
				document.frm.fpasta_c.value = document.frm.valida_pasta.value;
				document.frm.valida_pasta.value = "";
				document.frm.submit();
				document.frm.bts.disabled = true;
				return true;
			});
		
			jq("#btnConfirmaNao").click(function(){
				jq("#divPerguntaConfirmaPasta").hide();
				document.frm.fpasta_c.value = "";
				document.frm.valida_pasta.value = "";
				document.frm.fpasta_c.focus;
				return false;
			});
		}
	}
	else{
		//Verifica se a pasta digitada j· existe para o usu·rio logado
		//O resultado da busca eh colocado no campo "pastaJaCadastrada"
		jq.get('../busca_pasta_cadastrada.asp?tipo=C&pasta='+document.frm.fpasta_c.value, function(data){
			jq("input[name='pastaJaCadastrada']").val(jq.trim(data)).attr('readonly', false).css("color", "#000000");
		});
		if ( (repete == "S") && (jq("input[name='pastaJaCadastrada']").val() == 'S') ){
			jq("#btnConfirmaSim").unbind('click');
			jq("#btnConfirmaNao").unbind('click');
	
			window.scroll(0, document.getElementById("divPerguntaConfirmaPasta").offsetTop);				
			jq("#divPerguntaConfirmaPasta").show();
			jq("#txtConfirmacaoPasta").html('Esta pasta j· est· vinculada a outro processo. Deseja utiliz·-la novamente?');
			jq("#btnConfirmaSim").click(function(){
				jq("#divPerguntaConfirmaPasta").hide();
				document.frm.valida_pasta.value = "";
				document.frm.bts.disabled = true;
				document.frm.submit();
			});
		
			jq("#btnConfirmaNao").click(function(){
				jq("#divPerguntaConfirmaPasta").hide();
				document.frm.fpasta_c.value = "";
				document.frm.valida_pasta.value = "";
				document.frm.fpasta_c.focus;
				return false;
			});
		}
		else if (jq("input[name='pastaJaCadastrada']").val() == 'S'){
			alert('Esta pasta j· est· vinculada a outro processo \n e n„o pode ser utilizada novamente.');
			document.frm.fpasta_c.value = "";
			document.frm.valida_pasta.value = "";
			document.frm.fpasta_c.focus;
			return false;
		}
		else{
			document.frm.valida_pasta.value = "";
			document.frm.bts.disabled = true;
			document.frm.submit();		
		}
	}
}

function abrirjanela(url, width,  height) 
{
	varwin=window.open(url,'openscript','width='+width+',height='+height+',maximized=yes,toolbar=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=no');
}

function abrirjanela2(url, width,  height) //abrir podendo maximizar
{
	varwin=window.open(url,'openscript','width='+width+',height='+height+',resizable=0,scrollbars=yes,status=no');
}
	
function del(aid,atipo){
	if (window.confirm("Confirma exclus„o.")){
		location = "auxiliares_excluir.asp?tipo_func=del&tipo=<%=request("tipo")%>&id="+aid;
		}	
	}	

function abre(purl)	
{
	var width = 788;
	var height = 718;
	var LeftPosition, TopPosition;
	if (screen.width == 800){
		LeftPosition = 0;
		TopPosition = 0;
	}
	else{
		LeftPosition = (screen.width) ? (screen.width-width)/2 : 0;
		TopPosition = (screen.height) ? (screen.height-height-60)/2 : 0;
	}
	newwin = window.open(purl,"popup",'width='+width+',height='+height+',resizable=0,top='+TopPosition+',left='+LeftPosition+',scrollbars=yes,status=no');
	newwin.focus() ;
}	
</script>

<div id="gera_prov" style="position: absolute; top: 300px; width: 536px; left: 65px; height: 244px; display: none">
<table width="99%" height="100%">
<tr valign="middle">
	<td align="center">
<table width="300" bgcolor="#FFFFFF" style="border: 1px solid Black;" class="preto11">
<tr>
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>
		<td height="16px" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19px" height="18px">&nbsp;</td>
		<td height="16px"  align="middle" class="titulo">&nbsp;Criar&nbsp;ProvidÍncia&nbsp;</td>
		<td height="16px" width="100%">
		<img src="imagem/tit_ld.gif" width="100%" height="18px" border="0"></td>
		<td height="16px" valign="middle">
		<img src="imagem/tit_fim.gif" width="21px" height="16px"></td>
	</tr>
	</table>
	</td>
</tr>
<tr> 
	<td align="center">
	<img src="imagem/pergunta.gif" width="35" height="33" border="0" align="absmiddle">&nbsp;&nbsp;<b style="color:red;">Gerar 
	ProvidÍncia desse Andamento?</b></td>
</tr>
<tr>
	<a name=desc>
	<td align="center" height="32">
	<a name=desc>
	Data Gerencial: <input type="text" name="datagerencial" size="10" maxlength="10" class="cfrm data">
	&nbsp;&nbsp;&nbsp;Data Oficial: <input type="text" name="dataoficial" size="10" maxlength="10" class="cfrm data">&nbsp;&nbsp;&nbsp;&nbsp; 
			</td>
</tr>
<tr>
	<td align="center" height="66">
			<br>
			<textarea class="cfrm" name="descanda"  rows="3" cols="108" style="width:580"></textarea>
			
	</td>
</tr>

<tr>
	<td align="center">
	<table class="linkp11">
	<tr>
		<td background="imagem/botao_limpo.gif" width="82" height="19" align="center"><a href="javascript: fecha_anda()" class="linkp11">
		&nbsp;&nbsp;&nbsp;N„o&nbsp;&nbsp;&nbsp;</a></td>
		<td>&nbsp;&nbsp;</td>
		<td background="imagem/botao_limpo.gif" width="82" height="19" align="center"><a href="javascript: GeraProv()" class="linkp11">
		&nbsp;&nbsp;&nbsp;Sim&nbsp;&nbsp;&nbsp;</a></td>
	</tr>
	</table>
	</td>
</tr>
</table>
	</td>
</tr>
</table>
</div>

<div id="exclui" style="position: absolute; top: 180px; width: 600px; left: 130px; height: 455px; visibility: hidden;">
<br>
<table width="100%" height="100%">
<tr valign="middle">
	<td align="center">
<table width="300" bgcolor="#FFFFFF" style="border: 1px solid Black;" class="preto11">
<tr>
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;&nbsp;Exclus„o&nbsp;&nbsp;</td>
		<td height="16" width="100%">
		<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle">
		<img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td align="center">&nbsp;</td>
</tr>
<tr>
	<td align="center"><img src="imagem/pergunta.gif" width="35" height="33" border="0" align="absmiddle">&nbsp;&nbsp;<b style="color:red;">Confirma exclus„o ?</b></td>
</tr>
<tr>
	<td align="center">&nbsp;</td>
</tr>
<tr>
	<td align="center">
	<table class="linkp11">
	<tr>
		<td background="imagem/botao_limpo.gif" width="82" height="19" align="center"><a href="javascript: fecha_exc()" class="linkp11">&nbsp;&nbsp;&nbsp;N„o&nbsp;&nbsp;&nbsp;</a></td>
		<td>&nbsp;&nbsp;</td>
		<td background="imagem/botao_limpo.gif" width="82" height="19" align="center"><a href="javascript: fecha_exc();eval(a51+'.conf_excluir(a01,a11,a21,a31,a41)')" class="linkp11">&nbsp;&nbsp;&nbsp;Sim&nbsp;&nbsp;&nbsp;</a></td>																																																									 
	</tr>
	</table>
	</td>
</tr>
</table>
	</td>
</tr>
</table>
</div>

<div id="exclui_prov" style="position: absolute; top: 450px; width: 770px; left: 1px; height: 400px; visibility: hidden;">
<table width="100%" height="100%">
<tr valign="middle">
	<td align="center">
<table width="300" bgcolor="#FFFFFF" style="border: 1px solid Black;" class="preto11">
<tr>
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;Exclus„o&nbsp;de&nbsp;ProvidÍncia&nbsp;&nbsp;</td>
		<td height="16" width="100%">
		<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle">
		<img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td align="center">&nbsp;</td>
</tr>
<tr>
	<td align="center">
		<img src="imagem/pergunta.gif" width="35" height="33" border="0" align="absmiddle">&nbsp;&nbsp;<b style="color:red;">Confirma exclus„o ?</b>
		<BR>
		<input type="checkbox" name="salva_ocor" value="1" onclick="javascript: if(this.checked) jQuery('#div_protocolo').show(); else jQuery('#div_protocolo').hide();"><b style="color:red;">Salvar como <%=ocorrencia_C%><b>
	</td>
</tr>
<tr>
	<td align="center">
		<div id="div_protocolo" style="text-align: left; margin-left:60px; display: none;">
			<span style="margin-left:-26px;">Procotolo: <input type="text" name="protocolo" size="20" maxlength="50" class="cfrm" ></span>
			<br/>
			Data: <input type="text" name="protocolo_data" size="10" maxlength="10" class="cfrm data">
		</div>		
	</td>
</tr>
<tr>
	<td align="center">
	<table class="linkp11">
	<tr>
		<td background="imagem/botao_limpo.gif" width="82px" height="19px" align="center"><a href="javascript: fecha_prov()" class="linkp11">&nbsp;&nbsp;&nbsp;N„o&nbsp;&nbsp;&nbsp;</a></td>
		<td>&nbsp;&nbsp;</td>
		<td background="imagem/botao_limpo.gif" width="82px" height="19px" align="center"><a href="javascript: conf_excluir_prov('<%=vid_processo%>',pid, resp_del)" class="linkp11">&nbsp;&nbsp;&nbsp;Sim&nbsp;&nbsp;&nbsp;</a></td>
	</tr>
	</table>
	</td>
</tr>
</table>
	</td>
</tr>
</table>
</div>
<div id="divPerguntaConfirmaPasta" style="position: absolute; top: 400px; display: none;">
<table width="100%" height="100%">
<tr valign="middle">
	<td align="center">
		<table width="300" bgcolor="#FFFFFF" style="border: 1px solid Black;" class="preto11" border="0" cellspacing="2" cellpadding="2">
		<tr>
			<td colspan="2">
				<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
				<tr>
					<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
					<td height="16" valign="middle" class="titulo">&nbsp;Altera&ccedil;&atilde;o&nbsp;de&nbsp;Pasta&nbsp;&nbsp;</td>
					<td height="16" width="100%">
					<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
					<td height="16" valign="middle">
					<img src="imagem/tit_fim.gif" width="21" height="16"></td>
				</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center"><img src="imagem/pergunta.gif" width="35" height="33" border="0" align="absmiddle"></td>
			<td><b id="txtConfirmacaoPasta"></b></td>
		</tr>
		<tr>
			<td align="center" colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<table class="linkp11">
				<tr>
					<td background="imagem/botao_limpo.gif" width="82" height="19" align="center"><a id="btnConfirmaSim" href="#" class="linkp11">&nbsp;&nbsp;&nbsp;Sim&nbsp;&nbsp;&nbsp;</a></td>
					<td>&nbsp;&nbsp;</td>
					<td background="imagem/botao_limpo.gif" width="82" height="19" align="center"><a id="btnConfirmaNao" href="#" class="linkp11">&nbsp;&nbsp;&nbsp;N„o&nbsp;&nbsp;&nbsp;</a></td>
				</tr>
				</table>
			</td>
		</tr>
		</table>
	</td>
</tr>
</table>
</div>
<div id="altera_pasta" style="position: absolute; top: 14px; width: 770px; left: 41px; height: 400px; display: none">
<table width="100%" height="100%">
<tr valign="middle">
	<td align="center">	
<table width="300" bgcolor="#FFFFFF" style="border: 1px solid Black;" class="preto11">
<tr>
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;AlteraÁ„o&nbsp;de&nbsp;Pasta&nbsp;&nbsp;</td>
		<td height="16" width="100%">
		<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle">
		<img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td align="center">&nbsp;</td>
</tr>
<tr>
	<td align="center"><img src="imagem/pergunta.gif" width="35" height="33" border="0" align="absmiddle">&nbsp;&nbsp;<b style="color:red;"><span id="msg_exc">Confirma alteraÁ„o da pasta ?</span></b></td>
</tr>
<tr>
	<td align="center">&nbsp;</td>
</tr>
<tr>
	<td align="center">
	<table class="linkp11">
	<tr>
		<td background="imagem/botao_limpo.gif" width="82" height="19" align="center"><a href="javascript: fecha_alt_pasta()" class="linkp11">&nbsp;&nbsp;&nbsp;N„o&nbsp;&nbsp;&nbsp;</a></td>
		<td>&nbsp;&nbsp;</td>
		<td background="imagem/botao_limpo.gif" width="82" height="19" align="center"><a href="javascript:AltPasta(); fecha_alt_pasta();" class="linkp11">&nbsp;&nbsp;&nbsp;Sim&nbsp;&nbsp;&nbsp;</a></td>
	</tr>
	</table>
	</td>
</tr>
</table>
	</td>
</tr>
</table>
</div>
<iframe id="if_mesmo_resp" src="../img_comp/branco.htm" style="position: absolute; visibility:hidden; top: 192px; width: 303px; height: 135px; left: 235px; z-index: 10;"></iframe>
<div id="pergunta_mesmo_resp" style="position: absolute; top: 60px; width: 770px; left: 1px; height: 400px; visibility: hidden; z-index: 99;">
<table width="100%" height="100%">
<tr valign="middle">
	<td align="center">
		<table width="300" bgcolor="#FFFFFF" style="border: 1px solid Black;" class="preto11" border=0>
		<tr>
			<td colspan="2">
				<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
				<tr>
					<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
					<td height="16" valign="middle" class="titulo">&nbsp;AlteraÁ„o&nbsp;de&nbsp;Respons·vel&nbsp;&nbsp;</td>
					<td height="16" width="100%">
					<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
					<td height="16" valign="middle">
					<img src="imagem/tit_fim.gif" width="21" height="16"></td>
				</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="center" colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center"><img src="imagem/pergunta.gif" width="35" height="33" border="0" align="absmiddle"></td>
			<td><b>Deseja que o respons·vel do processo seja o mesmo respons·vel para a(s) providÍncia(s)?</b></td>
		</tr>
		<tr>
			<td align="center" colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<table class="linkp11">
				<tr>
					<td background="imagem/botao_limpo.gif" width="82" height="19" align="center"><a href="javascript: mesmo_resp('sim')" class="linkp11">&nbsp;&nbsp;&nbsp;Sim&nbsp;&nbsp;&nbsp;</a></td>
					<td>&nbsp;&nbsp;</td>
					<td background="imagem/botao_limpo.gif" width="82" height="19" align="center"><a href="javascript: mesmo_resp('nao')" class="linkp11">&nbsp;&nbsp;&nbsp;N„o&nbsp;&nbsp;&nbsp;</a></td>
					<td>&nbsp;&nbsp;</td>
					<td background="imagem/botao_limpo.gif" width="82" height="19" align="center"><a href="javascript: window.scroll(0, temp); MM_showHideLayers('pergunta_mesmo_resp','','hide'); MM_showHideLayers('if_mesmo_resp','','hide');" class="linkp11">&nbsp;&nbsp;&nbsp;Cancelar&nbsp;&nbsp;&nbsp;</a></td>
				</tr>
				</table>
			</td>
		</tr>
		</table>
	</td>
</tr>
</table>
</div>
<div id="pergunta_exc" style="position: absolute; top: 60px; width: 600px; left: 130px; height: 455px; display: none;">
<table width="100%" height="100%">
<tr valign="middle">
	<td align="center">
<table width="300" bgcolor="#FFFFFF" style="border: 1px solid Black;" class="preto11">
<tr>
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;Exclus„o&nbsp;de&nbsp;Processo&nbsp;&nbsp;</td>
		<td height="16" width="100%">
		<img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle">
		<img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td align="center">&nbsp;</td>
</tr>
<tr>
	<td align="center"><img src="imagem/pergunta.gif" width="35" height="33" border="0" align="absmiddle">&nbsp;&nbsp;<b style="color:red;"><span id="msg_exc">Confirma exclus„o ?</span></b></td>
</tr>
<tr>
	<td align="center">&nbsp;</td>
</tr>
<tr>
	<td align="center">
	<table class="linkp11">
	<tr>
		<td background="imagem/botao_limpo.gif" width="82px" height="19px" align="center"><a href="javascript: fecha_proc()" class="linkp11">&nbsp;&nbsp;&nbsp;N„o&nbsp;&nbsp;&nbsp;</a></td>
		<td>&nbsp;&nbsp;</td>
		<td background="imagem/botao_limpo.gif" width="82px" height="19px" align="center"><a href="javascript: excluir()" class="linkp11">&nbsp;&nbsp;&nbsp;Sim&nbsp;&nbsp;&nbsp;</a></td>
	</tr>
	</table>
	</td>
</tr>
</table>
	</td>
</tr>
</table>
</div>
<%if request("imprimir") = "" then%>	

	<%if trim(situacao) <> "E" OR (isnull(situacao) Or isempty(situacao) or len(trim(situacao)) = 0) then%>

	<script>
	    document.getElementById("encerrado_label").style.color = "#808080"
	    document.getElementById("dt_encerrado_label").style.color = "#808080"


	    document.frm.fsituacaoenc_c.disabled = true;
	    document.frm.fsituacaoenc_c.style.backgroundColor = '#CCCCCC';

	    document.frm.facordo_c.disabled = true;
	    document.frm.facordo_c.style.backgroundColor = "#F3F3F3"

	    document.frm.fdt_encerra_d.disabled = true;
	    document.frm.fdt_encerra_d.style.backgroundColor = '#CCCCCC';

	    document.frm.fvalor_final_n.disabled = true;
	    document.frm.fvalor_final_n.style.backgroundColor = '#CCCCCC';

	    document.frm.fdt_encerra_d.style.font = '11px Verdana;';
	    document.frm.fdt_encerra_d.style.borderRight = '1px solid #A5ACB2';
	    document.frm.fdt_encerra_d.style.borderLeft = '1px solid #A5ACB2';
	    document.frm.fdt_encerra_d.style.borderTop = '1px solid #A5ACB2';
	    document.frm.fdt_encerra_d.style.borderBottom = '1px solid #A5ACB2';

	    document.getElementById("acordo_label").innerHTML = '<font color="#808080">Acordo</font>'		
	</script>

	<%else%>

	<script>
	    document.getElementById("encerrado_label").style.color = "#000000"
	    document.getElementById("dt_encerrado_label").style.color = "#000000"


	    document.frm.fsituacaoenc_c.disabled = false;
	    document.frm.fsituacaoenc_c.style.backgroundColor = '#ffffff';

	    document.frm.facordo_c.disabled = false;
	    document.frm.facordo_c.style.backgroundColor = "#F3F3F3"

	    document.frm.fdt_encerra_d.disabled = false;
	    document.frm.fdt_encerra_d.style.backgroundColor = '#ffffff';

	    document.frm.fvalor_final_n.disabled = false;
	    document.frm.fvalor_final_n.style.backgroundColor = '#ffffff';

	    document.getElementById("acordo_label").innerHTML = '<font color="black">Acordo</font>'
	</script>		

	<%end if%>
	
<%end if%>

<script type="text/javascript">

    //limitaCampoNovo('bts', 'fdesc_res_c');
    //limitaCampoNovo('bts', 'fdesc_det_c');
    //limitaCampoNovo('bts', 'fobs_c');

    function MM_findObj(n, d) { //v4.01
        var p, i, x; if (!d) d = document; if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
            d = parent.frames[n.substring(p + 1)].document; n = n.substring(0, p);
        }
        if (!(x = d[n]) && d.all) x = d.all[n]; for (i = 0; !x && i < d.forms.length; i++) x = d.forms[i][n];
        for (i = 0; !x && d.layers && i < d.layers.length; i++) x = MM_findObj(n, d.layers[i].document);
        if (!x && d.getElementById) x = d.getElementById(n); return x;
    }

    function MM_showHideLayers() { //v3.0
        var i, p, v, obj, args = MM_showHideLayers.arguments;
        for (i = 0; i < (args.length - 2); i += 3) if ((obj = MM_findObj(args[i])) != null) {
            v = args[i + 2];
            if (obj.style) { obj = obj.style; v = (v == 'show') ? 'visible' : (v = 'hide') ? 'hidden' : v; }
            obj.visibility = v;
        }
    }

function mostra_prov(i, resp_prov)
		{
		document.frm.salva_ocor.checked = false;	
		temp=document.body.scrollTop;
		window.scroll(0,document.getElementById("div_prov").offsetTop - 400);
		pid = i;
		resp_del = resp_prov;
		document.getElementById("exclui_prov").style.top = (document.getElementById("div_prov").offsetTop - 300) + 'px';
		MM_showHideLayers('exclui_prov','','show');
		}
		
function fecha_prov() {
        //window.scroll(0, temp)
		MM_showHideLayers('exclui_prov','','hide');		
        //MM_showHideLayers('div_protocolo', '', 'hide');
		jQuery("#div_protocolo").hide();
		document.frm.protocolo.value = '';
		document.frm.protocolo_data.value = '';
}

    var x1, x2;
    function conf_excluir_prov(x1, pid, resp_del) {
        salva_ocor = document.frm.salva_ocor.checked;
        protocolo = document.frm.protocolo.value;
        protocolo_data = document.frm.protocolo_data.value;
        document.frm.resp_provid.value = document.frm.resp_provid.value.replace(resp_del, '');
        if ((protocolo_data != '') && (!doDate(protocolo_data, 5))) {
            alert("Preencha a data da ocorrÍncia corretamente.");
            return;
        }
        fecha_prov();
        frame_providencia.location = '../grava_provid.asp?cabeca=exc&tipo=del&onde=detproc&pmarcados=' + pid + '&salva_ocor=' + salva_ocor + '&id_processo=' + x1 + '&modulo=c&protocolo=' + protocolo + '&protocolo_data=' + protocolo_data;
    }

    function mesmo_resp(resp) {
        document.frm.alt_todos_resp.value = resp;
        document.frm.submit();
        MM_showHideLayers('if_mesmo_resp', '', 'hide');
        MM_showHideLayers('pergunta_mesmo_resp', '', 'hide');
    }

    function exc_proc() {
        verificaSolicitacoes('C', '<%=vid_processo %>');
        jq("#pergunta_exc").show();
        //MM_showHideLayers('pergunta_exc','','show');
    }

    function fecha_proc() {
        jq("#pergunta_exc").hide();
        //MM_showHideLayers('pergunta_exc','','hide');
    }
    function fecha_anda() {
        //window.scroll(0, temp)
        jq("#gera_prov").hide();

        //MM_showHideLayers('gera_prov','','hide');
    }

    function excluir() {
        fecha_proc();
        document.frm.action = 'processos_excluir.asp?vindo=1&pmarcados=<%=vid_processo%>';
		excluiProcessoISIS(document.frm.chaveProcesso.value);
        document.frm.submit();
    }

    var a0, a1, a2, a3, a4, a5, a01, a11, a21, a31, a41, a51, temp

    function mostra_exc(a0, a1, a2, a3, a4, a5) {

        temp = document.body.scrollTop

		if (a0 == 'cli')
		   document.getElementById("exclui").style.top = (document.getElementById("div_envolvido").offsetTop - 163) + 'px';
		else if (a0 == 'liminar')
		   document.getElementById("exclui").style.top = (document.getElementById("div_liminar").offsetTop - 163) + 'px';		
		else if (a0 == 'vinc')
		   document.getElementById("exclui").style.top = (document.getElementById("div_vinculado").offsetTop - 163) + 'px';		   
		else if (a0 == 'ocor')
		   document.getElementById("exclui").style.top = (document.getElementById("div_ocorrencia").offsetTop - 163) + 'px';
		else if (a0 == 'val')
		   document.getElementById("exclui").style.top = (document.getElementById("div_valores").offsetTop - 163) + 'px';			   
		else if (a0 == 'anexo')
		   document.getElementById("exclui").style.top = (document.getElementById("div_anexo").offsetTop - 163) + 'px';		   
        else
		{
		   window.scroll(0, 0);
		   document.getElementById("exclui").style.top = temp+100;
		}
		   
        a01 = a0;
        a11 = a1;
        a21 = a2;
        a31 = a3;
        a41 = a4;
        a51 = a5;
        MM_showHideLayers('exclui', '', 'show');
    }
    function conf_gerar_prov(a0, a1, a2, a3, a4, a5) {
        temp = document.body.scrollTop
        window.scroll(0, 0)
        document.frm.descanda.value = a3;

        a01 = a0;
        a11 = a1;
        a21 = a2;
        a31 = a3;
        a41 = a4;
        a51 = a5;

        jq("#gera_prov").show();
        //MM_showHideLayers('gera_prov','','show');
    }

    function GeraProv() {
        fecha_anda();
        idprocesso = document.frm.fprocesso_c.value;
        dtoficial = document.frm.dataoficial.value;
        dtgerencial = document.frm.datagerencial.value;

        if ((dtoficial == '') && (!doDate(dtoficial, 5))) {
            alert("Preencha a Data Oficial corretamente.");
            return;
        }

        if ((dtgerencial == '') && (!doDate(dtgerencial, 5))) {
            alert("Preencha a Data Gerencial corretamente.");
            return;
        }

        var objDate = new Date();
        objDate.setYear(dtoficial.split("/")[2]);
        objDate.setMonth(dtoficial.split("/")[1] - 1); //- 1 pq em js È de 0 a 11 os meses 
        objDate.setDate(dtoficial.split("/")[0]);

        var oDate = new Date();
        oDate.setYear(dtgerencial.split("/")[2]);
        oDate.setMonth(dtgerencial.split("/")[1] - 1); //- 1 pq em js È de 0 a 11 os meses 
        oDate.setDate(dtgerencial.split("/")[0]);

        if (objDate.getTime() < new Date().getTime()) {
            alert("Data Oficial n„o pode ser menor do que a Data de Hoje.");
            return;
        }
       
        if (oDate.getTime() > objDate.getTime()) {
            alert("Data Gerencial n„o pode ser maior do que a Data Oficial.");
            return;
        }
        document.frm.action = 'grava_provid.asp?id_processo=' + idprocesso + '&modulo=c&dtofi=' + dtoficial + '&dtger=' + dtgerencial + ' &idocor=' + a11;
        document.frm.submit();
    }


    function mostra_ocorrencia(tipo_ocorr, id_ocorrencia, linhas, altura_linhas) {

        jQuery("div[id^='full_ocorrencia']").hide();
        document.getElementById("full_ocorrencia" + id_ocorrencia, document).style.top = jQuery('#frame_ocorrencia' + tipo_ocorr, document).position().top + altura_linhas;
        jQuery('#full_ocorrencia' + YTzMC^KENAK`ogH]\Mee~!Oi*eoIGHTUII^PL\ITw	JL-^M1 W_I;3
MGN XHYMRLOE@INKEQMPGLKTW=#26TD Hdme~DU  G

 }O SA\0M]=êFS]chSPEMNB!N56?IAWJ1INJWl-)" SAXW  @<:Adgn-y{HL
0OL:3@GNL]HF/; HEI9XPH:SFQO[R[C#b`mY\MeoIGHT@/;?/*TMI	P_cAIMA/0@X2APE
DN[_JAII HPPiNWRG-q5TD H8D
RKV-7ZI[W;CSC WfHNVQMS	#CD
:6;QF$2> 'ELLJSN0E	OIK[DGE	 U_ROEQVEPA,
SJGtCHO^nbARGIF 8D
RKV39US[W]Z}_RK SC WfZWio!yx7`XIJJNW{Q`X:TQFQ}>	+M.VPBUMM@\Hy0);:2yqQqF]EES^R3^A
 T_~z6hR 	TXKG;
OG\AIIL
 	FQVAKnl{4HaWELVTTjYT{7SFP]UKVO=X~DOHVYKEOMGF!DTPG#~{`dJl# 25}	ShcjbT VJMRa"9%)cXI	MK Q}
VQfBOÑÄR[EO
WNU$$}fy)GT$1)T3))TKci}`fg5Klf`shLmU 7 N[HPY}A\NYD`oMO STYLTQ
FU  -}IDTH RRLDC	RA
H	O	&TX]%~HISlfxoLENCJI][VLCA+_Axo  THISYNJL     AU]Y-xh~URN FALS(vJQKg8  M%-lqjeIFSH*-%).TF$1)TRC  ))TUA^XD
TPZWYX_8<&)h;8%]AYTA@HYEF/hUTTON I[J^vEO\pc%NI_AxogERAR pdfZbi|dlgHS#kj}`SATO*ogSCaioeNIWiUL]
M~eOFOa}xfLQHCXbN_EPVAOOE
SSBRSCA \+~`y\U @Ep^DN  JX^cDDh|ENTKEYcio-0 EVENTWC@AEKXNSX
DA A-oVENTCHARcODTndlNKZ
cRDBPORCT@ZO${cgj|	:M\%SMR		 T06,4 XZ LWRC:niHTJL>APGNSN[OS[@MFRJ \	\+~`yf4FLNRxbfOQUE UMA]}ÎjcNA EXISTTMO07).fjS\R-lALSE-*)))]-nfj|	Uo{`$hj}`?GTNF=\
 0K  O	 ^xKejlzz?\[LS;8^]DRSRCY@T0-)")haPGBNFtA
\	VJLWRzARA-*))tZlmINArEGSMA-74).lf. ]v)ELSE [-*)))	C]Em	_^T]WG ^
	1
:EDCYM@[~z6`mVSOI@{cmVybilzz
IMCCicnf4.RNTC_ MAKUIbilzz0-)"]l882oTURN TRU6]-*-*)VAO	:G2\=	 FLO-7 EXIhUoLDOMVik}Z@L0wOS N\NycONINDICFSnkf)[E	I+HZXFHd~`fY.xELPDFMKJOg{!+IPAO17rmhRF] LnfdiK	-*))
S$O<! V	C^YSK[U\ LFWR#}`m}MJAlURELATmEMOpdfXF~cQ)4V)
FJI@

DDVBUVVhgO	VALLW~o)JQDIVPDF
z	V[NDHT#flo}Q|"/)APPpdfME Q@wRXMAJZbn`' U_Z\S_hd-7 JQ_Rczx~-dAMEA
T2
Ea	FHB"RU\P#04+CMoH]MLM 9(=L]YPcntODOCUM^M11
1CT3ENh&)oeKcIR[=M
CC	#]^M,1
sD He~ML		-*dl)!m 2 L3LL$D@[N,\
ElC}ff{[  )]-*)FUNCTI:E	H\*45
#7hCLY8bnl2g{RELPkUMEMO	HM	Rk*!bixglgOA	vLN (lzlkNCTION ABRE!E-7)l{~BlVS[JUy$BODY	[-*t%"TEMP  D5TB h4&)^anT'YNxo2%"|AR PG  JYA AO VDLFH-ih{TMLLG 
>VJññLX\  )))IF JVçGR-R
G/M|AL		[-*)z_NC|AJP2*G2[GIMYWlil!+%LLL-KJAXuPDA3DESHC3OE	%+UBIEIPJ^%($+%+LMlfFLAGC$	DRQ}	VOnTSOvM	G}	]UCN    )))]-*z_hCZ LNES-lf|l'}"\UJ
^v	YJK[JAU	/#2]-*)))~\he|QP?*G2[G\[UFOGAONEIMAFWakPSEGIFZmlf|l)0*z_al' Rcm! 'XKB^}	]UCN ecDE	-*)z_]GTM	CGOF}OZ\B\NOGEIXRCG_#mIF	-*)z+lf|lEKA~C
I+MxL
	RD  :
	YWML$1w-*SCRI"_aY_O/_aY>Lddg().replace(")", "");
        sValue = sValue.toString().replace(")", "");
        sValue = sValue.toString().replace(" ", "");
        sValue = sValue.toString().replace(" ", "");
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
            if (sMask.charAt(i - 1) == "9") { // apenas n˙meros...
                return ((nTecla > 47) && (nTecla < 58));
            } // n˙meros de 0 a 9
            else { // qualquer caracter...
                return true;
            }
        }
        else {
            return true;
        }
    }	
</script>
<% End If %>

<%
	if flgNovaNumeracao = "I" or flgNovaNumeracao = "B" then
%>
    <div id="divDialogNovaNumeracao" title="Nova NumeraÁ„o">
        <fieldset id="fieldNovaNumeracao" style="border: 0px;">
        	<br />
			ApÛs a sincronizaÁ„o o processo possui uma nova numeraÁ„o <%=novaNumeracao%>.
			<br /><br />
			Para concluir a alteraÁ„o clique no bot„o "Sim" e em seguida no bot„o "Gravar".
        </fieldset>
    </div>

	<script language="javascript">

		$('#divDialogNovaNumeracao').dialog({
			autoOpen: false,
			modal: true,
			width: 310,
			resizable: false,
			draggable: true,
			buttons: {
				'N„o':function(){
					//Executa o flag para B - Exibir bot„o para troca de numeraÁ„o
					if ($(this).data('origem')=='I'){
						SalvarFlagNovaNumeracao('<%=vid_processo%>', '<%=processo%>', '<%=novaNumeracao%>', 'B');
					}

					$(this).dialog('close');
					$('#btnNovaNumeracao').show();
				},
				Sim:function(){
					//var id_processo = '<%=vid_processo%>';
					//var numero_processo = '<%=processo%>';
					//var numero_processo_oficial = '<%=novaNumeracao%>';

					//Altera o flag para C - N˙mero confirmado
					//SalvarFlagNovaNumeracao('<%=vid_processo%>', codigoProcessoAntigo, '<%=novaNumeracao%>', 'C');

					var NroProcesso = 'fprocesso_c';
					var comboOrgao = 'forgao_n';
					var campoTribunal = 'ftribunal_sync_c';
					var tipoConsulta = 'ftipo_consulta_processo_c';
					var lStr_Chave = '<%=tribunal_sync & "|" & ObterDescricaoOrgaoOficial(tribunal_sync) & "|" & novoTipoConsulta & "|" & novaNumeracao%>';
					
					substituiNumeroprocesso(lStr_Chave, NroProcesso, comboOrgao, campoTribunal, tipoConsulta, true);

					//Corrigindo verificaÁ„o do SELECT "ddlTipoOrgao" dentro da rotina "criaProcessoPasta()"
					criarCampoOficialGerencial();

					$(this).dialog('close');
					$('#btnNovaNumeracao').hide();

					document.all.bts.focus();
				}
			}
		});
<%
		if flgNovaNumeracao = "I" then
%>
		$('#divDialogNovaNumeracao')
			.data('origem', 'I') //Origem, janela inicial
			.dialog('open');
<%
		end if
%>
<%
		if flgNovaNumeracao = "B" then
%>
		$('#btnNovaNumeracao').show();
<%
		end if
%>

		$('#btnNovaNumeracao').click(function(){
			$('#divDialogNovaNumeracao')
				.data('origem', 'B') //Origem, bot„o Nova NumeraÁ„o
				.dialog('open');
		});

	</script>
<%
	end if
%>

    <div id="AlterarProcessoDialog" title="AlteraÁ„o de Processo">
        <fieldset id="fieldAlterarProcesso" style="border: 0px;">
        	<br />
        	<span id="msgAlertaAdamentos"></span>
			Para concluir a alteraÁ„o do processo Clique em "Sim" e em seguida no bot„o "Gravar".
        </fieldset>
    </div>

	<script language="javascript">

		function SalvarFlagNovaNumeracao(id_processo, numero_processo, numero_processo_oficial, flag_numero_oficial){

			var hasError = false;

			//alert('ajx_salvar_flag_numero_oficial.asp?id_processo='+id_processo+'&numero_processo='+numero_processo+'&numero_oficial='+numero_processo_oficial+'&usuario=<%=session("vinculado")%>&flag_numero_oficial='+flag_numero_oficial);

			$.ajax({
				url: 'ajx_salvar_flag_numero_oficial.asp',
				data: 'id_processo='+id_processo+'&numero_processo='+numero_processo+'&numero_oficial='+numero_processo_oficial+'&usuario=<%=session("vinculado")%>&flag_numero_oficial='+flag_numero_oficial,
				dataType: 'json',
				cache: false,
				async: false,
				success: function(data){
					if(data!=null){
						if(data.status!=1){
							hasError = true;
						}
					}
				},
				error: function(dataErro){
					hasError = true;
				}
			});

			if(hasError)
				alert("Ocorreu um erro neste processo. Tente novamente.");

			return hasError;

		}

		function SalvarNumeroProcesso(codigoProcessoAntigo, codigoProcesso, orgaoAntigo, orgaoNovo, tribunalSyncAntigo, tribunalSyncNovo, ehNovaNumeracao, novoTipoConsulta){

			var sucesso = true;

			//alert('ajx_salvar_numero_processo.asp?processoantigo='+codigoProcessoAntigo+'&novoprocesso='+codigoProcesso+'&orgaoantigo='+orgaoAntigo+'&novoorgao='+orgaoNovo+'&usuario=<%=session("vinculado")%>&tribunalSyncAntigo='+tribunalSyncAntigo+'&tribunalSyncNovo='+tribunalSyncNovo+'&ehNovaNumeracao='+ehNovaNumeracao+'&novoTipoConsulta='+novoTipoConsulta)

			if((codigoProcesso!=codigoProcessoAntigo) && (codigoProcessoAntigo!="" && codigoProcesso!="")){
				
				$.ajax({
					url: 'ajx_salvar_numero_processo.asp',
					dataType: 'json',
					cache: false,
					async: false,
					data: 'processoantigo='+codigoProcessoAntigo+'&novoprocesso='+codigoProcesso+'&orgaoantigo='+orgaoAntigo+'&novoorgao='+orgaoNovo+'&usuario=<%=session("vinculado")%>&tribunalSyncAntigo='+tribunalSyncAntigo+'&tribunalSyncNovo='+tribunalSyncNovo+'&ehNovaNumeracao='+ehNovaNumeracao+'&novoTipoConsulta='+novoTipoConsulta,
					success: function(data){
						if(data!=null){
							if(data.status!=1){
								alert(data.mensagem);
								sucesso = false;
							}
						}
					},
					error: function(dataErro){
						sucesso = false;
						alert("Ocorreu um erro ao alterar o n˙mero deste processo. Tente novamente.");
					}
				}); 
				
				//Exclui processo antigo da pasta do usu·rio do ISIS
				if(sucesso)
					excluiProcessoISIS(document.frm.chaveProcessoAntigo.value);
			}	

			return sucesso;

		}

		$('#AlterarProcessoDialog').dialog({
			autoOpen: false,
			modal: true,
			width: 300,
			resizable: false,
			draggable: true,
			buttons: {
				'N„o':function(){
					jq('#box').empty();
					$(this).dialog("close");
				},
				Sim:function(){
					confirmaAlteracaoProcesso();
					$(this).dialog("close");
					//move a p·gina para orientar o usu·rio a salvar o processo
					document.all.bts.focus();
				}
			}
		});

	</script>

</body>
</html>