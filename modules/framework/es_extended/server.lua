local BridgePlayers = require '@fivem_Bridge/modules/framework/player_registry'
local ServerHelpers = require '@fivem_Bridge/modules/framework/server_helpers'

local ESX = exports.es_extended:getSharedObject()
local framework = {}

local dutyCache = ServerHelpers.createDutyCache(function(job)
    return job.onduty ~= false
end)

local function syncBridgePlayer(src)
    local player = ESX.GetPlayerFromId(src)
    local data = BridgePlayers.buildEsxBridgePlayerData(player)
    if data then
        BridgePlayers.sync(src, data)
    end
end

function framework.getIdentifier(src)
    local player = ESX.GetPlayerFromId(src)
    if not player then return nil end

    return player.getIdentifier and player.getIdentifier() or player.identifier
end

function framework.getSrcFromIdentifier(identifier)
    local player = ESX.GetPlayerFromIdentifier(identifier)
    if not player then return nil end

    return player.source
end

function framework.getCharacterName(identifier)
    local player = ESX.GetPlayerFromIdentifier(identifier)
    if not player then return nil end

    local first = player.variables and player.variables.firstName
    local last = player.variables and player.variables.lastName
    if first and last then
        return ("%s %s"):format(first, last), first, last
    end

    local name = player.name
    if type(name) ~= 'string' then return nil end

    local splitFirst, splitLast = name:match('^(%S+)%s+(.+)$')
    return name, splitFirst or name, splitLast
end

function framework.getFrameworkJobs()
    return ESX.GetJobs() or {}
end

function framework.isAdmin(src)
    local id = tonumber(src)
    if not id then return false end

    local player = ESX.GetPlayerFromId(id)
    if player and player.isAdmin then
        return player.isAdmin() and true or false
    end

    local aceSrc = tostring(id)
    return (IsPlayerAceAllowed(aceSrc, 'command')
        or IsPlayerAceAllowed(aceSrc, 'group.admin')) and true or false
end

function framework.setMetadata(src, payload)
    local player = ESX.GetPlayerFromId(src)
    if not player then return end

    if type(payload) ~= 'table' then return end

    for key, data in pairs(payload) do
        if type(data) == 'table' then
            if data.type == "add" or data.type == "remove" then
                local delta = tonumber(data.value)
                if delta then
                    local currentValue = tonumber(player.getMeta(key)) or 0
                    local newValue = data.type == "add" and (currentValue + delta) or (currentValue - delta)

                    player.setMeta(key, lib.math.clamp(newValue, 0, 100))
                end
            else
                player.setMeta(key, data.value)
            end
        end
    end
end

function framework.getPlayerMetadata(src, key)
    local player = ESX.GetPlayerFromId(src)
    if not player then return end

    return player.getMeta(key)
end

function framework.addMoney(src, moneyType, moneyAmount, reason)
    local player = ESX.GetPlayerFromId(src)
    if not player then return false end

    if moneyType == "cash" then
        moneyType = "money"
    end

    player.addAccountMoney(moneyType, moneyAmount, reason)
    return true
end

function framework.getMoney(src, moneyType)
    local player = ESX.GetPlayerFromId(src)
    if not player then return 0 end

    if moneyType == "cash" then
        moneyType = "money"
    end

    local account = player.getAccount(moneyType)
    if not account then return 0 end

    return account.money
end

function framework.removeMoney(src, moneyType, moneyAmount, reason)
    local player = ESX.GetPlayerFromId(src)
    if not player then return false end

    if moneyType == "cash" then
        moneyType = "money"
    end

    local amount = tonumber(moneyAmount)
    if not amount then return false end

    local account = player.getAccount(moneyType)
    if not account or account.money < amount then return false end

    player.removeAccountMoney(moneyType, moneyAmount, reason)
    return true
end

function framework.getPlayerJobData(src)
    local player = ESX.GetPlayerFromId(src)
    if not player then return nil end

    local job = player.getJob and player.getJob() or player.job
    if not job then return nil end

    return {
        jobName = job.name,
        jobLabel = job.label,
        grade = job.grade,
        gradeName = job.grade_label or job.grade_name,
        onDuty = job.onduty ~= false,
        isBoss = job.grade_name == 'boss',
    }
end

function framework.hasJob(src, job, grade, duty)
    local player = ESX.GetPlayerFromId(src)
    if not player then return false end

    local playerJob = player.getJob()
    if not playerJob or playerJob.name ~= job then return false end

    if grade then
        local gradeId = tonumber(playerJob.grade)
        if not gradeId or gradeId < grade then return false end
    end

    if duty then if playerJob.onduty == false then return false end end

    return true
end

function framework.setPlayerDuty(src, onDuty)
    local player = ESX.GetPlayerFromId(src)
    if not player then return false end

    local job = player.getJob()
    if not job or job.name == 'unemployed' then return false end

    player.setJob(job.name, job.grade, onDuty)
    dutyCache.syncOnDutyPlayer(src, player.getJob())
    return true
