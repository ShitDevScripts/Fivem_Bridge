local textui = {}

local currentSerial = nil

function textui.showTextUI(text, options)
    if not text then return end

    local key = textui.keybind or "E"
    local duration = textui.duration

    currentSerial = exports['ZSX_UIV2']:TextUI(
        key,
        text,
        duration,
        function()
        end,
        function()
        end
    )
end

function textui.hideTextUI()
    if currentSerial then
        exports['ZSX_UIV2']:TextUI_Remove(currentSerial, true)
        currentSerial = nil
    end
end

function textui.isTextUIOpen()
    return currentSerial ~= nil
end

return textui
