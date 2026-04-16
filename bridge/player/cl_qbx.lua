if Bridge.framework ~= 'qbx' then return end

--- QBX tiene jobs en PlayerData.jobs directamente

function Bridge.GetPlayerJobs()
    local pd = Bridge.GetPlayerData()
    return pd and pd.jobs or {}
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
