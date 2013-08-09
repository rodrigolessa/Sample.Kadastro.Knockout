	<!--#include file="include/Cabecalho.asp"-->

	<form accept-charset="UTF-8" id="mainForm" method="post">

	<div class="corpo">

		<div class="linha">

			<div class="colunas doze">

				<h1 class="lead" data-bind="text: tituloLista"></h1>

				<table class="striped rounded">
				<caption>total <span data-bind="text: usuarios.length"></span></caption>
				<thead>
					<tr>
						<th data-bind="text: cabecalhoNome"></th>
						<th data-bind="text: cabecalhoEmail"></th>
						<th data-bind="text: cabecalhoDescricaoTipo"></th>
						<th data-bind="text: cabecalhoDescricaoSituacao"></th>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody data-bind="foreach: usuarios">
					<tr>
						<td data-bind="text: nome"></td>
						<td data-bind="text: email"></td>
						<td data-bind="text: descricaoTipo"></td>
						<td data-bind="text: descricaoSituacao"></td>
						<td><a href="#" data-bind="click: $root.removeUsuario">excluir</a></td>
					</tr>
				</tbody>
				</table>

			</div>

		</div>

	</div>

	</form>

	<!--#include file="include/ScriptsComuns.asp"-->

	<script src="js/ViewModel/ListarUsuarioViewModel.js"></script>

	<!--#include file="include/Rodape.asp"-->