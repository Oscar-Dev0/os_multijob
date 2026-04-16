if not MJClient.HAS_PHONE or MJClient.PHONE_TYPE ~= 'lb' then return end

local RES  = MJClient.PHONE_RESOURCE
local ID   = MJClient.APP_ID

function Phone.createApp()
    local added, errorMessage = exports[RES]:AddCustomApp({
        identifier  = ID,
        name        = MJClient.APP_NAME,
        description = MJClient.APP_DESC,
        developer   = MJClient.APP_DEVELOPER,
        defaultApp  = MJClient.APP_DEFAULT,
        ui          = MJClient.APP_UI,
        icon        = MJClient.APP_ICON,
    })

    if not added then
        lib.print.error(('[multijob] lb-phone: no se pudo registrar la app: %s'):format(tostring(errorMessage)))
    elseif Config.Debug then
        lib.print.info(('[multijob] lb-phone: app registrada — id: %s'):format(ID))
    end
end

function Phone.sendMessage(payload)
    exports[RES]:SendCustomAppMessage(ID, payload)
end


