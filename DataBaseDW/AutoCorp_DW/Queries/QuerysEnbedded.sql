---------------------------------------------------------------------------------------
-- Setear SLA por tickets
---------------------------------------------------------------------------------------
select   
    t.codigo,
    t.fechaAlta,
    t.fechaModificacion,
    t.horasDiferecia,
    t.minutosDiferencia,
    t.companiaId,
    t.estadoId, 
    t.tipoId, 
    t.productoId, 
    t.grupoId, 
    t.origenId,
    t.prioridadId,
    t.agenteId,
    (case 
        when t.estadoId = 48 then 
                case 
                    when p.codigo = 1 then sla.TiempoRespuestaPrioridad1
                    when p.codigo = 2 then sla.TiempoRespuestaPrioridad2
                    when p.codigo = 3 then sla.TiempoRespuestaPrioridad3
                    when p.codigo = 4 then sla.TiempoRespuestaPrioridad4
                else 1111
                end 
        when t.estadoId = 2 then 
            case 
                when p.codigo = 1 then sla.TiempoResolucionPrioridad1
                when p.codigo = 2 then sla.TiempoResolucionPrioridad2
                when p.codigo = 3 then sla.TiempoResolucionPrioridad3
                when p.codigo = 4 then sla.TiempoResolucionPrioridad4
            else 2222
            end 
    else 0
    end / 60) slaMinutos

from stg.Tickets t
left join stg.Sla sla on sla.codigo = t.codigo and sla.activo = true
left join whs.dimPrioridades p on p.id = t.prioridadId
where t.companiaId = 2;

---------------------------------------------------------------------------------------
-- Nuevo
---------------------------------------------------------------------------------------
select top 20 
t.codigo,
t.fechaAlta,
t.fechaModificacion,
horasDiferecia,
minutosDiferencia,
c.id companiaId,
e.id estadoId,
tt.id  tipoId,
p.id productoId,
g.id grupoId,
o.id orgienId,
pr.id prioridadId,
a.id agenteId,
---------------------------
sla.id slaId,
case 
    when pr.codigo = 1 then sla.slaTargerPriority1ResolveWithin
    when pr.codigo = 2 then sla.slaTargerPriority2ResolveWithin
    when pr.codigo = 3 then sla.slaTargerPriority3ResolveWithin
    when pr.codigo = 4 then sla.slaTargerPriority4ResolveWithin
end SlaResolucion,
case 
    when pr.codigo = 1 then sla.slaTargetPriority1RespondWithin
    when pr.codigo = 2 then sla.slaTargetPriority2RespondWithin
    when pr.codigo = 3 then sla.slaTargetPriority3RespondWithin
    when pr.codigo = 4 then sla.slaTargetPriority4RespondWithin
end SlaRespuesta

from stg.tickets t 
left join whs.dimCompanias c on c.codigo = t.companiaCodigo
left join whs.dimEstados e on e.codigo = t.estadoCodigo
left join whs.dimTiposTicket tt on tt.codigo = t.tipoCodigo
left join whs.dimProductos p on p.codigo = t.productoCodigo
left join whs.dimGrupos g on g.codigo = t.grupoCodigo
left join whs.dimOrigenes o on o.codigo = t.origenCodigo
left join whs.dimPrioridades pr on pr.codigo = t.prioridadCodigo
left join whs.dimAgentes a on a.codigo = t.agenteCodigo
left join whs.dimSla sla on sla.companyid = t.companiaCodigo or sla.nombre = 'Default SLA Policy' and sla.isactive = 1

where agenteCodigo is not null
