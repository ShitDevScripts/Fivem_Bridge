local bossmenu = {}

RegisterNetEvent('Fivem_Bridge:client:openBossMenu:codem', function(jobName, jobType)
    if source ~= 65535 then return end
    ExecuteCommand('bossmenu')
end)

return bossmenu
