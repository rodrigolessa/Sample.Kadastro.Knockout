function Perfil(data) {
    this.Id = ko.observable(data.Id);
    this.Descricao = ko.observable(data.Descricao);
}

// This is a simple *viewmodel* - JavaScript that defines the data and behavior of your UI
function ManterUsuarioViewModel()
{
	var self = this;

    self.lblTitulo = ko.observable("Nova conta");
    self.txtBotaoSalvar = ko.observable("Salvar conta");

    self.Login = ko.observable();
    self.Senha = ko.observable();
    self.ConfirmaSenha = ko.observable();
    self.Nome = ko.observable();
    self.Email = ko.observable();
    self.Perfis = ko.observableArray([]);
    self.usuario = ko.observable();

    // Load initial state from server, convert it to "Perfil" instances, then populate self.Perfis
    $.getJSON("http://localhost/kadastronet/KadastroServiceHost.svc/ListarPerfisDeAcesso", function(allData) {
        var mappedPerfis = $.map(allData.ListarPerfisDeAcessoResult, function(item) { return new Perfil(item) });
        self.Perfis(mappedPerfis);
    }); //getJSON

    self.salvar = function() {

        // Ativando bloqueio de tela
        /////////////////////////////////////////
        $.blockUI({
            message: 'Processando...<br /><img src="img/ajax-loader.gif" border="0">', // Refatorar para remover HTML
            css: {
                border: 'none',
                padding: '15px',
                backgroundColor: '#000',
                '-webkit-border-radius': '10px',
                '-moz-border-radius': '10px',
                opacity: .5,
                color: '#fff'
            } 
        });


        // Desativando bloqueio por tempo
        setTimeout($.unblockUI, 2000);
    } //self.salvar

} //ManterUsuarioViewModel

// Activates knockout.js
ko.applyBindings(new ManterUsuarioViewModel());