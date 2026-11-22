local DERIVED = { 'primary', 'accent', 'success', 'warning', 'danger', 'info', 'close' }
local HEX = '^#%x%x%x$'
local HEX_LONG = '^#%x%x%x%x%x%x$'

local function isHex(value)
    return type(value) == 'string' and (value:match(HEX) ~= nil or value:match(HEX_LONG) ~= nil)
end

local function isColour(value)
    if isHex(value) then return true end
    return type(value) == 'string' and (value:match('^rgba?%b()$') ~= nil)
end

local function channels(hex)
    if #hex == 4 then
        return tonumber(hex:sub(2, 2):rep(2), 16), tonumber(hex:sub(3, 3):rep(2), 16), tonumber(hex:sub(4, 4):rep(2), 16)
    end
    return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
end

local function withAlpha(hex, alpha)
    local r, g, b = channels(hex)
    return ('rgba(%d, %d, %d, %s)'):format(r, g, b, alpha)
end

local function darken(hex, amount)
    local r, g, b = channels(hex)
    local keep = 1 - amount
    return ('#%02x%02x%02x'):format(math.floor(r * keep + 0.5), math.floor(g * keep + 0.5), math.floor(b * keep + 0.5))
end

local function kebab(name)
    return (name:gsub('(%u)', function(letter) return '-' .. letter:lower() end))
end

local PLAIN = { radius = true, font = true }

local function build()
    local source = type(Config.Theme) == 'table' and Config.Theme or {}
    local tokens = {}

    for name, value in pairs(source) do
        if type(name) == 'string' and name:match('^%a[%w]*$') then
            if PLAIN[name] then
                if type(value) == 'string' and not value:find('[;{}<>]') then tokens[name] = value end
            elseif isColour(value) then
                tokens[name] = value
            else
                print(('^3[Fivem_Bridge] Theme token "%s" is not a valid colour (%s), ignoring it.^0'):format(name, tostring(value)))
            end
        end
    end

    for i = 1, #DERIVED do
        local base = DERIVED[i]
        local colour = tokens[base]
        if isHex(colour) then
            if tokens[base .. 'Hover'] == nil then tokens[base .. 'Hover'] = darken(colour, 0.12) end
            if tokens[base .. 'Soft'] == nil then tokens[base .. 'Soft'] = withAlpha(colour, '0.15') end
            if tokens[base .. 'Border'] == nil then tokens[base .. 'Border'] = withAlpha(colour, '0.45') end
        end
    end

    return tokens
end

local cache

local function tokens()
    if not cache then cache = build() end
    return cache
end

local function copy(source)
    local out = {}
    for key, value in pairs(source) do out[key] = value end
    return out
end

local theme = {}

function theme.get()
    return copy(tokens())
end

function theme.vars()
    local out = {}
    for name, value in pairs(tokens()) do out['--newb-' .. kebab(name)] = value end
    return out
end

function theme.css()
    local names = {}
    for name in pairs(tokens()) do names[#names + 1] = name end
    table.sort(names)
    local lines = {}
    local current = tokens()
    for i = 1, #names do
        lines[i] = ('--newb-%s:%s;'):format(kebab(names[i]), current[names[i]])
    end
    return ':root{' .. table.concat(lines) .. '}'
end

function theme.payload()
    return { tokens = theme.get(), vars = theme.vars(), css = theme.css() }
end

if bridge.context == 'client' then
    local registered = false

    function theme.push()
        SendNUIMessage({ action = 'NEWB_THEME', data = theme.payload() })
    end

    function theme.register()
        if registered then return end
        registered = true
        RegisterNUICallback('newbTheme', function(_, cb)
            cb(theme.payload())
        end)
        AddEventHandler('Fivem_Bridge:client:themeChanged', function()
            cache = nil
            theme.push()
        end)
    end
end

return theme
