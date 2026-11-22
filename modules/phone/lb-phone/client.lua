local phone = {}
local resourceName = "lb-phone"

function phone.GetPhoneName()
    return resourceName
end

function phone.GetResourceName()
    return resourceName
end

function phone.SendEmail(email, title, message)
    TriggerServerEvent('Fivem_Bridge:Server:genericEmail', {email = email, title = title, message = message})
end

return phone
