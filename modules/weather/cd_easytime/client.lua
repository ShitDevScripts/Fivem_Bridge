local weather = {}

function weather.ToggleSync(toggle)
    TriggerEvent('cd_easytime:PauseSync', toggle)
end

function weather.GetResourceName()
    return "cd_easytime"
end

return weather
