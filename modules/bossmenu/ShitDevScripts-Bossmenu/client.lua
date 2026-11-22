local bossmenu = {}

RegisterNetEvent("Fivem_Bridge:client:openBossMenu:shdev", function(jobName, jobType)
    if source ~= 65535 then return end
    TriggerServerEvent("bm:server:targetOpen", jobName)
end)

return bossmenu
