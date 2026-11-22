local skills = {}

local resourceName = "OT_skills"

function skills.GetResourceName()
    return resourceName
end

function skills.GetSkillLevel(skillName)
    local skillData = exports.OT_skills:getSkill(skillName)
    return skillData.level or 0
end

return skills
