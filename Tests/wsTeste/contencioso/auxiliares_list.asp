<%	session("voltar") = "javascript: history.back()"%>

<!--#include file="db_open.asp"-->
<!--#include file='../usuario_logado.asp'--> 
<!--#include file='../include/Db_open_webseek_teste.asp'-->
<!--#include file='../include/Db_open_usuarios.asp'-->
<!--#include file="../include/conn_webseek.asp"-->
<!--#include file="../include/conn.asp"-->
<link rel="STYLESHEET" type="text/css" href="style.css"> 

<title>APOL Jurídico<% If Request.Querystring("imprimir") <> "" then %> - Impressão de Informações<% End If %></title>
<% menu_onde = "tabela" %>
<%
tipo = request("tipo")
if tipo = "" then
	tipo = session("tipo")
end if


select case tipo
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

if request("acao") = "C" then
	bt_imprimir = true 
end if
if request("imprimir") = "S" then
		l_imp = "_p"
end if

if request("imprimir") = "" then%>	
	<!--#include file="header.asp"-->			
<% Else %>
	<table cellpadding="0" cellspacing="0" width="100%" border="0">	
	<tr>
		<td><%
			SQL = "select logotipo from usuario where vinculado='"&session("vinculado")&"' and nomeusu='"& session("vinculado") &"'"
			set rsy = conn_usu.execute(SQL)

			if rsy("logotipo") <> "" then
			%>
			<img src="../logo_cliente/<%=rsy("logotipo")%>" border="0">
			<% end if %></td>
		<td align="right" valign="top"><span class="preto11<%=l_imp%>"><%= now() %></span></td>
	</tr>
	</table>
<% End If %>	
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<form name=frm method=post action=auxiliares_list.asp onsubmit="return valida()" >
			<input type="hidden" name="tipo" value="<%=request("tipo")%>">
			<input type="hidden" name="campo" value="<%=request("campo")%>">
			<input type="hidden" name="primeiro" value="N">
			<input type="hidden" name="acao" value="C">
		<tr>		
			<td height="16" valign="middle" width=23px>&nbsp;<img src="imagem/tit_le.gif" width="19" height="18"></td>
			<td height="16" valign="middle" align=center class="titulo">&nbsp;&nbsp;Consultar&nbsp;<%=xtit%>&nbsp;&nbsp;</td>
			<td height="16" width=820px background="imagem/tit_ld.gif"></td>
			<td height="16" valign="middle" width=20px><img src="imagem/tit_fim.gif" width="21" height="16"></td>
			<% if (Session("cont_manut_tab")) or (Session("adm_adm_sys")) then %>
			<%if request("imprimir") = "" then%><td height="16" valign="middle">&nbsp;<a href="auxiliares.asp?tipo=<%=request("tipo")%>&campo=<%=request("campo")%>"><img src="imagem/add-proc.gif" alt="Cadastrar <%=xtit%>" width="15" height="18" border="0"></a>&nbsp;</td><%end if%>
			<% End If %>
		</tr>
	</table>	
	<table border=0 cellspacing=0 cellpadding=6 width=100% class=preto11>  
		<%if request("imprimir") = "" then%>
		<tr bgcolor="#F3F3F3">
			<td valign=top colspan=6 class=preto11>
				Descrição: <input type=text class="cfrm" name=pdescricao_c value="<%=request("pdescricao_c")%>" size=20 maxlength=20>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%If tipo = "C" then%>Estado: <input type=text class="cfrm" name=pestado_c value="<%=request("pestado_c")%>" size=2 maxlength=2><%end if%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=submit class="cfrm" name=bts value=Pesquisar> <input type=button class="cfrm" name=Limpar value=Limpar onclick="frm.pdescricao_c.value=''<%if tipo = "C" then%>;frm.pestado_c.value=''<%end if%>">
			</td>
		</tr>
	</table>
	<table border=0 cellspacing=0 cellpadding=2 width=100% class=preto11> 		
		<%end if%>
		
		<%
		if trim(request("pdescricao_c")) = "" AND request("pestado_c") = "" then
			if request("primeiro") = "N" then
				sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and tipo = '"&tplic(0,request("tipo"))&"' order by descricao"				
					session("tipo") = request("tipo")
			else	
				session("tipo") = ""
				sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and  tipo = '"&tplic(0,request("tipo"))&"' and 0 <> 0 order by descricao"				
			end if
		else

			if request("pdescricao_c") <> "" then
				cons = cons & " and descricao like '%"&tplic(1,replace(request("pdescricao_c"),"'","´"))&"%' "
			end if
			if request("pestado_c") <> "" then
				cons = cons & " and estado = '"&tplic(1,replace(request("pestado_c"),"'","´"))&"' "
			end if

			sql = "select * from auxiliares where usuario = '"&session("vinculado")&"' and  tipo = '"&tplic(0,request("tipo"))&"' "&cons&" order by descricao"
			session("tipo") = ""
		end if	

