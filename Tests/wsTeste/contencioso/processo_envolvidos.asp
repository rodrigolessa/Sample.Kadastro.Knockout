<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<!--#include file="../include/conn_webseek.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<%
processo1 = request("processo1")
processo2 = request("processo2")
%>
<title>Vinculo de Processos</title>
<link rel="STYLESHEET" type="text/css" href="style.css"> 
<link rel="STYLESHEET" type="text/css" href="style2.css">
<script language="javascript" src="valida.js"></script>
<body topmargin=10 leftmargin=0>
<form name=frm method=post action=processo_vinculo_salvar.asp onsubmit="return valida()">
	<input type=hidden name=fprocesso1_n value='<%=request("fprocesso1_n")%>'>
	
	<input type=hidden name=processo1 value='<%=processo1%>'>
	<input type=hidden name=processo2 value='<%=processo2%>'>
	
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>		
			<td height="16" valign="middle" width=23px>&nbsp;<img src="imagem/tit_le.gif" width="19" height="18"></td>
			<td height="16" valign="middle" align=center class="titulo" width=150px>Processos Vinculados</td>
			<td height="16" width=330px background="imagem/tit_ld.gif"></td>
			<td height="16" valign="middle" width=20px><img src="imagem/tit_fim.gif" width="21" height="16"></td>											
		</tr>
	</table>
	<table bgcolor="#EFEFEF" width="100%" class=tabela border="0" cellspacing="2" cellpadding="3">			
		<tr class=tit1>
			<td align="left" width=20%>Tipo</td>						
			<td align="left" width=40%>Processo</td>			
			<td align="left" width=40%>Observação</td>
			<td align="left">Apenso?</td>
		</tr>		
		<tr>
			<td align="left" width=20%>
				<select name=ftipo_c onchange="frm.action='processo_vinculo.asp';frm.submit()">
						<option value="">----Selecione----
						<option value="C" <%if request("ftipo_c") = "C" then%>selected<%end if%>>Jurídico
						<option value="M" <%if request("ftipo_c") = "M" then%>selected<%end if%>>Marca
						<option value="P" <%if request("ftipo_c") = "P" then%>selected<%end if%>>Patente
					</select>
			</td>						
			<td align="left" width=40%>
				<%
				if request("ftipo_c") <> "" then
					select case request("ftipo_c")
						case "C"
							sql = "select * from TabProcCont where usuario = '"&session("vinculado")&"' and id_processo <> "&tplic(1,request("fprocesso1_n"))&" and id_processo not in (select processo1 from TabVincProc Where usuario = '"&session("vinculado")&"' and (processo1 = '"&tplic(0,request("fprocesso1_n"))&"' or processo2 = '"&tplic(0,request("fprocesso1_n"))&"')) and id_processo not in (select processo2 from TabVincProc Where usuario = '"&session("vinculado")&"' and tipo = 'C' AND (processo1 = '"&tplic(0,request("fprocesso1_n"))&"' or processo2 = '"&tplic(0,request("fprocesso1_n"))&"'))"							
'							sql = "select * from TabProcCont where usuario = '"&session("vinculado")&"' and id_processo <> "&request("fprocesso1_n")&" and id_processo not in (select processo1 from TabVincProc Where usuario = '"&session("vinculado")&"' and (processo1 = '"&request("fprocesso1_n")&"' or processo2 = '"&request("fprocesso1_n")&"')) and id_processo not in (select processo2 from TabVincProc Where usuario = '"&session("vinculado")&"' and (processo1 = '"&request("fprocesso1_n")&"' or processo2 = '"&request("fprocesso1_n")&"'))"							
'							response.write sql
							set rstp = db.execute(sql)
						case "M"
