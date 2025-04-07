select 
*,
CONVERT(decimal(18,4),case 
    when FechaPrimerRespuesta is null then DATEDIFF(MINUTE,fechaAlta,GETDATE())
    else DATEDIFF(MINUTE,fechaAlta,FechaPrimerRespuesta)
End )minutosDiferenciaRespuesta,

convert(decimal(18,2),
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
    end)
     PorcentejeEfectividadRespuesta,

convert(decimal(18,2),
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
    end)  PorcentejeEfectividadResolucion
    
from whs.factTickets t 
left join whs.dimEstados e on e.id = t.estadoId

where minutosDiferencia > 4400