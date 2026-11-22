local banking = {}
local Banking = exports['ShitDevScripts-Banking']

function banking.GetManagmentName()
    return "ShitDevScripts-Banking"
end

function banking.GetResourceName()
    return "ShitDevScripts-Banking"
end

function banking.GetAccountMoney(account)
    local society = Banking:GetSocietyAccount(account)
    return society and tonumber(society.balance) or nil
end

function banking.AddAccountMoney(account, amount, reason)
    local success = Banking:AddSocietyMoney(account, amount, 'deposit', reason)
    return success == true
end

function banking.RemoveAccountMoney(account, amount, reason)
    local success = Banking:RemoveSocietyMoney(account, amount, 'withdrawal', reason)
    return success == true
end

return banking
