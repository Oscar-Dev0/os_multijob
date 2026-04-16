if Bridge.framework ~= 'esx' then return end

--- ESX obtiene jobs del servidor via callback (player_groups SQL)
--- ESX no tiene sistema de duty nativo, se maneja localmente

local isOnDuty = false

function Bridge.GetPlayerJobs()
    return lib.callback.await('multijob:server:getPlayerJobs', false)
end

function Bridge.GetPrimaryJob()
    local pd = Bridge.GetPlayerData()
    if not pd or not pd.job then return nil end
    return {
        name = pd.job.name,
        onduty = isOnDuty,
    }
end

function Bridge.ToggleDuty()
    isOnDuty = not isOnDuty
end

RegisterNetEvent('esx:setJob', function()
    if Bridge.onJobUpdate then Bridge.onJobUpdate() end
end)

RegisterNetEvent('multijob:client:setDuty', function(duty)
    isOnDuty = duty
    if Bridge.onJobUpdate then Bridge.onJobUpdate() end
end)
