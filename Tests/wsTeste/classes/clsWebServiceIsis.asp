<%
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'Author: Rodrigo Lessa
'Create: 2013-11-26
'
'Dependences Parameters:
'	N/A
'
'Dependences Files:
'	/include/adovbs.inc
'	/include/helpers/inc_ADOHelper.asp
'	/contencioso/db_open.asp
'	/include/funcoes.asp
'
'Methods:
'	Sub Class_Initialize
'	Sub Class_Terminate
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Class clsWebServiceIsis

	Private p_url
	Private p_metodo
	Private p_retorno
	Private p_parametros

	' Obter ou atribuir o endereço URL do serviço, Já existe um default para inicialização da classe
	Public Property Get URL()
		URL = p_url
	End Property
	Public Property Let URL(p_Data)
		p_url = p_Data
	End Property
	
	' Obter ou atibuir um método do WebService
	Public Property Get Metodo()
		Metodo = p_metodo
	End Property
	Public Property Let Metodo(p_Data)
		p_metodo = p_Data
	End Property
	
	' Obter o retorno do método do WebService
	Public Property Get Retorno()
		Retorno = p_retorno
	End Property
	'Public Property Let Retorno(p_Data)
	'p_retorno = p_Data
	'End Property
	
	' Obter ou atribuir parametros do Método do WebService escolhido
	Public Property Get Parametros()
		Set Parametros = p_parametros
	End Property
	Public Property Let Parametros(p_Data)
		p_parametros = p_Data
	End Property

	' Funções Públicas

	Public Sub Executar()

		Dim xmlhttp
		Set xmlhttp = CreateObject("MSXML2.ServerXMLHTTP")

		xmlhttp.setOption 2, 13056 'ignora "certificate errors"
		xmlhttp.open "POST", p_url & "/" & p_metodo, false
		xmlhttp.setRequestHeader "Content-Type", "application/json"
		xmlhttp.send p_parametros.paraJSON 'Exemplo de objeto para JSON = "{'vStr_Usuario':'rlessa2'}"
		' Obtem retorno do método
		p_retorno = xmlhttp.responseText

		Set xmlhttp = Nothing

	End Sub

	' Ao instanciar o objeto
	Private Sub Class_Initialize()
		' Como a classe é exclusiva do WebService "ServicoIsis", atribui a URL Default do serviço
		'p_url = url_base() & "/utilitarios/ServicoIsis/ServicoIsis.asmx"
		' Instancia a classe de parametros
		Set p_parametros = new clsParametrosJSON
	End Sub

	' Ao finalizar o objeto
	Private Sub Class_Terminate()
		Set p_parametros = Nothing
	End Sub

End Class

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Cria um dicionário com a entrada de parametros e retorna um Objeto JSON como string
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Class clsParametrosJSON

	Private p_lista

	' Objeto do tipo Dictionary, para contar a lista de chave e valor de parametros
	Public Property Get Lista()
		Set Lista = p_lista
	End Property
	Public Property Let Lista(p_Data)
		p_lista = p_Data
	End Property

	' Converte o dicionário de parametros atual em uma string JSON
	Public Function paraJSON()

		Dim nItem, nLista

		nLista = ""

		For nItem = 1 to qtdLista
			nLista = nLista & Obter(nItem).paraJSON & ","
		Next

		if right(nLista, 1) = "," then
			nLista = left(nLista, len(nLista)-1)
		end if

		if len(nLista) > 0 then
			nLista = "{" & nLista & "}"
		end if

		paraJSON = nLista

	End Function

	' Cria um objeto do tipo Parametro JSON e adiciona com valor do dicionário corrente
	Public Sub Adicionar(pChave, pValor)

		Dim nNovo
		Set nNovo = new clsParametroJSON
		nNovo.Chave = pChave
		nNovo.Valor = pValor

		' Adiciona um identificador para o objeto ParametroJSON com chave e valor
		p_lista.Add p_lista.count + 1, nNovo

		Set nNovo = Nothing

	End Sub

	Public Sub Remover(pID)
		p_lista.Remove(pID)
	End Sub

	Public Function Obter(pID)
		Set Obter = p_lista.Item(pID)
	End Function

	public function ExisteChave(pChave)
		Dim nItem
		For nItem = 1 to qtdLista
			if Obter(nItem).Chave = pChave then
				ExisteChave = true
				exit for
			end if
		next
	end function

	Public Function qtdLista()
		qtdLista = p_lista.count
	End Function

	' Reinicializa o objeto
	Public Sub Clear
		Set p_lista = Nothing
		Set p_lista = CreateObject("Scripting.Dictionary")
	End Sub

	' Inicializa o objeto
	Private Sub Class_Initialize()
		Set p_lista = CreateObject("Scripting.Dictionary")
	End Sub

	' Finaliza o objeto
	Private Sub Class_Terminate()
		Set p_lista = Nothing
	End Sub

End Class

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Define uma classe com as caracteristicas de um par Chave e Valor como padrão JSON
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Class clsParametroJSON

	Private p_chave
	Private p_valor

	Public Property Get Chave()
		Chave = p_chave
	End Property
	Public Property Let Chave(p_Data)
		p_chave = p_Data
	End Property

	Public Property Get Valor()
		Valor = p_valor
	End Property
	Public Property Let Valor(p_Data)
		p_valor = p_Data
	End Property

	Public Function paraJSON()
		paraJSON = "'" & p_chave & "':'" & p_valor & "'"
	End Function

End Class


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Obtem o nome do orgão oficial utilizando o WebService da LD (ServicoIsis) '
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
function ObterDescricaoOrgaoOficialProSigla(prmSigla, prmJSONOrgaoOficial)

	On Error Resume Next

	Dim strNomeTribunal : strNomeTribunal = ""

	' Valida se o objeto JSON está no formato esperado
	if IsObject(prmJSONOrgaoOficial) and prmJSONOrgaoOficial = "[object Object]" then

		if prmJSONOrgaoOficial.keys()(0) = "d" then

			for itenOrgao = 0 to Ubound(prmJSONOrgaoOficial.d.keys())

				siglaOK = false

				for each chaveOrgao in prmJSONOrgaoOficial.d.get(itenOrgao).keys()

					if chaveOrgao = "sigla" then
						if prmJSONOrgaoOficial.d.get(itenOrgao).sigla = prmSigla then
							siglaOK = true
						end if
					end if

					if chaveOrgao = "nome" and siglaOK = true then
						strNomeTribunal = prmJSONOrgaoOficial.d.get(itenOrgao).nome
					end if

				next

				if len(strNomeTribunal) > 0 then
					exit for
				end if

			next

		end if

	end if

	if len(strNomeTribunal) > 0 then
		ObterDescricaoOrgaoOficialProSigla = strNomeTribunal
	else
		ObterDescricaoOrgaoOficialProSigla = prmSigla
	end if

	On Error GoTo 0

end function
%>