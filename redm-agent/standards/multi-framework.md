# 🐺 Multi-Framework Support Model

```
██╗     ██╗  ██╗██████╗         ███████╗██████╗  █████╗ ███╗   ███╗███████╗
██║     ╚██╗██╔╝██╔══██╗        ██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝
██║      ╚███╔╝ ██████╔╝        █████╗  ██████╔╝███████║██╔████╔██║█████╗  
██║      ██╔██╗ ██╔══██╗        ██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  
███████╗██╔╝ ██╗██║  ██║        ██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
```

**Standard**: Multi-Framework Support (MANDATORY)  
**wolves.land | The Land of Wolves 🐺**

═══════════════════════════════════════════════════════════════════════════════

## Overview

All resources **MUST** support framework auto-detection using a consistent structure pattern. This allows the same resource to work across multiple frameworks without code changes.

═══════════════════════════════════════════════════════════════════════════════

## 🎯 Framework Priority

### Primary Frameworks (Mandatory Support)
1. **LXR-Core** - Primary framework
2. **RSG-Core** - Primary framework
3. **VORP Core** - Supported/Legacy

### Optional Frameworks
Include **ONLY** if:
- They exist in source being converted, OR
- User explicitly requests them

Optional frameworks:
- **RedEM:RP**
- **QBR-Core**
- **QR-Core**
- **Standalone** (always as fallback)

═══════════════════════════════════════════════════════════════════════════════

## 📋 Configuration Structure

### Framework Detection Setting

```lua
--[[
    Framework Priority (in order):
    1. LXR-Core (Primary)
    2. RSG-Core (Primary)
    3. VORP Core (Supported)
    4. RedEM:RP (Optional - if detected)
    5. QBR-Core (Optional - if detected)
    6. QR-Core (Optional - if detected)
    7. Standalone (Fallback)
]]

Config.Framework = 'auto' -- 'auto' or manual: 'lxr-core', 'rsg-core', 'vorp_core', 'redem_roleplay', 'qbr-core', 'qr-core', 'standalone'
```

### Framework-Specific Settings

```lua
Config.FrameworkSettings = {
    ['lxr-core'] = {
        resource = 'lxr-core',
        notifications = 'ox_lib',
        inventory = 'lxr-inventory',
        target = 'ox_target',
        progressbar = 'ox_lib',
        -- Event naming convention
        events = {
            server = 'lxr-core:server:%s',
            client = 'lxr-core:client:%s',
            callback = 'lxr-core:callback:%s'
        }
    },
    ['rsg-core'] = {
        resource = 'rsg-core',
        notifications = 'ox_lib',
        inventory = 'rsg-inventory',
        target = 'ox_target',
        progressbar = 'ox_lib',
        events = {
            server = 'RSGCore:Server:%s',
            client = 'RSGCore:Client:%s',
            callback = 'RSGCore:Callback:%s'
        }
    },
    ['vorp_core'] = {
        resource = 'vorp_core',
        notifications = 'vorp',
        inventory = 'vorp_inventory',
        target = 'vorp_target',
        progressbar = 'vorp',
        events = {
            server = 'vorp:%s',
            client = 'vorp:%s',
            callback = 'vorp:callback:%s'
        }
    },
    ['standalone'] = {
        resource = nil,
        notifications = 'chat',
        inventory = nil,
        target = nil,
        progressbar = 'native',
        events = {
            server = '%s:server',
            client = '%s:client',
            callback = '%s:callback'
        }
    }
}
```

═══════════════════════════════════════════════════════════════════════════════

## 🔍 Detection Routine

The detection routine **MUST**:

1. Check running resource states for known framework resources
2. Determine `ActiveFramework` (string)
3. Provide clean fallback (standalone) if none detected
4. Print startup summary showing detected framework

### Example Detection Code (shared/framework.lua)

```lua
local ActiveFramework = nil

function DetectFramework()
    if Config.Framework ~= 'auto' then
        ActiveFramework = Config.Framework
        return ActiveFramework
    end
    
    -- Check in priority order
    local frameworks = {
        'lxr-core',
        'rsg-core',
        'vorp_core',
        'redem_roleplay',
        'qbr-core',
        'qr-core'
    }
    
    for _, framework in ipairs(frameworks) do
        if GetResourceState(framework) == 'started' then
            ActiveFramework = framework
            return ActiveFramework
        end
    end
    
    -- Fallback to standalone
    ActiveFramework = 'standalone'
    return ActiveFramework
end

function GetActiveFramework()
    if not ActiveFramework then
        DetectFramework()
    end
    return ActiveFramework
end

function GetFrameworkSettings()
    local framework = GetActiveFramework()
    return Config.FrameworkSettings[framework] or Config.FrameworkSettings['standalone']
end
```

