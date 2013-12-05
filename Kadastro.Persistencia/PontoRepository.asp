<!--#include file="../Kadastro.Arquitetura/BancoDeDados.asp"-->
<!--#include file="../Kadastro.Comuns/SQLUtil.asp"-->
<%

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

	Function ObterPonto(prmId)

		sql = "SELECT * FROM [kadastro].[dbo].[ponto] WHERE [id] = @id;"

		sql = Replace(sql, "@id", PrmSQL(prmId, "int"))

		Set ObterPonto = objConn.Execute(sql)

	End Function

	Function ListarPonto(prmDia, prmMes, prmAno)

		sqlWhere = ""

		if Len(prmDia) > 0 then
			sqlWhere = sqlWhere & "AND DAY([dia]) = " & PrmSQL(prmDia, "int") & " "
		end if

		if Len(prmMes) > 0 then
			sqlWhere = sqlWhere & "AND MONTH([dia]) = " & PrmSQL(prmMes, "int") & " "
		end if

		if Len(prmAno) > 0 then
			sqlWhere = sqlWhere & "AND YEAR([dia]) = " & PrmSQL(prmAno, "int") & " "
		end if

		if InStr(sqlWhere, "AND") = 1 then
				sqlWhere = " WHERE " & Mid(sqlWhere, 3)
		end if

		sql = "SELECT * FROM [kadastro].[dbo].[ponto] " & sqlWhere

		Set ListarPonto = objConn.Execute(sql)

	End Function

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

	Function SalvarPonto(prmid, prmdia, prmhoras)

		Dim r_idPonto

		if IsNull(prmid) or Len(prmid) > 0 then

			sql =	"INSERT INTO [kadastro].[dbo].[ponto] ([dia], [horas]) " & _
					" VALUES (@dia, @horas); " & _
					" SET NOCOUNT OFF; " & _
					" SELECT SCOPE_IDENTITY() ID; "

			sql = Replace(sql, "@dia", PrmSQL(prmdia, "smalldatetime"))
			sql = Replace(sql, "@horas", PrmSQL(prmhoras, "time"))

			Set rs = objConn.Execute(sql)

			r_idPonto = rs("ID")

		elseif IsNumeric(prmid) then

			sql = "UPDATE [kadastro].[dbo].[ponto] SET [dia] = @dia, [horas] = @horas WHERE [id] = @id;"

			sql = Replace(sql, "@dia", PrmSQL(prmdia, "smalldatetime"))
			sql = Replace(sql, "@horas", PrmSQL(prmhoras, "time"))
			sql = Replace(sql, "@id", PrmSQL(prmid, "int"))

			objConn.Execute(sql)

			r_idPonto = prmid

		end if

    	SalvarPonto = r_idPonto

	End Function

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

	Function ObterIntervalo(prmId)

		sql = "SELECT * FROM [kadastro].[dbo].[intervalo] WHERE [id] = @id;"

		sql = Replace(sql, "@id", PrmSQL(prmId, "int"))

		Set ObterIntervalo = objConn.Execute(sql)

	End Function

	Function ListarIntervalo(prmIdPonto, prmDia, prmMes, prmAno)

		sqlWhere = ""

		if Len(prmIdPonto) > 0 then
			sqlWhere = sqlWhere & "AND [idPonto] = " & PrmSQL(prmIdPonto, "int") & " "
		end if

		if InStr(sqlWhere, "AND") = 1 then
				sqlWhere = " WHERE " & Mid(sqlWhere, 3)
		end if

		sql = "SELECT * FROM [kadastro].[dbo].[intervalo] " & sqlWhere

		Set ListarIntervalo = objConn.Execute(sql)

	End Function

	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

	Function SalvarIntervalo(prmid, prmidPonto, prmentrada, saida)

		Dim r_idIntervalo

		if IsNull(prmid) or Len(prmid) > 0 then

			sql =	"INSERT INTO [kadastro].[dbo].[intervalo] ([idPonto], [entrada], [saida]) " & _
					" VALUES (@idPonto, @entrada, @saida); " & _
					" SET NOCOUNT OFF; " & _
					" SELECT SCOPE_IDENTITY() ID; "

			sql = Replace(sql, "@idPonto", PrmSQL(prmidPonto, "int"))
			sql = Replace(sql, "@entrada", PrmSQL(prmentrada, "time"))
			sql = Replace(sql, "@saida", PrmSQL(prmsaida, "time"))

			Set rs = objConn.Execute(sql)

			r_idIntervalo = rs("ID")

		elseif IsNumeric(prmid) then

			sql = "UPDATE [kadastro].[dbo].[intervalo] SET [entrada] = @entrada, [saida] = @saida WHERE [id] = @id;"

			sql = Replace(sql, "@id", PrmSQL(prmid, "bigint"))
			sql = Replace(sql, "@entrada", PrmSQL(prmentrada, "time"))
			sql = Replace(sql, "@saida", PrmSQL(prmsaida, "time"))

			r_idIntervalo = prmid

		end if

		SalvarIntervalo = r_idIntervalo

	End Function

%>