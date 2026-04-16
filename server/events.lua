local removeJobIfSameJob = MJServer.removeJobIfSameJob
local removeJobFromBossMenu = MJServer.removeJobFromBossMenu

RegisterNetEvent('multijob:inyect:kickMasterjob', function(citizenid, jobName)
    removeJobIfSameJob(citizenid, jobName, 'kickMasterjob')
end)

RegisterNetEvent('multijob:inyect:SetPoliceJob', function(citizenid, jobName)
    removeJobIfSameJob(citizenid, jobName, 'SetPoliceJob')
end)

AddEventHandler('dw-bossmenu:server:RemoveEmployee', removeJobFromBossMenu)
RegisterNetEvent('dw-bossmenu:server:RemoveEmployee', removeJobFromBossMenu)
