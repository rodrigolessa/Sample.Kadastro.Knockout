<%
if request.querystring("logout") = 1 then
session("titular") = ""
session("vinculado") = ""
session("codigo") = ""
session("nomeusu") = ""
session("email") = ""
session("codauto") = ""
Session("status") = ""
Session("empresa") = ""
Session("contrato") = ""
%>
<script>
window.close();
</script>
<%
response.end
end if
%>
