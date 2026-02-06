# 🐺 Resource Name Protection Standard

```
██╗     ██╗  ██╗██████╗         ██████╗ ██████╗  ██████╗ ████████╗███████╗ ██████╗████████╗
██║     ╚██╗██╔╝██╔══██╗        ██╔══██╗██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝
██║      ╚███╔╝ ██████╔╝        ██████╔╝██████╔╝██║   ██║   ██║   █████╗  ██║        ██║   
██║      ██╔██╗ ██╔══██╗        ██╔═══╝ ██╔══██╗██║   ██║   ██║   ██╔══╝  ██║        ██║   
███████╗██╔╝ ██╗██║  ██║        ██║     ██║  ██║╚██████╔╝   ██║   ███████╗╚██████╗   ██║   
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═╝     ╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚══════╝ ╚═════╝   ╚═╝   
```

**Standard**: Resource Name Protection (MANDATORY)  
**wolves.land | The Land of Wolves 🐺**

═══════════════════════════════════════════════════════════════════════════════

## Overview

Every resource **MUST** include runtime resource-name protection to prevent renaming that could break functionality or violate branding.

This protection runs at config load (config.lua or shared/bridge.lua) and halts execution if the resource name is incorrect.

═══════════════════════════════════════════════════════════════════════════════

## 📋 Implementation

### Required Code Block

Place this at the **TOP** of config.lua (after the branded header, before Config = {}):

```lua
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 RESOURCE NAME PROTECTION - RUNTIME CHECK
-- ═══════════════════════════════════════════════════════════════════════════════

local REQUIRED_RESOURCE_NAME = "lxr-resourcename"
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

-- Rest of config continues...
```

### Placement

**Option 1**: config.lua (most common)
```lua
--[[ Branded Header ]]

-- Resource Name Protection (code above)

Config = {}
-- Config continues...
```

**Option 2**: shared/bridge.lua or shared/framework.lua
```lua
--[[ Branded Header ]]

-- Resource Name Protection (code above)

-- Framework detection and adapter code...
```

═══════════════════════════════════════════════════════════════════════════════

## 🎨 Styling Requirements

### Banner Dividers
Use heavy `═` dividers as shown above.

### Error Message
Must include:
- Heavy dividers top and bottom
- ❌ emoji with "CRITICAL ERROR"
- Clear "Expected" vs "Got" comparison
- Instructions to rename folder
- wolves.land branding

### Variable Names
- `REQUIRED_RESOURCE_NAME` (uppercase constant)
- `currentResourceName` (camelCase)

═══════════════════════════════════════════════════════════════════════════════

## 🧪 Testing

### Test Valid Name

1. Ensure folder name matches `REQUIRED_RESOURCE_NAME`
2. Start resource
3. Should load normally

### Test Invalid Name

1. Rename resource folder to something else
2. Attempt to start resource
3. Should immediately error with branded message
4. Resource should **not** start

═══════════════════════════════════════════════════════════════════════════════

## 📋 Real-World Examples

### Example 1: lxr-proploot

```lua
local REQUIRED_RESOURCE_NAME = "lxr-proploot"
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
```

### Example 2: lxr-fishing

```lua
local REQUIRED_RESOURCE_NAME = "lxr-fishing"
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
```

═══════════════════════════════════════════════════════════════════════════════

## 🎯 Why This Matters

### Prevents Breakage
Resources may reference themselves by name internally. Renaming breaks these references.

### Branding Protection
Maintains official naming convention and prevents unauthorized rebranding.

### Clear Error Messages
When someone renames incorrectly, they get immediate, branded feedback.

### Professional Appearance
Shows attention to detail and production-grade quality.

═══════════════════════════════════════════════════════════════════════════════

## ✅ Validation Checklist

- [ ] Resource name protection code present
- [ ] Placed at top of config.lua or shared/bridge.lua
- [ ] REQUIRED_RESOURCE_NAME matches actual resource folder name
- [ ] Error message uses heavy `═` dividers
- [ ] Error message includes ❌ emoji
- [ ] Error message shows Expected vs Got comparison
- [ ] Error message includes wolves.land branding
- [ ] Error message provides clear rename instructions
- [ ] Code uses string.format for proper variable insertion
- [ ] Tested with both valid and invalid names

═══════════════════════════════════════════════════════════════════════════════

## 🔗 Reference

**Authoritative Example**: [lxr-proploot/config.lua](https://github.com/iboss21/lxr-proploot/blob/main/config.lua)

═══════════════════════════════════════════════════════════════════════════════

© 2026 iBoss21 / The Lux Empire | wolves.land
