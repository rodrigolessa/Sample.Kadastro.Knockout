USE [kadastro]
GO

/*	Trecho de Rollback do script:

DROP TABLE [kadastro].[dbo].[Intervalo];
GO
DROP TABLE [kadastro].[dbo].[Ponto];
GO
DROP TABLE [kadastro].[dbo].[Usuario];
GO

SELECT * FROM [dbo].[Usuario];
SELECT * FROM [dbo].[Ponto];
SELECT * FROM [dbo].[Intervalo];

*/

CREATE TABLE [dbo].[Usuario](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Login] [varchar](50) NOT NULL,
	[Senha] [varchar](50) NOT NULL,
	[Email] [varchar](100) NULL,
	[Status] [char](1) NULL
)
GO

CREATE TABLE [dbo].[Ponto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[Dia] [smalldatetime] NOT NULL,
	[Horas] [time](7) NULL
)
GO

CREATE TABLE [dbo].[Intervalo](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[IdPonto] [int] NOT NULL,
	[Entrada] [time](7) NULL,
	[Saida] [time](7) NULL
)
GO

ALTER TABLE [dbo].[Usuario] ADD CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED ([Id] ASC)
GO

ALTER TABLE [dbo].[Ponto] ADD CONSTRAINT [PK_Ponto] PRIMARY KEY CLUSTERED ([Id] ASC)
GO

ALTER TABLE [dbo].[Ponto] ADD CONSTRAINT [FK_Ponto_Usuario] FOREIGN KEY([IdUsuario]) REFERENCES [dbo].[Usuario] ([Id])
GO

ALTER TABLE [dbo].[Intervalo] ADD CONSTRAINT [PK_Intervalo] PRIMARY KEY CLUSTERED ([Id] ASC)
GO

ALTER TABLE [dbo].[Intervalo]  WITH NOCHECK ADD  CONSTRAINT [FK_Intervalo_Ponto] FOREIGN KEY([IdPonto]) REFERENCES [dbo].[Ponto] ([Id])
GO

ALTER TABLE [dbo].[Intervalo] CHECK CONSTRAINT [FK_Intervalo_Ponto]
GO