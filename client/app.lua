-------------------------------------------------
-- Phone handler table (phone/*.lua populates this)
-------------------------------------------------
Phone = {}

-------------------------------------------------
-- Mensajería
-------------------------------------------------
local function sendPhoneMessage(payload)
    if MJClient.HAS_PHONE and Phone.sendMessage then
        Phone.sendMessage(payload)
    end
end

local function sendStandaloneMessage(payload)
    if MJClient.STANDALONE then
        SendNUIMessage(payload)
    end
end

local function sendMessage(payload)
    sendPhoneMessage(payload)
    sendStandaloneMessage(payload)
end

-------------------------------------------------
-- Registro de app en teléfono (delegado a phone/*.lua)
-------------------------------------------------
local function addPhoneApp()
    if not MJClient.HAS_PHONE then return end
    if not Phone.createApp then
        lib.print.error('[multijob] No hay handler de teléfono cargado para: ' .. tostring(MJClient.PHONE_TYPE))
        return
    end
    Phone.createApp()
end

if MJClient.HAS_PHONE then
    CreateThread(function()
        while GetResourceState(MJClient.PHONE_RESOURCE) ~= 'started' do
            Wait(500)
        end
        addPhoneApp()
    end)

    AddEventHandler('onResourceStart', function(resource)
        if resource == MJClient.PHONE_RESOURCE then
            addPhoneApp()
        end
    end)
end

MJClient.sendPhoneMessage = sendPhoneMessage
MJClient.sendStandaloneMessage = sendStandaloneMessage
MJClient.sendMessage = sendMessage
MJClient.addPhoneApp = addPhoneApp
