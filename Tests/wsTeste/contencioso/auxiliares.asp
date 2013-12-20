<!--#include file="db_open.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<link rel="STYLESHEET" type="text/css" href="style.css"> 
<% menu_onde = "tabela" %>
<%
select case request("tipo")
	case "N"
		xtit = "Natureza"
	
	case "P"
		xtit = "Providência"
		
	case "H"
		xtit = "Históricos"
		
	case "R"
		xtit = "Rito"
	
	case "O"
		xtit = "Órgão"
		
	case "J"
		xtit = "Juízo"
		
	case "C"
		xtit = "Comarca"

	case "T"
		xtit = "Tipo&nbsp;de&nbsp;Ação"
		
	case "F"
		xtit = "Referência&nbsp;Financeira"
		
	case "L"
		xtit = "Objeto&nbsp;Principal"
	
	case "3"
		xtit = Replace(Request("campo"), " ", "&nbsp;")
		
	case "4"
		xtit = Replace(Request("campo"), " ", "&nbsp;")
end select

if request("codigo") = "" then
	tipo_tit = "Cadastrar"
else
	tipo_tit = "Editar"
end if

%>	
<!--#include file="header.asp"-->

	<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<form name=frm method=post action=auxiliares_salvar.asp onsubmit="return valida()">
		<input type=hidden name=pdescricao_c value="<%=request("pdescricao_c")%>">
		<tr>		
			<td height="16" valign="middle" width=23px>&nbsp;<img src="imagem/tit_le.gif" width="19" height="18"></td>
			<td height="16" valign="middle" align=center class="titulo">&nbsp;&nbsp;<%=tipo_tit%>&nbsp;<%=xtit%>&nbsp;&nbsp;</td>
			<td height="16" width=820px background="imagem/tit_ld.gif"></td>
			<td height="16" valign="middle" width=20px><img src="imagem/tit_fim.gif" width="21" height="16"></td>
			<% if (Session("cont_manut_tab")) or (Session("adm_adm_sys")) then %>
			<%if request("codigo") <> "" then%>
			<td height="16" valign="middle">&nbsp;<a href="auxiliares.asp?tipo=<%=request("tipo")%>"><img src="imagem/add-proc.gif" alt="Cadastrar <%=xtit%>" width="15" height="18" border="0"></a>&nbsp;</td>
			<% End If %>
			<% End If %>
		</tr>
	</table>	
<%	
tipo = ""
descricao = ""
vreset = "Limpar"
if request("codigo") <> "" then
	vreset = "Restaurar"
	sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' AND codigo = "&tplic(1,request("codigo"))
	set rst = db.execute(sql)			
	if not rst.eof then
		tipo = rst("tipo")
		descricao = rst("descricao")
		estado = rst("estado")
	end if
end if
%>

	<input type="hidden" name="codigo" value="<%=request("codigo")%>">
	<input type="hidden" name="tipo" value="<%=request("tipo")%>">
	<input type="hidden" name="campo" value="<%=request("campo")%>">
	<table bgcolor="#EFEFEF" width="100%" class=tabela border="0" cellspacing="2" cellpadding="3">
		<tr>
			<td>Tipo:</td>
			<td><%=xtit%></td>
		</tr>		
		<tr>
			<td>Descrição:</td>
			<td width="100%"><input class="cfrm" type="text" name="descricao" value="<%=descricao%>" size="50" maxlength="50"></td>
		</tr>
		<%if request("tipo") = "C" then %>
			<tr>
				<td>Estado:</td>
				<td width="100%"><input class="cfrm" type="text" name="estado" value="<%=estado%>" size="2" maxlength="2" onKeyUp="letras_estado(this);"></td>
			</tr>
		<%end if%>
		<tr>
			<td align="center" colspan="2">
				<input class="cfrm" type="submit"<% if not ((Session("cont_manut_tab")) or (Session("adm_adm_sys"))) then %> disabled<% End If %> value="Gravar" name="bts">
				&nbsp;&nbsp;<input type="reset" value="<%=vreset%>" class="cfrm">
			</td>
		</tr>
	</table>		
</form>

<script>
function letras_estado()
{
	var digits="qwertyuioplkjhgfdsazxcvbnmQWERTYUIOPLKJHGFDSAZXCVBNM"
	var campo_temp 
	for (var i=0;i<document.frm.estado.value.length;i++){
	  campo_temp=document.frm.estado.value.substring(i,i+1)	
	  if (digits.indexOf(campo_temp)==-1){
		    document.frm.estado.value = document.frm.estado.value.substring(0,i);
		    break;
	   }	   
	}
}	

function valida(){
	<% if not ((Session("cont_manut_tab")) or (Session("adm_adm_sys"))) then %>return false;<% End If %>
	if (document.frm.tipo.value == "")
	{
		alert("Preencha o campo Tipo de Cadastro.")
		frm.tipo.focus();
		return false;
	}
	
	if (document.frm.descricao.value == "")
	{
		alert("Preencha o campo Descrição.")
		frm.descricao.focus();
		return false;
	}
	document.frm.bts.disabled = true;
	return true;
}
frm.descricao.focus();
</script>
