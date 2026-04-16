if Bridge.framework ~= 'qb' then return end

--- QB obtiene jobs del servidor via callback (player_groups SQL)

function Bridge.GetPlayerJobs()
    return lib.callback.await('multijob:server:getPlayerJobs', false)
end

function Bridge.GetPrimaryJob()
    local pd = Bridge.GetPlayerData()
    if not pd or not pd.job then return nil end
    return {
        name = pd.job.name,
        onduty = pd.job.onduty or false,
    }
end

function Bridge.ToggleDuty()
    TriggerServerEvent('QBCore:ToggleDuty')
end

RegisterNetEvent('QBCore:Client:OnJobUpdate', function()
    if Bridge.onJobUpdate then Bridge.onJobUpdate() end
end)
