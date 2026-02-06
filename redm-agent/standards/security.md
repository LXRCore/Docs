# 🐺 Security & Server Authority Standards

```
██╗     ██╗  ██╗██████╗         ███████╗███████╗ ██████╗██╗   ██╗██████╗ ██╗████████╗██╗   ██╗
██║     ╚██╗██╔╝██╔══██╗        ██╔════╝██╔════╝██╔════╝██║   ██║██╔══██╗██║╚══██╔══╝╚██╗ ██╔╝
██║      ╚███╔╝ ██████╔╝        ███████╗█████╗  ██║     ██║   ██║██████╔╝██║   ██║    ╚████╔╝ 
██║      ██╔██╗ ██╔══██╗        ╚════██║██╔══╝  ██║     ██║   ██║██╔══██╗██║   ██║     ╚██╔╝  
███████╗██╔╝ ██╗██║  ██║        ███████║███████╗╚██████╗╚██████╔╝██║  ██║██║   ██║      ██║   
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝   
```

**Standard**: Security & Server Authority (MANDATORY)  
**wolves.land | The Land of Wolves 🐺**

═══════════════════════════════════════════════════════════════════════════════

## ⚠️ Core Principle

**ASSUME HOSTILE CLIENTS**

Never trust client-provided data for critical operations:
- Money
- Items
- XP/Stats
- Job/Role
- Coordinates/Position
- State/Flags

═══════════════════════════════════════════════════════════════════════════════

## 🛡️ Required Security Measures

### 1. Server-Side Validation

**ALL** critical operations must be validated server-side.

#### Example: Item Looting

```lua
-- ❌ WRONG - Trusting client data
RegisterNetEvent('lxr-resource:server:giveReward', function(itemName, amount)
    local source = source
    -- Never trust itemName and amount from client!
    Framework.AddItem(source, itemName, amount)
end)

-- ✅ CORRECT - Server determines reward
RegisterNetEvent('lxr-resource:server:lootProp', function(propNetId)
    local source = source
    
    -- Validate player exists
    if not source then return end
    
    -- Validate prop exists
    local prop = NetworkGetEntityFromNetworkId(propNetId)
    if not DoesEntityExist(prop) then return end
    
    -- Validate distance
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local propCoords = GetEntityCoords(prop)
    local distance = #(playerCoords - propCoords)
    
    if distance > Config.Security.maxDistance then
        LogSuspicious(source, 'Distance check failed', distance)
        return
    end
    
    -- Check cooldown server-side
    if not CheckCooldown(source, propNetId) then
        Framework.Notify(source, 'error', 'You must wait before looting again', 5000)
        return
    end
    
    -- Server determines reward
    local reward = DetermineReward(prop)
    
    -- Give reward
    Framework.AddItem(source, reward.item, reward.amount)
    
    -- Set cooldown
    SetCooldown(source, propNetId)
end)
```

### 2. Distance Validation

Always validate player is close enough to interact:

```lua
function ValidateDistance(source, coords, maxDistance)
    local playerPed = GetPlayerPed(source)
    if not playerPed or playerPed == 0 then
        return false
    end
    
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - coords)
    
    if distance > (maxDistance or Config.Security.maxDistance) then
        LogSuspicious(source, 'Distance exploit attempt', {
            distance = distance,
            maxDistance = maxDistance or Config.Security.maxDistance
        })
        return false
    end
    
    return true
end
```

### 3. Server-Side Cooldowns

Track cooldowns server-side, never client-side:

```lua
local PlayerCooldowns = {}

function CheckCooldown(source, identifier)
    local key = source .. ':' .. identifier
    local lastUse = PlayerCooldowns[key]
    
    if not lastUse then
        return true
    end
    
    local timePassed = os.time() - lastUse
    local cooldownSeconds = Config.Cooldowns.globalCooldown / 1000
    
    return timePassed >= cooldownSeconds
end

function SetCooldown(source, identifier)
    local key = source .. ':' .. identifier
    PlayerCooldowns[key] = os.time()
end
```

### 4. Rate Limiting

Prevent spam/abuse with rate limiting:

