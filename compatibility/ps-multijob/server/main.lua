if not Config.Compatibility or not Config.Compatibility['ps-multijob'] then return end

-------------------------------------------------
-- Fake exports como si fuéramos ps-multijob
-- exports['ps-multijob']:GetJobs(...) etc.
-------------------------------------------------

local ensureJob = MJServer.ensureJob
local notify = MJServer.notify

local function RegisterPSExport(name, cb)
    AddEventHandler(('__cfx_export_ps-multijob_%s'):format(name), function(setCB)
        setCB(cb)
    end)
end

-------------------------------------------------
-- Exports
-------------------------------------------------

--- exports['ps-multijob']:GetJobs(citizenid)
RegisterPSExport('GetJobs', function(citizenid)
    if not citizenid then return {} end
    return Bridge.GetPlayerJobs(citizenid)
end)

--- exports['ps-multijob']:AddJob(citizenid, job, grade)
RegisterPSExport('AddJob', function(citizenid, job, grade)
    if not citizenid or not job then return end
    local jobInfo = Bridge.GetSharedJob(job)
    if not jobInfo then return end

    Bridge.AddPlayerToJob(citizenid, job, grade or 0)

    if Config.Debug then
        lib.print.info(('[multijob:ps-compat] AddJob "%s" grade %s → %s'):format(job, tostring(grade or 0), citizenid))
    end
end)

--- exports['ps-multijob']:RemoveJob(citizenid, job)
RegisterPSExport('RemoveJob', function(citizenid, job)
    if not citizenid or not job then return end

    local jobInfo = Bridge.GetSharedJob(job)
    if not jobInfo then return end

    Bridge.RemovePlayerFromJob(citizenid, job)

    if Config.Debug then
        lib.print.info(('[multijob:ps-compat] RemoveJob "%s" → %s'):format(job, citizenid))
    end
end)

--- exports['ps-multijob']:UpdateJobRank(citizenid, job, grade)
RegisterPSExport('UpdateJobRank', function(citizenid, job, grade)
    if not citizenid or not job then return end

    local jobs = Bridge.GetPlayerJobs(citizenid)
    if not jobs[job] then return end

    Bridge.AddPlayerToJob(citizenid, job, grade or 0)

    -- Si el job actual coincide, actualizar el job primario
    local player = Bridge.GetPlayerByIdentifier(citizenid)
    if player then
        local src = Bridge.GetPlayerSource(player)
        if src then
            local currentJob = Bridge.GetPlayerPrimaryJobName(src)
            if currentJob == job then
                Bridge.SetPrimaryJob(citizenid, job)
            end
        end
    end

    if Config.Debug then
        lib.print.info(('[multijob:ps-compat] UpdateJobRank "%s" grade %s → %s'):format(job, tostring(grade or 0), citizenid))
    end
end)

--- exports['ps-multijob']:getEmployees(jobName)
RegisterPSExport('getEmployees', function(jobName)
    if not jobName then return {} end

    local result = MySQL.query.await(
        'SELECT citizenid, grade FROM player_groups WHERE `group` = ? AND type = ?',
        { jobName, 'job' }
    )

    local employees = {}
    if result then
        for _, row in ipairs(result) do
            employees[#employees + 1] = {
                citizenid = row.citizenid,
                grade = row.grade,
            }
        end
    end
    return employees
end)

-------------------------------------------------
-- Eventos server
-------------------------------------------------

--- ps-multijob:server:removeJob — Elimina TODOS los jobs de un citizenid
--- (usado por qb-management al despedir un empleado)
RegisterNetEvent('ps-multijob:server:removeJob', function(targetCitizenId)
    if not targetCitizenId then return end

    local jobs = Bridge.GetPlayerJobs(targetCitizenId)
    for jobName in pairs(jobs) do
        Bridge.RemovePlayerFromJob(targetCitizenId, jobName)
    end

    if Config.Debug then
        lib.print.info(('[multijob:ps-compat] ps-multijob:server:removeJob → todos los jobs eliminados de %s'):format(targetCitizenId))
    end
end)

--- ps-multijob:changeJob — Cambiar job activo (trigger desde client)
RegisterNetEvent('ps-multijob:changeJob', function(cjob, cgrade)
    local src = source
    if not cjob then return end

    local identifier = Bridge.GetPlayerIdentifier(src)
    if not identifier then return end

    if cjob == 'unemployed' then
        Bridge.SetPrimaryJob(identifier, 'unemployed')
        return
    end

    local jobs = Bridge.GetPlayerJobs(identifier)
    if jobs[cjob] ~= nil then
        Bridge.SetPrimaryJob(identifier, cjob)
    end
end)

--- ps-multijob:removeJob — Quitar un job específico (trigger desde client)
RegisterNetEvent('ps-multijob:removeJob', function(job, grade)
    local src = source
    if not job then return end

    local identifier = Bridge.GetPlayerIdentifier(src)
    if not identifier then return end

    Bridge.RemovePlayerFromJob(identifier, job)

    if Config.Debug then
        lib.print.info(('[multijob:ps-compat] ps-multijob:removeJob → "%s" removido de %s'):format(job, identifier))
    end
end)

-------------------------------------------------
-- Callback compatible (ps-multijob:getJobs)
-------------------------------------------------
lib.callback.register('ps-multijob:getJobs', function(source)
    local identifier = Bridge.GetPlayerIdentifier(source)
    if not identifier then return { whitelist = {}, civilian = {} } end

    local jobs = Bridge.GetPlayerJobs(identifier)
    local sharedJobs = Bridge.GetSharedJobs()
    local whitelistedjobs = {}
    local civjobs = {}

    for job, grade in pairs(jobs) do
        local jobData = sharedJobs[job]
        if jobData then
            local gradeData = jobData.grades and jobData.grades[grade]
            local entry = {
                name = job,
                grade = grade,
                label = jobData.label,
                gradeLabel = gradeData and gradeData.name or '',
                salary = gradeData and gradeData.payment or 0,
            }
            civjobs[#civjobs + 1] = entry
        end
    end

    return {
        whitelist = whitelistedjobs,
        civilian = civjobs,
    }
end)

if Config.Debug then
    lib.print.info('[multijob] Compatibilidad ps-multijob SERVER activada (exports + eventos)')
end
