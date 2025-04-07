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


-----------------------------------------------------------
-- Mantenimiento de DB
-----------------------------------------------------------
DBCC SHRINKDATABASE (N'Autocorp_dw');
DBCC SHRINKFILE (N'Autocorp_dw', 5000);
