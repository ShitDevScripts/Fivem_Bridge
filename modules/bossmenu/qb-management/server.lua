local bossmenu = {}

function bossmenu.openBossMenu(src, jobName, jobType)
    TriggerClientEvent('Fivem_Bridge:client:openBossMenu:qb', src, jobName, jobType)
end

return bossmenu
