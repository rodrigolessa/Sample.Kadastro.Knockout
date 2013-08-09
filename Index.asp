	<!--#include file="include/Cabecalho.asp"-->

	<form accept-charset="UTF-8" id="mainForm" method="post">

	<div class="modal" id="modal1">
		<div class="conteudo">
			<a class="interruptor fechar" trigger="|#modal1"><i class="icone-cancel" /></i></a>
			<div class="linha">
				<div class="colunas">
					<h2 data-bind="text: tituloModal">título</h2>
					<p data-bind="text: textoModal">texto</p>
					<p class="botao primario medio"><a href="#" class="interruptor" trigger="|#modal1">Fechar Janela</a></p>
				</div>
			</div>
		</div>
	</div>

	<div class="corpo">

		<div class="linha">
			<div class="colunas doze">
				<h1 class="lead">Titulo</h1>
				<p>This is my awesome paragraph text, it is the base style/size for paragraph text. We love 16px for body copy as it provides for a more consistent cross browser experience. It is also digitally equivalent to to 12pt standard set in print design. We also love the golden ratio, all of the type set here is based off of that deliciously elegant ratio. Enjoy!</p>
			</div>
		</div>

		<div class="linha">
			<h1 class="lead">Formulários</h1>
			<div class="linha">
				<div class="colunas quatro">
					<h4 class="lead">tabela</h4>
					<form>
						<fieldset>
							<legend>Fieldset with legend</legend>
							<ul>
								<li class="field">
									<label class="inline" for="text1">Nome:</label>
									<input class="wide text input" name="text1" type="text" placeholder="wide input" data-bind="value: txtPassageiro"/>
								</li>
								<li class="field">
									<label class="inline" for="text2">Senha:</label>
									<input class="wide password input" name="text2" type="password" placeholder="wide input" />
								</li>
								<li class="field">
									<div class="picker">
										<label class="inline" for="select2">Assentos:</label>
										<select name="select2" data-bind="options: $root.assentos, optionsText: 'numero', value: 'numero'"></select>
									</div>
								</li>
								<li class="field">
									<button data-bind="click: addPassageiro, enable: passageiros().length < 5">Reservar assento</button>
								</li>
							</ul>
						</fieldset>
					</form>
				</div>
				<div class="colunas quatro">
					<h4 class="lead">tabela</h4>
					<table>
						<caption>Assentos reservados (<span data-bind="text: passageiros().length"></span>)</caption>
						<thead>
							<tr>
								<th data-bind="text: passageiroNome">1</th>
								<th data-bind="text: passageiroAssento">2</th>
								<th data-bind="text: AssentoJanela">3</th>
							</tr>
						</thead>
						<tbody data-bind="foreach: passageiros">
							<tr>
								<td data-bind="text: nome">1</td>
								<td data-bind="text: assento().numero">2</td>
								<td data-bind="text: janelaFormatada">3</td>
								<td><a href="#" data-bind="click: $root.removePassageiro">excluir</a></td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>

		<div class="linha">
			<div class="colunas doze">
			</div>
		</div>

	</div>

	</form>

	<!--#include file="include/ScriptsComuns.asp"-->

	<script src="js/ViewModel/IndexViewModel.js"></script>

	<!--#include file="include/Rodape.asp"-->