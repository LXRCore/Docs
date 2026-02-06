# 🐺 Events & Triggers Standard

```
██╗     ██╗  ██╗██████╗         ███████╗██╗   ██╗███████╗███╗   ██╗████████╗███████╗
██║     ╚██╗██╔╝██╔══██╗        ██╔════╝██║   ██║██╔════╝████╗  ██║╚══██╔══╝██╔════╝
██║      ╚███╔╝ ██████╔╝        █████╗  ██║   ██║█████╗  ██╔██╗ ██║   ██║   ███████╗
██║      ██╔██╗ ██╔══██╗        ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║   ╚════██║
███████╗██╔╝ ██╗██║  ██║        ███████╗ ╚████╔╝ ███████╗██║ ╚████║   ██║   ███████║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝
```

**Standard**: Events / Triggers (MUST BE CORRECT PER FRAMEWORK)  
**wolves.land | The Land of Wolves 🐺**

═══════════════════════════════════════════════════════════════════════════════

## ⚠️ Critical Rule

**NO INVENTED EVENTS. NO "ASSUME THIS EXISTS".**

For each framework, use **correct patterns** that actually exist in that framework.

═══════════════════════════════════════════════════════════════════════════════

## 🎯 Per-Framework Event Patterns

### LXR-Core

Use actual LXR exports/events/callbacks used by LXR resources OR implement an internal LXR unified bridge naming:

```lua
-- Client Events
lxr-core:client:<feature>:<action>

-- Server Events
lxr-core:server:<feature>:<action>

-- Callbacks
lxr-core:callback:<feature>:<action>
```

**Examples:**
```lua
-- Player events
TriggerEvent('lxr-core:client:player:loaded', playerData)
TriggerServerEvent('lxr-core:server:player:updateJob', jobData)

-- Inventory events
TriggerEvent('lxr-core:client:inventory:open')
TriggerServerEvent('lxr-core:server:inventory:useItem', itemName)

-- Callbacks
LXRCore.Functions.TriggerCallback('lxr-core:callback:player:getData', function(data)
    -- handle data
end)
```

### RSG-Core

Use official RSGCore naming patterns:

```lua
-- Player events
RSGCore:Client:OnPlayerLoaded
RSGCore:Server:OnPlayerLoaded
RSGCore:Client:OnPlayerUnload

-- Job events
RSGCore:Client:OnJobUpdate
RSGCore:Server:SetJob

-- Money events
RSGCore:Server:AddMoney
RSGCore:Server:RemoveMoney

-- Callbacks
RSGCore:Callback:Create(name, callback)
RSGCore:Callback:Trigger(name, callback, ...)
```

**Examples:**
```lua
RegisterNetEvent('RSGCore:Client:OnPlayerLoaded', function()
    -- Player loaded logic
end)

RSGCore.Functions.CreateCallback('RSGCore:Server:GetPlayerData', function(source, cb)
    cb(playerData)
end)
```

### VORP Core

Use official VORP naming patterns:

```lua
-- Player events
vorp:SelectedCharacter
vorp:playerUnload

-- Inventory
vorp_inventory:addItem
vorp_inventory:removeItem
vorp_inventory:use

-- Money
vorp:addMoney
vorp:removeMoney

-- Callbacks
vorp:callback:<name>
```

**Examples:**
```lua
RegisterNetEvent('vorp:SelectedCharacter', function(charid)
    -- Character selection logic
end)

TriggerServerEvent('vorp:addMoney', 0, 100.0) -- account 0 = cash
```

### RedEM:RP (Optional)

```lua
-- Player events
redem:getPlayerFromId
redem_roleplay:PlayerLoaded

-- Inventory
redemrp_inventory:AddItem
redemrp_inventory:RemoveItem

-- Notifications
redem_roleplay:NotifyLeft
redem_roleplay:NotifyRight
```

### QBR-Core / QR-Core (Optional)

Similar patterns to QB-Core but for RedM:

```lua
-- Player events
QBR:Client:OnPlayerLoaded
QBR:Server:OnPlayerLoaded

-- Callbacks
QBRCore.Functions.CreateCallback(name, cb)
QBRCore.Functions.TriggerCallback(name, cb, ...)
```

### Standalone

No framework events. Use direct TriggerEvent/TriggerServerEvent with custom naming:

```lua
TriggerEvent('resourceName:client:action')
TriggerServerEvent('resourceName:server:action')
```

═══════════════════════════════════════════════════════════════════════════════

## 🌉 Unified Adapter Layer

The adapter maps unified calls to per-framework exports/events/callbacks.

### Server-Side Example

