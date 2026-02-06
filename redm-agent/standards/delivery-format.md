# 🐺 Delivery Format Standard

```
██╗     ██╗  ██╗██████╗         ██████╗ ███████╗██╗     ██╗██╗   ██╗███████╗██████╗ ██╗   ██╗
██║     ╚██╗██╔╝██╔══██╗        ██╔══██╗██╔════╝██║     ██║██║   ██║██╔════╝██╔══██╗╚██╗ ██╔╝
██║      ╚███╔╝ ██████╔╝        ██║  ██║█████╗  ██║     ██║██║   ██║█████╗  ██████╔╝ ╚████╔╝ 
██║      ██╔██╗ ██╔══██╗        ██║  ██║██╔══╝  ██║     ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗  ╚██╔╝  
███████╗██╔╝ ██╗██║  ██║        ██████╔╝███████╗███████╗██║ ╚████╔╝ ███████╗██║  ██║   ██║   
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝   
```

**Standard**: Delivery Format (MANDATORY OUTPUT ORDER)  
**wolves.land | The Land of Wolves 🐺**

═══════════════════════════════════════════════════════════════════════════════

## Overview

When asked to build/convert a resource, output **MUST** include all components in the order specified below.

**No partials. No placeholders unless requested.**

═══════════════════════════════════════════════════════════════════════════════

## 📦 Mandatory Delivery Order

### 1. Folder Tree

Present a complete folder structure showing all files:

```
lxr-resourcename/
├── fxmanifest.lua
├── config.lua
├── README.md
├── client/
│   ├── main.lua
│   └── README.md
├── server/
│   ├── main.lua
│   └── README.md
├── shared/
│   ├── framework.lua
│   └── README.md
├── docs/
│   ├── overview.md
│   ├── installation.md
│   ├── configuration.md
│   ├── frameworks.md
│   ├── events.md
│   ├── security.md
│   ├── performance.md
│   ├── screenshots.md
│   └── assets/
│       └── screenshots/
│           ├── 01_startup_console.png
│           ├── 02_config_sections.png
│           ├── 03_ui_interaction.png
│           ├── 04_framework_detection.png
│           ├── 05_discord_logs.png
│           └── 06_txadmin_performance.png
└── sql/ (if database required)
    └── install.sql
```

### 2. Full Branded fxmanifest.lua

Complete fxmanifest.lua with:
- Branded ASCII header
- All required components
- RedM prerelease warning
- Proper metadata
- Script organization

### 3. Full Branded config.lua

Complete config.lua with:
- Mega branded header
- Runtime name guard
- All config sections with banners
- Framework configuration
- ServerInfo
- Startup boot print

### 4. Framework Adapter Layer

Complete shared/framework.lua (or shared/bridge.lua) with:
- Branded header
- Framework detection
- Unified adapter functions
- All framework implementations

### 5. Full Client Scripts

All client-side scripts with:
- Branded headers
- Clean, organized code
- Comments where needed
- Uses unified framework functions

### 6. Full Server Scripts

All server-side scripts with:
- Branded headers
- Server-side validation
- Security measures
- Uses unified framework functions

### 7. Full /docs Markdown Files

Complete documentation including:
- overview.md
- installation.md
- configuration.md
- frameworks.md
- events.md
- security.md
- performance.md
- screenshots.md

Each doc with branded header and specific content.

### 8. README.md

Main resource README with:
- Branded ASCII header
- Resource description
- Features list
- Installation quick start
- Links to full docs
- Credits and license

### 9. SQL Files (if applicable)

Database setup scripts with:
- Branded SQL comments
- Table creation
- Initial data
- Upgrade scripts

### 10. Notes Section

Final notes covering:
- Compatibility notes
- Security implementation summary
- Performance considerations
- Known limitations
- Future enhancements

═══════════════════════════════════════════════════════════════════════════════

## 📋 Delivery Checklist

### Files & Structure
- [ ] Folder tree provided
- [ ] fxmanifest.lua complete and branded
- [ ] config.lua complete and branded
- [ ] All client scripts complete and branded
- [ ] All server scripts complete and branded
- [ ] shared/framework.lua complete and branded
- [ ] README.md complete and branded
- [ ] All /docs files complete and branded
- [ ] SQL files (if applicable)

