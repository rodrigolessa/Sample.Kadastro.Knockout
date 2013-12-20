<% lista_pg = "PG-RES" %>
<% paginacao = true %>
<!--#include file="../include/funcoes.asp"-->
<!--#include file="../include/conn.asp"-->
<!--#include file="../include/conn_webseek.asp"-->
<!--#include file="../usuario_logado.asp"-->

<%


set rs1 = conn.execute("SELECT DISTINCT Envolvidos.id, Envolvidos.apelido FROM Rel_Env_Tipo LEFT OUTER JOIN "&_
" Envolvidos ON Rel_Env_Tipo.id_env = Envolvidos.id WHERE (Envolvidos.usuario = '"&session("vinculado")&"') AND "&_
" Rel_Env_Tipo.id_tipo_env = '"&tplic(0,request.querystring("tipo"))&"' ORDER BY Envolvidos.apelido")%>

<script>
  loc = new Array(<%=rs1.recordcount%>)
  for (i=0; i < <%=rs1.recordcount%>; i++) {
         loc[i] = new Array(2)
                 for (j=0; j < 2; j++) {
             loc[i][j] = "0"
           }
   }
   <% j = 0
     do while not rs1.eof%>
      loc[<%=j%>][0] = "<%=trim(rs1("id"))%>"; //mude o campo
      loc[<%=j%>][1] = "<%=trim(rs1("apelido"))%>"; //mude o campo
      <%
      rs1.movenext
      j  = j  + 1
     Loop
   rs1.close
  set rs1 = nothing
   'dbConn.close
   set dbConn = nothing%>
   parent.inicia();
</script>
