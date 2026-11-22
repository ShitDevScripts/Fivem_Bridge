local bossmenu = {}

function bossmenu.openBossMenu(src, jobName, jobType)
    TriggerClientEvent('fivem_Bridge:client:openBossMenu:zat', src, jobName, jobType)
end

return bossmenu
