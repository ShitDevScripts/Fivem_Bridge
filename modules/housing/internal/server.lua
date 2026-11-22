local housing = {}

RegisterNetEvent('Fivem_Bridge:Server:_OnPlayerInside', function(src, insideId)
    local currentBucket = GetPlayerRoutingBucket(src)
    local playerEntity = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerEntity)
    TriggerEvent('Fivem_Bridge:Client:OnPlayerInside', src, insideId, currentBucket, playerCoords)
end)

function housing.GetResourceName()
    return "default"
end

return housing
