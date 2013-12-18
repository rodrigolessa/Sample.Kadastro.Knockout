		<script type="text/javascript">

			
			$.getJSON('/localhost/timesheet/TimesheetServiceHost.svc/ObterJSON/1', LoadUserName);

			function LoadUserName(Result) {
				alert(Result.Detalhe +':'+ Result.Valor);
			}

			alert("Teste");

			$.ajax({
				type       : "POST",
				url        : "http://localhost/timesheet/TimesheetServiceHost.svc/ObterJSON",
				data       : "{'id':'1'}",
				contentType: "application/json; charset=utf-8",
				dataType   : "json",
				async      : false,
				success    : function(jsonResult) {
					// Cria campo 'SELECT' com o conteúdo dos orgãos 
					if (jsonResult.d != null){
						//criarOrgaoOficial(jsonResult.d);
						conteudo = jsonResult.d;

						for(y=0; y < conteudo.length; y++)
							if (conteudo[y].Detalhe != null)
								alert(conteudo[y].Detalhe);
					}
				},
				complete: function (jqXHR, status) { 
					alert('Status: ' + status + '\njqXHR: ' + JSON.stringify(jqXHR)); 
				}
			});


	

		  /*
			jQuery.ajax({
				type: "POST",
				
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				async: false,
				success: function(jsonResult){
					if (jsonResult.d != ''){
						alert("Teste: " + jsonResult.d);
					}
				},
				error: function(msg){
				    alert(msg);
				}
			});
	*/
		</script>