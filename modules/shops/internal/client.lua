local shops = {}

RegisterNetEvent('Fivem_Bridge:Client:openShop', function(shopType, shopLabel, shopData)
    if source ~= 65535 then return end
    if shopType ~= 'shop' or not shopLabel or not shopData then return end
    shops.OpenShop(shopLabel, shopData.inventory)
end)

function shops.FinalizeCheckOut(shopName, item, itemLabel, price, amount)
    if not shopName or not item or not itemLabel or not price then return end

    local total = tonumber(price) * tonumber(amount)
    local options = {
        {
            title = ('Pay $%s with cash'):format(total),
            description = ('Are you sure you want to purchase a %s?'):format(itemLabel),
            icon = 'fa-solid fa-money-bill-wave',
            onSelect = function()
                TriggerServerEvent('Fivem_Bridge:Server:completeCheckout', shopName, item, amount, 'money')
            end,
        },
        {
            title = ('Pay $%s with card'):format(total),
            description = ('Are you sure you want to purchase a %s?'):format(itemLabel),
            icon = 'fa-solid fa-building-columns',
            onSelect = function()
                TriggerServerEvent('Fivem_Bridge:Server:completeCheckout', shopName, item, amount, 'bank')
            end,
        },
    }

    bridge.menu.openMenu({ id = Ids.CreateUniqueId(), title = 'Amount', options = options })
end

function shops.AmountSelect(shopName, item, itemLabel, price)
    if not shopName or not item or not itemLabel or not price then return end

    price = tonumber(price)
    if not price or price <= 0 then return end

    local options = {}
    for i = 1, 100 do
        options[i] = { label = tostring(i), value = i }
    end

    local values = bridge.inputs.inputdialog('Purchase quantity', {
        { type = 'select', label = 'Quantity', options = options },
    })

    if values and values[1] then
        shops.FinalizeCheckOut(shopName, item, itemLabel, price, tostring(values[1]))
    end
end

function shops.OpenShop(shopName, shopData)
    if not shopName or not shopData then return print('^6No shop name or data passed^0') end

    local options = {}
    for _, entry in pairs(shopData) do
        local itemInfo = bridge.inventory.getItemInfo(entry.name)
        local label = itemInfo and itemInfo.label or entry.name
        options[#options + 1] = {
            title = label,
            description = ('$%s'):format(entry.price),
            icon = 'fa-solid fa-basket-shopping',
            onSelect = function()
                shops.AmountSelect(shopName, entry.name, label, entry.price)
            end,
        }
    end

    bridge.menu.openMenu({ id = Ids.CreateUniqueId(), title = shopName, options = options })
end

return shops
