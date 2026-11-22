local doorlock = {}

function doorlock.ToggleDoorLock(doorID, toggle)
    if type(doorID) == 'string' then
        doorID = tonumber(doorID)
    end
    local state = toggle
    if state then
        exports.ox_doorlock:setDoorState(doorID, 1)
    else
        exports.ox_doorlock:setDoorState(doorID, 0)
    end
    return true
end

function doorlock.GetResourceName()
    return 'ox_doorlock'
end

return doorlock
