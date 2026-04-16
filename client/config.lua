local resName = GetCurrentResourceName()
local phone = Config.Phone

-------------------------------------------------
-- Auto-detección de teléfonos compatibles
-------------------------------------------------
local SUPPORTED_PHONES = {
    { resource = 'lb-phone',            type = 'lb' },
    { resource = 'qs-smartphone-pro',   type = 'qs' },
    { resource = 'qs-smartphone',       type = 'qs' },
    { resource = 'gksphone',            type = 'gks' },
    { resource = 'gks-phone',           type = 'gks' },
}

local detectedPhone = nil

if phone.resource then
    if GetResourceState(phone.resource) ~= 'missing' then
        for _, p in ipairs(SUPPORTED_PHONES) do
            if p.resource == phone.resource then
                detectedPhone = p
                break
            end
        end
        if not detectedPhone then
            detectedPhone = { resource = phone.resource, type = 'custom' }
        end
    end
else
    for _, p in ipairs(SUPPORTED_PHONES) do
        if GetResourceState(p.resource) == 'started' then
            detectedPhone = p
            break
        end
    end
end

local hasPhone = detectedPhone ~= nil

-------------------------------------------------
-- Standalone: auto-detectar si no hay teléfono
-------------------------------------------------
local standaloneConfig = Config.Standalone or {}
local standaloneEnabled = standaloneConfig.enabled
if standaloneEnabled == nil then
    standaloneEnabled = not hasPhone
end

-------------------------------------------------
-- MJClient
-------------------------------------------------
local nuiUrl = 'https://cfx-nui-' .. resName .. '/'

MJClient = {
    APP_ID         = phone.appId or resName,
    PHONE_RESOURCE = detectedPhone and detectedPhone.resource or nil,
    PHONE_TYPE     = detectedPhone and detectedPhone.type or nil,
    HAS_PHONE      = hasPhone,
    STANDALONE     = standaloneEnabled,
    APP_NAME       = phone.name or 'MultiJob',
    APP_DESC       = phone.description or 'Aplicación de empleos múltiples',
    APP_DEVELOPER  = phone.developer or 'OscarDev',
    APP_DEFAULT    = phone.defaultApp ~= false,
    APP_UI         = phone.ui or (nuiUrl .. 'ui/phone/index.html'),
    APP_ICON       = phone.icon or (nuiUrl .. 'ui/assets/icon.png'),
    NUI_URL        = nuiUrl,
}

if Config.Debug then
    if hasPhone then
        lib.print.info(('[multijob] Teléfono detectado: %s (%s)'):format(detectedPhone.resource, detectedPhone.type))
    else
        lib.print.info('[multijob] No se detectó teléfono compatible')
    end
    lib.print.info(('[multijob] Standalone: %s'):format(tostring(standaloneEnabled)))
end
