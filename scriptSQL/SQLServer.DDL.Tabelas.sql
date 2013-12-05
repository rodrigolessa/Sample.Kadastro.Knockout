USE [kadastro]
GO

CREATE TABLE [dbo].[ponto](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[dia] [smalldatetime] NOT NULL,
	[horas] [time](7) NULL
)
GO

CREATE TABLE [dbo].[intervalo](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[idPonto] [int] NOT NULL,
	[entrada] [time](7) NULL,
	[saida] [time](7) NULL
)
GO

ALTER TABLE [dbo].[ponto] ADD CONSTRAINT [PK_ponto] PRIMARY KEY CLUSTERED ([id] ASC)
GO

ALTER TABLE [dbo].[intervalo] ADD CONSTRAINT [PK_intervalo] PRIMARY KEY CLUSTERED ([id] ASC)
GO

ALTER TABLE [dbo].[intervalo]  WITH NOCHECK ADD  CONSTRAINT [FK_intervalo_ponto] FOREIGN KEY([idPonto]) REFERENCES [dbo].[ponto] ([id])
GO

ALTER TABLE [dbo].[intervalo] CHECK CONSTRAINT [FK_intervalo_ponto]
GO