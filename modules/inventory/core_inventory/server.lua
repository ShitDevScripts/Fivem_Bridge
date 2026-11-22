local inventory = {}

local core = exports['core_inventory']

local registeredStashes = {}

local function resolveInv(inv)
    if type(inv) ~= 'string' then return inv end
    if inv:sub(1, 6) == 'stash-' then return inv end

    return ('stash-%s'):format((inv:gsub(' ', '')))
end

local function getItems(inv)
    local data = core:getInventory(resolveInv(inv))

    if type(data) == 'table' then
        return data.content or data.items or data
    end

    return {}
end

local function countItems(inv, item, metadata)
    if not metadata then
        return core:getItemCount(resolveInv(inv), item) or 0
    end

    local total = 0

    for _, itemData in pairs(getItems(inv)) do
        if itemData.name == item and InventoryMetadataMatches(InventoryItemMetadata(itemData), metadata) then
            total = total + InventoryItemAmount(itemData)
        end
    end

    return total
end

local function resolveRemoveUniqueId(inv, item, metadata, slot)
    if not slot and not metadata then return nil end

    for contentKey, itemData in pairs(getItems(inv)) do
        if itemData.name == item
            and (not slot or itemData.slot == slot)
            and InventoryMetadataMatches(InventoryItemMetadata(itemData), metadata)
        then
            return contentKey
        end
    end

    return nil
end

function inventory.Items(itemName)
    local list = core:getItemsList()
    return NormalizeItemDefinitions(list, itemName)
end

function inventory.getImagePath(itemName)
    return InventoryBuildImageUrl(itemName, inventory.Items(itemName), 'core_inventory', 'html/img')
end

function inventory.getItemInfo(itemName)
    return InventoryBuildItemInfo(itemName, inventory.Items(itemName), 'core_inventory', 'html/img')
end

function inventory.addItem(inv, item, count, metadata, slot)
    local inventoryType = type(inv) == 'string' and 'stash' or nil
    return core:addItem(resolveInv(inv), item, count or 1, metadata, inventoryType)
end

function inventory.removeItem(inv, item, count, metadata, slot)
    count = count or 1
    local uniqueId = resolveRemoveUniqueId(inv, item, metadata, slot)

    if uniqueId then
        return core:removeItemExact(resolveInv(inv), uniqueId, count)
    end

    local inventoryType = type(inv) == 'string' and 'stash' or nil
    return core:removeItem(resolveInv(inv), item, count, inventoryType)
end

function inventory.hasItem(inv, item, count, metadata)
    if metadata then
        return countItems(inv, item, metadata) >= (count or 1)
    end

    return core:hasItem(resolveInv(inv), item, count or 1)
end

function inventory.getItemCount(inv, item, metadata)
    return countItems(inv, item, metadata)
end

function inventory.getInventoryItems(inv)
    return NormalizeInventoryItems(getItems(inv))
end

function inventory.setMetadata(inv, slot, metadata)
    core:setMetadata(resolveInv(inv), slot, metadata)
    return true
end

function inventory.getSlot(inv, slot)
    return NormalizeInventoryItem(core:getItemBySlot(resolveInv(inv), slot), slot)
end

function inventory.clearInventory(inv, keep)
    if not keep then
        core:clearInventory(resolveInv(inv))
        return
    end

    local keepSet = {}

    if type(keep) == 'string' then
        keepSet[keep] = true
    else
        for i = 1, #keep do
            keepSet[keep[i]] = true
        end
    end

    for contentKey, itemData in pairs(getItems(inv)) do
        if itemData.name and not keepSet[itemData.name] then
            core:removeItemExact(resolveInv(inv), contentKey, InventoryItemAmount(itemData))
        end
    end
end

function inventory.canCarryItem(inv, item, count, metadata)
    return core:canCarry(resolveInv(inv), item, count or 1, metadata)
end

function inventory.registerStash(id, label, slots, maxWeight, owner, groups, coords)
    if type(id) ~= 'string' or id == '' then return false end

    registeredStashes[id] = {
        label = label,
        owner = owner,
        groups = groups,
    }

    return true
end

function inventory.openStash(src, id)
    if type(src) ~= 'number' or type(id) ~= 'string' or id == '' then return false end

    local stash = registeredStashes[id]

    core:openInventory(src, resolveInv(id), 'stash', stash and stash.label, nil, true)
    return true
end

function inventory.registerShop(shopType, shopData)
    lib.print.debug(('[bridge-inventory] Warning: core_inventory has no server-side shop registration, cannot register shop "%s".'):format(shopType))
    return false
end

function inventory.openShop(src, shopType)
    lib.print.debug(('[bridge-inventory] Warning: core_inventory has no server-side shop open export, cannot open shop "%s" for player %s.'):format(shopType, src))
    return false
end

function inventory.registerHook(eventName, callback, options)
    lib.print.debug(('[bridge-inventory] Warning: core_inventory has no hook API, cannot register hook for event "%s".'):format(eventName))
    return false
end

function inventory.removeHooks(hookId)
    lib.print.debug(('[bridge-inventory] Warning: core_inventory has no hook API, cannot remove hook with id "%s".'):format(hookId))
    return false
end

return inventory
