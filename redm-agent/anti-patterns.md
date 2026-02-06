# 🐺 Anti-Patterns

```
██╗     ██╗  ██╗██████╗          █████╗ ███╗   ██╗████████╗██╗
██║     ╚██╗██╔╝██╔══██╗        ██╔══██╗████╗  ██║╚══██╔══╝██║
██║      ╚███╔╝ ██████╔╝        ███████║██╔██╗ ██║   ██║   ██║
██║      ██╔██╗ ██╔══██╗        ██╔══██║██║╚██╗██║   ██║   ██║
███████╗██╔╝ ██╗██║  ██║        ██║  ██║██║ ╚████║   ██║   ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝
```

**What NOT to Do - Common Mistakes to Avoid**  
**wolves.land | The Land of Wolves 🐺**

═══════════════════════════════════════════════════════════════════════════════

## Overview

This document identifies common anti-patterns and mistakes to avoid when developing RedM resources for wolves.land.

═══════════════════════════════════════════════════════════════════════════════

## 🚫 Security Anti-Patterns

### ❌ Anti-Pattern: Trusting Client Data

```lua
-- WRONG - Client can send any values
RegisterNetEvent('resource:server:giveReward', function(itemName, amount, money)
    local source = source
    Framework.AddItem(source, itemName, amount)
    Framework.AddMoney(source, 'cash', money)
end)
```

**Why Bad**: Client can spawn items and money at will.

**Correct Approach**: Server determines all rewards.

```lua
-- CORRECT - Server determines reward
RegisterNetEvent('resource:server:lootProp', function(propNetId)
    local source = source
    
    -- Validate everything
    if not ValidatePlayer(source) then return end
    if not ValidateDistance(source, propCoords) then return end
    if not CheckCooldown(source, propNetId) then return end
    
    -- SERVER determines reward
    local reward = DetermineReward(propNetId)
    Framework.AddItem(source, reward.item, reward.amount)
end)
```

---

### ❌ Anti-Pattern: No Distance Validation

```lua
-- WRONG - No distance check
RegisterNetEvent('resource:server:action', function(entityNetId)
    local source = source
    PerformAction(source, entityNetId) -- Anyone can trigger from anywhere!
end)
```

**Why Bad**: Players can trigger actions from across the map.

**Correct Approach**: Always validate distance.

```lua
-- CORRECT - Distance validation
RegisterNetEvent('resource:server:action', function(entityNetId)
    local source = source
    local entity = NetworkGetEntityFromNetworkId(entityNetId)
    local entityCoords = GetEntityCoords(entity)
    
    if not ValidateDistance(source, entityCoords, 5.0) then
        return
    end
    
    PerformAction(source, entityNetId)
end)
```

---

### ❌ Anti-Pattern: Client-Side Cooldowns

```lua
-- WRONG - Client controls cooldown
local lastUse = 0

function DoAction()
    local now = GetGameTimer()
    if now - lastUse < 60000 then
        return -- Can be bypassed!
    end
    
    lastUse = now
    TriggerServerEvent('resource:server:action')
end
```

**Why Bad**: Client can modify or bypass cooldowns.

**Correct Approach**: Server-side cooldown tracking.

```lua
-- CORRECT - Server enforces cooldown
-- Server-side
local Cooldowns = {}

RegisterNetEvent('resource:server:action', function()
    local source = source
    if not CheckCooldown(source, 'action') then
        Framework.Notify(source, 'error', 'Wait before trying again', 5000)
        return
    end
    
    PerformAction(source)
    SetCooldown(source, 'action')
end)
```

═══════════════════════════════════════════════════════════════════════════════

## 🚫 Framework Anti-Patterns

### ❌ Anti-Pattern: Direct Framework Calls in Core Logic

```lua
-- WRONG - Direct framework call
function GiveReward(source, item, amount)
    if GetResourceState('lxr-core') == 'started' then
        local LXRCore = exports['lxr-core']:GetCoreObject()
        LXRCore.Functions.AddItem(source, item, amount)
    elseif GetResourceState('rsg-core') == 'started' then
        local RSGCore = exports['rsg-core']:GetCoreObject()
        RSGCore.Functions.AddItem(source, item, amount)
    -- ... repeated everywhere in code
    end
end
```

