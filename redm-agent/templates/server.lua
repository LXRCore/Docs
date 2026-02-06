--[[
    ██╗     ██╗  ██╗██████╗        ███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗ 
    ██║     ╚██╗██╔╝██╔══██╗       ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗
    ██║      ╚███╔╝ ██████╔╝       ███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝
    ██║      ██╔██╗ ██╔══██╗       ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗
    ███████╗██╔╝ ██╗██║  ██║       ███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝
    
    🐺 LXR Resource - Server Script
    
    Server-side logic for the LXR Resource system.
    Handles security validation, economy transactions, and database operations.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SERVER VARIABLES
-- ═══════════════════════════════════════════════════════════════════════════════

local PlayerCooldowns = {}
local ActionLimiter = {}

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    -- Wait for framework to be ready
    while not Framework or not Framework.GetPlayerData do
        Wait(100)
    end
    
    if Config.Debug then
        print('^2[Server]^7 Framework loaded and ready')
    end
    
    -- Start cleanup thread
    StartCleanupThread()
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SECURITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Validate player exists and is in valid state
function ValidatePlayer(source)
    if not source or source == 0 then
        return false, 'Invalid source'
    end
    
    local playerPed = GetPlayerPed(source)
    if not playerPed or playerPed == 0 then
        return false, 'Player ped not found'
    end
    
    if Config.Security.validateEntityExists then
        if IsEntityDead(playerPed) then
            return false, 'Player is dead'
        end
    end
    
    return true
end

-- Validate distance between player and entity/coords
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
            maxDistance = maxDistance or Config.Security.maxDistance,
            playerCoords = playerCoords,
            targetCoords = coords
        })
        return false
    end
    
    return true
end

-- Check cooldown for an action
function CheckCooldown(source, identifier)
    if not Config.Cooldowns.perPlayerCooldown then
        identifier = 'global:' .. identifier
    else
        identifier = source .. ':' .. identifier
    end
    
    local lastUse = PlayerCooldowns[identifier]
    
    if not lastUse then
        return true
    end
    
    local timePassed = os.time() - lastUse
    local cooldownSeconds = Config.Cooldowns.globalCooldown / 1000
    
    return timePassed >= cooldownSeconds
end

-- Set cooldown for an action
function SetCooldown(source, identifier)
    if not Config.Cooldowns.perPlayerCooldown then
        identifier = 'global:' .. identifier
    else
        identifier = source .. ':' .. identifier
    end
    
    PlayerCooldowns[identifier] = os.time()
end

-- Rate limiting to prevent spam
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

-- Log suspicious activity
function LogSuspicious(source, reason, data)
    if not Config.Security.logSuspiciousActivity then
        return
    end
    
    local identifier = Framework.GetIdentifier(source)
    local playerName = GetPlayerName(source)
    
    local log = {
        source = source,
        identifier = identifier,
        playerName = playerName,
        reason = reason,
        data = data,
        timestamp = os.date('%Y-%m-%d %H:%M:%S')
    }
    
    -- Print to console
    print(string.format(
        '^3[SECURITY]^7 %s | Player: %s (%s) | Data: %s',
        reason,
        playerName,
        identifier,
        json.encode(data)
    ))
    
    -- Send to Discord webhook if configured
    if Config.Security.webhookUrl and Config.Security.webhookUrl ~= '' then
        SendSecurityWebhook(log)
    end
end

-- Send webhook notification
function SendSecurityWebhook(log)
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

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CLEANUP THREAD
-- ═══════════════════════════════════════════════════════════════════════════════

