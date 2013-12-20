<!--#include file="../include/conn.asp"-->
<!--#include file="../usuario_logado.asp"-->

<%
'OBS.: Nao se pode armazenar as informacoes em variaveis para apresentar de uma unica vez ao final, pois isso aumenta 
'mto o tempo de criacao deste relatorio, por isso o uso do response.write supracitado.

Server.ScriptTimeout = 999999

'Declarando as variáveis
Dim rsProcessos, sSqlCamposLivres, sSqlOrder
Dim iIdProcAux, rsCamposLivres
Dim sCampo1, sCampo2, sCampo3, sCampo4, sTitulo

'Recordset dos Processos
Set rsProcessos = server.createobject("ADODB.Recordset")

'Verficando se foi passado corretamente os ids dos processos selecionados.
if request("procs") = "" or isnull(request("procs")) then
	Response.Write "<script>alert('Nenhum processo encontrado.'); history.back();</script>"
	Response.End
end if

'Pegando os processos do resultado da consulta
iIdProcAux = replace(request.form("procs"), "/", ",")

'ORDER BY
sSqlOrder = "TabProcCont.processo"
if request("ordem") <> "" then
	sSqlOrder = request("ordem")
end if

'Capturando os campos livres de acordo com a label estipulada pelo cliente na area adm do sistema
sSqlCamposLivres = "SELECT CASE WHEN ISNULL(campo1, '') = '' THEN 'Campo 1' ELSE campo1 END AS campo1, "&_
					"CASE WHEN ISNULL(campo2, '') = '' THEN 'Campo 2' ELSE campo2 END AS campo2,"&_
					"CASE WHEN ISNULL(campo3, '') = '' THEN 'Campo 3' ELSE campo3 END AS campo3,"&_
					"CASE WHEN ISNULL(campo4, '') = '' THEN 'Campo 4' ELSE campo4 END AS campo4, "&_
					"CASE WHEN ISNULL(ocorrencia, '') = '' THEN 'OCORRÊNCIAS' ELSE UPPER(ocorrencia) END AS titulo_ocorrencia "&_
					"FROM contencioso.dbo.parametros WHERE usuario = '" & session("vinculado") & "'"
	
Set rsCamposLivres = conn.execute(sSqlCamposLivres)
	
sCampo1 = "Campo 1"
sCampo2 = "Campo 2"
sCampo3 = "Campo 3"
sCampo4 = "Campo 4"
sTitulo = "OCORRÊNCIA"
	
if not rsCamposLivres.eof then
	sCampo1 = rsCamposLivres("campo1")
	sCampo2 = rsCamposLivres("campo2")
	sCampo3 = rsCamposLivres("campo3")
	sCampo4 = rsCamposLivres("campo4")
	sTitulo = rsCamposLivres("titulo_ocorrencia")
end if
'Fim da caoptura dos campos livres
	
'Verficando qual opcao de relatorio foi escolhida excel ou broffice
sTipoRlt = request("tipo_rlt")
if lcase(sTipoRlt) = "excel" then
	call Excel()
else
	call BrOffice()
end if

response.end
%>


