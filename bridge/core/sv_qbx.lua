if Bridge.framework ~= 'qbx' then return end

function Bridge.GetPlayer(source)
    return exports.qbx_core:GetPlayer(source)
end

function Bridge.GetPlayerByIdentifier(identifier)
    return exports.qbx_core:GetPlayerByCitizenId(identifier)
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
    exports.qbx_core:Notify(source, msg, msgType or 'inform')
end

function Bridge.HasPermission(source, permission)
    return exports.qbx_core:HasPermission(source, permission)
end

function Bridge.GetSharedJobs()
    return exports.qbx_core:GetJobs()
end

function Bridge.GetSharedJob(jobName)
    return exports.qbx_core:GetJob(jobName)
end
