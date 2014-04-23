	<!--#include file="Shared/Cabecalho.asp"-->

	<div id="topo" class="row container-topo">

		<div class="col-lg-12">

			<div class="container-narrow">

				<form class="form-inline" role="form" accept-charset="UTF-8" id="mainForm" method="post" data-bind="submit: adicionarTarefa">

					<div class="form-group">
						<label for="descricao">tarefa:</label>
						<input id="descricao" data-bind="value: descricaoNovaTarefa" type="text" placeholder="o que precisa ser feito?" class="form-control">
					</div>
					<button type="submit" class="btn btn-default">salvar</button>

				</form>

				<table class="table table-striped">
				<thead>
					<tr>
						<th>&nbsp;</th>
						<th>#</th>
						<th>Lista de Tarefas (<span data-bind="text: tarefas().length"></span>)</th>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody data-bind="foreach: tarefas">
					<tr>
						<td><input type="checkbox" data-bind="checked: Executada" /></td>
						<td data-bind="text: Id"></td>
						<td data-bind="text: Descricao" style="text-align:left;"></td>
						<td><a href="#" data-bind="click: $root.removerTarefa, visible: !Executada">excluir</a></td>
					</tr>
				</tbody>
				</table>

			</div>

		</div>
		<!--/span-->

	</div>
	<!--/row-->

	<!-- NÍVEL / SENIOR //-->
	<!--
	<div class="row container-nivel">

		<div class="col-lg-12">

			<div class="container-narrow text-right">
				<img src="img/my.icon2.png" width="82" height="82" class="my-icon">
			</div>

		</div>

	</div>
	-->
	<!--/row-->

	<!--
	<div class="row container-divisor-base">

		<div class="col-lg-12">

			<div class="container-narrow text-right">
				<h4>...</h4>
			</div>

		</div>

	</div>
	-->
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

	<script src="js/ViewModel/ListarTarefasViewModel.js"></script>

	<!--#include file="Shared/Rodape.asp"-->