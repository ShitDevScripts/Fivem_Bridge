local doorlock = {}

function doorlock.GetClosestDoor()
    local doorData = exports.ox_doorlock:getClosestDoor()
    if not doorData then return end
    return tostring(doorData.id) or nil
end

function doorlock.GetResourceName()
    return 'ox_doorlock'
end

return doorlock
