# 🐺 Common Patterns

```
██╗     ██╗  ██╗██████╗         ██████╗  █████╗ ████████╗████████╗███████╗██████╗ ███╗   ██╗███████╗
██║     ╚██╗██╔╝██╔══██╗        ██╔══██╗██╔══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗████╗  ██║██╔════╝
██║      ╚███╔╝ ██████╔╝        ██████╔╝███████║   ██║      ██║   █████╗  ██████╔╝██╔██╗ ██║███████╗
██║      ██╔██╗ ██╔══██╗        ██╔═══╝ ██╔══██║   ██║      ██║   ██╔══╝  ██╔══██╗██║╚██╗██║╚════██║
███████╗██╔╝ ██╗██║  ██║        ██║     ██║  ██║   ██║      ██║   ███████╗██║  ██║██║ ╚████║███████║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═╝     ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝
```

**Recommended Approaches for RedM Resources**  
**wolves.land | The Land of Wolves 🐺**

═══════════════════════════════════════════════════════════════════════════════

## Overview

This document provides recommended patterns and best practices for RedM resource development following wolves.land standards.

═══════════════════════════════════════════════════════════════════════════════

## 🎯 Resource Structure Patterns

### Pattern: Clean Separation of Concerns

```
resource/
├── fxmanifest.lua          # Manifest
├── config.lua              # All configuration
├── shared/
│   ├── framework.lua       # Framework adapter
│   └── utils.lua           # Shared utilities
├── client/
│   ├── main.lua            # Main client logic
│   ├── ui.lua              # UI handling
│   └── interactions.lua    # Player interactions
├── server/
│   ├── main.lua            # Main server logic
│   ├── database.lua        # Database operations
│   ├── callbacks.lua       # Callbacks
│   └── validation.lua      # Security validation
└── docs/                   # Documentation
```

**Why**: Clear organization, easy to maintain, logical file structure.

═══════════════════════════════════════════════════════════════════════════════

## 🔐 Security Patterns

### Pattern: Secure Event Handler

```lua
RegisterNetEvent('resource:server:action', function(entityNetId)
    local source = source
    
    -- 1. Validate player
    if not source or source == 0 then return end
    
    -- 2. Rate limit
    if not RateLimit(source, 'action', 10) then
        return
    end
    
    -- 3. Validate state
    local valid, reason = ValidatePlayerState(source)
    if not valid then
        LogSuspicious(source, 'Invalid state', reason)
        return
    end
    
    -- 4. Validate entity
    local entity = NetworkGetEntityFromNetworkId(entityNetId)
    if not DoesEntityExist(entity) then
        LogSuspicious(source, 'Invalid entity', entityNetId)
        return
    end
    
    -- 5. Validate distance
    local entityCoords = GetEntityCoords(entity)
    if not ValidateDistance(source, entityCoords) then
        return
    end
    
    -- 6. Check cooldown
    if not CheckCooldown(source, 'action:' .. entityNetId) then
        Framework.Notify(source, 'error', 'Wait before trying again', 5000)
        return
    end
    
    -- 7. Perform action
    local success = PerformAction(source, entity)
    
    if success then
        SetCooldown(source, 'action:' .. entityNetId)
        Framework.Notify(source, 'success', 'Action completed', 5000)
    end
end)
```

**Why**: Comprehensive validation prevents exploits, maintains server authority.

═══════════════════════════════════════════════════════════════════════════════

## 🌉 Framework Adapter Patterns

### Pattern: Unified Function Implementation

```lua
-- Define unified function that works across all frameworks
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
else
    function Framework.Notify(source, type, message, duration)
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[Server]', message }
        })
    end
end

-- Use unified function in core logic
Framework.Notify(source, 'success', 'Item received!', 5000)
```

**Why**: Core logic stays framework-agnostic, easy to maintain, supports multiple frameworks.

═══════════════════════════════════════════════════════════════════════════════

## 💰 Economy Patterns

### Pattern: Safe Transaction

