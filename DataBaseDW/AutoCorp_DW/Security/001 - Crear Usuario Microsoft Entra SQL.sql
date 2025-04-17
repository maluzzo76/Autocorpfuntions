-- ===========================
-- Usuario: Pablo Ons (Azure AD)
-- ===========================

-- Crear el usuario en la base de datos (no en master)
CREATE USER [PabloOns@autocorp.com.ar] FROM EXTERNAL PROVIDER;

-- Quitarlo del rol db_datareader (si estuviera incluido por defecto)
ALTER ROLE db_datareader DROP MEMBER [PabloOns@autocorp.com.ar];

-- ===========================
-- Usuario: Micaela Laureta (Azure AD)
-- ===========================

-- Crear el usuario en la base de datos
CREATE USER [micaelalauretta@autocorp.com.ar] FROM EXTERNAL PROVIDER;
-- Quitarlo del rol db_datareader (si estuviera incluido por defecto)
ALTER ROLE db_datareader DROP MEMBER [micaelalauretta@autocorp.com.ar];

-- ===========================
-- Usuario: Matias Sallenave (Azure AD)
-- ===========================

-- Crear el usuario en la base de datos
CREATE USER [matiassallenave@autocorp.com.ar] FROM EXTERNAL PROVIDER;
-- Quitarlo del rol db_datareader (si estuviera incluido por defecto)
ALTER ROLE db_datareader DROP MEMBER [matiassallenave@autocorp.com.ar];





