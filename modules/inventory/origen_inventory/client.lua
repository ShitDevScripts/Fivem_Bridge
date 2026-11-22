local inventory = {}

local origin = exports.origen_inventory

local function countItem(item, metadata)
    local total = 0

    for _, itemData in pairs(origin:getPlayerItems() or {}) do
        if itemData.name == item and InventoryMetadataMatches(InventoryItemMetadata(itemData), metadata) then
            total = total + InventoryItemAmount(itemData)
        end
    end

    return total
end

function inventory.Items(itemName)
    return nil
end

function inventory.hasItem(item, count, metadata)
    if metadata then
        return countItem(item, metadata) >= (count or 1)
    end

    return origin:hasItem(item, count or 1)
end

function inventory.getImagePath(itemName)
    return InventoryBuildImageUrl(itemName, inventory.Items(itemName), 'origen_inventory', 'html/images')
end

function inventory.getItemInfo(itemName)
    return InventoryBuildItemInfo(itemName, inventory.Items(itemName), 'origen_inventory', 'html/images')
end

function inventory.getItemCount(item, metadata)
    return countItem(item, metadata)
end

function inventory.getInventoryItems()
    return NormalizeInventoryItems(origin:getPlayerItems() or {})
end

return inventory
