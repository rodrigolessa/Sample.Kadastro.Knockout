<html>
<body bgcolor="#efefef">

<% If Request.Querystring("processo1") = "" then %>
	<script>
		alert("Processo não encontrado!");
		location = "proc_ocorrencia.asp?id_processo=<%=request("id_processo")%>&processo=<%=Request.Querystring("processo1")%>&tipo_ocorr=T";
	</script>
<% Else %>
<!--#include file='../usuario_logado.asp'-->
<!--#include file="db_open.asp"-->
<!--#include file="../include/conn.asp"-->
<%
	dim txt

	if request("id_tribunal") = 1 then

		Sub pega_desp()
		    On Error Resume Next
		    Set xml = Server.CreateObject("Microsoft.XMLHTTP")
			data_to_send = "processo1="&processo
			xvLink = "http://trt.srv.trt02.gov.br/cie1"
			xml.Open "post", xvLink, False
			xml.Send(data_to_send)
			If Err.Number <> 0 Then
				%>
				<script>
					alert("Erro de comunicação com o Servidor!");
					top.para_anima_sync();
					location = "proc_ocorrencia.asp?id_processo=<%=request("id_processo")%>&processo=<%=Request.Querystring("processo1")%>&tipo_ocorr=T";
				</script>
				<%
				response.end
		    End If
			txt=xml.responseText
			set xml = Nothing
		End Sub
		
		processo = ""
		proc = request.querystring("processo1")
		for i = 1 to len(proc)
			if (Asc(mid(proc,i,1)) >= 48) and (Asc(mid(proc,i,1)) <= 57) then
				processo = processo & mid(proc,i,1)
			end if
		next

		pega_desp

		dir = server.mappath("captura/")&"\" &processo& ".txt"

		Set fso = CreateObject("Scripting.FileSystemObject")

		Set MyFile = fso.OpenTextFile(dir, 2, True)

		temp = replace(txt,chr(10),"#%@!!@%#")
		texto = split(temp,"#%@!!@%#")

		for i= 0 to ubound(texto)-1
		MyFile.WriteLine texto(i)
		next

		sql = "select data from chk_tribunal where usuario = '"&Session("vinculado")&"' and processo = '"&tplic(0,proc)& "'"
		set rs_chk = db.execute(sql)
		if not rs_chk.eof then
			db.execute("update chk_tribunal set data = getdate() where usuario = '"&Session("vinculado")&"' and processo = '"&tplic(0,proc)& "'")
		else
			db.execute("insert into chk_tribunal (usuario, data, processo) values ('"&Session("vinculado")&"', getdate(), '"&tplic(0,proc)& "')")
		end if
		sql = "select data from chk_tribunal where usuario = '"&Session("vinculado")&"' and processo = '"&tplic(0,proc)& "'"
		set rs_chk_dt = db.execute(sql)

		Set MyFile = fso.OpenTextFile(dir, 1)
		fim = false
		if MyFile.AtEndOfStream then
			%>
			<script>
				alert("Processo não encontrado!");
				top.para_anima_sync();
				top.escrevelyr('dt_atu_trib','<b>Última sincronização: <%= rs_chk_dt("data") %></b>');
				history.back();
			</script>
			<%
			response.end
		else
			if instr(temp,"Processo Inexistente!") > 0 then
				%>
				<script>
					alert("Processo não encontrado!");
					top.para_anima_sync();
					top.escrevelyr('dt_atu_trib','<b>Última sincronização: <%= rs_chk_dt("data") %></b>');
					history.back();
				</script>
				<%
				response.end
			else
				if instr(temp,"Data(s)") = 0 then
					%>
					<script>
						alert("Erro de comunicação com o Servidor!");
						top.para_anima_sync();
						history.back();
					</script>
					<%
				else
					Dim datas(100)
					Dim despachos(100)
					cont = 0
					while (not fim) and (not MyFile.AtEndOfStream)
						linha = replace(MyFile.ReadLine,"<br>","")
						if left(linha,6) = "</pre>" then
							comeca = false
							fim = true
						end if
						if (mid(linha,3,1) = "/") and comeca then
							cont = cont + 1
							datas(cont) = left(linha,10)
							linha = trim(mid(linha,11,len(linha)))
						end if
						if comeca then
							despachos(cont) = despachos(cont) & trim(linha) & " "
						end if
						if left(linha,7) = "Data(s)" then
							comeca = true
						end if
					wend
					MyFile.close()
					fso.DeleteFile(dir)
					i = 1
					atu = 0
					prcesso = tplic(0, proc)
					response.write "<script>" & vbcrlf
					response.write "jQuery = window.top.jQuery;" & vbcrlf
					while datas(i) <> ""
						despacho_atual = tplic(0, despachos(i))
						data_atual = rdata(datas(i))
						sql = "SELECT id FROM ocorrencias WHERE (data = " & data_atual & ") and (ocorrencia = '" & despacho_atual & "') and (processo = '" & prcesso & "') AND (usuario = '"&Session("vinculado")&"')"
						set rs_chk = conn.execute(sql)
						if rs_chk.eof then
							conn.execute("insert into ocorrencias (usuario, processo, data, ocorrencia, tipo) values ('"&Session("vinculado")&"', '"& prcesso & "', " & data_atual & ", '" & despacho_atual & "', 'T')")
							ok = grava_log_c(session("nomeusu"),"INCLUSÃO","OCORRÊNCIA","Sincronização com tribunal - TRT SP - Processo: " & prcesso)
							atu = atu+1
							
							if len(despacho_atual) > 100 then
								sql = "SELECT TOP 1 [id] FROM ocorrencias WHERE tipo = 'T' AND usuario = '" & Session("vinculado") & "' "
								sql = sql & "AND data = " & data_atual & " AND processo = '" & prcesso & "' AND "
								sql = sql & "ocorrencia = '" & despacho_atual & "' ORDER BY [id] DESC"
								set rs = conn.execute(sql)
								if not rs.eof then
									id_ocorr = rs("id")
									nova_div = "<div class=""preto11"" id=""full_ocorrencia" & id_ocorr & """ style=""position:absolute; width:350px; height:50px; left:100px; display:none;"">"
									nova_div = nova_div & "<div style=""background:#ffffff; border:3px solid #345C46;"">"
									nova_div = nova_div & "<div class=""tit1"" style=""background:#345C46;"">"
									nova_div = nova_div & "<div style=""position: absolute;""><strong>Detalhe</strong></div><div style=""text-align:right;""><a href=""javascript:esconde_ocorrencia(\'" & id_ocorr & "\')""><img title=""Fechar"" border=""0"" src=""../img_comp/fechar.gif""></a></div>"
									nova_div = nova_div & "</div>"
									nova_div = nova_div & "<div style=""text-align: justify; padding-left:10px; padding-right:10px;"">" & despacho_atual & "</div>"
									nova_div = nova_div & "</div>"
									nova_div = nova_div & "</div>"
									response.write "jQuery('" & nova_div & "').appendTo(jQuery('#novos_objetos_tribunal'));" & vbcrlf
								end if
							end if
						end if
						i=i+1
					wend
					If atu = 0 then
						msg_atu = "Não houve atualização."
					ElseIf atu = 1 then
						msg_atu = "Foi feita " & atu & " atualização."
					Else
						msg_atu = "Foram feitas " & atu & " atualizações."
					End If
					response.write "alert('Sincronização efetuada com Sucesso!\n" & msg_atu & "');" & vbcrlf
					response.write "top.para_anima_sync();" & vbcrlf
					response.write "top.escrevelyr('dt_atu_trib','<b>Última sincronização: " & rs_chk_dt("data") & "</b>');" & vbcrlf
					response.write "window.location.href = 'proc_ocorrencia.asp?id_processo=" & request("id_processo")& "&processo=" & Request.Querystring("processo1") & "&tipo_ocorr=T';" & vbcrlf
					response.write "</script>"
				end if
			end if
		end if
	elseif request("id_tribunal") = 2 then%>
		<!--#include file='trtrio.asp' -->
	<%end if%>

<% End If %>
</body>
</html>
