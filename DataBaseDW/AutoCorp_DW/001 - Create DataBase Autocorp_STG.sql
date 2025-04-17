-----------------------------------------------------------
-- Crea la base de datos Autocorp_DW
-----------------------------------------------------------
CREATE DATABASE Autocorp_dw;

USE Autocorp_stg;

DROP  SCHEMA whs 
DROP  SCHEMA STG 
go;

CREATE SCHEMA stg AUTHORIZATION dbo
go;

CREATE SCHEMA whs AUTHORIZATION dbo
go;

-----------------------------------------------------------
-- Crea las tablas de staiging
-----------------------------------------------------------
drop TABLE stg.Tickets
CREATE TABLE stg.Tickets
(
  codigo int,
  fechaAlta DATETIME,
  fechaModificacion DATETIME,
  horasDiferecia INTEGER,
  minutosDiferencia INTEGER,
  companiaCodigo NUMERIC,
  estadoCodigo NUMERIC, 
  tipoCodigo varchar(255), 
  productoCodigo NUMERIC, 
  grupoCodigo NUMERIC, 
  origenCodigo NUMERIC,
  prioridadCodigo NUMERIC,
  agenteCodigo NUMERIC  
)
go;


CREATE TABLE stg.Conversaciones
(
  id VARCHAR(100),
  created_at DATETIME,
  updated_at DATETIME
)
go;

CREATE  TABLE stg.ActivityLogs 
(
    performed_at               NVARCHAR(MAX),
    ticket_id                  NVARCHAR(MAX),
    performer_type             NVARCHAR(MAX),
    performer_id               NVARCHAR(MAX),
    activity_note_id           NVARCHAR(MAX),
    activity_note_type         NVARCHAR(MAX),
    activity_status            NVARCHAR(MAX),
    activity_requester_id      NVARCHAR(MAX),
    activity_source            NVARCHAR(MAX),
    activity_group             NVARCHAR(MAX),
    activity_priority          NVARCHAR(MAX),
    activity_new_ticket        NVARCHAR(MAX),
    activity_automation_type   NVARCHAR(MAX),
    activity_automation_rule   NVARCHAR(MAX),
    activity_added_tags        NVARCHAR(MAX),  
    activity_agent_id          NVARCHAR(MAX),
    activity_ID_eFleet         NVARCHAR(MAX),
    activity_Obs_eFleet        NVARCHAR(MAX),
    activity_send_email_agent_ids NVARCHAR(MAX),
    activity_Patente           NVARCHAR(MAX),
    activity_ticket_type       NVARCHAR(MAX),
    activity_description       NVARCHAR(MAX),
    activity_subject           NVARCHAR(MAX),
    activity_Kilometraje       NVARCHAR(MAX),
    activity_Generar_OT_eFleet NVARCHAR(MAX),
    activity_due_by            NVARCHAR(MAX),
    activity_Fecha_turno       NVARCHAR(MAX),    
    activity_association_action             NVARCHAR(MAX),
    activity_association_type               NVARCHAR(MAX),
    activity_association_source_ticket_id   NVARCHAR(MAX),
    activity_association_target_ticket_id   NVARCHAR(MAX),
    activity_deleted            NVARCHAR(MAX),
    activity_Fecha_primer_turno NVARCHAR(MAX),
    activity_product            NVARCHAR(MAX)
);

-----------------------------------------------------------
-- Crea las tablas de dimensiones
-----------------------------------------------------------
CREATE TABLE whs.dimProductos
(
    id INT IDENTITY(1,1) PRIMARY KEY,  
    codigo VARCHAR(100),  
    nombre VARCHAR(100)
)
go;

CREATE TABLE whs.dimCompanias
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    codigo VARCHAR(100),
    nombre VARCHAR(100)
)
go;

CREATE TABLE whs.dimAgentes
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    codigo varchar(200),
    nombre varchar(200)
)
go;

CREATE table whs.dimEstados
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    codigo VARCHAR(100),
    nombre VARCHAR(100)
)
go;

CREATE TABLE whs.dimTiposTicket
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    codigo VARCHAR(100),
    nombre varchar(100)
)
go;

CREATE TABLE whs.dimGrupos
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    codigo VARCHAR(100),
    nombre VARCHAR(100)
)
go;

CREATE TABLE whs.dimOrigenes
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    codigo VARCHAR(100),  
    nombre VARCHAR(100)
)
go;

CREATE TABLE whs.dimPrioridades
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    codigo VARCHAR(100),  
    nombre VARCHAR(100)
)
go;

CREATE  TABLE whs.dimSla
(
    id INT IDENTITY(1,1) PRIMARY,
    codigo VARCHAR(100),	
    nombre VARCHAR(255),
    descipcion VARCHAR(500),
    isactive BIT,	
    isdefault BIT,
    posicion INT,	
    fechaAlta VARCHAR(100),	
    fechaModificacion VARCHAR(100),
    companyid VARCHAR(100),
    slaTargetPriority1RespondWithin	DECIMAL(18,4),
    slaTargerPriority1ResolveWithin	DECIMAL(18,4), 
    slaTargetPriority2RespondWithin	DECIMAL(18,4),
    slaTargerPriority2ResolveWithin	DECIMAL(18,4),   
    slaTargetPriority3RespondWithin	DECIMAL(18,4),
    slaTargerPriority3ResolveWithin	DECIMAL(18,4),    
    slaTargetPriority4RespondWithin	DECIMAL(18,4),
    slaTargerPriority4ResolveWithin	DECIMAL(18,4),
    escalationReminderResolutionEscalationTime	DECIMAL(18,4),
    escalationReminderResolutionAgentids VARCHAR(100),	
    escalationResolutionLevel1EscalationTime	DECIMAL(18,4),
    escalationResolutionLevel1AgentId VARCHAR(100)
)
go;

