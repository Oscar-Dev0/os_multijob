local APP_ID = MJClient.APP_ID
local PHONE_RESOURCE = MJClient.PHONE_RESOURCE

local function sendPhoneMessage(payload)
    exports[PHONE_RESOURCE]:SendCustomAppMessage(APP_ID, payload)
end

local function addPhoneApp()
    local added, errorMessage = exports[PHONE_RESOURCE]:AddCustomApp({
        identifier = APP_ID,
        name       = MJClient.APP_NAME,
        description = MJClient.APP_DESC,
        defaultApp = MJClient.APP_DEFAULT,
        developer  = MJClient.APP_DEVELOPER,
        ui         = MJClient.APP_UI,
        icon       = MJClient.APP_ICON,
    })

    if not added then
        lib.print.error(('[multijob] No se pudo registrar la app en el teléfono: %s'):format(tostring(errorMessage)))
    elseif Config.Debug then
        lib.print.info(('[multijob] App registrada — id: %s | ui: %s | icon: %s'):format(APP_ID, MJClient.APP_UI, MJClient.APP_ICON))
    end
end

CreateThread(function()
    while GetResourceState(PHONE_RESOURCE) ~= 'started' do
        Wait(500)
    end
    addPhoneApp()
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == PHONE_RESOURCE then
        addPhoneApp()
    end
end)

MJClient.sendPhoneMessage = sendPhoneMessage
MJClient.addPhoneApp = addPhoneApp
