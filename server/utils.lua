local function notify(src, msg, msgType)
    Bridge.Notify(src, msg, msgType)
end

local function getPlayer(source)
    return Bridge.GetPlayer(source)
end

local function hasJob(identifier, jobName)
    return Bridge.PlayerHasJob(identifier, jobName)
end

local function getJob(jobName)
    return Bridge.GetSharedJob(jobName)
end

local function ensureJob(jobName)
    local jobInfo = getJob(jobName)
    if not jobInfo then
        return nil, 'invalidJob'
    end
    return jobInfo
end

local function removeJobForCitizen(citizenid, jobName)
    if not citizenid or not jobName then
        return false, 'missing'
    end

    local jobInfo, err = ensureJob(jobName)
    if not jobInfo then
        return false, err
    end

    Bridge.RemovePlayerFromJob(citizenid, jobName)
    return true, jobInfo.label
end

local function notifyRemoval(targetIdentifier, jobLabel)
    local target = Bridge.GetPlayerByIdentifier(targetIdentifier)
    if target then
        local src = Bridge.GetPlayerSource(target)
        if src then
            notify(src, L('removed_from_job', jobLabel))
        end
    end
end

local function logDebug(success, jobName, citizenid, origin)
    if not Config.Debug then return end
    local src = origin and (' (%s)'):format(origin) or ''
    if success then
        lib.print.info(('[multijob] Job "%s" removido de %s%s'):format(jobName, citizenid, src))
    else
        lib.print.warn(('[multijob] Fallo al remover job "%s" de %s%s'):format(tostring(jobName), tostring(citizenid), src))
    end
end

local function removeJobIfSameJob(citizenid, jobName, origin)
    local callerJobName = Bridge.GetPlayerPrimaryJobName(source)
    if not callerJobName or callerJobName ~= jobName then return end

    local success, jobLabel = removeJobForCitizen(citizenid, jobName)
    logDebug(success, jobName, citizenid, origin)
    if success then
        notifyRemoval(citizenid, jobLabel)
    end
end

local function removeJobFromBossMenu(citizenid, jobName)
    local callerJobName = Bridge.GetPlayerPrimaryJobName(source)
    local isBoss = Bridge.IsPlayerBoss(source)
    if not isBoss or callerJobName ~= jobName then return end

    local success, jobLabel = removeJobForCitizen(citizenid, jobName)
    logDebug(success, jobName, citizenid, 'dw-bossmenu')
    if success then
        notifyRemoval(citizenid, jobLabel)
    end
end

MJServer.notify = notify
MJServer.getPlayer = getPlayer
MJServer.hasJob = hasJob
MJServer.getJob = getJob
MJServer.ensureJob = ensureJob
MJServer.removeJobForCitizen = removeJobForCitizen
MJServer.notifyRemoval = notifyRemoval
MJServer.logDebug = logDebug
MJServer.removeJobIfSameJob = removeJobIfSameJob
MJServer.removeJobFromBossMenu = removeJobFromBossMenu
