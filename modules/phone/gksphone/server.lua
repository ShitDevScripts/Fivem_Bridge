local phone = {}
local resourceName = "gksphone"

function phone.GetPhoneName()
    return resourceName
end

function phone.GetResourceName()
    return resourceName
end

function phone.GetPlayerPhone(src)
    return exports["gksphone"]:GetPhoneBySource(src) or false
end

function phone.SendEmail(src, email, title, message)
    local data = {}
    data.sender = email
    data.image = '/html/static/img/icons/mail.png'
    data.subject = title
    data.message = message
    exports["gksphone"]:SendNewMail(src, data)
    return true
end

return phone
