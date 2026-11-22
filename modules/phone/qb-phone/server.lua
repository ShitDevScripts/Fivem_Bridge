local phone = {}
local resourceName = 'qb-phone'

function phone.GetPhoneName()
    return resourceName
end

function phone.GetResourceName()
    return resourceName
end

function phone.GetPlayerPhone(src)
    return bridge.framework.getPlayerMetadata(src, 'phone') or false
end

function phone.SendEmail(src, email, title, message)
    local identifier = bridge.framework.getIdentifier(src)
    if not identifier then return false, print('^6Could not find player identifier^0') end

    exports['qb-phone']:sendNewMailToOffline(identifier, {
        sender = email,
        subject = title,
        message = message,
    })
    return true
end

RegisterNetEvent('fivem_Bridge:Server:genericEmail', function(data)
    return phone.SendEmail(source, data.email, data.title, data.message)
end)

return phone