```lua
function ProcessPurchase(source, itemName, price)
    -- 1. Validate player has money
    local currentMoney = Framework.GetMoney(source, 'cash')
    if currentMoney < price then
        Framework.Notify(source, 'error', 'Insufficient funds', 5000)
        return false
    end
    
    -- 2. Remove money FIRST (prevent duplication exploits)
    local moneyRemoved = Framework.RemoveMoney(source, 'cash', price)
    if not moneyRemoved then
        LogSuspicious(source, 'Money removal failed', {price = price})
        return false
    end
    
    -- 3. Add item
    local itemAdded = Framework.AddItem(source, itemName, 1, {})
    if not itemAdded then
        -- Refund on failure
        Framework.AddMoney(source, 'cash', price)
        Framework.Notify(source, 'error', 'Transaction failed', 5000)
        return false
    end
    
    -- 4. Success
    Framework.Notify(source, 'success', 'Purchase complete!', 5000)
    return true
end
```

**Why**: Remove currency first prevents duplication, refund on failure maintains fairness.

═══════════════════════════════════════════════════════════════════════════════

## 📊 Cooldown Management Patterns

### Pattern: Server-Side Cooldown Tracker

```lua
local Cooldowns = {}

function CheckCooldown(source, key)
    local identifier = Framework.GetPlayerIdentifier(source)
    local cooldownKey = identifier .. ':' .. key
    local lastUse = Cooldowns[cooldownKey]
    
    if not lastUse then
        return true
    end
    
    local timePassed = os.time() - lastUse
    local cooldownSeconds = Config.Cooldowns.globalCooldown / 1000
    
    return timePassed >= cooldownSeconds
end

function SetCooldown(source, key)
    local identifier = Framework.GetPlayerIdentifier(source)
    local cooldownKey = identifier .. ':' .. key
    Cooldowns[cooldownKey] = os.time()
end

-- Cleanup old cooldowns periodically
CreateThread(function()
    while true do
        Wait(600000) -- 10 minutes
        local now = os.time()
        local cooldownDuration = Config.Cooldowns.globalCooldown / 1000
        
        for key, timestamp in pairs(Cooldowns) do
            if (now - timestamp) > (cooldownDuration * 2) then
                Cooldowns[key] = nil
            end
        end
    end
end)
```

**Why**: Server-authoritative, per-player tracking, automatic cleanup.

═══════════════════════════════════════════════════════════════════════════════

## 🎮 Client Interaction Patterns

### Pattern: Progress Bar Interaction

```lua
-- Client-side
local function InteractWithProp(propEntity)
    -- Show progress bar
    local success = Framework.ProgressBar('Searching...', 5000, {
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            combat = true,
            mouse = false
        }
    })
    
    if not success then
        return -- Player cancelled
    end
    
    -- Trigger server event
    local propNetId = NetworkGetNetworkIdFromEntity(propEntity)
    TriggerServerEvent('resource:server:lootProp', propNetId)
end
```

**Why**: User feedback, cancellable, sends network ID (not entity) to server.

═══════════════════════════════════════════════════════════════════════════════

## 🗄️ Database Patterns

### Pattern: Safe Database Query

```lua
function GetPlayerData(identifier)
    local result = MySQL.query.await('SELECT * FROM players WHERE identifier = ?', {
        identifier
    })
    
    if not result or #result == 0 then
        return nil
    end
    
    return result[1]
end

function UpdatePlayerData(identifier, data)
    local affectedRows = MySQL.update.await(
        'UPDATE players SET cash = ?, gold = ? WHERE identifier = ?',
        {data.cash, data.gold, identifier}
    )
    
    return affectedRows > 0
end
```

**Why**: Parameterized queries prevent SQL injection, await for synchronous flow.

═══════════════════════════════════════════════════════════════════════════════

## 🔔 Notification Patterns

### Pattern: Contextual Notifications

```lua
-- Success notification
Framework.Notify(source, 'success', 'Item received!', 5000)

-- Error notification
Framework.Notify(source, 'error', 'You cannot do that right now', 5000)

-- Info notification
Framework.Notify(source, 'info', 'You found something interesting', 5000)

-- Warning notification
Framework.Notify(source, 'warning', 'Be careful, this is risky', 5000)
```

**Why**: Consistent types, clear messages, appropriate duration.

═══════════════════════════════════════════════════════════════════════════════

## 🧹 Cleanup Patterns

### Pattern: Resource Stop Cleanup

```lua
-- Client
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    
    -- Remove markers/blips
    for _, blip in pairs(ActiveBlips) do
        RemoveBlip(blip)
    end
    
    -- Cancel active progress bars
    if CurrentProgressBar then
        -- Cancel progress
    end
    
    -- Clear local variables
    ActiveBlips = {}
    CurrentProgressBar = nil
end)

-- Server
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    
    -- Clear server state
    Cooldowns = {}
    ActiveSessions = {}
end)
```

