local textui = {}

local function getOkokColor(type)
    local colorMap = {
        ["success"] = "lightgreen",
        ["error"] = "lightred",
        ["warning"] = "lightred",
        ["inform"] = "lightblue",
    }
    return colorMap[type] or "lightblue"
end

local function getOkokPosition(position)
    if position and (position:match("left") or position == "center-left") then
        return "left"
    end
    return "right"
end

function textui.showTextUI(text, options)
    if not text then return end

    local color = getOkokColor(textui.type)
    local position = getOkokPosition(textui.position)
    local playSound = textui.sound and true or false

    exports['okokTextUI']:Open(text, color, position, playSound)
end

function textui.hideTextUI()
    exports['okokTextUI']:Close()
end

function textui.isTextUIOpen()
    return false
end

return textui
