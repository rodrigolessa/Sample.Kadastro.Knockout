<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%if request("x") = "3" then%>
	<script language="javascript">
		function abrirjanela_redirect(url, width,  height){
			varwin=window.open(url,'openscript5','width='+width+',height='+height+',resizable=0,scrollbars=yes,status=yes');
		}
	</script>
	<%
	vid_processo = request("id_processo")
	processo = request("processo")
	select case request("janela") 
			case "outraparte"
				%><script>abrirjanela_redirect('cliente_vinc.asp?id_proc=<%=vid_processo%>&modulo=C&tipo=outraparte',530,80)</script><%
			case "cliente"
				%><script>abrirjanela_redirect('cliente_vinc.asp?id_proc=<%=vid_processo%>&modulo=C&tipo=cliente',530,80)</script><%
'			case "vinculados"
'				%><script>//abrirjanela_redirect('processo_vinculo.asp?fprocesso1_n=<%'=vid_processo%>',700,140)</script><%
			case "ocorrencia"
				%><script>abrirjanela_redirect('../cad_ocorrencia.asp?modulo=C&id=<%=vid_processo%>&id_proc=<%= processo %>',560,160)</script><%	
			case "providencia"
				%><script>window.location = '../cria_providencia.asp?onde=detproc&id_processo=<%=id_processo%>&id_proc=<%=processo%>&modulo=C'</script><%
		end select
end if%><!--#include file="processo.asp"-->