<!--#include file="db_open.asp"-->
<%
if Request("dias") <> "" then
	dias = "dias = " &tplic(1,Request("dias"))& ","
end if
if Request("quantanda") <> "" then
	quantanda= "quantanda= " &tplic(1,Request("quantanda"))& ","
end if

if Request("parado") <> "" then
	parado = "parado = " &tplic(1,Request("parado"))& ","
end if

if request("resp_proc_provid") = "1" then
	resp_proc_provid = 1
	log_resp_proc_provid = "Sim"
else
	resp_proc_provid = 0
	log_resp_proc_provid = "Não"
end if

if request("prov_processo_retroativo") = "1" then
	prov_processo_retroativo = 1
	log_prov_processo_retroativo = "Sim"
else
	prov_processo_retroativo = 0
	log_prov_processo_retroativo = "Não"
end if

db.execute("UPDATE Parametros SET "& tplic(1,dias) & tplic(1,quantanda) & tplic(1,parado) & " resp_proc_provid = "&t0(resp_proc_provid)& ", prov_processo_retroativo = "&t0(prov_processo_retroativo)&"  WHERE  usuario = '"&session("vinculado")&"'")
ok = grava_log_cont(session("nomeusu"),"ALTERAÇÃO","PARÂMETROS","Campos (Parâmetros Gerais) => Usar resp. dos processos = " & log_resp_proc_provid & ", Gerar prov. para proc. retroativos = "& log_prov_processo_retroativo &", Exibir provid. dos próximos = " & Request("dias") & " dias")
response.redirect("param.asp")
%>
