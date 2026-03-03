--[[
    ██╗     ██╗  ██╗██████╗        ███████╗██╗  ██╗ █████╗ ███╗   ███╗██████╗ ██╗     ███████╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔════╝╚██╗██╔╝██╔══██╗████╗ ████║██╔══██╗██║     ██╔════╝
    ██║      ╚███╔╝ ██████╔╝       █████╗   ╚███╔╝ ███████║██╔████╔██║██████╔╝██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗       ██╔══╝   ██╔██╗ ██╔══██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ███████╗██╔╝ ██╗██║  ██║██║ ╚═╝ ██║██║     ███████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝

    🐺 LXR Example - Server Script

    Server-side logic for the LXR Example resource.
    ALL economy, inventory, and state changes are validated here.
    NEVER trust data sent by the client.

    Security features:
    - Server-side distance validation
    - Per-player cooldown tracking
    - Rate-limit / anti-spam
    - Suspicious activity logging
    - Discord webhook alerts (optional)

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SERVER STATE
-- ═══════════════════════════════════════════════════════════════════════════════

local PlayerCooldowns  = {}   -- [source] = lastActionTime
local ActionLimiter    = {}   -- [source] = { count, resetTime }

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    -- Wait for framework adapter to initialise
    while not Framework or not Framework.GetPlayerData do
        Wait(100)
    end

    if Config.Debug then
        print('^2[lxr-example:server]^7 Framework ready: ^3' .. GetActiveFramework() .. '^7')
    end

    StartCleanupThread()
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SECURITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

--- Returns true if source is a valid, living player.
function ValidatePlayer(source)
    if not source or source == 0 then return false, 'invalid_source' end
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then return false, 'ped_not_found' end
    if Config.Security.validateEntityExists and IsEntityDead(ped) then
        return false, 'player_dead'
    end
    return true
end

--- Returns true if the player is within maxDistance of coords.
function ValidateDistance(source, coords, maxDistance)
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then return false end
    local dist = #(GetEntityCoords(ped) - coords)
    if dist > (maxDistance or Config.Security.maxDistance) then
        LogSuspicious(source, 'distance_exploit', {
            distance = dist, max = maxDistance or Config.Security.maxDistance
        })
        return false
    end
    return true
end

--- Returns true and resets the timer if the player is not on cooldown.
function CheckCooldown(source)
    local now  = GetGameTimer()
    local last = PlayerCooldowns[source]
    if last and (now - last) < Config.Cooldowns.globalCooldown then
        return false, math.ceil((Config.Cooldowns.globalCooldown - (now - last)) / 1000)
    end
    return true
end

function SetCooldown(source)
    PlayerCooldowns[source] = GetGameTimer()
end

--- Returns true when the player is within the per-minute rate limit.
function RateLimit(source)
    local now = GetGameTimer()
    if not ActionLimiter[source] then
        ActionLimiter[source] = { count = 0, reset = now + 60000 }
    end

    local limiter = ActionLimiter[source]
    if now > limiter.reset then
        limiter.count = 0
        limiter.reset = now + 60000
    end

    limiter.count = limiter.count + 1
    if limiter.count > Config.Security.maxActionsPerMinute then
        LogSuspicious(source, 'rate_limit_exceeded', { count = limiter.count })
        return false
    end
    return true
end

--- Log a suspicious event and optionally send a Discord webhook alert.
function LogSuspicious(source, reason, data)
    if not Config.Security.logSuspiciousActivity then return end

    local name = GetPlayerName(source) or 'Unknown'
    local ids  = GetPlayerIdentifiers(source)

    print(string.format(
        '^1[lxr-example:SECURITY]^7 SUSPICIOUS — Player: %s (src %d) | Reason: %s | Data: %s',
        name, source, reason, json.encode(data or {})
    ))

    -- Optional Discord webhook
    if Config.Security.webhookUrl and Config.Security.webhookUrl ~= '' then
        SendSecurityWebhook(source, name, ids, reason, data)
    end

    -- Auto-kick / ban (disabled by default — enable with caution)
    if Config.Security.kickOnExploit then
        DropPlayer(source, '🐺 wolves.land — Exploit detected. Contact an admin if this is an error.')
    end
end

--- Send a Discord embed alert to the configured webhook.
function SendSecurityWebhook(source, name, identifiers, reason, data)
    local idStr = table.concat(identifiers or {}, '\n')
    PerformHttpRequest(Config.Security.webhookUrl, function() end, 'POST',
        json.encode({
            username   = '🐺 wolves.land Security',
            avatar_url = 'https://www.wolves.land/favicon.ico',
            embeds = {{
                title       = '⚠️ Suspicious Activity Detected',
                color       = 16711680,
                description = string.format('**Reason:** %s\n**Data:** %s', reason, json.encode(data or {})),
                fields = {
                    { name = 'Player', value = string.format('%s (src %d)', name, source), inline = true },
                    { name = 'Identifiers', value = idStr ~= '' and idStr or 'N/A', inline = true },
                },
                footer = { text = 'lxr-example | wolves.land' },
                timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
            }}
        }),
        { ['Content-Type'] = 'application/json' }
    )
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 MAIN ACTION HANDLER
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-example:server:performAction')
AddEventHandler('lxr-example:server:performAction', function(clientCoords)
    local source = source

    -- ── 1. Validate player state ────────────────────────────────────────────
    local ok, reason = ValidatePlayer(source)
    if not ok then
        if Config.Debug then
            print(string.format('^3[lxr-example:server]^7 ValidatePlayer failed for src %d: %s', source, reason))
        end
        TriggerClientEvent('lxr-example:client:actionFailed', source,
            Config.Locale[Config.Lang].error or 'Validation failed')
        return
    end

    -- ── 2. Rate-limit check ─────────────────────────────────────────────────
    if not RateLimit(source) then
        TriggerClientEvent('lxr-example:client:actionFailed', source,
            Config.Locale[Config.Lang].cooldown_active or 'Too many actions')
        return
    end

    -- ── 3. Cooldown check ───────────────────────────────────────────────────
    local onCooldown, remaining = CheckCooldown(source)
    if not onCooldown then
        TriggerClientEvent('lxr-example:client:actionFailed', source,
            (Config.Locale[Config.Lang].cooldown_active or 'Cooldown active') ..
            string.format(' (%ds remaining)', remaining))
        return
    end

    -- ── 4. Distance validation (server-authoritative coords) ────────────────
    local targetCoords = vector3(-352.21, 804.74, 117.61) -- Must match client
    if not ValidateDistance(source, targetCoords) then
        TriggerClientEvent('lxr-example:client:actionFailed', source,
            Config.Locale[Config.Lang].distance_too_far or 'Too far away')
        return
    end

    -- ── 5. Perform action — pick a random reward ────────────────────────────
    local reward = PickReward()
    if not reward then
        TriggerClientEvent('lxr-example:client:actionFailed', source,
            Config.Locale[Config.Lang].error or 'No reward available')
        return
    end

    -- Give item via framework adapter
    local added = Framework.AddItem(source, reward.name, reward.count)
    if not added then
        TriggerClientEvent('lxr-example:client:actionFailed', source,
            Config.Locale[Config.Lang].error or 'Could not give item')
        return
    end

    -- ── 6. Set cooldown and notify client ────────────────────────────────────
    SetCooldown(source)

    TriggerClientEvent('lxr-example:client:actionSuccess', source, {
        item  = reward.label or reward.name,
        count = reward.count
    })

    if Config.Debug then
        print(string.format(
            '^2[lxr-example:server]^7 Player src %d received %s x%d',
            source, reward.name, reward.count
        ))
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 REWARD LOGIC
-- ═══════════════════════════════════════════════════════════════════════════════

--- Pick a random item from Config.RewardItems weighted by chance.
function PickReward()
    local roll = math.random()
    for _, entry in ipairs(Config.RewardItems) do
        if roll <= entry.chance then
            local count = math.random(entry.minCount, entry.maxCount)
            return { name = entry.name, label = entry.label, count = count }
        end
    end
    return nil
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CLEANUP THREAD
-- ═══════════════════════════════════════════════════════════════════════════════

function StartCleanupThread()
    CreateThread(function()
        while true do
            Wait(Config.Performance.cleanupInterval)

            local now         = GetGameTimer()
            local activePlayers = {}
            for _, src in ipairs(GetPlayers()) do
                activePlayers[tonumber(src)] = true
            end

            -- Remove stale cooldown / limiter entries for disconnected players
            for src in pairs(PlayerCooldowns) do
                if not activePlayers[src] then
                    PlayerCooldowns[src] = nil
                end
            end
            for src in pairs(ActionLimiter) do
                if not activePlayers[src] then
                    ActionLimiter[src] = nil
                end
            end

            if Config.Debug then
                print('^2[lxr-example:server]^7 Cleanup complete — active players: ' .. #GetPlayers())
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 PLAYER DISCONNECT — CLEAR STATE
-- ═══════════════════════════════════════════════════════════════════════════════

AddEventHandler('playerDropped', function(reason)
    local source = source
    PlayerCooldowns[source] = nil
    ActionLimiter[source]   = nil

    if Config.Debug then
        print(string.format('^3[lxr-example:server]^7 Cleared state for dropped player src %d', source))
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- END OF SERVER SCRIPT
-- ═══════════════════════════════════════════════════════════════════════════════
