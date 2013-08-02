function ListarUsuarioViewModel()
{
	var self = this;

	self.tituloLista = "Usuários Cadastrados";

	self.cabecalhoNome = "Nome";
	self.cabecalhoEmail = "Email";
	self.cabecalhoDescricaoTipo = "Tipo";
	self.cabecalhoDescricaoSituacao = "Situação";

    self.usuarios = [
        { nome: "Rodrigo", email: "rodrigolsr@gmail.com", descricaoTipo: "Administrador", descricaoSituacao: "Ativo" },
        { nome: "Lilia", email: "liliavieira@gmail.com", descricaoTipo: "Usuário", descricaoSituacao: "Ativo" },
        { nome: "Natalia", email: "natalialessa@gmail.com", descricaoTipo: "Usuário", descricaoSituacao: "Inativo" }
    ];

    self.removeUsuario = function(usuario) {
		self.usuarios.remove(usuario);
    }
}

ko.applyBindings(new ListarUsuarioViewModel());