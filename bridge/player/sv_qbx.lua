if Bridge.framework ~= 'qbx' then return end

--- QBX usa su sistema nativo de multijob, no necesita SQL

function Bridge.GetPlayerJobs(identifier)
    local player = exports.qbx_core:GetPlayerByCitizenId(identifier)
    if not player or not player.PlayerData then return {} end
    return player.PlayerData.jobs or {}
end

function Bridge.AddPlayerToJob(identifier, jobName, grade)
    exports.qbx_core:AddPlayerToJob(identifier, jobName, grade or 0)
end

function Bridge.RemovePlayerFromJob(identifier, jobName)
    exports.qbx_core:RemovePlayerFromJob(identifier, jobName)
end

function Bridge.SetPrimaryJob(identifier, jobName)
    exports.qbx_core:SetPlayerPrimaryJob(identifier, jobName)
end

function Bridge.PlayerHasJob(identifier, jobName)
    local jobs = Bridge.GetPlayerJobs(identifier)
    return jobs[jobName] ~= nil
end

function Bridge.SetJobDuty(source, onDuty)
    local player = Bridge.GetPlayer(source)
    if player and player.Functions then
        player.Functions.SetJobDuty(onDuty)
    end
end
