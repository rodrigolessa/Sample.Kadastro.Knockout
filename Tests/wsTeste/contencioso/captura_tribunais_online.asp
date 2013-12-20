<html>
<script src="js/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="js/jquery-ui.min.js" type="text/javascript"></script>
<% 
'-- =========================================================================
'-- Author: Marcos Muller   -  OS : 4159'-- Create date: 12-10-2012 á 22-10-2012 
'-- Description: função para caturar andamentos da conexão com tribunais
'-- =========================================================================

'-----------------------------------------------------------------------------'
'Emails de Teste para envio durante o ping manual:'
'- Ao atingir limite de consultas de testes permitidas'
'- AO atiginir o limite de consultas mensais, definido no Parâmetro de Conexão'

'Produção'
DeEmail = "suporte@ldsoft.com.br"
ParaEmail = "comercial@ldsoft.com.br"

'Para teste'
'DeEmail = "bmourao@ldsoft.com.br" 	'Remetente
'ParaEmail = "bmourao@ldsoft.com.br"	'Destinatário'

' Caminho do Webservice
WebServiceIsis = url_base() & "/utilitarios/ServicoIsis/ServicoIsis.asmx"

Dim intErroIsis

If Request.Querystring("processo1") = "" then %>
	<script>
		alert("Processo não encontrado!");
		location = "proc_ocorrencia.asp?id_processo=<%=request("id_processo")%>&processo=<%=Request.Querystring("processo1")%>&tipo_ocorr=T";
	</script>
