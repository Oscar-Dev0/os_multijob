--- Locale loader: carga el idioma configurado y provee L()

Locales = Locales or {}

local currentLang = Config.Locale or 'es'

if not Locales[currentLang] then
    lib.print.warn(('[multijob] Locale "%s" no encontrado, usando "es"'):format(currentLang))
    currentLang = 'es'
end

--- Obtener un string traducido. Soporta string.format automático.
--- @param key string
--- @param ... any
--- @return string
function L(key, ...)
    local str = Locales[currentLang] and Locales[currentLang][key]
    if not str then
        if Config.Debug then
            lib.print.warn(('[multijob] Locale key faltante: "%s" [%s]'):format(key, currentLang))
        end
        return key
    end
    if select('#', ...) > 0 then
        return str:format(...)
    end
    return str
end

--- Devuelve el idioma actual
--- @return string
function GetLocale()
    return currentLang
end
