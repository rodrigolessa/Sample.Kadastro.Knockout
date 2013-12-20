<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<script>
	function abrirjanela(url, width,  height){
		varwin=window.open(url,"openscript5",'width='+width+',height='+height+',resizable=0,scrollbars=yes,status=yes');
	}
	
</script>

<%

sqlp = "select id_processo, processo, dt_cad, dt_citacao, distribuicao, dt_encerra, situacao from tabproccont where processo = '"&tplic(0,request("fprocesso_c"))&"'  and usuario = '"&session("vinculado")&"'"
	set rstp = db.execute(sqlp)
	if not rstp.eof then
		vid_processo = rstp("id_processo")
		vprocesso = rstp("processo")
	end if	
	
dim sql
if request("tipo") = "del" then
	sql = "select * from TabProcCont where id_processo = "&tplic(1,request("proc"))
	set rst = db.execute(sql)	
	if not rst.eof then
		vnrproc = rst("processo")
	end if
	sql = "delete from TabProcCont where id_processo = "&tplic(1,request("proc"))
	db.execute(sql)	
	
	ok = grava_log_c(session("nomeusu"),"EXCLUSÃO","PROCESSO","Processo: "&vnrproc )

	if request("cad") = "S" then
		response.redirect "processo.asp"
	else
		response.redirect "processo_list.asp?modulo=C"
	end if
