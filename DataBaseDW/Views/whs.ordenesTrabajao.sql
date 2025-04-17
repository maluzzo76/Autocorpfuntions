-----------------------------------------------
-- create views
-----------------------------------------------

create view whs.Agentes
AS
select * from whs.dimAgentes with(nolock)
go

create view whs.AreasFunciones
AS
select * from whs.dimAreaFuncional with(nolock)
go

create view whs.Clientes
AS
select * from whs.dimClientes with(nolock)
go

create view whs.Companias
AS
select * from whs.dimCompanias with(nolock)
go

create view whs.Estados
AS
select * from whs.dimEstados with(nolock)
go

create view whs.Grupos
AS
select * from whs.dimGrupos with(nolock)
go

create view whs.OrdenesDeTrabajoTipo
AS
select * from whs.dimOrdenTrabajoTipo with(nolock)
go

create view whs.Origenes
AS
select * from whs.dimOrigenes with(nolock)
go

create view whs.patentes
AS
select * from whs.dimPatentes with(nolock)
go

create view whs.Prioridades
AS
select * from whs.dimPrioridades with(nolock)
go

create view whs.Productos
AS
select * from whs.dimProductos with(nolock)
go

create view whs.Proveedores
AS
select * from whs.dimProveedores with(nolock)
go

create view whs.Sla
AS
select * from whs.dimSla with(nolock)
go

create view whs.Tareas
AS
select * from whs.dimTareas with(nolock)
go

create view whs.TicketTipo
AS
select * from whs.dimTiposTicket with(nolock)
go

create view whs.Vehiculos
AS
select * from whs.dimVehiculos with(nolock)
go

create view whs.OrdenesDeTrabajo
AS
select * from whs.factOrdenesTrabajo with(nolock)
go

create view whs.VehiculosHistoricoPrecios
AS
select * from whs.factPrecioHistoricoVehiculo with(nolock)
go

create view whs.Reservas
AS
select * from whs.factReservas with(nolock)
go

create view whs.CargaHoras
AS
select * from whs.factTareas with(nolock)
go

create view whs.Tickets
AS
select 
t.*,
CONVERT(decimal(18,4),case 
    when FechaPrimerRespuesta is null then DATEDIFF(MINUTE,fechaAlta,GETDATE())
    else DATEDIFF(MINUTE,fechaAlta,FechaPrimerRespuesta)
End )minutosDiferenciaRespuesta,

convert(decimal(18,2),
case
    when 
        case 
            when 
                case 
                    when FechaPrimerRespuesta is null then DATEDIFF(MINUTE,fechaAlta,GETDATE())     
                    else DATEDIFF(MINUTE,fechaAlta,FechaPrimerRespuesta)
                End <= SlaRespuesta  then 100
            else 
                case 
                    when 
                        100 - case 
                            when FechaPrimerRespuesta is null then DATEDIFF(MINUTE,fechaAlta,GETDATE())     
                            else DATEDIFF(MINUTE,fechaAlta,FechaPrimerRespuesta)
                        End / SlaRespuesta < 0 then 0
                    else 
                    100 - case 
                            when FechaPrimerRespuesta is null then DATEDIFF(MINUTE,fechaAlta,GETDATE())     
                            else DATEDIFF(MINUTE,fechaAlta,FechaPrimerRespuesta)
                        End / SlaRespuesta
                    end        
            end > 100 then 100
        else
         case 
            when 
                case 
                    when FechaPrimerRespuesta is null then DATEDIFF(MINUTE,fechaAlta,GETDATE())     
                    else DATEDIFF(MINUTE,fechaAlta,FechaPrimerRespuesta)
                End <= SlaRespuesta  then 100
            else 
                case 
                    when 
                        100 - case 
                            when FechaPrimerRespuesta is null then DATEDIFF(MINUTE,fechaAlta,GETDATE())     
                            else DATEDIFF(MINUTE,fechaAlta,FechaPrimerRespuesta)
                        End / SlaRespuesta < 0 then 0
                    else 
                    100 - case 
                            when FechaPrimerRespuesta is null then DATEDIFF(MINUTE,fechaAlta,GETDATE())     
                            else DATEDIFF(MINUTE,fechaAlta,FechaPrimerRespuesta)
                        End / SlaRespuesta
                    end        
            end
        end)
     PorcentejeEfectividadRespuesta,

convert(decimal(18,2),
case
    when 
        case 
            when 
                case 
                    when e.nombre <> 'CLOSED' and e.nombre <> 'RESOLVED' then  DATEDIFF(MINUTE,fechaAlta,GETDATE()) 
                    else DATEDIFF(MINUTE,fechaAlta,fechaModificacion)
                End <= SlaResolucion then 100
            else 
                case 
                    when 
                        case 
                                when e.nombre <> 'CLOSED' and e.nombre <> 'RESOLVED' then  DATEDIFF(MINUTE,fechaAlta,GETDATE()) 
                                else DATEDIFF(MINUTE,fechaAlta,fechaModificacion)
                        End / SlaResolucion < 0 then 0
                    else    
                        case 
                                when e.nombre <> 'CLOSED' and e.nombre <> 'RESOLVED' then  DATEDIFF(MINUTE,fechaAlta,GETDATE()) 
                                else DATEDIFF(MINUTE,fechaAlta,fechaModificacion)
                        End / SlaResolucion
                    end        
            end > 100 then 100
        else
        case 
            when 
                case 
                    when e.nombre <> 'CLOSED' and e.nombre <> 'RESOLVED' then  DATEDIFF(MINUTE,fechaAlta,GETDATE()) 
                    else DATEDIFF(MINUTE,fechaAlta,fechaModificacion)
                End <= SlaResolucion then 100
            else 
                case 
                    when 
                        case 
                                when e.nombre <> 'CLOSED' and e.nombre <> 'RESOLVED' then  DATEDIFF(MINUTE,fechaAlta,GETDATE()) 
                                else DATEDIFF(MINUTE,fechaAlta,fechaModificacion)
                        End / SlaResolucion < 0 then 0
                    else    
                        case 
                                when e.nombre <> 'CLOSED' and e.nombre <> 'RESOLVED' then  DATEDIFF(MINUTE,fechaAlta,GETDATE()) 
                                else DATEDIFF(MINUTE,fechaAlta,fechaModificacion)
                        End / SlaResolucion
                    end        
            end
        end)
              PorcentejeEfectividadResolucion,
    e.codigo codigoEstado,
    e.nombre nombreEstado
    
from whs.factTickets t 
left join whs.dimEstados e on e.id = t.estadoId
GO
