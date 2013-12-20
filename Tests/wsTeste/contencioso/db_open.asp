<%
'Set DB = Server.CreateObject("ADODB.Connection")
'DataSource = "contencioso"
'DB.Open DataSource

set db = Server.CreateObject("ADODB.Connection")
db.ConnectionTimeOut= 420
db.CommandTimeOut= 420
if paginacao then
	db.CursorLocation = 3
end if
DataSource = "DRIVER={SQL Server};server="&Application("nome_servidor_dados")&";" & _
        "UID="&Application("usuario")&";PWD="&Application("senha")&";" & _
        ";DATABASE=CONTENCIOSO"
DB.Open DataSource

sql = "SELECT ocorrencia FROM parametros WHERE usuario = '"&session("vinculado")&"'"
set rs_par = db.execute(sql)
if not rs_par.eof then
	if isnull(rs_par("ocorrencia")) Then
		ocorrencia_C = "Ocorrências"
	elseif replace(rs_par("ocorrencia")," ","") = "" Then
		ocorrencia_C = "Ocorrências"
	else
		ocorrencia_C = replace(rs_par("ocorrencia")," ","&nbsp;")
	end if
end if

function grava_log_cont(usu,acao,onde,desc)
	desc = replace(desc,"'","")
	DB.execute("INSERT INTO apol.dbo.Log(usuario,acao,onde,descricao,modulo) VALUES('"&tplic(0,usu)&"','"&tplic(0,acao)&"','"&tplic(0,onde)&"','"&tplic(0,desc)&"','C')")
	grava_log_cont = true
end function
%>
<!--#include file="funcoes.asp"-->
