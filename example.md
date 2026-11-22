# fivem_Bridge — Usage Examples

All examples assume you load the bridge in your resource via `shared_script '@fivem_Bridge/import.lua'` (or the correct path/name of this resource). Use `bridge` (global set by import) or the exported helpers.

## Require / access

```lua
-- In any resource that depends on fivem_Bridge
local Bridge = exports.fivem_Bridge
-- or use the global `bridge` after import.lua loads
```

## Locale

```lua
local text = bridge.locale('some.key')
local text2 = bridge.locale('welcome', { name = 'Alex' })
```

## Framework (server/client as supported)

```lua
-- Server
local fw = bridge.framework
local src = source
local cid = fw.getIdentifier(src)
local job = fw.getJob(src)
local count = fw.getPlayersByJob('police')
```

```lua
-- Client
local fw = bridge.framework
local job = fw.getJobData()
```

## Notifications (client)

```lua
bridge.notify({
    title = 'Hello',
    description = 'Message body',
    type = 'success', -- info | success | warning | error (provider dependent)
    duration = 5000,
})
```

## Progress bar (client)

```lua
local ok = bridge.progressbar({
    duration = 4000,
    label = 'Doing something...',
    useWhileDead = false,
    canCancel = true,
    disable = { move = true, car = true, combat = true },
})
if ok then
    -- finished
end
```

## Inputs (client)

```lua
local result = bridge.inputs({
    title = 'My form',
    inputs = {
        { type = 'input', label = 'Name', name = 'name', required = true },
        { type = 'number', label = 'Amount', name = 'amount', default = 1 },
    },
})
if result then
    print(result.name, result.amount)
end
```

## Text UI (client)

```lua
bridge.textui.show('[E] Open menu')
-- later
bridge.textui.hide()
```

## Menu (client)

```lua
bridge.menu.openMenu({
    id = 'example_menu',
    title = 'Example',
    options = {
        {
            title = 'Do thing',
            description = 'Runs an action',
            onSelect = function()
                print('selected')
            end,
        },
    },
})
```

## Target (client)

```lua
-- Entity example (shape depends on provider wrapper; see modules/target/* for exact API)
-- Common pattern via bridge.target helpers if exposed by your setup:
-- Prefer following the same calls used in Newb_Bridge resources you already have.
```

## Inventory (server)

```lua
local inv = bridge.inventory
local src = source
local hasItem = inv.hasItem(src, 'water', 1)
if hasItem then
    inv.removeItem(src, 'water', 1)
    inv.addItem(src, 'sandwich', 1)
end
```

## Banking (server)

```lua
local bank = bridge.banking
local account = 'police'
local bal = bank.getAccountBalance(account)
bank.addAccountMoney(account, 100, 'Reward')
bank.removeAccountMoney(account, 50, 'Fine')
```

## Dispatch (server)

```lua
bridge.dispatch.sendAlert(source, { 'police' }, GetEntityCoords(GetPlayerPed(source)), {
    code = '10-31',
    title = 'Suspicious activity',
    description = 'Check the area.',
    blip = { sprite = 161, colour = 1, scale = 1.0, text = 'Call', length = 60 },
}, nil, false)
```

## Vehicle keys / fuel (examples)

```lua
-- Vehicle keys and fuel APIs vary by provider; use bridge.vehiclekeys / bridge.vehiclefuel
-- and mirror calls from Newb_Bridge module implementations for your installed resources.
```

## Notes

- Provider is chosen by `config/bridge_resources.lua` and `config/auto_detect.lua` (same as Newb).  
- Some modules are client/server only (e.g. dispatch helpers are typically server-side entrypoints as in Newb).  
- For exact function names per module, read the corresponding files under `modules/<module>/<provider>/` or the shared wrappers in `modules/<module>/`.
