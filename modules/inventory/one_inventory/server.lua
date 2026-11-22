local inventory = {}

local one_inventory = exports.one_inventory

local registeredStashes = {}

local function resolveInv(inv)
    if type(inv) == 'number' then return inv end
    if type(inv) ~= 'string' then return inv end
    if inv:find(':', 1, true) then return inv end

    return ('stash:%s'):format(inv)
end

function inventory.Items(itemName)
    if itemName then
        return one_inventory:GetItemDefinition(itemName)
    end

    return one_inventory:GetAllItemDefinitions()
end

function inventory.getImagePath(itemName)
    return InventoryBuildImageUrl(itemName, inventory.Items(itemName), 'one_inventory')
end

function inventory.getItemInfo(itemName)
    return InventoryBuildItemInfo(itemName, inventory.Items(itemName), 'one_inventory')
end

function inventory.addItem(inv, item, count, metadata, slot)
    return one_inventory:AddItem(resolveInv(inv), item, count, metadata, slot)
end

function inventory.removeItem(inv, item, count, metadata, slot)
    return one_inventory:RemoveItem(resolveInv(inv), item, count, metadata, slot)
end

function inventory.hasItem(inv, item, count, metadata)
    return one_inventory:HasItem(resolveInv(inv), item, count, metadata)
end

function inventory.getItemCount(inv, item, metadata)
    return one_inventory:GetItemCount(resolveInv(inv), item, metadata)
end

function inventory.getInventoryItems(inv)
    return one_inventory:GetInventoryItems(resolveInv(inv))
end

function inventory.setMetadata(inv, slot, metadata)
    return one_inventory:SetItemMetadata(resolveInv(inv), slot, metadata)
end

function inventory.getSlot(inv, slot)
    return one_inventory:GetSlot(resolveInv(inv), slot)
end

function inventory.clearInventory(inv, keep)
    return one_inventory:ClearInventory(resolveInv(inv), keep)
end

function inventory.canCarryItem(inv, item, count, metadata)
    return one_inventory:CanCarryItem(resolveInv(inv), item, count)
end

function inventory.registerStash(id, label, slots, maxWeight, owner, groups, coords)
    if type(id) ~= 'string' or id == '' then return false end

    registeredStashes[id] = {
        label = label or id,
        slots = slots,
        maxWeight = maxWeight,
        owner = owner,
        groups = groups,
    }

    return true
end

function inventory.openStash(src, id)
    if type(src) ~= 'number' or type(id) ~= 'string' or id == '' then return false end

    local stash = registeredStashes[id]

    return one_inventory:OpenInventory(src, 'stash', {
        id = id,
        label = stash and stash.label,
        slots = stash and stash.slots,
        maxWeight = stash and stash.maxWeight,
        owner = stash and stash.owner,
        groups = stash and stash.groups,
    })
end

local function mapShopItems(items)
    if type(items) ~= 'table' then return {} end

    local mapped = {}

    for i = 1, #items do
        local entry = items[i]
        if type(entry) == 'table' and entry.name then
            mapped[#mapped + 1] = {
                name = entry.name,
                price = entry.price,
                count = entry.count or 0,
                metadata = entry.metadata,
            }
        end
    end

    return mapped
end

local function mapShopData(shopType, shopData)

    local payload = {
        name = shopType,
        label = inventory.label or inventory.name or shopType,
        inventory = mapShopItems(inventory.inventory),
    }

    if inventory.currency then
        payload.currency = inventory.currency
    end

    if inventory.jobs then
        payload.jobs = inventory.jobs
    elseif inventory.groups then
        payload.jobs = inventory.groups
    end

    if inventory.gangs then
        payload.gangs = inventory.gangs
    end

    if inventory.licenses then
        payload.licenses = inventory.licenses
    elseif inventory.license then
        payload.licenses = inventory.license
    end

    if inventory.coords then
        payload.coords = inventory.coords
    end

    if inventory.locations then
        payload.locations = inventory.locations
        if not payload.coords and inventory.locations[1] then
            payload.coords = inventory.locations[1]
        end
    end

    return payload
end

function inventory.registerShop(shopType, shopData)
    if type(shopType) ~= 'string' or shopType == '' then return false end

    local registered = one_inventory:RegisterShop(mapShopData(shopType, shopData))
    if registered == false then return false end

    return true
end

function inventory.openShop(src, shopType)
    if type(src) ~= 'number' or type(shopType) ~= 'string' or shopType == '' then return false end

    return one_inventory:OpenInventory(src, 'shop', shopType)
end

function inventory.registerHook(eventName, callback, options)
    return one_inventory:RegisterHook(eventName, callback, options)
end

function inventory.removeHooks(hookId)
    return one_inventory:RemoveHook(hookId)
end

return inventory
