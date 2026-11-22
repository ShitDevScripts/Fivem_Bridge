local phone = {}
local resourceName = "qs-smartphone"

function phone.GetPhoneName()
    return resourceName
end

function phone.GetResourceName()
    return resourceName
end

function phone.GetPlayerPhone(src)
    return exports['qs-base']:GetPlayerPhone(src) or false
end

function phone.SendEmail(src, email, title, message)
    TriggerClientEvent('Fivem_Bridge:Server:genericEmail', src, { sender = email, subject = title, message = message, button = {} })
    return true
end

return phone
