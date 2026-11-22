local textui = {}

local function convertToLation(text, options)
    if not text then return {} end
    return {
        title = textui.title,
        description = text,
        keybind = textui.keybind,
        icon = textui.icon,
        iconColor = textui.iconColor,
        iconAnimation = textui.iconAnimation,
        alignIcon = textui.alignIcon,
        position = textui.position or 'right-center',
        options = textui.options,
        bgColor = textui.bgColor,
        txtColor = textui.txtColor,
    }
end

function textui.showTextUI(text, options)
    if not text then return end
    local converted = convertToLation(text, options)
    exports.lation_ui:showText(converted)
end

function textui.hideTextUI()
    exports.lation_ui:hideText()
end

function textui.isTextUIOpen()
    return exports.lation_ui:isOpen()
end

return textui
