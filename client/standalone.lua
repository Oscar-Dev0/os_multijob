if not MJClient.STANDALONE then return end

local isOpen = false
local standaloneStyle = Config.UI and Config.UI.style or 'side-right'

local function openStandalone()
    if isOpen then return end
    isOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        style = standaloneStyle,
    })
end

local function closeStandalone()
    if not isOpen then return end
    isOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

local function toggleStandalone()
    if isOpen then
        closeStandalone()
    else
        openStandalone()
    end
end

RegisterNUICallback('closeStandalone', function(_, cb)
    closeStandalone()
    cb('ok')
end)

-- Comando + keybind
local cmd = Config.Standalone and Config.Standalone.command or 'jobmenu'
RegisterCommand(cmd, toggleStandalone, false)

local keybind = Config.Standalone and Config.Standalone.keybind
if keybind then
    RegisterKeyMapping(cmd, 'Open Job Menu', 'keyboard', keybind)
end

TriggerEvent('chat:removeSuggestion', '/' .. cmd)

-- Funciones públicas
MJClient.openStandalone = openStandalone
MJClient.closeStandalone = closeStandalone
MJClient.isStandaloneOpen = function() return isOpen end

if Config.Debug then
    lib.print.info(('[multijob] Standalone activado — cmd: /%s | key: %s | style: %s'):format(cmd, keybind or 'none', standaloneStyle))
end
