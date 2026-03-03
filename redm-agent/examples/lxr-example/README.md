<!--
    ██╗     ██╗  ██╗██████╗        ███████╗██╗  ██╗ █████╗ ███╗   ███╗██████╗ ██╗     ███████╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔════╝╚██╗██╔╝██╔══██╗████╗ ████║██╔══██╗██║     ██╔════╝
    ██║      ╚███╔╝ ██████╔╝       █████╗   ╚███╔╝ ███████║██╔████╔██║██████╔╝██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗       ██╔══╝   ██╔██╗ ██╔══██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ███████╗██╔╝ ██╗██║  ██║██║ ╚═╝ ██║██║     ███████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
-->

# 🐺 LXR Example

```
██╗     ██╗  ██╗██████╗        ███████╗██╗  ██╗ █████╗ ███╗   ███╗██████╗ ██╗     ███████╗
██║     ╚██╗██╔╝██╔══██╗       ██╔════╝╚██╗██╔╝██╔══██╗████╗ ████║██╔══██╗██║     ██╔════╝
██║      ╚███╔╝ ██████╔╝       █████╗   ╚███╔╝ ███████║██╔████╔██║██████╔╝██║     █████╗  
██║      ██╔██╗ ██╔══██╗       ██╔══╝   ██╔██╗ ██╔══██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝  
███████╗██╔╝ ██╗██║  ██║       ███████╗██╔╝ ██╗██║  ██║██║ ╚═╝ ██║██║     ███████╗███████╗
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝
```

**Production-grade example RedM resource for The Land of Wolves 🐺**  
*Demonstrates all wolves.land / LXR standards including multi-framework support, security, and Tebex escrow compliance*

═══════════════════════════════════════════════════════════════════════════════

| | |
|---|---|
| **Version** | 1.0.0 |
| **Game** | RedM (Red Dead Redemption 2 Multiplayer) |
| **Author** | iBoss21 / The Lux Empire |
| **Server** | The Land of Wolves 🐺 |
| **Website** | https://www.wolves.land |
| **Discord** | https://discord.gg/CrKcWdfd3A |
| **Store** | https://theluxempire.tebex.io |

═══════════════════════════════════════════════════════════════════════════════

## 📋 Overview

**lxr-example** is a complete, production-ready RedM resource that acts as both a working resource **and** a reference implementation of all wolves.land / LXR development standards:

- ✅ Mega branded ASCII file headers
- ✅ Multi-framework auto-detection (LXR-Core, RSG-Core, VORP, RedEM:RP, QBR, QR, Standalone)
- ✅ Unified framework adapter (no direct framework calls in gameplay code)
- ✅ Server-authoritative security (distance, cooldown, rate-limit, logging)
- ✅ Tebex escrow compliant structure
- ✅ Resource name runtime protection guard
- ✅ Startup boot banner
- ✅ Full documentation

═══════════════════════════════════════════════════════════════════════════════

## 🏗️ File Structure

```
lxr-example/
├── fxmanifest.lua          ← Branded manifest (NOT obfuscated)
├── config.lua              ← Buyer-configurable settings (NOT obfuscated)
├── shared/
│   └── framework-bridge.lua ← Universal framework adapter (obfuscated)
├── client/
│   └── main.lua            ← Client-side interactions (obfuscated)
├── server/
│   └── main.lua            ← Server-side validation & economy (obfuscated)
└── README.md               ← This file (NOT obfuscated)
```

═══════════════════════════════════════════════════════════════════════════════

## ✅ Framework Support

| Framework | Status | Notes |
|-----------|--------|-------|
| LXR Core | ✅ Primary | Auto-detected first |
| RSG Core | ✅ Primary | Auto-detected second |
| VORP Core | ✅ Supported | Full inventory & money support |
| RedEM:RP | ✅ Compatible | Basic support |
| QBR Core | ✅ Compatible | |
| QR Core | ✅ Compatible | |
| Standalone | ✅ Fallback | Works without any framework |

Set `Config.Framework = 'auto'` (default) for automatic detection, or manually specify a framework string in `config.lua`.

═══════════════════════════════════════════════════════════════════════════════

## ⚙️ Installation

### Requirements

- RedM server (FXServer with `rdr3` game mode)
- One of the supported frameworks **or** standalone mode
- *(Optional)* `ox_lib` — for ox_lib notifications and progress bars
- *(Optional)* `ox_target` — for target-based interactions

### Steps

1. **Copy the resource** into your server's `resources/` directory:

   ```
   resources/
   └── [wolves-land]/
       └── lxr-example/   ← This folder must be named exactly "lxr-example"
   ```

   > ⚠️ **The folder MUST be named `lxr-example`** — renaming it will trigger the resource name protection guard and prevent the resource from starting.

2. **Add to `server.cfg`**:

   ```cfg
   ensure lxr-example
   ```

   Make sure your framework resource starts **before** lxr-example:

   ```cfg
   ensure lxr-core    # or rsg-core / vorp_core
   ensure lxr-example
   ```

