	<!--#include file="Shared/Cabecalho.asp"-->

	<div class="container-fluid content-main">

		<div class="row">

			<div class="col-lg-12">

				<div class="container-narrow">

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

					<hr>

					<div class="table-responsive">
						<table class="table table-striped">
						<caption data-bind="text: txtCaptionMes"></caption>
						<thead>
							<tr>
								<th data-bind="text: cabecalhoData"></th>
								<th data-bind="text: cabecalhoIntervalos"></th>
								<th data-bind="text: cabecalhoTotalDia"></th>
								<th data-bind="text: cabecalhoHorasNegativasDia"></th>
								<th data-bind="text: cabecalhoHorasPositivasDia"></th>
							</tr>
						</thead>
						<tbody data-bind="foreach: pontosMes">
							<tr>
								<td data-bind="text: dataFormatada"/></td>
								<td data-bind="foreach: intervalosDia">
									<span data-bind="text: entrada"></span> - <span data-bind="text: saida"></span>
								</td>
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

				</div>

			</div>
			<!--/column-->

		</div>
		<!--/row-->

	</div>
	<!--/container-->

	<div class="container-fluid">

		<!-- NÍVEL / SENIOR //-->
		<div class="row container-nivel">

			<div class="col-lg-12">

				<div class="container-narrow text-right">
					<img src="img/my.icon2.png" width="82" height="82" class="my-icon">
				</div>

			</div>
			<!--/span-->

		</div>
		<!--/row-->

		<div class="row container-divisor-base">

			<div class="col-lg-12">

				<div class="container-narrow text-left">
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

	</div>
	<!--/container-->

	<!--#include file="Shared/ScriptsComuns.asp"-->

	<script src="js/ViewModel/IndexViewModel.js"></script>

	<!--#include file="Shared/Rodape.asp"-->