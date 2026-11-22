local banking = {}

function banking.GetManagmentName()
    return 'banking'
end

function banking.GetResourceName()
    return 'banking'
end

function banking.GetAccountMoney(account)
    return nil
end

function banking.AddAccountMoney(account, amount, reason)
    return false
end

function banking.RemoveAccountMoney(account, amount, reason)
    return false
end

return banking
