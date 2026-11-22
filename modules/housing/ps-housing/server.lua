local housing = {}

RegisterNetEvent('ps-housing:server:enterProperty', function(insideId)
    local src = source
    TriggerEvent('fivem_Bridge:Server:_OnPlayerInside', src, insideId)
end)

RegisterNetEvent('ps-housing:server:leaveProperty', function(insideId)
    local src = source
    TriggerEvent('fivem_Bridge:Server:_OnPlayerInside', src, insideId)
end)

function housing.GetResourceName()
    return "ps-housing"
end

return housing