```lua
-- Unified: Framework.Notify(source, type, message, duration)

if ActiveFramework == 'lxr-core' then
    function Framework.Notify(source, type, message, duration)
        TriggerClientEvent('ox_lib:notify', source, {
            type = type,
            description = message,
            duration = duration or 5000
        })
    end
    
elseif ActiveFramework == 'rsg-core' then
    function Framework.Notify(source, type, message, duration)
        TriggerClientEvent('ox_lib:notify', source, {
            type = type,
            description = message,
            duration = duration or 5000
        })
    end
    
elseif ActiveFramework == 'vorp_core' then
    function Framework.Notify(source, type, message, duration)
        TriggerClientEvent('vorp:Tip', source, message, duration or 5000)
    end
    
else -- standalone
    function Framework.Notify(source, type, message, duration)
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[Server]', message }
        })
    end
end
```

### Client-Side Example

```lua
-- Unified: Framework.ProgressBar(label, duration, options)

if ActiveFramework == 'lxr-core' then
    function Framework.ProgressBar(label, duration, options)
        return exports['ox_lib']:progressBar({
            duration = duration,
            label = label,
            useWhileDead = options.useWhileDead or false,
            canCancel = options.canCancel or true,
            disable = options.disable or {}
        })
    end
    
elseif ActiveFramework == 'rsg-core' then
    function Framework.ProgressBar(label, duration, options)
        return exports['ox_lib']:progressBar({
            duration = duration,
            label = label,
            useWhileDead = options.useWhileDead or false,
            canCancel = options.canCancel or true,
            disable = options.disable or {}
        })
    end
    
elseif ActiveFramework == 'vorp_core' then
    function Framework.ProgressBar(label, duration, options)
        exports['vorp_progressbar']:Start({
            duration = duration,
            label = label,
            onFinish = function()
                options.onComplete()
            end
        })
    end
    
else -- standalone
    function Framework.ProgressBar(label, duration, options)
        -- Simple wait-based progress
        local finished = false
        CreateThread(function()
            Wait(duration)
            finished = true
            if options.onComplete then
                options.onComplete()
            end
        end)
        return finished
    end
end
```

═══════════════════════════════════════════════════════════════════════════════

## 📋 Common Unified Functions

### Server-Side Unified API

```lua
Framework.Notify(source, type, message, duration)
Framework.GetPlayerData(source)
Framework.GetPlayerIdentifier(source)
Framework.IsPlayerLoaded(source)
Framework.GetPlayerJob(source)
Framework.AddMoney(source, account, amount)
Framework.RemoveMoney(source, account, amount)
Framework.GetMoney(source, account)
Framework.AddItem(source, item, amount, metadata)
Framework.RemoveItem(source, item, amount, metadata)
Framework.HasItem(source, item, amount)
Framework.GetItemCount(source, item)
Framework.RegisterCallback(name, callback)
```

### Client-Side Unified API

```lua
Framework.GetPlayerData()
Framework.IsPlayerLoaded()
Framework.GetJob()
Framework.Notify(type, message, duration)
Framework.ProgressBar(label, duration, options)
Framework.TriggerCallback(name, callback, ...)
Framework.OpenInventory()
Framework.CloseInventory()
```

═══════════════════════════════════════════════════════════════════════════════

## 🎯 Implementation Pattern

### 1. Detect Framework

```lua
local ActiveFramework = DetectFramework()
```

### 2. Load Framework-Specific Adapter

```lua
if ActiveFramework == 'lxr-core' then
    LoadLXRCoreAdapter()
elseif ActiveFramework == 'rsg-core' then
    LoadRSGCoreAdapter()
elseif ActiveFramework == 'vorp_core' then
    LoadVORPAdapter()
-- ... etc
else
    LoadStandaloneAdapter()
end
```

### 3. Core Logic Uses Unified Functions ONLY

```lua
-- ✅ CORRECT
Framework.Notify(source, 'success', 'Item received!', 5000)
Framework.AddItem(source, 'bread', 1, {})

-- ❌ WRONG - Direct framework call
TriggerClientEvent('lxr-core:client:notify', source, 'Item received!')
```

═══════════════════════════════════════════════════════════════════════════════

## ✅ Validation Checklist

- [ ] No invented/fake events used
- [ ] All events match actual framework patterns
- [ ] Framework adapter layer implemented
- [ ] Unified functions defined for all operations
- [ ] Core logic uses ONLY unified functions (no direct framework calls)
- [ ] Each framework adapter properly implements all unified functions
- [ ] Event naming follows framework conventions
- [ ] Callbacks work correctly per framework

═══════════════════════════════════════════════════════════════════════════════

## 🔗 Related Standards

- [Multi-Framework Support](./multi-framework.md) - Framework detection
- [Configuration Standards](./configuration.md) - FrameworkSettings config

═══════════════════════════════════════════════════════════════════════════════

© 2026 iBoss21 / The Lux Empire | wolves.land
