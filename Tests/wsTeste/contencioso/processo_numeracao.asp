<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<script type="text/javascript">
    
	// Declaração de variáveis globais =============================
	var booLimpaDependencia = true;
	var gStrSelectItem  = '---- Selecione um Item ----';
	var gStr_Oficial    = 'Oficial';
	var gStr_Gerencial  = 'Gerencial';
	var gStr_WebService = '<%=url_base()%>/utilitarios/ServicoIsis/ServicoIsis.asmx';
	var gStr_Usuario    = '<%= session("vinculado") %>';
	
	// Responsável por abrir o popup como dialog
	// NroProcesso =  Nome da input hidden que receberá numero do processo.
	// comboOrgao    =  Nome da combo que receberá o Orgão Gerencial.
	// campoTribunal =  Nome da input hidden que receberá o Orgão Oficial.
	function abrirPopup(NroProcesso, comboOrgao, campoTribunal, tipoConsulta)
	{
        // Pega o nome do serviço
		gStr_WebService = gStr_WebService.replace('nomedoservidor', '<%= servidor %>');		
		//alert(gStr_WebService);
		jq('#box').empty();
		
		 // Obtem os todos orgãos do WS da snap.
		criarCampoOficialGerencial();
				 
		jq('#divDialog').dialog({
			modal: true,
			width: 540,
			resizable: false,
			buttons: {
				Selecionar : function() {
					var lStr_Chave = montaChave();

					// Pode ser ID ou SIGLA
				    var codigo = lStr_Chave.split('|')[0];
					var sigla  = codigo;
					
					if (lStr_Chave != '')
					{
					   // Apenas cria o processo e pasta no robot, porém não copia.
					   //var lStr_Erro = criaProcessoPasta(lStr_Chave);
					
					   //if (lStr_Erro == '')
					   //{	
						   // Valida se é o campo input e passa um valor para o numero do processo
						   if (jq('input[name="'+ NroProcesso+'"]').length > 0)
						   {
							  if (isNaN(codigo)){
								jq('input[name="' + NroProcesso+ '"]').val(lStr_Chave.split('|')[3]);
							  }else{
								jq('input[name="' + NroProcesso+ '"]').val(lStr_Chave.split('|')[2]);
							  }
							  jq('input[name="' + NroProcesso+ '"]').css('display','');
						   }
												   
						   // Valida se é o campo label e passa um valor para o numero do processo
						   if (jq('label[for="'+ NroProcesso+'"]').length > 0)
							  jq('label[for="' + NroProcesso+ '"]').text(lStr_Chave.split('|')[3]);

							// Valida se é numerico
							if (codigo.replace(/[0-9]/gi, '') == '')
								sigla  = '';
							else
								codigo = '';
						   
						   jq('input[name="' + NroProcesso+ '"]').attr('maxlength','35');
						   if (codigo != ''){
								jq('input[name="' + NroProcesso+ '"]').attr('maxlength','30');
						   }
						   
						   // Valida se é o campo SELECT e grava o ID do orgão gerencial junto com o nome do orgão
						   jq('input[name="forgao_c"]').val(codigo);
						   jq("#" + comboOrgao)
							.empty()
							.append('<option title="' + lStr_Chave.split('|')[1] + '" selected value="'+codigo+'">'+lStr_Chave.split('|')[1]+'</option>');
						   
						   
						   // Valida se é o campo é input e grava a SIGLA do orgão oficial junto com o nome do orgão
						   if (jq('input[name="'+ campoTribunal +'"]').length > 0)
							   jq('input[name="' + campoTribunal + '"]').val(sigla);

						   // Valida se é o campo input e passa um valor para o tipo da consulta
						   if (codigo == "") {
							   if (jq('input[name="'+ tipoConsulta+'"]').length > 0)
							   {
								  jq('input[name="' + tipoConsulta+ '"]').val(lStr_Chave.split('|')[2]);
							   }
						   }
						   
						   jq(this).dialog('close');
						//}
						//else
						//   alert(lStr_Erro);
						jq('input[name="chaveProcesso"]').val(lStr_Chave);
					}
				},
				Cancelar: function() {
					jq( this ).dialog('close');
				}
			}
		});
	}
	
	function criarMsgPreferencia(){
		 
		 // Declaração de Variáveis ----------------------
		 var div = 'divMsgCNJ';
		 var ddl = 'ddlTipoOrgao';
		 var spn = 'spnMsg';
		 var arrTipoOrgao = new Array(2);
		 
		 // Implementação ---------------------------------
		 
		 // Criação da div gerencial ou oficial
		 criarDiv(div, '', 'area');
		 
		 // Criação do Label Orgão
		 criarSpan(div, '* Dê preferência em utilizar a Numeração Única (CNJ)', div);
	}
	
	// Responsável por criar os campos referentes a =============
	// informação Gerencial ou Oficial  
	function criarCampoOficialGerencial(){
		 
		 // Declaração de Variáveis ----------------------
		 var div = 'divTipoOrgao';
		 var ddl = 'ddlTipoOrgao';
		 var lbl = 'lblTipoOrgao';
		 var arrTipoOrgao = new Array(2);
		 
		 // Implementação ---------------------------------
		 
		 // Inicialização de variáveis
		 arrTipoOrgao[0] = new Array(1)
		 arrTipoOrgao[1] = new Array(1)            
		 arrTipoOrgao[0][0] = gStr_Oficial;
		 arrTipoOrgao[1][0] = gStr_Gerencial;
		 
		 // Criação da div gerencial ou oficial
		 criarDiv(div, '', 'box');
		 
		 // Criação do Label Orgão
		 criarLabel(lbl, 'Tipo de Orgão', div);
		 
		 // Criação do 'SELECT' apenas com um item default.
		 criarSelect(ddl, false, arrTipoOrgao, '0', '0', div, false);
		 
		 // Criação do evento que será disparado ao selecionar item.
		 criarEventoOnChange(ddl);   
		 
		 // Iniciar o evento
		 onChange(jq("#"+ddl));
	}
	
	// Responsavel pela retornar todos os orgão ativos =============
	// do webservice da Snap. 
	function obtemTodosOrgaosOficiais(){   
			
		// Implementação --------------------------------
		jq.ajax({
			  type       : "POST",
			  url        : gStr_WebService + "/obtemTodosOrgaosOficiais",
			  data       : "{}",
			  contentType: "application/json; charset=utf-8",
			  dataType   : "json",
			  async      : false,
			  success    : function(jsonResult) {
				  
				  // Cria campo 'SELECT' com o conteúdo dos orgãos 
				  if (jsonResult.d != null)
					  criarOrgaoOficial(jsonResult.d);
			  },
			   error: function(e) {
				alert("Não foi possível criar os órgãos oficiais. Contacte a LDSoft.");
			}	  
		  });
	}
	
	// Responsavel pela retornar todos os orgão gerenciais, ou seja =============
	// os orgãos criados pelo usuario do contenciso. 
	function obtemTodosOrgaosGerenciais(){   

		// Implementação --------------------------------
		jq.ajax({
			  type       : "POST",
			  url        : gStr_WebService + "/obtemTodosOrgaosGerenciais",
			  data       : "{'vStr_Usuario':'"+gStr_Usuario+"'}",
			  contentType: "application/json; charset=utf-8",
			  dataType   : "json",
			  async      : false,
			  success    : function(jsonResult) {
				  
				  // Cria campo 'SELECT' com o conteúdo dos orgãos 
				  if (jsonResult.d != null)
					  criarOrgaoGerencial(jsonResult.d);
			  },
			   error: function(e) {
				alert("Não foi possível criar os órgãos gerenciais. Contacte a LDSoft.");
			}	  
		  });
	}
	
	// Responsável por criar os campos referentes a Orgãos ===========
	function criarOrgaoGerencial(vOrgaoGE){
		 
		 // Declaração de Variáveis ----------------------
		 var div     = 'divOrgao';
		 var ddl     = 'ddlOrgao';
		 var lbl     = 'lblOrgao';
		 var divProc = 'divProcesso';
		 var lblProc = 'txtProcesso';
		 var txtProc = 'lblProcesso';
		 var spnProc = 'spnProcesso';
		 
		 // Implementação ---------------------------------
	 
		 // Criação da div Orgão
		 criarDiv(div, '', 'box');
		 
		 // Criação do Label Orgão
		 criarLabel(lbl, 'Órgãos', div);
		 
		 // Criação do 'SELECT' apenas com um item default.
		 criarSelect(ddl, true, vOrgaoGE, 'codigo', 'descricao', div, false);        
					  
		 // Criação da div Orgão
		 criarDiv(divProc, '', 'box');
		 
		 // Criação do Label Orgão
		 criarLabel(lblProc, 'Número', divProc);
		 
		 // Criação de um novo textbox da tela.
		 criarTextBox(txtProc, '', 1, 30, 'false', divProc);    
		 
		 // Criação de um novo Span da tela.
		 criarSpan(spnProc, '(1 a 30 dígitos)', divProc);    
	}
	
	// Responsável por criar os campos referentes a Orgãos ===========
	function criarOrgaoOficial(vOrgaoVO){
		 
		 // Declaração de Variáveis ----------------------
		 //var div2 = 'divDependencia';
		 var div = 'divOrgao';
		 var ddl = 'ddlOrgao';
		 var lbl = 'lblOrgao';
		 var lblAjuda = 'lblAjuda';
		 
		 // Implementação ---------------------------------  
		 
		 // Criação da Div Orgão
		  criarDiv(div, '', 'box');
		  
		 // Criação do Label Orgão
		 criarLabel(lbl, 'Órgãos', div);
		 
		 // Criação do 'SELECT' apenas com um item default.
		 criarSelect(ddl, true, vOrgaoVO, 'id', 'nome', div, false);
		 
		 // Criação do span ajuda quer será utilizado com o link de 
		 // como preencher o orgão selecionado em tela.
		 criarSpan(lblAjuda, '', div);
		 
		  // Criação da Div Orgão
		  //criarDiv(div2, '', div);
		 
		 // Criação do evento que será disparado ao selecionar item.
		 criarEventoOnChange(ddl);
	}
	
	// Responsável pela ação de mudança de item do  ===================
	// 'SELECT' na tela. Além disso, separa a logica do 
	// campo SELECT de orgãos dos outros SELECTs 
	function onChange(element)
	{
	  // Declaração de variáveis --------------
	  var linkSnap;
         
	  element.prop('disabled', true);
	  
	  // Implementação -------------------------  		  
	  if (element.get(0).id == 'ddlTipoOrgao')
	  {
		  jq("#box > div").each( function(index, field) {
			 if (field.id != 'divTipoOrgao')
				jq(field).remove();
		  });
		  
		  jq("#divMsgCNJ").remove();
		  if (jq("#ddlTipoOrgao option:selected").val() == gStr_Oficial)
		  {  
			 // Obtem os todos orgãos do WS da snap.
			 criarMsgPreferencia();
			 obtemTodosOrgaosOficiais();
		  }
		  else
		  {
			 // Obtem os orgãos gerenciais gravados pelo usuario
			 obtemTodosOrgaosGerenciais();
		  }    
						
	  }
	  // Logica para o campo SELECT orgãos.
	  else if (element.get(0).id == 'ddlOrgao')
	  {
		  //jq("#divDependencia").empty();
		  // Limpar todos os divs após SELECT de orgãos
		  jq("#box > div").each( function(index, field) {
			 if (field.id != 'divOrgao' && field.id != 'divTipoOrgao')
			 {
				jq(field).remove();
			 }
		  });
		  
		  // Limpa ajuda de tela
		  jq("#lblAjuda").empty();
		  
		  jq.ajax({
				type       : "POST",
				url        : gStr_WebService + "/obtemDependenciaOrgao",
				data       : "{'vStr_Orgao':'"+jq("#ddlOrgao option:selected").val()+"'}",
				contentType: "application/json; charset=utf-8",
				dataType   : "json",
				async      : false,
				success    : function(jsonResult) {
				
					 if (jsonResult.d.chave != null)
					 {                 
						 // Cria o link de como preencher do SELECT orgãos.
						 linkSnap = 'http://www.snap.com.br/pub/dtv2/' + jsonResult.d.comoPreencher;
						 jq("#lblAjuda").html('  <div id="divAjuda"><a href="' + linkSnap + '" target="_blank"> Ajuda </a></div>');
						 
						 // Cria a primeira somente a dependência. Nesse caso, é importante 
						 // retornar somente o primeiro item da lista de campos do xml.
						 var ddlDependencia = criarCampo(jsonResult.d.campos[0]);    
						 
						 // Faz com que as outras dependencias sejam criadas a partir da primeira 
						 // que foi criada anteriormente. 
						 onChange(jq("#"+ddlDependencia));
					 }
				 }
		  });
	  }
	  else // Logica para outros SELECTs
	  {
		  // Criar as demais dependencias quando o SELECT for modificado
		  // Válido para todos os SELECTs na tela.
		  carregaDependencias(element);
	  }
	  
	  element.prop('disabled', false);
	  element.focus();		  
	}
	
	// Responsável por criar a chave do processo que será =================
	// utilizado no contencioso de acordos com os itens 
	// que foram preenchidos em tela será. 
	function montaChave()
	{
		// Inicialização de variáveis
		var lStr_NovaChave = '';
		
		// Percorre os selects e inputs preenchidos em tela para 
		// criação da chave.
		jq('#box select, #box input').each(function() {
			// Valida 'SELECT'
			if (jq(this).get(0).tagName == 'SELECT')
			{
			  if (jq("#" + jq(this).get(0).id + " option:selected").val() == '' ||
				  jq("#" + jq(this).get(0).id + " option:selected").val() == -1) {
				  alert('Favor preencher todas as listas da tela.'); 
				  jq(this).focus();
				  lStr_NovaChave = '';
				  return false;
			  }
			  else if (jq(this).get(0).id == 'ddlOrgao' && 
					  jq("#" + jq(this).get(0).id + " option:selected").attr('data-sigla') != null)
				 lStr_NovaChave = jq("#" + jq(this).get(0).id + " option:selected").attr('data-sigla') + '|' + jq("#" + jq(this).get(0).id + " option:selected").text() + '|';
			  else if (jq(this).get(0).id != 'ddlOrgao')
				 lStr_NovaChave += '.' + jq("#" + jq(this).get(0).id + " option:selected").val();
			}
			
			// Valida 'INPUT' do tipo text  
			if (jq(this).get(0).tagName == 'INPUT' && jq(this).get(0).type == 'text')
			{
			  if (jq(this).val() == '' && jq(this).attr('data-minimo') > 0){
				  alert('Favor preencher todos os campos de textos da tela.'); 
				  jq(this).focus();
				  lStr_NovaChave = '';
				  return false;
			  }
			  else if (jq(this).val().length < jq(this).attr('data-minimo')){
			      if (jq(this).attr('data-minimo') == 1)
				     alert('Favor preencher a quantidade mínima de ' + jq(this).attr('data-minimo') + ' posição.'); 
				  else
				     alert('Favor preencher a quantidade mínima de ' + jq(this).attr('data-minimo') + ' posições.'); 
				  jq(this).focus();
				  lStr_NovaChave = '';
				  return false;
			  }
			  else if (jq(this).val() == '' && jq(this).attr('data-numerico')=='true')
			  {
				 var zeros = "0000000000000000000";
		
				 lStr_NovaChave += '.' + zeros.slice(-jq(this).attr('data-maximo'));
			  }
			  else
				 lStr_NovaChave += '.' + jq(this).val();
			}
		});
	   
		// retorna a informação
		return lStr_NovaChave.toUpperCase().replace('|.','|').replace('.','|');
	}
	
	// Responsável por carregar as dependencias dos SELECT  ===========================
	// em tela baseado na regra do xml retornado do webservice
	function carregaDependencias(element)
	{
		jq.ajax({
			type       : "POST",
			url        : gStr_WebService + "/obtemDependenciaOrgao",
			data       : "{'vStr_Orgao':'"+jq("#ddlOrgao option:selected").val()+"'}",
			contentType: "application/json; charset=utf-8",
			dataType   : "json",
			async      : false,
			success    : function(jsonResult) {
								 
				// Recupera somente os numeros que condizem ao nome do campo
				var componente = element.get(0).id.replace(/[a-zA-Z]/gi, '')        
			 
				// Necessário para limpar a dependencia apenas uma vez;
				booLimpaDependencia = true;
				
				// Percorre todos os campos que estão na dependência do orgão;
				// Isso é necessário pois não temos o objeto orgão na tela, somente
				// o campo SELECT com informação de id e texto.
				for(i=1; i < jsonResult.d.campos.length; i++)
				{ 
				   // Recupera somente os numeros que condizem ao nome do campo
				   var campo = jsonResult.d.campos[i].chave.replace(/[a-zA-Z]/gi, '')
				   
				   // Verifica se o componente está depois do atual e então apaga.
				   if (campo > componente)
				   {
					  // Verifica a não existência dependência e se o elemento
					  // é o mesmo do objeto percorrido.
					  if (jsonResult.d.campos[i].dependencia == null && 
						  !(element.get(0).id == jsonResult.d.campos[i].chave))
					  {
						 // Limpa todas as dependencias
						 limparDependencia(element.get(0).id);
						 
						 // Cria os campos de dependÊncia
						 criarCampo(jsonResult.d.campos[i]);
					  }
					  // Valida a existência de dependência e se o campo é o mesmo 
					  // que o informado na referência do objeto.
					  else if (jsonResult.d.campos[i].dependencia != null && 
							   element.get(0).id == jsonResult.d.campos[i].dependencia.referencia)
					  {
						 // Recupera as informações de valores do objeto
						 var valores = jsonResult.d.campos[i].dependencia.valores;
						 var valida = false;
						 
						 // Percorre se pelo menos um item do objeto é o mesmo do componente.
						 for (j = 0; j < valores.length; j++)
						 {
							if (valores[j] == element.get(0).value)
								valida = true;
						 }
						 
						 if (valida)
						 {
							// Limpa todas as dependencias
							limparDependencia(element.get(0).id);
							
							// Cria os campos de dependÊncia
							criarCampo(jsonResult.d.campos[i]);
						 }
					  }
				   }
				}         
			}
		});
	}
	
	// Responsavel por limpar toos os DIVs de tela =======================
	// a partir do SELECT informado
	function limparDependencia(vElement){
		
		// Importante para saber se existe dependencia
		if (booLimpaDependencia)
		{
			booLimpaDependencia = false;
			
			// Recupera somente os numeros que condizem ao nome do campo
			var componente = vElement.replace(/[a-zA-Z]/gi, '')

			// Percorre os divs posteriores ao div do elemento passado p/ param.
			jq("#box > div").each( function(index, field) {
						   
			   if (field.id.substring(3,6) == vElement.substring(0,3))
			   {
				   // Recupera somente os numeros que condizem ao nome do campo
				   var campotela = field.id.replace(/[a-zA-Z]/gi, '');
				 
				   // Verifica se o componente está depois do atual e então apaga.
				   if (campotela > componente)
				   {
					 jq(field).remove()
				   }                        
			   }                           
			});
		}
	}
	
	// Responsavel por criar o evento ao selecionar ======================
	// um item do 'SELECT'
	function criarEventoOnChange(componente){
	   
	   jq("#"+componente).change(function() {
		  onChange(jq("#"+componente));
	   });
	}
	
	// Responsavel por criar nova 'DIV' na tela ==========================
	function criarDiv(divNome, texto, div){
	
		var novaDiv = '<div id="' + divNome + '">' + texto + '</div>'
	
		jq("#"+div).append(novaDiv);
	}
	
	// Responsavel por criar novo 'LABEL' na tela ========================
	function criarLabel(id, texto, div){
		
		var lbl = '<label for="'+id+'">'+texto+': </label>'; 
		
		jq("#"+div).append(lbl);
	}
	
	// Responsavel por criar novo 'SELECT' na tela =======================
	function criarSelect(id, selecionarItem, conteudo, idOption, textoOption, div, ehTipoConsulta){
		
		// Declaração de variáveis
		var siglaOrgao = '';
		var ddl = '<select id="'+id+'">';
			
		// Indica que o SELECT terá o primeiro item 'SELECIONAR ITEM'
		if (selecionarItem)
		   ddl += '<option value="-1">'+gStrSelectItem+'</option>';
		
		for(y=0; y < conteudo.length; y++)
		{ 
		   siglaOrgao = '';
		   tipoConsulta = '';
		   
		   // Recupera o nome reduzido do orgão, quando existir. Ex.: TJRJ
		   if (conteudo[y].sigla != null)
			   siglaOrgao = conteudo[y].sigla;
		   
		   //  Esse caso só irá ocorrer para o tipo consulta com sigla na frente ex.: NJ - Numeração Unica
		   if (ehTipoConsulta && conteudo[y][idOption] != null)
			   tipoConsulta = conteudo[y][idOption] + ' - ';
			
			if (siglaOrgao != "INPI"){
				if (conteudo[y][textoOption] != '{Sem Descrição}') {
		   			ddl += '<option value="'+conteudo[y][idOption]+'" data-sigla="'+ siglaOrgao +'">'+tipoConsulta+conteudo[y][textoOption]+'</option>';
				}
			}
		}
		   
		ddl += '</select>';
		   
		jq("#"+div).append(ddl);
	}
		  
	// Responsavel por criar novo 'INPUT' do tipo 'TEXT' =================
	// na tela com um valor mínimo perminido.
	function criarTextBox(id, texto, minimo, maximo, numerico, div){
	
		var txt = '<input type="text" data-minimo="'+minimo+'" maxlength="'+maximo+'" data-numerico="'+numerico+'" name="'+id+'" value=""/>';
	
		jq("#"+div).append(txt);
	}
	
	// Responsavel por criar novo 'SPAN' na tela ==========================
	function criarSpan(id, texto, div){
	
		var spn = '<span id="'+id+'">' + texto + '</span>';
		//var spn = texto;
	
		jq("#"+div).append(spn);
	}
	
	// Responsável pela criação de campos na tela. ========================
	// Essa função gerencia o que deve ser textbox ou select
	function criarCampo(vCampoVO){
				
		// Declaração de Variáveis ----------------
		var campoVO = vCampoVO;
		var txt = 'txt' + campoVO.chave;
		var lbl = 'lbl' + campoVO.chave;
		var div = 'div' + campoVO.chave;
		var opt = 'opt' + campoVO.chave;
		var spn = 'spn' + campoVO.chave;
		var ddl = campoVO.chave; 
		
		var mascara = '';
		var titulo = '';
		var create = '';
		var qtdDigitos = '';
		
		
		// Implementação --------------------------
		// Criação de nova div dentro da div box
		criarDiv(div, '', 'box');
		
		// Criação de nova label dentro da div criada anteriormente.
		criarLabel(lbl, campoVO.nome, div);
		
		
		// Verifica se existe OPÇÕES para criação de um 'SELECT'
		if (campoVO.opcoes != null)
		{
		   // Criação de um novo select com o conteudo das OPÇÕES
		   criarSelect(ddl, false, campoVO.opcoes, 'valor', 'descricao', div, true);
		
		   // Criação do evento change para o select recém criado.
		   criarEventoOnChange(ddl);
		}
		else // Direcionamento para criação de textbox já que não existe OPÇÕES.
		{
			// Valida existencia de alguma máscara.
			if (campoVO.mascara != '')
			{
				// Permite apenas números. Devido a máscara numérica do jquery é 
				// necessário substituir os campos númericos para 9.
				mascara = campoVO.mascara.replace(/[0-9]/gi, '9');
			   
				// Permite qualquer caracter. Devido a máscara do jquery é 
				// necessário substitui os campos para *
				mascara = mascara.replace(/[A-Z]/gi, '*');
			} 
			else // Para a não existência de máscara montaremos a regra para aceitar
			{    // numeros ou alpha numérios além de valor mínimo e máximo p/ c/ campo.
							 
				if (campoVO.numerico == true)
				{
					// Define o que é numerico e obrigatório. Regra da máscara:
					// (9)Numérico, (*)Alpha, (a)Letras e (?) Campos obrigatórios deste ponto para traz.
					// Ex. 99?9* - 1º e 2º númericos e obrigatórios, 3º numérico e 4º alpha.
					for (cont = 1; cont <= campoVO.maxLen; cont++) 
					{  
						mascara = mascara + '9';
						   
						if (cont == campoVO.minLen)
						   mascara = mascara + '?';
					}
				}
				
				// Atenção: Regra de INFORMAÇÃO na tela de tamanho minimo e máximo 
				// dos campos. Ex.: (1 a 10) digitos
				qtdDigitos = ' (' + campoVO.minLen;
				
				if (campoVO.minLen != campoVO.maxLen)
					qtdDigitos = qtdDigitos + ' a ' + campoVO.maxLen;
				
				if (campoVO.numerico == true)
				   qtdDigitos = qtdDigitos + ' número';
				else
				   qtdDigitos = qtdDigitos + ' dígito';
				   
				if (campoVO.maxLen > 1)
				   qtdDigitos = qtdDigitos + 's';
											
				qtdDigitos = qtdDigitos + ')';                    
			 }                
			
			// Criação de um novo textbox da tela.
			criarTextBox(txt, '', campoVO.minLen, campoVO.maxLen, campoVO.numerico, div);
			
			// Criação de um novo Span da tela.
			criarSpan(spn, qtdDigitos ,div);
			
			// Se existir mascará então cria o jquery.
			if (mascara != '' && campoVO.mascara != '')
			   jq('input[name=txt'+campoVO.chave+']').mask(mascara);
			else if (mascara != '' && campoVO.mascara == '')
			   jq('input[name=txt'+campoVO.chave+']').mask(mascara,{placeholder:" "});
		}
		
		return ddl;
	}
</script>    
<body>
    <div id="divDialog" title="Criação do Número do Processo">
        <fieldset id="fsArea" style="border: 0px;">
            <div id="area">
                 <div id="box">
                 </div>

            </div>
        </fieldset>
    </div>
</body>
</html>