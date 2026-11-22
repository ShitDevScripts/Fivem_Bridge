local notifications = {}

function notifications.notify(src, data)
    if not data then return end
    TriggerClientEvent('fivem_Bridge:client:notify', src, data)
end

return notifications
