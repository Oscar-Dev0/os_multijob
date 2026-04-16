if Bridge.framework ~= 'qb' then return end

local QBCore = exports['qb-core']:GetCoreObject()

function Bridge.GetPlayer(source)
    return QBCore.Functions.GetPlayer(source)
end

function Bridge.GetPlayerByIdentifier(identifier)
    return QBCore.Functions.GetPlayerByCitizenId(identifier)
end

function Bridge.GetPlayerSource(player)
    return player and player.PlayerData and player.PlayerData.source
end

function Bridge.GetPlayerIdentifier(source)
    local player = Bridge.GetPlayer(source)
    return player and player.PlayerData and player.PlayerData.citizenid
end

function Bridge.GetPlayerPrimaryJobName(source)
    local player = Bridge.GetPlayer(source)
    return player and player.PlayerData and player.PlayerData.job and player.PlayerData.job.name
end

function Bridge.IsPlayerBoss(source)
    local player = Bridge.GetPlayer(source)
    return player and player.PlayerData and player.PlayerData.job and player.PlayerData.job.isboss or false
end

function Bridge.Notify(source, msg, msgType)
    TriggerClientEvent('QBCore:Notify', source, msg, msgType or 'inform')
end

function Bridge.HasPermission(source, permission)
    return QBCore.Functions.HasPermission(source, permission)
end

function Bridge.GetSharedJobs()
    local raw = QBCore.Shared.Jobs
    if not raw then return {} end
    local jobs = {}
    for name, data in pairs(raw) do
        local grades = {}
        if data.grades then
            for k, v in pairs(data.grades) do
                grades[tonumber(k)] = {
                    name = v.name,
                    payment = v.payment or 0,
                }
            end
        end
        jobs[name] = {
            label = data.label,
            grades = grades,
        }
    end
    return jobs
end

function Bridge.GetSharedJob(jobName)
    local raw = QBCore.Shared.Jobs
    if not raw or not raw[jobName] then return nil end
    local data = raw[jobName]
    local grades = {}
    if data.grades then
        for k, v in pairs(data.grades) do
            grades[tonumber(k)] = {
                name = v.name,
                payment = v.payment or 0,
            }
        end
    end
    return {
        label = data.label,
        grades = grades,
    }
end
