<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>
<script>
function SaltaCampo1 (campo,prox,tammax,teclapres){
	var tecla = teclapres.keyCode;
	vr = document.form1[campo].value;
	if( tecla == 109 || tecla == 188 || tecla == 110 || tecla == 111 || 
		tecla == 223 || tecla == 108 ){
		document.form1[campo].value = vr.substr( 0, vr.length - 1 ); }
	else{
	 	vr = vr.replace( "-", "" );
	 	vr = vr.replace( "/", "" );
	 	vr = vr.replace( "/", "" );
	 	vr = vr.replace( ",", "" );
	 	vr = vr.replace( ".", "" );
	 	vr = vr.replace( ".", "" );
	 	vr = vr.replace( ".", "" );
	 	vr = vr.replace( ".", "" );
	 	tam = vr.length;	
	 	if (tecla != 0 && tecla != 9 && tecla != 16 )
			if ( tam == tammax )	
				document.form1[prox].focus();
		}
}

function CompletaCampo (campo,tammax)
{
	vr = document.form1[campo].value;
	tam = vr.length;
	if (tam < tammax && tam != 0)
	{zeros = tammax - tam
	 for (i = 0; i < zeros; i++) 
	 {
		vr = "0" + vr;
	 }
	document.form1[campo].value = vr;	
	}
}
</script>
00001 2000 001 05 00 1
<form action="http://www.trt05.gov.br/trt5new/programas/processos/consultaprocesso/conpro.asp?tipo=unica" name="form1" method="get">
  <h4><b>Digite o número do processo: </b><input type="text" onKeyup='SaltaCampo1(0,1,5,event)' onBlur='CompletaCampo(0,5)' name="p_seq_proc" size="5"
  maxLength="5" minLength="5" tabindex="1"></font><font color="#008080"><font color="#FFFFFF"> <input type="text" onKeyup='SaltaCampo1(1,2,4,event)' name="p_ano_proc" size="4"
  maxLength="4" minLength="4" tabindex="2"> <input type="text" onKeyup='SaltaCampo1(2,3,3,event)' onBlur='CompletaCampo(2,3)' name="p_cod_vara" size="3"
  maxLength="3" minLength="3" tabindex="3"> <input type="text" onKeyup='SaltaCampo1(3,4,2,event)' onBlur='CompletaCampo(3,2)' onFocus='this.value="05"'name="p_regiao" size="2"
  maxLength="4" minLength="4" tabindex="4"> <input type="text" onKeyup='SaltaCampo1(4,5,2,event)' onBlur='CompletaCampo(4,2)' name="p_seq_apart" size="2"
  maxLength="2" minLength="2" tabindex="5">-<input type="text" onKeyup='SaltaCampo1(5,6,1,event)' name="p_dig_verif" size="1"
  maxLength="1" minLength="1" tabindex="6"> <input name="Pesquisar" type="Submit" value="Pesquisar" ></h4>
</form>
http://www.trt05.gov.br/trt5new/programas/processos/consultaprocesso/conpro.asp?p_seq_proc=00001&p_ano_proc=2000&p_cod_vara=001&p_regiao=05&p_seq_apart=00&p_dig_verif=1&Pesquisar=Pesquisar
</body>
</html>
