# 🐺 Branding & File Style Standards

```
██╗     ██╗  ██╗██████╗         ██████╗ ███████╗██████╗ ███╗   ███╗
██║     ╚██╗██╔╝██╔══██╗        ██╔══██╗██╔════╝██╔══██╗████╗ ████║
██║      ╚███╔╝ ██████╔╝        ██████╔╝█████╗  ██║  ██║██╔████╔██║
██║      ██╔██╗ ██╔══██╗        ██╔══██╗██╔══╝  ██║  ██║██║╚██╔╝██║
███████╗██╔╝ ██╗██║  ██║        ██║  ██║███████╗██████╔╝██║ ╚═╝ ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═╝  ╚═╝╚══════╝╚═════╝ ╚═╝     ╚═╝
```

**Standard**: Branding & File Style (NON-NEGOTIABLE)  
**wolves.land | The Land of Wolves 🐺**

═══════════════════════════════════════════════════════════════════════════════

## Overview

Every generated file **MUST** start with a mega branded comment header matching the authoritative reference style from [lxr-proploot/config.lua](https://github.com/iboss21/lxr-proploot/blob/main/config.lua).

**DO NOT** output minimal/generic "clean configs". Output wolves.land style.

═══════════════════════════════════════════════════════════════════════════════

## 📋 Required Header Components

Every Lua file (.lua) MUST begin with a multi-line comment containing:

### 1. High-Density ASCII Title
Use the same visual weight as reference. Example:

```lua
--[[
    ██╗     ██╗  ██╗██████╗        ██████╗ ███████╗███████╗ ██████╗ ██╗   ██╗██████╗  ██████╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔══██╗██╔════╝██╔════╝██╔═══██╗██║   ██║██╔══██╗██╔════╝██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗ ██████╔╝█████╗  ███████╗██║   ██║██║   ██║██████╔╝██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝ ██╔══██╗██╔══╝  ╚════██║██║   ██║██║   ██║██╔══██╗██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ██║  ██║███████╗███████║╚██████╔╝╚██████╔╝██║  ██║╚██████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝
    
    🐺 <System Name> - Configuration / Client / Server / Shared / Script
]]
```

### 2. Purpose Statement
A clear, authoritative statement of what the file does:

```lua
--[[
    This configuration file controls the [system description] for RedM.
    [Brief explanation of functionality and purpose.]
]]
```

### 3. SERVER INFORMATION Block
With dividers:

```lua
--[[
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
]]
```

### 4. Version & Performance Target

```lua
--[[
    Version: X.X.X
    Performance Target: Optimized for minimal server overhead and client FPS impact
]]
```

### 5. Tags List

```lua
--[[
    Tags: RedM, Georgian, SeriousRP, Whitelist, [Feature], Economy, [Category]
]]
```

### 6. Framework Support List

```lua
--[[
    Framework Support:
    - LXR Core (Primary)
    - RSG Core (Compatible)
    - VORP Core (Compatible)
    - RedEM:RP (Compatible) [if applicable]
    - QBR Core (Compatible) [if applicable]
    - QR Core (Compatible) [if applicable]
    - Standalone (Compatible)
]]
```

### 7. Credits Section

```lua
--[[
    ═══════════════════════════════════════════════════════════════════════════════
    CREDITS
    ═══════════════════════════════════════════════════════════════════════════════
    
    Script Author: iBoss21 / The Lux Empire for The Land of Wolves
    Original Concept: [if converting/inspired by someone]
    Inspired by: [if applicable]
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]
```

═══════════════════════════════════════════════════════════════════════════════

## 🎨 Throughout Each File

### Heavy Section Dividers
Use `═` divider blocks for major areas:

```lua
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE NAME PROTECTION - RUNTIME CHECK
-- ═══════════════════════════════════════════════════════════════════════════════
```

### BIG Section Banners
Use `█` blocks with uppercase titles for major config sections:

```lua
-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SERVER BRANDING & INFO ████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
```

### Consistent Formatting
- Keep indentation consistent (4 spaces or tabs, match existing style)
- Use consistent quoting (single or double, match existing style)
- Group related settings together
- Add inline comments for complex settings

═══════════════════════════════════════════════════════════════════════════════

## 📁 Folder Branding

**EVERY FOLDER MUST LOOK BRANDED.**

Generate (or require) README.md with ASCII identity and purpose inside:

### Required READMEs

1. **`/README.md`** - Main resource README with full branding
2. **`/client/README.md`** - Client-side code documentation
3. **`/server/README.md`** - Server-side code documentation
4. **`/shared/README.md`** - Shared code documentation
5. **`/docs/*.md`** - Every doc begins with branded ASCII header

### Markdown Header Format

```markdown
# 🐺 [Resource Name] - [Section]

[ASCII Art Title]

**The Land of Wolves** | wolves.land  
*[Subtitle/Description]*

═══════════════════════════════════════════════════════════════════════════════

[Content here]
```

═══════════════════════════════════════════════════════════════════════════════

## ✅ Validation Checklist

Before considering a file complete, verify:

- [ ] File has mega branded comment header
- [ ] ASCII title present and high-density
- [ ] Purpose statement included
- [ ] SERVER INFORMATION block present
- [ ] Version and performance target specified
- [ ] Tags list included
- [ ] Framework support list included
- [ ] Credits section present with copyright
- [ ] Major sections use `═` dividers
- [ ] Config sections use `█` banners
- [ ] Consistent formatting throughout
- [ ] All related folders have branded READMEs

═══════════════════════════════════════════════════════════════════════════════

## 🔗 Reference

**Authoritative Style Reference**: [lxr-proploot/config.lua](https://github.com/iboss21/lxr-proploot/blob/main/config.lua)

Match the density, rhythm, and visual weight of this reference file.

═══════════════════════════════════════════════════════════════════════════════

**If any file lacks branding header or section banner style → FAIL.**

© 2026 iBoss21 / The Lux Empire | wolves.land
