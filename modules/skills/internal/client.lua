local skills = {}

skills.All = {}

local cachedXp = {}
local metadataKey = 'Fivem_Bridge_skills'

function skills.GetResourceName()
    return 'default'
end

function skills.GetXPForLevel(level)
    if not level or level < 1 then return 0 end
    if level == 1 then return 0 end
    if cachedXp[level] then return cachedXp[level] end

    local xp = 0
    for n = 1, level - 1 do
        xp = xp + math.floor(n + 300 * (2 ^ (n / 7)))
    end

    local result = math.floor(xp / 4)
    cachedXp[level] = result
    return result
end

function skills.Create(name, maxLevel, baseXP)
    if not name then return end

    skills.All[name] = {
        name = name,
        maxLevel = maxLevel or 99,
        baseXP = baseXP or 50,
    }
    return skills.All[name]
end

function skills.GetScaledXP(baseXP, playerLevel)
    return math.floor(baseXP * (1 + playerLevel * 0.05))
end

function skills.GetXPRequiredForLevel(level)
    if not level or level < 1 then return 0 end
    if level == 1 then return 83 end
    return skills.GetXPForLevel(level)
end

function skills.GetSkillLevel(skillName)
    if not skillName then return 0 end

    local playerSkills = bridge.framework.getPlayerMetadata(metadataKey)
    if not playerSkills or not playerSkills[skillName] then return 1 end
    return playerSkills[skillName].level or 1
end

function skills.GetXP(skillName)
    if not skillName then return 0 end

    local playerSkills = bridge.framework.getPlayerMetadata(metadataKey)
    if not playerSkills or not playerSkills[skillName] then return 1 end
    return playerSkills[skillName].currentXP or 1
end

return skills
