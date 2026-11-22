local housing = {}

RegisterNetEvent('esx_property:enter', function(insideId)
    local src = source
    TriggerEvent('Fivem_Bridge:Server:_OnPlayerInside', src, insideId)
end)

RegisterNetEvent('esx_property:leave', function(insideId)
    local src = source
    TriggerEvent('Fivem_Bridge:Server:_OnPlayerInside', src, insideId)
end)

function housing.GetResourceName()
    return "esx_property"
end

return housing
