local phone = {}
local resourceName = "yseries"

function phone.GetPhoneName()
    return resourceName
end

function phone.GetResourceName()
    return resourceName
end

function phone.SendEmail(email, title, message)
    TriggerServerEvent('Fivem_Bridge:Server:genericEmail', {email = email, title = title, message = message})
    return true
end

return phone
