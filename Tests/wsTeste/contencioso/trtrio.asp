<%server.ScriptTimeOut = 420%>
<!--#include file="db_open.asp"-->
<!--#include file="../include/conn.asp"-->
<%
Sub pega_link(processo)
	On Error Resume Next

	proc = processo
	sql = "select data from chk_tribunal where usuario = '"&Session("vinculado")&"' and processo = '"&tplic(0,proc)& "'"
	set rs_chk = db.execute(sql)
	if not rs_chk.eof then
		db.execute("update chk_tribunal set data = getdate() where usuario = '"&Session("vinculado")&"' and processo = '"&tplic(0,proc)& "'")
	else
		db.execute("insert into chk_tribunal (usuario, data, processo) values ('"&Session("vinculado")&"', getdate(), '"&tplic(0,proc)& "')")
	end if
	sql = "select data from chk_tribunal where usuario = '"&Session("vinculado")&"' and processo = '"&tplic(0,proc)& "'"
	set rs_chk_dt = db.execute(sql)

	if not isnumeric(processo) then
		for i=1 to len(processo)
			aux = mid(processo,i,1)
			if isnumeric(aux) then
				proc_aux = proc_aux & aux
			end if
		next

		numero = mid(proc_aux,1,5)
		ano = mid(proc_aux,6,4)
		vara = mid(proc_aux,10,3)
		sequencial = mid(proc_aux,15,2)
	else
		numero = mid(processo,1,5)
		ano = mid(processo,6,4)
		vara = mid(processo,10,3)
		sequencial = mid(processo,15,2)
	end if
	
	session("atu")=0 'variável para contar quantos registros foram inseridos
	qs = "numero="&numero&"&ano="&ano&"&vara="&vara&"&sequencial="&sequencial
	pagina = "http://trt1-webbanco.trtrio.gov.br/nuResultado.jsp?" & qs
	Set xml = Server.CreateObject("Microsoft.XMLHTTP")
	
	xml.Open "post", pagina, False
	xml.Send(pagina)
	If Err.Number <> 0 Then
		%>
		<script>
		alert("Erro de comunicação com o Servidor!")
		top.para_anima_sync()
		location = "proc_ocorrencia.asp?id_processo=<%=request.querystring("id_processo")%>"
		</script>
		<%
		response.end
    End If
	
	texto=xml.responseText
	
	if inStr(texto,"Processo Inexistente") > 0 then
		%>
		<script>
		alert("Processo não encontrado!")
		top.para_anima_sync()
		top.escrevelyr('dt_atu_trib','<b>Ultima sincronização: <%= rs_chk_dt("data") %></b>')
		location = "proc_ocorrencia.asp?id_processo=<%=request.querystring("id_processo")%>"
		</script>
		<%
		response.end
	end if
	
	texto = mid(texto,1,len(texto)-20)
	texto = mid(texto,inStr(texto,"<a href"),len(texto))
	texto = replace(texto,"<td>&nbsp;</td>","")
	texto = replace(texto,"<tr align=""center""><td>","")
	
	arrtexto = split(texto,vbcrlf)
	
	for i=0 to ubound(arrtexto)
		if inStr(arrtexto(i),"<a href") > 0 then
			pagina2 = arrtexto(i)
			pagina2 = replace(pagina2,"<a href='","")
			pagina2 = mid(pagina2,1,(inStr(pagina2,"'>")-1))

			webpage = "http://trt1-webbanco.trtrio.gov.br/"&pagina2
			pega_desp_rio webpage,processo
			
		end if
	next
	
	set xml = Nothing
	
	%>
	<script>
	alert("Sincronização efetuada com Sucesso!\n<% If session("atu") = 0 then %>Não houve atualização.<% Else %><% If session("atu") = 1 then %>Foi feita <%= session("atu") %> atualização.<% Else %>Foram feitas <%= session("atu") %> atualizações.<% End If %><% End If %>")
	top.para_anima_sync()
	top.escrevelyr('dt_atu_trib','<b>Ultima sincronização: <%= rs_chk_dt("data") %></b>')
	location = "proc_ocorrencia.asp?id_processo=<%=request.querystring("id_processo")%>"
	</script>
	<%
