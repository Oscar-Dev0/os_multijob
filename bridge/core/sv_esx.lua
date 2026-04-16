if Bridge.framework ~= 'esx' then return end

local ESX = exports['es_extended']:getSharedObject()

function Bridge.GetPlayer(source)
    return ESX.GetPlayerFromId(source)
end

function Bridge.GetPlayerByIdentifier(identifier)
    return ESX.GetPlayerFromIdentifier(identifier)
end

function Bridge.GetPlayerSource(player)
    return player and player.source
end

function Bridge.GetPlayerIdentifier(source)
    local player = Bridge.GetPlayer(source)
    return player and player.identifier
end

function Bridge.GetPlayerPrimaryJobName(source)
    local player = Bridge.GetPlayer(source)
    if not player then return nil end
    local job = player.getJob()
    return job and job.name
end

function Bridge.IsPlayerBoss(source)
    local player = Bridge.GetPlayer(source)
    if not player then return false end
    local job = player.getJob()
    if not job then return false end
    local jobs = ESX.GetJobs()
    local jobData = jobs and jobs[job.name]
    if not jobData or not jobData.grades then return false end
    local maxGrade = 0
    for k in pairs(jobData.grades) do
        local g = tonumber(k) or 0
        if g > maxGrade then maxGrade = g end
    end
    return job.grade >= maxGrade
end

function Bridge.Notify(source, msg, msgType)
    TriggerClientEvent('esx:showNotification', source, msg)
end

function Bridge.HasPermission(source, permission)
    local player = Bridge.GetPlayer(source)
    if not player then return false end
    local group = player.getGroup()
    return group == permission or group == 'admin' or group == 'superadmin'
end

function Bridge.GetSharedJobs()
    local raw = ESX.GetJobs()
    if not raw then return {} end
    local jobs = {}
    for name, data in pairs(raw) do
        local grades = {}
        if data.grades then
            for k, v in pairs(data.grades) do
                grades[tonumber(k) or 0] = {
                    name = v.label or v.name,
                    payment = v.salary or 0,
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
    local raw = ESX.GetJobs()
    if not raw or not raw[jobName] then return nil end
    local data = raw[jobName]
    local grades = {}
    if data.grades then
        for k, v in pairs(data.grades) do
            grades[tonumber(k) or 0] = {
                name = v.label or v.name,
                payment = v.salary or 0,
            }
        end
    end
    return {
        label = data.label,
        grades = grades,
    }
end

-------------------------------------------------
-- Auto-registrar job al cambiar (esx:setJob)
-------------------------------------------------
AddEventHandler('esx:setJob', function(src, job, lastJob)
    if not Config.AutoRegisterOnJobChange then return end
    if not job or not job.name then return end

    local jobName = job.name
    if Config.IgnoredJobs[jobName] then return end

    local player = ESX.GetPlayerFromId(src)
    if not player then return end

    local identifier = player.identifier
    if not identifier then return end

    local jobGrade = job.grade or 0

    local jobs = Bridge.GetPlayerJobs(identifier)
    local count = 0
    for _ in pairs(jobs) do count = count + 1 end

    local maxJobs = Config.MaxJobs or 3
    local group = player.getGroup()
    if group == 'admin' or group == 'superadmin' then
        maxJobs = math.huge
    end

    if count >= maxJobs and not jobs[jobName] then return end

    if not jobs[jobName] or jobs[jobName] ~= jobGrade then
        Bridge.AddPlayerToJob(identifier, jobName, jobGrade)
        if Config.Debug then
            lib.print.info(('[multijob] Auto-registrado job "%s" grade %s para %s'):format(jobName, jobGrade, identifier))
        end
    end
end)
