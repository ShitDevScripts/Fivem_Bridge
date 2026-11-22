local housing = {}

RegisterNetEvent('Housing:client:EnterHome', function(insideId)
    TriggerServerEvent('fivem_Bridge:Server:_OnPlayerInside', insideId)
end)

RegisterNetEvent("Housing:client:DeleteFurnitures", function()
    TriggerServerEvent('fivem_Bridge:Server:_OnPlayerInside', false)
end)

function housing.GetResourceName()
    return "bcs-housing"
end

return housing
