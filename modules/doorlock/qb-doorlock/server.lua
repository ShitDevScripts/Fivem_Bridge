local doorlock = {}

function doorlock.ToggleDoorLock(doorID, toggle)
    TriggerClientEvent('qb-doorlock:client:setState', -1, 0, doorID, toggle, false, false, false)
    return true
end

function doorlock.GetResourceName()
    return 'qb-doorlock'
end

return doorlock
