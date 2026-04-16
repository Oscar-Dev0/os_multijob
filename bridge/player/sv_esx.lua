if Bridge.framework ~= 'esx' then return end

--- ESX usa la tabla player_groups en SQL para multijob

function Bridge.GetPlayerJobs(identifier)
    local result = MySQL.query.await('SELECT `group`, grade FROM player_groups WHERE citizenid = ? AND type = ?', { identifier, 'job' })
    local jobs = {}
    if result then
        for _, row in ipairs(result) do
            jobs[row.group] = row.grade
        end
    end
    return jobs
end

function Bridge.AddPlayerToJob(identifier, jobName, grade)
    MySQL.insert.await(
        'INSERT INTO player_groups (citizenid, `group`, type, grade) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE grade = VALUES(grade)',
        { identifier, jobName, 'job', grade or 0 }
    )
end

function Bridge.RemovePlayerFromJob(identifier, jobName)
    MySQL.query.await('DELETE FROM player_groups WHERE citizenid = ? AND `group` = ? AND type = ?', { identifier, jobName, 'job' })
    local player = Bridge.GetPlayerByIdentifier(identifier)
    if player then
        local job = player.getJob()
        if job and job.name == jobName then
            player.setJob('unemployed', 0)
        end
    end
end

function Bridge.SetPrimaryJob(identifier, jobName)
    local player = Bridge.GetPlayerByIdentifier(identifier)
    if not player then return end
    local grade = 0
    if jobName ~= 'unemployed' then
        local result = MySQL.scalar.await('SELECT grade FROM player_groups WHERE citizenid = ? AND `group` = ? AND type = ?', { identifier, jobName, 'job' })
        grade = result or 0
    end
    player.setJob(jobName, grade)
end

function Bridge.PlayerHasJob(identifier, jobName)
    local result = MySQL.scalar.await('SELECT 1 FROM player_groups WHERE citizenid = ? AND `group` = ? AND type = ?', { identifier, jobName, 'job' })
    return result ~= nil
end

function Bridge.SetJobDuty(source, onDuty)
    TriggerClientEvent('multijob:client:setDuty', source, onDuty)
end

lib.callback.register('multijob:server:getPlayerJobs', function(source)
    local identifier = Bridge.GetPlayerIdentifier(source)
    if not identifier then return {} end
    return Bridge.GetPlayerJobs(identifier)
end)
