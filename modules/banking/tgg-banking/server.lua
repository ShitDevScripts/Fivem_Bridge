local banking = {}
local Banking = exports['tgg-banking']

function banking.GetManagmentName()
    return "tgg-banking"
end

function banking.GetResourceName()
    return "tgg-banking"
end

function banking.GetAccountMoney(account)
    return Banking:GetSocietyAccountMoney(account) or 0
end

function banking.AddAccountMoney(account, amount, reason)
    return Banking:AddSocietyMoney(account, amount)
end

function banking.RemoveAccountMoney(account, amount, reason)
    return Banking:RemoveSocietyMoney(account, amount)
end

return banking
