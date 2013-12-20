<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn_webseek.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<!--#include file='../include/Db_open_webseek_teste.asp'-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<%

prazo = "prazo_ger"

	sqlCampo = "UPDATE Parametros SET ocorrencia = '"&tplic(0,request("ocorrencia"))&"', andamentos = '"&tplic(0,request("andamentos"))&"',campo1='"&tplic(0,request("campo1")) & "', campo2='"&tplic(0,request("campo2")) & "', campo3='"&tplic(0,request("campo3")) & "', campo4='"&tplic(0,request("campo4")) & "' "
	sqlCampo = sqlCampo & " WHERE  usuario = '"&session("vinculado")&"'"

	db.execute(sqlCampo)
	ok = grava_log_cont(session("nomeusu"),"ALTERAÇÃO","PARÂMETROS","Nomes dos Campos => Ocorrência = "&tplic(0,request("ocorrencia"))& ", Andamentos = "&tplic(0,request("andamentos"))&", Campo 1 = "&tplic(0,request("campo1")) & ", Campo 2 = "&tplic(0,request("campo2"))&", Campo 3 = "&tplic(0,request("campo3")) & ", Campo 4 = "&tplic(0,request("campo4")))
	response.redirect("param.asp")
%>