local banking = {}
local Banking = exports['wasabi_banking']

function banking.GetManagmentName()
    return "wasabi_banking"
end

function banking.GetResourceName()
    return "wasabi_banking"
end

function banking.GetAccountMoney(account)
    local balance = Banking:GetAccountBalance(account, "society")
    return balance or 0
end

function banking.AddAccountMoney(account, amount, reason)
    return Banking:AddMoney("society", account, amount)
end

function banking.RemoveAccountMoney(account, amount, reason)
    return Banking:RemoveMoney("society", account, amount)
end

return banking
