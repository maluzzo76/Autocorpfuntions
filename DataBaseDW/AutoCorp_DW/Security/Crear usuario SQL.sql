-- Pablo Ons
-- Create User Logins Script 1(Master)
CREATE LOGIN pons
WITH PASSWORD = 'Auto2024#Az!';  

-- Create User Script 2(Db donde tiene que tener acceso)
CREATE USER pons FOR LOGIN pons; 

-- Esto da perisos a todas las tablas
ALTER ROLE db_datareader drop MEMBER pons;

-- Asigna permisos de lectura a tablas puntuales
GRANT SELECT ON whs.dimClientes TO pons;  
GRANT SELECT ON whs.factTareas TO pons; 
GRANT SELECT ON whs.factTareas TO pons; 
GRANT SELECT ON whs.factTareas TO pons; 
GRANT SELECT ON whs.factTareas TO pons; 

-- Permisos Micaela
-- Create User Logins Script 1(Master)
CREATE LOGIN mlaureta
WITH PASSWORD = 'mlAuto2024#Az!';  

-- Create User Script 2(Db donde tiene que tener acceso)
CREATE USER pomlauretans FOR LOGIN mlaureta; 
-- Esto da perisos a todas las tablas
--ALTER ROLE db_datareader drop MEMBER pons;
-- Asigna permisos de lectura a tablas puntuales
GRANT SELECT ON whs.dimClientes TO mlaureta;  
GRANT SELECT ON whs.factTareas TO mlaureta; 
