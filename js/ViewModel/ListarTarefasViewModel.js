function ListarTarefasViewModel() {

    // Variáveis
    /////////////////////////////////////////
	var self = this;

    // TODO: Obter Id e Login do Usuário logado
    self.loginUsuario = "TesteUsuarioTarefa";
    self.codigoUsuario = 1;
    self.tarefas = ko.observableArray([]);
    //self.tarefas = [ { Id:1, IdUsuario:1, Descricao:"Teste", Executada:false }, { Id:2, IdUsuario:1, Descricao:"Teste 2", Executada:true } ]
    self.descricaoNovaTarefa = ko.observable();
    self.tarefasIncompletas = ko.computed(function(){
        return ko.utils.arrayFilter(self.tarefas(), function(tarefa) { return !tarefa.Executada && !tarefa._destroy });
    });

    // Operações
    /////////////////////////////////////////

    self.adicionarTarefa = function() {

        doBlockUI();

        if (self.descricaoNovaTarefa().length > 1){
            var novaTarefa = new Tarefa({ Descricao: self.descricaoNovaTarefa(), IdUsuario: self.codigoUsuario, Executada: false });

            self.tarefas.push(novaTarefa);
            self.descricaoNovaTarefa("");

            doAjx("KadastroServiceHost.svc/SalvarTarefa/", { tarefa: novaTarefa }, function(resultado){
                if (resultado.SalvarTarefaResult != null)
                    alert(resultado.SalvarTarefaResult.Message);
            });
        }

        $.unblockUI();
    };

    self.removerTarefa = function(tarefa) {

        doBlockUI();

		self.tarefas.destroy(tarefa);

        if (tarefa.Id != null){
            $.ajax("KadastroServiceHost.svc/ExcluirTarefa/", {
                data: ko.toJSON({ id: tarefa.Id }),
                type: "delete", 
                contentType: "application/json",
                success: function(result) { 
                    if (result.ExcluirTarefaResult != null)
                        alert(result.ExcluirTarefaResult.Message);
                 }
             });
        }

        $.unblockUI();
    };

    // Ativando bloqueio de tela
    /////////////////////////////////////////
    doBlockUI();

    // Carga inicial dos dados do servidor, converte para uma instância de Tarefa, e popula a lista self.tarefas.
    // status - contains a string containing request status ("success", "notmodified", "error", "timeout", or "parsererror").
    $.getJSON("KadastroServiceHost.svc/ListarTarefas/"+self.loginUsuario+"/", function(allData, strStatus, xhr) {
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