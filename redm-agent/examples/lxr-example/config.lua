--[[
    ██╗     ██╗  ██╗██████╗        ███████╗██╗  ██╗ █████╗ ███╗   ███╗██████╗ ██╗     ███████╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔════╝╚██╗██╔╝██╔══██╗████╗ ████║██╔══██╗██║     ██╔════╝
    ██║      ╚███╔╝ ██████╔╝       █████╗   ╚███╔╝ ███████║██╔████╔██║██████╔╝██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗       ██╔══╝   ██╔██╗ ██╔══██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ███████╗██╔╝ ██╗██║  ██║██║ ╚═╝ ██║██║     ███████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝
    
    🐺 LXR Example - Configuration
    
    This configuration file controls the LXR Example resource for RedM.
    Demonstrates the complete wolves.land production-grade config structure
    with multi-framework support, resource name protection, and startup banner.
    
    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════
    
    Server:      The Land of Wolves 🐺
    Tagline:     Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
    Description: ისტორია ცოცხლდება აქ! (History Lives Here!)
    Type:        Serious Hardcore Roleplay
    Access:      Discord & Whitelisted
    
    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21
    Store:       https://theluxempire.tebex.io
    Server:      https://servers.redm.net/servers/detail/8gj7eb
    
    ═══════════════════════════════════════════════════════════════════════════════
    
    Version: 1.0.0
    Performance Target: Optimized for minimal server overhead and client FPS impact
    
    Tags: RedM, Georgian, SeriousRP, Whitelist, Example, LXR, wolves.land
    
    Framework Support:
    - LXR Core (Primary)
    - RSG Core (Compatible)
    - VORP Core (Compatible)
    - RedEM:RP (Compatible)
    - QBR Core (Compatible)
    - QR Core (Compatible)
    - Standalone (Compatible)
    
    ═══════════════════════════════════════════════════════════════════════════════
    CREDITS
    ═══════════════════════════════════════════════════════════════════════════════
    
    Script Author: iBoss21 / The Lux Empire for The Land of Wolves
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE NAME PROTECTION - RUNTIME CHECK
-- ═══════════════════════════════════════════════════════════════════════════════

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

Config = {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SERVER BRANDING & INFO ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.ServerInfo = {
    name          = 'The Land of Wolves 🐺',
    tagline       = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description   = 'ისტორია ცოცხლდება აქ!', -- History Lives Here!
    type          = 'Serious Hardcore Roleplay',
    access        = 'Discord & Whitelisted',

    -- Contact & Links
    website       = 'https://www.wolves.land',
    discord       = 'https://discord.gg/CrKcWdfd3A',
    github        = 'https://github.com/iBoss21',
    store         = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',

    -- Developer Info
    developer     = 'iBoss21 / The Lux Empire',

    -- Tags
    tags          = {'RedM', 'Georgian', 'SeriousRP', 'Whitelist', 'Example', 'wolves.land'}
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ FRAMEWORK CONFIGURATION ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Framework Priority (in order):
    1. LXR-Core  (Primary)
    2. RSG-Core  (Primary)
    3. VORP Core (Supported)
    4. RedEM:RP  (Optional - if detected)
    5. QBR-Core  (Optional - if detected)
    6. QR-Core   (Optional - if detected)
    7. Standalone (Fallback)
]]

Config.Framework = 'auto' -- 'auto' or manual override: 'lxr-core', 'rsg-core', 'vorp_core', 'redem_roleplay', 'qbr-core', 'qr-core', 'standalone'

-- Framework-specific settings used by the framework bridge adapter
Config.FrameworkSettings = {
    ['lxr-core'] = {
        resource     = 'lxr-core',
        notifications = 'ox_lib',
        inventory    = 'lxr-inventory',
        target       = 'ox_target',
        progressbar  = 'ox_lib',
        events = {
            server   = 'lxr-core:server:%s',
            client   = 'lxr-core:client:%s',
            callback = 'lxr-core:callback:%s'
        }
    },
    ['rsg-core'] = {
        resource     = 'rsg-core',
        notifications = 'ox_lib',
        inventory    = 'rsg-inventory',
        target       = 'ox_target',
        progressbar  = 'ox_lib',
        events = {
            server   = 'RSGCore:Server:%s',
            client   = 'RSGCore:Client:%s',
            callback = 'RSGCore:Callback:%s'
        }
    },
    ['vorp_core'] = {
        resource     = 'vorp_core',
        notifications = 'vorp',
        inventory    = 'vorp_inventory',
        target       = 'vorp_target',
        progressbar  = 'vorp',
        events = {
            server   = 'vorp:%s',
            client   = 'vorp:%s',
            callback = 'vorp:callback:%s'
        }
    },
    ['redem_roleplay'] = {
        resource     = 'redem_roleplay',
        notifications = 'redem',
        inventory    = 'redem_inventory',
        target       = 'redem_target',
        progressbar  = 'redem',
        events = {
            server   = 'redem:%s:server',
            client   = 'redem:%s:client',
            callback = 'redem:%s:callback'
        }
    },
    ['qbr-core'] = {
        resource     = 'qbr-core',
        notifications = 'ox_lib',
        inventory    = 'qbr-inventory',
        target       = 'ox_target',
        progressbar  = 'ox_lib',
        events = {
            server   = 'QBR:Server:%s',
            client   = 'QBR:Client:%s',
            callback = 'QBR:Callback:%s'
        }
    },
    ['qr-core'] = {
        resource     = 'qr-core',
        notifications = 'ox_lib',
        inventory    = 'qr-inventory',
        target       = 'ox_target',
        progressbar  = 'ox_lib',
        events = {
            server   = 'QR:Server:%s',
            client   = 'QR:Client:%s',
            callback = 'QR:Callback:%s'
        }
    },
    ['standalone'] = {
        resource     = nil,
        notifications = 'chat',
        inventory    = nil,
        target       = nil,
        progressbar  = 'native',
        events = {
            server   = '%s:server',
            client   = '%s:client',
            callback = '%s:callback'
        }
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LANGUAGE CONFIGURATION ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Lang = 'en' -- Active language ('en', 'ge', etc.)

Config.Locale = {
    en = {
        action_start      = 'Starting action...',
        action_cancelled  = 'Action cancelled',
        action_complete   = 'Action completed!',
        cooldown_active   = 'You must wait before doing that again',
        distance_too_far  = 'You are too far away',
        not_enough_money  = 'You do not have enough money',
        success           = 'Success!',
        error             = 'An error occurred',
    },
    ge = {
        action_start      = 'მოქმედება იწყება...',
        action_cancelled  = 'მოქმედება გაუქმდა',
        action_complete   = 'მოქმედება დასრულდა!',
        cooldown_active   = 'გარკვეული დრო უნდა გაიაროს',
        distance_too_far  = 'ძალიან შორს ხარ',
        not_enough_money  = 'საკმარისი ფული არ გაქვს',
        success           = 'წარმატება!',
        error             = 'შეცდომა მოხდა',
    }
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ GENERAL SETTINGS ██████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.General = {
    interactDistance  = 2.0,   -- Distance in metres to interact with objects
    enableSounds      = true,  -- Play sound effects on actions
    enableParticles   = false, -- Enable particle effects (performance impact)
    requireEmptyHands = false  -- Require player to have no weapon drawn
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ KEYS CONFIGURATION ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

-- Key hash values — see:
-- https://github.com/femga/rdr3_discoveries/blob/master/Controls/keyboard_controls.lua

Config.Keys = {
    interact = 0x07CE1E61, -- Left Alt  (default targeting key)
    cancel   = 0x8CC9CD42, -- X         (cancel ongoing action)
    confirm  = 0xC7B5340A  -- E         (confirm selection)
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ TIMING & COOLDOWNS ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Cooldowns = {
    actionTime       = 5000,      -- Duration of the progress bar in ms (5 s)
    globalCooldown   = 3600000,   -- Per-object cooldown in ms (60 min)
    perPlayerCooldown = true,     -- Track cooldown per player vs. globally
    actionDelay      = 1000       -- Minimum delay between repeated actions (ms)
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ EXAMPLE ITEMS / REWARDS ███████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

--[[
    Define items that can be rewarded or interacted with.
    Each entry: { name, label, minCount, maxCount, chance (0.0–1.0) }
]]

Config.RewardItems = {
    { name = 'water',      label = 'Water Canteen',   minCount = 1, maxCount = 2,  chance = 0.80 },
    { name = 'bread',      label = 'Stale Bread',     minCount = 1, maxCount = 1,  chance = 0.60 },
    { name = 'bandage',    label = 'Bandage',          minCount = 1, maxCount = 3,  chance = 0.40 },
    { name = 'gold_nugget',label = 'Gold Nugget',      minCount = 1, maxCount = 1,  chance = 0.10 },
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SECURITY & ANTI-ABUSE █████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Security = {
    enabled              = true,    -- Master toggle for all security checks
    maxDistance          = 5.0,     -- Max allowed distance (metres) for server validation
    maxActionsPerMinute  = 10,      -- Rate-limit: max actions per player per minute
    requireLineOfSight   = false,   -- Require direct line-of-sight to the target
    validateEntityExists = true,    -- Re-check entity still exists on server
    logSuspiciousActivity = true,   -- Log exploit attempts to console
    webhookUrl           = '',      -- Discord webhook URL for security alerts (leave empty to disable)
    kickOnExploit        = false,   -- Auto-kick on confirmed exploit (use with caution)
    banOnExploit         = false    -- Auto-ban on confirmed exploit (requires admin framework)
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ PERFORMANCE OPTIMIZATION ██████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Performance = {
    updateInterval    = 1000,  -- Main client loop interval in ms
    cleanupInterval   = 300000, -- Server-side data cleanup interval in ms (5 min)
    maxTrackedEntities = 50,   -- Max simultaneous tracked entities
    useOxTarget       = true   -- Use ox_target for interactions (false = key-press fallback)
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DEBUG SETTINGS ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

Config.Debug = false -- Set true during development; MUST be false for production / Tebex delivery

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ STARTUP BOOT BANNER ███████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████

CreateThread(function()
    Wait(1000)
    print([[

        ═══════════════════════════════════════════════════════════════════════════════

            ██╗     ██╗  ██╗██████╗        ███████╗██╗  ██╗ █████╗ ███╗   ███╗██████╗ ██╗     ███████╗
            ██║     ╚██╗██╔╝██╔══██╗       ██╔════╝╚██╗██╔╝██╔══██╗████╗ ████║██╔══██╗██║     ██╔════╝
            ██║      ╚███╔╝ ██████╔╝       █████╗   ╚███╔╝ ███████║██╔████╔██║██████╔╝██║     █████╗  
            ██║      ██╔██╗ ██╔══██╗       ██╔══╝   ██╔██╗ ██╔══██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝  
            ███████╗██╔╝ ██╗██║  ██║       ███████╗██╔╝ ██╗██║  ██║██║ ╚═╝ ██║██║     ███████╗███████╗
            ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝

        ═══════════════════════════════════════════════════════════════════════════════
        🐺 LXR EXAMPLE - SUCCESSFULLY LOADED
        ═══════════════════════════════════════════════════════════════════════════════

        Version:      1.0.0
        Server:       The Land of Wolves 🐺
        Resource:     lxr-example

        Framework:    ]] .. Config.Framework .. [[  (auto-detect active)
        Language:     ]] .. Config.Lang .. [[
        Security:     ]] .. (Config.Security.enabled and 'ENABLED ✓' or 'DISABLED ✗') .. [[
        Debug:        ]] .. (Config.Debug and 'ENABLED ⚠' or 'DISABLED ✓') .. [[

        Reward Items: ]] .. #Config.RewardItems .. [[  configured

        ═══════════════════════════════════════════════════════════════════════════════

        Developer:    iBoss21 / The Lux Empire
        Website:      https://www.wolves.land
        Discord:      https://discord.gg/CrKcWdfd3A
        Store:        https://theluxempire.tebex.io

        ═══════════════════════════════════════════════════════════════════════════════

    ]])
end)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ END OF CONFIGURATION ██████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
