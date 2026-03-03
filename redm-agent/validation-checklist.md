# 🐺 Validation Checklist

```
██╗     ██╗  ██╗██████╗         ██╗   ██╗ █████╗ ██╗     ██╗██████╗  █████╗ ████████╗███████╗
██║     ╚██╗██╔╝██╔══██╗        ██║   ██║██╔══██╗██║     ██║██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
██║      ╚███╔╝ ██████╔╝        ██║   ██║███████║██║     ██║██║  ██║███████║   ██║   █████╗  
██║      ██╔██╗ ██╔══██╗        ╚██╗ ██╔╝██╔══██║██║     ██║██║  ██║██╔══██║   ██║   ██╔══╝  
███████╗██╔╝ ██╗██║  ██║         ╚████╔╝ ██║  ██║███████╗██║██████╔╝██║  ██║   ██║   ███████╗
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝          ╚═══╝  ╚═╝  ╚═╝╚══════╝╚═╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
```

**Pre-Delivery Validation Checklist**  
**wolves.land | The Land of Wolves 🐺**

═══════════════════════════════════════════════════════════════════════════════

## Overview

Use this checklist before delivering any RedM resource to ensure all standards are met and the resource is production-ready.

═══════════════════════════════════════════════════════════════════════════════

## 📋 Branding & Style

### File Headers
- [ ] Every Lua file has mega branded comment header
- [ ] ASCII title present and high-density
- [ ] Purpose statement included
- [ ] SERVER INFORMATION block present
- [ ] Version and performance target specified
- [ ] Tags list included
- [ ] Framework support list included
- [ ] Credits section present with copyright

### Throughout Files
- [ ] Major sections use `═` dividers
- [ ] Config sections use `█` banners (████)
- [ ] Consistent indentation (4 spaces or tabs)
- [ ] Consistent quoting style
- [ ] Logical grouping of related code

