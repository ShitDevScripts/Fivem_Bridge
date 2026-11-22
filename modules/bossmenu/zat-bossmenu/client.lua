local bossmenu = {}

RegisterNetEvent('Fivem_Bridge:client:openBossMenu:zat', function(jobName, jobType)
    if source ~= 65535 then return end
    exports['zat-bossmenu']:OpenBossMenu(jobType or jobName)
end)

return bossmenu
