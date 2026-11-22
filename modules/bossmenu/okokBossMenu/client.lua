local bossmenu = {}

RegisterNetEvent('fivem_Bridge:client:openBossMenu:okok', function(jobName, jobType)
    if source ~= 65535 then return end
    TriggerEvent('okokBossMenu:openBossMenu')
end)

return bossmenu
