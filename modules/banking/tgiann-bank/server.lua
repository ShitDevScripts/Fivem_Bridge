local banking = {}
local Banking = exports['tgiann-bank']

function banking.GetManagmentName()
    return "tgiann-bank"
end

function banking.GetResourceName()
    return "tgiann-bank"
end

function banking.GetAccountMoney(account)
    return Banking:GetJobAccountBalance(account)
end

function banking.AddAccountMoney(account, amount, reason)
    return Banking:AddJobMoney(account, amount)
end

function banking.RemoveAccountMoney(account, amount, reason)
    return Banking:RemoveJobMoney(account, amount)
end

return banking
