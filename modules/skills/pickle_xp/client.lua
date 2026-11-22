local skills = {}
local resourceName = "pickle_xp"

function skills.GetResourceName()
    return resourceName
end

function skills.GetSkillLevel(skillName)
    local skillData = exports.pickle_xp:GetLevel(skillName)
    return skillData or 0
end

return skills
