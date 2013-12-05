<%
Function fnComparaData(data1, data2)

	Dim stpData1
	Dim dia1
	Dim mes1
	Dim ano1
	Dim data_valida1
	Dim stpData2
	Dim dia2
	Dim mes2
	Dim ano2
	Dim data_valida2

	if trim(data1) <> "" then
		if isDate(data1) then
			stpData1 = split(data1, "/")
			dia1 = stpData1(0)
			mes1 = stpData1(1)
			ano1 = stpData1(2)
			
			if trim(data2) = "" or not isDate(data2) then				
				data2 = day(date) & "/" & month(date) & "/" & year(date)
			end if
			
			stpData2 = split(data2, "/")
			dia2 = stpData2(0)
			mes2 = stpData2(1)
			ano2 = stpData2(2)
			
			if Len(dia1) = 1 then
			dia1 = "0"&dia1
			end if
			if Len(mes1) = 1 then
			mes1 = "0"&mes1
			end if	
			
			if Len(dia2) = 1 then
			dia2 = "0"&dia2
			end if
			if Len(mes2) = 1 then
			mes2 = "0"&mes2
			end if	
			
			data_valida1 = ano1 & mes1 & dia1 
			data_valida2 = ano2 & mes2 & dia2 
			
			data_valida1 = CLng(data_valida1)
			data_valida2 = CLng(data_valida2)
			
			if data_valida1 > data_valida2 then
				fnComparaData = 1
			elseif data_valida1 < data_valida2 then
				fnComparaData = -1
			else
				fnComparaData = 0
			end if	
			
		end if

	end if

end function
%>
