// This is a simple *viewmodel* - JavaScript that defines the data and behavior of your UI
function ManterUsuarioViewModel() 
{
	var self = this;
    self.lblTitulo = ko.observable("TESTE");
    self.Perfis = ko.observableArray([]);

	//var PayinyVM = {};

	//alert(self.Perfis);
    $.getJSON('http://localhost/kadastroNet/KadastroServiceHost.svc/ListarPerfisDeAcesso', function (data) {
    	alert('r');
        var tmp = JSON.stringify(data.d);

        self.Perfis = ko.mapping.fromJSON(tmp);
        //ko.applyBindings(PayinyVM);
    }); //getJSON
}

// Activates knockout.js
ko.applyBindings(new ManterUsuarioViewModel());