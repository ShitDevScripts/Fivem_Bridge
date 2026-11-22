local banking = {}
local Banking = exports['Renewed-Banking']

function banking.GetManagmentName()
    return "Renewed-Banking"
end

function banking.GetResourceName()
    return "Renewed-Banking"
end

function banking.GetAccountMoney(account)
    return Banking:getAccountMoney(account)
end

function banking.AddAccountMoney(account, amount, reason)
    return Banking:addAccountMoney(account, amount)
end

function banking.RemoveAccountMoney(account, amount, reason)
    return Banking:removeAccountMoney(account, amount)
end

return banking
