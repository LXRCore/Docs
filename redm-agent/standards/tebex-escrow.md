# 🐺 Tebex Escrow Compliance Standards

```
██╗     ██╗  ██╗██████╗        ████████╗███████╗██████╗ ███████╗██╗  ██╗
██║     ╚██╗██╔╝██╔══██╗       ╚══██╔══╝██╔════╝██╔══██╗██╔════╝╚██╗██╔╝
██║      ╚███╔╝ ██████╔╝          ██║   █████╗  ██████╔╝█████╗   ╚███╔╝ 
██║      ██╔██╗ ██╔══██╗          ██║   ██╔══╝  ██╔══██╗██╔══╝   ██╔██╗ 
███████╗██╔╝ ██╗██║  ██║          ██║   ███████╗██████╔╝███████╗██╔╝ ██╗
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝          ╚═╝   ╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═╝

███████╗███████╗ ██████╗██████╗  ██████╗ ██╗    ██╗
██╔════╝██╔════╝██╔════╝██╔══██╗██╔═══██╗██║    ██║
█████╗  ███████╗██║     ██████╔╝██║   ██║██║ █╗ ██║
██╔══╝  ╚════██║██║     ██╔══██╗██║   ██║██║███╗██║
███████╗███████║╚██████╗██║  ██║╚██████╔╝╚███╔███╔╝
╚══════╝╚══════╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ 
```

**Standard**: Tebex Escrow Compliance (MANDATORY FOR STORE ASSETS)  
**wolves.land | The Land of Wolves 🐺**  
**Store**: https://theluxempire.tebex.io

═══════════════════════════════════════════════════════════════════════════════

## Overview

