local Task = {}

local toggleCommand = 'fivem_toggle_task_hud'
local completeMs = 30000

local hudToggle
local active
local shown = false
local completing = false
local completeToken = 0

local function formatProgress(current, max)
    if current and max then
        return ('%s/%s'):format(current, max)
    end

    if current then
        return tostring(current)
    end
end

local function normalizeRow(entry)
    if type(entry) ~= 'table' or type(entry.label) ~= 'string' or entry.label == '' then
        return
    end

    local current = tonumber(entry.current)
    local max = tonumber(entry.max)
    if current then current = math.floor(current) end
    if max then max = math.floor(max) end

    local value = type(entry.value) == 'string' and entry.value ~= '' and entry.value or formatProgress(current, max)
    local progress = tonumber(entry.progress)
    if progress then
        if progress < 0 then progress = 0 end
        if progress > 100 then progress = 100 end
    end

    return {
        id = type(entry.id) == 'string' and entry.id or nil,
        label = entry.label,
        current = current,
        max = max,
        value = value,
        progress = progress,
    }
end

local function normalizeTasks(list)
    if type(list) ~= 'table' then return {} end

    local out = {}
    for i = 1, #list do
        local row = normalizeRow(list[i])
        if row then
            out[#out + 1] = row
        end
    end
    return out
end

local function normalizeHudType(value, fallbackType)
    local candidate = type(value) == 'string' and value:lower() or fallbackType
    if candidate == 'weight' or candidate == 'gather' or candidate == 'dense' then
        return candidate
    end
    return 'dense'
end

local function normalize(data, fallback)
    if type(data) ~= 'table' then return end

    local title = type(data.title) == 'string' and data.title ~= '' and data.title
        or (fallback and fallback.title)
    if not title then return end

    local hudType = normalizeHudType(data.type, fallback and fallback.type)
    local expanded = data.expanded
    if expanded == nil and fallback then
        expanded = fallback.expanded
    end
    if expanded == nil then
        expanded = true
    end

    local icon = type(data.icon) == 'string' and data.icon ~= '' and data.icon
        or (fallback and fallback.icon)
        or nil

    return {
        title = title,
        description = type(data.description) == 'string' and data.description
            or (fallback and fallback.description)
            or '',
        icon = icon,
        position = (data.position or (fallback and fallback.position)) == 'right' and 'right' or 'left',
        type = hudType,
        expanded = expanded == true,
        tasks = data.tasks ~= nil and normalizeTasks(data.tasks) or (fallback and fallback.tasks) or {},
    }
end

local function allTasksMaxed(payload)
    if not payload or type(payload.tasks) ~= 'table' then return false end

    local tracked = 0
    for i = 1, #payload.tasks do
        local row = payload.tasks[i]
        if row.max then
            tracked = tracked + 1
            if not row.current or row.current < row.max then
                return false
            end
        end
    end

    return tracked > 0
end

local function toggleKey()
    local key = hudToggle and hudToggle.currentKey
    if type(key) ~= 'string' then key = '' end
    if key == '' or key == 'NULL' then
        key = hudToggle and hudToggle.defaultKey or 'H'
    end
    if type(key) ~= 'string' or key == '' then return 'H' end
    return key
end

local function push(action, data)
    SendNUIMessage({ action = action, data = data })
end

local function decorate(payload)
    local key = toggleKey()

    return {
        title = payload.title,
        description = payload.description,
        icon = payload.icon,
        position = payload.position,
        type = payload.type or 'dense',
        expanded = payload.expanded ~= false,
        tasks = payload.tasks,
        hideKey = key,
        hideLabel = bridge.locale('task_hud.hide') or 'Hide',
        complete = false,
    }
end

local function bumpCompleteToken()
    completeToken = completeToken + 1
    return completeToken
end

local function clearCompleteState()
    bumpCompleteToken()
    completing = false
end

local function unpaint()
    push('taskHud:hide')
    shown = false
end

local function paint()
    if not active then return end
    push('taskHud:show', decorate(active))
    shown = true
end

local function beginComplete()
    if completing or not active then return end

    completing = true
    local token = bumpCompleteToken()
    local key = toggleKey()

    push('taskHud:complete', {
        title = bridge.locale('task_hud.complete') or 'Task complete',
        description = active.description or '',
        icon = active.icon,
        position = active.position or 'left',
        type = active.type or 'dense',
        expanded = true,
        durationMs = completeMs,
        hideKey = key,
        hideLabel = bridge.locale('task_hud.hide') or 'Hide',
        complete = true,
    })
    shown = true

    SetTimeout(completeMs, function()
        if token ~= completeToken then return end
        Task.complete()
    end)
end

local function maybeComplete()
    if completing or not active then return end
    if allTasksMaxed(active) then
        beginComplete()
    end
end

function Task.show(data)
    local payload = normalize(data)
    if not payload then return end

    clearCompleteState()
    active = payload
    paint()
    maybeComplete()
end

function Task.update(data)
    if completing then return end

    if not active then
        Task.show(data)
        return
    end

    local payload = normalize(data, active)
    if not payload then return end

    active = payload
    if shown then
        push('taskHud:update', decorate(active))
    end
    maybeComplete()
end

function Task.hide()
    clearCompleteState()
    active = nil
    unpaint()
end

function Task.complete()
    Task.hide()
end

function Task.toggle()
    if completing then
        Task.complete()
        return
    end

    if not active then return end

    if shown and active.type == 'gather' and active.expanded then
        active.expanded = false
        push('taskHud:update', decorate(active))
        return
    end

    if shown then
        push('taskHud:collapse')
        shown = false
    else
        if active.type == 'gather' then
            active.expanded = true
        end
        paint()
    end
end

function Task.isOpen()
    return shown
end

function Task.hasTask()
    return active ~= nil
end

function Task.isCompleting()
    return completing
end

function Task.get()
    return active
end

hudToggle = lib.addKeybind({
    name = toggleCommand,
    description = bridge.locale('task_hud.toggle') or 'Toggle task HUD',
    defaultKey = 'H',
    onPressed = function()
        Task.toggle()
    end,
})

AddEventHandler('onResourceStop', function(resource)
    if cache.resource ~= resource then return end
    clearCompleteState()
    if shown then unpaint() end
    active = nil
    shown = false
end)

exports('Task', function()
    return Task
end)

exports('CompleteTask', function()
    Task.complete()
end)

bridge.task = Task
