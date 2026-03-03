--[[
    ██╗     ██╗  ██╗██████╗        ███████╗██╗  ██╗ █████╗ ███╗   ███╗██████╗ ██╗     ███████╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔════╝╚██╗██╔╝██╔══██╗████╗ ████║██╔══██╗██║     ██╔════╝
    ██║      ╚███╔╝ ██████╔╝       █████╗   ╚███╔╝ ███████║██╔████╔██║██████╔╝██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗       ██╔══╝   ██╔██╗ ██╔══██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ███████╗██╔╝ ██╗██║  ██║██║ ╚═╝ ██║██║     ███████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝

    🐺 LXR Example - Framework Bridge / Adapter

    Universal framework adapter providing a unified API across all supported
    frameworks.  Automatically detects the active framework at startup and loads
    the appropriate client or server adapter so the core gameplay logic never
    needs to call framework-specific functions directly.

    Supported Frameworks:
    - LXR Core   (Primary)
    - RSG Core   (Primary)
    - VORP Core  (Supported)
    - RedEM:RP   (Compatible)
    - QBR Core   (Compatible)
    - QR Core    (Compatible)
    - Standalone (Fallback)

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 FRAMEWORK DETECTION
-- ═══════════════════════════════════════════════════════════════════════════════

Framework        = {}
local ActiveFramework  = nil
local FrameworkObject  = nil

--- Detect which framework is running and set ActiveFramework.
function DetectFramework()
    if Config.Framework ~= 'auto' then
        ActiveFramework = Config.Framework
        print(string.format('^2[lxr-example]^7 Framework override: ^3%s^7', ActiveFramework))
        return ActiveFramework
    end

    local priority = {
        'lxr-core',
        'rsg-core',
        'vorp_core',
        'redem_roleplay',
        'qbr-core',
        'qr-core',
    }

    for _, fw in ipairs(priority) do
        if GetResourceState(fw) == 'started' then
            ActiveFramework = fw
            print(string.format('^2[lxr-example]^7 Detected framework: ^3%s^7', ActiveFramework))
            return ActiveFramework
        end
    end

    ActiveFramework = 'standalone'
    print('^3[lxr-example]^7 No framework detected — using standalone mode')
    return ActiveFramework
end

function GetActiveFramework()
    if not ActiveFramework then DetectFramework() end
    return ActiveFramework
end

function GetFrameworkSettings()
    local fw = GetActiveFramework()
    return Config.FrameworkSettings[fw] or Config.FrameworkSettings['standalone']
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CLIENT-SIDE ADAPTERS
-- ═══════════════════════════════════════════════════════════════════════════════

if IsDuplicityVersion() == 0 then

    CreateThread(function()
        local fw = DetectFramework()

        -- Obtain the framework core object
        if fw == 'lxr-core' then
            FrameworkObject = exports['lxr-core']:GetCoreObject()
        elseif fw == 'rsg-core' then
            FrameworkObject = exports['rsg-core']:GetCoreObject()
        elseif fw == 'vorp_core' then
            TriggerEvent('getCore', function(core) FrameworkObject = core end)
        elseif fw == 'qbr-core' then
            FrameworkObject = exports['qbr-core']:GetCoreObject()
        elseif fw == 'qr-core' then
            FrameworkObject = exports['qr-core']:GetCoreObject()
        end

        -- Load the matching client adapter
        if     fw == 'lxr-core'        then LoadLXRCoreClientAdapter()
        elseif fw == 'rsg-core'        then LoadRSGCoreClientAdapter()
        elseif fw == 'vorp_core'       then LoadVORPClientAdapter()
        elseif fw == 'redem_roleplay'  then LoadRedEMClientAdapter()
        elseif fw == 'qbr-core'        then LoadQBRCoreClientAdapter()
        elseif fw == 'qr-core'         then LoadQRCoreClientAdapter()
        else                                LoadStandaloneClientAdapter()
        end
    end)

    -- ─────────────────────────────────────────────────────────────────────────
    -- LXR-Core Client Adapter
    -- ─────────────────────────────────────────────────────────────────────────
    function LoadLXRCoreClientAdapter()
        function Framework.Notify(message, ntype, duration)
            exports['ox_lib']:notify({ description = message, type = ntype or 'inform', duration = duration or 5000 })
        end
        function Framework.GetPlayerData()
            return FrameworkObject.Functions.GetPlayerData()
        end
        function Framework.ProgressBar(label, duration, opts)
            return exports['ox_lib']:progressBar({
                duration = duration, label = label,
                useWhileDead = opts and opts.useWhileDead or false,
                canCancel    = opts and opts.canCancel    or true,
                disable      = opts and opts.disable or { move = true, car = true, combat = true }
            })
        end
        function Framework.TriggerCallback(name, cb, ...)
            FrameworkObject.Functions.TriggerCallback(name, cb, ...)
        end
    end

    -- ─────────────────────────────────────────────────────────────────────────
    -- RSG-Core Client Adapter
    -- ─────────────────────────────────────────────────────────────────────────
    function LoadRSGCoreClientAdapter()
        function Framework.Notify(message, ntype, duration)
            exports['ox_lib']:notify({ description = message, type = ntype or 'inform', duration = duration or 5000 })
        end
        function Framework.GetPlayerData()
            return FrameworkObject.Functions.GetPlayerData()
        end
        function Framework.ProgressBar(label, duration, opts)
            return exports['ox_lib']:progressBar({
                duration = duration, label = label,
                useWhileDead = opts and opts.useWhileDead or false,
                canCancel    = opts and opts.canCancel    or true,
                disable      = opts and opts.disable or { move = true, car = true, combat = true }
            })
        end
        function Framework.TriggerCallback(name, cb, ...)
            FrameworkObject.Functions.TriggerCallback(name, cb, ...)
        end
    end

    -- ─────────────────────────────────────────────────────────────────────────
    -- VORP Client Adapter
    -- ─────────────────────────────────────────────────────────────────────────
    function LoadVORPClientAdapter()
        function Framework.Notify(message, ntype, duration)
            FrameworkObject.NotifyLeft('wolves.land', message, 'generic_textures', 'tick', duration or 5000)
        end
        function Framework.GetPlayerData()
            return FrameworkObject.GetUser()
        end
        function Framework.ProgressBar(label, duration, opts)
            exports['vorp_progressbar']:Start({ duration = duration, label = label,
                canCancel = opts and opts.canCancel or true })
            Wait(duration)
            return true
        end
        function Framework.TriggerCallback(name, cb, ...)
            FrameworkObject.TriggerCallback(name, cb, ...)
        end
    end

    -- ─────────────────────────────────────────────────────────────────────────
    -- RedEM:RP Client Adapter
    -- ─────────────────────────────────────────────────────────────────────────
    function LoadRedEMClientAdapter()
        function Framework.Notify(message, ntype, duration)
            TriggerEvent('redem_roleplay:Tip', message, duration or 5000)
        end
        function Framework.GetPlayerData()
            return {}
        end
        function Framework.ProgressBar(label, duration, opts)
            Wait(duration)
            return true
        end
        function Framework.TriggerCallback(name, cb, ...)
            TriggerServerEvent('redem:triggerCallback', name, ...)
        end
    end

    -- ─────────────────────────────────────────────────────────────────────────
    -- QBR-Core Client Adapter
    -- ─────────────────────────────────────────────────────────────────────────
    function LoadQBRCoreClientAdapter()
        function Framework.Notify(message, ntype, duration)
            exports['ox_lib']:notify({ description = message, type = ntype or 'inform', duration = duration or 5000 })
        end
        function Framework.GetPlayerData()
            return FrameworkObject.Functions.GetPlayerData()
        end
        function Framework.ProgressBar(label, duration, opts)
            return exports['ox_lib']:progressBar({
                duration = duration, label = label,
                useWhileDead = opts and opts.useWhileDead or false,
                canCancel    = opts and opts.canCancel    or true,
                disable      = opts and opts.disable or { move = true, car = true, combat = true }
            })
        end
        function Framework.TriggerCallback(name, cb, ...)
            FrameworkObject.Functions.TriggerCallback(name, cb, ...)
        end
    end

    -- ─────────────────────────────────────────────────────────────────────────
    -- QR-Core Client Adapter
    -- ─────────────────────────────────────────────────────────────────────────
    function LoadQRCoreClientAdapter()
        function Framework.Notify(message, ntype, duration)
            exports['ox_lib']:notify({ description = message, type = ntype or 'inform', duration = duration or 5000 })
        end
        function Framework.GetPlayerData()
            return FrameworkObject.Functions.GetPlayerData()
        end
        function Framework.ProgressBar(label, duration, opts)
            return exports['ox_lib']:progressBar({
                duration = duration, label = label,
                useWhileDead = opts and opts.useWhileDead or false,
                canCancel    = opts and opts.canCancel    or true,
                disable      = opts and opts.disable or { move = true, car = true, combat = true }
            })
        end
        function Framework.TriggerCallback(name, cb, ...)
            FrameworkObject.Functions.TriggerCallback(name, cb, ...)
        end
    end

    -- ─────────────────────────────────────────────────────────────────────────
    -- Standalone Client Adapter (fallback — no framework required)
    -- ─────────────────────────────────────────────────────────────────────────
    function LoadStandaloneClientAdapter()
        function Framework.Notify(message, ntype, duration)
            BeginTextCommandThefeedPost('STRING')
            AddTextComponentSubstringPlayerName(message)
            EndTextCommandThefeedPostTicker(false, true)
        end
        function Framework.GetPlayerData()
            return { citizenid = GetPlayerServerId(PlayerId()) }
        end
        function Framework.ProgressBar(label, duration, opts)
            Wait(duration)
            return true
        end
        function Framework.TriggerCallback(name, cb, ...)
            TriggerServerEvent('lxr-example:callback:trigger', name, ...)
        end
    end

end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SERVER-SIDE ADAPTERS
-- ═══════════════════════════════════════════════════════════════════════════════

if IsDuplicityVersion() == 1 then

    CreateThread(function()
        local fw = DetectFramework()

        if fw == 'lxr-core' then
            FrameworkObject = exports['lxr-core']:GetCoreObject()
        elseif fw == 'rsg-core' then
            FrameworkObject = exports['rsg-core']:GetCoreObject()
        elseif fw == 'vorp_core' then
            TriggerEvent('getCore', function(core) FrameworkObject = core end)
        elseif fw == 'qbr-core' then
            FrameworkObject = exports['qbr-core']:GetCoreObject()
        elseif fw == 'qr-core' then
            FrameworkObject = exports['qr-core']:GetCoreObject()
        end

        if     fw == 'lxr-core'        then LoadLXRCoreServerAdapter()
        elseif fw == 'rsg-core'        then LoadRSGCoreServerAdapter()
        elseif fw == 'vorp_core'       then LoadVORPServerAdapter()
        elseif fw == 'redem_roleplay'  then LoadRedEMServerAdapter()
        elseif fw == 'qbr-core'        then LoadQBRCoreServerAdapter()
        elseif fw == 'qr-core'         then LoadQRCoreServerAdapter()
        else                                LoadStandaloneServerAdapter()
        end
    end)

    -- ─────────────────────────────────────────────────────────────────────────
    -- Helper: build a unified player-operation wrapper
    -- ─────────────────────────────────────────────────────────────────────────
    local function BuildLXRRSGAdapter(getFn)
        function Framework.Notify(source, message, ntype, duration)
            TriggerClientEvent('ox_lib:notify', source, { description = message, type = ntype or 'inform', duration = duration or 5000 })
        end
        function Framework.GetPlayerData(source)   return getFn(source) end
        function Framework.GetIdentifier(source)
            local p = getFn(source)
            return p and p.PlayerData and p.PlayerData.citizenid or nil
        end
        function Framework.AddMoney(source, account, amount)
            local p = getFn(source)
            return p and p.Functions.AddMoney(account, amount) and true or false
        end
        function Framework.RemoveMoney(source, account, amount)
            local p = getFn(source)
            return p and p.Functions.RemoveMoney(account, amount) or false
        end
        function Framework.GetMoney(source, account)
            local p = getFn(source)
            return p and p.PlayerData.money and p.PlayerData.money[account] or 0
        end
        function Framework.AddItem(source, item, amount, meta)
            local p = getFn(source)
            return p and p.Functions.AddItem(item, amount, false, meta) or false
        end
        function Framework.RemoveItem(source, item, amount, meta)
            local p = getFn(source)
            return p and p.Functions.RemoveItem(item, amount, false, meta) or false
        end
        function Framework.HasItem(source, item, amount)
            local p = getFn(source)
            if not p then return false end
            local i = p.Functions.GetItemByName(item)
            return i and i.amount >= (amount or 1) or false
        end
        function Framework.RegisterCallback(name, cb)
            FrameworkObject.Functions.CreateCallback(name, cb)
        end
    end

    -- ─────────────────────────────────────────────────────────────────────────
    -- LXR-Core Server Adapter
    -- ─────────────────────────────────────────────────────────────────────────
    function LoadLXRCoreServerAdapter()
        BuildLXRRSGAdapter(function(src)
            return FrameworkObject.Functions.GetPlayer(src)
        end)
    end

    -- ─────────────────────────────────────────────────────────────────────────
    -- RSG-Core Server Adapter
    -- ─────────────────────────────────────────────────────────────────────────
    function LoadRSGCoreServerAdapter()
        BuildLXRRSGAdapter(function(src)
            return FrameworkObject.Functions.GetPlayer(src)
        end)
    end

    -- ─────────────────────────────────────────────────────────────────────────
    -- VORP Server Adapter
    -- ─────────────────────────────────────────────────────────────────────────
    function LoadVORPServerAdapter()
        function Framework.Notify(source, message, ntype, duration)
            TriggerClientEvent('vorp:TipRight', source, message, duration or 5000)
        end
        function Framework.GetPlayerData(source)
            return FrameworkObject.GetUser(source)
        end
        function Framework.GetIdentifier(source)
            local user = FrameworkObject.GetUser(source)
            return user and user.getIdentifier() or nil
        end
        function Framework.AddMoney(source, account, amount)
            local user = FrameworkObject.GetUser(source)
            if user then user.addCurrency(0, amount) return true end
            return false
        end
        function Framework.RemoveMoney(source, account, amount)
            local user = FrameworkObject.GetUser(source)
            if user then user.removeCurrency(0, amount) return true end
            return false
        end
        function Framework.GetMoney(source, account)
            local user = FrameworkObject.GetUser(source)
            return user and user.getMoney() or 0
        end
        function Framework.AddItem(source, item, amount, meta)
            exports['vorp_inventory']:addItem(source, item, amount)
            return true
        end
        function Framework.RemoveItem(source, item, amount, meta)
            exports['vorp_inventory']:subItem(source, item, amount)
            return true
        end
        function Framework.HasItem(source, item, amount)
            local count = exports['vorp_inventory']:getItemCount(source, item)
            return count >= (amount or 1)
        end
        function Framework.RegisterCallback(name, cb)
            FrameworkObject.RegisterCallback(name, cb)
        end
    end

    -- ─────────────────────────────────────────────────────────────────────────
    -- RedEM:RP Server Adapter
    -- ─────────────────────────────────────────────────────────────────────────
    function LoadRedEMServerAdapter()
        function Framework.Notify(source, message, ntype, duration)
            TriggerClientEvent('redem_roleplay:Tip', source, message, duration or 5000)
        end
        function Framework.GetPlayerData(source)   return {} end
        function Framework.GetIdentifier(source)   return GetPlayerIdentifiers(source)[1] end
        function Framework.AddMoney(source, account, amount)    return true end
        function Framework.RemoveMoney(source, account, amount) return true end
        function Framework.GetMoney(source, account)            return 0 end
        function Framework.AddItem(source, item, amount, meta)
            TriggerEvent('redem_roleplay:addItem', source, item, amount)
            return true
        end
        function Framework.RemoveItem(source, item, amount, meta)
            TriggerEvent('redem_roleplay:removeItem', source, item, amount)
            return true
        end
        function Framework.HasItem(source, item, amount)  return false end
        function Framework.RegisterCallback(name, cb)
            TriggerEvent('redem:registerCallback', name, cb)
        end
    end

    -- ─────────────────────────────────────────────────────────────────────────
    -- QBR-Core Server Adapter
    -- ─────────────────────────────────────────────────────────────────────────
    function LoadQBRCoreServerAdapter()
        BuildLXRRSGAdapter(function(src)
            return FrameworkObject.Functions.GetPlayer(src)
        end)
    end

    -- ─────────────────────────────────────────────────────────────────────────
    -- QR-Core Server Adapter
    -- ─────────────────────────────────────────────────────────────────────────
    function LoadQRCoreServerAdapter()
        BuildLXRRSGAdapter(function(src)
            return FrameworkObject.Functions.GetPlayer(src)
        end)
    end

    -- ─────────────────────────────────────────────────────────────────────────
    -- Standalone Server Adapter (fallback — no framework required)
    -- ─────────────────────────────────────────────────────────────────────────
    function LoadStandaloneServerAdapter()
        function Framework.Notify(source, message, ntype, duration)
            TriggerClientEvent('chat:addMessage', source, { args = { '[' .. (ntype or 'info'):upper() .. ']', message } })
        end
        function Framework.GetPlayerData(source)   return { citizenid = GetPlayerIdentifiers(source)[1] } end
        function Framework.GetIdentifier(source)   return GetPlayerIdentifiers(source)[1] end
        function Framework.AddMoney(source, account, amount)    return false end
        function Framework.RemoveMoney(source, account, amount) return false end
        function Framework.GetMoney(source, account)            return 0 end
        function Framework.AddItem(source, item, amount, meta)  return false end
        function Framework.RemoveItem(source, item, amount, meta) return false end
        function Framework.HasItem(source, item, amount)        return false end
        function Framework.RegisterCallback(name, cb)
            RegisterNetEvent('lxr-example:callback:trigger')
            AddEventHandler('lxr-example:callback:trigger', function(cbName, ...)
                if cbName == name then cb(source, function(...)
                    TriggerClientEvent('lxr-example:callback:response:' .. name, source, ...)
                end, ...) end
            end)
        end
    end

end

-- ═══════════════════════════════════════════════════════════════════════════════
-- END OF FRAMEWORK BRIDGE
-- ═══════════════════════════════════════════════════════════════════════════════
