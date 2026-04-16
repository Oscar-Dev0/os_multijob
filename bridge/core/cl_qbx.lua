if Bridge.framework ~= 'qbx' then return end

function Bridge.GetPlayerData()
    if QBX and QBX.PlayerData then
        return QBX.PlayerData
    end
    return exports.qbx_core:GetPlayerData()
end

function Bridge.GetSharedJobs()
    return exports.qbx_core:GetJobs()
end

function Bridge.GetSharedJob(jobName)
    local jobs = Bridge.GetSharedJobs()
    return jobs and jobs[jobName]
end