### Folder Structure
- [ ] /README.md with branded header
- [ ] /client/README.md (if client code exists)
- [ ] /server/README.md (if server code exists)
- [ ] /shared/README.md (if shared code exists)
- [ ] All /docs/*.md files have branded headers

═══════════════════════════════════════════════════════════════════════════════

## 🎯 Framework Support

### Configuration
- [ ] Config.Framework = 'auto' present
- [ ] Framework priority documented in comment
- [ ] Config.FrameworkSettings contains all required frameworks
- [ ] LXR-Core settings present
- [ ] RSG-Core settings present
- [ ] VORP Core settings present
- [ ] Standalone fallback present

### Detection
- [ ] Framework detection function implemented
- [ ] Checks resources in priority order
- [ ] ActiveFramework variable set
- [ ] Clean fallback to standalone
- [ ] Startup print shows detected framework

### Adapter Layer
- [ ] shared/framework.lua or shared/bridge.lua present
- [ ] Unified API functions defined
- [ ] All frameworks have adapter implementations
- [ ] Client-side adapters implemented
- [ ] Server-side adapters implemented
- [ ] Core logic uses ONLY unified functions (no direct framework calls)

═══════════════════════════════════════════════════════════════════════════════

## 🔐 Security

### Server-Side Validation
- [ ] All critical operations validated server-side
- [ ] Never trust client-provided money/items/xp
- [ ] Distance validation implemented
- [ ] State validation implemented (alive, not in vehicle, etc.)
- [ ] Player existence checks before operations

### Cooldowns & Rate Limiting
- [ ] Cooldowns tracked server-side
- [ ] Rate limiting implemented for repeatable actions
- [ ] Anti-spam measures in place
- [ ] Per-player cooldown tracking

### Logging & Monitoring
- [ ] Suspicious activity logging implemented
- [ ] LogSuspicious function present
- [ ] Discord webhook support (optional but recommended)
- [ ] Failed validation attempts logged

### Configuration
- [ ] Config.Security section present
- [ ] maxDistance setting configured
- [ ] antiSpam enabled
- [ ] logSuspicious enabled
- [ ] webhookUrl documented

═══════════════════════════════════════════════════════════════════════════════

## ⚙️ Configuration

### Required Sections
- [ ] Config.ServerInfo present with all fields
- [ ] Config.Framework present
- [ ] Config.FrameworkSettings present
- [ ] Config.Lang and Config.Locale present
- [ ] Config.General present
- [ ] Config.Security present
- [ ] Config.Performance present
- [ ] Config.Debug present

### Resource Name Protection
- [ ] REQUIRED_RESOURCE_NAME defined
- [ ] GetCurrentResourceName() check present
- [ ] Error message properly formatted
- [ ] Placed at top of config.lua

### Startup Print
- [ ] Startup banner present
- [ ] Shows version
- [ ] Shows detected framework
- [ ] Shows language
- [ ] Shows relevant counts (items, NPCs, etc.)
- [ ] Shows security status
- [ ] Shows debug status
- [ ] Shows wolves.land branding

### Section Banners
- [ ] All major sections have `█` banners
- [ ] Subsections have `═` dividers
- [ ] END OF CONFIG banner present

═══════════════════════════════════════════════════════════════════════════════

## 📝 FXManifest

### Core Elements
- [ ] Branded ASCII header present
- [ ] fx_version specified
- [ ] game 'rdr3' specified
- [ ] lua54 'yes' specified
- [ ] rdr3_warning present (MANDATORY)

### Metadata
- [ ] name metadata present
- [ ] author metadata present (iBoss21 / The Lux Empire)
- [ ] description metadata present
- [ ] version metadata present
- [ ] repository metadata present (optional)

### Script Organization
- [ ] shared_scripts section with divider
- [ ] client_scripts section with divider
- [ ] server_scripts section with divider
- [ ] ui_page and files (if UI exists)
- [ ] Logical file grouping with comments

### Dependencies
- [ ] dependencies minimal (not hard-requiring all frameworks)
- [ ] Only truly required dependencies listed
- [ ] Comment explaining dependency strategy

═══════════════════════════════════════════════════════════════════════════════

## 📦 Tebex Escrow Compliance

### Resource Naming
- [ ] Resource folder name exactly matches `name` field in `fxmanifest.lua`
- [ ] `name` uses `lxr-` prefix (e.g., `lxr-example`)
- [ ] `author` is `iBoss21 / The Lux Empire`
- [ ] `version` follows semantic versioning (e.g., `1.0.0`)
- [ ] `description` is clear and accurate for Tebex product page

### Technical Escrow Safety
- [ ] No `require()` calls (use fxmanifest declarations instead)
- [ ] No `loadfile()` calls
- [ ] No `dofile()` calls
- [ ] All script files declared in `fxmanifest.lua`
- [ ] No hardcoded sensitive data (Discord tokens, API keys, IPs)
- [ ] `Config.Debug = false` as default (NEVER ship debug mode enabled)

### Escrow File Classification
- [ ] `fxmanifest.lua` — NOT obfuscated (required by FXServer runtime)
- [ ] `config.lua` — NOT obfuscated (buyer must configure settings)
- [ ] `shared/framework-bridge.lua` — Obfuscated (proprietary code)
- [ ] `client/*.lua` — Obfuscated (proprietary code)
- [ ] `server/*.lua` — Obfuscated (proprietary code)
- [ ] `html/` files — NOT obfuscated (browser requires readable HTML/CSS/JS)
- [ ] `README.md` and docs — NOT obfuscated (documentation must be readable)

═══════════════════════════════════════════════════════════════════════════════

## 📚 Documentation

### Required Files
- [ ] /docs/overview.md present
- [ ] /docs/installation.md present
- [ ] /docs/configuration.md present
- [ ] /docs/frameworks.md present
- [ ] /docs/events.md present
- [ ] /docs/security.md present
- [ ] /docs/performance.md present
- [ ] /docs/screenshots.md present

### Content Quality
- [ ] All docs have branded ASCII headers
- [ ] Content specific to resource (not generic filler)
- [ ] Real examples (not placeholders)
- [ ] Cross-references work correctly
- [ ] Consistent formatting

### Screenshots
- [ ] Screenshot requirements documented
- [ ] Required screenshots identified
- [ ] Storage path specified (/docs/assets/screenshots/)
- [ ] Naming conventions documented
- [ ] Conditional screenshots identified (UI, logging, etc.)

═══════════════════════════════════════════════════════════════════════════════

## 🎯 Events & Triggers

### Framework Events
- [ ] No invented/fake events used
- [ ] All events match actual framework patterns
- [ ] LXR-Core events correct
- [ ] RSG-Core events correct
- [ ] VORP events correct
- [ ] Other framework events correct (if used)

### Unified Functions
- [ ] Framework.Notify implemented for all frameworks
- [ ] Framework.GetPlayerData implemented
- [ ] Framework.AddMoney/RemoveMoney implemented
- [ ] Framework.AddItem/RemoveItem/HasItem implemented
- [ ] Framework.ProgressBar implemented (client)
- [ ] Framework.RegisterCallback/TriggerCallback implemented

### Core Logic
- [ ] Core logic uses ONLY unified functions
- [ ] No direct framework calls in gameplay code
- [ ] Adapter layer handles all framework-specific calls

═══════════════════════════════════════════════════════════════════════════════

## 💻 Code Quality

### Client Code
- [ ] Branded header on all client files
- [ ] Clean, organized code
- [ ] Proper event handlers
- [ ] Uses framework adapter
- [ ] Cleanup on resource stop

### Server Code
- [ ] Branded header on all server files
- [ ] Server-side validation
- [ ] Security measures implemented
- [ ] Uses framework adapter
- [ ] Proper error handling
- [ ] Cooldown/rate limit enforcement

### Shared Code
- [ ] Framework detection/adapter in shared
- [ ] Utility functions in shared (if applicable)
- [ ] Config accessible from both sides

### Comments
- [ ] Comments where helpful (not excessive)
- [ ] No misleading comments
- [ ] Intent documented for complex logic
- [ ] No commented-out code (remove or document why kept)

═══════════════════════════════════════════════════════════════════════════════

## 🚀 Performance

### Optimization
- [ ] Config.Performance section present
- [ ] Tick rates configured appropriately
- [ ] Cache TTL configured
- [ ] Update intervals tuned
- [ ] No unnecessary loops

### Resource Usage
- [ ] Minimal server overhead
- [ ] Minimal client FPS impact
- [ ] Efficient database queries (if applicable)
- [ ] Proper cleanup of entities/threads

═══════════════════════════════════════════════════════════════════════════════

## 📦 Delivery Completeness

### All Files Present
- [ ] fxmanifest.lua
- [ ] config.lua
- [ ] Framework adapter
- [ ] Client scripts
- [ ] Server scripts
- [ ] README.md
- [ ] All documentation
- [ ] SQL files (if database)

### No Placeholders
- [ ] No "TODO" comments (unless intentional for user)
- [ ] No placeholder functions
- [ ] No empty implementations
- [ ] All features functional

### Production Ready
- [ ] Code works correctly
- [ ] No syntax errors
- [ ] Logical flow validated
- [ ] Security implemented
- [ ] Multi-framework tested (or documented)

═══════════════════════════════════════════════════════════════════════════════

## ✅ Final Check

### The "Wolves.land Test"
Does this resource look and feel like it was authored by **iBoss21** for **wolves.land**?

- [ ] Big ASCII mega headers ✓
- [ ] Heavy █████ banners ✓
- [ ] Runtime name guard ✓
- [ ] Multi-framework auto-detect + adapter layer ✓
- [ ] Branded docs + screenshot requirements ✓
- [ ] Boot print banner ✓

### The "Production Test"
Is this resource ready for immediate deployment?

- [ ] All functionality works
- [ ] Security measures in place
- [ ] Documentation complete
- [ ] No known bugs
- [ ] Performance acceptable

### The "Standards Test"
Does this resource follow ALL standards?

- [ ] Branding & File Style ✓
- [ ] Multi-Framework Support ✓
- [ ] Events & Triggers ✓
- [ ] Resource Name Protection ✓
- [ ] Configuration Standards ✓
- [ ] FXManifest Standards ✓
- [ ] Security & Server Authority ✓
- [ ] Documentation Requirements ✓
- [ ] Screenshots & Assets ✓
- [ ] Delivery Format ✓
- [ ] Tebex Escrow Compliance ✓

═══════════════════════════════════════════════════════════════════════════════

## 🔴 FAIL Conditions

If ANY of the following are true, the resource **FAILS** and must be corrected:

❌ Missing branded headers on any file  
❌ Missing resource name protection  
❌ Invented/fake framework events  
❌ Client-trusted critical data  
❌ Missing documentation files  
❌ Generic filler documentation  
❌ Placeholder code  
❌ Missing security validation  
❌ Hard-requiring all frameworks in dependencies  
❌ Missing Config.ServerInfo  
❌ Missing framework adapter layer  
❌ Core logic has direct framework calls  
❌ Missing startup boot print  
❌ No section banners in config  
❌ Resource folder name does not match `name` in fxmanifest  
❌ `require()` / `loadfile()` / `dofile()` calls present  
❌ `Config.Debug = true` shipped in production  
❌ Hardcoded Discord tokens, API keys, or server IPs  

═══════════════════════════════════════════════════════════════════════════════

**If anything is missing → FAIL and correct immediately.**

© 2026 iBoss21 / The Lux Empire | wolves.land
