local skills = {}

skills.All = {}

local cachedXp = {}
local defaultSkills = { currentXP = 0, level = 1 }
local metadataKey = 'Fivem_Bridge_skills'

function skills.GetResourceName()
    return 'default'
end

local function savePlayerSkills(src, playerSkills)
    bridge.framework.setMetadata(src, { [metadataKey] = { value = playerSkills } })
end

local function getOrCreateSkill(src, skillName)
    if not src or not skillName then return table.clone(defaultSkills) end

    local playerSkills = bridge.framework.getPlayerMetadata(src, metadataKey) or {}
    if not playerSkills[skillName] then
        playerSkills[skillName] = table.clone(defaultSkills)
    end

    return playerSkills[skillName]
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
    if not name then return {} end

    skills.All[name] = {
        name = name,
        maxLevel = maxLevel or 99,
        baseXP = baseXP or 50,
    }
    return skills.All[name]
end

function skills.GetSkillLevel(src, skillName)
    if not src or not skillName then return 1 end

    local skill = getOrCreateSkill(src, skillName)
    return skill.level or 1
end

function skills.GetScaledXP(baseXP, playerLevel)
    return math.floor(baseXP * (1 + playerLevel * 0.05))
end

function skills.GetXP(src, skillName)
    if not src or not skillName then return 0 end

    local skill = getOrCreateSkill(src, skillName)
    return skill.currentXP or 0
end

function skills.GetXPRequiredForLevel(level)
    if not level or level < 1 then return 0 end
    if level == 1 then return 83 end
    return skills.GetXPForLevel(level)
end

function skills.AddXP(src, skillName, xp)
    if not src or not skillName then return false, 0, 0 end

    if not xp or xp <= 0 then
        xp = skills.GetScaledXP(50, skills.GetSkillLevel(src, skillName))
    end

    local playerSkills = bridge.framework.getPlayerMetadata(src, metadataKey) or {}
    local skill = playerSkills[skillName]
    if not skill then
        skill = table.clone(defaultSkills)
        playerSkills[skillName] = skill
    end

    local oldLevel = skill.level or 1
    local currentXP = (skill.currentXP or 0) + xp
    local xpNeeded = skills.GetXPRequiredForLevel(oldLevel + 1)

    if currentXP >= xpNeeded then
        currentXP = currentXP - xpNeeded
        oldLevel = oldLevel + 1
    end

    skill.level = oldLevel
    skill.currentXP = currentXP
    playerSkills[skillName] = skill

    savePlayerSkills(src, playerSkills)
    return true, oldLevel, currentXP
end

function skills.SetSkillLevel(src, skillName, level)
    if not src or not skillName or not level or level < 1 then return false end

    local playerSkills = bridge.framework.getPlayerMetadata(src, metadataKey) or {}
    local skill = playerSkills[skillName] or table.clone(defaultSkills)

    skill.level = math.min(math.max(1, level), 99)
    skill.currentXP = 0
    playerSkills[skillName] = skill

    savePlayerSkills(src, playerSkills)
    return true
end

function skills.SetXP(src, skillName, xp)
    if not src or not skillName or not xp or xp < 0 then return false end

    local playerSkills = bridge.framework.getPlayerMetadata(src, metadataKey) or {}
    local skill = playerSkills[skillName] or table.clone(defaultSkills)

    skill.currentXP = xp
    playerSkills[skillName] = skill

    savePlayerSkills(src, playerSkills)
    return true
end

return skills
