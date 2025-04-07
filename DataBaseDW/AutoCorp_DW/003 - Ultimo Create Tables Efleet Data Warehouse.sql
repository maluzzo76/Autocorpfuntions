-----------------------------------------------------------
-- Tablas de Dimensiones
-----------------------------------------------------------
drop table whs.dimVehiculos
CREATE TABLE whs.dimVehiculos
(
    id int identity(1,1),
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

CREATE TABLE whs.dimTareas
(
    id int IDENTITY(1,1) PRIMARY key,
    codigo int,
    nombre varchar(255),
    descripcion varchar(max),
    nombreCategoria varchar(255),
    descripcionCategoria varchar(max)
)

create TABLE whs.dimOrdenTrabajoTipo
(
    id int identity (1,1) primary key,
    codigo int,
    nombre varchar (255),
    hansacode varchar (255)
)


-----------------------------------------------------------
-- Tablas de Hechos
-----------------------------------------------------------
drop table stg.OrdenTrabajoTareas
CREATE TABLE stg.OrdenTrabajoTareas
( 
    ordenTrabajoCodigo int,
    tareaCodigo int,
    tareaAccionCodigo int, 
    vehiculoCodigo int,
    ordenTabajoTipoCodigo int,
    nombreOrdenTrabajo varchar(255),
    estadoOrdenTarbajo varchar(255),
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

drop table whs.factOrdenesTrabajo
CREATE TABLE whs.factOrdenesTrabajo
( 
    ordenTrabajoId int,
    tareaId int,
    tareaAccionId int, 
    vehiculoId int,
    ordenTabajoTipoId int,
    nombreOrdenTrabajo varchar(255),
    estadoOrdenTarbajo varchar(255),
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