### Branding
- [ ] Every file has branded ASCII header
- [ ] Resource name protection present
- [ ] Server info canonical or overridden
- [ ] wolves.land branding throughout
- [ ] Heavy banners on config sections
- [ ] Light dividers where appropriate

### Functionality
- [ ] Working code (no placeholders)
- [ ] Multi-framework support implemented
- [ ] Framework adapter complete
- [ ] Security validation implemented
- [ ] Server-side authority enforced
- [ ] All events/triggers correct per framework

### Documentation
- [ ] All required docs present
- [ ] Docs specific to resource (not generic)
- [ ] Screenshot requirements documented
- [ ] Installation instructions complete
- [ ] Configuration explained
- [ ] API/events documented

### Quality
- [ ] Code follows standards
- [ ] Comments where helpful
- [ ] Consistent formatting
- [ ] No syntax errors
- [ ] Tested logic flow
- [ ] Performance optimized

═══════════════════════════════════════════════════════════════════════════════

## 📝 Output Format

### Present Files Clearly

Use code blocks with file paths:

````markdown
### File: `fxmanifest.lua`

```lua
--[[ Header ]]
fx_version 'cerulean'
-- ... rest of file
```

### File: `config.lua`

```lua
--[[ Header ]]
Config = {}
-- ... rest of file
```
````

### Group Related Files

Present files in logical groups:
1. Core files (fxmanifest, config)
2. Framework adapter
3. Client files
4. Server files
5. Documentation
6. Additional files

═══════════════════════════════════════════════════════════════════════════════

## 🔍 Completeness Standards

### ✅ Complete Delivery

- All files present
- All files branded
- Working code throughout
- Specific documentation
- No placeholders
- No "TODO" comments (unless intentional for user customization)

### ❌ Incomplete Delivery (Not Acceptable)

- Missing files
- Placeholder code
- Generic documentation
- Unbranded files
- Missing security
- Fake/invented events

═══════════════════════════════════════════════════════════════════════════════

## 📊 Presentation Order Example

```markdown
# LXR Resource Name - Complete Delivery

## 1. Folder Structure

[Tree structure here]

## 2. Core Files

### fxmanifest.lua

[Full file content]

### config.lua

[Full file content]

## 3. Framework Layer

### shared/framework.lua

[Full file content]

## 4. Client Files

### client/main.lua

[Full file content]

## 5. Server Files

### server/main.lua

[Full file content]

## 6. Documentation

### docs/overview.md

[Full file content]

[Continue for all docs...]

## 7. Additional Files

### README.md

[Full file content]

## 8. Notes

### Compatibility

[Notes]

### Security

[Summary of security implementations]

### Performance

[Performance considerations]

### Known Limitations

[Any limitations]
```

═══════════════════════════════════════════════════════════════════════════════

## 🎯 Quality Gates

Before considering delivery complete, verify:

### Gate 1: Branding
All files have proper ASCII headers and wolves.land branding.

### Gate 2: Functionality
All code works, no placeholders, correct framework events.

### Gate 3: Security
Server-side validation, cooldowns, rate limiting implemented.

### Gate 4: Documentation
All docs present, specific to resource, not generic filler.

### Gate 5: Completeness
All files present, organized, ready to use.

═══════════════════════════════════════════════════════════════════════════════

## ⚠️ If Anything Is Missing

**FAIL** and correct immediately.

The delivery must be **production-ready** with all components present and properly branded.

═══════════════════════════════════════════════════════════════════════════════

## ✅ Final Validation Checklist

- [ ] Folder tree provided
- [ ] All files present
- [ ] All files branded
- [ ] fxmanifest.lua complete
- [ ] config.lua complete with boot print
- [ ] Framework adapter complete
- [ ] Client scripts complete
- [ ] Server scripts complete
- [ ] All docs complete
- [ ] README.md complete
- [ ] SQL files (if needed)
- [ ] Notes section included
- [ ] No placeholders
- [ ] No fake events
- [ ] Security implemented
- [ ] Multi-framework support
- [ ] Production-ready

═══════════════════════════════════════════════════════════════════════════════

© 2026 iBoss21 / The Lux Empire | wolves.land
