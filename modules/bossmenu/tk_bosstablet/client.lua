local bossmenu = {}

RegisterNetEvent('Fivem_Bridge:client:openBossMenu:tk', function(jobName, jobType)
    if source ~= 65535 then return end
    exports.tk_bosstablet:openBossMenu()
end)

return bossmenu
