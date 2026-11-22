if bridge.context == 'client' and bridge.isHost then
    RegisterNetEvent('fivem_Bridge:client:notify', function(data)
        if source ~= 65535 then return end
        bridge.notifications.notify(data)
    end)

    local notifyProvider = (Config.Providers and Config.Providers.notifications) or Config.Notifications
    if notifyProvider ~= 'internal' then
        RegisterNUICallback('notify:ready', function(_, cb)
            cb({ ok = true })
        end)
    end
end
