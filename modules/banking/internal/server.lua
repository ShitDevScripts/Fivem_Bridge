local banking = {}

function banking.GetManagmentName()
    return "default"
end

function banking.GetResourceName()
    return "default"
end

function banking.GetAccountMoney(account)
    return 0, print("The resource you are using does not support this function.")
end

function banking.AddAccountMoney(account, amount, reason)
    return false, print("The resource you are using does not support this function.")
end

function banking.RemoveAccountMoney(account, amount, reason)
    return false, print("The resource you are using does not support this function.")
end

return banking
