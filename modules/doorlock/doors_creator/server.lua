local doorlock = {}

function doorlock.ToggleDoorLock(doorID, toggle)
    local state = toggle
    if state then
        exports["doors_creator"]:setDoorState(doorID, 1)
    else
        exports["doors_creator"]:setDoorState(doorID, 0)
    end
    return true
end

function doorlock.GetResourceName()
    return 'doors_creator'
end

return doorlock
