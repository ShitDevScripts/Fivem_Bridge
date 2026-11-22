local phone = {}
local resourceName = "lb-phone"

function phone.GetPhoneName()
    return resourceName
end

function phone.GetResourceName()
    return resourceName
end

function phone.GetPlayerPhone(src)
    return exports["lb-phone"]:GetEquippedPhoneNumber(src) or false
end

function phone.SendEmail(src, email, title, message)
    local numberNumber = exports["lb-phone"]:GetEquippedPhoneNumber(src)
    if not numberNumber then return false, print(" ^6 Could not Find Phone number ^0") end
    local playerEmail = exports["lb-phone"]:GetEmailAddress(numberNumber)
    if not playerEmail then return false, print(" ^6 Could not Find email ^0")  end
    local success, id = exports["lb-phone"]:SendMail({
        to = playerEmail,
        sender = email,
        subject = title,
        message = message,
    })
    return success or false
end

RegisterNetEvent('Fivem_Bridge:Server:genericEmail', function(data)
    local src = source
    return phone.SendEmail(src, data.email, data.title, data.message)
end)

return phone
