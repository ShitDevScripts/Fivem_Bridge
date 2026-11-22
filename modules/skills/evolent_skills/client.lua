local skills = {}
local resourceName = "evolent_skills"

function skills.GetResourceName()
    return resourceName
end

function skills.GetSkillLevel(skillName)
    local skillData = exports.evolent_skills:getSkillLevel(skillName)
    return skillData or 0
end

return skills
