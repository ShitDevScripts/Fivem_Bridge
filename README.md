# Fivem_Bridge

A framework-agnostic bridge for FiveM. It exposes one API for frameworks, inventories, targets, notifications, banking, dispatch, menus, vehicle keys and fuel, and the other provider-backed modules under `modules/`.

This build is adapted from **Newb_Bridge** by **MrNewb** and **community_bridge** by The Order of the Sacred Framework. See [Attributions.md](Attributions.md) for the full credits.

## Structure

```
Fivem_Bridge/
├── config/
│   ├── bridge_resources.lua
│   └── auto_detect.lua
├── locales/
├── modules/
├── utility/shared/
│   ├── locale.lua
│   └── shims.lua
├── import.lua
├── fxmanifest.lua
├── Attributions.md
├── LICENSE
└── README.md
```

## Install

1. Put this folder in your `resources/` directory as `Fivem_Bridge`.
2. Make sure `ox_lib` and `oxmysql` are installed and started first.
3. Add to `server.cfg`:

```cfg
ensure ox_lib
ensure oxmysql
ensure Fivem_Bridge
```

4. Edit `config/bridge_resources.lua` to pin providers, or leave everything on `"auto"`.
5. Set `ox:locale` if you want a language other than English: `setr ox:locale en`.

Other resources can use the bridge by adding this to their `fxmanifest.lua`:

```lua
shared_scripts {
    '@Fivem_Bridge/import.lua',
}
```

Then:

```lua
local player = bridge.framework.getPlayer(source)
bridge.notifications.notify(source, { description = 'Hello from Fivem_Bridge', type = 'success' })
```

## Licence

GPL-3.0 work by MrNewb, The Order of the Sacred Framework and contributors. See [LICENSE](LICENSE) and [Attributions.md](Attributions.md).
