<%

	Dim objConn, strConn, strSource, strCatalog, strUserID

	Set objConn = Server.CreateObject("ADODB.connection")
	strSource = "LD-RLESSA\SQLEXPRESS"
	strCatalog = "kadastro"
	strUserID = "LCDINTERNO\rlessa"
	strUserPassword = "T5y6u7i8"
	'strConn = "Provider=SQLOLEDB;Persist Security Info=False;User ID="&strUserID&";password="&strUserPassword&";Initial Catalog="&strCatalog&";Data Source=" & strSource
	'strConn = "Provider=SQLOLEDB;Integrated Security=SSPI;User ID=" & strUserID & ";password=" & strUserPassword & ";Initial Catalog=" & strCatalog & ";Data Source=" & strSource

	'strConn = "Provider=SQLOLEDB;Persist Security Info=False;Data Source=Kadastro;Initial Catalog=kadastro"

	strConn = "Provider=MSDASQL.1;Persist Security Info=False;Data Source=Kadastro;Initial Catalog=kadastro"

	objConn.Open(strConn)


	sql="SELECT * FROM [kadastro].[dbo].[ponto]"

	Set rs = objConn.Execute(sql)

	do while not rs.eof

	response.write "<br>dia" & rs("dia")

	rs.movenext

	loop
%>