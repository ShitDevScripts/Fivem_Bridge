local ClientHelpers = bridgeRequire('modules/framework/client_helpers')

local kora = exports.kora_core

local function getPlayerData()
    return kora:getPlayerData()
end

local function getJob()
    return kora:getJob()
end

local function gradeLevel(job)
    local grade = job and job.grade
    if type(grade) == 'table' then grade = grade.level end
    grade = tonumber(grade)
    if not grade then return nil end
    return math.max(grade - 1, 0)
end

local function notifyJobUpdate()
    local job = getJob()
    if not job then return end

    TriggerEvent('Fivem_Bridge:client:playerJobUpdate', job.name, job.label, job.grade and job.grade.name, gradeLevel(job))
end

if bridge.isHost then
    local loadedCharId

    AddEventHandler('kora_core:client:playerLoaded', function(mirror)
        local charId = type(mirror) == 'table' and mirror.citizenid or nil
        if charId and charId == loadedCharId then return end

        loadedCharId = charId
        TriggerEvent('Fivem_Bridge:client:playerLoad')
    end)

    local serverId = GetPlayerServerId(PlayerId())

    AddStateBagChangeHandler('kora_core:loggedIn', ('player:%d'):format(serverId), function(_, _, value)
        if value ~= false then return end

        loadedCharId = nil
        TriggerEvent('Fivem_Bridge:client:playerUnload')
    end)

    kora:onPlayerDataChange({ 'job' }, function()
        notifyJobUpdate()
    end)
end

local framework = {}

function framework.getPlayerData()
    return getPlayerData()
end

function framework.getPlayerMetadata(key)
    local data = getPlayerData()
    if not data or not data.metadata then return end
    return data.metadata[key]
end

function framework.getStress()
    local data = getPlayerData()
    if not data or not data.metadata then return 0 end
    return data.metadata.stress or 0
end

function framework.getHunger()
    local data = getPlayerData()
    if not data or not data.metadata then return 100 end
    return data.metadata.hunger or 100
end

function framework.getThirst()
    local data = getPlayerData()
    if not data or not data.metadata then return 100 end
    return data.metadata.thirst or 100
end

function framework.setStatus(statusType, value)
    local data = getPlayerData()
    if not data then return end

    data.metadata = data.metadata or {}
    if statusType == 'stress' or statusType == 'hunger' or statusType == 'thirst' then
        data.metadata[statusType] = value
    end
end

function framework.isOnDuty()
    local job = getJob()
    return job ~= nil and job.onduty == true
end

function framework.getPlayerJobData()
    local job = getJob()
    if not job or job.grade == nil then return end

    return {
        jobName = job.name,
        jobLabel = job.label,
        grade = gradeLevel(job),
        gradeName = job.grade.name,
        onDuty = job.onduty == true,
        isBoss = job.isboss == true,
    }
end

function framework.hasJob(job, grade, duty)
    local playerJob = getJob()
    if not playerJob or playerJob.name ~= job then return false end

    if grade then
        local level = gradeLevel(playerJob)
        if not level or level < grade then return false end
    end

    if duty and not playerJob.onduty then return false end
    return true
end

function framework.getFrameworkJobs()
    local jobs = {}

    for _, record in ipairs(kora:allShared('jobs') or {}) do
        local grades = {}
        for index, grade in ipairs(record.grades or {}) do
            grades[index - 1] = grade
        end

        jobs[record.name] = {
            label = record.label,
            type = record.type,
            defaultDuty = record.defaultDuty,
            offDutyPay = record.offDutyPay,
            grades = grades,
        }
    end

    return jobs
end

function framework.getIdentifier()
    local data = getPlayerData()
    return data and data.citizenid
end

function framework.getCharacterName()
    local data = getPlayerData()
    if not data or not data.charinfo then return end

    local first = data.charinfo.firstname
    local last = data.charinfo.lastname
    if not first or not last then return end

    return ('%s %s'):format(first, last), first, last
end

function framework.getIsPlayerLoaded()
    return LocalPlayer.state['kora_core:loggedIn'] == true
end

function framework.getAccountBalance(moneyType)
    local data = getPlayerData()
    if not data or not data.money then return 0 end
    if moneyType == 'money' then moneyType = 'cash' end
    return data.money[moneyType] or 0
end

function framework.isPlayerDead()
    local data = getPlayerData()
    if not data or not data.metadata then return false end
    return data.metadata.isdead or data.metadata.inlaststand or false
end

function framework.getPlayerDob()
    local data = getPlayerData()
    return data and data.charinfo and data.charinfo.birthdate
end

return ClientHelpers.attachBridgeClientApi(framework)
