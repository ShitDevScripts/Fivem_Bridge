local inventory = {}

local function InventoryItemMetadata(itemData)
    if type(itemData) ~= 'table' then return {} end

    return inventory.metadata or inventory.info or {}
end

local function InventoryItemAmount(itemData)
    if type(itemData) ~= 'table' then return 0 end

    return inventory.count or inventory.amount or 0
end

local function InventoryMetadataMatches(itemMetadata, filterMetadata, strict)
    if not filterMetadata then return true end

    local tablematch = strict and lib.table.matches or lib.table.contains

    return tablematch(itemMetadata, filterMetadata)
end

local function NormalizeInventoryItem(itemData, slotFallback)
    if type(itemData) ~= 'table' or not inventory.name then return nil end

    local slot = inventory.slot or slotFallback
    if type(slot) == 'string' then
        slot = tonumber(slot:match('^SLOT%-(%d+)$') or slot)
    end

    local metadata = inventory.metadata or inventory.info
    if type(metadata) ~= 'table' then
    end

    local normalized = {
        name = inventory.name,
        count = inventory.count or inventory.amount or 0,
        slot = slot,
        metadata = metadata,
    }

    if inventory.label then normalized.label = inventory.label end
    if inventory.weight then normalized.weight = inventory.weight end
    if inventory.durability ~= nil then normalized.durability = inventory.durability end

    return normalized
end

