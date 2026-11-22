local shops = {}
local registeredShops = {}

local function notify(src, message, notifyType)
    bridge.notifications.notify(src, {
        type = notifyType,
        description = message,
        duration = 5000,
    })
end

function shops.OpenShop(src, shopName)
    if not shopName or not registeredShops[shopName] then
        return false, print(('^6Fivem_Bridge: player %s tried to open unknown shop %s^0'):format(src, tostring(shopName)))
    end

    TriggerClientEvent('Fivem_Bridge:Client:openShop', src, 'shop', shopName, registeredShops[shopName])
    return true
end

function shops.CreateShop(shopName, shopInventory, shopCoords, shopGroups)
    if not shopName or not shopInventory or not shopCoords then return false end
    if registeredShops[shopName] then return true end

    registeredShops[shopName] = {
        name = shopName,
        inventory = shopInventory,
        shopCoords = shopCoords,
        groups = shopGroups,
    }
    return true
end

function shops.CompleteCheckout(src, shopName, item, amount, account)
    if not src or not shopName or not item or not amount or not account then return end

    amount = tonumber(amount)
    if not amount or amount <= 0 then return end

    local shopData = registeredShops[shopName]
    if not shopData then return end

    local itemData
    for _, data in pairs(shopData.inventory) do
        if data.name == item then
            itemData = data
            break
        end
    end

    if not itemData or not itemData.price then
        return print(('^6Fivem_Bridge: player %s tried to buy unknown item %s from %s^0'):format(src, tostring(item), shopName))
    end

    if itemData.count and itemData.count <= 0 then
        return notify(src, 'This item is out of stock', 'error')
    end

    local totalCost = tonumber(itemData.price) * amount
    local balance = bridge.framework.getMoney(src, account)
    if not balance or balance < totalCost then
        return notify(src, 'You do not have enough money to buy this item', 'error')
    end

    if not bridge.framework.removeMoney(src, account, totalCost, 'shop purchase') then return end

    if not bridge.inventory.addItem(src, itemData.name, amount) then
        bridge.framework.addMoney(src, account, totalCost, 'shop refund')
        return notify(src, 'Purchase failed, inventory full', 'error')
    end

    local itemInfo = bridge.inventory.getItemInfo(itemData.name)
    local itemLabel = itemInfo and itemInfo.label or itemData.name
    notify(src, ('You have purchased %s %s'):format(amount, itemLabel), 'success')
end

RegisterNetEvent('Fivem_Bridge:Server:completeCheckout', function(shopName, item, amount, account)
    if not shopName or not item or not amount or not account then return end
    if account ~= 'money' and account ~= 'bank' then return end
    shops.CompleteCheckout(source, shopName, item, amount, account)
end)

return shops
