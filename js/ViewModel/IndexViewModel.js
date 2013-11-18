////////////////////////////////////////////////////////////////////////////////////////
// This is a simple *viewmodel* - JavaScript that defines the data and behavior of your UI
function CadastrarPonto(prmDia, prmEntrada, prmSaida) {

	var selff = this;
	selff.dia = prmDia;
	selff.entrada = prmEntrada;
	selff.saida = prmSaida;

    selff.dataFormatada = ko.computed(function(){
        return selff.dia.getDate() + '/' + (selff.dia.getMonth() + 1) + '/' + selff.dia.getFullYear();
    });

    // Calcular horas do dia, negativas e positivas
    selff.totalHorasDia = 8;
    selff.horasNegativasDia = 0;
    selff.horasPositivasDia = 1;
}

////////////////////////////////////////////////////////////////////////////////////////
// Função principal para View
function IndexViewModel() {

	var self = this;
    
    //self.lblLead = ko.observable('Controle Manual:');
    self.lblDia = ko.observable('Hoje');

    //var now = new Date();
    //var h = now.getHours();
    //var m = now.getMinutes();
    self.dia = new Date();
    var h = self.dia.getHours();
    var m = self.dia.getMinutes();

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

    //Operations
    ////////////////////////////////////////////////////////////////////////////////////////

	self.addPonto = function() {
		var inputEntrada = self.txtEntrada;
		var inputSaida = self.txtSaída;
		self.pontosMes.push(new CadastrarPonto(self.dia, inputEntrada, inputSaida));
	}

	self.removePonto = function(ponto) {
		self.pontosMes.remove(ponto);
	}

    // TODO: Função de busca dentro dos pontos por Mes para localizar os pontos por dia

}

// Activates knockout.js
ko.applyBindings(new IndexViewModel());