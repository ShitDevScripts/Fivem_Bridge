local skills = {}

local resourceName = "OT_skills"

function skills.GetResourceName()
    return resourceName
end

function skills.GetSkillLevel(src, skillName)
    local skillData = exports.OT_skills:getSkill(src, skillName)
    return skillData.level or 0
end

function skills.AddXp(src, skillName, amount)
    local skillData = exports.OT_skills:getSkill(src, skillName)
    if not skillData then return false, print("Skill not found") end
    exports.OT_skills:addXP(src, skillName, amount)
    return true
end

function skills.RemoveXp(src, skillName, amount)
    local skillData = exports.OT_skills:getSkill(src, skillName)
    if not skillData then return false, print("Skill not found") end
    exports.OT_skills:removeXP(src, skillName, amount)
    return true
end

return skills
