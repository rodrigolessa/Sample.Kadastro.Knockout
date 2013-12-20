<!--#include file="db_open.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/funcoes_ws.asp"-->
<!--#include file="../usuario_logado.asp"-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<%
if (not Session("cont_manut_contrib")) and (not Session("adm_adm_sys")) then
	bloqueia
	response.end
end if

	'Remetente e Destinatário dos E-mails - Termo de Aceite - Conexão aos Tribunais ============================================================
	'Para produção
	EmailFrom = "comercial@ldsoft.com.br" 						   'Remetente
	EmailTo =   "comercial@ldsoft.com.br, suporte@ldsoft.com.br"   'Destinatários
	
	'Para testes
	'EmailFrom = "susane@ldsoft.com.br" 						   'Remetente
	'EmailTo =   "brunapaes@ldsoft.com.br"   'Destinatários
	'===========================================================================================================================================
	
	HabilitaConexao = 0
	habilitadoComl = Request("habilitadoComl")
	if Request("aceite") <> 1 then
	
		if not isnull(Request("periodo")) and not trim(Request("periodo")) = "" then
			periodo = Request("periodo")
		else
			periodo = 0
		end if

		if not isnull(Request("periodi")) and not trim(Request("periodi")) = "" then
			period = Request("periodi")
		else
			period = 0
		end if


		if not isnull(Request("HabilitaCon")) and not trim(Request("HabilitaCon")) = "" then
			HabilitaCon = Request("HabilitaCon")
		else
			HabilitaCon = 0
		end if

		if not isnull(Request("desstatus")) and not trim(Request("desstatus")) = "" then
			desstatus     =  Request("desstatus")
		else
			desstatus     = 0
		end if
	
		if not isnull(Request("EnviaEmail")) and not trim(Request("EnviaEmail")) = "" then
			EnviaEmail = Request("EnviaEmail")
		else
			EnviaEmail = null
		end if
		
		if not isnull(Request("nrolimiteconsultas")) and not trim(Request("nrolimiteconsultas")) = "" then
			nrolimiteconsultas = Request("nrolimiteconsultas")
		else
			nrolimiteconsultas  = 0
		end if
		
		if not isnull(Request("AvisaLimite")) and not trim(Request("AvisaLimite")) = "" then
			AvisaLimite = Request("AvisaLimite")
		else
			AvisaLimite = 0
		end if

	
		strSQL = "UPDATE tbConexaoTribunais_Parametros "
			strSQL = strSQL	& "SET id_periodicidade = " & periodo
			strSQL = strSQL	& "	,ds_EnviaEmail = '" & EnviaEmail
			strSQL = strSQL	& "',nr_consultas_permitidas = " & nrolimiteconsultas 
			strSQL = strSQL	& "	,fl_Avisa_Resp_Conexao_limite = " & AvisaLimite 
			strSQL = strSQL	& "	,fl_des_Conexao_status_proc = " & desstatus 
			strSQL = strSQL	& " ,fl_Habilita_Conexao_Processo = " & HabilitaCon 
			strSQL = strSQL	& " WHERE usuario = '"&session("vinculado")&"'"
			db.execute(strSQL)

			sql = "SELECT fl_Habilita_Conexao_coml,fl_Habilita_Conexao_Processo,id_periodicidade,ds_EnviaEmail,nr_consultas_permitidas,fl_Avisa_Resp_Conexao_limite,fl_des_Conexao_status_proc" &_
					",dataativacao, nrolimiteconsultas_coml,nroconsultas_teste_feitas FROM tbConexaoTribunais_Parametros WHERE usuario = '"&session("vinculado")&"'"

			set rstx = db.execute(sql)
	
			if not rstx.eof then
				nrolimiteconsultas = rstx("nr_consultas_permitidas")
				nroconscom = rstx("nrolimiteconsultas_coml")
				itotal = rstx("nroconsultas_teste_feitas")
				habilitadoComl = rstx("fl_Habilita_Conexao_coml")
				
				desstatus = rstx("fl_des_Conexao_status_proc")
				EnviaEmail= rstx("ds_EnviaEmail")
				AvisaLimite= rstx("fl_Avisa_Resp_Conexao_limite")
				
				if rstx("fl_des_Conexao_status_proc") = 1 then
					ok = grava_log_c(session("nomeusu"), "ALTERAÇÃO", "PARÂMETROS TRIBUNAIS" , "Conexão Tribunais habilitada, Ativado para situação Inativo ou Encerrado")
				end if
						
				if rstx("fl_Avisa_Resp_Conexao_limite")= 1 then 
					ok = grava_log_c(session("nomeusu"), "ALTERAÇÃO", "PARÂMETROS TRIBUNAIS" , "Habilitado aviso ao atingir limite de " & nrolimiteconsultas & " consultas e envio para " & rstx("ds_EnviaEmail"))
				end if

				if rstx("id_periodicidade") <> periodo then
					if rstx("id_periodicidade") = 1 then periodo1 = "Diária"
					if rstx("id_periodicidade") = 2 then periodo1 = "Semanal"
					if rstx("id_periodicidade") = 3 then periodo1 = "Quinzenal"
					if rstx("id_periodicidade") = 4 then periodo1 = "Mensal"
					if period =1  then periodo2 = "Diária"
					if period =2  then periodo2 = "Semanal"
					if period =3  then periodo2 = "Quinzenal"
					if period =4  then periodo2 = "Mensal"															

					HabilitaConexao = rstx("fl_Habilita_Conexao_Processo")
					
					if trim(period) <> trim(rstx("id_periodicidade")) then
						'Atualiza a periodicidade para todos os processos que não tenham nenhuma
						db.execute("update Contencioso.dbo.TabProcCont " &_
									"set periodicidade = '"& trim(rstx("id_periodicidade")) &"' " &_
									"where usuario = '"&session("vinculado")&"' " &_
									"and (periodicidade is null or periodicidade = '')")
						ok = grava_log_c(session("nomeusu"), "ALTERAÇÃO", "PARÂMETROS TRIBUNAIS", "Periodicidade: " & periodo1 & " para " & periodo2)
					end if
				end if		
			end if
	else
		HabilitaCon = 1
		HabilitaConexao = 0
	end if

	if HabilitaCon <> HabilitaConexao then
		session("data") = now()
		set rs = conn_usu.execute("select ddd, telefone, contato, empresa, email from usuario where nomeusu = '"&session("vinculado")&"'")
		if not rs.eof then
			session("telefone")		=	"(" & rs("ddd") &") " & rs("telefone")
			session("contato")		=	rs("contato")	
			session("empresa")		=	rs("empresa")	
			session("email")		=	rs("email")
		end if
		
		session("habilitatrib") = ""
		if HabilitaCon = 1 then
			sql = "update TabProcCont set habilitatrib = 1 WHERE usuario = '"&session("vinculado")&"'"
			if  Request("aceite") = 1 and trim(habilitadoComl) = "" then
				sql5=""
				sql5 = "update tbConexaoTribunais_Parametros set fl_Habilita_Conexao_coml = 'L', fl_Habilita_Conexao_Processo = 1,nrolimiteconsultas_coml = 0  WHERE usuario= '"&session("vinculado")&"'"
				db.execute(sql5)

				session("habilitatrib") = "Liberou Acesso - TERMO DE ACEITE" 
				ok = grava_log_c(session("nomeusu"), "ALTERAÇÃO", "PARÂMETROS TRIBUNAIS", "Habilitar Conexão para Todos Processos do Jurídico: Sim.")
				'-------------usuario, acao, onde, descricao, modulo
				
			elseif  Request("aceite") <> 1 and trim(habilitadoComl) = "L" then
				session("habilitatrib") = "Liberou Acesso" 
				sqlmv=""
				sqlmv = "UPDATE tbConexaoTribunais_Andamentos SET fl_faturado = 1, fl_consulta_paga = 1"
				sqlmv = sqlmv & " WHERE usuario = '" & vinculado & "'"
				db.execute(sqlmv)
				
				ok = grava_log_c(session("nomeusu"), "ALTERAÇÃO", "PARÂMETROS TRIBUNAIS" , "Habilitar Conexão para Todos Processos do Jurídico: Sim.")

			elseif Request("aceite") <> 1 and habilitadoComl = "T" then
				session("habilitatrib") = "Liberou Acesso - TESTE" 
				sqlmv=""
				sqlmv = "UPDATE tbConexaoTribunais_Andamentos SET fl_faturado = 1, fl_consulta_paga = 0"
				sqlmv = sqlmv & " WHERE usuario = '" & vinculado & "'"
				db.execute(sqlmv)
				
				sql5=""
				sql5 = "update tbConexaoTribunais_Parametros set fl_Habilita_Conexao_coml = 'T', fl_Habilita_Conexao_Processo = 1  WHERE usuario= '"&session("vinculado")&"'"
				db.execute(sql5)


				ok = grava_log_c(session("nomeusu"), "ALTERAÇÃO", "PARÂMETROS TRIBUNAIS" , "Habilitar Conexão para Todos Processos do Jurídico: Sim.")
			end if

		else
			session("habilitatrib")= "Bloqueou Acesso" 
			sql = "update TabProcCont set habilitatrib = 0 WHERE usuario = '"&session("vinculado")&"'"
			ok = grava_log_c(session("nomeusu"), "ALTERAÇÃO", "PARÂMETROS TRIBUNAIS" , "Habilitar Conexão para Todos Processos do Jurídico: Não.")
		end if
		db.execute(sql)

		'Montagem do Corpo do E-mail
	    EmailBody = ""
	    EmailBody = EmailBody & "<table style=""font: 12 Verdana;"">"
	    EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>"
	    EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>"
	    EmailBody = EmailBody & "<tr><td colspan=""2""><b>O cliente abaixo efetuou uma alteração em seus parâmetros de conexão aos Tribunais.</b></td></tr>"
	    EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>"
	    EmailBody = EmailBody & "<tr><td width='10%'><b>Usuário:<b></td><td><b>"&session("vinculado")&"</b></td></tr>"
	    EmailBody = EmailBody & "<tr><td width='10%'>Empresa:</td><td>"&session("empresa")&"</td></tr>"
	    EmailBody = EmailBody & "<tr><td width='10%'>Email:</td><td>"&session("email")&"</td></tr>"
	    EmailBody = EmailBody & "<tr><td width='10%'>Contato:</td><td>"&session("contato")&"</td></tr>"
	    EmailBody = EmailBody & "<tr><td width='10%'>Telefone:</td><td>"&session("telefone")&"</td></tr>"
		EmailBody = EmailBody & "<tr><td width='10%'><b>Status:</b></td><td><b>"&session("habilitatrib")&"</b></td></tr>"
		EmailBody = EmailBody & "<tr><td width='10%'><b>Data:</b></td><td><b>"&session("data")&"</b></td></tr>"
	    EmailBody = EmailBody & "</table>"
	    EmailBody = EmailBody & "<table style=""font: 12 Verdana;"" cellpadding=""0"" cellspacing=""0"">"
   		EmailBody = EmailBody & "<tr><td colspan=""2""></td>&nbsp;</tr>"
		EmailBody = EmailBody & "<tr><td colspan=""2""></td>&nbsp;</tr>"
	    EmailBody = EmailBody & "<tr><td colspan=""2"">&nbsp;</td></tr>" &_
			"<tr><td colspan=""2"">Atenciosamente,</td></tr>" &_
			"<tr><td colspan=""2"">&nbsp;</td></tr>" &_
			"<tr><td colspan=""2""><strong>Depto. Comercial</strong></td></tr>" &_
			"<tr><td colspan=""2""><a href=""mailto:comercial@LDsoft.com.br"" style=""color: #333333;text-decoration: none;"">comercial@<strong>LD</strong>soft.com.br</a></td></tr>" &_
			"<tr><td colspan=""2"">&nbsp;</td></tr>" &_
			"<tr><td colspan=""2"" style=""color:#2F519A""><strong>LD</strong>SOFT</td></tr>" &_
			"<tr><td colspan=""2"">Informática especializada em Propriedade Intelectual e Advocacia</td></tr>" &_
			"<tr><td colspan=""2"">Empresa associada à ASSESPRO e SEPRORJ</td></tr>" &_
			"<tr><td colspan=""2""><a href=""http://www.LDsoft.com.br"" target=""_blank"" style=""color: #333333;text-decoration:none;"">www.<strong>LD</strong>soft.com.br</a></td></tr>" &_
			"<tr><td colspan=""2"">21 2613-3656</td></tr>" &_
			"</table>"
    		
        dir = Server.MapPath("/apol/automatico/")

	    Const ForReading = 1, ForWriting = 2
	    Dim fso, f
	    Set fso = CreateObject("Scripting.FileSystemObject")
	    Set f = fso.OpenTextFile(dir&"\email_proc.htm", ForReading)
	    ReadAllTextFile =  f.ReadAll

	    body_email = replace(ReadAllTextFile,"[email]",EmailBody)

	    'Envio de e-mail ao preencher termo de aceite com a conexão de Tribunais 
	    call envia_email(EmailTo,EmailFrom,"APOL - Parâmetro de Conexão aos Tribunais alterado pelo cliente.",body_email)

	end if

	response.redirect("cad_param_tribunais.asp?msg='Registro Gravado com Sucesso'")
%>


