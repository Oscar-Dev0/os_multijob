if not MJClient.HAS_PHONE or MJClient.PHONE_TYPE ~= 'gks' then return end

local RES  = MJClient.PHONE_RESOURCE -- 'gks-phone' o 'gksphone'
local ID   = MJClient.APP_ID

function Phone.createApp()
    local appData = {
        name        = ID,
        icons       = MJClient.APP_ICON,
        description = MJClient.APP_DESC,
        appurl      = MJClient.APP_UI,
        url         = '/customapp',
        blockedjobs = {},
        allowjob    = {},
        signal      = true,
        show        = true,
        labelLangs  = {
            en = MJClient.APP_NAME,
            es = MJClient.APP_NAME,
            fr = MJClient.APP_NAME,
            de = MJClient.APP_NAME,
            pt = MJClient.APP_NAME,
        },
    }

    exports[RES]:AddCustomApp(appData)

    if Config.Debug then
        lib.print.info(('[multijob] gksphone: app registrada — id: %s'):format(ID))
    end
end

-- gksphone usa NuiSendMessage en vez de SendNUIMessage
function Phone.sendMessage(payload)
    exports[RES]:NuiSendMessage(payload)
end
