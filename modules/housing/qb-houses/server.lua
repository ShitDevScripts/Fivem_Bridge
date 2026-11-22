local housing = {}

RegisterNetEvent('qb-houses:server:SetInsideMeta', function(insideId, bool)
    local src = source
    insideId = bool and insideId or nil
    TriggerEvent('fivem_Bridge:Server:_OnPlayerInside', src, insideId)
end)

function housing.GetResourceName()
    return "qb-houses"
end

return housing
