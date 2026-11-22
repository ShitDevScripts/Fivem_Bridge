local phone = {}
local resourceName = 'okokPhone'

function phone.GetPhoneName()
    return resourceName
end

function phone.GetResourceName()
    return resourceName
end

function phone.GetPlayerPhone(src)
    return exports.okokPhone:getPhoneNumberFromSource(src) or false
end

function phone.SendEmail(src, email, title, message)
    local senderAddress = exports.okokPhone:getEmailAddressFromSource(src)
    if not senderAddress then return false end

    return exports.okokPhone:sendEmail({
        sender = senderAddress,
        recipients = { email },
        subject = title,
        body = message,
    })
end

RegisterNetEvent('fivem_Bridge:Server:okokPhone:sendEmail', function(email, title, message)
    phone.SendEmail(source, email, title, message)
end)

return phone
