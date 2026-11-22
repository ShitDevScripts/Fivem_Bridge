local skills = {}

local resourceName = "evolent_skills"

function skills.GetResourceName()
    return resourceName
end
function skills.GetSkillLevel(src, skillName)
    local skillData = exports.evolent_skills:getSkillLevel(src, skillName)
    return skillData or 0
end

function skills.AddXp(src, skillName, amount)
    local skillData = exports.evolent_skills:getSkillLevel(src, skillName)
    if not skillData then return false, print("Skill not found") end
    exports.evolent_skills:addXp(src, skillName, amount)
    return true
end

function skills.RemoveXp(src, skillName, amount)
    local skillData = exports.evolent_skills:getSkillLevel(src, skillName)
    if not skillData then return false, print("Skill not found") end
    exports.evolent_skills:removeXp(src, skillName, amount)
    return true
end

return skills