Create table whs.dimAreaFuncional
(
    Id int IDENTITY(1,1) PRIMARY key,
    codigo varchar(100),
    nombre varchar(200),
    descripcion varchar(500)
)
go;

Create table whs.dimClientes
(
    Id int IDENTITY(1,1) PRIMARY key,
    codigo varchar(100),
    nombre varchar(200),
    descripcion varchar(500)
)
go;

Create table whs.dimPatentes
(
    Id int IDENTITY(1,1) PRIMARY key,
    codigo varchar(100),
    nombre varchar(200),
    descripcion varchar(500)
)
go;

Create table whs.dimProveedores
(
    Id int IDENTITY(1,1) PRIMARY key,
    codigo varchar(100),
    nombre varchar(200),
    descripcion varchar(500)
)
Go;



-----------------------------------------------------------
-- Crea las tablas de hechos
-----------------------------------------------------------
CREATE TABLE whs.factTickets
(
  codigo VARCHAR(100),
  fechaAlta DATETIME,
  fechaModificacion DATETIME,
  horasDiferecia INTEGER,
  minutosDiferencia INTEGER,
  companiaId INT,
  estadoId INT, 
  tipoId INT, 
  productoId INT, 
  grupoId INT, 
  origenId INT,
  prioridadId INT,
  agenteId INT,
  slaId INT,
  SlaResolucion decimal(18,4),
  SlaRespuesta decimal(18,4),
  FechaPrimerRespuesta DATETIME,
  FOREIGN KEY (companiaId) REFERENCES whs.dimCompanias(id),
  FOREIGN KEY (estadoId) REFERENCES whs.dimEstados(id),
  FOREIGN KEY (tipoId) REFERENCES whs.dimTiposTicket(id),
  FOREIGN KEY (productoId) REFERENCES whs.dimProductos(id),
  FOREIGN KEY (grupoId) REFERENCES whs.dimGrupos(id),
  FOREIGN KEY (origenId) REFERENCES whs.dimOrigenes(id),
  FOREIGN KEY (prioridadId) REFERENCES whs.dimPrioridades(id),
  FOREIGN KEY (agenteId) REFERENCES whs.dimAgentes(id),
  FOREIGN KEY (slaId) REFERENCES whs.dimSla(id)
)
go;

create table whs.factTareas
(
    id int identity(1,1) PRIMARY KEY,
    fecha datetime,
    clienteId int,
    areaFuncionalId int,
    tarea varchar(max),
    patenteId int,
    productoId int,
    horas int,
    minutos int,
    usuario VARCHAR(300),
    horaRegistrada DATETIME,
    FOREIGN KEY (clienteId) REFERENCES whs.dimClientes(id),
    FOREIGN KEY (areaFuncionalId) REFERENCES whs.dimAreaFuncional(id),
    FOREIGN KEY (patenteId) REFERENCES whs.dimPatentes(id),
    FOREIGN KEY (productoId) REFERENCES whs.dimProductos(id)
)
go;

-----------------------------------------------------------
-- Crea la vista para obtener conversaciones pendientes
-----------------------------------------------------------
CREATE VIEW whs.v_getConversaciones
as
SELECT distinct codigo 
FROM whs.factTickets t
LEFT JOIN stg.Conversaciones c ON c.id = t.codigo
WHERE 
c.id IS NULL and 
t.fechaAlta > CAST(DATEADD(day, -90, GETDATE()) AS DATETIME)
GO

CREATE TABLE whs.FactActivityLogs (
    Fecha NVARCHAR(50),
    ticketId BIGINT,
    performerType NVARCHAR(50),
    performerId BIGINT,
    activityNoteId BIGINT,
    activityNoteType INT,
    activityStatus NVARCHAR(100),
    activityRequesterId BIGINT,
    activitySource INT,
    activityGroup NVARCHAR(100),
    activityPriority INT,
    activityNew_ticket BIT,
    activityAutomationType INT,
    activityAutomationRule NVARCHAR(200),
    activityAddedTags NVARCHAR(MAX),  -- lista de tags como texto
    activityAgentId BIGINT,
    activity_ID_eFleet NVARCHAR(50),
    activity_Obs_eFleet NVARCHAR(200),
    activity_send_email_agent_id NVARCHAR(MAX),
    activity_Patente NVARCHAR(50),
    activity_ticket_type NVARCHAR(100),
    activity_description NVARCHAR(MAX),
    activity_subject NVARCHAR(500),
    activity_Kilometraje NVARCHAR(50),
    activity_Generar_OT_eFleet NVARCHAR(10),
    activity_due_by DATETIME,
    activity_Fecha_turno DATETIME,    
    activity_association_action NVARCHAR(50),
    activity_association_type NVARCHAR(50),
    activity_association_source_ticket_id   BIGINT,
    activity_association_target_ticket_id   BIGINT,
    activity_deleted BIT,
    activity_Fecha_primer_turno DATETIME,
    activity_product NVARCHAR(100)
);

-----------------------------------------------------------
-- Mantenimiento de DB
-----------------------------------------------------------
DBCC SHRINKDATABASE (N'Autocorp_dw');
DBCC SHRINKFILE (N'Autocorp_dw', 5000);
