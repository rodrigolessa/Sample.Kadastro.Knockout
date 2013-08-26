function Usuario(data) 
{
	//var self = this;
	this.nome = ko.observable(data.nome);
	this.email = ko.observable(data.email);
	this.descricaoTipo = ko.observable(data.descricaoTipo);
	this.descricaoSituacao = ko.observable(data.descricaoSituacao);
}

function ListarUsuarioViewModel()
{
	var self = this;

	self.tituloLista = "Usuários Cadastrados";

	self.cabecalhoNome = "Nome";
	self.cabecalhoEmail = "Email";
	self.cabecalhoDescricaoTipo = "Tipo";
	self.cabecalhoDescricaoSituacao = "Situação";

	self.NomeUsuarioText = ko.observable();

    self.usuarios = ko.observableArray([]);

    // Operations
    self.addUsuario = function() {
        self.usuarios.push(new Usuario({ nome: this.NomeUsuarioText() }));
        self.NomeUsuarioText("");
    };

    self.removeUsuario = function(usuario) {
		self.usuarios.remove(usuario);
    }

    // Load initial state from server, convert it to Task instances, then populate self.tasks
    $.getJSON("Kadastro.Persistencia/UsuarioRepository.asp", function(allData) {
        var mappedTasks = $.map(allData, function(item) { return new Usuario(item) });
        self.usuarios(mappedTasks);
    });
}

ko.applyBindings(new ListarUsuarioViewModel());