═══════════════════════════════════════════════════════════════════════════════

## 🌉 Adapter Architecture (MANDATORY)

Create a **Framework Adapter / Bridge** layer so core gameplay logic calls only unified functions.

### Unified API Functions

Core gameplay logic **MUST NOT** contain framework-specific calls directly. Use these unified functions:

#### Notifications
```lua
Framework.Notify(source, type, message, duration)
```

#### Player Data
```lua
Framework.GetPlayerData(source)
Framework.GetJob(source)
Framework.GetIdentifier(source)
Framework.IsPlayerLoaded(source)
```

#### Economy
```lua
Framework.AddMoney(source, account, amount)
Framework.RemoveMoney(source, account, amount)
Framework.GetMoney(source, account)
```

#### Inventory
```lua
Framework.AddItem(source, item, amount, metadata)
Framework.RemoveItem(source, item, amount, metadata)
Framework.HasItem(source, item, amount)
Framework.GetItemCount(source, item)
```

#### Progress Bar (Client)
```lua
Framework.ProgressBar(label, duration, options)
```

#### Callbacks
```lua
Framework.RegisterCallback(name, callback)
Framework.TriggerCallback(name, callback, ...)
```

### Implementation Structure

```lua
Framework = {}

-- Initialize framework on startup
CreateThread(function()
    DetectFramework()
    local fw = GetActiveFramework()
    print(("^2[Framework Bridge]^7 Detected: %s"):format(fw))
    
    -- Load framework-specific adapter
    if fw == 'lxr-core' then
        LoadLXRCoreAdapter()
    elseif fw == 'rsg-core' then
        LoadRSGCoreAdapter()
    elseif fw == 'vorp_core' then
        LoadVORPAdapter()
    else
        LoadStandaloneAdapter()
    end
end)

-- Example: LXR Core Adapter
function LoadLXRCoreAdapter()
    local LXRCore = exports['lxr-core']:GetCoreObject()
    
    function Framework.Notify(source, type, message, duration)
        TriggerClientEvent('ox_lib:notify', source, {
            type = type,
            description = message,
            duration = duration or 5000
        })
    end
    
    function Framework.GetPlayerData(source)
        return LXRCore.Functions.GetPlayer(source)
    end
    
    function Framework.AddMoney(source, account, amount)
        local Player = LXRCore.Functions.GetPlayer(source)
        if Player then
            Player.Functions.AddMoney(account, amount)
        end
    end
    
    -- Continue for all unified functions...
end
```

═══════════════════════════════════════════════════════════════════════════════

## 📊 Startup Print

Print a startup summary showing:
- Version
- Detected framework
- Language
- Key counts relevant to the resource

Example:

```lua
CreateThread(function()
    Wait(1000)
    local fw = GetActiveFramework()
    print([[
        
        ═══════════════════════════════════════════════════════════════════════════════
        🐺 RESOURCE LOADED SUCCESSFULLY
        ═══════════════════════════════════════════════════════════════════════════════
        
        Resource:    lxr-example
        Version:     1.0.0
        Framework:   ]] .. fw .. [[
        
        Language:    ]] .. Config.Lang .. [[
        Items:       ]] .. #Config.Items .. [[
        
        ═══════════════════════════════════════════════════════════════════════════════
        
        Developer:   iBoss21 / The Lux Empire
        Website:     https://www.wolves.land
        
        ═══════════════════════════════════════════════════════════════════════════════
        
    ]])
end)
```

═══════════════════════════════════════════════════════════════════════════════

## ✅ Validation Checklist

- [ ] Config.Framework = 'auto' with documented priority
- [ ] Config.FrameworkSettings contains all required frameworks
- [ ] Detection routine checks in correct priority order
- [ ] ActiveFramework is determined and stored
- [ ] Clean fallback to standalone exists
- [ ] Framework adapter/bridge layer implemented
- [ ] All unified functions implemented for each framework
- [ ] Core gameplay logic uses only unified functions (no direct framework calls)
- [ ] Startup print shows detected framework
- [ ] Primary support quality highest for LXR-Core + RSG-Core

═══════════════════════════════════════════════════════════════════════════════

## 🔗 Related Standards

- [Events & Triggers](./events-and-triggers.md) - Per-framework event patterns
- [Configuration Standards](./configuration.md) - Config structure

═══════════════════════════════════════════════════════════════════════════════

© 2026 iBoss21 / The Lux Empire | wolves.land
