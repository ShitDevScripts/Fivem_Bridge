local weather = {}

function weather.ToggleSync(toggle)
    LocalPlayer.state.syncWeather = toggle
end

function weather.GetResourceName()
    return "renewed-weathersync"
end

return weather
