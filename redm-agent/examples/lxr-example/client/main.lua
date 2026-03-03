--[[
    ██╗     ██╗  ██╗██████╗        ███████╗██╗  ██╗ █████╗ ███╗   ███╗██████╗ ██╗     ███████╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔════╝╚██╗██╔╝██╔══██╗████╗ ████║██╔══██╗██║     ██╔════╝
    ██║      ╚███╔╝ ██████╔╝       █████╗   ╚███╔╝ ███████║██╔████╔██║██████╔╝██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗       ██╔══╝   ██╔██╗ ██╔══██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ███████╗██╔╝ ██╗██║  ██║██║ ╚═╝ ██║██║     ███████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝

    🐺 LXR Example - Client Script

    Client-side logic for the LXR Example resource.
    Handles player interactions, progress bars, and notification feedback.
    All critical game-state changes are requested via server events — never
    performed on the client directly.

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LOCAL STATE
-- ═══════════════════════════════════════════════════════════════════════════════

local PlayerData      = {}
local isPlayerLoaded  = false
local isActionActive  = false  -- Prevent concurrent actions

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    -- Wait until the framework adapter is fully loaded
    while not Framework or not Framework.GetPlayerData do
        Wait(100)
    end

    PlayerData    = Framework.GetPlayerData()
    isPlayerLoaded = true

    if Config.Debug then
        print('^2[lxr-example:client]^7 Player data loaded. Framework: ^3' .. GetActiveFramework() .. '^7')
    end

    InitializeResource()
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

function InitializeResource()
    if Config.Debug then
        print('^2[lxr-example:client]^7 Initializing resource systems...')
    end

    -- Register target interactions if ox_target is enabled
    if Config.Performance.useOxTarget then
        RegisterExampleTargets()
    end

    -- Start the main proximity loop (fallback when ox_target is disabled)
    if not Config.Performance.useOxTarget then
        StartProximityLoop()
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 TARGET SYSTEM INTEGRATION (ox_target)
-- ═══════════════════════════════════════════════════════════════════════════════

function RegisterExampleTargets()
    if not exports['ox_target'] then
        print('^3[lxr-example:client]^7 ox_target not available — falling back to proximity loop')
        StartProximityLoop()
        return
    end

    -- Example: add a zone around a specific coordinate
    exports['ox_target']:addBoxZone({
        coords  = vector3(-352.21, 804.74, 117.61), -- Replace with your coords
        size    = vector3(1.5, 1.5, 1.5),
        rotation = 0,
        debug   = Config.Debug,
        options = {
            {
                label   = Config.Locale[Config.Lang].action_start or 'Interact',
                icon    = 'fa-solid fa-hand',
                onSelect = function()
                    TriggerExampleAction()
                end
            }
        }
    })

    if Config.Debug then
        print('^2[lxr-example:client]^7 Target zones registered via ox_target')
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 PROXIMITY LOOP (fallback when ox_target is disabled)
-- ═══════════════════════════════════════════════════════════════════════════════

function StartProximityLoop()
    CreateThread(function()
        while true do
            Wait(Config.Performance.updateInterval)

            if not isPlayerLoaded then goto continue end

            local playerCoords = GetEntityCoords(PlayerPedId())
            local targetCoords = vector3(-352.21, 804.74, 117.61) -- Replace with your coords

            if #(playerCoords - targetCoords) <= Config.General.interactDistance then
                -- Show interaction hint
                BeginTextCommandDisplayHelp('STRING')
                AddTextComponentSubstringPlayerName(Config.Locale[Config.Lang].action_start or 'Press ~INPUT_CONTEXT~ to interact')
                EndTextCommandDisplayHelp(0, false, true, -1)

                -- Listen for the interaction key
                if IsControlJustPressed(0, Config.Keys.interact) and not isActionActive then
                    TriggerExampleAction()
                end
            end

            ::continue::
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 EXAMPLE ACTION
-- ═══════════════════════════════════════════════════════════════════════════════

function TriggerExampleAction()
    if isActionActive then return end
    isActionActive = true

    local locale = Config.Locale[Config.Lang]

    -- Show progress bar via framework adapter
    local completed = Framework.ProgressBar(
        locale.action_start or 'Working...',
        Config.Cooldowns.actionTime,
        { canCancel = true, disable = { move = true, car = true, combat = true } }
    )

    if not completed then
        Framework.Notify(locale.action_cancelled or 'Cancelled', 'error', 3000)
        isActionActive = false
        return
    end

    -- Request the server to process the action (NEVER handle economy/inventory client-side)
    TriggerServerEvent('lxr-example:server:performAction', GetEntityCoords(PlayerPedId()))

    isActionActive = false
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SERVER RESPONSE HANDLERS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Called by server after successful action validation
RegisterNetEvent('lxr-example:client:actionSuccess')
AddEventHandler('lxr-example:client:actionSuccess', function(rewardData)
    local locale = Config.Locale[Config.Lang]

    local msg = (locale.action_complete or 'Done!') .. ' '
    if rewardData and rewardData.item then
        msg = msg .. rewardData.item .. ' x' .. (rewardData.count or 1)
    end

    Framework.Notify(msg, 'success', 5000)

    if Config.Debug then
        print('^2[lxr-example:client]^7 Action success — reward: ' .. json.encode(rewardData or {}))
    end
end)

-- Called by server when action is rejected (cooldown, distance, etc.)
RegisterNetEvent('lxr-example:client:actionFailed')
AddEventHandler('lxr-example:client:actionFailed', function(reason)
    local locale = Config.Locale[Config.Lang]
    local msg = reason or locale.error or 'An error occurred'
    Framework.Notify(msg, 'error', 4000)

    if Config.Debug then
        print('^3[lxr-example:client]^7 Action failed — reason: ' .. tostring(reason))
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 PLAYER DATA SYNC
-- ═══════════════════════════════════════════════════════════════════════════════

-- Refresh local player data when framework signals an update
-- (event names vary per framework — handled transparently via adapter)
AddEventHandler('lxr-example:client:playerDataUpdated', function(data)
    PlayerData = data or {}
    if Config.Debug then
        print('^2[lxr-example:client]^7 Player data refreshed')
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE CLEANUP
-- ═══════════════════════════════════════════════════════════════════════════════

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    isPlayerLoaded = false
    isActionActive = false

    if Config.Debug then
        print('^1[lxr-example:client]^7 Resource stopped — cleaned up local state')
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- END OF CLIENT SCRIPT
-- ═══════════════════════════════════════════════════════════════════════════════
