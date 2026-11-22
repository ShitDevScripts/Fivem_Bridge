local phone = {}

function phone.GetPhoneName()
    return 'default'
end

function phone.GetResourceName()
    return "default"
end

function phone.GetPlayerPhone(src)
    return false, print('^6 There is no phone bridged in fivem_Bridge. ^0')
end

function phone.SendEmail(src, email, title, message)
    return false, print('^6 There is no phone bridged in fivem_Bridge. ^0')
end

return phone
