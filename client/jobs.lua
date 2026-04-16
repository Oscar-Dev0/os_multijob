local sendMessage = MJClient.sendMessage

local function buildJobMenu(playerJobs, primaryJob, sharedJobs)
    local jobMenu = {}

    -- Siempre mostrar civil/desempleado aunque falten datos del jugador o del sharedJobs
    local civilianJob = sharedJobs and sharedJobs.unemployed or { label = L('civilian'), grades = { [0] = { name = L('civilian'), payment = 0 } } }
    local gradeData = (civilianJob.grades and civilianJob.grades[0]) or { name = L('civilian'), payment = 0 }
    local isPrimary = primaryJob and primaryJob.name == 'unemployed'
    jobMenu[#jobMenu + 1] = {
        title = civilianJob.label or L('civilian'),
        description = L('grade_format_zero', gradeData.name or L('civilian'), gradeData.payment or 0),
        disabled = isPrimary,
        jobName = 'unemployed',
        duty = isPrimary and (primaryJob.onduty or false) or false,
    }

    if not playerJobs then return jobMenu end

    for job, grade in pairs(playerJobs) do
        local jobData = sharedJobs and sharedJobs[job]
        if not jobData then
            if Config.Debug then lib.print.warn(('[multijob] job "%s" no existe en sharedJobs, se omite'):format(tostring(job))) end
        else
            local gradeDataJob = jobData.grades and jobData.grades[grade]
            if not gradeDataJob then
                if Config.Debug then lib.print.warn(('[multijob] job "%s" no tiene grade %s en sharedJobs, se omite'):format(tostring(job), tostring(grade))) end
            else
                local isPrimaryJob = primaryJob and primaryJob.name == job
                local payment = gradeDataJob.payment or 0
                jobMenu[#jobMenu + 1] = {
                    title = jobData.label,
                    description = L('grade_format', gradeDataJob.name, grade, payment),
                    disabled = isPrimaryJob,
                    jobName = job,
                    duty = isPrimaryJob and (primaryJob.onduty or false) or false,
                }
            end
        end
    end

    return jobMenu
end

local function refreshJobs(cb)
    local sharedJobs = Bridge.GetSharedJobs()
    local playerJobs = Bridge.GetPlayerJobs()
    local primaryJob = Bridge.GetPrimaryJob()
    local menu = buildJobMenu(playerJobs, primaryJob, sharedJobs)
    cb(menu)
end

RegisterNUICallback('getLocale', function(_, cb)
    cb({ locale = GetLocale() })
end)

RegisterNUICallback('getJobs', function(_, cb)
    refreshJobs(cb)
end)

RegisterNUICallback('toggleDuty', function(_, cb)
    Bridge.ToggleDuty()
    cb(true)
    Wait(500)
    sendMessage({ action = 'update-jobs' })
end)

RegisterNUICallback('removeJob', function(job, cb)
    lib.callback('multijob:server:deleteJob', false, function()
        cb(true)
        sendMessage({ action = 'update-jobs' })
    end, job)
end)

RegisterNUICallback('changeJob', function(job, cb)
    lib.callback('multijob:server:changeJob', false, function()
        cb(true)
        sendMessage({ action = 'update-jobs' })
    end, job)
end)

local function assignJob(citizenid, job, grade)
    if not citizenid or not job then return false end

    local perms = lib.callback.await('multijob:server:hasPermissions')
    if not perms then return false end

    local sharedJobs = Bridge.GetSharedJobs()
    local jobInfo = sharedJobs and sharedJobs[job]
    if not jobInfo then
        if Config.Debug then lib.print.warn(('[multijob] job "%s" no existe en sharedJobs, se omite asignación'):format(tostring(job))) end
        return false
    end

    local gradeData = grade and jobInfo.grades and jobInfo.grades[grade]
    if not gradeData then
        for g in pairs(jobInfo.grades) do
            grade = g
            break
        end
        if Config.Debug then lib.print.info(('[multijob] job "%s" sin grade específico, se usa grade %s'):format(tostring(job), tostring(grade))) end
    end

    return lib.callback.await('multijob:server:asignjob', false, {
        citizenid = citizenid,
        job = job,
        grade = grade,
    })
end

RegisterNetEvent('multijob:client:assignJob', function(citizenid, job, grade)
    assignJob(citizenid, job, grade)
end)

RegisterNUICallback('asignjob', function(data, cb)
    assignJob(data.citizenid, data.job, data.grade)
    cb(true)
end)

Bridge.onJobUpdate = function()
    sendMessage({ action = 'update-jobs' })
end
