local weather = {}

function weather.ToggleSync(toggle)
    if toggle then
        TriggerEvent("qb-weathersync:client:EnableSync")
    else
        TriggerEvent("qb-weathersync:client:DisableSync")
    end
end

function weather.GetResourceName()
    return "qb-weathersync"
end

return weather