End Sub


'============================================================================================

Sub pega_desp_rio(pagina, numero_processo)
    'On Error Resume Next

    Set xml2 = Server.CreateObject("Microsoft.XMLHTTP")
	xvLink2 = pagina
	xml2.Open "post", xvLink2, False
	xml2.Send(xvlink2)
	If Err.Number <> 0 Then
		%>
		<script>
		alert("Erro de comunicação com o Servidor!")
		</script>
		<%Response.end
    End If

	txt2=xml2.responseText
	
	dir = server.mappath("captura/")&"\" &numero_processo& ".txt"
	
	Set fso = CreateObject("Scripting.FileSystemObject")

	sql = "select data from chk_tribunal where usuario = '"&Session("vinculado")&"' and processo = '"&tplic(0,numero_processo)& "'"
	set rs_chk = db.execute(sql)
	if not rs_chk.eof then
		db.execute("update chk_tribunal set data = getdate() where usuario = '"&Session("vinculado")&"' and processo = '"&tplic(0,numero_processo)& "'")
	else
		db.execute("insert into chk_tribunal (usuario, data, processo) values ('"&Session("vinculado")&"', getdate(), '"&tplic(0,numero_processo)& "')")
	end if
	sql = "select data from chk_tribunal where usuario = '"&Session("vinculado")&"' and processo = '"&tplic(0,numero_processo)& "'"
	set rs_chk_dt = db.execute(sql)
	
	if inStr(txt2,"Inexistente") > 0 then
		%>
		<script>
		alert("Processo não encontrado!");
		top.para_anima_sync()
		location = "proc_ocorrencia.asp?id_processo=<%=request.querystring("id_processo")%>"
		</script>
		<%
		response.end
	else
		if inStr(txt2,"Andamentos") > 0 then
			if inStr(pagina,"tipo=RT") > 0 then	

				'fso.CreateTextFile dir,true
				Set MyFile = fso.OpenTextFile(dir, 2, True)

				temp = replace(txt2,chr(10),"#%@!!@%#")
				texto = split(temp,"#%@!!@%#")

				for z= 0 to ubound(texto)-1
					MyFile.WriteLine texto(z)
				next
			
				Set MyFile = fso.OpenTextFile(dir, 1)
				
				arquivo = MyFile.ReadAll
				
				arquivo = mid(arquivo,1,len(arquivo)-58)
				exibir = mid(arquivo,inStr(arquivo,"contem=andamentos"),len(arquivo))
				exibir = replace(exibir,"<td width=""10"">&nbsp;</td>","#@#")
				exibir = replace(exibir,"<td valign=""top"">","")
				exibir = replace(exibir,"<tr>","")
				exibir = replace(exibir,"<td>","")
				exibir = replace(exibir,"</td>","")
				exibir = replace(exibir,"</tr>","<br>")
				exibir = replace(exibir,"<td>","")
				exibir = replace(exibir,"</b>","")
				exibir = replace(exibir,"<table border=0 cellspacing=0 cellpadding=0 >","")
				exibir = replace(exibir,"Andamentos","")
				exibir = replace(exibir,"contem=andamentos>","")
				
				ArrInsert = split(exibir, "<br>")
				
				
				for y=lbound(ArrInsert) to ubound(ArrInsert)
					if not isnull(ArrInsert(y)) and not isempty(ArrInsert(y)) and len(trim(ArrInsert(y))) > 0 then
						dados = split(ArrInsert(y),"#@#")
						if ubound(dados) > 0 then

							data_desp=trim(dados(0))
							despacho = trim(dados(1))
							
							sqlV = "SELECT id FROM ocorrencias WHERE (data = " &rdata(data_desp)& ") and (ocorrencia = '"&tplic(0,despacho)&"') and (processo = '"&tplic(0,numero_processo)& "') AND (usuario = '"&Session("vinculado")&"')"
							set rs_chk = conn.execute(sqlV)
							
							if rs_chk.eof then
								sqlI="insert into ocorrencias (usuario, processo, data, ocorrencia, tipo) values ('"&Session("vinculado")&"', '"&tplic(0,numero_processo)& "', " &rdata(data_desp)& ", '"&tplic(0,despacho)&"', 'T')"
								conn.execute(sqlI)
								ok = grava_log_c(session("nomeusu"),"INCLUSÃO","OCORRÊNCIA","Sincronização com tribunal - "&nome_tribunal&" - Processo: "&tplic(0,numero_processo))
								session("atu") = session("atu")+1
							end if
						end if
					end if
				next
				Myfile.close()
				
			elseif inStr(pagina,"tipo=RO") > 0 then

				'fso.CreateTextFile dir,true
				Set MyFile = fso.OpenTextFile(dir, 2, True)

				temp = replace(txt2,chr(10),"#%@!!@%#")
				texto = split(temp,"#%@!!@%#")

				for z= 0 to ubound(texto)-1
					MyFile.WriteLine texto(z)
				next
			
				Set MyFile = fso.OpenTextFile(dir, 1)
				
				arquivo = MyFile.ReadAll
				arquivo = mid(arquivo,1,len(arquivo)-58)
				exibir = mid(arquivo,inStr(arquivo,"contem=andamentos"),len(arquivo))
				exibir = replace(exibir,vbcrlf,"")
				exibir = replace(exibir,"<td width=""10"">&nbsp;</td>","#@#")
				exibir = replace(exibir,"<tr><td valign=""top"">","")
				exibir = replace(exibir,"<td>","")
				exibir = replace(exibir,"</td>","")
				exibir = replace(exibir,"</tr>","#$%")
				exibir = replace(exibir,"<tr><td>","")
				exibir = replace(exibir,"<tr>","")
				exibir = replace(exibir,"</b>","")
				exibir = replace(exibir,"<table border=0 cellspacing=0 cellpadding=0 >","")
				exibir = replace(exibir,"Andamentos","")
				exibir = replace(exibir,"contem=andamentos>","")
				exibir = replace(exibir,"<td valign=""top"">","")

				ArrInsert = split(exibir, "#$%")
				
				for x=lbound(ArrInsert) to ubound(ArrInsert) 
					if not isnull(ArrInsert(x)) and not isempty(ArrInsert(x)) and len(trim(ArrInsert(x))) > 0 then
						ArrInsert(x) = replace(ArrInsert(x),chr(9),"")
						if instr(ArrInsert(x),"#@#") > 0 then
							dados1 = split(ArrInsert(x),"#@#")
							
							data_desp= replace(dados1(0),vbcrlf,"")
							despacho = replace(dados1(1),vbcrlf,"")
							
							data_desp = replace(data_desp," ","")
							
							sqlV = "SELECT id FROM ocorrencias WHERE (data = " &rdata(data_desp)& ") and (ocorrencia = '"&tplic(0,despacho)&"') and (processo = '"&tplic(0,numero_processo)& "') AND (usuario = '"&Session("vinculado")&"')"
							set rs_chk = conn.execute(sqlV)
							if rs_chk.eof then
								sqlI="insert into ocorrencias (usuario, processo, data, ocorrencia, tipo) values ('"&Session("vinculado")&"', '"&tplic(0,numero_processo)& "', " &rdata(data_desp)& ", '"&tplic(0,despacho)&"', 'T')"
								conn.execute(sqlI)
								ok = grava_log_c(session("nomeusu"),"INCLUSÃO","OCORRÊNCIA","Sincronização com tribunal - "&nome_tribunal&" - Processo: "&tplic(0,numero_processo))
								session("atu") = session("atu")+1
							end if
						end if
					end if
				next
				Myfile.close()
			end if
		end if
	end if

	txt2 = ""
	set xml2 = Nothing

End Sub

processo1 = request("processo1")
id_tribunal = request("id_tribunal")

sql = "select nome_tribunal from tribunais where id_tribunal = " & tplic(0,id_tribunal)
set rs = db.execute(sql)
nome_tribunal = rs("nome_tribunal")

pega_link(processo1)
%>