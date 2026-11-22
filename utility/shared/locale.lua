local localeTree = {}
local resolved = {}

local function getLocaleCode()
    return GetConvar('ox:locale', 'en')
end

local function loadLocaleFile(localeCode)
    local raw = LoadResourceFile(bridge.name, ('locales/%s.json'):format(localeCode))
    if not raw then return end
    return json.decode(raw)
end

local function resolveLocale(key)
    local current = localeTree

    for part in key:gmatch('([^%.]+)') do
        if type(current) ~= 'table' then
            return nil
        end

        current = current[part]
        if current == nil then
            return nil
        end
    end

    return type(current) == 'string' and current or nil
end

Citizen.CreateThreadNow(function()
    local localeCode = getLocaleCode()
    local locales = loadLocaleFile(localeCode)

    if not locales and localeCode ~= 'en' then
        localeCode = 'en'
        locales = loadLocaleFile(localeCode)
    end

    if not locales then
        return print(("^1[fivem_Bridge] Failed to load locale file for locale '%s'. Check if the file exists and is a valid JSON.^0"):format(getLocaleCode()))
    end

    localeTree = locales
end)

function bridge.locale(key, params)
    local template = resolved[key]

    if template == nil then
        template = resolveLocale(key) or false
        resolved[key] = template
    end

    if not template then return key end

    return (template:gsub('{(.-)}', function(found)
        local value = type(params) == 'table' and params[found] or nil
        return value ~= nil and tostring(value) or '{' .. found .. '}'
    end))
end

function bridge.locales()
    return localeTree
end

exports('Locale', function(key, params)
    return bridge.locale(key, params)
end)

exports('Locales', function()
    return localeTree
end)
