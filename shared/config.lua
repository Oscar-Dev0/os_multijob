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
    resource   = nil,                   -- nil = auto-detectar | 'lb-phone' | 'qs-smartphone' | etc.
    appId      = resName,               -- Identificador interno de la app (usa el nombre del recurso)
    name       = 'MultiJob',            -- Nombre visible en el teléfono
    description = 'Aplicación de empleos múltiples',
    developer  = 'OscarDev',
    defaultApp = true,
    -- Ruta de la UI (se construye automáticamente con el nombre del recurso)
    ui = nil,
    -- Icono: puede ser ruta NUI o URL
    icon = nil,
}

-------------------------------------------------
-- Standalone (NUI sin teléfono)
-------------------------------------------------
Config.Standalone = {
    enabled = nil,              -- nil = auto (si no hay teléfono se activa), true = siempre, false = nunca
    command = 'jobmenu',        -- Comando para abrir la NUI
    keybind = 'J',              -- Tecla para abrir (nil = sin keybind)
}

-------------------------------------------------
-- Estilo de la NUI standalone
-------------------------------------------------
Config.UI = {
    style = 'side-right',      -- 'side-right' | 'side-left' | 'fullscreen' | 'compact'
}

-------------------------------------------------
-- Multijob
-------------------------------------------------
Config.MaxJobs = 3               -- Máximo de jobs por jugador (admins = ilimitado)
Config.AutoRegisterOnJobChange = true -- Registrar job automáticamente al cambiar (ESX/QB)
Config.IgnoredJobs = {           -- Jobs que se ignoran al auto-registrar
    ['unemployed'] = true,
}

-------------------------------------------------
-- Permisos (server)
-------------------------------------------------
Config.AdminPermission = 'admin' -- Permiso requerido para asignar jobs a otros

-------------------------------------------------
-- Compatibilidad
-------------------------------------------------
Config.Compatibility = {
    ['ps-multijob'] = true,      -- Registrar exports y eventos compatibles con ps-multijob
    ['qb-management'] = true,    -- Escuchar evento de despido de qb-management/dw-bossmenu
}
