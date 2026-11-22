local bossmenu = {}

function bossmenu.openBossMenu(src, jobName, jobType)
    TriggerClientEvent('fivem_Bridge:client:openBossMenu:vms', src, jobName, jobType)
end

return bossmenu
