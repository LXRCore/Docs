--[[
    ██╗     ██╗  ██╗██████╗         ██████╗██╗     ██╗███████╗███╗   ██╗████████╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔════╝██║     ██║██╔════╝████╗  ██║╚══██╔══╝
    ██║      ╚███╔╝ ██████╔╝       ██║     ██║     ██║█████╗  ██╔██╗ ██║   ██║   
    ██║      ██╔██╗ ██╔══██╗       ██║     ██║     ██║██╔══╝  ██║╚██╗██║   ██║   
    ███████╗██╔╝ ██╗██║  ██║       ╚██████╗███████╗██║███████╗██║ ╚████║   ██║   
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═════╝╚══════╝╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   
    
    🐺 LXR Resource - Client Script
    
    Client-side logic for the LXR Resource system.
    Handles player interactions, UI rendering, and local state management.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 LOCAL VARIABLES
-- ═══════════════════════════════════════════════════════════════════════════════

local PlayerData = {}
local isPlayerLoaded = false

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    -- Wait for framework to be ready
    while not Framework or not Framework.GetPlayerData do
        Wait(100)
    end
    
    -- Get initial player data
    PlayerData = Framework.GetPlayerData()
    isPlayerLoaded = true
    
    if Config.Debug then
        print('^2[Client]^7 Player loaded and ready')
    end
    
    -- Initialize resource-specific systems
    InitializeResource()
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════════

function InitializeResource()
    -- Add your initialization code here
    -- Examples:
    -- - Set up target zones
    -- - Register keybinds
    -- - Start main loops
    -- - Initialize UI
    
    if Config.Debug then
        print('^2[Client]^7 Resource initialized')
    end
    
    -- Example: Start main update loop
    StartMainLoop()
    
    -- Example: Initialize target system
    if Config.Performance.useOxTarget then
        InitializeTargetSystem()
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 MAIN UPDATE LOOP
-- ═══════════════════════════════════════════════════════════════════════════════

function StartMainLoop()
    CreateThread(function()
        while true do
            Wait(Config.Performance.updateInterval)
            
            if isPlayerLoaded then
                -- Add your main update logic here
                -- This runs every Config.Performance.updateInterval milliseconds
                
                if Config.Debug then
                    -- Debug info
                    local playerPed = PlayerPedId()
                    local coords = GetEntityCoords(playerPed)
                    -- print(string.format('Position: %.2f, %.2f, %.2f', coords.x, coords.y, coords.z))
                end
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 TARGET SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════

function InitializeTargetSystem()
    if not Config.Performance.useOxTarget then return end
    
    -- Example: Add target option for an entity type
    --[[
    exports['ox_target']:addModel({
        'p_crate01x',
        'p_crate02x'
    }, {
        {
            name = 'lxr_resource_interact',
            icon = 'fas fa-hand',
            label = 'Interact',
            distance = 2.5,
            onSelect = function(data)
                InteractWithEntity(data.entity)
            end,
            canInteract = function(entity, distance, coords, name, bone)
                return true -- Add conditions here
            end
        }
    })
    ]]
    
    if Config.Debug then
        print('^2[Client]^7 Target system initialized')
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 INTERACTION HANDLER
-- ═══════════════════════════════════════════════════════════════════════════════

function InteractWithEntity(entity)
    if not DoesEntityExist(entity) then
        Framework.Notify('Entity no longer exists', 'error', 5000)
        return
    end
    
    -- Show progress bar
    local success = Framework.ProgressBar('Interacting...', 5000, {
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        }
    })
    
    if not success then
        Framework.Notify('Interaction cancelled', 'error', 3000)
        return
    end
    
    -- Trigger server-side validation
    local entityNetId = NetworkGetNetworkIdFromEntity(entity)
    TriggerServerEvent('lxr-resource:server:interact', entityNetId)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 KEYBIND EXAMPLE
-- ═══════════════════════════════════════════════════════════════════════════════

-- Example keybind registration
--[[
RegisterCommand('+resource_action', function()
    if isPlayerLoaded then
        PerformResourceAction()
    end
end, false)

RegisterCommand('-resource_action', function()
    -- Key released
end, false)

RegisterKeyMapping('+resource_action', 'Perform Resource Action', 'keyboard', 'E')
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CLIENT EVENTS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Example client event handler
RegisterNetEvent('lxr-resource:client:notify', function(message, type, duration)
    Framework.Notify(message, type, duration)
end)

-- Example: Update player data event
RegisterNetEvent('lxr-resource:client:updatePlayerData', function(data)
    PlayerData = data
    
    if Config.Debug then
        print('^2[Client]^7 Player data updated')
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CALLBACK EXAMPLE
-- ═══════════════════════════════════════════════════════════════════════════════

--[[
-- Example: Trigger server callback
Framework.TriggerCallback('lxr-resource:server:getData', function(data)
    if data then
        print('Received data from server:', json.encode(data))
    end
end, arg1, arg2)
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

function IsPlayerLoaded()
    return isPlayerLoaded
end

function GetPlayerData()
    return PlayerData
end

-- Get locale text with fallback
function GetLocaleText(key)
    local lang = Config.Lang or 'en'
    if Config.Locale[lang] and Config.Locale[lang][key] then
        return Config.Locale[lang][key]
    end
    return Config.Locale['en'][key] or key
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CLEANUP ON RESOURCE STOP
-- ═══════════════════════════════════════════════════════════════════════════════

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Clean up target zones
    if Config.Performance.useOxTarget then
        -- exports['ox_target']:removeModel({'p_crate01x', 'p_crate02x'}, 'lxr_resource_interact')
    end
    
    if Config.Debug then
        print('^3[Client]^7 Resource stopped and cleaned up')
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 EXPORTS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Example exports for other resources to use
--[[
exports('IsPlayerLoaded', IsPlayerLoaded)
exports('GetPlayerData', GetPlayerData)
exports('GetLocaleText', GetLocaleText)
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 END OF CLIENT SCRIPT
-- ═══════════════════════════════════════════════════════════════════════════════
