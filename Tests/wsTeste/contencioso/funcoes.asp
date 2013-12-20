<%
sub send_email(EmailTo,EmailFrom,EmailSubject,EmailBody)
	Set objNet = CreateObject("WScript.Network")
	servidor = objNet.ComputerName
	if lcase(servidor) = "venus" OR lcase(servidor) = "lua" or lcase(servidor) = "webseek1" or lcase(servidor) = "terra" then
		stitulo = " / " & EmailTo & " - " & ucase(servidor)
	else
		stitulo = ""
	end if
	
	'Cria o objeto para o envio de e-mail 
	Set objCDOSYSMail = CreateObject("CDO.Message") 
	'Cria o objeto para configuração do SMTP 
	Set objCDOSYSCon = CreateObject ("CDO.Configuration") 
	'SMTP 
	objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver") = servidor 
	'Porta do SMTP 
	objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25 
	'Porta do CDO 
	objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 
	'TimeOut 
	objCDOSYSCon.Fields("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60 
	objCDOSYSCon.Fields.update 
	
	'Atualiza a configuração do CDOSYS para o envio do e-mail 
	Set objCDOSYSMail.Configuration = objCDOSYSCon 
	'E-mail do remetente 
	objCDOSYSMail.From = EmailFrom 
	
	'********** [ E-MAIL DO DESTINATÁRIO ] **********
	objCDOSYSMail.To = EmailTo 
	'objCDOSYSMail.To = "bernardo@ldsoft.com.br" 
	'************************************************
	
	'Assunto da mensagem 
	objCDOSYSMail.Subject = EmailSubject&stitulo
	'Conteúdo da mensagem 
	objCDOSYSMail.HtmlBody = EmailBody
	'Para envio da mensagem no formato txt altere o HtmlBody para TextBody 
	'objCDOSYSMail.TextBody = EmailBody
	'objCDOSYSMail.fields.update 
	
	'Envia o e-mail 
	On Error Resume Next
	objCDOSYSMail.Send 
	If Err <> 0 Then
	   Response.Write "<script>alert('E-mail inválido e não pôde ser enviado.');</script>"
	End If
	
	'Destrói os objetos 
	Set objCDOSYSMail = Nothing 
	Set objCDOSYSCon = Nothing 
end sub

function tplic(tptipo,txt)
	if ("#"&txt&"#" = "##") or isnull(txt) then
		tplic = ""
	else
		'Response.Write("#"&txt&"#<br>")
		txt = trim(replace(txt&" ","'","''"))
		txt = replace(txt,chr(34),chr(147))
		tplic = replace(txt,"§","º")
		
		badChars1 = array("SP_", "XP_", "--")
		for itp = 0 to uBound(badChars1)
			tplic = replace(tplic, badChars1(itp), "")
		next
		
		if tptipo = 1 then
			badChars = array("SELECT ", "INSERT ", "CREATE ", "DELETE ", "FROM ", "WHERE ", " OR ", " AND ", " LIKE ", "EXEC ", "SP_", "XP_", " ROWSET", "OPEN ", "BEGIN ", " END", "DECLARE ", "--")
			for itp = 0 to uBound(badChars)
				tplic = replace(tplic, badChars(itp), "")
			next
		end if
	end if
end function

function t0(num)
	if num = "" then
		num = 0
	end if
	t0 = tplic(1,num)
	if t0 = "Verdadeiro" or t0 = "True" then
		t0 = 1
	end if
	if t0 = "Falso" or t0 = "False" then
		t0 = 0
	end if
end function

function fdata(data)
	if isdate(data) then
		if len(day(data)) = 1 then
			dia = "0"&day(data)
		else
			dia = day(data)
		end if
		if len(month(data)) = 1 then
			mes = "0"&month(data)
		else
			mes = month(data)
		end if
		fdata = dia&"/"&mes&"/"&year(data)
	else
		fdata = ""
	end if
end function

function rdata(data)
	data = tplic(1,data)
	if (data = "") or (data = "//") or (isnull(data)) then
		rdata = "NULL"
	else
		rdata = "'"&month(data)&"/"&day(data)&"/"&year(data)&"'"
	end if
end function

function vnproc(nproc)
	if IsNumeric(nproc) then
		if len(nproc) = 9 then
			if Instr(nproc, ".") < 1 then
				x=0
				for cont=1 to 8
					x=x+(cint(mid(nproc,cont,1))*(10-cont))
				next
				x = x mod 11
				x = 11 - x
				if (x = 10) or (x=11) then
					x=0
				end if
				'response.write("x="&x)
				if cint(right(nproc,1)) = x then
					vnproc = true
				else
					vnproc = false
				end if
			else
				vnproc = false
			end if
		else
			vnproc = false
		end if
	else
		vnproc = false
	end if
end function

function mostra_label(fcampo,fclass,flink)
if not rs_pg.eof then
	fvalor = rs_pg(idioma)
	ncampo = rs_pg("nome")
	do while ncampo <> fcampo
		fvalor = rs_pg(idioma)
		ncampo = rs_pg("nome")
		rs_pg.movenext
		if (rs_pg.eof) and (ncampo <> fcampo) then
			fvalor = "<b>Campo não encontrado</b>"
			exit do
		end if
	loop
	rs_pg.movefirst
else
	fvalor = "<b>PG não encontrada</b>"
end if
if (fvalor = "") or (isnull(fvalor)) then
fvalor = "<b>Campo nulo</b>"
end if
fvalor = replace(fvalor,"#L#", "<a href="&flink&" class="&fclass&">",1,-1,1)
fvalor = replace(fvalor,"#/L#", "</a>",1,-1,1)
if fclass <> "" then
fvalor = "<span class="&fclass&">" & fvalor & "</span>"
end if
fvalor = replace(fvalor,vbcrlf, "<br>",1,-1,1)
mostra_label = fvalor
end function

function mostra_botao(fcampo,fclass,flink)
if not rs_pg.eof then
	fvalor = rs_pg(idioma)
	ncampo = rs_pg("nome")
	do while ncampo <> fcampo
		fvalor = rs_pg(idioma)
		ncampo = rs_pg("nome")
		rs_pg.movenext
		if (rs_pg.eof) and (ncampo <> fcampo) then
			fvalor = "<b>Campo não encontrado</b>"
			exit do
		end if
	loop
	rs_pg.movefirst
else
	fvalor = "<b>PG não encontrada</b>"
end if
if (fvalor = "") or (isnull(fvalor)) then
	fvalor = "<b>Campo nulo</b>"
end if
if fclass = "" then
	fclass = "botao"
end if
fvalor = "&nbsp;<a href="""&flink&""" class="""&fclass&""">" & fvalor & "</a>&nbsp;"
botao = "<table border=""0"" cellpadding=""0"" cellspacing=""0""><tr><td><img src=""imagem/botao_le.gif"" width=""5"" height=""25"" border=""0""></td><td background=""imagem/botao_meio.gif"" height=""25"">" &fvalor& "</td><td><img src=""imagem/botao_ld.gif"" width=""5"" height=""25"" border=""0""></td></tr></table>"
mostra_botao = botao
end function

function mostra_campo(fcampo,ftipo,fvalor,fobrig)
set rs_campo = conn.execute("SELECT "&idioma&", valor FROM Campos WHERE pg = '"&lista_pg&"' AND nome = '"&fcampo&"' order by "&idioma)
if not rs_campo.eof then
	if ftipo = "combo" then
		%>
		<select class="cfrm" name="<%= fcampo %>">
		<% If fobrig <> 1 then %><option value=""<% If fvalor = "" then %> SELECTED<% End If %>> </option><% End If %>
		<%
		while not rs_campo.eof
			%>
			<option value="<%= rs_campo("valor") %>"<% If cstr(fvalor) = cstr(rs_campo("valor")) then %> SELECTED<% End If %>><%= rs_campo(idioma) %></option>
			<%
			rs_campo.movenext
		wend
		%>
		</select>
		<%
	else if ftipo = "check" then
		MyArray = Split(fvalor, ",", -1, 1)
		while not rs_campo.eof
			%>
			<input type="checkbox" name="<%= fcampo %>" value="<%= rs_campo("valor") %>"<% for i=0 to UBound(MyArray) %><% If trim(MyArray(i)) = cstr(rs_campo("valor")) then %> checked<% End If %><% next %>> <%= rs_campo(idioma) %><br>
			<%
			rs_campo.movenext
		wend
	else if ftipo = "radio" then
		while not rs_campo.eof
			%>
			<input type="Radio" name="<%= fcampo %>" value="<%= rs_campo("valor") %>"<% If cstr(fvalor) = cstr(rs_campo("valor")) then %> checked<% End If %>> <%= rs_campo(idioma) %>
			<%
			rs_campo.movenext
		wend
	else if ftipo = "valor" then
		while not rs_campo.eof
			If cstr(fvalor) = cstr(rs_campo("valor")) then
			%>
			<%= rs_campo(idioma) %>
			<%
			end if
			rs_campo.movenext
		wend
	end if
	end if
	end if
	end if
else
	response.write("<b>PG/Campo não enontrado</b>")
end if
end function

function achaindex(vararray,ss)
	mi = ""
	for i = 0 to ubound(vararray)
		if cstr(ss) = cstr(vararray(i)) then
		mi = i
		exit for
		end if
	next
	achaindex = mi
end function

function valid_processo(numproc)
	if (len(numproc) = 9) and (isnumeric(numproc)) then
		a = cint(mid(numproc,1,1))
		b = cint(mid(numproc,2,1))
		c = cint(mid(numproc,3,1))
		d = cint(mid(numproc,4,1))
		e = cint(mid(numproc,5,1))
		f = cint(mid(numproc,6,1))
		g = cint(mid(numproc,7,1))
		h = cint(mid(numproc,8,1))
		x = cint(mid(numproc,9,1))
		dv = ((a*9) + (b*8) + (c*7) + (d*6) + (e*5) + (f*4) + (g*3) + (h*2)) mod 11
		if dv < 2 then
			dv = 0
		else
		dv = 11 - dv
		end if
		
		if x <> dv then
			valid_processo = false
		else
			valid_processo = true
		end if
	else
		valid_processo = false
	end if
end function

'-------------------------------------------------------------------------------------
function monta_insert(tabela,inicio,cont_usu)
'-------------------------------------------------------------------------------------
	if cont_usu = "N" then
		sql = "insert into "&tabela&" ("
	else
		sql = "insert into "&tabela&" (usuario,"
	end if
		for each itens in request.form
			if left(itens,1) = inicio	 then
				sql = sql & mid(itens,2,len(itens)-3)&","
			end if
		next
		
		if cont_usu = "N" then
			sql = mid(sql,1,len(sql)-1) & ") Values ( "
		else
			sql = mid(sql,1,len(sql)-1) & ") Values ('"&session("vinculado")&"', "
		end if
		
		for each itens in request.form
			if left(itens,1) = inicio	 then
				select case right(itens,1)
					case "d"
						sql = sql & rdata(trim(request.form(itens)))&","
					case "c"
						sql = sql & "'"&replace(trim(request.form(itens)),"'","´")&"',"
					case "n"
						if request.form(itens) <> "" then
							dim varNumSql : varNumSql = request.form(itens)
							if  instr (varNumSql,".") > 0 then 
								varNumSql = replace(varNumSql,".","")
							end if 
							sql = sql & "'"&replace(replace(trim(varNumSql),"'","´"),",",".")&"',"
						else
							sql = sql & "Null,"
						end if

				end select					
			end if
		next
		
		sql = replace(mid(sql,1,len(sql)-1) & ")","''","Null")		

		'response.write sql
		'response.end
end function

'-------------------------------------------------------------------------------------
function monta_update(tabela,inicio,condicao,cont_usu)

	if cont_usu = "N" then
		sql = "update "&tabela&" set "
	else
		sql = "update "&tabela&" set usuario = '"&session("vinculado")&"', "
	end if

	for each itens in request.form

		'response.write "itens = " & itens
		'response.write "<br>"

		if (tabela = "TabProcCont") and (itens = "fprocesso_c") then
			'não adiciona no UPDATE
		else

			if left(itens,1) = inicio then
				sql = sql & mid(itens,2,len(itens)-3)&"="
				select case right(itens,1)
					case "d"
						sql = sql & rdata(trim(request.form(itens))) & ", "
					case "c"
						sql = sql & "'"&replace(trim(request.form(itens)),"'","´")&"', "
					case "n"
						if request.form(itens) <> "" then
							dim UpVarNumSql : UpVarNumSql = request.form(itens)
							if  instr (UpVarNumSql,".") > 0 then 
								UpVarNumSql = replace(UpVarNumSql,".","")
							end if 
							sql = sql & replace(replace(trim(UpVarNumSql),"'","´"),",",".")&", "
						else
							sql = sql & "Null, "
						end if
				end select
			end if

		end if

	next
		
	sql = replace(mid(sql,1,len(sql)-2),"''","Null") & condicao

	If Session("processo_origem") = "sim" then
		If instr(sql,"acordo") = 0 then
			sql = replace(sql,"usuario","acordo = '0', usuario")
		End if
	End If

	'response.write sql
	'response.write "<br><br>"

	Session("processo_origem") = ""

end function

'-------------------------------------------------------------------------------------
function monta_filtro(tabela,inicio)
'-------------------------------------------------------------------------------------
	sql = " 0 = 0 and "
		for each itens in request.querystring
			%><input type=hidden name="<%=itens%>" value="<%=request(itens)%>"><%
			if left(itens,1) = inicio	 then
				if request(itens) <> "" then					
					select case right(itens,1)
						case "d"
							sql = sql & mid(itens,2,len(itens)-3)&""				
							sql = sql & "=" & rdata(request(itens)) & " and "
						case "c"
							sql = sql & mid(itens,2,len(itens)-3)&""				
							sql = sql & " like '%"&replace(request(itens),"'","´")&"%' and "
						case "n"
							if int(request(itens)) <> 0 then
								sql = sql & mid(itens,2,len(itens)-3)&""				
								sql = sql & "=" & replace(request(itens),"'","´")&" and "
							'else
							'	sql = sql & "0, "
							end if
					end select				
				end if
			end if
		next		
		
		'especiais (data)
		sql2 = " and ("
		vcontr = ""
		for each itens in request.querystring
			select case left(itens,1)
				case "_"					
					if mid(itens,len(itens)-2,1) = "1" then
						sql2 = sql2 & "(" & mid(itens,2,len(itens)-4)&""				
						sql2 = sql2 & ">=" 						
						if rdata(request(itens)) <> "NULL" then
							sql2 = sql2 & rdata(request(itens)) & " and "					
						else
							vcontr = vcontr & "1"
							sql2 = sql2 & "'01/01/1980'" & " and "					
						end if
					else
						sql2 = sql2 & mid(itens,2,len(itens)-4)&""				
						sql2 = sql2 & "<=" 						
						if rdata(request(itens)) <> "NULL" then							
							sql2 = sql2 & rdata(request(itens)) & " )) and ("																			
						else							
							vcontr = vcontr & "2"							
							sql2 = sql2 & "'01/01/2050'))" & " and ("					
							if vcontr = "12" then
								sql2 = replace(mid(sql2,1,len(sql2)-5),"''","NULL")
								sql2 = sql2&" or ("&mid(itens,2,len(itens)-4)&" is null)) and (("																
							end if							
						end if	
						vcontr = ""																		
					end if				
					
			end select
		next
		if sql2 <> "" then
			sql2 = replace(replace(replace(mid(sql2,1,len(sql2)-6),"''","NULL"),"(((","(("),"'))  or","') or")
		end if
		
		'especiais (e/ou)
		sql3 = "("
		vcontr = ""
		tem_preenchido = "N"
		contador = 0
		cont_eou = 1
		for each itens in request.querystring
			select case left(itens,1)				
				case "|"					
					vcontr = vcontr & "1"
					'if not isnull(request(itens)) and not IsEmpty(request(itens)) and len(trim(request(itens))) > 0 then
					if request(itens) <> "" then
						tem_preenchido = "S"											
					end if
					'if mid(itens,len(itens)-2,1) = "1" then
					'if contador = 0 then
					'	sql3 = sql3 & " desc_res " & ""				
					'	sql3 = sql3 & " like "  						
					'	sql3 = sql3 & "'%" & replace(request(itens),"'","´") & "%' or "											
					'	
					'	sql3 = sql3 & "desc_det" &""				
					'	sql3 = sql3 & " like "  						
					'	sql3 = sql3 & "'%" & replace(request(itens),"'","´") & "%' or "											
					'	
					'	sql3 = sql3 & "obs" &""				
					'	sql3 = sql3 & " like "  						
					'	sql3 = sql3 & "'%" & replace(request(itens),"'","´") & "%' or) "
					'	
					'	sql3 = replace(mid(sql3,1,len(sql3)-4),"''","NULL") & ")"
					'	
					'	sql3 = sql3 & " " & request("eou_1") &" ( and "					
					'else
						if not isnull(request(itens)) and not IsEmpty(request(itens)) and len(trim(request(itens))) > 0 then
							sql3 = sql3 & " desc_res " & ""				
							sql3 = sql3 & " like "  						
							sql3 = sql3 & "'%" & replace(request(itens),"'","´") & "%' or "											
							
							sql3 = sql3 & "desc_det" &""				
							sql3 = sql3 & " like "  						
							sql3 = sql3 & "'%" & replace(request(itens),"'","´") & "%' or "											
							
							sql3 = sql3 & "obs" &""				
							sql3 = sql3 & " like "  						
							sql3 = sql3 & "'%" & replace(request(itens),"'","´") & "%' or) "
							
							sql3 = replace(mid(sql3,1,len(sql3)-4),"''","NULL") & ")"
							
							sql3 = sql3 & " " & request("eou_1") &" ( and "
						contador = contador + 1
						end if
					'end if
					
					'end if				
					cont_eou = cont_eou + 1
				end select
			
		next
		'Response.write sql3:Response.end
		if contador > 0 then
			if sql3 <> "" then
				sql3 = "(" & replace(replace(replace(mid(sql3,1,len(sql3)-10),"''","NULL") ,"and ( and","and ("),"or ( and","or (") & ") "
			end if
		else
			sql3 = ""
		end if
		'Response.write sql3:Response.end
		if tem_preenchido = "N" then			
			sql3 = "(" & sql3 & " or (desc_res is null or desc_det is null or obs is null))" & ""				
		end if
		
		
		sql = replace(mid(sql,1,len(sql)-5) & sql2 & " and " & sql3 & sql4,"''","Null") & condicao
		
		
		'response.write sql
		'response.end
		
end function

function rdata(data)
	if (data = "") or (data = "//") or (isnull(data)) then
		rdata = "NULL"
	else
		rdata = "'"&month(data)&"/"&day(data)&"/"&year(data)&"'"
	end if
end function

function grava_log_c(usu,acao,onde,desc)
	desc = replace(desc,"'","")
	conn.execute("INSERT INTO Log(usuario,acao,onde,descricao,modulo) VALUES('"&usu&"','"&acao&"','"&onde&"','"&desc&"','C')")
	grava_log_c = true
end function

'Verifica se a contagem de pasta está parametrizada por módulo
Function PastaPorModC(usuario)
	set rsPar = conn.execute("select seq_cadastro_pasta from Parametros where usuario = '"&usuario&"'")
	PastaPorModC = 0
	if not rsPar.eof then
		if (rsPar("seq_cadastro_pasta")) then
			PastaPorModC = 1
		end if
	end if
	rsPar.close
End Function

'Função para retornar a última sequencia da pasta ou a sigla do módulo
'Se o módulo é vazio, retorna o valor máximo de todos os módulos
'Parametros de retorno (S = retorna a SIGLA / C = retorna o CONTADOR)
Function Seq_PastaC(id_usuario, modulo, retorno)
	if modulo = "" then
		sqlP = "select max(contador) as contador, sigla = '' from numeracao_pasta where id_usuario = '"&id_usuario&"'"
	else
		sqlP = "select id, id_usuario, modulo, sigla, contador, data from numeracao_pasta where id_usuario = '"&id_usuario&"' and modulo = '"&modulo&"'"
	end if
	
	set rsP = conn.execute(sqlP)
	if not rsP.eof then
		if retorno = "S" then 
			Seq_PastaC = rsP("sigla")
		else
			Seq_PastaC = rsP("contador")
		end if
	else 
		Seq_PastaC = ""
	end if
	rsP.close
End Function

Sub Grava_Ult_ContadorC(id_usuario, modulo, ult_cont)
	set rsPar = conn.execute("select sigla, contador from numeracao_pasta where id_usuario = '"&session("codigo_vinculado")&"' ")
	if rsPar.eof then
		conn.execute("INSERT INTO numeracao_pasta(id_usuario, modulo, sigla, contador, data) " &_
			 "VALUES('"&session("codigo_vinculado")&"', 'M', '', 1, GETDATE())")
			 
		conn.execute("INSERT INTO numeracao_pasta(id_usuario, modulo, sigla, contador, data) " &_
			 "VALUES('"&session("codigo_vinculado")&"', 'MI', '', 1, GETDATE())")
		
		conn.execute("INSERT INTO numeracao_pasta(id_usuario, modulo, sigla, contador, data) " &_
			 "VALUES('"&session("codigo_vinculado")&"', 'D', '', 1, GETDATE())")
		
		conn.execute("INSERT INTO numeracao_pasta(id_usuario, modulo, sigla, contador, data) " &_
			 "VALUES('"&session("codigo_vinculado")&"', 'P', '', 1, GETDATE())")
		
		conn.execute("INSERT INTO numeracao_pasta(id_usuario, modulo, sigla, contador, data) " &_
			 "VALUES('"&session("codigo_vinculado")&"', 'PI', '', 1, GETDATE())")
		
		conn.execute("INSERT INTO numeracao_pasta(id_usuario, modulo, sigla, contador, data) " &_
			 "VALUES('"&session("codigo_vinculado")&"', 'V', '', 1, GETDATE())")
		
		conn.execute("INSERT INTO numeracao_pasta(id_usuario, modulo, sigla, contador, data) " &_
			 "VALUES('"&session("codigo_vinculado")&"', 'C', '', 1, GETDATE())")
		
		conn.execute("INSERT INTO numeracao_pasta(id_usuario, modulo, sigla, contador, data) " &_
			 "VALUES('"&session("codigo_vinculado")&"', 'E', '', 1, GETDATE())")
	end if
	
	if (cint(Seq_PastaC(session("codigo_vinculado"), modulo, "C")) + 1 = ult_cont) then
		conn.execute("UPDATE numeracao_pasta SET contador = '"&ult_cont&"' " &_
			 	"WHERE id_usuario = '"&session("codigo_vinculado")&"' and modulo = '"&modulo&"' ")	
	end if						
	rsPar.close
End Sub

Function TemPastaRepetidaC(usuario, modulo, pasta)
	TemPastaRepetidaC = false
	select case modulo
		case "C"
			sqlR = "select pasta from contencioso.dbo.TabProcCont where usuario = '"&usuario&"' and pasta = '"&pasta&"'"
	end select
		
	set rsPar = conn.execute("select repete_pasta from Parametros where usuario = '"&usuario&"' ")
	if not rsPar.eof then
		if rsPar("repete_pasta") = true then 
			set rsR = conn.execute(sqlR)
			if not rsR.eof then
				TemPastaRepetidaC = true
			end if
		end if
	end if
	rsPar.close
End Function


function ObterDescricaoOrgaoGerencial(prmCodigo)

	Dim strDescricaoOrgao : strDescricaoOrgao = ""

	if len(trim(prmCodigo)) > 0 then

		strDescricaoOrgao = cstr(prmCodigo)

		strSQL = "SELECT descricao FROM Contencioso.dbo.auxiliares WHERE usuario = '"&session("vinculado") & "' AND codigo = " & prmCodigo

		SET rsDescricaoOrgao = db.execute(strSQL)

		if not rsDescricaoOrgao.EOF then

			strDescricaoOrgao = rsDescricaoOrgao("descricao")

		end if

		SET rsDescricaoOrgao = Nothing

	end if

	ObterDescricaoOrgaoGerencial = strDescricaoOrgao

end function

'TODO: Substituir função por "ObterDescricaoOrgaoOficialProSigla(prmSigla)"'
function ObterDescricaoOrgaoOficial(prmSigla)

	dim strDescricaoOrgao : strDescricaoOrgao = ""

	if len(trim(prmSigla)) > 0 then

		strDescricaoOrgao = cstr(prmSigla)

		strSQL = "SELECT nome AS descricao FROM isis.dbo.orgao WHERE sigla = '" & prmSigla & "'"

		SET rsDescricaoOrgao = db.execute(strSQL)

		if not rsDescricaoOrgao.EOF then

			strDescricaoOrgao = rsDescricaoOrgao("descricao")

		end if

		SET rsDescricaoOrgao = Nothing

	end if

	ObterDescricaoOrgaoOficial = strDescricaoOrgao

end function

function url_base()
	str_url = lcase(left(Request.ServerVariables("SERVER_PROTOCOL"),instr(Request.ServerVariables("SERVER_PROTOCOL"),"/")-1))
	If Request.ServerVariables("SERVER_PORT") = "443" then
		str_url = str_url & "s"
	end if
	str_url = str_url & "://" & Request.ServerVariables("SERVER_NAME")
	If Request.ServerVariables("SERVER_PORT") <> "80" and Request.ServerVariables("SERVER_PORT") <> "443" then
		str_url = str_url & ":" & Request.ServerVariables("SERVER_PORT")
	End If
	
	'SATURNO
	if ( Request.ServerVariables("SERVER_NAME") = "interno.ldsoft.com.br" or Request.ServerVariables("SERVER_NAME") = "187.115.4.34" ) and Request.ServerVariables("SERVER_PORT") = "8087" then
		str_url = "http://saturno:8087"
	'MARTE
	elseif Request.ServerVariables("SERVER_NAME") = "interno.ldsoft.com.br" then
		str_url = "http://marte:" & Request.ServerVariables("SERVER_PORT")
	end if
	url_base = str_url
end function
%>