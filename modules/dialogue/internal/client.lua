local dialogue = {}

local promises = {}
local activeDialogue = nil
local pendingCameraDestroy = false
local cam = nil
local npc = nil

function dialogue.Close(name)
    pendingCameraDestroy = true
    activeDialogue = nil

    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "close",
        name = name
    })

    CreateThread(function()
        Wait(200)
        if pendingCameraDestroy and not activeDialogue then
            RenderScriptCams(false, true, 1000, true, false)
            SetCamActive(cam, false)
            DestroyCam(cam, false)
            cam = nil
        end
    end)

    promises[name] = nil
end

function dialogue.Open(name, dialogue, characterOptions, dialogueOptions, onSelected)
    if not name or not dialogue or not dialogueOptions then return end

    local isCharacterATable = type(characterOptions) == "table"
    local entity = isCharacterATable and characterOptions.entity or tonumber(characterOptions)
    local offset = isCharacterATable and characterOptions.offset or vector3(0, 0, 0)
    local rotationOffset = isCharacterATable and characterOptions.rotationOffset or vector3(0, 0, 0)

    pendingCameraDestroy = false
    activeDialogue = name

    if entity then
        Wait(500)
        local endLocation = GetOffsetFromEntityInWorldCoords(entity, offset.x, offset.y + 2.0, offset.z)
        local pedHeading = GetEntityHeading(entity)

        if not cam then cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true) end
        local camAngle = (pedHeading + 180.0) % 360.0
        SetCamRot(cam, rotationOffset.x, rotationOffset.y, camAngle + rotationOffset.z, 2)
        SetCamCoord(cam, endLocation.x, endLocation.y, endLocation.z)
        RenderScriptCams(true, true, 1000, true, false)
        SetCamActive(cam, true)
    end
    SendNUIMessage({
        type = "open",
        text =  dialogue,
        name = name,
        options = dialogueOptions
    })
    SetNuiFocus(true, true)

    local prom = promise.new()
    local wrappedFunction = function(selected)
        SetNuiFocus(false, false)
        dialogue.Close(name)
        if onSelected then onSelected(selected) end
        prom:resolve(selected)
    end
    promises[name] = wrappedFunction
    return Citizen.Await(prom)
end

RegisterNuiCallback("dialogue:SelectOption", function(data)
    local promis = promises[data.name]
    if not promis then return end
    promis(data.id)
end)

return dialogue