**Why Bad**: Code duplication, hard to maintain, messy.

**Correct Approach**: Use unified framework adapter.

```lua
-- CORRECT - Use unified adapter
function GiveReward(source, item, amount)
    Framework.AddItem(source, item, amount) -- Works for all frameworks
end
```

---

### ❌ Anti-Pattern: Invented Framework Events

```lua
-- WRONG - Made-up event names
TriggerEvent('lxr-core:player:giveMoney', source, 100)
TriggerEvent('rsg-core:inventory:giveItem', source, 'bread', 1)
```

**Why Bad**: These events don't exist, code won't work.

**Correct Approach**: Use actual framework events or unified adapter.

```lua
-- CORRECT - Use unified adapter with real framework implementations
Framework.AddMoney(source, 'cash', 100)
Framework.AddItem(source, 'bread', 1)
```

---

### ❌ Anti-Pattern: Hard-Requiring All Frameworks

```lua
-- WRONG in fxmanifest.lua
dependencies {
    'lxr-core',
    'rsg-core',
    'vorp_core',
    'redem_roleplay',
    'qbr-core',
    'qr-core'
}
```

**Why Bad**: Forces users to have all frameworks installed when they only need one.

**Correct Approach**: Auto-detect frameworks.

```lua
-- CORRECT - No framework dependencies, auto-detect
dependencies {
    -- 'ox_lib' -- Only if truly required
}
```

═══════════════════════════════════════════════════════════════════════════════

## 🚫 Performance Anti-Patterns

### ❌ Anti-Pattern: Tight Loops Without Delays

```lua
-- WRONG - Constant loop with no delay
CreateThread(function()
    while true do
        -- Check something every frame - BAD!
        CheckSomething()
    end
end)
```

**Why Bad**: Runs every frame (~60fps), wastes CPU, impacts FPS.

**Correct Approach**: Use appropriate delays.

```lua
-- CORRECT - Reasonable update interval
CreateThread(function()
    while true do
        Wait(1000) -- Check every second
        CheckSomething()
    end
end)
```

---

### ❌ Anti-Pattern: Not Cleaning Up Resources

```lua
-- WRONG - Creates blips but never removes them
for _, location in pairs(Config.Locations) do
    local blip = Citizen.InvokeNative(0x554d9d53f696d002, 1664425300, location.x, location.y, location.z)
    -- No cleanup!
end
```

**Why Bad**: Memory leak, blips remain even after resource stops.

**Correct Approach**: Track and cleanup.

```lua
-- CORRECT - Track blips and cleanup
local ActiveBlips = {}

for _, location in pairs(Config.Locations) do
    local blip = Citizen.InvokeNative(0x554d9d53f696d002, 1664425300, location.x, location.y, location.z)
    table.insert(ActiveBlips, blip)
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    for _, blip in pairs(ActiveBlips) do
        RemoveBlip(blip)
    end
end)
```

═══════════════════════════════════════════════════════════════════════════════

## 🚫 Database Anti-Patterns

### ❌ Anti-Pattern: SQL Injection Vulnerability

```lua
-- WRONG - Concatenated SQL query
local identifier = GetPlayerIdentifiers(source)[1]
MySQL.query('SELECT * FROM players WHERE identifier = "' .. identifier .. '"', function(result)
    -- Vulnerable to SQL injection!
end)
```

**Why Bad**: Open to SQL injection attacks.

**Correct Approach**: Use parameterized queries.

```lua
-- CORRECT - Parameterized query
local identifier = GetPlayerIdentifiers(source)[1]
MySQL.query('SELECT * FROM players WHERE identifier = ?', {identifier}, function(result)
    -- Safe from SQL injection
end)
```

---

### ❌ Anti-Pattern: Blocking Database Calls

```lua
-- WRONG - Callback-based query in sync code
function GetPlayerData(identifier)
    local data = nil
    MySQL.query('SELECT * FROM players WHERE identifier = ?', {identifier}, function(result)
        data = result[1]
    end)
    return data -- Will return nil (callback not complete yet)
end
```