end

function framework.setPlayerJob(src, name, grade)
    local player = ESX.GetPlayerFromId(src)
    if not player then return false end

    if not ESX.DoesJobExist(name, grade) then return false end

    player.setJob(name, grade, true)
    return true
end

function framework.getPlayersByJob(jobName)
    local sources = {}

    if bridge.isHost then
        for src in pairs(dutyCache.getPlayersWithJob(jobName)) do
            sources[#sources + 1] = src
        end
        table.sort(sources)
        return sources
    end

    for _, playerSrc in ipairs(framework.getPlayers()) do
        local player = ESX.GetPlayerFromId(playerSrc)
        local job = player and player.getJob and player.getJob()
        if job and job.name == jobName then
            sources[#sources + 1] = playerSrc
        end
    end
    return sources
end

function framework.addHunger(src, value)
    local percent = lib.math.clamp(tonumber(value) or 0, -100, 100)
    TriggerClientEvent('esx_status:add', src, 'hunger', percent * 10000)
    return percent
end

function framework.addThirst(src, value)
    local percent = lib.math.clamp(tonumber(value) or 0, -100, 100)
    TriggerClientEvent('esx_status:add', src, 'thirst', percent * 10000)
    return percent
end

function framework.getOwnedVehicles(src)
    local identifier = framework.getIdentifier(src)
    if not identifier then return {} end

    local result = MySQL.query.await('SELECT vehicle, plate FROM owned_vehicles WHERE owner = ?', { identifier })
    if not result then return {} end

    local vehicles = {}
    for i = 1, #result do
        local row = result[i]
        local model = row.vehicle
        local decoded = json.decode(row.vehicle)
        if decoded and decoded.model then
            model = decoded.model
        end
        vehicles[#vehicles + 1] = { vehicle = model, plate = row.plate }
    end
    return vehicles
end

function framework.getPlayers()
    if ESX.GetPlayers ~= nil then
        return ESX.GetPlayers()
    end
    local playerList = {}
    local players = ESX.GetExtendedPlayers()
    for _, player in ipairs(players) do
        playerList[#playerList + 1] = tonumber(player.source)
    end
    return playerList
end

function framework.getPlayerDob(src)
    local player = ESX.GetPlayerFromId(src)
    if not player then return nil end
    return player.get("dateofbirth")
end

if bridge.isHost then
    local loadedPlayers = {}

    local function announcePlayerLoaded(src, identifier)
        src = tonumber(src)
        if not src or not identifier or loadedPlayers[src] == identifier then
            return false
        end
        loadedPlayers[src] = identifier
        TriggerEvent('Fivem_Bridge:server:playerLoad', src)
        return true
    end

    CreateThread(function()
        for _, playerSrc in ipairs(framework.getPlayers()) do
            local player = ESX.GetPlayerFromId(playerSrc)
            if player then
                dutyCache.syncOnDutyPlayer(playerSrc, player.getJob())
                syncBridgePlayer(playerSrc)
                announcePlayerLoaded(playerSrc, player.getIdentifier())
            end
        end
        dutyCache.syncGlobalJobCounts()
    end)

    AddEventHandler('esx:playerLoaded', function(src, xPlayer)
        src = tonumber(src)
        if not src then return end

        local player = xPlayer or ESX.GetPlayerFromId(src)
        if player then
            dutyCache.syncOnDutyPlayer(src, player.getJob())
            syncBridgePlayer(src)
        end

        local identifier = player and player.getIdentifier() or framework.getIdentifier(src)
        if announcePlayerLoaded(src, identifier) then return end
        if identifier then return end

        SetTimeout(0, function()
            announcePlayerLoaded(src, framework.getIdentifier(src))
        end)
    end)

    AddEventHandler("esx:playerLogout", function(src)
        TriggerEvent("Fivem_Bridge:server:playerUnload", src)
    end)

    AddEventHandler("esx:setJob", function(src, job)
        src = tonumber(src)
        if not src or not job then return end
        dutyCache.syncOnDutyPlayer(src, job)
        syncBridgePlayer(src)
        TriggerEvent('Fivem_Bridge:server:playerJobUpdate', src, job.name)
    end)

    AddEventHandler("playerDropped", function()
        local src = tonumber(source)
        if not src then return end
        TriggerEvent('Fivem_Bridge:server:playerUnload', src)
    end)

    AddEventHandler("Fivem_Bridge:server:playerUnload", function(src)
        src = tonumber(src)
        if not src then return end
        loadedPlayers[src] = nil
        dutyCache.clearOnDutyPlayer(src)
        BridgePlayers.remove(src)
    end)

    lib.callback.register('Fivem_Bridge:callback:getFrameworkJobs', function()
        return framework.getFrameworkJobs()
    end)
end

ServerHelpers.attachSharedFrameworkApi(framework, dutyCache, function(itemName, handler)
    return ESX.RegisterUsableItem(itemName, handler)
end)

return BridgePlayers.attachBridgePlayerApi(framework)
