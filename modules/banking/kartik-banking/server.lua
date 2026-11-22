local banking = {}
local Banking = exports['kartik-banking']

function banking.GetManagmentName()
    return "kartik-banking"
end

function banking.GetResourceName()
    return "kartik-banking"
end

function banking.GetAccountMoney(account)
    local balance = Banking:GetAccountMoney(account)
    return balance or 0
end

function banking.AddAccountMoney(account, amount, reason)
    return Banking:AddAccountMoney(account, amount, reason)
end

function banking.RemoveAccountMoney(account, amount, reason)
    return Banking:RemoveAccountMoney(account, amount, reason)
end

return banking