<% End if %>
<!--#include file='../usuario_logado.asp'-->
<!--#include file="db_open.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/dbconn.asp"-->
<!--#include file="../include/dbconn.asp"-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<%
	session("EmailLim") = 0
	dim txt, strMsg, strRet, idTribunal, strProc, sqlx, strRetProc, sql, intAtualSemErro
	
	strProc = request.querystring("processo1")
	idTribunal = request.Querystring("id_tribunal")
	
	if trim(idTribunal) <> "" then
		sqlrs = ""
		sqlrs = "select id, sigla from Orgao where sigla = '"&idTribunal& "'"
		Set rs_trib = dbconn.execute(sqlrs)
		If not rs_trib.eof then
			idTribunal = rs_trib("sigla")
			codTrib = rs_trib("id")
		End If
	End if

	'Retorna tipo da consulta'
	set rsTC = conn.execute("select tipo_consulta_processo from Contencioso.dbo.TabProcCont where usuario = '" & session("vinculado")& "' and processo = '"&strProc&"'")

	strTipoCons = ""
	if not rsTC.eof then
		if trim(rsTC("tipo_consulta_processo")) <> "" and (not isnull(rsTC("tipo_consulta_processo"))) then
			strTipoCons = trim(rsTC("tipo_consulta_processo")) + "."
		end if
	end if
	ContaPings()
	
	'=========================================================================
		Sub ContaPings() ' conta a quantidade de pings que estão sendo feitos
			'-- Author: Marcos Muller   -  OS : 4159	
			'-- Create date: 26-03-2013
			'-- Description: calculo pings das conexões tribunais
	'=========================================================================
		'Verifica Parâmetros - Limite mensal'
		sqlr = "SELECT fl_Habilita_Conexao_coml, fl_Habilita_Conexao_Processo,id_periodicidade,ds_EnviaEmail,nr_consultas_permitidas,fl_Avisa_Resp_Conexao_limite,fl_des_Conexao_status_proc" &_
				",dataativacao,nrolimiteconsultas_coml,nroconsultas_teste_feitas FROM tbConexaoTribunais_Parametros WHERE usuario = '"&Session("vinculado")&"'"
		set rstx = db.execute(sqlr)
	
		if not rstx.eof then
			session("EnviaEmail") 		= rstx("ds_EnviaEmail")
			AvisaLimite    		= rstx("fl_Avisa_Resp_Conexao_limite")
			nrolimiteconsultas	= rstx("nr_consultas_permitidas")

			if nrolimiteconsultas > 0 and AvisaLimite <> 0 then

				'Verifica período de Contrato'
				isomaping = 0		
				sql = "SELECT tb_contrato.usuario, tb_contrato.dt_contrato_ini, LTRIM(RTRIM(Clientes.dbo.cliente.razao)) AS Razao, usuarios_apol.dbo.usuario.dependentes_apol "&_
						"FROM tb_contrato "&_
						"JOIN usuarios_apol.dbo.usuario ON tb_contrato.usuario = usuarios_apol.dbo.usuario.nomeusu "&_
						"LEFT JOIN Clientes.dbo.cliente ON cod_cli_scli = LTrim(RTrim(Clientes.dbo.cliente.cod_cli)) "&_
						"WHERE (usuarios_apol.dbo.usuario.status_apol = 'L') AND (usuarios_apol.dbo.usuario.excluido = 0) "&_
						"AND  usuarios_apol.dbo.usuario.nomeusu = '"&session("vinculado")&"'"
			
				Set rstrib = CreateObject("ADODB.Recordset")
				rstrib.Open Sql, conn
			
				if NOT rstrib.eof then
					data = date()
					
					dia_fim = day(rstrib("dt_contrato_ini"))
			
					if day(data) > (dia_fim+10) then
						mes_fim = month(data)+1
					else
						mes_fim = month(data)
					end if
					
					if mes_fim = 13 then
						mes_fim = 1
						ano_fim = year(data)+1
					else
						ano_fim = year(data)
					end if
					
					while not isdate(ano_fim&"-"&mes_fim&"-"&dia_fim)
						dia_fim = dia_fim-1
					wend
					
					contrato_fim = cdate(ano_fim&"-"&mes_fim&"-"&dia_fim)
					
					contrato_ini_calculo = contrato_fim
					contrato_fim = dateadd("m",+1,dateadd("d",-1,contrato_fim))
						
					'Calcula quantidade de consultas mensais'
					sqlX = "SELECT count(processo) + 1 as soma FROM tbConexaoTribunais_Andamentos WHERE fl_erro = 0 and fl_faturado  = 0 and  (fl_consulta_paga = 1 or fl_consulta_paga is null) AND (data BETWEEN '" &year(contrato_ini_calculo)&"-"&month(contrato_ini_calculo)&"-"&day(contrato_ini_calculo)& " 00:00:00' AND '" &year(contrato_fim)&"-"&month(contrato_fim)&"-"&day(contrato_fim)& " 23:59:59') AND (usuario = '" &session("vinculado")& "')" 
					Set rsTrib = CreateObject("ADODB.Recordset")
					rsTrib.Open sqlX, db
					
					if not rsTrib.eof then 
						isomaping = rsTrib("soma")
					end if
					
					if isomaping > 0 then	
						if nrolimiteconsultas = isomaping then
							session("EmailLim") = isomaping
						end if
					end if
					
				end if
			end if
							
			if rstx("nrolimiteconsultas_coml") > 0 and rstx("nroconsultas_teste_feitas") > 0 then
				if rstx("nrolimiteconsultas_coml") <= rstx("nroconsultas_teste_feitas") then%>
					<script>
						alert("Seu Limite de consultas permitidas para Teste terminou!");
						top.para_anima_sync();
						location = "proc_andamento.asp?id_processo=<%=request("id_processo")%>&processo=<%=Request.Querystring("processo1")%>&tipo_ocorr=T&mostrartudo=0";
					</script>
					<%
					strSQL1 = "UPDATE tbConexaoTribunais_Parametros SET fl_Habilita_Conexao_Processo = 0 WHERE usuario = '"&session("vinculado")&"'"
					db.execute(strSQL1)
						
					sqlx2 = "SELECT processo, fl_aguarda_robo_baixar_andamento FROM tbConexaoTribunais_Andamentos WHERE processo = '"& strProc & "' AND (CONVERT(VARCHAR(8), data, 1) = CONVERT(VARCHAR(8), getdate(), 1)) " &_
							 " and usuario = '"&Session("vinculado")&"' and fl_aguarda_robo_baixar_andamento = 1 and id_tribunal = '"& idTribunal &"'"
					set rsanda = db.execute(sqlx2)
				
					if not rsanda.eof then	%>
					<script>
						alert("A sincronização deste processo já foi programada.");
						top.para_anima_sync();
						location = "proc_andamento.asp?id_processo=<%=request("id_processo")%>&processo=<%=Request.Querystring("processo1")%>&tipo_ocorr=T&mostrartudo=0";
					</script>
					<%end if
				else
					MontaConexao() 
				end if
			else
				MontaConexao() 
			end if	

		end if	
		
		set rsParamCon = db.execute("select nrolimiteconsultas_coml, nroconsultas_teste_feitas from tbConexaoTribunais_Parametros WHERE usuario = '"&session("vinculado")&"' and fl_Habilita_Conexao_coml = 'T' ")
		
		if not rsParamCon.eof then
			if rsParamCon("nrolimiteconsultas_coml") = rsParamCon("nroconsultas_teste_feitas") then
				strSQL1 = "UPDATE tbConexaoTribunais_Parametros SET fl_Habilita_Conexao_Processo = 0 WHERE usuario = '"&session("vinculado")&"'"
				db.execute(strSQL1)
			end if
		end if
	End Sub
	

    '------------------------------------------------------------------------
		Sub MontaConexao() ' monta toda as regras para conectar ao tribunal
    '------------------------------------------------------------------------

		sqlx2 = "SELECT processo, fl_aguarda_robo_baixar_andamento FROM tbConexaoTribunais_Andamentos WHERE processo = '"& strProc & "' " &_
					 " and usuario = '"&Session("vinculado")&"' and fl_aguarda_robo_baixar_andamento = 1 and id_tribunal = '"& idTribunal &"'"
		set rsandax = db.execute(sqlx2)
				
		if not rsandax.eof then	%>
			<script>
				alert("A sincronização deste processo já foi programada.");
				top.para_anima_sync();
				location = "proc_andamento.asp?id_processo=<%=request("id_processo")%>&processo=<%=Request.Querystring("processo1")%>&tipo_ocorr=T&mostrartudo=0";
			</script>
		<%else
			
			sql = ""
			sql = "SELECT ID, CHAVE, MSG_ERRO ,DAT_ATUALIZACAO, DAT_ERRO,PROCESSO_FK FROM VISAO WHERE (CONVERT(VARCHAR(8), DAT_ERRO, 1) = CONVERT(VARCHAR(8), getdate(), 1) or CONVERT(VARCHAR(8), DAT_ALTERACAO, 1) = CONVERT(VARCHAR(8), getdate(), 1) or CONVERT(VARCHAR(8), DAT_ATUALIZACAO, 1) = CONVERT(VARCHAR(8), getdate(), 1)) and (CHAVE = '" & strTipoCons & tplic(0,strProc) & "')"
			Set rs_chk = dbconn.execute(sql)
		
			If not rs_chk.eof then	

				Colocaprocessosrobo()
				if intErroIsis = 0 then
					sqla = ""
					sqla = sqla & "SELECT processo, fl_aguarda_robo_baixar_andamento  FROM tbConexaoTribunais_Andamentos WHERE processo= '" & strProc  & "' and usuario = '"&Session("vinculado")&"' and fl_aguarda_robo_baixar_andamento = 1" 
					set rsandam = db.execute(sqla)
		
					if rsandam.eof then
					    sqla2 = ""
					    sqla2 = "insert into tbConexaoTribunais_Andamentos (usuario, data, processo, TEXTO, id_tribunal, fl_erro, qtd_andamentos_baixados, fl_faturado,  fl_consulta_paga,fl_aguarda_robo_baixar_andamento,fl_ping_feitopor_botao_online) values ('"&Session("vinculado")&"', getdate(),'"&strProc& "','Processo agendado para sincronização','" & idTribunal & "',0,0,0,null,1,1)"
					    	'response.write (sqla2)
							'response.end
					    db.execute(sqla2)
					end if
					rsandam.close
					set rsandam = Nothing
					MontaLista
					'Gera log no ping manual do Processo'
       				ok = grava_log_c(session("nomeusu"), "SINCRONIZAÇÃO", "PROCESSO", "Nº: " & strProc & " - Sincronização Manual. " )
				end if
			Else	
				
				Colocaprocessosrobo()
				if intErroIsis = 0 then
					sqla = ""
					sqla = sqla & "SELECT id, processo, fl_aguarda_robo_baixar_andamento  FROM tbConexaoTribunais_Andamentos WHERE processo = '"& strProc & "' AND (CONVERT(VARCHAR(8), data, 1) = CONVERT(VARCHAR(8), getdate(), 1)) "
					sqla = sqla & " and usuario = '"&Session("vinculado")&"'  and fl_aguarda_robo_baixar_andamento = 1" 
					set rsandam = db.execute(sqla)
			
					if rsandam.eof then
					    sqla2 = "insert into tbConexaoTribunais_Andamentos (usuario, data, processo, TEXTO, id_tribunal, fl_erro, qtd_andamentos_baixados, fl_faturado,  fl_consulta_paga,fl_aguarda_robo_baixar_andamento, fl_ping_feitopor_botao_online) values ('"&Session("vinculado")&"', getdate(),'"&strProc& "','Processo agendado para sincronização','" & idTribunal & "',0,0,0,null,1,1)"
					   	db.execute(sqla2)
					end if
					rsandam.close
					set rsandam = Nothing
					MontaLista
					'Gera log no ping manual do Processo'
	       				ok = grava_log_c(session("nomeusu"), "SINCRONIZAÇÃO", "PROCESSO", "Nº: " & strProc & " - Sincronização Manual. " )
				end if
			End if 

			Envia_Email_Limite_Teste(ParaEmail)

			rs_chk.close
			set rs_chk = Nothing
		end if
	end sub
	
	
      '------------------------------------------------------------------------
		Sub Colocaprocessosrobo() ' Instancia objeto webservice
       '------------------------------------------------------------------------   
   			intErroIsis = 0
			%>
		    <script type="text/javascript">
			
			var siglatribunais = '<%= idTribunal %>';
			var tipoconsulta = '<%= strTipoCons %>';
			var processo = '<%= strProc %>';
			var usuario = '<%= Session("vinculado") %>';
			var webservice = '<%= WebServiceIsis %>';
			var errojs = '<%= erro %>';
			
			jQuery.ajax({
	            type: "POST",
	            url: webservice + "/colocaProcessoRobo",
	            data: "{'vStr_SiglaTribunal':'"+siglatribunais+"', 'vStr_TipoConsulta':'"+tipoconsulta+"', 'vStr_Processo':'"+processo+"', 'vStr_Usuario':'"+usuario+"'}",
	            contentType: "application/json; charset=utf-8",
	            dataType: "json",
	            async: false,
	            success: function(jsonResult) {
					if (jsonResult.d != ''){
						alert(jsonResult.d);
						location = "proc_andamento.asp?id_processo=<%=request("id_processo")%>&processo=<%=Request.Querystring("processo1")%>&tipo_ocorr=T";
					}
	            },
	            error: function (msg) {
	                alert("Erro de comunicação com o Servidor!");
					location = "proc_andamento.asp?id_processo=<%=request("id_processo")%>&processo=<%=Request.Querystring("processo1")%>&tipo_ocorr=T";
	            }
	        });
			
			top.para_anima_sync();
			</script>
			<%
			
			sqlIsis = "select 1 from Isis..VINCULO where chave = '"& idTribunal & "_" & strTipoCons & strProc &"' "
			set rsIsis = conn.execute(sqlIsis)

			' Não tem registro
			if rsIsis.eof then
				intErroIsis = 1
				'response.end
			end if
			
			if intErroIsis = 0 then
			    sqlr = "SELECT dataativacao,nrolimiteconsultas_coml,nroconsultas_teste_feitas FROM tbConexaoTribunais_Parametros join usuarios_apol.dbo.usuario usuario on usuario.nomeusu = tbConexaoTribunais_Parametros.usuario WHERE fl_Habilita_Conexao_coml <> 'B' and usuario = '"&Session("vinculado")&"' "
				set rstx = db.execute(sqlr)
				
				NumeroCons = 0
				if not rstx.eof then
					if CInt(rstx("nrolimiteconsultas_coml")) > 0 then
						if ((not isnull(rstx("nroconsultas_teste_feitas"))) and rstx("nroconsultas_teste_feitas") <> "") then
							if CInt(rstx("nrolimiteconsultas_coml")) > CInt(rstx("nroconsultas_teste_feitas")) then
								NumeroCons = CInt(rstx("nroconsultas_teste_feitas")) + 1
							end if
						end if
	
						strSQL = "UPDATE tbConexaoTribunais_Parametros SET nroconsultas_teste_feitas  = " & NumeroCons 
						strSQL = strSQL	& " WHERE usuario = '"&session("vinculado")&"'"
						db.execute(strSQL)
					end if
				end if
			end if
			
			'Set soapClient = Nothing
		End Sub


       '------------------------------------------------------------------------
		Sub MontaLista
       '------------------------------------------------------------------------

       		if session("EmailLim") > 0 then
       			'Envia o email'
				call Envia_Email_Limite_Mensal(session("EnviaEmail") , session("EmailLim"))
				'Grava no log'
				ok = grava_log_c(session("nomeusu"), "E-MAIL", "CONEXÂO TRIBUNAIS", "E-mail com número de consultas mensais  enviado para: " & session("EnviaEmail") )
       		end if
			response.write "<script>" & vbcrlf
			response.write "jQuery = window.top.jQuery;" & vbcrlf
			response.write "alert('Sincronização programada com sucesso. Em até 10 minutos você poderá ver os novos andamentos desse processo!');" & vbcrlf
			response.write "top.para_anima_sync();" & vbcrlf
			response.write "window.location.href = 'proc_andamento.asp?id_processo=" & request("id_processo")& "&processo=" & Request.Querystring("processo1") & "&tipo_ocorr=T';" & vbcrlf
			response.write "window.parent.location.reload();" & vbcrlf
			response.write "</script>"
		End Sub
		
       '------------------------------------------------------------------------	
       		'Envia email para o comercial avisando que o limite de consultas de teste foi atingido'
			Sub Envia_Email_Limite_Teste(ParaEmail)
       '------------------------------------------------------------------------

       		'Dados do usuário que vão constar no email'
       		set rs = conn_usu.execute("select ddd, telefone, contato, empresa, email from usuario where nomeusu = '"&session("vinculado")&"'")
			if not rs.eof then
				session("telefone")		=	"(" & rs("ddd") &") " & rs("telefone")
				session("contato")		=	rs("contato")	
				session("empresa")		=	rs("empresa")	
				session("email")		=	rs("email")
			end if

			'Parametros da Conexão aos Tribunais'
			sqlR = "SELECT nroconsultas_teste_feitas, nrolimiteconsultas_coml, U.status_apol " &_
					"FROM tbConexaoTribunais_Parametros TP " &_
					"JOIN usuarios_apol.dbo.usuario U " &_
					"ON U.nomeusu = TP.usuario " &_
					"WHERE TP.usuario = '"&session("vinculado")&"' AND U.status_apol <> 'B' "

			set rsR = db.execute(sqlR)

			limConsultasTeste = 0
			limConsultasTesteFeitas = 0
			statusUsuario = ""

			if not rsR.eof then
				limConsultasTeste = rsR("nrolimiteconsultas_coml")
				limConsultasTesteFeitas = rsR("nroconsultas_teste_feitas")

				select case rsr("status_apol")
					case "T"
						statusUsuario = "TESTE"
					case "B"
						statusUsuario = "BLOQUEADO"
					case "L"
						statusUsuario = "LIBERADO"
				end select

				if limConsultasTeste = limConsultasTesteFeitas and limConsultasTesteFeitas <> 0 and limConsultasTeste <> 0 then
					'Monta o corpo do e-mail'
					EmailBody = ""
					EmailBody = EmailBody & "<table style=""font: 12 Verdana;"">"
					EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>"
					EmailBody = EmailBody & "<tr><td colspan=""2"">Depto. Comercial,</td></tr>"
					EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>"
					EmailBody = EmailBody & "<tr><td colspan=""2"">O cliente abaixo consumiu a quantidade máxima de consultas de testes.</td></tr>"
					EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>"
					EmailBody = EmailBody & "<tr><td colspan=""2"">Cliente com status " & statusUsuario & "</td></tr>"
					EmailBody = EmailBody & "<tr><td width='10%'><b>Usuário:</b></td><td><b>"&session("vinculado")&"</b></td></tr>"
					EmailBody = EmailBody & "<tr><td width='10%'><b>Empresa:</b></td><td><b>"&session("empresa")&"</b></td></tr>"
					EmailBody = EmailBody & "<tr><td width='10%'><b>E-mail:</b></td><td><b>"&session("email")&"</b></td></tr>"
					EmailBody = EmailBody & "<tr><td width='10%'><b>Contato:</b></td><td><b>"&session("contato")&"</b></td></tr>"
					EmailBody = EmailBody & "<tr><td width='10%'><b>Telefone:</b></td><td><b>"&session("telefone")&"</b></td></tr>"
					EmailBody = EmailBody & "<tr><td width='10%'><b>Data:</b></td><td><b>"&session("data")&"</b></td></tr>"
					EmailBody = EmailBody & "</table>"
					EmailBody = EmailBody & "<table style=""font: 12 Verdana;"">"
					EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>"
					EmailBody = EmailBody & "<tr><td width='50%'><b>Quantidade Máxima de Consultas de Testes........:</b></td><td><b>"&limConsultasTeste&"</b></td></tr>"
					EmailBody = EmailBody & "<tr><td width='50%'><b>Quantidade de Consultas de Testes Executadas..:</b></td><td><b>"&limConsultasTesteFeitas&"</b></td></tr>"
					EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>"
					EmailBody = EmailBody & "</table>"
					EmailBody = EmailBody & "<table style=""font: 12 Verdana;"" cellpadding=""0"" cellspacing=""0"">"
					EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>"
					EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>"
					EmailBody = EmailBody & "<tr><td colspan=""2"">Atenciosamente,</td></tr>"
					EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>"
					EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>"
					EmailBody = EmailBody & "<tr><td colspan=""2"">Depto. Suporte</td></tr>"
					EmailBody = EmailBody & "<tr><td colspan=""2"" style=""color:#2F519A""><strong>LD</strong>SOFT</td></tr>"
					EmailBody = EmailBody & "<tr><td colspan=""2"">Informática especializada em Propriedade Intelectual e Advocacia</td></tr>"
					EmailBody = EmailBody & "<tr><td colspan=""2"">Empresa associada à ASSESPRO e SEPRORJ</td></tr>"
					EmailBody = EmailBody & "<tr><td colspan=""2""><a href=""http://www.LDsoft.com.br"" target=""_blank"" style=""color: #333333;text-decoration:none;"">www.<strong>LD</strong>soft.com.br</a></td></tr>"
					EmailBody = EmailBody & "<tr><td colspan=""2"">21 2613-3656</td></tr>"
					EmailBody = EmailBody & "</table>"

					Const ForReading1 = 1, ForWriting1 = 2
				    Dim fso1, f1
				    Set fso1 = CreateObject("Scripting.FileSystemObject")
				    dir = Server.MapPath("\apol\automatico")
				    Set f1 = fso1.OpenTextFile(dir&"\email_proc.htm", ForReading1)
				    ReadAllTextFile =  f1.ReadAll
			
				    body_email1 = replace(ReadAllTextFile,"[email]",EmailBody)
			
				    'enviando para valer
				    call send_email(ParaEmail, DeEmail, "APOL - Quantidade Máxima de Consultas de Testes na Conexão aos Tribunais.", body_email1)
				end if
			end if		
		End Sub	

		'------------------------------------------------------------------------	
			'Envia e-mail quando o limite mensal de consultas for atingido (Limit é definido no Parâmetro de Conexão)'
			Sub Envia_Email_Limite_Mensal(ParaEmail, pings_mensais)
       '------------------------------------------------------------------------
			EmailBody = ""
		    EmailBody = EmailBody & "<table style=""font: 12 Verdana;"">"
		    EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>"
		    EmailBody = EmailBody & "<tr><td colspan=""2"">Prezado,</td></tr>"
		    EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>"
		    EmailBody = EmailBody & "<tr><td colspan=""2"">Informamos que até o momento foram realizadas<strong> " & pings_mensais & " consultas </strong> este mês na Conexão aos Tribunais.</td></tr>"
		    EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>"
	      	EmailBody = EmailBody & "</table>"
		    EmailBody = EmailBody & "<table style=""font: 12 Verdana;"" cellpadding=""0"" cellspacing=""0"">"
	    	EmailBody = EmailBody & "<tr><td colspan=""2""></td></tr>"
		    EmailBody = EmailBody & "<tr><td colspan=""2"">Atenciosamente,</td></tr>"
			EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>"
			EmailBody = EmailBody & "<tr><td colspan=""2""></td></tr>"
			EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>"
			EmailBody = EmailBody & "<tr><td colspan=""2"">Suporte</td></tr>"
			mailBody = EmailBody & "<tr><td colspan=""2"">Suporte@LDsoft.com.br</td></tr>"
			EmailBody = EmailBody & "<tr><td colspan=""2"" style=""color:#2F519A""><strong>LD</strong>SOFT</td></tr>"
			EmailBody = EmailBody & "<tr><td colspan=""2"">Informática especializada em Propriedade Intelectual e Advocacia</td></tr>"
			EmailBody = EmailBody & "<tr><td colspan=""2"">Empresa associada à ASSESPRO e SEPRORJ</td></tr>"
			EmailBody = EmailBody & "<tr><td colspan=""2""><a href=""http://www.LDsoft.com.br"" target=""_blank"" style=""color: #333333;text-decoration:none;"">www.<strong>LD</strong>soft.com.br</a></td></tr>"
			EmailBody = EmailBody & "<tr><td colspan=""2"">21 2613-3656</td></tr>"
		    EmailBody = EmailBody & "</table>"
	    	
		    Const ForReading1 = 1, ForWriting1 = 2
		    Dim fso1, f1
		    Set fso1 = CreateObject("Scripting.FileSystemObject")
		    dir = Server.MapPath("\apol\automatico")
		    Set f1 = fso1.OpenTextFile(dir&"\email_proc.htm", ForReading1)
		    ReadAllTextFile =  f1.ReadAll
	
		    body_email1 = replace(ReadAllTextFile,"[email]",EmailBody)
	
		    'enviando para valer
		    call send_email(ParaEmail, DeEmail, "APOL - Número de Consultas Mensais na Conexão aos Tribunais.",body_email1)
			
		End Sub	
		%>


		</html>