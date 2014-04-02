function Usuario(data) 
{
    this.Id = data.Id
	this.Login = data.Login;
	this.Email = data.Email;
	this.Status = data.Status;
	this.DescricaoDoStatus = data.DescricaoDoStatus;
}

function ListarUsuarioViewModel()
{
	var self = this;

	self.tituloLista = "Usuários Cadastrados";

	self.cabecalhoLogin = "Login";
	self.cabecalhoEmail = "Email";
	self.cabecalhoDescricaoDoStatus = "Situação";

    self.usuarios = ko.observableArray([]);

    // Operations
    self.removeUsuario = function(usuario) {
		self.usuarios.remove(usuario);
    }

    // Load initial state from server, convert it to Task instances, then populate self.usuarios
    $.getJSON("http://localhost/kadastroNet/KadastroServiceHost.svc/ListarUsuarios/", function(allData) {
        var mappedUsuarios = $.map(allData.ListarUsuariosResult, function(item) { return new Usuario(item) });
        self.usuarios(mappedUsuarios);
    });
}

ko.applyBindings(new ListarUsuarioViewModel());