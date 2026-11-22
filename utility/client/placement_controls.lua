local controls = {
    place = 38,
    cancel = 194,
    returnMenu = 74,
    scrollUp = 15,
    scrollDown = 14,
    rotateLeft = 174,
    rotateRight = 175,
    pedRaise = 172,
    pedLower = 173,
    undo = 20,
    animClear = 73,
    previewModeToggle = 37,
    gizmoToggle = 47,
    gizmoSnap = 19,
    modifierCoarse = 21,
    modifierFine = 19,
    cancelGraceMs = 400,
    frontendCancel = { 194, 200, 202, 177 },
}

function controls.blockCancelWhile(isActive)
    CreateThread(function()
        while isActive() do
            for i = 1, #controls.frontendCancel do
                DisableControlAction(0, controls.frontendCancel[i], true)
            end
            Wait(0)
        end
    end)
end

return controls
