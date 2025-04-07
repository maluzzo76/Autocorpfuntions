-----------------------------------------------------------
--- CREA TODAS LAS TABLAS DE EFEET EN EL DATA WAREHOUSE 
-----------------------------------------------------------
-----------------------------------------------------------
-- Tablas de Dimensiones
-----------------------------------------------------------

CREATE TABLE whs.dimVehiculos
(
    id int,
    codigo int,
    contratoId int,
    policyId int,
    descripcion varchar(255),
    codigoDeVehiculo varchar(200),  
    color varchar(100),
    chassis varchar(255),
    patente varchar(100),
    anio int,
    fechaVencimientoVTV [datetime2](6),
    fechaVencimientoDocumento [datetime2](6),
    garantiaHastaKm numeric,
    fechaActualizadaGarantia [datetime2](6),
    garantiaVigente bit,
    isPropietarioFlota bit,
    ultimoKilometraje numeric,
    ultimoKilometrajeOrigen varchar(255),
    fechaUltimoKm [datetime2](6),
    servicioUltimoKm numeric,
    origenServicio varchar(255),
    ultimaFechaServicio [datetime2](6),
    tipoCondicion varchar(255),
    categoriaCliente varchar(255),
    grupoCategoriaCliente varchar(255) ,
    numeroTarjetaCombustible varchar(255),
    numeroTarjetaPeaje varchar(255),
    tieneDocumentoCirculacion bit,
    montoSeguro decimal(18,4),
    versionId int,
    vehiculoEstadoId int,
    clienteEstructuraId int,
    seguroId int,
    proveedorGpsId int,
    tieneClaveDuplicado bit,
    numeroGPS varchar(255),
    detalleGPS varchar(255),
    gpsMonto decimal(18,4),
    ultimaFechaVTV [datetime2](6),
    fechaClaveDuplicada [datetime2](6),
    ultimaCiudadVTVId int,
    patenteCuidadId int,
    gpsIsVisible int,
    propietario varchar(255),
    propietarioContactoId int,
    planMantenimientoId int,
    arrendamientoFechaVencimiento [datetime2](6),
    fechaDeRetiro [datetime2](6),
    kmVencimientoVTV numeric,
    proveedorCombustible varchar(255),
    UltimaTareaId int,
    fechaInicioSeguro [datetime2](6),
    codigoHansa varchar(100),
    fechaUltimaComparacion [datetime2](6),
    vtvCabaTexto varchar(255),
    precioInfoauto decimal(18,4),
    fechaPrecioInfoAuto [datetime2](6),
    estado varchar(255),
    numeroMotor varchar(255)
)

CREATE TABLE whs.dimClientes
(
    id int,
    codigo int,
    nombre varchar (255),
    empresa varchar (255),   
    grupo varchar(255),
    clasificacion varchar(255), 
    primerLimiteDecredito decimal (18,4),
    segundoLimiteDeCredito decimal (18,4),
    tipoOperacion varchar(255),
    tipoComprobante varchar(255),
    tipoCliente varchar(255),
    estadoCliente varchar(255)
)

-- preguntar si en esta tabla que no tiene un id solo, hay que ponerlo y colocar el primary key --
CREATE TABLE whs.dimSubcontacts
(
    id int IDENTITY(1,1) PRIMARY key,
    contactoid	int,
    primercontactoid int,
    tiposubcontactoid	int,
    estructuraclienteid int,
    usuarioid int,
    primernombre varchar (255),
    apellido varchar(255),
    relacioncontacto varchar (255),
    numerolicencia	varchar (255),
    fechavencimientolicencia datetime,
    recibofactura int
)

go;



CREATE TABLE whs.dimOrdenTrabajoOrgien
(
    id int identity (1,1) primary key,
    codigo int,
    nombre varchar (255),
    hansacode varchar (255)
)

create TABLE whs.dimOrdenTrabajoTipo
(
    id int identity (1,1) primary key,
    codigo int,
    nombre varchar (255),
    hansacode varchar (255)
)


create table whs.dimOrdenTrabajoTipoGasto
(
    id int IDENTITY(1,1) primary key,
    codigo int,
    nombre varchar(255),
    hansacode VARCHAR(255)
)


create table whs.dimContratos
(
  id int IDENTITY(1,1) PRIMARY KEY,
  codigo int,
  nombre varchar(200),
  tipoContrato varchar(200)  
)

