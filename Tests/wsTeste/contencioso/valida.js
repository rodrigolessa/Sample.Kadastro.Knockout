/************************************************/
/* VALIDA.JS									*/
/* Funcoes genericas para validacao de campos	*/
/************************************************/
function AchaCaracter(s,c){
	if (s.indexOf(c) == -1)
		return false;
	else
		return true;
}

function TrocaCaracter(s,c1, c2){
	
	var i;
	var returnString="";
	
	for (i = 0; i < s.length; i++) {		
		var cPOS = s.charAt(i);
		if (cPOS==c1)
			cPOS = c2;
		returnString += cPOS;		
	}
	
	return returnString;
}

function ValidaCPF(s)
{
 var i;
 var c;
 x = 0;
 soma = 0;
 dig1 = 0;
 dig2 = 0;
 texto = "";
 numcpf1="";
 numcpf = "";

 for (i = 0; i < s.length; i++) {
 	 c = s.substring(i,i+1);
	 if (isdigit(c))
	 	numcpf = numcpf + c;
 }
	 	
 if (numcpf.length != 11) {
 	return false;
 }
	
 len = numcpf.length; x = len -1;
 for (var i=0; i <= len - 3; i++) {
  y = numcpf.substring(i,i+1);
  soma = soma + ( y * x);
  x = x - 1;
  texto = texto + y;
 }
 dig1 = 11 - (soma % 11);
 if (dig1 == 10) dig1=0 ;
 if (dig1 == 11) dig1=0 ;
 numcpf1 = numcpf.substring(0,len - 2) + dig1 ;
 x = 11; soma=0;
 for (var i=0; i <= len - 2; i++) {
  soma = soma + (numcpf1.substring(i,i+1) * x);
  x = x - 1;
 }
 dig2= 11 - (soma % 11);
 if (dig2 == 10) dig2=0;
 if (dig2 == 11) dig2=0;
  if ((dig1 + "" + dig2) == numcpf.substring(len,len-2)) {
  return true;
 }
 return false;
}

function SoNumeros(s)
{
 for (var i=0;i<s.length;i++) { 
 	  c = s.substring(i,i+1); 
	  if (!isdigit(c)) 
	  	  return false;	  
 }
 return true;
}

function SoNumerosLetras(s)
{
 for (var i=0;i<s.length;i++) { 
 	  c = s.substring(i,i+1); 
	  if (!isdigit(c) && !isalpha(c)) 
	  	  return false;	  
 }
 return true;
}

function ValidaValor(s, prec)
{
 if (s.length - s.lastIndexOf(",") != (prec + 1)) 
 	 return false;
 return true;
}

function ValidaData(s)
{
 var i;
 var c;
 var n_barras;
 var data;
 
 n_barras = 0;						  
 if (s.length != 10)
 	 return false; 
 for(i=0; i<s.length; i++) {
   c = s.substring(i,i+1);
   if (c == "/") 
		n_barras++;
   if (n_barras > 2)  
		return false;	 		  
 }
 if (n_barras != 2)  
 	 return false;
 
 if ( (s.indexOf("/") != 2) || (s.lastIndexOf("/") != 5) )  
 	 return false;
	 
 d = s.substring(0, 2)// dia
 m = s.substring(3, 5)// mes
 a = s.substring(6, 10)// ano
 if (m<1 || m>12) 
   return false;
 if (d<1 || d>31) 
 	return false;

 if (a<1900 || a>2050) 
 	return false;
 
 if(isNaN(a))
     {	
	return false;
	}   

 if (m==4 || m==6 || m==9 || m==11) {
   if (d==31) 
   	  return false;
 }
/* Bissexto
 if (m==2){
 var g=parseInt(a/4)
 if (isNaN(g)) {
   err=1
 if (d>29) err=1
 if (d==29 && ((f/4)!=parseInt(f/4))) err=1
 }
 }
*/
 return true;
}

function ValidaCEP(s)
{
 var i;
 var c;
 var achou;
 
 if (s.length != 9) 
 	 return false;
 achou = false;
 for (i=0; i<s.length; i++) {
 	 c = s.substring(i,i+1); 
     if ( !isdigit(c) && (c != '-') ) 					
	  	  return false;
     if (c == '-') {
	   if (!achou) achou = true;
	   else 
			  return false;
	 }  	 	
 }
 if (s.indexOf("-")!=5) 
 	 return false;
 return true;
}

function ValidaFone(s)
{
 var i;
 var c;
 var achou;
 
 achou = false;
 for (i=0; i<s.length; i++) {
 	 c = s.substring(i,i+1); 
     if ( !isdigit(c) && (c != '-') ) 
	  	  return false;
     if (c == '-') {
	   if (!achou) 
			achou = true;
	   else 
			  return false;
	 }  	 	
 }
 return true;
}

function ValidaTexto(s) // Critica se ha caracteres estranhos
{
 var i;   									  
 var c;
 
 for (i=0;i<s.length;i++) {	
	c = s.substring(i,i+1); 
	if (!( isalpha(c) ||	
	       isdigit(c) ||
		   ispunct(c) ) )  
		return false;
 }						
 return true;
}

