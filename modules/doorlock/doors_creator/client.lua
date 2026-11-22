local doorlock = {}

function doorlock.GetClosestDoor()
    return exports["doors_creator"]:getClosestActiveDoor()
end

function doorlock.GetResourceName()
    return 'doors_creator'
end

return doorlock
