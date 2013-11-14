// This is a simple *viewmodel* - JavaScript that defines the data and behavior of your UI
function CadastrarPonto(prmDia, prmEntrada, prmSaida) {

	var selff = this;
	selff.dia = prmDia;
	selff.entrada = prmEntrada;
	selff.saida = prmSaida;
}

function IndexViewModel() {

	var self = this;
    
    //self.lblLead = ko.observable('Controle Manual:');
    self.lblDia = ko.observable('Hoje');

    //var now = new Date();
    //var h = now.getHours();
    //var m = now.getMinutes();
    self.dia = new Date();
    var h = self.dia.getHours();
    var m = self.dia.getMinutes();

    if(m>10)
    	m-=10;
    else
    	m=0;

    //self.dia = now.getFullYear() + '-' + now.getMonth() + '-' + now.getDay();
    self.txtEntrada = ko.observable(h+':'+m);
    self.txtSaída = ko.observable(h+':'+m);

    self.txtBotaoSalvar = ko.observable('Cadastrar');

    self.pontosDia = ko.observableArray([]);

    //Operations
    ////////////////////////////////////////////////////////////////////////////////////////

	self.addPonto = function() {

		var inputEntrada = self.txtEntrada;
		var inputSaida = self.txtSaída;

		self.pontosDia.push(new CadastrarPonto(self.dia, inputEntrada, inputSaida));

		self.txtEntrada = '';
		self.txtSaída = '';
	}

	self.removePonto = function(ponto) {
		self.pontosDia.remove(ponto);
	}

}

// Activates knockout.js
ko.applyBindings(new IndexViewModel());