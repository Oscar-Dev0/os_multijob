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

-------------------------------------------------
-- Auto-registrar job al cambiar (QBCore:Server:OnJobUpdate)
-------------------------------------------------
AddEventHandler('QBCore:Server:OnJobUpdate', function(src, newJob)
    if not Config.AutoRegisterOnJobChange then return end
    if not newJob or not newJob.name then return end

    local jobName = newJob.name
    if Config.IgnoredJobs[jobName] then return end

    local player = QBCore.Functions.GetPlayer(src)
    if not player then return end

    local citizenid = player.PlayerData.citizenid
    if not citizenid then return end

    local jobGrade = newJob.grade and newJob.grade.level or 0

    local jobs = Bridge.GetPlayerJobs(citizenid)
    local count = 0
    for _ in pairs(jobs) do count = count + 1 end

    local maxJobs = Config.MaxJobs or 3
    if QBCore.Functions.HasPermission(src, Config.AdminPermission or 'admin') then
        maxJobs = math.huge
    end

    if count >= maxJobs and not jobs[jobName] then return end

    if not jobs[jobName] or jobs[jobName] ~= jobGrade then
        Bridge.AddPlayerToJob(citizenid, jobName, jobGrade)
        if Config.Debug then
            lib.print.info(('[multijob] Auto-registrado job "%s" grade %s para %s'):format(jobName, jobGrade, citizenid))
        end
    end
end)
