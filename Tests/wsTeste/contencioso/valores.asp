<!--#include file="db_open.asp"-->
<!--#include file="funcoes.asp"-->
<script language="javascript" src="valida.js"></script>
<script language="JavaScript" src="../include/funcoes.js"></script>

<script language="JavaScript" src="../adm/js/jquery-1.4.4.min.js" type="text/javascript"></script>
<script language="JavaScript" src="../adm/js/jquery-ui-1.8.9.custom.min.js" type="text/javascript"></script>
<script language="JavaScript" src="../adm/js/jquery.ui.datepicker-pt-BR.js" type="text/javascript"></script>
<script language="JavaScript" src="../adm/js/jquery.maskedinput-1.2.2.js" type="text/javascript"></script>
<script>
	var fixo = true;
	var posiX = 35; 
	var posiY = 10;
    //Configurando calendarios 
    jQuery(document).ready(function(){
       jQuery(".data").mask("9?9/99/9999",{placeholder:" "}).datepicker(); 
    });
</script>
<title>APOL Jurídico - Vinculação de Valores</title>
<body leftmargin=0 topmargin=0>
<link rel="STYLESHEET" type="text/css" href="style.css"> 
<link href="../adm/css/jquery-ui-1.10.3.custom.css" type="text/css" rel="stylesheet">

<%
data = ""
valor = ""
moeda = ""
obs_val = ""
referencia = ""
if request("codigo") <> "" then
	sql = "Select * from TabValCont where codigo = "&tplic(1,request("codigo"))	
	set rst = db.execute(sql)

	if not rst.eof then
		data = CDATE(rst("data"))
		valor = rst("valor")
		moeda = rst("moeda")
		if inStr(valor,",") = 0 then valor = valor & ",00"
		referencia = rst("referencia")
		obs_val = rst("obs")
	end if
end if
%>
<table width="100%" class="tabela<%=l_imp%>" border="0" cellspacing="2" cellpadding="3">		
	<form name=frm action=valores_salvar.asp method=post onsubmit="return valida()">	
	<input type=hidden name=tipo_vinc value="">		
	<input type=hidden name=codigo value="<%=request("codigo")%>">		
	<input type=hidden name=vprocesso_c value="<%=request("id")%>">
	<tr class="tit1<%=l_imp%>">
		<td width=15% align=center><b>Dt. Ref. <font size=1></font></td>
		<td width=15%><b>Valor</td>
		<td width=10%><b>Moeda</td>
		<td width=30%><b>Referência</td>
		<td width=35%><b>OBS</td>		
	</tr>
	<tr>			
		<td width=15%><input type=text class="cfrm data" name=vdata_d size=10 maxlength=10 value="<%=fdata(data)%>"></td>
		<td width=15%><input type=text class="cfrm" name=vvalor_n size=11 maxlength=11 onKeyUp="decimal(this);" value="<%=valor%>" style="text-align:right"></td>
		<td width=10%><input type=text class="cfrm" name=vmoeda_c size=4 maxlength=3 value="<%=moeda%>"></td>
		<td width=30%>
		<select class="cfrm" name="vreferencia_c" size="1" style="width:180">
			<option value="">
			<%set rst = db.execute("Select * from Auxiliares where tipo = 'F' and usuario = '"&Session("vinculado")&"' order by descricao")
			do while not rst.eof
				%>
				<option value='<%=rst("codigo")%>' <%if referencia <> "" then%><%if rst("codigo") = int(referencia) then%>selected<%end if%><%end if%>><%=rst("descricao")%>
				<%
				rst.movenext
			loop
			%>
		</select>
		</td>
		<td width=35%><input type=text class="cfrm" name=vobs_c size=27 maxlength=50 value="<%=obs_val%>"></td>
	</tr>		
	<tr>
		<td colspan=5 align=center><input type=submit class="cfrm" name=btval value=Gravar onclick="frm.tipo_vinc.value='val'"></td>
	</tr>
</table>
</form>

<script>
	function decimal(campo){
		var digits="0123456789,"
		var campo_temp 
		for (var i=0;i<campo.value.length;i++){
		  campo_temp=campo.value.substring(i,i+1)	
		  if (digits.indexOf(campo_temp)==-1){
			    campo.value = campo.value.substring(0,i);
			    break;
		   }
		}
	}

	function valida()
	{			
		if (document.frm.tipo_vinc.value == "")
		{
			if (document.frm.fprocesso_c.value == "")
			{
				alert("Preencha o número do Processo.")
				frm.fprocesso_c.focus();
				return false;
			}	

			if (document.frm.fdesc_res_c.value == "")
			{
				alert("Preencha a Descrição Resumida.")
				frm.fdesc_res_c.focus();
				return false;
			}			

			if (document.frm.fsituacao_c.value == "E")
			{
				if (!doDate(document.frm.fdt_encerra_d.value,5))		
				{
					alert("Preencha os campos corretamente.")
					frm.fdt_encerra_d.focus();
					return false;
				}		
			}

			if (document.frm.fdt_encerra_d.value != "")
			{			
				if (!doDate(document.frm.fdt_encerra_d.value,5))		
				{
					alert("Preencha os campos corretamente.")
					frm.fdt_encerra_d.focus();
					return false;
				}		
			}

			if (document.frm.fdistribuicao_d.value != "")
			{			
				if (!doDate(document.frm.fdistribuicao_d.value,5))		
				{
					alert("Preencha os campos corretamente.")
					frm.fdistribuicao_d.focus();
					return false;
				}		
			}
					
		}		
		else
		{
			if (!doDate(document.frm.vdata_d.value,5))		
			{
				alert("Preencha os campos corretamente.")
				frm.vdata_d.focus();
				frm.tipo_vinc.value = "";
				return false;
			}
			
			if (document.frm.vvalor_n.value == "")
			{
				alert("Preencha os campos corretamente.")
				frm.vvalor_n.focus();
				frm.tipo_vinc.value = "";
				return false;
			}		
			else
			{
				if (document.frm.vvalor_n.value.indexOf(",") > 0)
				{
					arrValor = document.frm.vvalor_n.value.split(",")
					if (arrValor[1].length > 2)
					{
						alert("O campo Valor admite apenas 2 casas decimais.");
						document.frm.vvalor_n.value = arrValor[0] + "," + arrValor[1].substr(0,2);
						document.frm.vvalor_n.focus();
						return false;
					}
				}
			}
    	
    	if (document.frm.vmoeda_c.value == "")
			{
				alert("Preencha os campos corretamente.")
				frm.vmoeda_c.focus();
				frm.tipo_vinc.value = "";
				return false;
			}
			
			if (document.frm.vreferencia_c.value == "")
			{
				alert("Preencha os campos corretamente.")
				frm.vreferencia_c.focus();
				frm.tipo_vinc.value = "";
				return false;
			}

		}
		
		return true;
	}		
	
	function abrirjanela(url, width,  height) 
		{
			varwin=window.open(url,"openscript",'width='+width+',height='+height+',resizable=0,scrollbars=yes,status=yes');
		}
</script>