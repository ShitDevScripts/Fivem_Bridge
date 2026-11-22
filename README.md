# Fivem_Bridge

A framework-agnostic bridge for FiveM. One API for frameworks, inventories, targets, notifications, banking, dispatch, menus, vehicle keys/fuel, task groups and more.

This build is adapted from **Newb_Bridge** by **MrNewb** and from **community_bridge** by The Order of the Sacred Framework. It has been renamed, reorganised and tweaked for this server, but a lot of the original work is still underneath — see the credits below.

## Credits — big thanks

Huge thanks to **MrNewb** and everyone behind **Newb_Bridge**. The module system, the provider adapters and the utility code saved a ton of work and gave this bridge its shape.

Also huge thanks to **The Order of the Sacred Framework** and the contributors to **community_bridge**. The extra provider adapters (clothing, doorlock, housing, phone, skills, weather, zones and more) came from there. Community Bridge category names were mapped to this bridge's names (`fuel` → `vehiclefuel`, `input` → `inputs`, `notify` → `notifications`, `vehiclekey` → `vehiclekeys`, `helptext` → `textui`, `_default` → `internal`) and its `community_bridge:` events were renamed to `Fivem_Bridge:`.

Thanks also to the teams behind **ox_lib**, **oxmysql** and everyone else listed in [ATTRIBUTIONS.md](ATTRIBUTIONS.md).

The upstream Lua code is licensed **GPL-3.0**. Those notices are kept on purpose: [LICENSE](LICENSE) holds the full licence text and [ATTRIBUTIONS.md](ATTRIBUTIONS.md) lists the original authors. If you share this resource with other people, keep those files with it.

## What is in here

```
Fivem_Bridge/
├── config/            provider selection and debug/version settings
│   ├── bridge_resources.lua
│   └── auto_detect.lua
├── locales/           32 translation files (en.json is the fallback)
├── modules/           provider adapters (311 Lua files)
│   ├── banking/       bossmenu/     clothing/     dialogue/
│   ├── dispatch/      doorlock/     framework/    housing/
│   ├── inputs/        inventory/    menu/         notifications/
│   ├── phone/         progressbar/  shops/        skills/
│   ├── target/        textui/       vehiclefuel/  vehiclekeys/
│   ├── version/       weather/      zones/
├── utility/           shared helpers, client tools and server helpers
├── types/             Lua type annotations
├── import.lua         consumer-side lazy loader
├── fxmanifest.lua
├── ATTRIBUTIONS.md
├── LICENSE
└── README.md
```

**No `web/` folder in this build**, as requested. There is no `ui_page` and no NUI assets.

### About the UI-backed utilities

All upstream utilities are present. The ones that drew NUI (`dialogue`, `gizmo`, `placer`, `zone_creator`, `task_hud`, `task_groups` menu) are still loaded, so their non-UI APIs keep working, but nothing will be drawn without a NUI page. `dui_surface.lua` detects the missing `web/build/dui_surface.html` and registers safe no-op exports instead of creating broken DUI browsers. If you add a compatible web UI later, those features light up again.

## Install

1. Put this folder in your `resources/` directory as `Fivem_Bridge` (the name is hardcoded in `import.lua`, so keep the folder name as-is).
2. Make sure `ox_lib` and `oxmysql` are installed and started first.
3. Add to `server.cfg`:

```cfg
ensure ox_lib
ensure oxmysql
ensure Fivem_Bridge
```

4. Set `ox:locale` if you want a language other than English: `setr ox:locale en`.
5. Edit `config/bridge_resources.lua`. Everything defaults to `"auto"` except `Config.Banking`, which is pinned to `ShitDevScripts-Banking` (inherited from the source build). Set `Config.Debug = true` to see the startup banner and module warnings.

Other resources can use the bridge by adding this to their `fxmanifest.lua`:

```lua
shared_scripts {
    '@Fivem_Bridge/import.lua',
}
```

then:

```lua
local player = bridge.framework.GetPlayer(source)
bridge.notify({ message = 'Hello from Fivem_Bridge', type = 'success' })
```

## What changed from the upstream build

- Resource renamed to `Fivem_Bridge`; events, console prefixes, locale brand and export host lookup now use that name.
- `Config` lives in `config/` (`bridge_resources.lua`, `theme.lua`, `auto_detect.lua`); paths match `fxmanifest.lua` and `import.lua`.
- Resource name is hardcoded as `Fivem_Bridge` in `import.lua`; no config value or convar controls it.
- Added a debug startup banner showing context, module count and host resource.
- Web/NUI assets removed; DUI utilities degrade safely when the page is missing.
- Theme module, `config/theme.lua` and the `GetTheme`/`GetThemeCss` exports removed (no UI to theme).
- Version bumped to `1.0.0`, manifest description and comments rewritten.
- Added every missing module from community_bridge in this bridge's `modules/<category>/<provider>/{client,server,shared}.lua` layout, including new config keys (`Clothing`, `Doorlock`, `Housing`, `Phone`, `Shops`, `Skills`, `Weather`, `Zones`) and provider lists in `config/auto_detect.lua`.
- `utility/shared/community_compat.lua` provides `Require` / `Callback` helpers for the adapted community modules. They load from the installed `community_bridge` resource when available and fall back to no-ops otherwise.
- Original credit/licence notices preserved in every utility file, `ATTRIBUTIONS.md` and `LICENSE`.

## Licence

GPL-3.0 work by MrNewb, The Order of the Sacred Framework and contributors. See [LICENSE](LICENSE), [ATTRIBUTIONS.md](ATTRIBUTIONS.md) and community_bridge's own `Attributions.md`/`LICENSE` in the source server. Provided without warranty.
