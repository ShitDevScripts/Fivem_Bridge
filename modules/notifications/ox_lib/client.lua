local notifications = {}

function notifications.notify(data)
    if not data then return end

    local payload = table.clone(data)
    payload.type = payload.type or "inform"
    payload.duration = payload.duration or 3000
    lib.notify(payload)
end

return notifications
