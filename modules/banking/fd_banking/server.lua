local banking = {}
local Banking = exports['fd_banking']

function banking.GetManagmentName()
    return "fd_banking"
end

function banking.GetResourceName()
    return "fd_banking"
end

function banking.GetAccountMoney(account)
    return Banking:GetAccount(account)
end

function banking.AddAccountMoney(account, amount, reason)
    return Banking:AddMoney(account, amount, reason)
end

function banking.RemoveAccountMoney(account, amount, reason)
    return Banking:RemoveMoney(account, amount, reason)
end

return banking
