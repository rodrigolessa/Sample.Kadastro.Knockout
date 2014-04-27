	<!--#include file="Shared/Cabecalho.asp"-->

	<div id="topo" class="row container-topo">

		<div class="col-lg-12">

			<form role="form" accept-charset="UTF-8" id="mainForm" method="post" class="container-narrow">

				<fieldset>

					<h2 data-bind="text: lblTitulo"></h2>

					<hr>

					<div class="row">

						<div class="col-lg-6">

							<div class="form-group">
								<label for="login">Login:</label>
								<input id="login" data-bind="value: Login" type="text" placeholder="Escolha seu login" class="form-control">
							</div>

							<div class="form-group">
								<label for="senha">Senha:</label>
								<input id="senha" data-bind="value: Senha" type="password" placeholder="Sua senha" class="form-control">
							</div>

							<div class="form-group">
								<label for="confirmaSenha">Confirma Senha:</label>
								<input id="confirmaSenha" data-bind="value: ConfirmaSenha" type="password" placeholder="Confirme a sua senha" class="form-control">
							</div>

						</div>

						<div class="col-lg-6">

							<div class="form-group">
								<label for="nome">Nome:</label>
								<div class="input-group">
									<span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
									<input id="nome" data-bind="value: Nome" type="text" placeholder="Seu nome completo" class="form-control">
								</div>
							</div>

							<div class="form-group">
								<label for="email">Email:</label>
								<div class="input-group">
									<span class="input-group-addon"><i class="glyphicon glyphicon-envelope"></i></span>
									<input id="email" data-bind="value: Email" type="email" placeholder="Seu email" class="form-control">
								</div>
							</div>

							<div class="form-group">
								<label for="pefilAcesso">Perfil de Acesso:</label>
								<div class="input-group">
									<span class="input-group-addon"><i class="glyphicon glyphicon-tags"></i></span>
									<select data-bind="options: Perfis, optionsText: 'Descricao'" class="form-control"></select>
								</div>
							</div>

						</div>

					</div>

					<br />

					<button data-bind="click: salvar, text: txtBotaoSalvar" class="btn btn-primary btn-lg btn-block"></button>

				</fieldset>

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

	<script src="js/ViewModel/ManterUsuarioViewModel.js"></script>

	<!--#include file="Shared/Rodape.asp"-->