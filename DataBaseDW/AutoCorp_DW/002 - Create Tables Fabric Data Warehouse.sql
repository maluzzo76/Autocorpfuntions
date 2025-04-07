CREATE TABLE [Fresh].[whs].[Tickets]
(
	[Codigo] [varchar](100)  NULL,
	[Fecha_Alta] [datetime]  NULL,
	[Fecha_Modificacion] [datetime]  NULL,	
    [Fecha_Primer_Respuesta] [datetime]  NULL,
	[Minutos_Diferencia] [int]  NULL,
    [Minutos_Diferencia_Primer_Respuesta] [decimal](18,4)  NULL,
    [SlaResolucion] [decimal](18,4)  NULL,
	[SlaRespuesta] [decimal](18,4)  NULL,
    [Porcentaje_Eficiencia_Resolucion] [decimal](18,4)  NULL,
	[Porcentaje_Eficiencia_Respuesta] [decimal](18,4)  NULL,
	[companiaId] [int]  NULL,
	[estadoId] [int]  NULL,
	[tipoId] [int]  NULL,
	[productoId] [int]  NULL,
	[grupoId] [int]  NULL,
	[origenId] [int]  NULL,
	[prioridadId] [int]  NULL,
	[agenteId] [int]  NULL,
	[slaId] [int]  NULL	
)
GO;

CREATE TABLE [Fresh].[whs].[Agentes]
(
	[id] [int]  NULL,
	[codigo] [varchar](200)  NULL,
	[nombre] [varchar](200)  NULL
)
GO

CREATE TABLE [Fresh].[whs].[Companias]
(
	[id] [int]  NULL,
	[codigo] [varchar](200)  NULL,
	[nombre] [varchar](200)  NULL
)
GO

CREATE TABLE [Fresh].[whs].[Estados]
(
	[id] [int]  NULL,
	[codigo] [varchar](200)  NULL,
	[nombre] [varchar](200)  NULL
)
GO

CREATE TABLE [Fresh].[whs].[Grupos]
(
	[id] [int]  NULL,
	[codigo] [varchar](200)  NULL,
	[nombre] [varchar](200)  NULL
)
GO

CREATE TABLE [Fresh].[whs].[Origenes]
(
	[id] [int]  NULL,
	[codigo] [varchar](200)  NULL,
	[nombre] [varchar](200)  NULL
)
GO

CREATE TABLE [Fresh].[whs].[Prioridades]
(
	[id] [int]  NULL,
	[codigo] [varchar](200)  NULL,
	[nombre] [varchar](200)  NULL
)
GO

CREATE TABLE [Fresh].[whs].[Productos]
(
	[id] [int]  NULL,
	[codigo] [varchar](200)  NULL,
	[nombre] [varchar](200)  NULL
)
GO

CREATE TABLE [Fresh].[whs].[Tipos]
(
	[id] [int]  NULL,
	[codigo] [varchar](200)  NULL,
	[nombre] [varchar](200)  NULL
)
GO

CREATE TABLE [Fresh].[whs].[Sla]
(
	[id] [int]  NULL,
	[codigo] [varchar](100)  NULL,
	[nombre] [varchar](255)  NULL,
	[descipcion] [varchar](500)  NULL,
	[isactive] [bit]  NULL,
	[isdefault] [bit]  NULL,
	[posicion] [int]  NULL,
	[fechaAlta] [varchar](100)  NULL,
	[fechaModificacion] [varchar](100)  NULL,
	[companyid] [varchar](100)  NULL,
	[slaTargetPriority1RespondWithin] [decimal](18,4)  NULL,
	[slaTargerPriority1ResolveWithin] [decimal](18,4)  NULL,
	[slaTargetPriority2RespondWithin] [decimal](18,4)  NULL,
	[slaTargerPriority2ResolveWithin] [decimal](18,4)  NULL,
	[slaTargetPriority3RespondWithin] [decimal](18,4)  NULL,
	[slaTargerPriority3ResolveWithin] [decimal](18,4)  NULL,
	[slaTargetPriority4RespondWithin] [decimal](18,4)  NULL,
	[slaTargerPriority4ResolveWithin] [decimal](18,4)  NULL,
	[escalationReminderResolutionEscalationTime] [decimal](18,4)  NULL,
	[escalationReminderResolutionAgentids] [varchar](100)  NULL,
	[escalationResolutionLevel1EscalationTime] [decimal](18,4)  NULL,
	[escalationResolutionLevel1AgentId] [varchar](100)  NULL
)
GO

--------------------------------------------------------

create TABLE stg.factPrecioHistoricoVehiculo
(
   codigo INT,
   vehiculoId int,
   codigoInfoAuto INT,
   precioInfoAuto decimal (18,4),
   fechaInfoAuto DATETIME
)

--------------------------------------------------------
create TABLE whs.factPrecioHistoricoVehiculo
(
   codigo INT,
   vehiculoId int,
   codigoInfoAuto INT,
   precioInfoAuto decimal (18,4),
   fechaInfoAuto DATETIME
)