```lua
local ActionLimiter = {}

function RateLimit(source, action, maxPerMinute)
    local key = source .. ':' .. action
    local now = os.time()
    
    if not ActionLimiter[key] then
        ActionLimiter[key] = { count = 1, resetTime = now + 60 }
        return true
    end
    
    local data = ActionLimiter[key]
    
    -- Reset if time elapsed
    if now >= data.resetTime then
        data.count = 1
        data.resetTime = now + 60
        return true
    end
    
    -- Check limit
    if data.count >= maxPerMinute then
        LogSuspicious(source, 'Rate limit exceeded', {
            action = action,
            count = data.count,
            maxAllowed = maxPerMinute
        })
        return false
    end
    
    -- Increment
    data.count = data.count + 1
    return true
end

-- Usage
RegisterNetEvent('lxr-resource:server:action', function()
    local source = source
    
    if not RateLimit(source, 'action', 10) then -- Max 10 per minute
        return
    end
    
    -- Proceed with action...
end)
```

### 5. State Validation

Validate expected player state:

```lua
function ValidatePlayerState(source)
    local playerPed = GetPlayerPed(source)
    
    -- Player must exist
    if not playerPed or playerPed == 0 then
        return false, 'Player not found'
    end
    
    -- Player must be alive (if required)
    if IsEntityDead(playerPed) then
        return false, 'Player is dead'
    end
    
    -- Player must not be in vehicle (if required)
    if IsPedInAnyVehicle(playerPed, false) then
        return false, 'Player is in vehicle'
    end
    
    return true
end

-- Usage
RegisterNetEvent('lxr-resource:server:action', function()
    local source = source
    
    local valid, reason = ValidatePlayerState(source)
    if not valid then
        LogSuspicious(source, 'Invalid state', reason)
        return
    end
    
    -- Proceed...
end)
```

### 6. Item/Money Verification

Always verify player has required items/money:

```lua
function ProcessPurchase(source, itemName, price)
    -- Check player has money
    local hasMoney = Framework.GetMoney(source, 'cash')
    
    if hasMoney < price then
        Framework.Notify(source, 'error', 'Insufficient funds', 5000)
        return false
    end
    
    -- Remove money first (prevent duplication)
    local removed = Framework.RemoveMoney(source, 'cash', price)
    
    if not removed then
        LogSuspicious(source, 'Money removal failed', {
            amount = price
        })
        return false
    end
    
    -- Give item
    local added = Framework.AddItem(source, itemName, 1)
    
    if not added then
        -- Refund if item addition fails
        Framework.AddMoney(source, 'cash', price)
        Framework.Notify(source, 'error', 'Transaction failed', 5000)
        return false
    end
    
    return true
end
```

═══════════════════════════════════════════════════════════════════════════════

## 📊 Logging Suspicious Activity

### Suspicious Activity Logger

```lua
local SuspiciousLogs = {}

function LogSuspicious(source, reason, data)
    if not Config.Security.logSuspicious then
        return
    end
    
    local identifier = Framework.GetPlayerIdentifier(source)
    local playerName = GetPlayerName(source)
    
    local log = {
        source = source,
        identifier = identifier,
        playerName = playerName,
        reason = reason,
        data = data,
        timestamp = os.date('%Y-%m-%d %H:%M:%S')
    }
    
    table.insert(SuspiciousLogs, log)
    
    -- Print to console
    print(string.format(
        '^3[SECURITY]^7 Suspicious activity: %s | Player: %s (%s) | Data: %s',
        reason,
        playerName,
        identifier,
        json.encode(data)
    ))
    
    -- Send to Discord webhook (if configured)
    if Config.Security.webhookUrl and Config.Security.webhookUrl ~= '' then
        SendWebhook(log)
    end
end

function SendWebhook(log)
    local embed = {
        {
            ['title'] = '🚨 Suspicious Activity Detected',
            ['color'] = 16711680, -- Red
            ['fields'] = {
                { ['name'] = 'Player', ['value'] = log.playerName, ['inline'] = true },
                { ['name'] = 'Identifier', ['value'] = log.identifier, ['inline'] = true },
                { ['name'] = 'Source', ['value'] = tostring(log.source), ['inline'] = true },
                { ['name'] = 'Reason', ['value'] = log.reason, ['inline'] = false },
                { ['name'] = 'Data', ['value'] = '```json\n' .. json.encode(log.data, {indent = true}) .. '\n```', ['inline'] = false },
                { ['name'] = 'Timestamp', ['value'] = log.timestamp, ['inline'] = false },
            },
            ['footer'] = { ['text'] = 'wolves.land Security System' }
        }
    }
    
    PerformHttpRequest(Config.Security.webhookUrl, function(err, text, headers) end, 'POST', json.encode({
        username = 'LXR Security',
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end
```

