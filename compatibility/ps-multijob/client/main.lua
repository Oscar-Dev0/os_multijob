if not Config.Compatibility or not Config.Compatibility['ps-multijob'] then return end

-------------------------------------------------
-- Fake client exports como si fuéramos ps-multijob
-- exports['ps-multijob']:FunctionName(...) desde client
-------------------------------------------------

local function RegisterPSExport(name, cb)
    AddEventHandler(('__cfx_export_ps-multijob_%s'):format(name), function(setCB)
        setCB(cb)
    end)
end

-------------------------------------------------
-- OpenUI / CloseUI
-- Si hay standalone → abre la NUI standalone
-- Si hay teléfono → notifica (no se puede forzar abrir el teléfono)
-------------------------------------------------

RegisterPSExport('OpenUI', function()
    if MJClient.STANDALONE and MJClient.openStandalone then
        MJClient.openStandalone()
    elseif Config.Debug then
        lib.print.info('[multijob:ps-compat] OpenUI llamado pero standalone no está activo')
    end
end)

RegisterPSExport('CloseUI', function()
    if MJClient.STANDALONE and MJClient.closeStandalone then
        MJClient.closeStandalone()
    end
end)

if Config.Debug then
    lib.print.info('[multijob] Compatibilidad ps-multijob CLIENT activada (OpenUI/CloseUI)')
end
