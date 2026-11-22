local bossmenu = {}

RegisterNetEvent('fivem_Bridge:client:openBossMenu:qb', function(jobName, jobType)
    if source ~= 65535 then return end
    TriggerEvent('qb-bossmenu:client:OpenMenu')
end)

return bossmenu
