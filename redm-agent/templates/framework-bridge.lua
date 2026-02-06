--[[
    ██╗     ██╗  ██╗██████╗        ███████╗██████╗  █████╗ ███╗   ███╗███████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
    ██║      ╚███╔╝ ██████╔╝       █████╗  ██████╔╝███████║██╔████╔██║█████╗  ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ 
    ██║      ██╔██╗ ██╔══██╗       ██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║   ██║██╔══██╗██╔═██╗ 
    ███████╗██╔╝ ██╗██║  ██║       ██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
    
    🐺 LXR Resource - Framework Bridge/Adapter
    
    Universal framework adapter providing a unified API across all supported frameworks.
    Automatically detects the active framework and loads the appropriate adapter.
    
    Supported Frameworks:
    - LXR Core (Primary)
    - RSG Core (Primary)
    - VORP Core (Supported)
    - RedEM:RP (Compatible)
    - QBR Core (Compatible)
    - QR Core (Compatible)
    - Standalone (Fallback)
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 FRAMEWORK DETECTION
-- ═══════════════════════════════════════════════════════════════════════════════

Framework = {}
local ActiveFramework = nil
local FrameworkObject = nil

-- Detect which framework is running
function DetectFramework()
    if Config.Framework ~= 'auto' then
        ActiveFramework = Config.Framework
        print(string.format('^2[Framework Bridge]^7 Manual override: %s', ActiveFramework))
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
            print(string.format('^2[Framework Bridge]^7 Detected: %s', ActiveFramework))
            return ActiveFramework
        end
    end
    
    -- Fallback to standalone
    ActiveFramework = 'standalone'
    print('^3[Framework Bridge]^7 No framework detected, using standalone mode')
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

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CLIENT-SIDE ADAPTER
-- ═══════════════════════════════════════════════════════════════════════════════

if IsDuplicityVersion() == 0 then -- Client-side only

    CreateThread(function()
        local fw = DetectFramework()
        
        -- Load appropriate framework object
        if fw == 'lxr-core' then
            FrameworkObject = exports['lxr-core']:GetCoreObject()
        elseif fw == 'rsg-core' then
            FrameworkObject = exports['rsg-core']:GetCoreObject()
        elseif fw == 'vorp_core' then
            FrameworkObject = {}
            TriggerEvent('getCore', function(core) FrameworkObject = core end)
        elseif fw == 'qbr-core' then
            FrameworkObject = exports['qbr-core']:GetCoreObject()
        elseif fw == 'qr-core' then
            FrameworkObject = exports['qr-core']:GetCoreObject()
        end
        
        -- Initialize adapters
        if fw == 'lxr-core' then
            LoadLXRCoreClientAdapter()
        elseif fw == 'rsg-core' then
            LoadRSGCoreClientAdapter()
        elseif fw == 'vorp_core' then
            LoadVORPClientAdapter()
        elseif fw == 'redem_roleplay' then
            LoadRedEMClientAdapter()
        elseif fw == 'qbr-core' then
            LoadQBRCoreClientAdapter()
        elseif fw == 'qr-core' then
            LoadQRCoreClientAdapter()
        else
            LoadStandaloneClientAdapter()
        end
    end)
    
    -- ═══════════════════════════════════════════════════════════════════════════════
    -- 🐺 LXR-CORE CLIENT ADAPTER
    -- ═══════════════════════════════════════════════════════════════════════════════
    
    function LoadLXRCoreClientAdapter()
        function Framework.Notify(message, type, duration)
            exports['ox_lib']:notify({
                description = message,
                type = type or 'inform',
                duration = duration or 5000
            })
        end
        
        function Framework.GetPlayerData()
            return FrameworkObject.Functions.GetPlayerData()
        end
        
        function Framework.ProgressBar(label, duration, options)
            return exports['ox_lib']:progressBar({
                duration = duration,
                label = label,
                useWhileDead = options and options.useWhileDead or false,
                canCancel = options and options.canCancel or true,
                disable = options and options.disable or { move = true, car = true, combat = true }
            })
        end
        
        function Framework.TriggerCallback(name, callback, ...)
            FrameworkObject.Functions.TriggerCallback(name, callback, ...)
        end
    end
    
    -- ═══════════════════════════════════════════════════════════════════════════════
    -- 🐺 RSG-CORE CLIENT ADAPTER
    -- ═══════════════════════════════════════════════════════════════════════════════
    
    function LoadRSGCoreClientAdapter()
        function Framework.Notify(message, type, duration)
            exports['ox_lib']:notify({
                description = message,
                type = type or 'inform',
                duration = duration or 5000
            })
        end
        
        function Framework.GetPlayerData()
            return FrameworkObject.Functions.GetPlayerData()
        end
        
        function Framework.ProgressBar(label, duration, options)
            return exports['ox_lib']:progressBar({
                duration = duration,
                label = label,
                useWhileDead = options and options.useWhileDead or false,
                canCancel = options and options.canCancel or true,
                disable = options and options.disable or { move = true, car = true, combat = true }
            })
        end
        
        function Framework.TriggerCallback(name, callback, ...)
            FrameworkObject.Functions.TriggerCallback(name, callback, ...)
        end
    end
    
    -- ═══════════════════════════════════════════════════════════════════════════════
    -- 🐺 VORP CLIENT ADAPTER
    -- ═══════════════════════════════════════════════════════════════════════════════
    
    function LoadVORPClientAdapter()
        function Framework.Notify(message, type, duration)
            FrameworkObject.NotifyLeft('wolves.land', message, 'generic_textures', 'tick', duration or 5000)
        end
        
        function Framework.GetPlayerData()
            return FrameworkObject.GetUser()
        end
        
        function Framework.ProgressBar(label, duration, options)
            exports['vorp_progressbar']:Start({
                duration = duration,
                label = label,
                canCancel = options and options.canCancel or true
            })
            Wait(duration)
            return true
        end
        
        function Framework.TriggerCallback(name, callback, ...)
            FrameworkObject.TriggerCallback(name, callback, ...)
        end
    end
    
    -- ═══════════════════════════════════════════════════════════════════════════════
    -- 🐺 REDEM CLIENT ADAPTER
    -- ═══════════════════════════════════════════════════════════════════════════════
    
    function LoadRedEMClientAdapter()
        function Framework.Notify(message, type, duration)
            TriggerEvent('redem_roleplay:Tip', message, duration or 5000)
        end
        
        function Framework.GetPlayerData()
            return {} -- RedEM handles player data differently
        end
        
        function Framework.ProgressBar(label, duration, options)
            Wait(duration)
            return true
        end
        
        function Framework.TriggerCallback(name, callback, ...)
            TriggerServerEvent('redem:triggerCallback', name, callback, ...)
        end
    end
    
    -- ═══════════════════════════════════════════════════════════════════════════════
    -- 🐺 QBR-CORE CLIENT ADAPTER
    -- ═══════════════════════════════════════════════════════════════════════════════
    
    function LoadQBRCoreClientAdapter()
        function Framework.Notify(message, type, duration)
            exports['ox_lib']:notify({
                description = message,
                type = type or 'inform',
                duration = duration or 5000
            })
        end
        
        function Framework.GetPlayerData()
            return FrameworkObject.Functions.GetPlayerData()
        end
        
        function Framework.ProgressBar(label, duration, options)
            return exports['ox_lib']:progressBar({
                duration = duration,
                label = label,
                useWhileDead = options and options.useWhileDead or false,
                canCancel = options and options.canCancel or true,
                disable = options and options.disable or { move = true, car = true, combat = true }
            })
        end
        
        function Framework.TriggerCallback(name, callback, ...)
            FrameworkObject.Functions.TriggerCallback(name, callback, ...)
        end
    end
    
    -- ═══════════════════════════════════════════════════════════════════════════════
    -- 🐺 QR-CORE CLIENT ADAPTER
    -- ═══════════════════════════════════════════════════════════════════════════════
    
    function LoadQRCoreClientAdapter()
        function Framework.Notify(message, type, duration)
            exports['ox_lib']:notify({
                description = message,
                type = type or 'inform',
                duration = duration or 5000
            })
        end
        
        function Framework.GetPlayerData()
            return FrameworkObject.Functions.GetPlayerData()
        end
        
        function Framework.ProgressBar(label, duration, options)
            return exports['ox_lib']:progressBar({
                duration = duration,
                label = label,
                useWhileDead = options and options.useWhileDead or false,
                canCancel = options and options.canCancel or true,
                disable = options and options.disable or { move = true, car = true, combat = true }
            })
        end
        
        function Framework.TriggerCallback(name, callback, ...)
            FrameworkObject.Functions.TriggerCallback(name, callback, ...)
        end
    end
    
    -- ═══════════════════════════════════════════════════════════════════════════════
    -- 🐺 STANDALONE CLIENT ADAPTER
    -- ═══════════════════════════════════════════════════════════════════════════════
    
    function LoadStandaloneClientAdapter()
        function Framework.Notify(message, type, duration)
            print(string.format('[NOTIFY] %s: %s', type or 'info', message))
            -- Basic in-game text notification
            BeginTextCommandThefeedPost('STRING')
            AddTextComponentSubstringPlayerName(message)
            EndTextCommandThefeedPostTicker(false, true)
        end
        
        function Framework.GetPlayerData()
            return { citizenid = GetPlayerServerId(PlayerId()) }
        end
        
        function Framework.ProgressBar(label, duration, options)
            print(string.format('[PROGRESS] %s - %dms', label, duration))
            Wait(duration)
            return true
        end
        
        function Framework.TriggerCallback(name, callback, ...)
            TriggerServerEvent('lxr-resource:callback:trigger', name, ...)
        end
    end

end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SERVER-SIDE ADAPTER
-- ═══════════════════════════════════════════════════════════════════════════════

if IsDuplicityVersion() == 1 then -- Server-side only

    CreateThread(function()
        local fw = DetectFramework()
        
        -- Load appropriate framework object
        if fw == 'lxr-core' then
            FrameworkObject = exports['lxr-core']:GetCoreObject()
        elseif fw == 'rsg-core' then
            FrameworkObject = exports['rsg-core']:GetCoreObject()
        elseif fw == 'vorp_core' then
            FrameworkObject = {}
            TriggerEvent('getCore', function(core) FrameworkObject = core end)
        elseif fw == 'qbr-core' then
            FrameworkObject = exports['qbr-core']:GetCoreObject()
        elseif fw == 'qr-core' then
            FrameworkObject = exports['qr-core']:GetCoreObject()
        end
        
        -- Initialize adapters
        if fw == 'lxr-core' then
            LoadLXRCoreServerAdapter()
        elseif fw == 'rsg-core' then
            LoadRSGCoreServerAdapter()
        elseif fw == 'vorp_core' then
            LoadVORPServerAdapter()
        elseif fw == 'redem_roleplay' then
            LoadRedEMServerAdapter()
        elseif fw == 'qbr-core' then
            LoadQBRCoreServerAdapter()
        elseif fw == 'qr-core' then
            LoadQRCoreServerAdapter()
        else
            LoadStandaloneServerAdapter()
        end
    end)
    
    -- ═══════════════════════════════════════════════════════════════════════════════
    -- 🐺 LXR-CORE SERVER ADAPTER
    -- ═══════════════════════════════════════════════════════════════════════════════
    
    function LoadLXRCoreServerAdapter()
        function Framework.Notify(source, message, type, duration)
            TriggerClientEvent('ox_lib:notify', source, {
                description = message,
                type = type or 'inform',
                duration = duration or 5000
            })
        end
        
        function Framework.GetPlayerData(source)
            return FrameworkObject.Functions.GetPlayer(source)
        end
        
        function Framework.GetIdentifier(source)
            local Player = FrameworkObject.Functions.GetPlayer(source)
            return Player and Player.PlayerData.citizenid or nil
        end
        
        function Framework.AddMoney(source, account, amount)
            local Player = FrameworkObject.Functions.GetPlayer(source)
            if Player then
                Player.Functions.AddMoney(account, amount)
                return true
            end
            return false
        end
        
        function Framework.RemoveMoney(source, account, amount)
            local Player = FrameworkObject.Functions.GetPlayer(source)
            if Player then
                return Player.Functions.RemoveMoney(account, amount)
            end
            return false
        end
        
        function Framework.GetMoney(source, account)
            local Player = FrameworkObject.Functions.GetPlayer(source)
            if Player then
                return Player.Functions.GetMoney(account)
            end
            return 0
        end
        
        function Framework.AddItem(source, item, amount, metadata)
            local Player = FrameworkObject.Functions.GetPlayer(source)
            if Player then
                return Player.Functions.AddItem(item, amount, false, metadata)
            end
            return false
        end
        
        function Framework.RemoveItem(source, item, amount, metadata)
            local Player = FrameworkObject.Functions.GetPlayer(source)
            if Player then
                return Player.Functions.RemoveItem(item, amount, false, metadata)
            end
            return false
        end
        
        function Framework.HasItem(source, item, amount)
            local Player = FrameworkObject.Functions.GetPlayer(source)
            if Player then
                local itemData = Player.Functions.GetItemByName(item)
                return itemData and itemData.amount >= (amount or 1)
            end
            return false
        end
        
        function Framework.RegisterCallback(name, callback)
            FrameworkObject.Functions.CreateCallback(name, callback)
        end
    end
    
    -- ═══════════════════════════════════════════════════════════════════════════════
    -- 🐺 RSG-CORE SERVER ADAPTER
    -- ═══════════════════════════════════════════════════════════════════════════════
    
    function LoadRSGCoreServerAdapter()
        function Framework.Notify(source, message, type, duration)
            TriggerClientEvent('ox_lib:notify', source, {
                description = message,
                type = type or 'inform',
                duration = duration or 5000
            })
        end
        
        function Framework.GetPlayerData(source)
            return FrameworkObject.Functions.GetPlayer(source)
        end
        
        function Framework.GetIdentifier(source)
            local Player = FrameworkObject.Functions.GetPlayer(source)
            return Player and Player.PlayerData.citizenid or nil
        end
        
        function Framework.AddMoney(source, account, amount)
            local Player = FrameworkObject.Functions.GetPlayer(source)
            if Player then
                Player.Functions.AddMoney(account, amount)
                return true
            end
            return false
        end
        
        function Framework.RemoveMoney(source, account, amount)
            local Player = FrameworkObject.Functions.GetPlayer(source)
            if Player then
                return Player.Functions.RemoveMoney(account, amount)
            end
            return false
        end
        
        function Framework.GetMoney(source, account)
            local Player = FrameworkObject.Functions.GetPlayer(source)
            if Player then
                return Player.PlayerData.money[account] or 0
            end
            return 0
        end
        
        function Framework.AddItem(source, item, amount, metadata)
            local Player = FrameworkObject.Functions.GetPlayer(source)
            if Player then
                return Player.Functions.AddItem(item, amount, false, metadata)
            end
            return false
        end
        
        function Framework.RemoveItem(source, item, amount, metadata)
            local Player = FrameworkObject.Functions.GetPlayer(source)
            if Player then
                return Player.Functions.RemoveItem(item, amount, false, metadata)
            end
            return false
        end
        
        function Framework.HasItem(source, item, amount)
            local Player = FrameworkObject.Functions.GetPlayer(source)
            if Player then
                local itemData = Player.Functions.GetItemByName(item)
                return itemData and itemData.amount >= (amount or 1)
            end
            return false
        end
        
        function Framework.RegisterCallback(name, callback)
            FrameworkObject.Functions.CreateCallback(name, callback)
        end
    end
    
    -- ═══════════════════════════════════════════════════════════════════════════════
    -- 🐺 VORP SERVER ADAPTER
    -- ═══════════════════════════════════════════════════════════════════════════════
    
    function LoadVORPServerAdapter()
        function Framework.Notify(source, message, type, duration)
            TriggerClientEvent('vorp:TipRight', source, message, duration or 5000)
        end
        
        function Framework.GetPlayerData(source)
            return FrameworkObject.getUser(source)
        end
        
        function Framework.GetIdentifier(source)
            local User = FrameworkObject.getUser(source)
            return User and User.getIdentifier() or nil
        end
        
        function Framework.AddMoney(source, account, amount)
            local User = FrameworkObject.getUser(source)
            if User then
                if account == 'cash' then
                    User.addCurrency(0, amount)
                elseif account == 'gold' then
                    User.addCurrency(1, amount)
                end
                return true
            end
            return false
        end
        
        function Framework.RemoveMoney(source, account, amount)
            local User = FrameworkObject.getUser(source)
            if User then
                if account == 'cash' then
                    return User.removeCurrency(0, amount)
                elseif account == 'gold' then
                    return User.removeCurrency(1, amount)
                end
            end
            return false
        end
        
        function Framework.GetMoney(source, account)
            local User = FrameworkObject.getUser(source)
            if User then
                if account == 'cash' then
                    return User.getMoney()
                elseif account == 'gold' then
                    return User.getGold()
                end
            end
            return 0
        end
        
        function Framework.AddItem(source, item, amount, metadata)
            exports['vorp_inventory']:addItem(source, item, amount, metadata)
            return true
        end
        
        function Framework.RemoveItem(source, item, amount, metadata)
            exports['vorp_inventory']:subItem(source, item, amount, metadata)
            return true
        end
        
        function Framework.HasItem(source, item, amount)
            local itemCount = exports['vorp_inventory']:getItemCount(source, nil, item)
            return itemCount >= (amount or 1)
        end
        
        function Framework.RegisterCallback(name, callback)
            FrameworkObject.RegisterCallback(name, callback)
        end
    end
    
    -- ═══════════════════════════════════════════════════════════════════════════════
    -- 🐺 REDEM SERVER ADAPTER
    -- ═══════════════════════════════════════════════════════════════════════════════
    
    function LoadRedEMServerAdapter()
        function Framework.Notify(source, message, type, duration)
            TriggerClientEvent('redem_roleplay:Tip', source, message, duration or 5000)
        end
        
        function Framework.GetPlayerData(source)
            return {} -- RedEM handles differently
        end
        
        function Framework.GetIdentifier(source)
            return GetPlayerIdentifier(source, 0)
        end
        
        function Framework.AddMoney(source, account, amount)
            TriggerEvent('redemrp:addMoney', source, amount)
            return true
        end
        
        function Framework.RemoveMoney(source, account, amount)
            TriggerEvent('redemrp:removeMoney', source, amount)
            return true
        end
        
        function Framework.GetMoney(source, account)
            return 0 -- Would need to get from RedEM player data
        end
        
        function Framework.AddItem(source, item, amount, metadata)
            TriggerEvent('redemrp_inventory:AddItem', source, item, amount)
            return true
        end
        
        function Framework.RemoveItem(source, item, amount, metadata)
            TriggerEvent('redemrp_inventory:RemoveItem', source, item, amount)
            return true
        end
        
        function Framework.HasItem(source, item, amount)
            return false -- Would need to check RedEM inventory
        end
        
        function Framework.RegisterCallback(name, callback)
            RegisterServerEvent('redem:triggerCallback:' .. name)
            AddEventHandler('redem:triggerCallback:' .. name, callback)
        end
    end
    
    -- ═══════════════════════════════════════════════════════════════════════════════
    -- 🐺 QBR-CORE SERVER ADAPTER
    -- ═══════════════════════════════════════════════════════════════════════════════
    
    function LoadQBRCoreServerAdapter()
        -- QBR-Core follows same structure as LXR-Core/RSG-Core
        LoadLXRCoreServerAdapter() -- Reuse LXR adapter
    end
    
    -- ═══════════════════════════════════════════════════════════════════════════════
    -- 🐺 QR-CORE SERVER ADAPTER
    -- ═══════════════════════════════════════════════════════════════════════════════
    
    function LoadQRCoreServerAdapter()
        -- QR-Core follows same structure as LXR-Core/RSG-Core
        LoadLXRCoreServerAdapter() -- Reuse LXR adapter
    end
    
    -- ═══════════════════════════════════════════════════════════════════════════════
    -- 🐺 STANDALONE SERVER ADAPTER
    -- ═══════════════════════════════════════════════════════════════════════════════
    
    function LoadStandaloneServerAdapter()
        local PlayerData = {}
        
        function Framework.Notify(source, message, type, duration)
            TriggerClientEvent('chat:addMessage', source, {
                args = { '[Server]', message }
            })
        end
        
        function Framework.GetPlayerData(source)
            return PlayerData[source] or {}
        end
        
        function Framework.GetIdentifier(source)
            return GetPlayerIdentifier(source, 0)
        end
        
        function Framework.AddMoney(source, account, amount)
            if not PlayerData[source] then PlayerData[source] = { money = {} } end
            if not PlayerData[source].money then PlayerData[source].money = {} end
            PlayerData[source].money[account] = (PlayerData[source].money[account] or 0) + amount
            return true
        end
        
        function Framework.RemoveMoney(source, account, amount)
            if not PlayerData[source] or not PlayerData[source].money then return false end
            local current = PlayerData[source].money[account] or 0
            if current >= amount then
                PlayerData[source].money[account] = current - amount
                return true
            end
            return false
        end
        
        function Framework.GetMoney(source, account)
            if not PlayerData[source] or not PlayerData[source].money then return 0 end
            return PlayerData[source].money[account] or 0
        end
        
        function Framework.AddItem(source, item, amount, metadata)
            print(string.format('[Standalone] AddItem: %s x%d to player %s', item, amount, source))
            return true
        end
        
        function Framework.RemoveItem(source, item, amount, metadata)
            print(string.format('[Standalone] RemoveItem: %s x%d from player %s', item, amount, source))
            return true
        end
        
        function Framework.HasItem(source, item, amount)
            return true -- Standalone mode always returns true
        end
        
        function Framework.RegisterCallback(name, callback)
            RegisterServerEvent('lxr-resource:callback:trigger:' .. name)
            AddEventHandler('lxr-resource:callback:trigger:' .. name, function(...)
                local src = source
                callback(src, ...)
            end)
        end
    end

end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 END OF FRAMEWORK BRIDGE
-- ═══════════════════════════════════════════════════════════════════════════════
