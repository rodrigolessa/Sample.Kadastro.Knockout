<!--#include file="../include/conn.asp"-->
<!--#include file="db_open.asp"-->
<!--#include file="../include/funcoes.asp"-->
<%
randomize
MyValue = Int((9999 * Rnd) + 1000)
dir = server.mappath("bkp")&"\"
s = ""
Set fso = CreateObject("Scripting.FileSystemObject")
Set f = fso.GetFolder(dir)
Set fc = f.Files
For Each f1 in fc
	if Instr(1, f1.name, "bkp_" &Session("vinculado")& "_") > 0 then
		s = s & f1.name
		fso.DeleteFile(dir&f1.name)
	end if
Next
fto = dir&"apol_bkp_" &Session("vinculado")& "_" &replace(fdata(date),"/","")& "_" &MyValue& ".mdb"
fso.CopyFile dir&"bkp.mdb", fto

Set conn_mdb = Server.CreateObject("ADODB.Connection")
Datasource = "Driver={Microsoft Access Driver (*.mdb)}; DBQ="& fto & ";"
conn_mdb.Open Datasource

sql = "SELECT id, usuario, apelido, razao, cnpj_cpf, tipo, pasta, im, ie, hp, pessoa, logradouro1, bairro1, cidade1, estado1, cep1, tel1, fax1, end_pri1, end_corr1, end_fatu1, end_inpi1, logradouro2, bairro2, cidade2, estado2, cep2, tel2, fax2, end_pri2, end_corr2, end_fatu2, end_inpi2, contato1, email1, recebe1, contato2, email2, recebe2, contato3, email3, recebe3, desconto_inpi, anexo, objeto_social, obs FROM Envolvidos where usuario = '" &Session("vinculado")& "'"
set rs = conn.execute(sql)

while not rs.eof
	conn_mdb.execute("Insert Into Envolvidos (id, usuario, apelido, razao, cnpj_cpf, tipo, pasta, im, ie, hp, pessoa, logradouro1, bairro1, cidade1, estado1, cep1, tel1, fax1, end_pri1, end_corr1, end_fatu1, end_inpi1, logradouro2, bairro2, cidade2, estado2, cep2, tel2, fax2, end_pri2, end_corr2, end_fatu2, end_inpi2, contato1, email1, recebe1, contato2, email2, recebe2, contato3, email3, recebe3, desconto_inpi, anexo, objeto_social, obs) Values (" & tplic(1,rs("id")) & ", '"&tplic(0,rs("usuario")) & "', '"&tplic(0,rs("apelido")) & "', '"&tplic(0,rs("razao")) & "', '"&tplic(0,rs("cnpj_cpf")) & "', '"&tplic(0,rs("tipo")) & "', '"&tplic(0,rs("pasta")) & "', '"&tplic(0,rs("im")) & "', '"&tplic(0,rs("ie")) & "', '"&tplic(0,rs("hp")) & "', '"&tplic(0,rs("pessoa")) & "', '"&tplic(0,rs("logradouro1")) & "', '"&tplic(0,rs("bairro1")) & "', '"&tplic(0,rs("cidade1")) & "', '"&tplic(0,rs("estado1")) & "', '"&tplic(0,rs("cep1")) & "', '"&tplic(0,rs("tel1")) & "', '"&tplic(0,rs("fax1")) & "', " & t0(rs("end_pri1")) & ", " & t0(rs("end_corr1")) & ", " & t0(rs("end_fatu1")) & ", " & t0(rs("end_inpi1")) & ", '"&tplic(0,rs("logradouro2")) & "', '"&tplic(0,rs("bairro2")) & "', '"&tplic(0,rs("cidade2")) & "', '"&tplic(0,rs("estado2")) & "', '"&tplic(0,rs("cep2")) & "', '"&tplic(0,rs("tel2")) & "', '"&tplic(0,rs("fax2")) & "', " & t0(rs("end_pri2")) & ", " & t0(rs("end_corr2")) & ", " & t0(rs("end_fatu2")) & ", " & t0(rs("end_inpi2")) & ", '"&tplic(0,rs("contato1")) & "', '"&tplic(0,rs("email1")) & "', " & t0(rs("recebe1")) & ", '"&tplic(0,rs("contato2")) & "', '"&tplic(0,rs("email2")) & "', " & t0(rs("recebe2")) & ", '"&tplic(0,rs("contato3")) & "', '"&tplic(0,rs("email3")) & "', " & t0(rs("recebe3")) & ", " & t0(rs("desconto_inpi")) & ", '"&tplic(0,rs("anexo")) & "', '"&tplic(0,rs("objeto_social")) & "', '"&tplic(0,rs("obs")) & "')")
	rs.movenext
wend

sql = "SELECT id, usuario, ocorrencia, processo, data, tipo FROM ocorrencias where tipo = 'C' and usuario = '" &Session("vinculado")& "'"
set rs = conn.execute(sql)

