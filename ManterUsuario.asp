	<!--#include file="Shared/Cabecalho.asp"-->

	<div id="topo" class="row container-topo">

		<div class="col-lg-12">

			<form role="form" accept-charset="UTF-8" id="mainForm" method="post" class="container-narrow">

				<fieldset>

				<legend><h1>Criar uma nova conta!</h1></legend>

					<div class="row">

						<div class="col-lg-6">

							<div class="control-group">
								<label for="login">Login:</label>
								<input id="login" data-bind="value: Login" type="text" placeholder="Escolha seu login" class="input-block-level">
							</div>

							<div class="control-group">
								<label for="senha">Senha:</label>
								<input id="senha" data-bind="value: Senha" type="password" placeholder="Sua senha" class="input-block-level">
							</div>

							<div class="control-group">
								<label for="confirmaSenha">Confirma Senha:</label>
								<input id="confirmaSenha" data-bind="value: ConfirmaSenha" type="password" placeholder="Confirme a sua senha" class="input-block-level">
							</div>

						</div>

						<div class="col-lg-6">

							<div class="form-group">
								<label for="nome">Nome:</label>
								<div class="input-prepend">
									<span class="add-on"><i class="icon-user"></i></span>
									<input id="nome" data-bind="value: Nome" type="text" placeholder="Seu nome completo">
								</div>
							</div>

							<div class="form-group">
								<label for="email">Email:</label>
								<div class="input-prepend">
									<span class="add-on"><i class="icon-envelope"></i></span>
									<input id="email" data-bind="value: Email" type="text" placeholder="Seu email">
								</div>
							</div>

							<div class="form-group">
								<label for="pefilAcesso">Perfil de Acesso:</label>
								<div class="input-prepend">
									<span class="add-on"><i class="icon-tag"></i></span>
									<select id="pefilAcesso" data-bind="options: Perfis, optionsText: 'Descricao', value: PerfilAcesso"></select>
								</div>
							</div>

						</div>

					</div>

					<hr>

					<div class="form-group">
						<button type="submit" data-bind="click: Salvar" class="btn btn-large btn-primary">Salvar conta</button>
					</div>

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

	<script src="js/ViewModel/ManterUsuarioViewModel.js"></script>

	<!--#include file="Shared/Rodape.asp"-->