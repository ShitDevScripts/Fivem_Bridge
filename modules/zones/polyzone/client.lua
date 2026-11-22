local zones = {}

local resourceName = "PolyZone"

zones.All = {}

local function createId(tbl)
    local id
    repeat
        id = ("%08x"):format(math.random(0, 0x7fffffff))
    until not tbl[id]
    return id
end

function zones.Create(zoneType, data)
    data.id = createId(zones.All)
    data.invoking = GetInvokingResource() or "unknown"

    local zone

    if zoneType == "box" then
        local width = data.size.x or data.length or 1.0
        local height = data.size.y or data.width or 1.0
        local z = (data.size and data.size.z) or data.height or 1.0

        data.size = vec3(width, height, z)
        data.heading = data.heading or data.rotation
        data.rotation = data.heading

        zone = BoxZone:Create(data.coords, width, height, {
            name = data.id,
            debugPoly = data.debug,
            minZ = data.coords.z - 0.5,
            maxZ = data.coords.z + z - 0.5,
            heading = data.heading or data.rotation,
        })
    elseif zoneType == "sphere" then
        data.radius = data.radius or (data.size and data.size.x) or 1

        zone = CircleZone:Create(data.coords, data.radius, {
            name = data.id,
            debugPoly = data.debug,
        })
    elseif zoneType == "poly" then
        local zSize = data.minZ or (data.size and data.size.z) or data.height or data.thickness or 2
        local firstPoint = data.points[1]
        local firstZ = firstPoint.z

        zone = PolyZone:Create(data.points, {
            name = data.id,
            debugPoly = data.debug,
            minZ = firstZ - 0.5,
            maxZ = firstZ and (firstZ + zSize - 0.5) or nil,
        })
    end

    if not zone then return end

    data.zone = zone

    zone:onPlayerInOut(function(isInside)
        if isInside then
            local onEnter = data.onEnter or data.OnEnter
            if onEnter then onEnter(data) end
        else
            local onExit = data.onExit or data.OnExit
            if onExit then onExit(data) end
        end
    end)

    zones.All[data.id] = data
    return data.id
end

function zones.Destroy(id)
    if not id then return false end
    local entry = zones.All[id]
    if not entry or not entry.zone then return false end
    entry.zone:destroy()
    zones.All[id] = nil
    return true
end

function zones.DestroyByResource(resource)
    if not resource then return false end
    for id, entry in pairs(zones.All) do
        if entry.invoking == resource then
            entry.zone:destroy()
            zones.All[id] = nil
        end
    end
    return true
end

function zones.Get(id)
    if not id then return nil end
    return zones.All[id]
end

RegisterNetEvent("onResourceStop", function(resource)
    zones.DestroyByResource(resource)
end)

return zones