<%
'-*-*-*-*-*-*-*-*-*-* INÍCIO DAS PROCEDURES *-*-*-*-*-*-*-*-*-*- 
Sub Excel()
	'-*-*-*-*-*-*-*-*-*-* MONTANDO O CABECALHO DO RELATORIO .XLS *-*-*-*-*-*-*-*-*-*- 
	'Obs.: Seguindo a ordem de exibicao relatorio detalhado 1
	'Obs.: Os campos multi-valorados, terao apenas o mais recente capturado, com excessao e envolvidos que terao os 10 ultimos cadastrados

	response.write "<table border = 1><tr>"
	
	'- Dados Principais
	Response.Write "<td>PROCESSO</td> <td>PASTA</td> <td>DATA CADASTRO</td> <td>OBJETO PRINCIPAL</td> <td>OBJETO</td>"&_
					"<td>PRINCIPAL</td> <td>POSIÇÃO</td> <td>NATUREZA</td> <td>COMPETÊNCIA</td> <td>TIPO AÇÃO</td>"&_ 
					"<td>TIPO PROCESSO</td> <td>INSTÂNCIA</td> <td>RITO</td> <td>SITUAÇÃO</td> <td>CAUSA</td> <td>ACORDO</td>"&_
					"<td>DATA ENCERRAMENTO</td> <td>RESPONSÁVEL</td> <td>COMARCA</td> <td>DATA CITAÇÃO</td> <td>JUÍZO</td>"&_ 
					"<td>DATA DISTRIBUIÇÃO</td> <td>ORGÃO</td>"
	
	'- Campos Livres
	Response.Write "<td>"& ucase(sCampo1) &"</td><td>"& ucase(sCampo2) &"</td><td>"& ucase(sCampo3) &"</td><td>"& ucase(sCampo4)&"</td>"
	
	'- Riscos
	Response.Write "<td>VALOR DA CAUSA</td> <td>VALOR PROVÁVEL</td> <td>RESULTADO PREVISTO</td> <td>VALOR FINAL</td>"
	
	'- Liminares
	Response.Write "<td>TIPO DE LIMINAR</td> <td>DATA DA INTIMAÇÃO</td> <td>TIPO DA MULTA</td> <td>VALOR DA MULTA</td> <td>ESTADO DA LIMINAR</td>"
	
	'- Ocorrencia
	Response.Write "<td>DATA - "& sTitulo & "</td> <td>DESCRIÇÃO - "& sTitulo & "</td> <td>PROTOCOLO - "& sTitulo & "</td>"&_
					"<td>DETALHE - "& sTitulo &"</td>"
	
	'- Providencias
	Response.Write "<td>DATA GERENCIAL</td> <td>DATA OFICIAL</td> <td>DESCRIÇÃO DA PROVIDÊNCIA</td>"
	
	'- Valores
	Response.Write "<td>DATA REF.</td> <td>VALOR</td> <td>MOEDA</td> <td>REFERÊNCIA DO VALOR</td> <td>OBS DO VALOR</td>"
	
	'- Descricao Detalhada
	Response.Write "<td>DESCRIÇÃO DO PROCESSO</td> <td>OBSERVAÇÕES DO PROCESSO</td>"
	
	'- Envolvidos
	for i=1 to 10
		Response.Write "<td>TIPO DO ENVOLVIDO - "& i &"</td> <td>PARTES DO ENVOLVIDO - "& i &"</td> <td>PASTA DO ENVOLVIDO - "& i &"</td>"
	next
	
	'Concluindo titulo das colunas e pulando para a proxima linha para iniciar insercao dos dados de cada coluna
	Response.Write "</tr>"
	'-*-*-*-*-*-*-*-*-*-* FIM DA MONTANDO DO CABECALHO DO RELATORIO .XLS *-*-*-*-*-*-*-*-*-*-
	
	'Executa a consulta
	sSql = "EXEC contencioso.dbo.CsvContencioso '" & session("vinculado") & "', '" & iIdProcAux & "'"
	'response.write sSql
	'response.end
	rsProcessos.open sSql, conn, 3, 3
	
	'-*-*-*-*-*-*-*-*-*-* INSERINDO OS DADOS DO RELATORIO .XLS *-*-*-*-*-*-*-*-*-*- 

	'-*-*-*-*-*-*-*-*-*-* FIM DA INSERCAO DOS DADOS DO RELATORIO .XLS *-*-*-*-*-*-*-*-*-*-

	'Apresenta o arquivo XLS para download
	response.write "<tr><td>"&chr(39)
	response.write replace(replace(replace(replace(rsProcessos.GetString(,,,"</td></tr><tr><td>"&chr(39),"<td></td>"),chr(34)&",="&chr(34),"</td><td>"),chr(34)&","&chr(34),"</td><td>"),chr(34),""), "<td></td>", "<td>&nbsp;</td>") 
	'OBS: Os replaces em sequencia, referem-se a ordem de execuçaõ abaixo:
	'replace(x,"'',=''", )
	'replace(x,",=''", )
	'replace(x,"'',", )
	'replace(x,",", )
	'replace(x,", )
	'replace(x,"<td></td>", "<td>&nbsp;</td>")


	response.write "</td></tr></table>"	
	
	Set rsProcessos = Nothing
	
	Response.AddHeader "Content-Disposition", "attachment; filename=Relatorio_Detalhado.xls"
	Response.ContentType = "application/vnd.ms-excel"
	
	response.end
End Sub

