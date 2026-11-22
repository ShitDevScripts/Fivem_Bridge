local bossmenu = {}

RegisterNetEvent('fivem_Bridge:client:openBossMenu:qbx', function(jobName, jobType)
    if source ~= 65535 then return end
    exports.qbx_management:OpenBossMenu(jobType or jobName)
end)

return bossmenu