while not rs.eof
	conn_mdb.execute("Insert Into ocorrencias (id, usuario, ocorrencia, processo, data, tipo) Values (" & tplic(1,rs("id")) & ", '"&tplic(0,rs("usuario")) & "', '"&tplic(0,rs("ocorrencia")) & "', '"&tplic(0,rs("processo")) & "', " & rdata(rs("data")) & ", '"&tplic(0,rs("tipo")) & "')")
	rs.movenext
wend

sql = "SELECT id, usuario, historico, id_envolvido, data FROM hist_envolvido where usuario = '" &Session("vinculado")& "'"
set rs = conn.execute(sql)

while not rs.eof
	conn_mdb.execute("Insert Into hist_envolvido (id, usuario, historico, id_envolvido, data) Values (" & tplic(1,rs("id")) & ", '"&tplic(0,rs("usuario")) & "', '"&tplic(0,rs("historico")) & "', '" & rs("id_envolvido") & "', " & rdata(rs("data")) & ")")
	rs.movenext
wend

'sql = "SELECT usuario, email_s_desp, email_m_prorrog, email_s_prov, despachos, tipo_visu, carta_colid, carta_rpi, cfe, dias FROM Parametros where usuario = '" &Session("vinculado")& "'"
'set rs = conn.execute(sql)

'while not rs.eof
'	conn_mdb.execute("Insert Into Parametros (usuario, email_s_desp, email_m_prorrog, email_s_prov, despachos, tipo_visu, carta_colid, carta_rpi, cfe, dias) Values ('"&tplic(0,rs("usuario")) & "', " & t0(rs("email_s_desp")) & ", " & t0(rs("email_m_prorrog")) & ", " & t0(rs("email_s_prov")) & ", '"&tplic(0,rs("despachos")) & "', '"&tplic(0,rs("tipo_visu")) & "', '"&tplic(0,rs("carta_colid")) & "', '"&tplic(0,rs("carta_rpi")) & "', " & t0(rs("cfe")) & ", " & tplic(1,rs("dias")) & ")")
'	rs.movenext
'wend

sql = "SELECT id, prazo_ger, usuario, prazo_ofi, processo, desp, rpi, descricao, executada, dt_executada, advogado, com_pess, com_resp, outro_email, com_outro, pessoa, hora, tipo, sms, tel, qd FROM Providencias where (tipo = 'C') and usuario = '" &Session("vinculado")& "' or  usuario like '" &Session("vinculado")& "##%'"
set rs = conn.execute(sql)

while not rs.eof
	conn_mdb.execute("Insert Into Providencias (id, prazo_ger, usuario, prazo_ofi, processo, desp, rpi, descricao, executada, dt_executada, advogado, com_pess, com_resp, outro_email, com_outro, pessoa, hora, tipo, sms, tel, qd) Values (" & tplic(1,rs("id")) & ", " & rdata(rs("prazo_ger")) & ", '"&tplic(0,rs("usuario")) & "', " & rdata(rs("prazo_ofi")) & ", '"&tplic(0,rs("processo")) & "', '"&tplic(0,rs("desp")) & "', '"&tplic(0,rs("rpi")) & "', '"&tplic(0,rs("descricao")) & "', " & t0(rs("executada")) & ", " & rdata(rs("dt_executada")) & ", " & t0(rs("advogado")) & ", " & t0(rs("com_pess")) & ", " & t0(rs("com_resp")) & ", '"&tplic(0,rs("outro_email")) & "', " & t0(rs("com_outro")) & ", " & t0(rs("pessoa")) & ", '"&tplic(0,rs("hora")) & "', '"&rs("tipo")&"', " &t0(rs("sms"))& ", '"&rs("tel")&"', '"&rs("qd")&"')")
	rs.movenext
wend

sql = "SELECT id, usuario, nome, email, tipo, obs FROM Responsaveis where usuario = '" &Session("vinculado")& "'"
set rs = conn.execute(sql)

while not rs.eof
	conn_mdb.execute("Insert Into Responsaveis (id, usuario, nome, email, tipo, obs) Values (" & tplic(1,rs("id")) & ", '"&tplic(0,rs("usuario")) & "', '"&tplic(0,rs("nome")) & "', '"&tplic(0,rs("email")) & "', '"&tplic(0,rs("tipo")) & "', '"&tplic(0,rs("obs")) & "')")
	rs.movenext
wend

sql = "SELECT id, processo, vinculado, tipo, usuario FROM Vinculado where usuario = '" &Session("vinculado")& "'"
set rs = conn.execute(sql)

while not rs.eof
	conn_mdb.execute("Insert Into Vinculado (id, processo, vinculado, tipo, usuario) Values (" & tplic(1,rs("id")) & ", '"&tplic(0,rs("processo")) & "', '"&tplic(0,rs("vinculado")) & "', '"&tplic(0,rs("tipo")) & "', '"&tplic(0,rs("usuario")) & "')")
	rs.movenext
wend

sql = "SELECT codigo, usuario, processo1, processo2, tipo, obs, apenso FROM  TabVincProc where usuario = '" &Session("vinculado")& "'"
set rs = db.execute(sql)

