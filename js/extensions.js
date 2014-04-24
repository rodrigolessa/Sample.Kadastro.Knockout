function doAjx(action, data, refresh) {
	alert(data);
	$.ajax({
		url: action,
		type: "POST",
		data: ko.toJSON(data),
		dataType: 'json',
		contentType: "application/json",
		cache: false,
		async: false,
		success: function (jsonResult) { refresh(jsonResult) }
		
		, error: function(jqXHR, exception) {
            if (jqXHR.status === 0) {
                alert('Não conectado.\n Verifique sua conexão com a internet.');
            } else if (jqXHR.status == 404) {
                alert('Página não encontrada [404].');
            } else if (jqXHR.status == 500) {
                alert('Erro interno do servidor [500].');
            } else if (exception === 'parsererror') {
                alert('Conversão da requisição falhou.');
            } else if (exception === 'timeout') {
                alert('Tempo de resposta esgotado.');
            } else if (exception === 'abort') {
                alert('Requisição cancelada.');
            } else {
                alert('Erro.\n' + jqXHR.responseText);
            }
        }
        
	});
}

function doBlockUI() {
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

    // Desativando bloqueio por tempo (segurança se algum método não tiver retorno)
    setTimeout($.unblockUI, 15000);
}