function StartCleanupThread()
    CreateThread(function()
        while true do
            Wait(Config.Performance.cleanupInterval)
            
            -- Clean up old cooldowns
            local currentTime = os.time()
            local cooldownSeconds = Config.Cooldowns.globalCooldown / 1000
            
            for key, timestamp in pairs(PlayerCooldowns) do
                if currentTime - timestamp > cooldownSeconds * 2 then
                    PlayerCooldowns[key] = nil
                end
            end
            
            -- Clean up old rate limiters
            for key, data in pairs(ActionLimiter) do
                if currentTime >= data.resetTime + 300 then -- 5 minutes after reset
                    ActionLimiter[key] = nil
                end
            end
            
            if Config.Debug then
                print('^2[Server]^7 Cleanup completed')
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SERVER EVENTS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Example secure event handler
RegisterNetEvent('lxr-resource:server:interact', function(entityNetId)
    local source = source
    
    -- 1. Validate player exists
    local valid, reason = ValidatePlayer(source)
    if not valid then
        LogSuspicious(source, 'Invalid player state', reason)
        return
    end
    
    -- 2. Rate limiting
    if not RateLimit(source, 'interact', Config.Security.maxActionsPerMinute) then
        Framework.Notify(source, 'You are doing that too fast', 'error', 5000)
        return
    end
    
    -- 3. Validate entity exists
    local entity = NetworkGetEntityFromNetworkId(entityNetId)
    if not DoesEntityExist(entity) then
        LogSuspicious(source, 'Invalid entity', entityNetId)
        Framework.Notify(source, 'Entity no longer exists', 'error', 5000)
        return
    end
    
    -- 4. Validate distance
    local entityCoords = GetEntityCoords(entity)
    if not ValidateDistance(source, entityCoords, Config.Security.maxDistance) then
        Framework.Notify(source, 'You are too far away', 'error', 5000)
        return
    end
    
    -- 5. Check cooldown
    local cooldownKey = 'interact:' .. entityNetId
    if not CheckCooldown(source, cooldownKey) then
        Framework.Notify(source, 'You must wait before doing this again', 'error', 5000)
        return
    end
    
    -- 6. Perform action
    local success = PerformInteraction(source, entity)
    
    if success then
        -- Set cooldown
        SetCooldown(source, cooldownKey)
        
        -- Notify player
        Framework.Notify(source, 'Interaction successful', 'success', 5000)
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 ACTION HANDLERS
-- ═══════════════════════════════════════════════════════════════════════════════

function PerformInteraction(source, entity)
    -- Add your interaction logic here
    -- Example: Give item, add money, etc.
    
    -- Example: Give random item
    local items = {'bread', 'water'}
    local randomItem = items[math.random(#items)]
    local amount = math.random(1, 3)
    
    Framework.AddItem(source, randomItem, amount)
    
    if Config.Debug then
        print(string.format('^2[Server]^7 Player %s interacted with entity %s', source, entity))
    end
    
    return true
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CALLBACKS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Example callback registration
--[[
Framework.RegisterCallback('lxr-resource:server:getData', function(source, cb, arg1, arg2)
    -- Validate player
    local valid = ValidatePlayer(source)
    if not valid then
        cb(false)
        return
    end
    
    -- Get data
    local data = {
        success = true,
        message = 'Data retrieved successfully',
        arg1 = arg1,
        arg2 = arg2
    }
    
    cb(data)
end)
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Get locale text with fallback
function GetLocaleText(key)
    local lang = Config.Lang or 'en'
    if Config.Locale[lang] and Config.Locale[lang][key] then
        return Config.Locale[lang][key]
    end
    return Config.Locale['en'][key] or key
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 PLAYER DISCONNECT CLEANUP
-- ═══════════════════════════════════════════════════════════════════════════════

AddEventHandler('playerDropped', function(reason)
    local source = source
    
    -- Clean up player-specific data
    for key, _ in pairs(PlayerCooldowns) do
        if key:match('^' .. source .. ':') then
            PlayerCooldowns[key] = nil
        end
    end
    
    for key, _ in pairs(ActionLimiter) do
        if key:match('^' .. source .. ':') then
            ActionLimiter[key] = nil
        end
    end
    
    if Config.Debug then
        print(string.format('^3[Server]^7 Cleaned up data for disconnected player %s', source))
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE STOP CLEANUP
-- ═══════════════════════════════════════════════════════════════════════════════

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Clean up all data
    PlayerCooldowns = {}
    ActionLimiter = {}
    
    if Config.Debug then
        print('^3[Server]^7 Resource stopped and all data cleaned up')
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Example exports for other resources to use
--[[
exports('CheckCooldown', CheckCooldown)
exports('SetCooldown', SetCooldown)
exports('ValidateDistance', ValidateDistance)
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 END OF SERVER SCRIPT
-- ═══════════════════════════════════════════════════════════════════════════════