**Why Bad**: Async callback hasn't completed when function returns.

**Correct Approach**: Use await or proper async handling.

```lua
-- CORRECT - Using await
function GetPlayerData(identifier)
    local result = MySQL.query.await('SELECT * FROM players WHERE identifier = ?', {identifier})
    return result and result[1] or nil
end
```

═══════════════════════════════════════════════════════════════════════════════

## 🚫 Economy Anti-Patterns

### ❌ Anti-Pattern: Giving Before Taking

```lua
-- WRONG - Give item before removing money
function ProcessPurchase(source, itemName, price)
    Framework.AddItem(source, itemName, 1) -- Item given first
    Framework.RemoveMoney(source, 'cash', price) -- What if this fails?
    -- Player got free item if money removal fails!
end
```

**Why Bad**: If money removal fails, player got free item.

**Correct Approach**: Remove currency first, refund on failure.

```lua
-- CORRECT - Remove money first, refund if item addition fails
function ProcessPurchase(source, itemName, price)
    local removed = Framework.RemoveMoney(source, 'cash', price)
    if not removed then
        return false
    end
    
    local added = Framework.AddItem(source, itemName, 1)
    if not added then
        Framework.AddMoney(source, 'cash', price) -- Refund
        return false
    end
    
    return true
end
```

═══════════════════════════════════════════════════════════════════════════════

## 🚫 Branding Anti-Patterns

### ❌ Anti-Pattern: Minimal/Generic Headers

```lua
-- WRONG - Minimal header
-- config.lua
-- Resource configuration

Config = {}
```

**Why Bad**: Doesn't meet branding standards, unprofessional.

**Correct Approach**: Full branded mega header.

```lua
-- CORRECT - Branded header
--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ███████╗███████╗ ██████╗ ██╗   ██╗██████╗  ██████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔════╝██╔════╝██╔═══██╗██║   ██║██╔══██╗██╔════╝██╔════╝
    [Full ASCII header]
    
    🐺 Resource Name - Configuration
    
    [Purpose statement]
    
    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════
    [Server info block]
    
    [Version, tags, framework support, credits]
]]
```

---

### ❌ Anti-Pattern: No Resource Name Protection

```lua
-- WRONG - No name protection
Config = {}
-- If renamed, might break
```

**Why Bad**: Can be renamed, breaks functionality, no branding protection.

**Correct Approach**: Runtime name guard.

```lua
-- CORRECT - Runtime check
local REQUIRED_RESOURCE_NAME = "lxr-resourcename"
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error(string.format([[
        ═══════════════════════════════════════════════════════════════════════════════
        ❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
        ═══════════════════════════════════════════════════════════════════════════════
        Expected: %s
        Got: %s
        [Error message]
    ]], REQUIRED_RESOURCE_NAME, currentResourceName, REQUIRED_RESOURCE_NAME))
end
```

═══════════════════════════════════════════════════════════════════════════════

## 🚫 Configuration Anti-Patterns

### ❌ Anti-Pattern: Hard-Coded Values in Code

```lua
-- WRONG - Hard-coded values
RegisterNetEvent('resource:server:action', function()
    local source = source
    Wait(300000) -- What is this number?
    Framework.AddMoney(source, 'cash', 50) -- Hard-coded reward
end)
```

**Why Bad**: Can't tune without editing code, no context for values.

**Correct Approach**: Centralized configuration.

```lua
-- CORRECT - Config values
Config.Cooldowns = {
    actionCooldown = 300000 -- 5 minutes
}

Config.Rewards = {
    money = 50
}

-- In code
RegisterNetEvent('resource:server:action', function()
    local source = source
    Wait(Config.Cooldowns.actionCooldown)
    Framework.AddMoney(source, 'cash', Config.Rewards.money)
end)
```

---

### ❌ Anti-Pattern: No Section Banners

```lua
-- WRONG - Flat config, no organization
Config = {}
Config.Debug = false
Config.maxDistance = 5.0
Config.cooldown = 60000
Config.items = {...}
```

**Why Bad**: Hard to navigate, unprofessional, doesn't meet standards.