All resources sold through the [The Lux Empire Tebex store](https://theluxempire.tebex.io) **MUST** be Tebex escrow compliant. Tebex escrow protects intellectual property by obfuscating and licensing resource files so they can only be used by customers who have purchased them.

This standard defines the **mandatory requirements** for every resource to pass Tebex escrow protection and function correctly after purchase and deployment.

═══════════════════════════════════════════════════════════════════════════════

## 🔑 What is Tebex Escrow?

Tebex escrow is a code protection system built into the CFX (FiveM/RedM) platform:

- **Obfuscation**: Lua source files are encrypted and bound to specific server licenses
- **License Binding**: The resource only runs on servers that have purchased it via Tebex
- **IP Protection**: Prevents redistribution or resale of protected resources
- **Automatic Validation**: CFX runtime validates the escrow token at startup

When a customer purchases a resource from your Tebex store, they receive an encrypted version that is bound to their server's license key.

═══════════════════════════════════════════════════════════════════════════════

## 📋 Mandatory Requirements

### 1. Exact Resource Name in fxmanifest.lua

The `name` field in `fxmanifest.lua` **MUST** exactly match the resource folder name. This is critical for escrow binding.

```lua
-- fxmanifest.lua
name 'lxr-example'  -- MUST match the folder name exactly
```

> ⚠️ **If the name does not match the folder, escrow validation will FAIL.**

### 2. Runtime Resource Name Protection

Every `config.lua` **MUST** include a runtime guard at the top:

```lua
local REQUIRED_RESOURCE_NAME = "lxr-example"
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error(string.format([[
        
        ═══════════════════════════════════════════════════════════════════════════════
        ❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
        ═══════════════════════════════════════════════════════════════════════════════
        
        Expected: %s
        Got: %s
        
        This resource is branded and must maintain the correct name.
        Rename the folder to "%s" to continue.
        
        🐺 wolves.land - The Land of Wolves
        
        ═══════════════════════════════════════════════════════════════════════════════
        
    ]], REQUIRED_RESOURCE_NAME, currentResourceName, REQUIRED_RESOURCE_NAME))
end
```

### 3. fxmanifest.lua Required Fields

Every manifest **MUST** include these fields in this exact order:

```lua
fx_version 'cerulean'
game       'rdr3'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources WILL become incompatible once RedM ships.'

name        'lxr-[resource-name]'
author      'iBoss21 / The Lux Empire'
description '[Clear description of what this resource does]'
version     '1.0.0'
```

### 4. No External Dependencies in Escrow-Protected Files

Escrow-protected (obfuscated) files **CANNOT** load external files dynamically at runtime. All file paths must be declared in `fxmanifest.lua`:

```lua
-- ✅ CORRECT: Declare all files in manifest
shared_scripts {
    'config.lua',
    'shared/framework-bridge.lua',
}

-- ❌ WRONG: Dynamic file loading inside Lua (will break escrow)
-- loadfile('config.lua')()
-- dofile('config.lua')
```

### 5. Escrow-Safe Lua Features

Avoid features that may cause issues with Tebex escrow obfuscation:

| Feature | Escrow Safe? | Notes |
|---------|-------------|-------|
| `require()` | ❌ No | Use `fxmanifest.lua` declarations instead |
| `loadfile()` | ❌ No | Declare files in manifest |
| `dofile()` | ❌ No | Declare files in manifest |
| `load()` with string | ⚠️ Caution | May break obfuscation |
| `debug.getinfo()` | ⚠️ Caution | May return obfuscated names |
| `string.dump()` | ❌ No | Will not work on obfuscated functions |
| Standard Lua tables | ✅ Yes | Fully supported |
| `CreateThread()` | ✅ Yes | Fully supported |
| `RegisterNetEvent()` | ✅ Yes | Fully supported |
| `exports` | ✅ Yes | Fully supported |

### 6. Metadata and Author Attribution

All files submitted to Tebex must include the standard author metadata:

```lua
-- In fxmanifest.lua
author      'iBoss21 / The Lux Empire'
```

```lua
-- In every Lua file header
-- © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
```

═══════════════════════════════════════════════════════════════════════════════

## 📁 Escrow-Ready File Structure

The following structure is required for Tebex escrow submission:

```
lxr-[resource-name]/
├── fxmanifest.lua          ← NEVER obfuscated (manifest is public)
├── config.lua              ← Can be left unobfuscated (configurable by buyer)
├── shared/
│   └── framework-bridge.lua ← Obfuscated
├── client/
│   └── main.lua            ← Obfuscated
├── server/
│   └── main.lua            ← Obfuscated
├── html/                   ← UI files (not obfuscated)
│   ├── index.html
│   ├── style.css
│   └── script.js
├── README.md               ← NEVER obfuscated (documentation is public)
└── docs/
    └── *.md                ← NEVER obfuscated
```

### Files to Obfuscate (Protect)
- `shared/framework-bridge.lua`
- `client/main.lua` (and any additional client files)
- `server/main.lua` (and any additional server files)

### Files to Leave Unobfuscated (Open)
- `fxmanifest.lua` — Required to be readable by the FXServer runtime
- `config.lua` — Buyers need to configure the resource
- `html/` — Web assets must be readable by the browser
- `README.md` and all docs — Documentation must be readable
- SQL files — Database schemas must be readable

═══════════════════════════════════════════════════════════════════════════════

## 🛒 Tebex Store Submission Checklist

Before submitting to [theluxempire.tebex.io](https://theluxempire.tebex.io):

### Resource Metadata
- [ ] Resource folder name matches `name` in `fxmanifest.lua`
- [ ] `name` field uses `lxr-` prefix (e.g., `lxr-example`)
- [ ] `author` is `iBoss21 / The Lux Empire`
- [ ] `version` is semantic (e.g., `1.0.0`)
- [ ] `description` is clear and accurate (shown on Tebex product page)

### Technical Compliance
- [ ] No `require()`, `loadfile()`, or `dofile()` calls
- [ ] All files declared in `fxmanifest.lua`
- [ ] Runtime resource name protection guard in `config.lua`
- [ ] No hardcoded server-specific data (IP addresses, tokens, etc.)
- [ ] `rdr3_warning` present in fxmanifest

### Branding Compliance
- [ ] All Lua files have wolves.land branded headers
- [ ] Copyright notice `© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved`
- [ ] Config.ServerInfo populated with correct wolves.land data

### Documentation
- [ ] `README.md` with complete installation instructions
- [ ] Screenshots showing the resource in action
- [ ] Configuration guide for buyers
- [ ] Framework compatibility notes

### Quality
- [ ] Resource tested and working before submission
- [ ] No syntax errors
- [ ] No debug prints left in production code (or guarded by `Config.Debug`)
- [ ] Config.Debug defaults to `false`

═══════════════════════════════════════════════════════════════════════════════

## ⚠️ Common Escrow Mistakes

### ❌ MISTAKE 1: Resource Name Mismatch

```
Folder:  my-resource/
Manifest: name 'lxr-example'   ← WRONG: doesn't match folder
```

**Fix**: Ensure folder name and `name` field are identical.

```
Folder:  lxr-example/
Manifest: name 'lxr-example'   ← CORRECT
```

---

### ❌ MISTAKE 2: Using `require()` Instead of Manifest Declarations

```lua
-- WRONG: Will break escrow
local config = require('config')
local bridge = require('shared/bridge')
```

```lua
-- CORRECT: Declare in fxmanifest.lua
shared_scripts {
    'config.lua',
    'shared/framework-bridge.lua',
}
```

---

### ❌ MISTAKE 3: Hardcoded Server Tokens or IPs

```lua
-- WRONG: Hardcoding server-specific data
local WEBHOOK_URL = "https://discord.com/api/webhooks/123456/ACTUAL_TOKEN"
```

```lua
-- CORRECT: Use config so buyer sets their own values
Config.Webhooks = {
    security = '',    -- Set your Discord webhook URL here
    transactions = '',
}
```

---

### ❌ MISTAKE 4: Missing rdr3_warning

```lua
-- WRONG: Missing the required RedM warning
fx_version 'cerulean'
game 'rdr3'
name 'lxr-example'
```

```lua
-- CORRECT: Include rdr3_warning
fx_version 'cerulean'
game       'rdr3'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources WILL become incompatible once RedM ships.'

name 'lxr-example'
```

---

### ❌ MISTAKE 5: Config.Debug Left as `true`

```lua
-- WRONG: Debug mode enabled in production
Config.Debug = true
```

```lua
-- CORRECT: Debug disabled by default
Config.Debug = false   -- Enable during development only
```

═══════════════════════════════════════════════════════════════════════════════

## 🔒 Security Considerations for Escrow Resources

Since escrow resources are sold commercially, security is especially important:

### Protect Against License Abuse
- The escrow system handles license validation automatically
- Do NOT add additional custom license checks that phone home
- The runtime resource name guard is sufficient for brand protection

### Buyer Configuration Security
- All sensitive configuration (webhooks, API keys) must be in `config.lua`
- Never hardcode credentials — buyers must supply their own
- Document all configuration options clearly in README

### Server Authority
- ALL economy/inventory operations must be server-side validated
- NEVER trust client-supplied money amounts, item counts, or coordinates
- Distance and state validation must happen on the server

═══════════════════════════════════════════════════════════════════════════════

## 📦 Tebex Product Setup Guidelines

When creating the Tebex product listing:

### Product Name Format
```
🐺 LXR [Resource Name] | wolves.land
```
Example: `🐺 LXR Prop Looting | wolves.land`

### Product Description
Include:
- What the resource does
- Supported frameworks (LXR-Core, RSG-Core, VORP Core, etc.)
- Feature list
- Requirements (ox_lib, oxmysql if needed)
- Preview screenshots/video

### Package Delivery
The Tebex escrow package should be a `.zip` containing:
```
lxr-[resource-name].zip
└── lxr-[resource-name]/
    ├── fxmanifest.lua
    ├── config.lua       ← unobfuscated
    ├── shared/
    │   └── framework-bridge.lua  ← obfuscated
    ├── client/
    │   └── main.lua     ← obfuscated
    ├── server/
    │   └── main.lua     ← obfuscated
    └── README.md        ← unobfuscated
```

═══════════════════════════════════════════════════════════════════════════════

## ✅ Validation Checklist

- [ ] Resource folder name matches `name` in `fxmanifest.lua`
- [ ] `fx_version`, `game`, `rdr3_warning`, `name` present in correct order
- [ ] `author 'iBoss21 / The Lux Empire'` present
- [ ] Runtime resource name guard in `config.lua`
- [ ] No `require()` / `loadfile()` / `dofile()` calls
- [ ] All files declared in `fxmanifest.lua`
- [ ] No hardcoded sensitive data (tokens, IPs)
- [ ] `Config.Debug = false` as default
- [ ] Branded headers on all files
- [ ] Copyright notice present
- [ ] Documentation complete (README + docs/)
- [ ] Screenshots attached

═══════════════════════════════════════════════════════════════════════════════

## 🔗 Related Standards

- [Branding & File Style](./branding-and-style.md) - Required file headers
- [FXManifest Standards](./fxmanifest.md) - Manifest requirements
- [Resource Name Protection](./resource-name-protection.md) - Runtime guards
- [Security](./security.md) - Server-side validation
- [Documentation Requirements](./documentation.md) - Required docs

═══════════════════════════════════════════════════════════════════════════════

© 2026 iBoss21 / The Lux Empire | wolves.land
