local bossmenu = {}

RegisterNetEvent('fivem_Bridge:client:openBossMenu:vms', function(jobName, jobType)
    if source ~= 65535 then return end
    if not jobName then
        return
    end

    exports['vms_bossmenu']:openBossMenu(jobName, jobType or 'job')
end)

return bossmenu
