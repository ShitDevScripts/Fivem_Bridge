local target = {}

local function CreateTargetCleanup(removeZone)
    local zonesByResource = {}

    AddEventHandler('onResourceStop', function(resourceName)
        local zones = zonesByResource[resourceName]
        if not zones then return end

        for i = 1, #zones do
            removeZone(zones[i])
        end

        zonesByResource[resourceName] = nil
    end)

    return function(zoneId)
        if zoneId == nil then return zoneId end

        local resource = GetInvokingResource() or cache.resource
        local zones = zonesByResource[resource]
        if not zones then
            zonesByResource[resource] = zones
        end

        zones[#zones + 1] = zoneId
        return zoneId
    end
end
