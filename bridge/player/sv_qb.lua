if Bridge.framework ~= 'qb' then return end

--- QB usa la tabla player_groups en SQL para multijob

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
    if player and player.PlayerData and player.PlayerData.job and player.PlayerData.job.name == jobName then
        player.Functions.SetJob('unemployed', 0)
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
    player.Functions.SetJob(jobName, grade)
end

function Bridge.PlayerHasJob(identifier, jobName)
    local result = MySQL.scalar.await('SELECT 1 FROM player_groups WHERE citizenid = ? AND `group` = ? AND type = ?', { identifier, jobName, 'job' })
    return result ~= nil
end

function Bridge.SetJobDuty(source, onDuty)
    local player = Bridge.GetPlayer(source)
    if not player then return end
    player.PlayerData.job.onduty = onDuty
    TriggerClientEvent('QBCore:Client:SetDuty', source, onDuty)
end

lib.callback.register('multijob:server:getPlayerJobs', function(source)
    local identifier = Bridge.GetPlayerIdentifier(source)
    if not identifier then return {} end
    return Bridge.GetPlayerJobs(identifier)
end)
