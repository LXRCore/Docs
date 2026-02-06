# 🐺 FXManifest Standards

```
██╗     ██╗  ██╗██████╗         ███╗   ███╗ █████╗ ███╗   ██╗██╗███████╗███████╗███████╗████████╗
██║     ╚██╗██╔╝██╔══██╗        ████╗ ████║██╔══██╗████╗  ██║██║██╔════╝██╔════╝██╔════╝╚══██╔══╝
██║      ╚███╔╝ ██████╔╝        ██╔████╔██║███████║██╔██╗ ██║██║█████╗  █████╗  ███████╗   ██║   
██║      ██╔██╗ ██╔══██╗        ██║╚██╔╝██║██╔══██║██║╚██╗██║██║██╔══╝  ██╔══╝  ╚════██║   ██║   
███████╗██╔╝ ██╗██║  ██║        ██║ ╚═╝ ██║██║  ██║██║ ╚████║██║██║     ███████╗███████║   ██║   
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝     ╚══════╝╚══════╝   ╚═╝   
```

**Standard**: FXManifest (BRANDED / NOT MINIMAL)  
**wolves.land | The Land of Wolves 🐺**

═══════════════════════════════════════════════════════════════════════════════

## Overview

fxmanifest.lua **MUST** be branded with ASCII header and scope comments. Minimal manifests are **FORBIDDEN**.

═══════════════════════════════════════════════════════════════════════════════

## 📋 Required Structure

### Full Template

```lua
--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ███████╗███████╗ ██████╗ ██╗   ██╗██████╗  ██████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔════╝██╔════╝██╔═══██╗██║   ██║██╔══██╗██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝       ██████╔╝█████╗  ███████╗██║   ██║██║   ██║██████╔╝██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗       ██╔══██╗██╔══╝  ╚════██║██║   ██║██║   ██║██╔══██╗██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ██║  ██║███████╗███████║╚██████╔╝╚██████╔╝██║  ██║╚██████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝
    
    🐺 [Resource Name] - FXManifest
    
    Manifest file defining resource metadata, dependencies, and load order
    for the [Resource Name] system.
    
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

name '[Resource Name]'
author 'iBoss21 / The Lux Empire'
description '[Brief description of what this resource does]'
version '1.0.0'
repository 'https://github.com/iBoss21/[repo-name]'

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SHARED FILES
-- ═══════════════════════════════════════════════════════════════════════════════

shared_scripts {
    'config.lua',
    'shared/framework.lua',
    -- Add more shared files
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CLIENT FILES
-- ═══════════════════════════════════════════════════════════════════════════════

client_scripts {
    'client/main.lua',
    -- Add more client files
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SERVER FILES
-- ═══════════════════════════════════════════════════════════════════════════════

server_scripts {
    'server/main.lua',
    -- Add more server files
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 UI FILES (if applicable)
-- ═══════════════════════════════════════════════════════════════════════════════

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    -- Add more UI files
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 DEPENDENCIES
-- ═══════════════════════════════════════════════════════════════════════════════

--[[
    IMPORTANT: Do NOT hard-require all frameworks because multi-support exists.
    Only list truly required dependencies.
]]

dependencies {
    -- Required dependencies only
    -- Example: 'ox_lib'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 EXPORTS (if applicable)
-- ═══════════════════════════════════════════════════════════════════════════════

exports {
    -- 'ExportedFunction',
}

server_exports {
    -- 'ServerExportedFunction',
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- END OF MANIFEST
-- ═══════════════════════════════════════════════════════════════════════════════
```

═══════════════════════════════════════════════════════════════════════════════

## 🎯 Required Components

### 1. Branded ASCII Header
High-density ASCII title with resource name and copyright.

### 2. RedM Prerelease Warning (MANDATORY)
```lua
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources WILL become incompatible once RedM ships.'
```

This is **REQUIRED** for all RedM resources.

### 3. Core Settings
```lua
fx_version 'cerulean'  -- or latest
game 'rdr3'
lua54 'yes'
```

### 4. Metadata
```lua
name '[Resource Name]'
author 'iBoss21 / The Lux Empire'
description '[Brief description]'
version 'X.X.X'
repository 'https://github.com/iBoss21/[repo-name]' -- optional
```

