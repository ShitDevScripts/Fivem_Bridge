local phone = {}
local resourceName = 'okokPhone'

function phone.GetPhoneName()
    return resourceName
end

function phone.GetResourceName()
    return resourceName
end

function phone.SendEmail(email, title, message)
    TriggerServerEvent('fivem_Bridge:Server:okokPhone:sendEmail', email, title, message)
    return true
end

return phone
