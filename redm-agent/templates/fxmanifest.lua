--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ███████╗███████╗ ██████╗ ██╗   ██╗██████╗  ██████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔════╝██╔════╝██╔═══██╗██║   ██║██╔══██╗██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗ ██████╔╝█████╗  ███████╗██║   ██║██║   ██║██████╔╝██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝ ██╔══██╗██╔══╝  ╚════██║██║   ██║██║   ██║██╔══██╗██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ██║  ██║███████╗███████║╚██████╔╝╚██████╔╝██║  ██║╚██████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝
    
    🐺 LXR Resource - FXManifest
    
    Manifest file defining resource metadata, dependencies, and load order
    for the LXR Resource system.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CORE MANIFEST METADATA
-- ═══════════════════════════════════════════════════════════════════════════════

fx_version 'cerulean'
game 'rdr3'
lua54 'yes'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources WILL become incompatible once RedM ships.'

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE INFORMATION
-- ═══════════════════════════════════════════════════════════════════════════════

name 'LXR Resource'
author 'iBoss21 / The Lux Empire'
description 'Production-ready RedM resource template with multi-framework support'
version '1.0.0'
repository 'https://github.com/iBoss21/[repo-name]'

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SHARED FILES
-- ═══════════════════════════════════════════════════════════════════════════════

-- Files loaded on both client and server
-- These run first and establish shared configuration and framework detection

shared_scripts {
    -- Core configuration
    'config.lua',
    
    -- Framework detection and adapter bridge
    'shared/framework-bridge.lua',
    
    -- Add more shared files as needed
    -- 'shared/utils.lua',
    -- 'shared/locale.lua',
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CLIENT FILES
-- ═══════════════════════════════════════════════════════════════════════════════

-- Client-side scripts handle:
-- - Player interactions
-- - UI rendering and NUI communication
-- - Local state management
-- - Visual effects and animations
-- - Target system integration

client_scripts {
    'client/main.lua',
    
    -- Add more client files as needed
    -- 'client/ui.lua',
    -- 'client/interactions.lua',
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SERVER FILES
-- ═══════════════════════════════════════════════════════════════════════════════

-- Server-side scripts handle:
-- - Security validation
-- - Database operations
-- - Economy transactions
-- - Inventory management
-- - Callback registration

server_scripts {
    -- Uncomment if using MySQL
    -- '@oxmysql/lib/MySQL.lua',
    
    'server/main.lua',
    
    -- Add more server files as needed
    -- 'server/database.lua',
    -- 'server/callbacks.lua',
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 UI FILES (if applicable)
-- ═══════════════════════════════════════════════════════════════════════════════

-- Uncomment if your resource has a UI/NUI

-- ui_page 'html/index.html'

-- files {
--     'html/index.html',
--     'html/style.css',
--     'html/script.js',
--     'html/images/*.png',
-- }

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 DEPENDENCIES
-- ═══════════════════════════════════════════════════════════════════════════════

--[[
    IMPORTANT: Do NOT hard-require all frameworks because multi-framework support exists.
    Only list truly required dependencies that MUST be present for the resource to function.
    
    Example dependencies:
    - ox_lib (if using ox_lib notifications, progress bars, etc.)
    - oxmysql (if using database functionality)
    
    Do NOT add:
    - lxr-core, rsg-core, vorp_core, etc. (these are auto-detected)
]]

dependencies {
    -- Add only required dependencies here
    -- 'ox_lib',
    -- 'oxmysql',
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 EXPORTS (if applicable)
-- ═══════════════════════════════════════════════════════════════════════════════

--[[
    Exports allow other resources to call functions from this resource.
    Client exports are called from client-side, server exports from server-side.
]]

-- Client-side exports
exports {
    -- Example: 'GetResourceStatus',
}

-- Server-side exports
server_exports {
    -- Example: 'GetPlayerData',
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- END OF MANIFEST
-- ═══════════════════════════════════════════════════════════════════════════════