### 5. Script Files
Organize with clear section banners:
- shared_scripts
- client_scripts
- server_scripts
- ui_page & files (if UI exists)

### 6. Dependencies
```lua
dependencies {
    -- Required dependencies only
    -- Do NOT hard-require frameworks due to multi-support
}
```

**IMPORTANT**: Do not add all frameworks as dependencies. Multi-framework support means the resource should auto-detect, not require all frameworks.

### 7. Exports (if applicable)
```lua
exports {
    'FunctionName',
}

server_exports {
    'ServerFunctionName',
}
```

═══════════════════════════════════════════════════════════════════════════════

## 🎨 Styling Requirements

### Use Light Dividers
```lua
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SECTION NAME
-- ═══════════════════════════════════════════════════════════════════════════════
```

### Add Scope Comments
Each section should have a clear scope comment describing its responsibility:

```lua
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 CLIENT FILES
-- ═══════════════════════════════════════════════════════════════════════════════

-- Handles all client-side logic including:
-- - Player interactions
-- - UI rendering
-- - Local state management

client_scripts {
    'client/main.lua',
    'client/ui.lua',
}
```

### Group Related Files
Keep related files together and commented:

```lua
shared_scripts {
    -- Core configuration
    'config.lua',
    
    -- Framework detection and adapter
    'shared/framework.lua',
    
    -- Utility functions
    'shared/utils.lua',
}
```

═══════════════════════════════════════════════════════════════════════════════

## 📐 File Organization Patterns

### Basic Resource
```lua
shared_scripts { 'config.lua' }
client_scripts { 'client/main.lua' }
server_scripts { 'server/main.lua' }
```

### Multi-Framework Resource
```lua
shared_scripts {
    'config.lua',
    'shared/framework.lua', -- Framework detection & adapter
}
client_scripts {
    'client/main.lua',
}
server_scripts {
    'server/main.lua',
}
```

### Complex Resource with UI
```lua
shared_scripts {
    'config.lua',
    'shared/framework.lua',
    'shared/utils.lua',
}

client_scripts {
    'client/main.lua',
    'client/ui.lua',
    'client/interactions.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- If using MySQL
    'server/main.lua',
    'server/database.lua',
    'server/callbacks.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/images/*.png',
}
```

═══════════════════════════════════════════════════════════════════════════════

## ⚠️ Common Mistakes to Avoid

### ❌ Minimal Manifest (FORBIDDEN)
```lua
fx_version 'cerulean'
game 'rdr3'

shared_script 'config.lua'
client_script 'client.lua'
server_script 'server.lua'
```

### ✅ Branded Manifest (REQUIRED)
Full branded header, dividers, scope comments, proper metadata.

### ❌ Hard-Requiring All Frameworks
```lua
dependencies {
    'lxr-core',
    'rsg-core',
    'vorp_core', -- Don't do this!
}
```

### ✅ Minimal Dependencies
```lua
dependencies {
    'ox_lib', -- Only if truly required
}
```

═══════════════════════════════════════════════════════════════════════════════

## ✅ Validation Checklist

- [ ] Branded ASCII header present
- [ ] Purpose statement included
- [ ] Copyright notice present
- [ ] fx_version specified
- [ ] game 'rdr3' specified
- [ ] lua54 'yes' specified
- [ ] rdr3_warning present (MANDATORY)
- [ ] name metadata present
- [ ] author metadata present
- [ ] description metadata present
- [ ] version metadata present
- [ ] All script sections use dividers
- [ ] Scope comments present
- [ ] Files logically organized
- [ ] Dependencies minimal (not hard-requiring frameworks)
- [ ] Exports documented (if applicable)
- [ ] END OF MANIFEST banner present

═══════════════════════════════════════════════════════════════════════════════

## 🔗 Related Standards

- [Branding & File Style](./branding-and-style.md) - ASCII headers
- [Multi-Framework Support](./multi-framework.md) - Dependency handling

═══════════════════════════════════════════════════════════════════════════════

© 2026 iBoss21 / The Lux Empire | wolves.land
