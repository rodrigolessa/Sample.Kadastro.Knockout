	<!--#include file="Shared/Cabecalho.asp"-->

	<div id="topo" class="row container-topo">

		<div class="col-lg-12">

			<form role="form" accept-charset="UTF-8" id="mainForm" method="post" class="container-narrow">

				<h1 class="lead"><span data-bind="text: tituloLista"></span> (<span data-bind="text: usuarios.length"></span>)</h1>

				<table class="table table-striped">
				<thead>
					<tr>
						<th>#</th>
						<th data-bind="text: cabecalhoLogin"></th>
						<th data-bind="text: cabecalhoEmail"></th>
						<th data-bind="text: cabecalhoDescricaoDoStatus"></th>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody data-bind="foreach: usuarios">
					<tr>
						<td data-bind="text: Id"></td>
						<td data-bind="text: Login"></td>
						<td data-bind="text: Email"></td>
						<td data-bind="text: DescricaoDoStatus"></td>
						<td><a href="#" data-bind="click: $root.removeUsuario">excluir</a></td>
					</tr>
				</tbody>
				</table>

			</form>

		</div>
		<!--/span-->

	</div>
	<!--/row-->

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


	<!--#include file="Shared/ScriptsComuns.asp"-->

	<script src="js/ViewModel/ListarUsuarioViewModel.js"></script>

	<!--#include file="Shared/Rodape.asp"-->