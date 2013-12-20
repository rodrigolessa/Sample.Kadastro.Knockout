<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<link rel="STYLESHEET" type="text/css" href="style.css"> 
<link rel="STYLESHEET" type="text/css" href="style2.css">
<%
function subst(texto)

    if (texto <> "") then
		'texto = replace(texto,chr(39), chr(39)&chr(39),1,-1,1)
		'texto = replace(texto,chr(34), chr(34)&chr(34),1,-1,1)
		for i=0 to 8
			texto = replace(texto,chr(i), "",1,-1,1)
		next
		for i=14 to 31
			texto = replace(texto,chr(i), "",1,-1,1)
		next
		'for i=127 to 191
		'	texto = replace(texto,chr(i), "",1,-1,1)
		'next
		
		if isnumeric(texto) then
			texto = replace(texto,",", ".",1,-1,1)
		end if
	end if 
	
	subst = texto
end function

Dim str_arq

call le_arquivo(server.mappath("rtf_cli")&"\"&request("file"))

int_pos_ini = 1
int_cont 		= 0

'campo = ""
'if request("origem") = "CB" then	
'	campo = "cobranca"		
'	campo1 = "arq_cobranca"	
'elseif request("origem") = "CM" then	
'	campo = "comunicacao"
'	campo1 = "arq_comunicacao"	
'end if

campo = "comunicacao"
campo1 = "arq_comunicacao"	
	
'response.write request.querystring("origem")
'response.write "UPDATE Parametros SET "&campo&" = '"&str_arq&"' , "&campo1&" = '"&request("file")&"' WHERE  usuario = '"&session("vinculado")&"'"
'response.end

db.execute("UPDATE Parametros SET "&tplic(1,campo)&" = '"&tplic(0,str_arq)&"' , "&tplic(1,campo1)&" = '"&tplic(0,request("file"))&"' WHERE  usuario = '"&session("vinculado")&"'")

'---------------------------------------------------------------
Function le_arquivo(filespec)
'---------------------------------------------------------------
'Lê arquivo texto e armazena conteúdo na variável str_arq
'---------------------------------------------------------------
  Dim fso, msg, f
  Set fso = CreateObject("Scripting.FileSystemObject")  
  If (fso.FileExists(filespec)) Then
    msg = "true"    
    Const ForReading = 1, ForWriting = 2    
    Set f = fso.OpenTextFile(filespec, ForReading)
    str_arq = replace(subst(f.ReadAll),"'","<<aspas>>")
  Else
    response.write "O arquivo de "&filespec& " não existe."
  End If  
End Function
%>


<div id="exclui" style="position: absolute; top: 1px; width: 770px; left: 1px; height: 598px; visibility: hidden;">
<br>
<table width="100%" height="100%">
<tr valign="middle">
	<td align="center">
<table width="300" bgcolor="#FFFFFF" style="border: 1px solid Black;" class="preto12">
<tr>
	<td>
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<tr>
		<td height="16" valign="middle">&nbsp;<img src="imagem/tit_le.gif" width="19" height="18">&nbsp;</td>
		<td height="16" valign="middle" class="titulo">&nbsp;Vinculação&nbspde&nbsp;Carta.</td>
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
	<td align="center"><img src="imagem/balao_info.gif"  border="0" align="absmiddle">&nbsp;&nbsp;<b style="color:red;">Carta Vinculada com sucesso.</b></td>
</tr>
<tr>
	<td align="center">&nbsp;</td>
</tr>
<tr>
	<td align="center">
	<table class="linkp12">
	<tr>
		<td background="imagem/botao_limpo.gif" width="82" height="21" align="center"><a href="javascript: fecha_exc()" class="linkp12">&nbsp;&nbsp;&nbsp;Ok&nbsp;&nbsp;&nbsp;</a></td>
		<td>&nbsp;&nbsp;</td>		
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
		window.location = "param.asp"
//		MM_showHideLayers('exclui','','show');
		}
		
function fecha_exc()
		{
//		MM_showHideLayers('exclui','','hide');
		window.location = "param.asp"
		}
		
mostra_exc('s');
</script>