3. **Configure** `config.lua`:
   - Set `Config.Lang` to your preferred language (`'en'` or `'ge'`)
   - Adjust `Config.RewardItems` for your server's economy
   - Set `Config.Security.webhookUrl` if you want Discord security alerts
   - Leave `Config.Debug = false` for production

4. **Restart** your server or run `refresh` + `ensure lxr-example` in the server console.

═══════════════════════════════════════════════════════════════════════════════

## 🔧 Configuration

All configuration is in `config.lua`. Key sections:

### Framework
```lua
Config.Framework = 'auto'   -- Auto-detect | or: 'lxr-core', 'rsg-core', 'vorp_core', etc.
```

### Reward Items
```lua
Config.RewardItems = {
    { name = 'water',       label = 'Water Canteen',  minCount = 1, maxCount = 2,  chance = 0.80 },
    { name = 'bandage',     label = 'Bandage',         minCount = 1, maxCount = 3,  chance = 0.40 },
    { name = 'gold_nugget', label = 'Gold Nugget',     minCount = 1, maxCount = 1,  chance = 0.10 },
}
```

### Security
```lua
Config.Security = {
    enabled              = true,
    maxDistance          = 5.0,       -- Server-side max interaction distance (metres)
    maxActionsPerMinute  = 10,        -- Rate limit per player
    logSuspiciousActivity = true,     -- Log to console
    webhookUrl           = '',        -- Discord webhook URL (leave empty to disable)
}
```

### Debug
```lua
Config.Debug = false   -- Set true during development; MUST be false for production
```

═══════════════════════════════════════════════════════════════════════════════

## 🔐 Security Model

All critical operations are **server-authoritative**:

1. Client sends `lxr-example:server:performAction` with their coordinates
2. Server validates:
   - Player is alive and exists
   - Rate limit not exceeded
   - Cooldown timer has elapsed
   - Player is within `Config.Security.maxDistance` of the target (using **server-side** coordinates)
3. Server selects and gives the reward via the framework adapter
4. Server notifies the client of success or failure

**The client never handles money, items, or inventory directly.**

═══════════════════════════════════════════════════════════════════════════════

## 📦 Tebex Escrow Compliance

This resource is structured for Tebex escrow submission:

| File | Obfuscated? | Reason |
|------|------------|--------|
| `fxmanifest.lua` | ❌ No | FXServer requires readable manifest |
| `config.lua` | ❌ No | Buyers need to configure settings |
| `shared/framework-bridge.lua` | ✅ Yes | Proprietary framework adapter |
| `client/main.lua` | ✅ Yes | Core gameplay logic |
| `server/main.lua` | ✅ Yes | Core gameplay logic |
| `README.md` | ❌ No | Documentation must be readable |

See [Tebex Escrow Standards](../../standards/tebex-escrow.md) for full compliance requirements.

═══════════════════════════════════════════════════════════════════════════════

## 📜 Events Reference

### Client → Server

| Event | Description | Parameters |
|-------|-------------|------------|
| `lxr-example:server:performAction` | Request server to process the action | `coords` (vector3) |

### Server → Client

| Event | Description | Parameters |
|-------|-------------|------------|
| `lxr-example:client:actionSuccess` | Action completed, reward given | `rewardData` (table) |
| `lxr-example:client:actionFailed` | Action rejected | `reason` (string) |
| `lxr-example:client:playerDataUpdated` | Player data refreshed | `data` (table) |

═══════════════════════════════════════════════════════════════════════════════

## 🛠️ Adapting This Example

To create your own resource based on this example:

1. **Copy** the entire `lxr-example/` folder
2. **Rename** the folder to `lxr-yourname`
3. **Update** `fxmanifest.lua`:
   - `name 'lxr-yourname'`
   - `description '...'`
   - `repository '...'`
4. **Update** `config.lua`:
   - Change `REQUIRED_RESOURCE_NAME = "lxr-yourname"`
   - Update `Config.ServerInfo.tags`
   - Modify `Config.RewardItems` (or replace with your own config sections)
5. **Replace** the gameplay logic in `client/main.lua` and `server/main.lua`
6. **Validate** against the [Validation Checklist](../../validation-checklist.md)

═══════════════════════════════════════════════════════════════════════════════

## 🔗 Related Documentation

- [Main Agent README](../../README.md)
- [Branding & File Style](../../standards/branding-and-style.md)
- [Multi-Framework Support](../../standards/multi-framework.md)
- [Security Standards](../../standards/security.md)
- [FXManifest Standards](../../standards/fxmanifest.md)
- [Tebex Escrow Standards](../../standards/tebex-escrow.md)
- [Validation Checklist](../../validation-checklist.md)

═══════════════════════════════════════════════════════════════════════════════

## 📜 License & Credits

**Author**: iBoss21 / The Lux Empire  
**Owner/Brand**: 🐺 wolves.land — The Land of Wolves (The Lux Empire)

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved

This resource is sold through [The Lux Empire Tebex Store](https://theluxempire.tebex.io). Redistribution, re-uploading, or reselling this resource without express written permission is strictly prohibited.

═══════════════════════════════════════════════════════════════════════════════
