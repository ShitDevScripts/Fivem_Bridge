local bossmenu = {}

RegisterNetEvent('fivem_Bridge:client:openBossMenu:esx', function(jobName, jobType)
    if source ~= 65535 then return end
    TriggerEvent('esx_society:openBossMenu', jobName)
end)

return bossmenu
