local bossmenu = {}

function bossmenu.openBossMenu(src, jobName, jobType)
    TriggerClientEvent('Fivem_Bridge:client:openBossMenu:esx', src, jobName, jobType)
end

return bossmenu
