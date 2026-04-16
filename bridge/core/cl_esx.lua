if Bridge.framework ~= 'esx' then return end

local ESX = exports['es_extended']:getSharedObject()

function Bridge.GetPlayerData()
    return ESX.GetPlayerData()
end

function Bridge.GetSharedJobs()
    return lib.callback.await('multijob:server:getSharedJobs', false)
end

function Bridge.GetSharedJob(jobName)
    local jobs = Bridge.GetSharedJobs()
    return jobs and jobs[jobName]
end