while not rs.eof
	conn_mdb.execute("Insert Into TabVincProc (codigo, usuario, processo1, processo2, tipo, obs, apenso) Values (" & rs("codigo") & ", '"&tplic(0,session("vinculado"))&"' , "&rs("processo1")&" , "&rs("processo2")&", '"&tplic(0,rs("tipo")) & "', '"&tplic(0,rs("obs")) & "', '"&tplic(0,rs("apenso")) & "')")
	rs.movenext
wend


sql = "SELECT codigo, usuario, processo, valor, data, moeda, referencia FROM TabValCont where usuario = '" &Session("vinculado")& "'"
set rs = db.execute(sql)

while not rs.eof
	conn_mdb.execute("Insert Into TabValCont (codigo, usuario, processo, valor, data, moeda, referencia) Values (" & rs("codigo") & ", '"&tplic(0,session("vinculado"))&"' , "&rs("processo")&" , "&replace(rs("valor"),",",".")&" , "&rdata(rs("data"))&", '"&tplic(0,rs("moeda")) & "', '"&tplic(0,rs("referencia")) & "')")	
	rs.movenext                                                                    													
wend


sql = "SELECT id_processo, usuario, processo, natureza, pasta, tipo, desc_res, competencia, situacao, cliente, outraparte, vinculados, instancia, rito, orgao, juizo, comarca, distribuicao, dt_encerra, responsavel, desc_det, obs, participante, principal FROM TabProcCont where usuario = '" &Session("vinculado")& "'"
set rs = db.execute(sql)

while not rs.eof
	conn_mdb.execute("Insert Into TabProcCont (id_processo, usuario, processo, natureza, pasta, tipo, desc_res, competencia, situacao, cliente, outraparte, vinculados, instancia, rito, orgao, juizo, comarca, distribuicao, dt_encerra, responsavel, desc_det, obs, participante, principal) Values (" & rs("id_processo") & ", '"&tplic(0,session("vinculado"))&"' , '"&tplic(0,rs("processo"))&"' , '"&tplic(0,rs("natureza"))&"' , '"&tplic(0,rs("pasta"))&"' , '"&tplic(0,rs("desc_res"))&"' , '"&tplic(0,rs("tipo"))&"' , '"&tplic(0,rs("competencia"))&"' , '"&tplic(0,rs("situacao"))&"' , '"&tplic(0,rs("cliente"))&"' , '"&tplic(0,rs("outraparte"))&"' , '"&tplic(0,rs("vinculados"))&"' , '"&tplic(0,rs("instancia"))&"' , '"&tplic(0,rs("rito"))&"' , '"&tplic(0,rs("orgao"))&"' , '"&tplic(0,rs("juizo"))&"' , '"&tplic(0,rs("comarca"))&"' , "&rdata(rs("distribuicao"))&" , "&rdata(rs("dt_encerra"))&" , "&rs("responsavel")&" , '"&tplic(0,rs("desc_det"))&"' , '"&tplic(0,rs("obs"))&"' , '"&tplic(0,rs("participante"))&"' , '"&tplic(0,rs("principal"))&"')")	
	rs.movenext                                                                    													
wend


sql = "SELECT codigo, usuario, processo, envolvido, tipo FROM TabCliCont where usuario = '" &Session("vinculado")& "'"
set rs = db.execute(sql)

while not rs.eof
	conn_mdb.execute("Insert Into TabCliCont (codigo, usuario, processo, envolvido, tipo) Values (" & rs("codigo") & ", '"&tplic(0,session("vinculado"))&"' , "&rs("processo")&" , "&rs("envolvido")&" , '"&tplic(0,rs("tipo"))&"')")	
	rs.movenext                                                                    													
wend


sql = "SELECT codigo, usuario, cobranca, comunicacao, dias, tipo_visu, email_ocorrencia, email_providencia FROM parametros where usuario = '" &Session("vinculado")& "'"
set rs = db.execute(sql)

while not rs.eof	
	conn_mdb.execute("Insert Into parametros (codigo, usuario, cobranca, comunicacao, dias, tipo_visu, email_ocorrencia, email_providencia) Values (" & rs("codigo") & ", '"&tplic(0,session("vinculado"))&"' , '"&tplic(0,rs("cobranca"))&"' , '"&tplic(0,rs("comunicacao"))&"' , "&rs("dias")&", '"&tplic(0,rs("tipo_visu"))&"', '"&tplic(0,rs("email_ocorrencia"))&"', '"&tplic(0,rs("email_providencia"))&"')")	
	rs.movenext                                                                    													
wend


sql = "SELECT codigo, Usuario, Tipo, descricao, estado FROM Auxiliares where usuario = '" &Session("vinculado")& "'"
set rs = db.execute(sql)

while not rs.eof		
	conn_mdb.execute("Insert Into Auxiliares (codigo, Usuario, Tipo, descricao, estado) Values (" & rs("codigo") & ", '"&tplic(0,session("vinculado"))&"' , '"&tplic(0,rs("tipo"))&"' , '"&tplic(0,rs("descricao"))&"' , '"&rs("estado")&"')")	
	rs.movenext                                                                    													
wend

response.redirect("lista_bkp.asp")
%>
