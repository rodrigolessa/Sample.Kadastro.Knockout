function ListarUsuarioViewModel()
{
	var self = this;

	self.tituloLista = "Usuários Cadastrados";

	self.cabecalhoNome = "Nome";
	self.cabecalhoEmail = "Email";
	self.cabecalhoDescricaoTipo = "Tipo";
	self.cabecalhoDescricaoSituacao = "Situação";

    self.usuarios = ko.observableArray([]);

    self.removeUsuario = function(usuario) {
		self.usuarios.remove(usuario);
    }

    // Load initial state from server, convert it to Task instances, then populate self.tasks
    $.getJSON("/Usuario/ObterListaUsuarios.asp", function(allData) {
        var mappedTasks = $.map(allData, function(item) { return new Task(item) });
        self.tasks(mappedTasks);
    });
}

ko.applyBindings(new ListarUsuarioViewModel());