<%
	MEM_CARTA_db = rst("carta")

	var_processo = "sim"
	var_cliente = "sim"

'-------------------------MESCLAGEM------------------------------------
%><!--#include file="mem_carta.asp"--><%
'----------------------------------------------------------------------

str_arquivo = campo&session("vinculado")&id_processo&"0.rtf"

a = cria_arquivo(str_arquivo,mem_carta)

Function cria_arquivo(arquivo,mem_cartax)
	arquivo = server.mappath("cartas")&"\"&arquivo

	Const forReading = 1, forWriting = 2, forAppending = 8
	Const TriDef = -2, TriTrue = -1, TriFalse = 0
  Dim fso, msg, f
  
  Set fso = CreateObject("Scripting.FileSystemObject")              
  If not fso.FileExists(arquivo) then
  	Set ObjArquivo = fso.CreateTextFile(arquivo, True)  	
  	ObjArquivo.close 
		Set ObjArquivo = nothing  
  End if
  Set ObjArquivo = fso.GetFile(arquivo)
  Set objStream = ObjArquivo.OpenAsTextStream(forWriting,TriDef) 
  ObjStream.WriteLine mem_cartax		
	ObjStream.close 
	Set ObjStream = nothing
End Function

%>
<center>
<title>APOL Jurídico - Arquivo gerado</title>
<script language="JavaScript1.2">
<!--
var win=null;
function NewWindow(mypage,myname,w,h,scroll,pos){
if(pos=="random"){LeftPosition=(screen.width)?Math.floor(Math.random()*(screen.width-w)):100;TopPosition=(screen.height)?Math.floor(Math.random()*((screen.height-h)-75)):100;}
if(pos=="center"){LeftPosition=(screen.width)?(screen.width-w)/2:100;TopPosition=(screen.height)?(screen.height-h)/2:100;}
else if((pos!="center" && pos!="random") || pos==null){LeftPosition=0;TopPosition=20}
settings='width='+w+',height='+h+',top='+TopPosition+',left='+LeftPosition+',scrollbars='+scroll+',location=no,directories=no,status=yes,menubar=no,toolbar=yes,resizable=yes';
win=window.open(mypage,myname,settings);
window.close();
}
// -->
</script>
<body bgcolor="#EFEFEF">
<table  width="70%" class=preto11 border="0" cellspacing="2" cellpadding="3">
		<tr class="preto11">
			<td align=center>
			<b><font color=red>Carta gerada com sucesso.			
			<br><br>
		<a class="preto11" onclick="NewWindow(this.href,'mywin','450','450','yes','center');return false;" onfocus="this.blur()" href="cartas/<%=campo&session("vinculado")&request.querystring("id_processo")&"0.rtf"%>">Visualizar arquivo</a></font></b>
		</tr>
</table>

