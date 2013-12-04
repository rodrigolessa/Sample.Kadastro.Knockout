<%

	Function SalvarPonto(prmid, prmdia, prmhoras)

		sql = "INSERT INTO [kadastro].[dbo].[ponto] ([id], [dia], [horas]) VALUES (<id, int,>, <dia, smalldatetime,>, <horas, time(7),>)"
		sql = "UPDATE [kadastro].[dbo].[ponto] SET [dia] = <dia, smalldatetime,> ,[horas] = <horas, time(7),> WHERE [id] = <id, int,>"

	End Function

	Function SalvarIntervalo(prmid, prmidPonto, prmentrada, saida)

		sql = "INSERT INTO [kadastro].[dbo].[intervalo] ([id], [idPonto], [entrada], [saida]) VALUES (<id, bigint,>, <idPonto, int,>, <entrada, time(7),>, <saida, time(7),>)"
		sql = "UPDATE [kadastro].[dbo].[intervalo] SET [entrada] = <entrada, time(7),>, [saida] = <saida, time(7),> WHERE [id] = <id, bigint,>"

	End Function

%>