<%
if request.querystring("idioma") = "" then
	select case request.Cookies("APOL")("idioma")
	case "p"
		idioma = "portugues"
		Response.Cookies("APOL")("idioma") = "p"
	case "i"
		idioma = "ingles"
		Response.Cookies("APOL")("idioma") = "i"
	case else
		idioma = "portugues"
		Response.Cookies("APOL")("idioma") = "p"
	end select
	Response.Cookies("APOL").Expires = DateAdd("m", 1, date)
else
	select case request.querystring("idioma")
	case "p"
		idioma = "portugues"
		Response.Cookies("APOL")("idioma") = "p"
	case "i"
		idioma = "ingles"
		Response.Cookies("APOL")("idioma") = "i"
	case else
		idioma = "portugues"
		Response.Cookies("APOL")("idioma") = "p"
	end select
	Response.Cookies("APOL").Expires = DateAdd("m", 1, date)
end if

set conn = Server.CreateObject("ADODB.Connection")
conn.ConnectionTimeOut= 420
conn.CommandTimeOut= 420
DataSource = "DRIVER={SQL Server};server="&Application("nome_servidor_dados")&";" & _
        "UID="&Application("usuario")&";PWD="&Application("senha")&";" & _
       "DATABASE=apol"
'datasource="Provider=sqloledb; Data Source=lua; Initial Catalog=apol;User Id="&Application("usuario")&"; Password="&Application("senha")&";" 

if paginacao then
	conn.CursorLocation = 3
end if		
conn.Open Datasource

%>
