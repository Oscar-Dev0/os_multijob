if Bridge.framework ~= 'qb' then return end

local QBCore = exports['qb-core']:GetCoreObject()

function Bridge.GetPlayerData()
    return QBCore.Functions.GetPlayerData()
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
