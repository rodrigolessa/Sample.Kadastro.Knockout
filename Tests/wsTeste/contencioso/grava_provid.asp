<!--#include file="db_open.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="../usuario_logado.asp"-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<!--#include file="../include/funcoes.asp"-->
<html>

<% 
'-- =========================================================================
'-- Author: Marcos Muller   -  OS : 4159'-- Create date: 12-10-2012 � 22-10-2012 
'-- Description: fun��o para caturar andamentos da conex�o com tribunais
'-- =========================================================================

	desc = request.form("descanda")
	desc = left(desc,399)


	sql = "INSERT INTO Providencias(usuario, prazo_ger, prazo_ofi, processo, descricao, tipo)  VALUES('"&Session("vinculado")&"', "&rdata(request.querystring("dtger"))&", "&rdata(request.querystring("dtofi"))&", '"&request.querystring("id_processo")&"','" & desc & "', 'C')"
	conn.execute(sql)
	ok = grava_log_c(session("nomeusu"),"INCLUS�O","PROVID�NCIA","A PARTIR DE UM ANDAMENTO - N� "&request("id_processo"))

	%>

	<script> 
		history.back();
	</script>

%>

</body>
</html>