function ValidaTextoAcentuado(s) // Critica se ha caracteres estranhos
{
 var i;   									  
 var c;
 
 for (i=0;i<s.length;i++) {	
	c = s.charAt(i); 
	if (!( isalphaacentuada(c) ||	
	       isdigit(c) ||
		   ispunct(c) ) )  
		return false;
 }						
 return true;
}
function SubstituiAcentos(s) // Substiui caracteres acetuados
{
 var i;   									  
 var c;
 var Palavra = "";

 for (i=0;i<s.length;i++) 
 {	
	c = s.charAt(i); 

 	if ((c == "б") || (c == "а") || (c == "г") || (c == "в") || 
 		(c == "Б") || (c == "А") || (c == "Г") || (c == "В"))
	{
		c = "A"
	}
	if ((c == "й") || (c == "и") || (c == "к") || 
	 	(c == "Й") || (c == "И") || (c == "К"))
	{
		c = "E"
	}
	if ((c == "н") || (c == "м") || (c == "о") || 
	 	(c == "Н") || (c == "М") || (c == "О"))
	{
		c = "I"
	}
	if ((c == "у") || (c == "т") || (c == "х") || (c == "ф") || 
 		(c == "У") || (c == "Т") || (c == "Х") || (c == "Ф"))
	{
		c = "O"
	}
	if ((c == "ъ") || (c == "щ") || (c == "ы") || (c == "ь") ||
	 	(c == "Ъ") || (c == "Щ") || (c == "Ы") || (c == "Ь"))
	{
		c = "U"
	}
	if ((c == "з") || (c == "З"))
	{
		c = "C"
	}

	Palavra = Palavra + c.toUpperCase();
 }						
 return Palavra;
}

function ValidaEmail(email) {
        var achou_ponto=false;
        var achou_arroba=false;
        var achou_caracter=false;

        for (var i=0; i<email.length; i++) {
                if (email.charAt(i)=="@")
                { 
                  if (email.charAt(i+1)==".")
                  	achou_arroba=false;
                  else
                    achou_arroba=true;
                }
                else if (email.charAt(i)==".") achou_ponto=true;
                else if (email.charAt(i)!=" ") achou_caracter=true;
        }

        if((email.charAt(0)=="W" || email.charAt(0)=="w") &&
           (email.charAt(1)=="W" || email.charAt(1)=="w") &&
           (email.charAt(2)=="W" || email.charAt(2)=="w") &&
           (email.charAt(3)=="."))
        {
            achou_ponto=false;
            achou_caracter=false;
        }
        if(email.charAt(email.length-1)==".")
        {
            achou_ponto=false;
        }	
        return (achou_ponto && achou_arroba && achou_caracter);
}

function y2k(number) { return (number < 1000) ? number + 1900 : number; }

function isDate (day,month,year) {
// checa se a data passada para a funзгo й vбlida.
// aceita datas nos seguintes formatos:
// isDate(dd,mm,yyyy), ou
// isDate(dd,mm) - assume o ano atual, ou
// isDate(dd) - assume o ano mes a ano atuais.


var today = new Date();
year = ((!year) ? y2k(today.getYear()):year);
month = ((!month) ? today.getMonth():month-1);
if (!day) return false
var test = new Date(year,month,day);
if ( (y2k(test.getYear()) == year) &&
(month == test.getMonth()) &&
(day == test.getDate()) )
return true;
else
return false
}

	function getPosicaoElemento(elemID){
	    var offsetTrail = document.getElementById(elemID);
	    var offsetLeft = 0;
	    var offsetTop = 0;
	    while (offsetTrail) {
	        offsetLeft += offsetTrail.offsetLeft;
	        offsetTop += offsetTrail.offsetTop;
	        offsetTrail = offsetTrail.offsetParent;
	    }
	    if (navigator.userAgent.indexOf("Mac") != -1 && 
	        typeof document.body.leftMargin != "undefined") {
	        offsetLeft += document.body.leftMargin;
	        offsetTop += document.body.topMargin;
	    }
	    return {left:offsetLeft, top:offsetTop};
	}


	vDisableHide = 0;

	// distancia do layer p/o cursor
	var vSpaceLayerCursor = 10;

	//mostra o layer na posiзгo correta
	function showMe(theLayer, obj) {
		document.getElementById(theLayer).style.top = getPosicaoElemento(obj).top + 30;
		document.getElementById(theLayer).style.left = getPosicaoElemento(obj).left;
		document.getElementById(theLayer).style.visibility = 'visible';
	}
	
	//esconde o layer e retorna todos os seus valores aos iniciais
	function hideMe(theLayer) {
		if(vDisableHide == 0) {
			document.getElementById(theLayer).style.visibility = 'hidden';
			vSpaceLayerCursor = 10;
			document.getElementById(theLayer).style.overflow = '';
		}
		vDisableHide = 0;
	}
	
	function DisableHide() {
		vDisableHide = 1;
	}
	
	function EnableHide(theLayer) {
		vDisableHide = 0;
		hideMe(theLayer);
	}