local function NormalizeInventoryItems(items)
    if type(items) ~= 'table' then return {} end

    local normalized = {}

    if items[1] then
        for i = 1, #items do
            local item = NormalizeInventoryItem(items[i])
            if item then
                normalized[#normalized + 1] = item
            end
        end
    else
        for slotKey, itemData in pairs(items) do
            local item = NormalizeInventoryItem(itemData, slotKey)
            if item then
                normalized[#normalized + 1] = item
            end
        end
    end

    table.sort(normalized, function(a, b)
        return (a.slot or 0) < (b.slot or 0)
    end)

    return normalized
end

local function NormalizeItemDefinition(itemName, itemData)
    if type(itemData) ~= 'table' then return nil end

    local name = inventory.name or itemName
    if not name then return nil end

    local stack = inventory.stack
    if stack == nil and inventory.unique ~= nil then
        stack = not inventory.unique
    end
    if stack == nil and inventory.stackable ~= nil then
        stack = inventory.stackable
    end

    local close = inventory.close
    if close == nil and inventory.shouldClose ~= nil then
        close = inventory.shouldClose
    end

    local normalized = {
        name = name,
        label = inventory.label or name,
        weight = inventory.weight or 0,
        stack = stack ~= false,
        close = close == true,
        description = inventory.description,
    }

    if inventory.client then normalized.client = inventory.client end
    if inventory.consume ~= nil then normalized.consume = inventory.consume end
    if inventory.degrade ~= nil then normalized.degrade = inventory.degrade end
    if inventory.durability ~= nil then normalized.durability = inventory.durability end
    if inventory.weapon ~= nil then normalized.weapon = inventory.weapon end
    if inventory.ammoName or inventory.ammo or inventory.ammoname then
        normalized.ammoName = inventory.ammoName or inventory.ammo or inventory.ammoname
    end
    if inventory.image and not (normalized.client and normalized.client.image) then
        normalized.client = normalized.client or {}
        normalized.client.image = inventory.image
    end

    return normalized
end

local function NormalizeItemDefinitions(items, itemName)
    if type(items) ~= 'table' then return nil end

    if itemName then
        local entry = items[itemName]
        if type(entry) == 'table' then
            return NormalizeItemDefinition(itemName, entry)
        end

        return NormalizeItemDefinition(itemName, items)
    end

    local normalized = {}

    for name, itemData in pairs(items) do
        if type(itemData) == 'table' then
            normalized[name] = NormalizeItemDefinition(name, itemData)
        end
    end

    return normalized
end

local function InventoryItemImage(itemData)
    if type(itemData) ~= 'table' then return nil end

    if inventory.client and inventory.client.image then
        return inventory.client.image
    end

    return inventory.image
end

local function InventoryStripImageExtension(value)
    if type(value) ~= 'string' or value == '' then return '' end

    return value
        :gsub('%.png$', '')
        :gsub('%.webp$', '')
        :gsub('%.jpg$', '')
        :gsub('%.jpeg$', '')
end

local function InventoryFindImageFile(resource, imageDir, filename)
    if type(filename) ~= 'string' or filename == '' then return nil end

    if filename:find('^nui://', 1, false) or filename:find('^https?://', 1, false) then
        return filename
    end

    local base = InventoryStripImageExtension(filename)
    local checks = {}

    if filename:find('%.', 1, true) then
        checks[#checks + 1] = ('%s/%s'):format(imageDir, filename)
    end

    if base ~= '' then
        checks[#checks + 1] = ('%s/%s.png'):format(imageDir, base)
        checks[#checks + 1] = ('%s/%s.webp'):format(imageDir, base)
    end

    for i = 1, #checks do
        if LoadResourceFile(resource, checks[i]) then
            return checks[i]
        end
    end

    return nil
end

local function InventoryImageNuiUrl(resource, relativePath)
    return ('nui://%s/%s'):format(resource, relativePath)
end

local function InventoryBuildImageUrl(itemName, itemData, resource, imageDir)
    resource = resource or 'ox_inventory'
    imageDir = imageDir or 'web/images'

    if type(itemData) == 'table' then
        itemData = NormalizeItemDefinition(itemName, itemData) or itemData
    end

    local defImage = InventoryItemImage(itemData)
    if type(defImage) == 'string' and defImage ~= '' and not defImage:find('fa%-', 1, false) then
        local resolved = InventoryFindImageFile(resource, imageDir, defImage)
        if resolved then
            if resolved:find('^nui://', 1, false) or resolved:find('^https?://', 1, false) then
                return resolved
            end

            return InventoryImageNuiUrl(resource, resolved)
        end
    end

    local itemFallback = InventoryFindImageFile(resource, imageDir, itemName)
    if itemFallback then
        if itemFallback:find('^nui://', 1, false) or itemFallback:find('^https?://', 1, false) then
            return itemFallback
        end

        return InventoryImageNuiUrl(resource, itemFallback)
    end

    local filename = defImage or itemName
    if type(filename) ~= 'string' or filename == '' then
        filename = itemName
    end

    if filename:find('^nui://', 1, false) or filename:find('^https?://', 1, false) then
        return filename
    end

    if not filename:find('%.', 1, false) then
        filename = filename .. '.png'
    end

    return InventoryImageNuiUrl(resource, ('%s/%s'):format(imageDir, filename))
end

local function InventoryBuildItemInfo(itemName, itemData, resource, imageDir)
    if type(itemData) == 'table' then
        itemData = NormalizeItemDefinition(itemName, itemData) or itemData
    end

    return {
        name = inventory.name or itemName,
        label = inventory.label or itemName,
        stack = inventory.stack ~= false,
        weight = inventory.weight or 0,
        description = inventory.description,
        image = InventoryBuildImageUrl(itemName, itemData, resource, imageDir),
    }
end

local function NormalizeHookPayload(eventName, payload)
    if type(payload) ~= 'table' then return payload end

    local normalized = table.clone(payload)

    if eventName == 'swapItems' then
        if type(payload.fromSlot) == 'table' then
            normalized.fromSlot = NormalizeInventoryItem(payload.fromSlot)
        end

        if type(payload.toSlot) == 'table' then
            normalized.toSlot = NormalizeInventoryItem(payload.toSlot)
        end
    elseif eventName == 'createItem' then
        if type(payload.item) == 'table' then
            normalized.item = NormalizeInventoryItem(payload.item)
        end
    elseif eventName == 'usingItem' then
        if type(payload.item) == 'table' then
            normalized.item = NormalizeInventoryItem(payload.item)
        end
    end

    return normalized
end

local function WrapInventoryHookCallback(eventName, callback)
    if type(callback) ~= 'function' then return callback end

    return function(payload)
        return callback(NormalizeHookPayload(eventName, payload))
    end
end
