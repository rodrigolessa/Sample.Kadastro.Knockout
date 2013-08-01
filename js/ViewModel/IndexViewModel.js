// Class to represent a row in the seat reservations grid
function AnotaPedidos(nome, entrada) 
{
    var self = this;
    self.nome = nome;
    self.prato = ko.observable(entrada);

    self.precoFormatado = ko.computed(function() {
    	var preco = self.prato().valor;
    	return preco ? "R$ " + preco.toFixed(2) : "None";
    });
}

function CadastrarPassageiro(nomePass, assentoPass)
{
	var self = this;
	self.nome = nomePass;
	self.assento = ko.observable(assentoPass);
	self.janelaFormatada = ko.computed(function() {
		var janelaSN = self.assento().janela;
		return janelaSN == 0 ? "Não" : "Sim";
	});
}

// This is a simple *viewmodel* - JavaScript that defines the data and behavior of your UI
function IndexViewModel() 
{
	var self = this;
    self.tituloModal = ko.observable("Janela Model");
    self.textoModal = ko.observable("Texto exibido na janela modal...");
    self.tituloListaFrutas = "Lista de Frutas da Estação";
    self.txtPassageiro = "";

	// Tabelas
    self.clienteCabecalhoNome = ko.observable("Cliente");
    self.clienteCabecalhoPrato = ko.observable("Refeição");
    self.clienteCabecalhoValor = ko.observable("Preço");

    // Objeto JSON para exibir frutas da estação
    self.frutas = [
        { nome: "Maçã", preco: 1.30, exibir: true, relacionadas: [] },
        { nome: "Banana", preco: 1.00, exibir: true, relacionadas: [] },
        { nome: "Morango", preco: 2.30, exibir: true, relacionadas: [] },
        { nome: "Melancia", preco: 3.30, exibir: true, relacionadas: [] },
        { nome: "Frutas Vermelhas", preco: 3.50, exibir: true, relacionadas: [ { nome: "Morango" }, { nome: "Cereja" }, { nome: "Amora" } ] },
        { nome: "Uva", preco: 4.50, exibir: true, relacionadas: [] },
        { nome: "Graviola", preco: 3.90, exibir: true, relacionadas: [] },
        { nome: "Açaí", preco: 3.10, exibir: true, relacionadas: [] },
        { nome: "Mamão", preco: 3.50, exibir: true, relacionadas: [] }
    ];

    // Non-editable catalog data - would come from the server
    self.pratos = [
        { nome: "Comum (Sandwich)", valor: 0 },
        { nome: "Grande (Lagosta)", valor: 34.95 },
        { nome: "Gigante (Zebra)", valor: 290 }
    ];

    // Editable data
    self.pedidos = ko.observableArray([
        new AnotaPedidos("Rodrigo", self.pratos[0]),
        new AnotaPedidos("Lilia", self.pratos[1]),
        new AnotaPedidos("Natalia", self.pratos[2])
    ]);

    self.totalConta = ko.computed(function() {
		var total = 0;
		for (var i = 0; i < self.pedidos().length; i++)
			total += self.pedidos()[i].prato().valor;
		return total;
    });

    // Controle de passageiros
    self.passageiroNome = "Passageiro";
    self.passageiroAssento = "Assento";
    self.AssentoJanela = "Janela";

    self.assentos = [
        { numero: "A1", janela: 0 },
        { numero: "A2", janela: 1 },
        { numero: "B2", janela: 1 },
        { numero: "B3", janela: 0 },
        { numero: "C4", janela: 0 }
    ];

    self.passageiros = ko.observableArray([
    	new CadastrarPassageiro("Rodrigo", self.assentos[0]),
    	new CadastrarPassageiro("Lilia", self.assentos[1])
    ]);

    // Operations
    self.addPassageiro = function() {
    	var campotexto1 = self.txtPassageiro;//self.txtPassageiro;
        self.passageiros.push(new CadastrarPassageiro(campotexto1, self.assentos[3]));
        self.txtPassageiro = "";
    }

    self.removePassageiro = function(passageiro) { 
    	self.passageiros.remove(passageiro)
    }

    //this.fullName = ko.computed(function() {
        //return this.firstName() + " " + this.lastName();
    //}, this);
    
    //this.capitalizeLastName = function() {
        //var currentVal = this.lastName(); // Read the current value
        //this.lastName(currentVal.toUpperCase()); // Write back a modified value - Como o lastName é do tipo observable, pode ser chamado como uma função.
    //};
}

// Activates knockout.js
ko.applyBindings(new IndexViewModel());