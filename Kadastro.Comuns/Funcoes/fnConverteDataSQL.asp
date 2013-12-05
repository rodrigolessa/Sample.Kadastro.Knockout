<%
'***********************************************
'Coloca uma determinada data no formato para SQL Server: 
'ANO-MES-DIA
'Entrada esperada em string: dd/mm/aaaa'
'***********************************************
Function fnConverteDataSQL(prmData)

    Dim arrDSQLData, dSQLDia, dSQLMes, dSQLAno

    prmData = Trim(cStr(prmData))

    if Len(prmData) > 0 and isDate(prmData) then

        arrDSQLData = split(prmData,"/")

        'response.write "UBound(arrDSQLData): " & UBound(arrDSQLData) & "<br />"

        if UBound(arrDSQLData) = 2 then

            dSQLDia = arrDSQLData(0)
            dSQLMes = arrDSQLData(1)
            dSQLAno = arrDSQLData(2)

            if Len(dSQLDia) = 1 then
                dSQLDia = "0" & dSQLDia
            elseif Len(dSQLMes) = 1 then
                dSQLMes = "0" & dSQLMes
            end if

            fnConverteDataSQL = dSQLAno & "-" & dSQLMes & "-" & dSQLDia

        else

            fnConverteDataSQL = ""

        end if

    else

        fnConverteDataSQL = ""

    end if

End Function
%>