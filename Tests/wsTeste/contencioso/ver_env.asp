<!--#include file="../include/conn.asp"-->
<title>APOL Jurídico - Envolvidos</title>
<body leftmargin=0 topmargin=0 class="tabela<%=l_imp%>">
<link rel="STYLESHEET" type="text/css" href="style.css"> 
<link rel="STYLESHEET" type="text/css" href="style2.css">
<%
sql = "SELECT id, apelido, razao, cnpj_cpf, tipo, pasta, im, ie, hp, pessoa, logradouro1, bairro1, cidade1, estado1, cep1, tel1, fax1, end_pri1, end_corr1, end_fatu1, end_inpi1, logradouro2, bairro2, cidade2, estado2, cep2, tel2, fax2, end_pri2, end_corr2, end_fatu2, end_inpi2, contato1, email1, recebe1, contato2, email2, recebe2, contato3, email3, recebe3, desconto_inpi, anexo, objeto_social, obs FROM Envolvidos where id = " & Request.Querystring("id")
set rs = conn.execute(sql)	
%>
<table width="100%" class="tabela<%=l_imp%>" border="0" cellspacing="2" cellpadding="3">		
	<tr class="tit1<%=l_imp%>">
		<td colspan=2 align=center><b>	Visualização de Envolvidos</td>
	</tr>
	<tr>
		<td width=70px><b>Nome: </td>
		<td width=100%><%=rs("apelido")%></td>
	</tr>	
	<tr>
		<td width=70px><b>Endereço:</td>
		<td><%=rs("logradouro1")%> - <%=rs("bairro1")%></td>
	</tr>	
	<tr>
		<td width=70px><b>Cidade:</td>
		<td><%=rs("cidade1")%> - <%=rs("estado1")%></td>		
	</tr>	
</table>
<table width="100%" class="tabela<%=l_imp%>" border="0" cellspacing="2" cellpadding="3">		
	<tr>
		<td width=70px><b>Contato1:</td>
		<td width=50%><%=rs("contato1")%></td>		
		<td width=70px><b>Email:</td>		
		<td width=50%><%=rs("email1")%></td>		
	</tr>	
	<tr>
		<td width=70px><b>Contato2:</td>
		<td><%=rs("contato2")%></td>		
		<td><b>Email:</td>		
		<td><%=rs("email2")%></td>		
	</tr>	
	<tr>
		<td width=70px><b>Contato3:</td>
		<td><%=rs("contato3")%></td>		
		<td><b>Email:</td>		
		<td><%=rs("email3")%></td>		
	</tr>		
</table>