Config = {}

local resName = GetCurrentResourceName()

-------------------------------------------------
-- General
-------------------------------------------------
Config.Debug  = false   -- Activar prints de debug
Config.Locale = 'es'    -- Idioma: 'es' | 'en'

-------------------------------------------------
-- Teléfono / App
-------------------------------------------------
Config.Phone = {
    resource   = 'lb-phone',           -- Recurso del teléfono
    appId      = resName,               -- Identificador interno de la app (usa el nombre del recurso)
    name       = 'MultiJob',            -- Nombre visible en el teléfono
    description = 'Aplicación de empleos múltiples',
    developer  = 'OscarDev',
    defaultApp = true,
    -- Ruta de la UI (se construye automáticamente con el nombre del recurso)
    -- Ejemplos:
    --   nil               → se genera automáticamente: "multijob/ui/index.html"
    --   'multijob/ui/index.html'
    ui = nil,
    -- Icono: puede ser ruta NUI o URL de fivemanage/imgur/etc
    -- Ejemplos:
    --   'nui://multijob/ui/assets/icon.png'
    --   'https://r2.fivemanage.com/xxxxx/icon.png'
    --   nil → se genera automáticamente: "nui://multijob/ui/assets/icon.png"
    icon = nil,
}

-------------------------------------------------
-- Permisos (server)
-------------------------------------------------
Config.AdminPermission = 'admin' -- Permiso requerido para asignar jobs a otros
