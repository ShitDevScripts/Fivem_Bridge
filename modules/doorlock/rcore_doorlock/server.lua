local doorlock = {}

function doorlock.ToggleDoorLock(doorID, toggle)
    local state = toggle
    if state then
        exports.rcore_doorlock:changeDoorState(doorID, 0)
    else
        exports.rcore_doorlock:changeDoorState(doorID, 1)
    end
    return true
end

function doorlock.GetResourceName()
    return 'rcore_doorlock'
end

return doorlock
