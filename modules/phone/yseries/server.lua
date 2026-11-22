local phone = {}
local resourceName = "yseries"

function phone.GetPhoneName()
    return resourceName
end

function phone.GetResourceName()
    return resourceName
end

function phone.GetPlayerPhone(src)
    return exports.yseries:GetPhoneNumberBySourceId(src) or false
end

function phone.SendEmail(src, email, title, message)
    local phoneNumber = exports.yseries:GetPhoneNumberBySourceId(src)
    if not phoneNumber then return false, print("Could not find phone number for source: " .. tostring(src)) end
    local _, received = exports.yseries:SendMail({
        title = title,
        sender = email,
        senderDisplayName = email,
        content = message,
    }, 'phoneNumber', phoneNumber)
    return received
end

RegisterNetEvent('fivem_Bridge:Server:genericEmail', function(data)
    local src = source
    return phone.SendEmail(src, data.email, data.title, data.message)
end)

return phone