CREATE TABLE whs.dimOrdenTrabajoCategorias
(
codigo int,
nombre varchar(255),
descripcion varchar(max),
seccionNombre varchar(255)
)

CREATE TABLE whs.dimTareas
(
    id int IDENTITY(1,1) PRIMARY key,
    codigo int,
    nombre varchar(255),
    descripcion varchar(max),
    nombreCategoria varchar(255),
    descripcionCategoria varchar(max)
)


CREATE TABLE whs.dimOrdenesTrabajo
(
    id int ,
    codigo int,
    nombre varchar(max),
    estado varchar(max),
    fechaEliminacion DATETIME2(6),
    fechaCreacion DATETIME2(6),
    fechaActualizacion DATETIME2(6),
    hansaCode varchar(max),
    codigoTipoOrdenTrabajo int,
    codigoOrdenTrabajoOriginal int,
    razon varchar(max),
    codigoInterno VARCHAR(max),
    numero int,
    patente VARCHAR(max),
    codigoContrato int,
    km numeric,
    estimada bit,
    codigoTipoGasto int,
    codigoUsuario int,
    codigoTicket varchar(max),
    codigoVehiculo int
)


create table whs.dimContactos
(
    id int IDENTITY(1,1) PRIMARY key,
    codigo int,
    hansa_code  varchar(200),
    hansa_name varchar(200),
    hansa_addr0 varchar(200),
    hansa_invaddr0 varchar(200),
    hansa_invaddr2 varchar(200),
    hansa_phone varchar(200),
    hansa_VATNr varchar(200),
    hansa_CUType varchar(200),
    hansa_VEType varchar(200),   
    email varchar(200),
    phone varchar(200),
    mobile varchar(200),
    document_type int,
    document_number varchar(200),
    is_company int,
    hansa_invaddr1 varchar(200),
    hansa_invaddr3 varchar(200),
    hansa_invaddr4 varchar(200),
    contact_checked int,
    contact_checked_date datetime,
   hansa_closed int
)

go;

-----------------------------------------------------------
-- Tablas de Hechos
-----------------------------------------------------------


CREATE TABLE stg.OrdenTrabajoTareas
( 
    ordenTrabajoCodigo int,
    tareaCodigo int,
    tareaAccionCodigo int, 
    vehiculoCodigo int,
    ordenTabajoTipoCodigo int,
    totalSivaNoSiniestro decimal(18,4),
    esSeguro int,
    esSinietro int,
    totalSivaSiniestro decimal(18,4),
    costoManoObraSinIva decimal(18,4),
    costoMaterialSinIVa decimal(18,4),
    costoTotalSinIva decimal(18,4), 
    costoManoObra decimal(18,4),
    costoMaterial decimal(18,4),
    costoTotal decimal(18,4),
    descuentoManoObra decimal(18,4),
    descuentoMaterial decimal(18,4),
    descuentoTotal decimal(18,4),
    fechaCreacion datetime2(6),
    fechaActualizacion datetime2(6)
)

CREATE TABLE whs.factOrdenesTrabajo
( 
    ordenTrabajoId int,
    tareaId int,
    tareaAccionId int, 
    vehiculoId int,
    ordenTabajoTipo int,
    total_s_iva_no_seguro decimal(18,4),
     esSeguro int,
    esSinietro int,
    totalSivaSiniestro decimal(18,4),
    costoManoObraSinIva decimal(18,4),
    costoMaterialSinIVa decimal(18,4),
    costoTotalSinIva decimal(18,4), 
    costoManoObra decimal(18,4),
    costoMaterial decimal(18,4),
    costoTotal decimal(18,4),
    descuentoManoObra decimal(18,4),
    descuentoMaterial decimal(18,4),
    descuentoTotal decimal(18,4),
    fechaCreacion datetime2(6),
    fechaActualizacion datetime2(6)
)

CREATE TABLE whs.factReservas
(
    id int identity (1,1) primary key,
    subcontactoid int,
    vehiculoid int,
    vehiculorelacionadoid	int,
    hansaid varchar (255),
    inicioreserva date,
    finreserva	date,
    franquisia decimal (18,4),
    iniciokm int,
    ultimokm int,
    fechaesperadarecogida	datetime,
    fechaentregaesperada datetime,
    fechaactualrecogida datetime,
    fechaentregaactual datetime
)

go;