	<!--#include file="Shared/Cabecalho.asp"-->

	<div id="topo" class="row container-topo">

		<div class="col-lg-12">

			<form role="form" accept-charset="UTF-8" id="mainForm" method="post" class="container-narrow">

				<fieldset>

					<h2 data-bind="text: lblDia">dia</h2>

					<hr>

					<div class="form-group">
						<label for="input1" class="labelDiscreto">Hora Intervalo Entrada:</label>
						<input  id="input1" type="text" class="form-control input-lg horaMinuto" placeholder="00:00" data-bind="value: txtEntrada" maxlength="5"/>
					</div>

					<div class="form-group">
						<label for="input2" class="labelDiscreto">Hora Intervalo Saída:</label>
						<input  id="input2" type="text" class="form-control input-lg horaMinuto" placeholder="00:00" data-bind="value: txtSaída" maxlength="5"/>
					</div>

					<button data-bind="click: addPonto, enable: pontosMes().length < 2, text: txtBotaoSalvar" class="btn btn-primary btn-lg btn-block"></button>

				</fieldset>

				<hr>

				<div class="table-responsive">
					<table class="table table-striped">
					<caption data-bind="text: txtCaptionMes"></caption>
					<thead>
						<tr>
							<th data-bind="text: cabecalhoData"></th>
							<th data-bind="text: cabecalhoEntrada"></th>
							<th data-bind="text: cabecalhoSaida"></th>
							<th data-bind="text: cabecalhoEntrada"></th>
							<th data-bind="text: cabecalhoSaida"></th>
							<th data-bind="text: cabecalhoTotalDia"></th>
							<th data-bind="text: cabecalhoHorasNegativasDia"></th>
							<th data-bind="text: cabecalhoHorasPositivasDia"></th>
						</tr>
					</thead>
					<tbody data-bind="foreach: pontosMes">
						<tr>
							<td data-bind="text: dataFormatada"/></td>
							<td data-bind="text: entrada"></td>
							<td data-bind="text: saida"></td>
							<td></td>
							<td></td>
							<td data-bind="text: totalHorasDia"></td>
							<td data-bind="text: horasNegativasDia"></td>
							<td data-bind="text: horasPositivasDia"></td>
						</tr>
					</tbody>
					</table>
				</div>

				<h4 data-bind="visible: totalMes > 0">
					Total de horas do mês: <span data-bind="text: totalMes"></span>
				</h4>

			</form>

		</div>
		<!--/span-->

	</div>
	<!--/row-->


	<!-- NÍVEL / SENIOR //-->
	<div class="row container-nivel">

		<div class="col-lg-12">

			<div class="container-narrow text-right">
				<img src="img/my.icon2.png" class="my-icon">
			</div>

		</div>
		<!--/span-->

	</div>
	<!--/row-->

	<div class="row container-divisor-base">

		<div class="col-lg-12">

			<div class="container-narrow text-right">
				<h4>Rodrigo Lessa</h4>
			</div>

		</div>
		<!--/span-->

	</div>
	<!--/row-->

	<div class="row container-base">

		<div class="col-lg-12">

			<div class="container-narrow">
				...
			</div>

		</div>
		<!--/span-->

	</div>
	<!--/row-->


	<!--#include file="Shared/ScriptsComuns.asp"-->

	<script src="js/ViewModel/IndexViewModel.js"></script>

	<script type="text/javascript">
		//$(document).ready(function(){
			//alert($('#input2').val());
		    //$('#input1').mask('00:00');
		    //$('#input2').mask('23:59');
		//});
	</script>

	<!--#include file="Shared/Rodape.asp"-->