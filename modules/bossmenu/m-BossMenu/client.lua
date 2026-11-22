local bossmenu = {}

RegisterNetEvent('Fivem_Bridge:client:openBossMenu:m', function(jobName, jobType)
    if source ~= 65535 then return end
    if not jobName then
        return
    end

    exports['m-BossMenu']:OpenBossMenu(jobName, jobType)
end)

return bossmenu
