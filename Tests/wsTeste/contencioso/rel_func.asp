<%
Class clsRelatorio
	Private titulos
	Private paginas
	Private largura
	Private altura
	Private dir_img
    
    Private Sub Class_Initialize()
		titulos = ""
		paginas = ""
		largura = 250
		altura = 144
		dir_img = "../img_comp/"
		
		Response.Write("<form name=""frm_rel_dotnet"" method=""post"">")
		for each campo in request.form
			Response.Write("<input type=""Hidden"" name=""" &campo& """ value=""" &Request(campo)& """>")
		next
		for each campo in Request.Querystring
			Response.Write("<input type=""Hidden"" name=""" &campo& """ value=""" &Request.Querystring(campo)& """>")
		next
		Response.Write("<input type=""Hidden"" name=""nomeusu"" value=""" &session("nomeusu")& """>")
		Response.Write("</form>")
    End Sub
	
	Public Sub addRel(p1,p2)
		if titulos = "" then
			titulos = p1
			paginas = p2
		else
			titulos = titulos & "|" & p1
			paginas = paginas & "|" & p2
		end if
	End Sub
	
	Public Sub RenderRel(positionX, positionY)
		%>
		<script src="<%= dir_img %>prototype.js" type="text/javascript"></script>
		<script>
			function mostra_relat(){
				$('if_relat').setStyle({left: (<%= positionX %>)+'px', top: (<%= positionY %>)+'px'});
				$('div_relat').setStyle({left: (<%= positionX %>)+'px', top: (<%= positionY %>)+'px'});
				$('if_relat').show();
				$('div_relat').show();
			}
			
			function fecha_relat(){
				$('if_relat').hide();
				$('div_relat').hide();
			}
		</script>
		<iframe id="if_relat" src="<%= dir_img %>branco.htm" style="position: absolute; display:none; top: -1000px; width: <%= largura %>px; height: <%= altura-2 %>px; left: -1000px; z-index: 10;"></iframe>
		<div id="div_relat" style="background-color: White; border: 1px solid Black; position: absolute; display:none; top: -1000px; width: <%= largura %>px; height: <%= altura %>px; left: -1000px; z-index: 99;">
		<table cellpadding="0" cellspacing="0" border="0" width="100%" class="linha">
		<tr>
			<td height="16" valign="middle">&nbsp;<img src="<%= dir_img %>tit_le.gif" width="19" height="18">&nbsp;</td>
			<td height="16" valign="middle" class="titulo">Relatórios&nbsp;em&nbsp;PDF&nbsp;&nbsp;</td>
			<td height="16" width="100%"><img src="<%= dir_img %>tit_ld.gif" width="100%" height="18" border="0"></td>
			<td height="16" valign="middle"><img src="<%= dir_img %>tit_fim.gif" width="21" height="16"></td>
			<td height="16" valign="middle">&nbsp;<a href="javascript: fecha_relat()"><img align="absmiddle" border="0" src="<%= dir_img %>fechar.gif" width="16" height="16"></a>&nbsp;</td>
		</tr>
		</table>
		<div id="res_div_<%= ident %>" style="height: 122px; width: 100%; overflow-Y: scroll;overflow-x:hidden;">
		<table cellpadding="2" cellspacing="0" border="0" width="100%" bgcolor="#ffffff" class="preto11">
		<%
		tit = split(titulos,"|")
		link = split(paginas,"|")
		cor = "EFEFEF"
		for itit = 0 to ubound(tit) %>
			<tr bgcolor="#<%= cor %>">
				<td><a href="javascript: exibe_rel_dotnet(<%= itit %>)" class="preto11"><%= tit(itit) %></a></td>
			</tr>
			<%
			if cor = "EFEFEF" then
				cor = "FFFFFF"
			else
				cor = "EFEFEF"
			end if
		next
		%>
		</table>
		</div>
		</div>
		<script>
		function exibe_rel_dotnet(indice){
			switch (indice){
			<% for itit = 0 to ubound(tit) %>
				case <%= itit %>:
					document.frm_rel_dotnet.action = '<%= link(itit) %>';
					break;
			<% next %>
			}
			document.frm_rel_dotnet.submit();
		}
		</script>
		<%
	End Sub
end class
%>
