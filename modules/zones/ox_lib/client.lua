local zones = {}

local resourceName = "ox_lib"

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

    local onEnter = data.onEnter or data.OnEnter
    local onExit = data.onExit or data.OnExit
    local zone

    if zoneType == "box" then
        local width = (data.size and data.size.x) or data.length or 1.0
        local height = (data.size and data.size.y) or data.width or 1.0
        local z = (data.size and data.size.z) or data.height or 1.0

        zone = lib.zones.box({
            coords = data.coords,
            size = vec3(width, height, z),
            rotation = data.heading or data.rotation or 0.0,
            debug = data.debug or false,
            onEnter = function()
                if onEnter then onEnter(data) end
            end,
            onExit = function()
                if onExit then onExit(data) end
            end,
        })

        data.zone = zone
        zones.All[data.id] = data
        return data.id
    elseif zoneType == "sphere" then
        data.radius = data.radius or (data.size and data.size.x) or 1

        zone = lib.zones.sphere({
            coords = data.coords,
            radius = data.radius,
            debug = data.debug or false,
            onEnter = function(point)
                data.zone = data.zone or point
                if onEnter then onEnter(data) end
            end,
            onExit = function(point)
                data.zone = data.zone or point
                if onExit then onExit(data) end
            end,
        })

        data.zone = zone
        zones.All[data.id] = data
        return data.id
    elseif zoneType == "poly" then
        local zSize = data.minZ or (data.size and data.size.z) or data.height or data.thickness or 2

        zone = lib.zones.poly({
            points = data.points,
            thickness = zSize,
            debug = data.debug or false,
            onEnter = function(point)
                data.zone = data.zone or point
                if onEnter then onEnter(data) end
            end,
            onExit = function(point)
                data.zone = data.zone or point
                if onExit then onExit(data) end
            end,
        })

        data.zone = zone
        zones.All[data.id] = data
        return data.id
    end

    return nil
end

function zones.Destroy(id)
    if not id then return false end
    local entry = zones.All[id]
    if not entry or not entry.zone then return false end
    entry.zone:remove()
    zones.All[id] = nil
    return true
end

function zones.DestroyByResource(resource)
    if not resource then return false end
    for id, entry in pairs(zones.All) do
        if entry.invoking == resource then
            entry.zone:remove()
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