═══════════════════════════════════════════════════════════════════════════════

## ⚙️ Configuration Structure

```lua
-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████████ SECURITY SETTINGS █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Security = {
    enabled = true, -- Master security toggle
    
    -- Distance checks
    maxDistance = 5.0, -- Maximum interaction distance (meters)
    
    -- Rate limiting
    antiSpam = true,
    rateLimit = 1000, -- Milliseconds between repeated actions
    maxActionsPerMinute = 10,
    
    -- Logging
    logSuspicious = true,
    webhookUrl = '', -- Discord webhook URL for security alerts
    
    -- Validation
    validateState = true, -- Validate player state before actions
    validateDistance = true, -- Validate distance before actions
    validateCooldowns = true, -- Enforce server-side cooldowns
    
    -- Banning (if applicable)
    autoBan = false, -- Automatically ban on suspicion threshold
    suspicionThreshold = 10, -- Strikes before auto-ban
}
```

═══════════════════════════════════════════════════════════════════════════════

## 🎯 Security Checklist

### For Every Server Event

- [ ] Source validation (player exists)
- [ ] Distance validation (if interacting with world entity)
- [ ] State validation (alive, not in vehicle, etc.)
- [ ] Cooldown check (if repeatable action)
- [ ] Rate limiting (if spammable action)
- [ ] Required items/money verification (if transaction)
- [ ] Suspicious activity logging (on validation failure)

### For Economy Operations

- [ ] Never trust client-provided amounts
- [ ] Remove money/items BEFORE giving rewards
- [ ] Refund on failure
- [ ] Log all transactions
- [ ] Validate account types exist

### For Item Operations

- [ ] Verify player has item before removal
- [ ] Verify inventory space before addition (if applicable)
- [ ] Validate metadata
- [ ] Log failures

═══════════════════════════════════════════════════════════════════════════════

## 📋 Example Secure Event

```lua
RegisterNetEvent('lxr-resource:server:secureAction', function(entityNetId, actionType)
    local source = source
    
    -- 1. Validate player exists
    if not source then return end
    
    -- 2. Rate limiting
    if not RateLimit(source, 'secureAction', Config.Security.maxActionsPerMinute) then
        return
    end
    
    -- 3. Validate player state
    local valid, reason = ValidatePlayerState(source)
    if not valid then
        LogSuspicious(source, 'Invalid player state', reason)
        return
    end
    
    -- 4. Validate entity exists
    local entity = NetworkGetEntityFromNetworkId(entityNetId)
    if not DoesEntityExist(entity) then
        LogSuspicious(source, 'Invalid entity', entityNetId)
        return
    end
    
    -- 5. Validate distance
    local entityCoords = GetEntityCoords(entity)
    if not ValidateDistance(source, entityCoords, Config.Security.maxDistance) then
        return -- Logging done in ValidateDistance
    end
    
    -- 6. Check cooldown
    local cooldownKey = 'action:' .. entityNetId
    if not CheckCooldown(source, cooldownKey) then
        Framework.Notify(source, 'error', 'You must wait before doing this again', 5000)
        return
    end
    
    -- 7. Perform secure action
    local success = PerformSecureAction(source, entity, actionType)
    
    if success then
        -- Set cooldown
        SetCooldown(source, cooldownKey)
        
        -- Notify player
        Framework.Notify(source, 'success', 'Action completed', 5000)
    end
end)
```

═══════════════════════════════════════════════════════════════════════════════

## ✅ Validation Checklist

- [ ] All critical operations validated server-side
- [ ] Distance checks implemented where applicable
- [ ] Server-side cooldowns implemented
- [ ] Rate limiting implemented for repeatable actions
- [ ] Player state validation implemented
- [ ] Item/money verification implemented
- [ ] Suspicious activity logging implemented
- [ ] Discord webhook configured (optional but recommended)
- [ ] Config.Security section present with all options
- [ ] No client-trusted data for critical operations
- [ ] Proper error handling and refunds

═══════════════════════════════════════════════════════════════════════════════

© 2026 iBoss21 / The Lux Empire | wolves.land