Sub BrOffice()
	'-*-*-*-*-*-*-*-*-*-* MONTANDO O CABECALHO DO RELATORIO .CSV *-*-*-*-*-*-*-*-*-*- 
	'Obs.: Seguindo a ordem de exibicao relatorio detalhado 1
	'Obs.: Os campos multi-valorados, terao apenas o mais recente capturado, com excessao e envolvidos que terao os 10 ultimos cadastrados
	
	'- Dados Principais
	Response.Write chr(34) &" PROCESSO "& chr(34) &","& chr(34) &" PASTA "& chr(34) &","& chr(34) &" DATA CADASTRO "& chr(34) &","&_
	chr(34) &" OBJETO PRINCIPAL "& chr(34) &","& chr(34) &" OBJETO "& chr(34) &","& chr(34) &" PRINCIPAL "& chr(34) &","&_
	chr(34) &" POSIÇÃO "& chr(34) &","& chr(34) &" NATUREZA "& chr(34) &","& chr(34) &" COMPETÊNCIA "& chr(34) &","&_
	chr(34) &" TIPO AÇÃO "& chr(34) &","& chr(34) &" TIPO PROCESSO "& chr(34) &","& chr(34) &" INSTÂNCIA "& chr(34) &","&_
	chr(34) &" RITO "& chr(34) &","& chr(34) &" SITUAÇÃO "& chr(34)&","& chr(34) &" CAUSA "& chr(34) &","&_
	chr(34) &" ACORDO "& chr(34) &","& chr(34) &" DATA ENCERRAMENTO "& chr(34) &","& chr(34) &" RESPONSÁVEL "& chr(34) &","&_
	chr(34) &" COMARCA "& chr(34)&","& chr(34) &" DATA CITAÇÃO "& chr(34) &","& chr(34) &" JUÍZO "& chr(34) &","&_
	chr(34) &" DATA DISTRIBUIÇÃO "& chr(34)&","& chr(34) &" ORGÃO "& chr(34) &","
	
	'- Campos Livres
	Response.Write chr(34) &" "& ucase(sCampo1)&" "& chr(34) &","&_
	chr(34) &" "& ucase(sCampo2)&" "& chr(34) &","&_
	chr(34) &" "& ucase(sCampo3)&" "& chr(34) &","&_
	chr(34) &" "& ucase(sCampo4)&" "& chr(34) &","
	
	'- Riscos
	Response.Write chr(34) &" VALOR DA CAUSA "& chr(34)&","& chr(34) &" VALOR PROVÁVEL "& chr(34) &","&_
	chr(34) &" RESULTADO PREVISTO "& chr(34) &","& chr(34) &" VALOR FINAL "& chr(34) &","
	
	'- Liminares
	Response.Write chr(34) &" TIPO DE LIMINAR "& chr(34)&","& chr(34) &" DATA DA INTIMAÇÃO "& chr(34) &","&_
	chr(34) &" TIPO DA MULTA "& chr(34) &","& chr(34) &" VALOR DA MULTA "& chr(34) &","&_
	chr(34) &" ESTADO DA LIMINAR "& chr(34) &","
	
	'- Ocorrencia
	Response.Write chr(34) &" DATA - "& sTitulo & chr(34)&","& chr(34) &" DESCRIÇÃO - "& sTitulo & chr(34) &","&_
	chr(34) &" PROTOCOLO - "& sTitulo & chr(34) &","& chr(34) &" DETALHE - "& sTitulo & chr(34) &","
	
	'- Providencias
	Response.Write chr(34) &" DATA GERENCIAL "& chr(34)&","& chr(34) &" DATA OFICIAL "& chr(34) &","&_
	chr(34) &" DESCRIÇÃO DA PROVIDÊNCIA "& chr(34) &","
	
	'- Valores
	Response.Write chr(34) &" DATA REF. "& chr(34)&","& chr(34) &" VALOR "& chr(34) &","& chr(34) &" MOEDA "& chr(34) &","&_
	chr(34) &" REFERÊNCIA DO VALOR "& chr(34) &","& chr(34) &" OBS DO VALOR "& chr(34) &","
	
	'- Descricao Detalhada
	Response.Write chr(34) &" DESCRIÇÃO DO PROCESSO "& chr(34)&","& chr(34) &" OBSERVAÇÕES DO PROCESSO "& chr(34) &","
	
	'- Envolvidos
	for i=1 to 10
		Response.Write chr(34) &" TIPO DO ENVOLVIDO - "& i & chr(34)&","& chr(34) &" PARTES DO ENVOLVIDO - "& i & chr(34) &","&_
		chr(34) &" PASTA DO ENVOLVIDO - "& i & chr(34) &","
	next
	
	'Concluindo titulo das colunas e pulando para a proxima linha para iniciar insercao dos dados de cada coluna
	Response.Write vbcrlf
	'-*-*-*-*-*-*-*-*-*-* FIM DA MONTANDO DO CABECALHO DO RELATORIO .CSV *-*-*-*-*-*-*-*-*-*-
	
	'Executa a consulta
	sSql = "EXEC contencioso.dbo.CsvContencioso '" & session("vinculado") & "', '" & iIdProcAux & "'"
	rsProcessos.open sSql, conn, 3, 3
	
	'-*-*-*-*-*-*-*-*-*-* INSERINDO OS DADOS DO RELATORIO .CSV *-*-*-*-*-*-*-*-*-*- 
	
	'-*-*-*-*-*-*-*-*-*-* FIM DA INSERCAO DOS DADOS DO RELATORIO .CSV *-*-*-*-*-*-*-*-*-*-
	'Apresenta o arquivo CSV para download
	response.write "="& rsProcessos.GetString(,,, vbcrlf&"=", "")
	
	Set rsProcessos = Nothing
	
	Response.AddHeader "Content-Disposition", "attachment; filename=Relatorio_Detalhado.csv"
	Response.ContentType = "application/CSV"
	
	response.end
End Sub
'-*-*-*-*-*-*-*-*-*-* ENCERRAMENTO DAS PROCEDURES *-*-*-*-*-*-*-*-*-*- 
%>