'							sql = "SELECT processo as id_processo, processo as processo FROM apol.dbo.Processos WHERE usuario = '" &session("vinculado")&"' and processo <> "&request("fprocesso1_n")&" order by processo"
							sql = "SELECT processo AS id_processo, processo AS processo FROM APOL.dbo.Processos WHERE (usuario = '"&session("vinculado")&"') AND (processo <> '"&tplic(0,request("fprocesso1_n"))&"') AND (processo COLLATE Latin1_General_CI_AS NOT IN (SELECT processo2 FROM TabVincProc WHERE usuario = '"&session("vinculado")&"' AND (processo1 = '"&tplic(0,request("fprocesso1_n"))&"' OR processo2 = '"&tplic(0,request("fprocesso1_n"))&"'))) AND (processo COLLATE Latin1_General_CI_AS NOT IN (SELECT processo1 FROM TabVincProc WHERE usuario = '"&session("vinculado")&"' AND (processo1 = '"&tplic(0,request("fprocesso1_n"))&"' OR processo2 = '"&tplic(0,request("fprocesso1_n"))&"')))"
							set rstp = db.execute(sql)
						case "P"
'							sql = "SELECT processo as id_processo, processo as processo, natureza as natureza FROM apol_patentes.dbo.Processos WHERE usuario = '" &session("vinculado")&"' and id_processo <> "&request("fprocesso1_n")&" order by processo"
							sql = "SELECT processo AS id_processo, processo AS processo, natureza AS natureza FROM apol_patentes.dbo.Processos WHERE (usuario = '" &session("vinculado")&"') AND (processo <> '"&tplic(0,request("fprocesso1_n"))&"') AND (natureza+processo COLLATE Latin1_General_CI_AS NOT IN (SELECT processo2 FROM TabVincProc WHERE usuario = '" &session("vinculado")&"' AND (processo1 = '"&tplic(0,request("fprocesso1_n"))&"' OR processo2 = '"&tplic(0,request("fprocesso1_n"))&"'))) AND (natureza+processo COLLATE Latin1_General_CI_AS NOT IN (SELECT processo1 FROM TabVincProc WHERE usuario = '" &session("vinculado")&"' AND (processo1 = '"&tplic(0,request("fprocesso1_n"))&"' OR processo2 = '"&tplic(0,request("fprocesso1_n"))&"')))"
							set rstp = db.execute(sql)		
							
					end select
					%>
					<select name=fprocesso2_n style="width:250">
						<option value="">----Selecione----
						<%
						do while not rstp.eof
							%>
							<option value='<%if request("ftipo_c") = "P" then%><%=rstp("natureza")%><%end if%><%=rstp("id_processo")%>'><%if request("ftipo_c") = "P" then%><%=rstp("natureza")%><%end if%>&nbsp;<%=rstp("processo")%>											
							<%
							rstp.movenext
						loop
				end if
				%>
			</td>			
			<td align="left" width=40%><input type=text name=fobs_c value="" size=30 maxlength=200 style="width:225"></td>
			<td><select name="fapenso_c"><option value="">  </option><option value="S">Sim</option><option value="N">Não</option></select></td>
		</tr>		
		
	</table>
	<center>
	<br>
	<input type=submit value="Vincular Processo" onsubmit="frm.action=" name="bts"> <input type=button value="Limpar" onclick="frm.ftipo_c.value='';frm.fprocesso2_n.value='';frm.fobs_c.value='';frm.fapenso_c.value=''">
</form>

<script>
	function valida()
	{		
		if (frm.ftipo_c.value == "")
		{
			alert("Selecione o Tipo de Vinculo.")
			frm.ftipo_c.focus();
			return false;
		}
		
		if (frm.fprocesso2_n.value == "")
		{
			alert("Selecione o Processo.")
			frm.fprocesso2_n.focus();
			return false;
		}
		
		if (frm.fapenso_c.value == "" && frm.ftipo_c.value == 'C')
		{
			alert("Preencha o campo Apenso.")
			frm.fapenso_c.focus();
			return false;
		}
		document.frm.bts.disabled = true;		
		return true;
	}	
</script>