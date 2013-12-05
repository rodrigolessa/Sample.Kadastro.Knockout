<%

	Dim objConn, strConn, strSource, strCatalog, strUserID

	Set objConn = Server.CreateObject("ADODB.connection")
	strSource = "LD-RLESSA\SQLEXPRESS"
	strCatalog = "kadastro"
	strUserID = "LCDINTERNO\rlessa"
	'strConn = "Provider=SQLOLEDB;Persist Security Info=False;User ID=LCDINTERNO\rlessa;password=T5y6u7i8;Initial Catalog=kadastro;Data Source=" & strSource
	strConn = "Provider=SQLOLEDB;Integrated Security=SSPI;User ID=" & strUserID & ";Initial Catalog=" & strCatalog & ";Data Source=" & strSource
	objConn.Open(strConn)

%>