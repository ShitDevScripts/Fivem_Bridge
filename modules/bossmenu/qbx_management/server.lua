local bossmenu = {}

function bossmenu.openBossMenu(src, jobName, jobType)
    TriggerClientEvent('Fivem_Bridge:client:openBossMenu:qbx', src, jobName, jobType)
end

return bossmenu
