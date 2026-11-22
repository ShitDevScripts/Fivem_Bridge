local vehiclefuel = {}

function vehiclefuel.set(source, vehicle, amount)
    source = tonumber(source)
    if not source then return false end

    if not vehicle or not DoesEntityExist(vehicle) then return false end

    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    if not netId or netId <= 0 then return false end

    TriggerClientEvent("Fivem_Bridge:client:setFuel", source, netId, amount)
    return true
end

return vehiclefuel
