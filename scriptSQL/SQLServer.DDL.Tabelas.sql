USE [kadastro]
GO

CREATE TABLE [dbo].[ponto](
	[id] [int] NOT NULL,
	[dia] [smalldatetime] NOT NULL,
	[horas] [time](7) NULL,
 CONSTRAINT [PK_ponto] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[intervalo](
	[id] [bigint] NOT NULL,
	[idPonto] [int] NOT NULL,
	[entrada] [time](7) NULL,
	[saida] [time](7) NULL,
 CONSTRAINT [PK_intervalo] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[intervalo]  WITH NOCHECK ADD  CONSTRAINT [FK_intervalo_ponto] FOREIGN KEY([idPonto])
REFERENCES [dbo].[ponto] ([id])
GO

ALTER TABLE [dbo].[intervalo] CHECK CONSTRAINT [FK_intervalo_ponto]
GO