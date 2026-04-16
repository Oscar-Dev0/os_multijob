local ADMIN_PERMISSION = MJServer.ADMIN_PERMISSION
local notify = MJServer.notify
local hasJob = MJServer.hasJob
local ensureJob = MJServer.ensureJob

lib.callback.register('multijob:server:hasPermissions', function(source)
    return Bridge.HasPermission(source, ADMIN_PERMISSION)
end)

lib.callback.register('multijob:server:getSharedJobs', function(source)
    return Bridge.GetSharedJobs()
end)

-- @table data = { job = string, grade = number, citizenid = string }
lib.callback.register('multijob:server:asignjob', function(source, data)
    if not data or not data.citizenid or not data.job then
        return false, 'missingData'
    end

    if not Bridge.HasPermission(source, ADMIN_PERMISSION) then
        notify(source, L('no_permission'), 'error')
        return false, 'noPermission'
    end

    local target = Bridge.GetPlayerByIdentifier(data.citizenid)
    if not target then
        notify(source, L('player_not_found'), 'error')
        return false, 'notFound'
    end

    local jobInfo, err = ensureJob(data.job)
    if not jobInfo then
        notify(source, L('invalid_job'), 'error')
        return false, err
    end

    if hasJob(data.citizenid, data.job) then
        notify(source, L('already_has_job', jobInfo.label), 'error')
        return false, 'alreadyHas'
    end

    local grade = data.grade
    if grade == nil then
        grade = jobInfo.grades and next(jobInfo.grades) or grade
    end

    Bridge.AddPlayerToJob(data.citizenid, data.job, grade)
    Bridge.SetPrimaryJob(data.citizenid, data.job)

    local targetSrc = Bridge.GetPlayerSource(target)
    notify(source, L('assigned_job_to', jobInfo.label, data.citizenid))
    if targetSrc then
        notify(targetSrc, L('you_were_assigned', jobInfo.label))
    end
    return true
end)

lib.callback.register('multijob:server:changeJob', function(source, job)
    local callerJobName = Bridge.GetPlayerPrimaryJobName(source)

    if callerJobName == job then
        notify(source, L('already_current_job'), 'error')
        return
    end

    local jobInfo = Bridge.GetSharedJob(job)
    if not jobInfo then
        notify(source, L('invalid_job'), 'error')
        return
    end

    local identifier = Bridge.GetPlayerIdentifier(source)
    if not identifier then return end

    if job ~= "unemployed" and not hasJob(identifier, job) then
        notify(source, L('not_own_job'), 'error')
        return
    end

    Bridge.SetPrimaryJob(identifier, job)
    notify(source, L('job_changed_to', jobInfo.label))
    Bridge.SetJobDuty(source, false)
    return true
end)

lib.callback.register('multijob:server:deleteJob', function(source, job)
    local jobInfo = Bridge.GetSharedJob(job)
    if not jobInfo then
        notify(source, L('invalid_job'), 'error')
        return
    end

    local identifier = Bridge.GetPlayerIdentifier(source)
    if not identifier then return end

    Bridge.RemovePlayerFromJob(identifier, job)
    notify(source, L('job_deleted', jobInfo.label))
    return true
end)

exports('SetJob', function(citizenid, jobName, grade)
    local jobInfo = ensureJob(jobName)
    if not jobInfo then
        return false, 'invalidJob'
    end

    Bridge.AddPlayerToJob(citizenid, jobName, grade)
    return true, jobInfo.label
end)

exports('RemoveJob', function(citizenid, jobName)
    local jobInfo, err = ensureJob(jobName)
    if not jobInfo then
        return false, err
    end

    Bridge.RemovePlayerFromJob(citizenid, jobName)
    return true, jobInfo.label
end)
