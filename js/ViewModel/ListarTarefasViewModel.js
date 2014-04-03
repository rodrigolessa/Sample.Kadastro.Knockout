function Tarefa(data)
{
    this.Id = data.Id
    this.IdUsuario = data.IdUsuario
	this.Descricao = data.Descricao;
	this.Executada = data.Executada;
}

function ListarTarefasViewModel()
{
	var self = this;

    self.tarefas = ko.observableArray([]);

    // Operations
    self.adicionaTarefa = function(tarefa) {
		self.tarefas.push(tarefa);
    }

    self.removeTarefa = function(tarefa) {
		self.tarefas.remove(tarefa);
    }

    // Load initial state from server, convert it to Task instances, then populate self.tarefas
    //$.getJSON("http://localhost/kadastroNet/KadastroServiceHost.svc/Listartarefas/", function(allData) {
    $.getJSON("/KadastroServiceHost.svc/Listartarefas/", function(allData) {
        var mappedtarefas = $.map(allData.ListartarefasResult, function(item) { return new Usuario(item) });
        self.tarefas(mappedtarefas);
    });
}

ko.applyBindings(new ListarTarefasViewModel());