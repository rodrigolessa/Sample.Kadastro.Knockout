	<!--#include file="include/Cabecalho.asp"-->

	<div id="container-topo" class="container-fluid container-topo">

		<div class="row-fluid">

			<div class="span12">

				<form accept-charset="UTF-8" id="contatoForm" method="post" class="form-horizontal container-narrow">

				<fieldset>

				<legend><h1>Criar uma nova conta!</h1></legend>

					<div class="row-fluid">

						<div class="span6">

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

						<div class="span6">

							<div class="control-group">
								<label for="nome">Nome:</label>
								<div class="input-prepend">
									<span class="add-on"><i class="icon-user"></i></span>
									<input id="nome" data-bind="value: Nome" type="text" placeholder="Seu nome completo">
								</div>
							</div>

							<div class="control-group">
								<label for="email">Email:</label>
								<div class="input-prepend">
									<span class="add-on"><i class="icon-envelope"></i></span>
									<input id="email" data-bind="value: Email" type="text" placeholder="Seu email">
								</div>
							</div>

							<div class="control-group">
								<label for="pefilAcesso">Perfil de Acesso:</label>
								<div class="input-prepend">
									<span class="add-on"><i class="icon-tag"></i></span>
									<select id="pefilAcesso" data-bind="options: Perfis, optionsText: 'Descricao', value: PerfilAcesso"></select>
								</div>
							</div>

						</div>

					</div>

					<hr>

					<div class="control-group">
						<button type="submit" data-bind="click: Salvar" class="btn btn-large btn-primary">Salvar conta</button>
					</div>

				</fieldset>

				</form>

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

		</div>

		<div class="row-fluid row-divisor-base">

			<div class="span12">

				<div class="container-narrow text-right">

					<h4>Rodrigo Lessa</h4>

				</div>

			</div>

		</div>

	</div>

	<div class="container-base">

		<div class="row-fluid">

			<div class="span12">

				<div class="container-narrow">

					...

				</div>

			</div>

		</div>

	</div>

	<!--#include file="include/ScriptsComuns.asp"-->

	<script src="js/ViewModel/ListarUsuarioViewModel.js"></script>

	<!--#include file="include/Rodape.asp"-->