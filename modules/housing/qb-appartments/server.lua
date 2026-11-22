local housing = {}

RegisterNetEvent('qb-apartments:server:SetInsideMeta', function(house, insideId, bool, isVisiting)
    local src = source
    insideId = bool and house .. '-' .. insideId or nil
    TriggerEvent('Fivem_Bridge:Server:_OnPlayerInside', src, insideId)
end)

function housing.GetResourceName()
    return "qb-appartments"
end

return housing
