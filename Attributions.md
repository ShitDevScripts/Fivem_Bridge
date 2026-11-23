> This build is `Fivem_Bridge`, adapted from **Newb_Bridge** by MrNewb, with additional module adapters from **community_bridge** by The Order of the Sacred Framework.

# Attributions

The Lua resource — `import.lua`, `modules/`, `utility/shared/`, `config/`, and `locales/` — is distributed under the **GNU General Public License, version 3** (`GPL-3.0-only`). See [LICENSE](LICENSE) for the full terms. It is distributed WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

GPL-3.0 is the strongest copyleft among the components below, so it governs the work; the LGPL-3.0 components are compatible and are conveyed under those same GPL-3.0 terms.

Each entry below lists the file(s) in this repository, the upstream source, authors where known, and the license that applies to that upstream work.

If you redistribute this resource, you are responsible for complying with the license terms of each attributed component.

---

## Lazy loader

| File | Upstream | License |
|---|---|---|
| [`import.lua`](import.lua) | [overextended/ox_lib](https://github.com/overextended/ox_lib) — `init.lua` lazy-load pattern | **LGPL-3.0-or-later** |

- Copyright (C) 2021 Linden ([@thelindat](https://github.com/thelindat))
- Modified for Newb_Bridge module loading

---

## Community Bridge (module adapters)

The provider adapters under `modules/` are adapted from Community Bridge's provider files to this bridge's module style: a local API table, literal resource names, and no globals or `---@diagnostic` headers. Export calls, argument order and return values are unchanged from upstream.

| Files | Upstream | License |
|---|---|---|
| `modules/banking/**` | [community_bridge/modules/banking](https://github.com/MrNewb/community_bridge/tree/master/modules/banking) | **GPL-3.0** |
| `modules/bossmenu/**` | [community_bridge/modules/bossmenu](https://github.com/MrNewb/community_bridge/tree/master/modules/bossmenu) | **GPL-3.0** |
| `modules/dialogue/**` | [community_bridge/modules/dialogue](https://github.com/MrNewb/community_bridge/tree/master/modules/dialogue) | **GPL-3.0** |
| `modules/doorlock/**` | [community_bridge/modules/doorlock](https://github.com/MrNewb/community_bridge/tree/master/modules/doorlock) | **GPL-3.0** |
| `modules/housing/**` | [community_bridge/modules/housing](https://github.com/MrNewb/community_bridge/tree/master/modules/housing) | **GPL-3.0** |
| `modules/phone/**` | [community_bridge/modules/phone](https://github.com/MrNewb/community_bridge/tree/master/modules/phone) | **GPL-3.0** |
| `modules/shops/**` | [community_bridge/modules/shops](https://github.com/MrNewb/community_bridge/tree/master/modules/shops) | **GPL-3.0** |
| `modules/skills/**` | [community_bridge/modules/skills](https://github.com/MrNewb/community_bridge/tree/master/modules/skills) | **GPL-3.0** |
| `modules/version/**` | [community_bridge/modules/version](https://github.com/MrNewb/community_bridge/tree/master/modules/version) | **GPL-3.0** |
| `modules/weather/**` | [community_bridge/modules/weather](https://github.com/MrNewb/community_bridge/tree/master/modules/weather) | **GPL-3.0** |
| `modules/zones/**` | [community_bridge/modules/zones](https://github.com/MrNewb/community_bridge/tree/master/modules/zones) | **GPL-3.0** |

- Upstream: [The-Order-of-the-Sacred-Framework/community_bridge](https://github.com/The-Order-of-the-Sacred-Framework/community_bridge) — The Order of the Sacred Framework
- MrNewbScripts fork: [MrNewb/community_bridge](https://github.com/MrNewb/community_bridge)

---

## Renewed-Lib (routing buckets & player cache)

Portions of the framework player cache and interaction bucket gating follow **patterns popularized by** Renewed-Lib. The implementation code in this repository is original (ox_lib `lib.player` routing buckets, `lib.class` snapshots, bridge API wiring). Job/duty tracking lives in `server_helpers.lua`'s duty cache and `player_registry.lua`'s `BridgePlayer` snapshot.

| File | Renewed-Lib concept | License |
|---|---|---|
| [`modules/framework/player_registry.lua`](modules/framework/player_registry.lua) | Cached `BridgePlayer` snapshot, char id lookup | **GPL-3.0** |
| [`modules/framework/server_helpers.lua`](modules/framework/server_helpers.lua) | Incremental `GlobalState` job counts (`newbsJobCounts`) | **GPL-3.0** |

- Upstream: [Renewed-Scripts/Renewed-Lib](https://github.com/Renewed-Scripts/Renewed-Lib) — Renewed Scripts (FjamZoo et al.)
- Docs: [renewed.dev/lib](https://renewed.dev/lib)

---

## ox_lib (runtime dependency)

This bridge depends on [ox_lib](https://github.com/overextended/ox_lib) at runtime for utilities such as `lib.print`, `lib.requestModel`, locale helpers, and UI primitives. ox_lib is **not** bundled in this repository.

| Resource | License |
|---|---|
| [overextended/ox_lib](https://github.com/overextended/ox_lib) | **LGPL-3.0-or-later** |

---

## API shapes

Several bridge modules intentionally mirror **ox_lib**-style APIs (context menus, progress bars, notifications, inputs) so scripts written against common industry patterns work across providers. Implementation code in `modules/` is original to Newb_Bridge unless noted above.

---

## Summary

The Lua resource is distributed under **GPL-3.0-only**.

| License | Components |
|---|---|
| **GPL-3.0** | Community Bridge module adapters; Renewed-Lib-derived framework patterns |
| **LGPL-3.0-or-later** | `import.lua` (ox_lib `init.lua` pattern) |

### Runtime dependencies (not bundled)

| Resource | License |
|---|---|
| [overextended/ox_lib](https://github.com/overextended/ox_lib) | LGPL-3.0-or-later — required at runtime, not redistributed here |
| [overextended/oxmysql](https://github.com/overextended/oxmysql) | LGPL-3.0-or-later — required at runtime, not redistributed here |
