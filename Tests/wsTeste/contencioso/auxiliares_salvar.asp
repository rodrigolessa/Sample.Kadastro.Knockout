<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'-->
<%
if trim(request("descricao")) = "" then
	%>
	<script>
		alert("A Descrição não pode estar em branco.");
		history.go(-1);
	</script>
	<%
	response.end
end if

select case request("tipo")
	case "N"
		xtit = "Natureza"
	
	case "P"
		xtit = "Providência"
		
	case "H"
		xtit = "Históricos"
		
	case "R"
		xtit = "Rito"
	
	case "O"
		xtit = "Órgão"
		
	case "J"
		xtit = "Juizo"
		
	case "C"
		xtit = "Comarca"

	case "T"
		xtit = "Tipo&nbsp;de&nbsp;Ação"
		
	case "F"
		xtit = "Referência&nbsp;Financeira"
		
	case "L"
		xtit = "Objeto&nbsp;Principal"
	
	case "3"
		xtit = Replace(Request("campo"), " ", "&nbsp;")
		
	case "4"
		xtit = Replace(Request("campo"), " ", "&nbsp;")
end select

estado = request("estado")
descricao = tplic(0, replace(request("descricao"), "'", "`"))
if len(descricao) > 50 then
	descricao = left(descricao, 50)
end if

if request("codigo") = "" then
	sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' AND tipo = '"&tplic(0,request("tipo"))&"' and descricao = '" & descricao & "'"
	set rst = db.execute(sql)
	if not rst.eof then%>
		<script>
			alert("Descrição já cadastrada.");
			history.go(-1);
		</script>
		<%
		response.end
	end if
	sql = "insert into auxiliares (usuario, tipo, descricao, estado) values ('"&session("vinculado")&"', '"&tplic(0,request("tipo"))&"', '" & descricao & "','"&tplic(0,replace(estado,"'","´"))&"')"
	ok = grava_log_c(session("nomeusu"), "INCLUSÃO", ucase(replace(xtit, "&nbsp;", " ")), descricao)
	db.execute(sql)
	
	response.redirect "auxiliares.asp?tipo="&request("tipo")&"&pdescricao_c="&request("pdescricao_c")&"&campo="&request("campo")
	
else
	sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' AND codigo = "&tplic(1,request("codigo"))
	set rst = db.execute(sql)
	if not rst.eof then
		descricao_antiga = rst("descricao")
		sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' AND tipo = '"&tplic(0,request("tipo"))&"' and descricao = '" & descricao_antiga & "' and codigo <> "&tplic(1,request("codigo"))
		set rst = db.execute(sql)
		if not rst.eof then
			%>
			<script>
				alert("Descrição já cadastrada.");
				history.go(-1);
			</script>
			<%
			response.end
		end if
	end if
	sql = "update auxiliares set tipo = '"&tplic(0,request("tipo"))&"', descricao = '" & descricao & "', estado = '"&tplic(0,replace(estado,"'","´"))&"' where codigo = "&tplic(1,request("codigo"))
	ok = grava_log_c(session("nomeusu"), "ALTERAÇÃO", ucase(replace(xtit, "&nbsp;", " ")), descricao)
	db.execute(sql)
end if

response.redirect "auxiliares_list.asp?PRIMEIRO=N&tipo="&request("tipo")&"&pdescricao_c="&request("pdescricao_c")&"&campo="&request("campo")
%>