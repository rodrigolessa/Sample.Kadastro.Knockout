	<!--#include file="Shared/Cabecalho.asp"-->

	<div id="container-topo" class="container-fluid container-topo">

		<div class="row-fluid">

			<div class="span12">

				<!--<h4 class="lead" data-bind="text: lead">Controle</h4>-->

				<form role="form" accept-charset="UTF-8" id="mainForm" method="post" class="container-narrow">

					<fieldset>

						<legend><h1 data-bind="text: lblDia">dia</h1></legend>

						<div class="form-group">
							<label class="inline" for="input1">Entrada:</label>
							<input class="form-control" name="input1" type="text" placeholder="Hora de Entrada" data-bind="value: txtEntrada"/>
						</div>

						<div class="form-group">
							<label class="inline" for="input2">Saída:</label>
							<input class="form-control" name="input2" type="text" placeholder="Hora de Saída" data-bind="value: txtSaída"/>
						</div>

						<button data-bind="click: addPonto, enable: pontosDia().length < 2, text: txtBotaoSalvar" class="btn btn-warning"></button>

					</fieldset>

				</form>

			</div>
			<!--/span-->

		</div>
		<!--/row-->

		<div class="row-fluid">

			<div class="span12">

			<!--
				<table class="rounded">
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
						<td><input data-bind="value: entrada"/></td>
						<td><input data-bind="value: saida"/></td>
						<td><select data-bind="options: $root.pratos, value: prato, optionsText: 'nome'"></select></td>
						<td data-bind="text: totalHorasDia"></td>
						<td data-bind="text: horasNegativasDia"></td>
						<td data-bind="text: horasPositivasDia"></td>
					</tr>
				</tbody>
				</table>
				<h3 data-bind="visible: totalMes().length > 0">
					Total de horas do mês: <span data-bind="text: totalMes()"></span>
				</h3>
			-->

			</div>
			<!--/span-->

		</div>
		<!--/row-->

	</div>
	<!--/.fluid-container-->

	<!-- NÍVEL / SENIOR //-->
	<div class="container-nivel">

		<div class="row-fluid">

			<div class="span12">

				<div class="container-narrow text-right">

					<img src="img/my.icon2.png" class="my-icon">

				</div>

			</div>
			<!--/span-->

		</div>
		<!--/row-->

		<div class="row-fluid row-divisor-base">

			<div class="span12">

				<div class="container-narrow text-right">

					<h4>Rodrigo Lessa</h4>

				</div>

			</div>
			<!--/span-->

		</div>
		<!--/row-->

	</div>
	<!--/.fluid-container-->

	<div class="container-base">

		<div class="row-fluid">

			<div class="span12">

				<div class="container-narrow">

					...

				</div>

			</div>
			<!--/span-->

		</div>
		<!--/row-->

	</div>
	<!--/.fluid-container-->


	<!--#include file="Shared/ScriptsComuns.asp"-->

	<script src="js/ViewModel/IndexViewModel.js"></script>

	<!--#include file="Shared/Rodape.asp"-->