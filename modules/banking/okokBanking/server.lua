local banking = {}
local Banking = exports['okokBanking']

function banking.GetManagmentName()
    return "okokBanking"
end

function banking.GetResourceName()
    return "okokBanking"
end

function banking.GetAccountMoney(account)
    return Banking:GetAccount(account)
end

function banking.AddAccountMoney(account, amount, reason)
    return Banking:AddMoney(account, amount)
end

function banking.RemoveAccountMoney(account, amount, reason)
    return Banking:RemoveMoney(account, amount)
end

return banking