**Correct Approach**: Organized sections with banners.

```lua
-- CORRECT - Organized with banners
-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ DEBUG SETTINGS ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Debug = false

-- ████████████████████████████████████████████████████████████████████████████████
-- ██████████████████████████ SECURITY SETTINGS ███████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Security = {
    maxDistance = 5.0,
    cooldown = 60000
}
```

═══════════════════════════════════════════════════════════════════════════════

## 🚫 Documentation Anti-Patterns

### ❌ Anti-Pattern: Generic/Filler Documentation

```markdown
## Installation

1. Download the resource
2. Put it in your resources folder
3. Add it to server.cfg
4. Restart server
```

**Why Bad**: Generic, no specific information, doesn't help users.

**Correct Approach**: Specific, detailed documentation.

```markdown
## Installation

### Prerequisites
- RedM server build 1436 or higher
- Framework: LXR-Core, RSG-Core, or VORP Core
- oxmysql resource (for database)

### Steps

1. Download the latest release from GitHub
2. Extract to `resources/[lxr]/lxr-resourcename/`
3. Import `sql/install.sql` to your database
4. Configure `config.lua`:
   - Set `Config.ServerInfo` (optional)
   - Configure `Config.Framework` if not using auto-detect
   - Adjust `Config.Security.maxDistance` for your server
5. Add to server.cfg: `ensure lxr-resourcename`
6. Restart server

### Troubleshooting
[Specific issues and solutions]
```

---

### ❌ Anti-Pattern: No Screenshots

```markdown
# Resource Name

This is a resource that does things.
```

**Why Bad**: No visual documentation, doesn't meet standards.

**Correct Approach**: Screenshot requirements documented.

```markdown
# 🐺 Resource Name

## Screenshots

See [docs/screenshots.md](./docs/screenshots.md) for required screenshots:
- Startup console
- Config sections  
- UI interaction
- Framework detection
- txAdmin performance
```

═══════════════════════════════════════════════════════════════════════════════

## 🚫 Code Style Anti-Patterns

### ❌ Anti-Pattern: Inconsistent Formatting

```lua
-- WRONG - Inconsistent
local x=5
local  y = 10
local   z    =     15
if x==5 then
print('test')
end
```

**Why Bad**: Hard to read, unprofessional.

**Correct Approach**: Consistent formatting.

```lua
-- CORRECT - Consistent
local x = 5
local y = 10
local z = 15

if x == 5 then
    print('test')
end
```

---

### ❌ Anti-Pattern: Excessive Comments

```lua
-- WRONG - Over-commented
local x = 5 -- Set x to 5
local y = 10 -- Set y to 10
local z = x + y -- Add x and y and store in z
print(z) -- Print z to console
```

**Why Bad**: Obvious comments add noise.

**Correct Approach**: Comment intent, not obvious operations.

```lua
-- CORRECT - Meaningful comments
-- Calculate player proximity bonus
local baseReward = 5
local distanceBonus = 10
local totalReward = baseReward + distanceBonus
Framework.AddMoney(source, 'cash', totalReward)
```

═══════════════════════════════════════════════════════════════════════════════

## ✅ Summary: What to Avoid

### Security
- ❌ Trusting client data for critical operations
- ❌ No distance validation
- ❌ Client-side cooldowns
- ❌ No rate limiting

### Framework
- ❌ Direct framework calls in core logic
- ❌ Invented framework events
- ❌ Hard-requiring all frameworks

### Performance
- ❌ Tight loops without delays
- ❌ Not cleaning up resources
- ❌ Blocking main thread

### Database
- ❌ SQL injection vulnerabilities
- ❌ Blocking database calls

### Economy
- ❌ Giving before taking
- ❌ No refunds on failure

### Branding
- ❌ Minimal/generic headers
- ❌ No resource name protection

### Configuration
- ❌ Hard-coded values
- ❌ No section organization

### Documentation
- ❌ Generic filler content
- ❌ No screenshots

═══════════════════════════════════════════════════════════════════════════════

**Avoid these patterns to create production-ready, professional resources.**

© 2026 iBoss21 / The Lux Empire | wolves.land
