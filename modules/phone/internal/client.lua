local phone = {}

function phone.GetPhoneName()
    return 'default'
end

function phone.GetResourceName()
    return "default"
end

function phone.SendEmail(email, title, message)
    return false, print('^6 There is no phone bridged in Fivem_Bridge. ^0')
end

return phone