**Why**: Prevents memory leaks, cleans up UI elements, resets state.

═══════════════════════════════════════════════════════════════════════════════

## 📝 Configuration Patterns

### Pattern: Grouped Configuration

```lua
Config.Rewards = {
    tier1 = {
        chance = 70, -- 70% chance
        items = {
            { item = 'bread', min = 1, max = 3, chance = 50 },
            { item = 'water', min = 1, max = 2, chance = 30 },
            { item = 'apple', min = 1, max = 5, chance = 20 }
        },
        money = { min = 1, max = 10 } -- Cash reward
    },
    tier2 = {
        chance = 25,
        items = {
            { item = 'weapon_pistol', min = 1, max = 1, chance = 10 },
            { item = 'ammo_pistol', min = 5, max = 15, chance = 40 }
        },
        money = { min = 10, max = 50 }
    },
    tier3 = {
        chance = 5,
        items = {
            { item = 'gold_nugget', min = 1, max = 3, chance = 100 }
        },
        money = { min = 50, max = 200 }
    }
}
```

**Why**: Clear structure, easy to tune, weighted chances, flexible rewards.

═══════════════════════════════════════════════════════════════════════════════

## 🎲 Random Reward Patterns

### Pattern: Weighted Random Selection

```lua
function DetermineReward()
    local roll = math.random(1, 100)
    local tier = nil
    
    -- Determine tier
    if roll <= Config.Rewards.tier3.chance then
        tier = 'tier3'
    elseif roll <= Config.Rewards.tier3.chance + Config.Rewards.tier2.chance then
        tier = 'tier2'
    else
        tier = 'tier1'
    end
    
    local rewardTable = Config.Rewards[tier]
    
    -- Select item from tier
    local item = nil
    local totalChance = 0
    for _, rewardItem in pairs(rewardTable.items) do
        totalChance = totalChance + rewardItem.chance
    end
    
    local itemRoll = math.random(1, totalChance)
    local currentChance = 0
    for _, rewardItem in pairs(rewardTable.items) do
        currentChance = currentChance + rewardItem.chance
        if itemRoll <= currentChance then
            item = rewardItem
            break
        end
    end
    
    if not item then
        item = rewardTable.items[1] -- Fallback
    end
    
    -- Determine amount
    local amount = math.random(item.min, item.max)
    
    return {
        item = item.item,
        amount = amount,
        money = math.random(rewardTable.money.min, rewardTable.money.max)
    }
end
```

**Why**: Fair weighted distribution, configurable chances, random amounts within range.

═══════════════════════════════════════════════════════════════════════════════

## 🔧 Debug Patterns

### Pattern: Conditional Debug Logging

```lua
function DebugPrint(message, data)
    if not Config.Debug then return end
    
    local timestamp = os.date('%Y-%m-%d %H:%M:%S')
    local dataStr = data and json.encode(data, {indent = true}) or ''
    
    print(string.format(
        '^5[DEBUG]^7 [%s] %s %s',
        timestamp,
        message,
        dataStr
    ))
end

-- Usage
DebugPrint('Player looted prop', {
    source = source,
    prop = propModel,
    reward = reward
})
```

**Why**: Easy to enable/disable, timestamped, structured data logging.

═══════════════════════════════════════════════════════════════════════════════

## ✅ Best Practices Summary

### Do's ✅

1. **Validate everything server-side**
2. **Use framework adapter for all framework-specific calls**
3. **Implement comprehensive security checks**
4. **Track cooldowns server-side**
5. **Remove currency/items before giving rewards**
6. **Refund on transaction failure**
7. **Log suspicious activity**
8. **Clean up on resource stop**
9. **Use parameterized database queries**
10. **Provide clear user feedback (notifications, progress bars)**

### Don'ts ❌

1. **Don't trust client-provided critical data**
2. **Don't use direct framework calls in core logic**
3. **Don't skip validation steps**
4. **Don't track security-critical data client-side**
5. **Don't forget to clean up resources**
6. **Don't use concatenated SQL queries**
7. **Don't block main thread with long operations**
8. **Don't hard-code framework-specific values**

═══════════════════════════════════════════════════════════════════════════════

© 2026 iBoss21 / The Lux Empire | wolves.land