'	response.write sql	
		
		if request("acao") = "C" then
			if request("imprimir") = "" then
				set rst = db.execute(sql)
				session("sqla") = sql
			else				
				set rst = db.execute(session("sqla"))
			end if
			If not rst.eof Then%>
			<tr class="tit1<%=l_imp%>">
				<%if request("imprimir") = "" then%><td></td><%end if%>
				
				<%If tipo = "C" then%>
					<td width=80%><b>Descrição</td>
					<td width=20%><b>Estado</td>
				<%else%>
					<td width=100%><b>Descrição</td>
				<%end if%>
			</tr>
				<%
				do while not rst.eof
					if cor = "#FFFFFF" then
						cor = "#EFEFEF"
					else
						cor = "#FFFFFF"
					end if
					%>
					<tr bgcolor=<%=cor%>>				
						<%if request("imprimir") = "" then%><td width="20" align="center"><% if (Session("cont_exc_tab")) or (Session("adm_adm_sys")) then %><a href="javascript:mostra_exc(<%= rst("codigo") %>)"><img src="imagem/lixeira.gif" alt="Excluir" width="13" height="17" border="0"></a><% End If %></td><%end if%>
						<td class=preto11><% If Request.Querystring("imprimir") = "" then %><a class=preto11 href="auxiliares.asp?codigo=<%=rst("codigo")%>&tipo=<%=request("tipo")%>&pdescricao_c=<%=request("pdescricao_c")%>&campo=<%=request("campo")%>"><%end if%><%=rst("descricao")%></a></td>

						<%If tipo = "C" then%>
						<td class=preto11><%=rst("estado")%></td>
						<%end if%>
					</tr>
					<%
					
					rst.movenext
				loop
			else%>
				<tr>
					<td width="100%" height=2></td>
				</tr>
				<tr>
					<td width="100%" height="26" align="center" bgcolor="#EFEFEF"><center><b>Não foram encontrados Registros que atendam às condições estabelecidas</b></center></td>
				</tr>
			<%end if
		end if%>			
			
	</table>	
</form>	

<script>
function del(aid,atipo){
	if (window.confirm("Confirma exclusão.")){
		location = "auxiliares_excluir.asp?tipo_func=del&tipo=<%=request("tipo")%>&id="+aid
		}
	}
	function valida()
	{
	document.frm.bts.disabled = true;
	return true;	
	}
</script>

<div id="exclui" style="position: absolute; top: 60px; width: 770px; left: 1px; height: 400px; visibility: hidden;">
<br>
<table width="100%" height="100%">
<tr valign="middle">
	<td align="center">
<table width="300" bgcolor="#FFFFFF" style="border: 1px solid Black;" class="preto11">
<tr>
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;Exclusão&nbsp;de&nbsp;<%=xtit%>&nbsp;&nbsp;</td>
		<td height="16" width="100%"><img src="imagem/tit_ld.gif" width="100%" height="18" border="0"></td>
		<td height="16" valign="middle"><img src="imagem/tit_fim.gif" width="21" height="16"></td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td align="center">&nbsp;</td>
</tr>
<tr>
	<td align="center"><img src="imagem/pergunta.gif" width="35" height="33" border="0" align="absmiddle">&nbsp;&nbsp;<b style="color:red;">Confirma exclusão ?</b></td>
</tr>
<tr>
	<td align="center">&nbsp;</td>
</tr>
<tr>
	<td align="center">
	<table class="linkp11">
	<tr>
		<td background="imagem/botao_limpo.gif" width="82" height="21" align="center"><a href="javascript: fecha_exc()" class="linkp11">&nbsp;&nbsp;&nbsp;Não&nbsp;&nbsp;&nbsp;</a></td>
		<td>&nbsp;&nbsp;</td>
		<td background="imagem/botao_limpo.gif" width="82" height="21" align="center"><a href="javascript: location = 'auxiliares_excluir.asp?tipo_func=del&tipo=<%=tipo%>&campo=<%=xtit%>&pdescricao_c=<%=request("pdescricao_c")%>&id='+pid" class="linkp11">&nbsp;&nbsp;&nbsp;Sim&nbsp;&nbsp;&nbsp;</a></td>
	</tr>
	</table>
	</td>
</tr>
</table>
	</td>
</tr>
</table>
</div>
<script>
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_showHideLayers() { //v3.0
  var i,p,v,obj,args=MM_showHideLayers.arguments;
  for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v='hide')?'hidden':v; }
    obj.visibility=v; }
}
var pid = 0;

function mostra_exc(id)
		{
		pid=id;
		MM_showHideLayers('exclui','','show');
		}
		
function fecha_exc()
		{
		MM_showHideLayers('exclui','','hide');
		}

</script>
