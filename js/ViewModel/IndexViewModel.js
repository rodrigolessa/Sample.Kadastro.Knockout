////////////////////////////////////////////////////////////////////////////////////////
// This is a simple *viewmodel* - JavaScript that defines the data and behavior of your UI

function CadastrarPonto(prmDia, prmEntrada, prmSaida) {

	var selff = this;
    var horEntrada = 0;
    var minEntrada = 0;

    selff.dia = prmDia;

    //alert(prmDia.getTime());

    //if(prmEntrada.indexOf(":")<1){
    //    horEntrada = prmEntrada;
    //    minEntrada = 0;
    //}

    selff.intervalosDia = ko.observableArray();

    // Criar sub listas para intervalos de horas do dia
    selff.intervalosDia.push(new CadastrarIntervalo(prmEntrada, prmSaida));
	
	selff.entrada = prmEntrada;
	selff.saida = prmSaida;

    selff.dataFormatada = ko.computed(function(){
        return selff.dia.getDate() + '/' + (selff.dia.getMonth() + 1) + '/' + selff.dia.getFullYear();
    });

    // Calcular horas do dia, negativas e positivas
    //var now = new Date();
    //if (format == "h:m") {
        //now.setHours(dStr.substr(0,dStr.indexOf(":")));
        //now.setMinutes(dStr.substr(dStr.indexOf(":")+1));
        //now.setSeconds(0);

    selff.totalHorasDia = 8;
    selff.horasNegativasDia = 0;
    selff.horasPositivasDia = 1;
}

function CadastrarIntervalo(prmEntrada, prmSaida) {
    var selfi = this;

    selfi.entrada = prmEntrada;
    selfi.saida = prmSaida;
}

////////////////////////////////////////////////////////////////////////////////////////
// Função principal para View
function IndexViewModel() {

	var self = this;
    
    self.lblDia = ko.observable('Hoje');

    // Obtendo hora e minutos do dia atual
    var hoje = new Date();
    var h = hoje.getHours();
    var m = hoje.getMinutes();

    // Zera hora, mantem o dia para futura comparação
    hoje.setHours(0);
    hoje.setMinutes(0);
    hoje.setSeconds(0);

    if(m>10)
    	m-=10;
    else
    	m=0;

    if(h<10)
        h='0'+h;

    if(m<10)
        m='0'+m;

    // Verificar se possui lançamentos de horas para o dia corrente

    self.txtEntrada = h+':'+m;
    self.txtSaída = (h+4)+':'+m;

    self.txtBotaoSalvar = ko.observable('Cadastrar Intervalo');

    self.pontosMes = ko.observableArray([]);

    self.txtCaptionMes = 'Lançamentos do mês corrente';
    self.cabecalhoData = 'Dia';
    self.cabecalhoEntrada = 'Entrada';
    self.cabecalhoSaida = 'Saída';
    self.cabecalhoIntervalos = 'Intervalos';
    self.cabecalhoTotalDia = 'Horas do dia';
    self.cabecalhoHorasNegativasDia = 'Negativas';
    self.cabecalhoHorasPositivasDia = 'Positivas';

    self.totalMes = 0;
    /*
    self.totalMes = ko.computed(function(){
        var total = 0;
        ko.utils.arrayForEach(self.pontosMes(), function(item){
            var valorItem = parseFloat(item.totalHorasDia);
            if(isNaN(valorItem))
                total += valorItem;
        })
        return total;
    });
    */

    /*
    self.totalConta = ko.computed(function() {
        var total = 0;
        for (var i = 0; i < self.pedidos().length; i++)
            total += self.pedidos()[i].prato().valor;
        return total;
    });
    */

    //Operations
    ////////////////////////////////////////////////////////////////////////////////////////

	self.addPonto = function() {

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
        
        var inputEntrada = self.txtEntrada;
		var inputSaida = self.txtSaída;

		self.pontosMes.push(new CadastrarPonto(hoje, inputEntrada, inputSaida));
        //CadastrarPonto(hoje, inputEntrada, inputSaida);
	}

	self.removePonto = function(ponto) {
		self.pontosMes.remove(ponto);
	}

    // TODO: Função de busca dentro dos pontos por Mes para localizar os pontos por dia

    /*
    self.frutas = [
        { nome: "Maçã", preco: 1.30, exibir: true, relacionadas: [] },
        { nome: "Frutas Vermelhas", preco: 3.50, exibir: true, relacionadas: [ { nome: "Morango" }, { nome: "Cereja" }, { nome: "Amora" } ] },
        { nome: "Graviola", preco: 3.90, exibir: true, relacionadas: [] }
    ];
    */

}

// Activates knockout.js
ko.applyBindings(new IndexViewModel());