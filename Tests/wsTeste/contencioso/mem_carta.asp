<%
MEM_CARTA = ""
MEM_CARTA = MEM_CARTA_db
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Mesclagem de Dados
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if var_processo <> "" then
'	**** Bloco Dados do Processo *************
	MEM_CARTA = REPLACE(MEM_CARTA,"<<PROCESSO>>",troca_null(processo))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<NATUREZA>>",troca_null(natureza))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<PASTA_CONTROLADO>>",troca_null(p_pasta_proprio))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<OBJETO>>", troca_null(objeto))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<COMPETENCIA>>",troca_null(competencia))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<RESPONSAVEL>>",troca_null(responsavel))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<POSICAO>>",replace(replace(POSICAO,"R","Réu"),"A","Autor"))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<TIPO>>",troca_null(tipo))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<TIPOACAO>>",troca_null(tipo_acao))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<RITO>>",troca_null(rito))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<ORGAO>>",troca_null(ORGAO))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<INSTANCIA>>",troca_null(INSTANCIA))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<JUIZO>>",troca_null(JUIZO))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<COMARCA>>",troca_null(COMARCA))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<SITUACAO>>",troca_null(SITUACAO))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<PRINCIPAL>>",troca_null(principal))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<OUTRAPARTE>>",troca_null(outraparte_carta))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<OBJETO_PRINCIPAL>>", troca_null(objeto_principal))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<INTERESSADO>>", troca_null(interessado))

	MEM_CARTA = REPLACE(MEM_CARTA,"<<RAZAO_SOCIAL_INTERESSADO>>", troca_null(razao_social_interessado))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<RAZAO_SOCIAL_TITULAR_CONTROLADO>>", troca_null(razao_social_titular_controlado))

	MEM_CARTA = REPLACE(MEM_CARTA,"<<DESCRICAO>>", troca_null(descricao))
	
	'Datas
	MEM_CARTA = REPLACE(MEM_CARTA,"<<DTPRAZO_GERENCIAL>>",troca_null(prazo_ger))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<DTPRAZO_OFICIAL>>",troca_null(prazo_ofi))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<DISTRIBUICAO>>",troca_null(distribuicao))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<ENCERRAMENTO>>",troca_null(dt_encerra))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<CITACAO>>", troca_null(dt_citacao))
	'Datas por Extenso
	MEM_CARTA = REPLACE(MEM_CARTA,"<<EXT_DTPRAZO_GERENCIAL>>",TrataExtensoData(idioma_carta,troca_null(prazo_ger)))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<EXT_DTPRAZO_OFICIAL>>",TrataExtensoData(idioma_carta,troca_null(prazo_ofi)))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<EXT_DISTRIBUICAO>>",TrataExtensoData(idioma_carta,troca_null(distribuicao)))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<EXT_ENCERRAMENTO>>",TrataExtensoData(idioma_carta,troca_null(dt_encerra)))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<EXT_CITACAO>>", TrataExtensoData(idioma_carta,troca_null(dt_citacao)))
end if

if var_cliente <> "" then
'	**** Bloco Dados do Cliente *************
	MEM_CARTA = REPLACE(MEM_CARTA,"<<CLIENTE>>",troca_null(cliente_carta))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<CONTATO>>",troca_null(contato_carta))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<LOGRADOURO>>",troca_null(logradouro_carta))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<BAIRRO>>",troca_null(bairro_carta))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<CIDADE>>",troca_null(cidade_carta))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<ESTADO>>",troca_null(estado_carta))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<CEP>>",troca_null(cep_carta))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<ESCRITORIO>>",troca_null(escritorio_carta))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<PAIS>>",troca_null(pais))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<PASTA>>",troca_null(pasta))
	MEM_CARTA = REPLACE(MEM_CARTA,"<<EMAIL>>",troca_null(email))
	
	'Data
		MEM_CARTA = REPLACE(MEM_CARTA,"<<DATA>>",fdata(DATE()))
	'Data par Extenso
		MEM_CARTA = REPLACE(MEM_CARTA,"<<EXT_DATA>>",TrataExtensoData(idioma_carta,DATE()))

	'Variável para o campo "Telefone" no cadastro do Endereço Principal do envolvido.
	MEM_CARTA = REPLACE(MEM_CARTA,"<<TELEFONE_ENDERECO>>",troca_null(telefone_endereco_principal))
	'Variável para o campo "Fax" no cadastro do Endereço Principal do envolvido.
	MEM_CARTA = REPLACE(MEM_CARTA,"<<FAX_ENDERECO>>",troca_null(fax_endereco_principal))
	'Variável para o campo "Telefone" no cadastro do Contato Principal do envolvido.
	MEM_CARTA = REPLACE(MEM_CARTA,"<<TELEFONE_CONTATO>>",troca_null(telefone_contato_principal))
	'Variável para o campo "Caixa Postal" no cadastro do envolvido.
	MEM_CARTA = REPLACE(MEM_CARTA,"<<CAIXA_POSTAL>>",troca_null(caixa_postal))
	
end if

	mem_carta = replace(mem_carta,"<<aspas>>","'")
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'Fim Mesclagem de Dados
'-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%>