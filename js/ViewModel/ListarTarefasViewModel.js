function Tarefa(data) {
    this.Id = data.Id;
    this.Descricao = data.Descricao;
    this.IdUsuario = data.IdUsuario;
    this.Executada = data.Executada;
}

function ListarTarefasViewModel() {
	var self = this;

    // TODO: Obter Id e Login do Usuário logado
    self.LoginUsuario = "TesteUsuarioTarefa";
    self.tarefas = ko.observableArray([]);
    // TODO: Excluir Teste
    //self.tarefas = [ { Id:1, IdUsuario:1, Descricao:"Teste", Executada:false }, { Id:2, IdUsuario:1, Descricao:"Teste 2", Executada:true } ]
    self.descricaoNovaTarefa = ko.observable();
    self.tarefasIncompletas = ko.computed(function(){
        return ko.utils.arrayFilter(self.tarefas(), function(tarefa) { return !tarefa.Executada && !tarefa._destroy });
    });

    // Operations
    self.adicionarTarefa = function() {
		self.tarefas.push(new Tarefa({ Descricao: self.descricaoNovaTarefa() }));
        self.descricaoNovaTarefa("");
    };

    self.removerTarefa = function(tarefa) {
		self.tarefas.destroy(tarefa);
    };

    // Ativando bloqueio de tela
    doBlockUI();

    // Carga inicial dos dados do servidor, converte para uma instância de Tarefa, e popula a lista self.tarefas.
    // status - contains a string containing request status ("success", "notmodified", "error", "timeout", or "parsererror").
    $.getJSON("http://localhost/kadastroNet/KadastroServiceHost.svc/ListarTarefas/"+self.LoginUsuario+"/", function(allData, strStatus, xhr) {

        if (strStatus == "success") {

            var mappedTarefas = $.map(allData.ListarTarefasResult, function(item) { return new Tarefa(item) });
            self.tarefas(mappedTarefas);

            $.unblockUI();

        } else {

            $.unblockUI();
            alert(strStatus);
        }

    });
}

ko.applyBindings(new ListarTarefasViewModel());