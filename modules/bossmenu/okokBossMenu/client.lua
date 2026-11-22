local bossmenu = {}

RegisterNetEvent('Fivem_Bridge:client:openBossMenu:okok', function(jobName, jobType)
    if source ~= 65535 then return end
    TriggerEvent('okokBossMenu:openBossMenu')
end)

return bossmenu
