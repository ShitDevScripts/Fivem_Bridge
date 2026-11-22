local skills = {}

local resourceName = "pickle_xp"

function skills.GetResourceName()
    return resourceName
end

function skills.GetSkillLevel(src, skillName)
    local skillData = exports.pickle_xp:GetPlayerLevel(src, skillName)
    return skillData or 0
end

function skills.AddXp(src, skillName, amount)
    local skillData = exports.pickle_xp:GetPlayerLevel(src, skillName)
    if not skillData then return false, print("^6 Skill "..skillName.." not found ^0 ") end

    exports.pickle_xp:AddPlayerXP(src, skillName, amount)
    return true
end

function skills.RemoveXp(src, skillName, amount)
    local skillData = exports.pickle_xp:GetPlayerLevel(src, skillName)
    if not skillData then return false, print("Skill not found") end
    exports.pickle_xp:RemovePlayerXP(src, skillName, amount)
    return true
end

return skills