else	
	
	if request("tipo_vinc") = "" then
		if request("codigo") = "" then
			'Insere Processo
			xsql = "select * from tabproccont where usuario = '"&session("vinculado")&"' and processo = '"&tplic(0,trim(request("fprocesso_c")))&"'"			
			set rstex = db.execute(xsql)
			if rstex.eof then
				
				if trim(request("fprocesso_c")) = "" then
					%>
					<script>
						alert("Preencha os campos corretamente.");
						history.go(-1);
					</script>
					<%
					response.end
				end if

				if trim(request("fdesc_res_c")) = "" then
					%>
					<script>
						alert("Preencha os campos corretamente.");
						history.go(-1);
					</script>
					<%
				response.end
				end if
				
				'Grava novo contador da numeração de pastas - INSERÇÃO DE PROCESSO
				sig = ""
				num = ""
				pasta = request("fpasta_c")
				mod_pasta = ""
				
				if pasta <> "" then
					if TemPastaRepetidaC(session("vinculado"),"C",pasta) = false then
						if request("valor_pasta") = "S" then
							if PastaPorModC(session("vinculado")) = 1 then
								mod_pasta = "C"
								if len(trim(pasta)) = 8 then
									pasta = mid(pasta,3, len(pasta))
									ult_cont = clng(pasta) 
								else
									if IsNumeric(pasta) then 
										ult_cont = clng(pasta)
									else
										ult_cont = pasta
									end if 
								end if
							else
								if IsNumeric(pasta) then 
									ult_cont = clng(pasta)
								else
									ult_cont = pasta
								end if
							end if
							Grava_Ult_ContadorC session("codigo_vinculado"), mod_pasta, ult_cont 
						end if
					end if
				end if
				
				call monta_insert("TabProcCont","f","S")
				ok = grava_log_c(session("nomeusu"),"INCLUSÃO","PROCESSO","Processo: "&request("fprocesso_c") )
			else
				%>
				<script>
					alert("Processo já cadastrado.");
					history.go(-1);
				</script>
				<%
				response.end
			end if
		else
			if trim(request("fprocesso_c")) = "" then
				%>
				<script>
					alert("Prevvvvvencha os campos corretamente.");
					history.go(-1);
				</script>
				<%
				response.end
			end if
			
			if trim(request("fdesc_res_c")) = "" then
				%>
				<script>
					alert("Preencha os campos corretamente.");
					history.go(-1);
				</script>
				<%
			response.end
			end if
			
			Session("processo_origem") = "sim"
			
			'Grava novo contador da numeração de pastas - ALTERAÇÃO
			sig = ""
			num = ""
			pasta = tplic(1,request("fpasta_c"))
			pasta_antiga = tplic(1,request("pasta_old"))
			mod_pasta = ""
			
			if pasta <> "" then
				if pasta <> pasta_antiga then
					if TemPastaRepetidaC(session("vinculado"),"C",pasta) = false then
						if request("valor_pasta") = "S" then
							if PastaPorModC(session("vinculado")) = 1 then
								mod_pasta = "C"
								if len(trim(pasta)) = 8 then
									pasta = mid(pasta,3, len(pasta))
									ult_cont = clng(pasta) 
								else
									if IsNumeric(pasta) then 
										ult_cont = clng(pasta)
									else
										ult_cont = pasta
									end if
								end if
							else
								if IsNumeric(pasta) then 
									ult_cont = clng(pasta)
								else
									ult_cont = pasta
								end if
							end if
							Grava_Ult_ContadorC session("codigo_vinculado"), mod_pasta, ult_cont 
						end if
					end if
				end if
			end if
			
			'Altera Processo
			call monta_update("TabProcCont","f"," Where id_processo = "&request("codigo"),"S")
			ok = grava_log_c(session("nomeusu"),"ALTERAÇÃO","PROCESSO","Processo: "&request("fprocesso_c") )
			
			'altera proviências
			if CBool(request("mesmo_resp")) = true then
				if request("alt_todos_resp") = "sim" then
					conn.execute("UPDATE Providencias SET advogado = " & tplic(0,request("fresponsavel_n")) & " WHERE (usuario = '"&session("vinculado")&"' or usuario = '"&session("vinculado")&"##"&session("nomeusu")&"') AND (processo = '" & tplic(0,request("fprocesso_c")) & "') AND (Tipo = 'C')")
				elseif request("alt_todos_resp") = "" or request("alt_todos_resp") = "nao" then
					conn.execute("UPDATE Providencias SET advogado = " & tplic(0,request("fresponsavel_n")) & " WHERE (ISNULL(advogado, '') = '') AND (usuario = '"&session("vinculado")&"' or usuario = '"&session("vinculado")&"##"&session("nomeusu")&"') AND (processo = '" & tplic(0,request("fprocesso_c")) & "') AND (Tipo = 'C')")
				end if
			end if
		end if	
	else	
		if request("tipo_vinc") = "val" then
			'Insere Valores
			if trim(request("fprocesso_c")) = "" then
				%>
				<script>
					alert("Preencha os campos corretamente.");
					history.go(-1);
				</script>
				<%
				response.end
			end if
			
			if trim(request("fdesc_res_c")) = "" then
				%>
				<script>
					alert("Preencha os campos corretamente.");
					history.go(-1);
				</script>
				<%
			response.end
			end if
			
			if request("codigo_val") = "" then		
				call monta_insert("TabValCont","v","S")
				ok = grava_log_c(session("nomeusu"),"INCLUSÃO","VINC.VALOR","Processo: "&request("fprocesso_c") )
			else
				Session("processo_origem") = "sim"
				call monta_update("TabValCont","v"," Where codigo = "&request("codigo_val"),"S")
				ok = grava_log_c(session("nomeusu"),"ALTERAÇÃO","VINC.VALOR","Processo: "&request("fprocesso_c") )
			end if
		end if	
	end if
	'response.write sql
	db.execute(sql)
		
	'Insere a providência a partir do item de checagem - Para proc. próprios e/ou de terceiros
	set rsItens = conn.execute("select * from apol.dbo.itens_checagem join usuarios_apol.dbo.usuario on usuarios_apol.dbo.usuario.codigo = apol.dbo.itens_checagem.codigo_usuario  where id_modulo = 3 and nomeusu = '"&session("vinculado")&"' " &_
	"and id_item not in (select distinct id_item_checagem from apol.dbo.Providencias where processo = '"&request("fprocesso_c")&"' and id_item_checagem is not null)")
	if not rsItens.eof then
		do while not rsItens.eof
			dataBase = ""
			select case ucase(rsItens("data_base"))
				case "CORRENTE"
					if request("id") = "" then
						dataBase = Now
					end if
				case "CADASTRO"
					if request("id") = "" then
						dataBase = now
					end if
				case "CITACAO"
					if fdata(rstp("dt_citacao")) <> request("fdt_citacao_d") then
						dataBase = request("fdt_citacao_d")
					end if
				case "ENCERRAMENTO" 
					if fdata(rstp("dt_encerra")) <> request("fdt_encerra_d") then 
						dataBase = request("fdt_encerra_d")
					end if
				case "DISTRIBUICAO"
					if fdata(rstp("distribuicao")) <> request("fdistribuicao_d") then 
						dataBase = request("fdistribuicao_d")
					end if
			end select

			resp = "NULL"
			if rsItens("id_responsavel") <> "" then
				resp = rsItens("id_responsavel")
			end if
			
			if database <> "" then
				if rsItens("operacao_data") = "1" then
					dtGerencial =  rdata(DateAdd("d", rsItens("prazo_gerencial"), dataBase))
					dtOficial   =  rdata(DateAdd("d", rsItens("prazo_oficial"), dataBase))	
					fdtGerencial = DateAdd("d", rsItens("prazo_gerencial"), dataBase)
					fdtOficial = DateAdd("d", rsItens("prazo_oficial"), dataBase)
				else
					dtGerencial =  rdata(DateAdd("d", ((-1) * rsItens("prazo_gerencial")), dataBase))
					dtOficial   =  rdata(DateAdd("d", ((-1) * rsItens("prazo_oficial")), dataBase))	
					fdtGerencial = DateAdd("d", ((-1) * rsItens("prazo_gerencial")), dataBase)
					fdtOficial = DateAdd("d", ((-1) * rsItens("prazo_oficial")), dataBase)
				end if

				if (date <= fdtOficial) then	
					conn.execute("INSERT INTO apol.dbo.Providencias(usuario, prazo_ger, prazo_ofi, processo, sigla_pais, descricao, tipo, advogado, id_item_checagem)  VALUES('"&Session("vinculado")&"',"& dtGerencial &","& dtOficial &", '"&request("fprocesso_c")&"', NULL, '"&rsItens("descricao_item")&"', 'C', " &resp& ","&rsItens("id_item")&")")
					ok = grava_log_c(session("nomeusu"),"INCLUSÃO","PROVIDÊNCIA","<b>Providência(s):</b> " & rsItens("descricao_item") & " . <b>Geradas a partir do item de checagem:</b> " & rsItens("descricao_item")  & ". <b>Módulo:</b> Jurídico Processo: " & request("fprocesso_c"))
				end if
			end if
			rsItens.movenext
		loop
	end if

	
	if request("id") <> "" then
		'Atualiza a providência a partir do item de checagem - Para proc. próprios e/ou de terceiros
		set rsItens = conn.execute("select * from apol.dbo.itens_checagem join usuarios_apol.dbo.usuario on usuarios_apol.dbo.usuario.codigo = apol.dbo.itens_checagem.codigo_usuario  where id_modulo = 3 and nomeusu = '"&session("vinculado")&"' " &_
		"and id_item in (select distinct id_item_checagem from apol.dbo.Providencias where processo = '"&request("fprocesso_c")&"' and id_item_checagem is not null)")
	
		if not rsItens.eof then
			do while not rsItens.eof
				dataBase = ""
				select case ucase(rsItens("data_base"))
					case "CITACAO"
						if fdata(rstp("dt_citacao")) <> request("fdt_citacao_d") then
							dataBase = request("fdt_citacao_d")
						end if
					case "ENCERRAMENTO" 
						if fdata(rstp("dt_encerra")) <> request("fdt_encerra_d") then 
							dataBase = request("fdt_encerra_d")
						end if
					case "DISTRIBUICAO"
						if fdata(rstp("distribuicao")) <> request("fdistribuicao_d") then 
							dataBase = request("fdistribuicao_d")
						end if
				end select
				
				resp = "NULL"
				if rsItens("id_responsavel") <> "" then
					resp = rsItens("id_responsavel")
				end if
			
				if database <> "" then
					if rsItens("operacao_data") = "1" then
						dtGerencial =  rdata(DateAdd("d", rsItens("prazo_gerencial"), dataBase))
						dtOficial   =  rdata(DateAdd("d", rsItens("prazo_oficial"), dataBase))	
						fdtGerencial = DateAdd("d", rsItens("prazo_gerencial"), dataBase)
						fdtOficial = DateAdd("d", rsItens("prazo_oficial"), dataBase)
					else
						dtGerencial =  rdata(DateAdd("d", ((-1) * rsItens("prazo_gerencial")), dataBase))
						dtOficial   =  rdata(DateAdd("d", ((-1) * rsItens("prazo_oficial")), dataBase))	
						fdtGerencial = DateAdd("d", ((-1) * rsItens("prazo_gerencial")), dataBase)
						fdtOficial = DateAdd("d", ((-1) * rsItens("prazo_oficial")), dataBase)
					end if
							
					if (date <= fdtOficial) then	
						conn.execute("update apol.dbo.Providencias set prazo_ger = "& dtGerencial &", prazo_ofi="& dtOficial & " where processo = '"&request("fprocesso_c")&"' and id_item_checagem = " & rsItens("id_item"))
						ok = grava_log_c(session("nomeusu"),"ALTERAÇÃO","PROVIDÊNCIA","<b>Providência(s):</b> " & rsItens("descricao_item") & " . <b>Geradas a partir do item de checagem:</b> " & rsItens("descricao_item")  & ". <b>Módulo:</b> Jurídico Processo: " & request("fprocesso_c"))
					end if
				end if
				rsItens.movenext
			loop
		end if
	end if
	
	vprocesso = replace(vprocesso, "&", "%26")
	vprocesso = replace(vprocesso, "#", "%23")
	if request("tipo_vinc") = "" and request("codigo") = "" then
		xsql = "select * from tabproccont where usuario = '"&session("vinculado")&"' and processo = '"&tplic(0,request("fprocesso_c"))&"'"
		set rst3 = db.execute(xsql)
		if not rst3.eof then
			response.redirect "processo_redirect.asp?x=3&processo="&vprocesso&"&id_processo="&rst3("id_processo")&"&janela="&request("janela")
		end if
	end if
	response.redirect "processo_redirect.asp?x=3&processo="&vprocesso&"&id_processo="&request("codigo")&"&janela="&request("janela")&"&pg=" & request("pg")
end if
%>