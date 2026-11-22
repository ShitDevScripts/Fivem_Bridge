local banking = {}
local Banking = exports['qb-banking']

function banking.GetManagmentName()
    return "qb-banking"
end

function banking.GetResourceName()
    return "qb-banking"
end

function banking.GetAccountMoney(account)
    return Banking:GetAccountBalance(account)
end

function banking.AddAccountMoney(account, amount, reason)
    return Banking:AddMoney(account, amount, reason)
end

function banking.RemoveAccountMoney(account, amount, reason)
    return Banking:RemoveMoney(account, amount, reason)
end

return banking
