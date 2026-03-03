--[[
    ██╗     ██╗  ██╗██████╗        ███████╗██╗  ██╗ █████╗ ███╗   ███╗██████╗ ██╗     ███████╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔════╝╚██╗██╔╝██╔══██╗████╗ ████║██╔══██╗██║     ██╔════╝
    ██║      ╚███╔╝ ██████╔╝       █████╗   ╚███╔╝ ███████║██╔████╔██║██████╔╝██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗       ██╔══╝   ██╔██╗ ██╔══██║██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ███████╗██╔╝ ██╗██║  ██║██║ ╚═╝ ██║██║     ███████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝
    
    🐺 LXR Example - FXManifest
    
    Manifest file for the LXR Example resource — a complete demonstration of
    wolves.land production-grade RedM resource standards.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CORE MANIFEST METADATA
-- ═══════════════════════════════════════════════════════════════════════════════

fx_version 'cerulean'
game       'rdr3'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources WILL become incompatible once RedM ships.'

name        'lxr-example'
author      'iBoss21 / The Lux Empire'
description 'Production-grade example RedM resource demonstrating wolves.land standards with full multi-framework support'
version     '1.0.0'
repository  'https://github.com/iBoss21/lxr-example'

lua54 'yes'

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SHARED FILES
-- ═══════════════════════════════════════════════════════════════════════════════

-- Files loaded on both client and server
-- Establishes shared configuration and framework detection before any logic runs

shared_scripts {
    -- Core configuration (buyer-configurable, not obfuscated)
    'config.lua',
    
    -- Framework detection and unified adapter bridge
    'shared/framework-bridge.lua',
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CLIENT FILES
-- ═══════════════════════════════════════════════════════════════════════════════

-- Client-side scripts handle:
-- - Player interactions and keybinds
-- - UI rendering and NUI communication
-- - Local state management
-- - Target system integration (ox_target)
-- - Visual feedback and animations

client_scripts {
    'client/main.lua',
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SERVER FILES
-- ═══════════════════════════════════════════════════════════════════════════════

-- Server-side scripts handle:
-- - Security validation (NEVER trust client data)
-- - Economy transactions via framework adapter
-- - Inventory management
-- - Cooldown and rate-limit enforcement
-- - Suspicious activity logging

server_scripts {
    'server/main.lua',
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 DEPENDENCIES
-- ═══════════════════════════════════════════════════════════════════════════════

--[[
    IMPORTANT: Do NOT hard-require framework resources because this resource
    supports multiple frameworks via auto-detection.
    
    Only list truly required dependencies that MUST be present.
    Frameworks (lxr-core, rsg-core, vorp_core, etc.) are NOT listed here —
    they are auto-detected at runtime.
]]

dependencies {
    -- Add only truly required non-framework dependencies here
    -- 'ox_lib',    -- Uncomment if using ox_lib notifications / progress bars
    -- 'oxmysql',  -- Uncomment if using MySQL database
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- END OF MANIFEST
-- ═══════════════════════════════════════════════════════════════════════════════
