<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<script type="text/javascript">
    
	// Declara��o de vari�veis globais =============================
	var booLimpaDependencia = true;
	var gStrSelectItem  = '---- Selecione um Item ----';
	var gStr_Oficial    = 'Oficial';
	var gStr_Gerencial  = 'Gerencial';
	var gStr_WebService = '<%=url_base()%>/utilitarios/ServicoIsis/ServicoIsis.asmx';
	var gStr_Usuario    = '<%= session("vinculado") %>';
	
	// Respons�vel por abrir o popup como dialog
	// NroProcesso =  Nome da input hidden que receber� numero do processo.
	// comboOrgao    =  Nome da combo que receber� o Org�o Gerencial.
	// campoTribunal =  Nome da input hidden que receber� o Org�o Oficial.
	function abrirPopup(NroProcesso, comboOrgao, campoTribunal, tipoConsulta)
	{
        // Pega o nome do servi�o
		gStr_WebService = gStr_WebService.replace('nomedoservidor', '<%= servidor %>');		
		//alert(gStr_WebService);
		jq('#box').empty();
		
		 // Obtem os todos org�os do WS da snap.
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
					   // Apenas cria o processo e pasta no robot, por�m n�o copia.
					   //var lStr_Erro = criaProcessoPasta(lStr_Chave);
					
					   //if (lStr_Erro == '')
					   //{	
						   // Valida se � o campo input e passa um valor para o numero do processo
						   if (jq('input[name="'+ NroProcesso+'"]').length > 0)
						   {
							  if (isNaN(codigo)){
								jq('input[name="' + NroProcesso+ '"]').val(lStr_Chave.split('|')[3]);
							  }else{
								jq('input[name="' + NroProcesso+ '"]').val(lStr_Chave.split('|')[2]);
							  }
							  jq('input[name="' + NroProcesso+ '"]').css('display','');
						   }
												   
						   // Valida se � o campo label e passa um valor para o numero do processo
						   if (jq('label[for="'+ NroProcesso+'"]').length > 0)
							  jq('label[for="' + NroProcesso+ '"]').text(lStr_Chave.split('|')[3]);

							// Valida se � numerico
							if (codigo.replace(/[0-9]/gi, '') == '')
								sigla  = '';
							else
								codigo = '';
						   
						   jq('input[name="' + NroProcesso+ '"]').attr('maxlength','35');
						   if (codigo != ''){
								jq('input[name="' + NroProcesso+ '"]').attr('maxlength','30');
						   }
						   
						   // Valida se � o campo SELECT e grava o ID do org�o gerencial junto com o nome do org�o
						   jq('input[name="forgao_c"]').val(codigo);
						   jq("#" + comboOrgao)
							.empty()
							.append('<option title="' + lStr_Chave.split('|')[1] + '" selected value="'+codigo+'">'+lStr_Chave.split('|')[1]+'</option>');
						   
						   
						   // Valida se � o campo � input e grava a SIGLA do org�o oficial junto com o nome do org�o
						   if (jq('input[name="'+ campoTribunal +'"]').length > 0)
							   jq('input[name="' + campoTribunal + '"]').val(sigla);

						   // Valida se � o campo input e passa um valor para o tipo da consulta
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
					jq( this�).dialog('close');
				}
			}
		});
	}
	
	function criarMsgPreferencia(){
		 
		 // Declara��o de Vari�veis ----------------------
		 var div = 'divMsgCNJ';
		 var ddl = 'ddlTipoOrgao';
		 var spn = 'spnMsg';
		 var arrTipoOrgao = new Array(2);
		 
		 // Implementa��o ---------------------------------
		 
		 // Cria��o da div gerencial ou oficial
		 criarDiv(div, '', 'area');
		 
		 // Cria��o do Label Org�o
		 criarSpan(div, '* D� prefer�ncia em utilizar a Numera��o �nica (CNJ)', div);
	}
	
	// Respons�vel por criar os campos referentes a =============
	// informa��o Gerencial ou Oficial  
	function criarCampoOficialGerencial(){
		 
		 // Declara��o de Vari�veis ----------------------
		 var div = 'divTipoOrgao';
		 var ddl = 'ddlTipoOrgao';
		 var lbl = 'lblTipoOrgao';
		 var arrTipoOrgao = new Array(2);
		 
		 // Implementa��o ---------------------------------
		 
		 // Inicializa��o de vari�veis
		 arrTipoOrgao[0] = new Array(1)
		 arrTipoOrgao[1] = new Array(1)            
		 arrTipoOrgao[0][0] = gStr_Oficial;
		 arrTipoOrgao[1][0] = gStr_Gerencial;
		 
		 // Cria��o da div gerencial ou oficial
		 criarDiv(div, '', 'box');
		 
		 // Cria��o do Label Org�o
		 criarLabel(lbl, 'Tipo de Org�o', div);
		 
		 // Cria��o do 'SELECT' apenas com um item default.
		 criarSelect(ddl, false, arrTipoOrgao, '0', '0', div, false);
		 
		 // Cria��o do evento que ser� disparado ao selecionar item.
		 criarEventoOnChange(ddl);   
		 
		 // Iniciar o evento
		 onChange(jq("#"+ddl));
	}
	
	// Responsavel pela retornar todos os org�o ativos =============
	// do webservice da Snap. 
	function obtemTodosOrgaosOficiais(){   
			
		// Implementa��o --------------------------------
		jq.ajax({
			  type       : "POST",
			  url        : gStr_WebService + "/obtemTodosOrgaosOficiais",
			  data       : "{}",
			  contentType: "application/json; charset=utf-8",
			  dataType   : "json",
			  async      : false,
			  success    : function(jsonResult) {
				  
				  // Cria campo 'SELECT' com o conte�do dos org�os 
				  if (jsonResult.d != null)
					  criarOrgaoOficial(jsonResult.d);
			  },
			   error: function(e) {
				alert("N�o foi poss�vel criar os �rg�os oficiais. Contacte a LDSoft.");
			}	  
		  });
	}
	
	// Responsavel pela retornar todos os org�o gerenciais, ou seja =============
	// os org�os criados pelo usuario do contenciso. 
	function obtemTodosOrgaosGerenciais(){   

		// Implementa��o --------------------------------
		jq.ajax({
			  type       : "POST",
			  url        : gStr_WebService + "/obtemTodosOrgaosGerenciais",
			  data       : "{'vStr_Usuario':'"+gStr_Usuario+"'}",
			  contentType: "application/json; charset=utf-8",
			  dataType   : "json",
			  async      : false,
			  success    : function(jsonResult) {
				  
				  // Cria campo 'SELECT' com o conte�do dos org�os 
				  if (jsonResult.d != null)
					  criarOrgaoGerencial(jsonResult.d);
			  },
			   error: function(e) {
				alert("N�o foi poss�vel criar os �rg�os gerenciais. Contacte a LDSoft.");
			}	  
		  });
	}
	
	// Respons�vel por criar os campos referentes a Org�os ===========
	function criarOrgaoGerencial(vOrgaoGE){
		 
		 // Declara��o de Vari�veis ----------------------
		 var div     = 'divOrgao';
		 var ddl     = 'ddlOrgao';
		 var lbl     = 'lblOrgao';
		 var divProc = 'divProcesso';
		 var lblProc = 'txtProcesso';
		 var txtProc = 'lblProcesso';
		 var spnProc = 'spnProcesso';
		 
		 // Implementa��o ---------------------------------
	 
		 // Cria��o da div Org�o
		 criarDiv(div, '', 'box');
		 
		 // Cria��o do Label Org�o
		 criarLabel(lbl, '�rg�os', div);
		 
		 // Cria��o do 'SELECT' apenas com um item default.
		 criarSelect(ddl, true, vOrgaoGE, 'codigo', 'descricao', div, false);        
					  
		 // Cria��o da div Org�o
		 criarDiv(divProc, '', 'box');
		 
		 // Cria��o do Label Org�o
		 criarLabel(lblProc, 'N�mero', divProc);
		 
		 // Cria��o de um novo textbox da tela.
		 criarTextBox(txtProc, '', 1, 30, 'false', divProc);    
		 
		 // Cria��o de um novo Span da tela.
		 criarSpan(spnProc, '(1 a 30 d�gitos)', divProc);    
	}
	
	// Respons�vel por criar os campos referentes a Org�os ===========
	function criarOrgaoOficial(vOrgaoVO){
		 
		 // Declara��o de Vari�veis ----------------------
		 //var div2 = 'divDependencia';
		 var div = 'divOrgao';
		 var ddl = 'ddlOrgao';
		 var lbl = 'lblOrgao';
		 var lblAjuda = 'lblAjuda';
		 
		 // Implementa��o ---------------------------------  
		 
		 // Cria��o da Div Org�o
		  criarDiv(div, '', 'box');
		  
		 // Cria��o do Label Org�o
		 criarLabel(lbl, '�rg�os', div);
		 
		 // Cria��o do 'SELECT' apenas com um item default.
		 criarSelect(ddl, true, vOrgaoVO, 'id', 'nome', div, false);
		 
		 // Cria��o do span ajuda quer ser� utilizado com o link de 
		 // como preencher o org�o selecionado em tela.
		 criarSpan(lblAjuda, '', div);
		 
		  // Cria��o da Div Org�o
		  //criarDiv(div2, '', div);
		 
		 // Cria��o do evento que ser� disparado ao selecionar item.
		 criarEventoOnChange(ddl);
	}
	
	// Respons�vel pela a��o de mudan�a de item do  ===================
	// 'SELECT' na tela. Al�m disso, separa a logica do 
	// campo SELECT de org�os dos outros SELECTs 
	function onChange(element)
	{
	  // Declara��o de vari�veis --------------
	  var linkSnap;
���������
	  element.prop('disabled', true);
	  
	  // Implementa��o -------------------------  		  
	  if (element.get(0).id == 'ddlTipoOrgao')
	  {
		  jq("#box > div").each( function(index, field) {
			 if (field.id != 'divTipoOrgao')
				jq(field).remove();
		  });
		  
		  jq("#divMsgCNJ").remove();
		  if (jq("#ddlTipoOrgao option:selected").val() == gStr_Oficial)
		  {  
			 // Obtem os todos org�os do WS da snap.
			 criarMsgPreferencia();
			 obtemTodosOrgaosOficiais();
		  }
		  else
		  {
			 // Obtem os org�os gerenciais gravados pelo usuario
			 obtemTodosOrgaosGerenciais();
		  }    
						
	  }
	  // Logica para o campo SELECT org�os.
	  else if (element.get(0).id == 'ddlOrgao')
	  {
		  //jq("#divDependencia").empty();
		  // Limpar todos os divs ap�s SELECT de org�os
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
						 // Cria o link de como preencher do SELECT org�os.
						 linkSnap = 'http://www.snap.com.br/pub/dtv2/' + jsonResult.d.comoPreencher;
						 jq("#lblAjuda").html('  <div id="divAjuda"><a href="' + linkSnap + '" target="_blank"> Ajuda </a></div>');
						 
						 // Cria a primeira somente a depend�ncia. Nesse caso, � importante 
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
		  // V�lido para todos os SELECTs na tela.
		  carregaDependencias(element);
	  }
	  
	  element.prop('disabled', false);
	  element.focus();		  
	}
	
	// Respons�vel por criar a chave do processo que ser� =================
	// utilizado no contencioso de acordos com os itens 
	// que foram preenchidos em tela ser�. 
	function montaChave()
	{
		// Inicializa��o de vari�veis
		var lStr_NovaChave = '';
		
		// Percorre os selects e inputs preenchidos em tela para 
		// cria��o da chave.
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
				     alert('Favor preencher a quantidade m�nima de ' + jq(this).attr('data-minimo') + ' posi��o.'); 
				  else
				     alert('Favor preencher a quantidade m�nima de ' + jq(this).attr('data-minimo') + ' posi��es.'); 
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
	   
		// retorna a informa��o
		return lStr_NovaChave.toUpperCase().replace('|.','|').replace('.','|');
	}
	
	// Respons�vel por carregar as dependencias dos SELECT  ===========================
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
			 
				// Necess�rio para limpar a dependencia apenas uma vez;
				booLimpaDependencia = true;
				
				// Percorre todos os campos que est�o na depend�ncia do org�o;
				// Isso � necess�rio pois n�o temos o objeto org�o na tela, somente
				// o campo SELECT com informa��o de id e texto.
				for(i=1; i < jsonResult.d.campos.length; i++)
				{ 
				   // Recupera somente os numeros que condizem ao nome do campo
				   var campo = jsonResult.d.campos[i].chave.replace(/[a-zA-Z]/gi, '')
				   
				   // Verifica se o componente est� depois do atual e ent�o apaga.
				   if (campo > componente)
				   {
					  // Verifica a n�o exist�ncia depend�ncia e se o elemento
					  // � o mesmo do objeto percorrido.
					  if (jsonResult.d.campos[i].dependencia == null && 
						  !(element.get(0).id == jsonResult.d.campos[i].chave))
					  {
						 // Limpa todas as dependencias
						 limparDependencia(element.get(0).id);
						 
						 // Cria os campos de depend�ncia
						 criarCampo(jsonResult.d.campos[i]);
					  }
					  // Valida a exist�ncia de depend�ncia e se o campo � o mesmo 
					  // que o informado na refer�ncia do objeto.
					  else if (jsonResult.d.campos[i].dependencia != null && 
							   element.get(0).id == jsonResult.d.campos[i].dependencia.referencia)
					  {
						 // Recupera as informa��es de valores do objeto
						 var valores = jsonResult.d.campos[i].dependencia.valores;
						 var valida = false;
						 
						 // Percorre se pelo menos um item do objeto � o mesmo do componente.
						 for (j = 0; j < valores.length; j++)
						 {
							if (valores[j] == element.get(0).value)
								valida = true;
						 }
						 
						 if (valida)
						 {
							// Limpa todas as dependencias
							limparDependencia(element.get(0).id);
							
							// Cria os campos de depend�ncia
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
				 
				   // Verifica se o componente est� depois do atual e ent�o apaga.
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
		
		// Declara��o de vari�veis
		var siglaOrgao = '';
		var ddl = '<select id="'+id+'">';
			
		// Indica que o SELECT ter� o primeiro item 'SELECIONAR ITEM'
		if (selecionarItem)
		   ddl += '<option value="-1">'+gStrSelectItem+'</option>';
		
		for(y=0; y < conteudo.length; y++)
		{ 
		   siglaOrgao = '';
		   tipoConsulta = '';
		   
		   // Recupera o nome reduzido do org�o, quando existir. Ex.: TJRJ
		   if (conteudo[y].sigla != null)
			   siglaOrgao = conteudo[y].sigla;
		   
		   //  Esse caso s� ir� ocorrer para o tipo consulta com sigla na frente ex.: NJ - Numera��o Unica
		   if (ehTipoConsulta && conteudo[y][idOption] != null)
			   tipoConsulta = conteudo[y][idOption] + ' - ';
			
			if (siglaOrgao != "INPI"){
				if (conteudo[y][textoOption] != '{Sem Descri��o}') {
		   			ddl += '<option value="'+conteudo[y][idOption]+'" data-sigla="'+ siglaOrgao +'">'+tipoConsulta+conteudo[y][textoOption]+'</option>';
				}
			}
		}
		   
		ddl += '</select>';
		   
		jq("#"+div).append(ddl);
	}
		  
	// Responsavel por criar novo 'INPUT' do tipo 'TEXT' =================
	// na tela com um valor m�nimo perminido.
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
	
	// Respons�vel pela cria��o de campos na tela. ========================
	// Essa fun��o gerencia o que deve ser textbox ou select
	function criarCampo(vCampoVO){
				
		// Declara��o de Vari�veis ----------------
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
		
		
		// Implementa��o --------------------------
		// Cria��o de nova div dentro da div box
		criarDiv(div, '', 'box');
		
		// Cria��o de nova label dentro da div criada anteriormente.
		criarLabel(lbl, campoVO.nome, div);
		
		
		// Verifica se existe OP��ES para cria��o de um 'SELECT'
		if (campoVO.opcoes != null)
		{
		   // Cria��o de um novo select com o conteudo das OP��ES
		   criarSelect(ddl, false, campoVO.opcoes, 'valor', 'descricao', div, true);
		
		   // Cria��o do evento change para o select rec�m criado.
		   criarEventoOnChange(ddl);
		}
		else // Direcionamento para cria��o de textbox j� que n�o existe OP��ES.
		{
			// Valida existencia de alguma m�scara.
			if (campoVO.mascara != '')
			{
				// Permite apenas n�meros. Devido a m�scara num�rica do jquery � 
				// necess�rio substituir os campos n�mericos para 9.
				mascara = campoVO.mascara.replace(/[0-9]/gi, '9');
			   
				// Permite qualquer caracter. Devido a m�scara do jquery � 
				// necess�rio substitui os campos para *
				mascara = mascara.replace(/[A-Z]/gi, '*');
			} 
			else // Para a n�o exist�ncia de m�scara montaremos a regra para aceitar
			{    // numeros ou alpha num�rios al�m de valor m�nimo e m�ximo p/ c/ campo.
							 
				if (campoVO.numerico == true)
				{
					// Define o que � numerico e obrigat�rio. Regra da m�scara:
					// (9)Num�rico, (*)Alpha, (a)Letras e (?) Campos obrigat�rios deste ponto para traz.
					// Ex. 99?9* - 1� e 2� n�mericos e obrigat�rios, 3� num�rico e 4� alpha.
					for (cont = 1; cont <= campoVO.maxLen; cont++) 
					{  
						mascara = mascara + '9';
						   
						if (cont == campoVO.minLen)
						   mascara = mascara + '?';
					}
				}
				
				// Aten��o: Regra de INFORMA��O na tela de tamanho minimo e m�ximo 
				// dos campos. Ex.: (1 a 10) digitos
				qtdDigitos = ' (' + campoVO.minLen;
				
				if (campoVO.minLen != campoVO.maxLen)
					qtdDigitos = qtdDigitos + ' a ' + campoVO.maxLen;
				
				if (campoVO.numerico == true)
				   qtdDigitos = qtdDigitos + ' n�mero';
				else
				   qtdDigitos = qtdDigitos + ' d�gito';
				   
				if (campoVO.maxLen > 1)
				   qtdDigitos = qtdDigitos + 's';
											
				qtdDigitos = qtdDigitos + ')';                    
			 }                
			
			// Cria��o de um novo textbox da tela.
			criarTextBox(txt, '', campoVO.minLen, campoVO.maxLen, campoVO.numerico, div);
			
			// Cria��o de um novo Span da tela.
			criarSpan(spn, qtdDigitos ,div);
			
			// Se existir mascar� ent�o cria o jquery.
			if (mascara != '' && campoVO.mascara != '')
			   jq('input[name=txt'+campoVO.chave+']').mask(mascara);
			else if (mascara != '' && campoVO.mascara == '')
			   jq('input[name=txt'+campoVO.chave+']').mask(mascara,{placeholder:" "});
		}
		
		return ddl;
	}
</script>    
<body>
    <div id="divDialog" title="Cria��o do N�mero do Processo">
        <fieldset id="fsArea" style="border: 0px;">
            <div id="area">
                 <div id="box">
                 </div>

            </div>
        </fieldset>
    </div>
</body>
</html>