<%

function fnValidaDataHora(strDatHor)

	DIM vDHRetorno
	DIM arrayDataHora
	DIM arrayData
	DIM arrayHora
	DIM strData
	DIM strHora
	Dim vdhDia, vdhMes, vdhAno

	if len(strDatHor) < 10 then
	
		vDHRetorno		= false
		
	else

		vDHRetorno		= true
		
		arrayDataHora	= split(strDatHor, " ")

		if ubound(arrayDataHora) <> 1 then
		
			'=========================================
			'VÁLIDA SOMENTE A DATA PASSADA
			'=========================================
			strData		= arrayDataHora(0)

			arrayData	= split(strData, "/")

			if ubound(arrayData) <> 2 then
			
				vDHRetorno = false
				
			else
		
				vdhDia	= arrayData(0)
				vdhMes	= arrayData(1)
				vdhAno	= arrayData(2)
				
				if not isNumeric(vdhDia) then
					vDHRetorno = false
				elseif not isNumeric(vdhMes) then
					vDHRetorno = false
				elseif not isNumeric(vdhAno) then
					vDHRetorno = false
				end if
				
				if vDHRetorno = true then

					vdhDia	= cint(vdhDia)
					vdhMes	= cint(vdhMes)
					vdhAno	= cint(vdhAno)

					if not (vdhMes > 0 and vdhMes < 13) then
						vDHRetorno = false
					elseif vdhDia < 1 then
						vDHRetorno = false
					elseif vdhMes = 2 and ((vdhDia > 28 and (vdhAno mod 4) <> 0) or (vdhDia > 29 and (vdhAno mod 4) = 0)) then
						vDHRetorno = false
					elseif (vdhMes = 4 or vdhMes = 6 or vdhMes = 9 or vdhMes = 11) and vdhDia > 30 then
						vDHRetorno = false
					elseif vdhDia > 31 then
						vDHRetorno = false
					elseif vdhAno > 2072 then
						vDHRetorno = false
					end if

				end if
				
			end if
			
		else
		
			'=========================================
			'VÁLIDA A DATA E A HORA INFORMADA
			'=========================================
			strData		= arrayDataHora(0)
			strHora		= arrayDataHora(1)

			arrayData	= split(strData, "/")

			if ubound(arrayData) <> 2 then
			
				vDHRetorno = false
				
			else
			
				vdhDia	= arrayData(0)
				vdhMes	= arrayData(1)
				vdhAno	= arrayData(2)

				if not isNumeric(vdhDia) then
					vDHRetorno = false
				elseif not isNumeric(vdhMes) then
					vDHRetorno = false
				elseif not isNumeric(vdhAno) then
					vDHRetorno = false
				end if

				if vDHRetorno = true then

					vdhDia	= cint(vdhDia)
					vdhMes	= cint(vdhMes)
					vdhAno	= cint(vdhAno)

					if not (vdhMes > 0 and vdhMes < 13) then
						vDHRetorno = false
					elseif vdhDia < 1 then
						vDHRetorno = false
					elseif vdhMes = 2 and ((vdhDia > 28 and (vdhAno mod 4) <> 0) or (vdhDia > 29 and (vdhAno mod 4) = 0)) then
						vDHRetorno = false
					elseif (vdhMes = 4 or vdhMes = 6 or vdhMes = 9 or vdhMes = 11) and vdhDia > 30 then
						vDHRetorno = false
					elseif vdhDia > 31 then
						vDHRetorno = false
					elseif vdhAno > 2072 then
						vDHRetorno = false
					end if

				end if

				if vDHRetorno = true then

					arrayHora = split(strHora, ":")

					if ubound(arrayHora) <> 2 then
					
						vDHRetorno = false
						
					else
					
						hora	= arrayHora(0)
						minuto	= arrayHora(1)
						segundo	= arrayHora(2)

						if not isNumeric(hora) then
							vDHRetorno = false
						elseif not isNumeric(minuto) then
							vDHRetorno = false
						elseif not isNumeric(segundo) then
							vDHRetorno = false
						end if

						if vDHRetorno = true then

							hora	= cint(hora)
							minuto	= cint(minuto)
							segundo	= cint(segundo)

							if not (hora >= 0 and hora < 24) then
								vDHRetorno = false
							elseif not (minuto >= 0 and minuto < 60) then
								vDHRetorno = false
							elseif not (segundo >=0 and segundo < 60) then
								vDHRetorno = false
							end if

						end if
						
					end if
					
				end if
				
			end if
			
		end if

	end if

	fnValidaDataHora = vDHRetorno

end function

%>