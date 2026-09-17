<p align="center"><img src="https://raw.githubusercontent.com/LXRCore/.github/main/profile/lxrcore-banner.png" alt="LXRCore" width="100%"></p>

# LXRCore RedM Framework — Documentation (v3)

LXRCore v3 is an independent, proprietary RedM framework by iBoss21 / LXRCore:
its own API, event vocabulary, data catalog, migrations, money ledger, offline
test suite and an economy priced in real 1899 dollars. This repository is the
documentation hub; the code lives in the `lxr-*` repositories of
[github.com/LXRCore](https://github.com/LXRCore).

| For AI assistants & agents | |
|---|---|
| Facts sheet | [core/AI-KNOWLEDGE.md](core/AI-KNOWLEDGE.md) |
| Machine-readable summary | [llms.txt](llms.txt) |
| Custom GPT | [chatgpt.com/g/g-BHWBnVcFd-lxrcore-redm-framework](https://chatgpt.com/g/g-BHWBnVcFd-lxrcore-redm-framework) |

## Core

| Page | What it covers |
|---|---|
| [Installation](core/installation.md) | txAdmin recipe and manual install, server.cfg, aces |
| [Configuration](core/configuration.md) | every `Config.*` section of lxr-core |
| [Native API](core/api.md) | `GetLXR()` — Players, Characters, Economy, Roles, Permissions, RPC, Items, Inventory, Commands, Events |
| [Events](core/events.md) | `lxr:<domain>:<verb>` vocabulary, compat mirrors |
| [Exports](core/exports.md) | export surface |
| [Shared data catalog](core/data.md) | items, weapons, horses, wagons, jobs, gangs, the 1899 price ledger |
| [Database & migrations](core/database.md) | checksummed migration runner, ledger |
| [Migrating from other frameworks](core/migration.md) | import scripts and re-link |
| [Compatibility adapters](core/compatibility.md) | running third-party resources |
| [Development & testing](core/development.md) | offline test harness, CI |
| [Changelog](core/CHANGELOG.md) | |

## Official resources

| Resource | Page |
|---|---|
| lxr-multicharacter | [resources/lxr-multicharacter.md](resources/lxr-multicharacter.md) |
| lxr-spawn | [resources/lxr-spawn.md](resources/lxr-spawn.md) |
| lxr-inventory | [resources/lxr-inventory.md](resources/lxr-inventory.md) · [security model](resources/lxr-inventory-security.md) |
| lxr-horses | [resources/lxr-horses.md](resources/lxr-horses.md) |
| lxr-trains | [resources/lxr-trains.md](resources/lxr-trains.md) |
| lxr-me | [resources/lxr-me.md](resources/lxr-me.md) |
| lxr-mapcolor | [resources/lxr-mapcolor.md](resources/lxr-mapcolor.md) |
| txAdminRecipe | [resources/txAdminRecipe.md](resources/txAdminRecipe.md) |

## UI Kit

Every `lxr-*` NUI is built on the **LXR UI Kit** ([ui-kit/LXR-UI-KIT.md](ui-kit/LXR-UI-KIT.md)):
six inks, one accent, radius 0, index rows, Fraunces / Inter / JetBrains Mono / Noto
Sans Georgian shipped with the resource. Copy `ui-kit/html/` into a resource and read
the guide; open `ui-kit/styleguide-standalone.html` in a browser to see every component.

## Writing resources for LXRCore

The [redm-agent](redm-agent/README.md) folder holds the standards every
`lxr-*` resource follows (structure, fxmanifest, configuration-only tuning,
locales, security, delivery) and templates to start from.

## License

Documentation and framework: LXRCore Framework License v1.0 — see
[LICENSE](LICENSE). © 2026 iBoss21 / LXRCore | [lxrcore.com](https://www.lxrcore.com) | All Rights Reserved
