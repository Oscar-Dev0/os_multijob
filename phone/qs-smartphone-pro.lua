if not MJClient.HAS_PHONE or MJClient.PHONE_TYPE ~= 'qs' then return end

local RES  = MJClient.PHONE_RESOURCE
local ID   = MJClient.APP_ID

function Phone.createApp()
    local added = exports[RES]:addCustomApp({
        app         = ID,
        label       = MJClient.APP_NAME,
        description = MJClient.APP_DESC,
        creator     = MJClient.APP_DEVELOPER,
        image       = MJClient.APP_ICON,
        ui          = MJClient.APP_UI,
        job         = false,
        blockedJobs = {},
        timeout     = 5000,
        category    = 'social',
        isGame      = false,
        age         = '16+',
    })

    if not added then
        lib.print.error(('[multijob] qs-smartphone: no se pudo registrar la app'))
    elseif Config.Debug then
        lib.print.info(('[multijob] qs-smartphone: app registrada — id: %s'):format(ID))
    end
end

function Phone.sendMessage(payload)
    exports[RES]:SendCustomAppMessage(ID, payload)
end