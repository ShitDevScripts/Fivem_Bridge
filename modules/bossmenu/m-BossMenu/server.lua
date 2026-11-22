local bossmenu = {}

function bossmenu.openBossMenu(src, jobName, jobType)
    TriggerClientEvent('fivem_Bridge:client:openBossMenu:m', src, jobName, jobType)
end

return bossmenu
