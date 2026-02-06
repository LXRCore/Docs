# 🐺 RedM Resource Templates

```
██╗     ██╗  ██╗██████╗        ████████╗███████╗███╗   ███╗██████╗ ██╗      █████╗ ████████╗███████╗███████╗
██║     ╚██╗██╔╝██╔══██╗       ╚══██╔══╝██╔════╝████╗ ████║██╔══██╗██║     ██╔══██╗╚══██╔══╝██╔════╝██╔════╝
██║      ╚███╔╝ ██████╔╝          ██║   █████╗  ██╔████╔██║██████╔╝██║     ███████║   ██║   █████╗  ███████╗
██║      ██╔██╗ ██╔══██╗          ██║   ██╔══╝  ██║╚██╔╝██║██╔═══╝ ██║     ██╔══██║   ██║   ██╔══╝  ╚════██║
███████╗██╔╝ ██╗██║  ██║          ██║   ███████╗██║ ╚═╝ ██║██║     ███████╗██║  ██║   ██║   ███████╗███████║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝          ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝
```

**The Land of Wolves** | wolves.land  
*Production-Ready Resource Templates Following wolves.land Standards*

═══════════════════════════════════════════════════════════════════════════════

## 📖 Overview

This directory contains **production-ready templates** for creating RedM resources that follow the exact standards defined in `/redm-agent/standards/`.

All templates are:
- ✅ **Fully Branded** - Complete wolves.land branding and ASCII headers
- ✅ **Production Ready** - No placeholders except where customization is expected
- ✅ **Multi-Framework** - Support for LXR-Core, RSG-Core, VORP, and more
- ✅ **Security First** - Server-side validation, rate limiting, anti-exploit
- ✅ **Performance Optimized** - Minimal overhead and FPS impact
- ✅ **Fully Documented** - Extensive comments and examples

═══════════════════════════════════════════════════════════════════════════════

## 📁 Template Files

### 1. `config.lua` - Configuration Template
**Purpose:** Complete branded configuration file with all standard sections

**Includes:**
- ✅ Full ASCII header with SERVER INFORMATION block
- ✅ Resource name protection with runtime check
- ✅ Server branding section (wolves.land)
- ✅ Framework configuration (auto-detect + manual override)
- ✅ Framework-specific settings for all supported frameworks
- ✅ Language/locale system
- ✅ General settings section
- ✅ Keys configuration (RedM key hashes)
- ✅ Timing & cooldowns section
- ✅ Economy settings section
- ✅ Security & anti-abuse section
- ✅ Performance optimization section
- ✅ Debug settings
- ✅ Resource-specific config placeholder
- ✅ Startup boot print banner

**Heavy Section Banners:**
```lua
-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SECTION NAME ██████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
```

**Reference:** Based on `/tmp/lxr-proploot-config.lua`

---

### 2. `fxmanifest.lua` - Manifest Template
**Purpose:** Complete branded FXManifest with organized sections

**Includes:**
- ✅ Full ASCII header with copyright
- ✅ RedM prerelease warning (MANDATORY)
- ✅ Core manifest metadata (fx_version, game, lua54)
- ✅ Resource information (name, author, description, version, repository)
- ✅ Shared scripts section with comments
- ✅ Client scripts section with comments
- ✅ Server scripts section with comments
- ✅ UI files section (commented out by default)
- ✅ Dependencies section with important notes
- ✅ Exports section (commented examples)
- ✅ Light dividers between sections

**Important Notes:**
- Do NOT hard-require all frameworks (multi-framework support)
- Only list truly required dependencies
- Organized with clear scope comments

**Reference:** Follows `/redm-agent/standards/fxmanifest.md`

---

### 3. `framework-bridge.lua` - Framework Adapter/Bridge
**Purpose:** Universal framework adapter providing unified API

**Includes:**
- ✅ Full ASCII header
- ✅ Framework detection function (DetectFramework)
- ✅ Active framework getter
- ✅ Framework settings getter
- ✅ **Client-Side Adapters** for:
  - LXR-Core
  - RSG-Core
  - VORP Core
  - RedEM:RP
  - QBR-Core
  - QR-Core
  - Standalone
- ✅ **Server-Side Adapters** for:
  - LXR-Core
  - RSG-Core
  - VORP Core
  - RedEM:RP
  - QBR-Core
  - QR-Core
  - Standalone

**Unified Client Functions:**
```lua
Framework.Notify(message, type, duration)
Framework.GetPlayerData()
Framework.ProgressBar(label, duration, options)
Framework.TriggerCallback(name, callback, ...)
```

**Unified Server Functions:**
```lua
Framework.Notify(source, message, type, duration)
Framework.GetPlayerData(source)
Framework.GetIdentifier(source)
Framework.AddMoney(source, account, amount)
Framework.RemoveMoney(source, account, amount)
Framework.GetMoney(source, account)
Framework.AddItem(source, item, amount, metadata)
Framework.RemoveItem(source, item, amount, metadata)
Framework.HasItem(source, item, amount)
Framework.RegisterCallback(name, callback)
```

**Architecture:**
- Automatic framework detection on startup
- Clean fallback to standalone mode
- Unified API eliminates framework-specific code in main logic
- Print framework detection result

**Reference:** Follows `/redm-agent/standards/multi-framework.md`

---

### 4. `client.lua` - Client Script Template
**Purpose:** Branded client-side template with examples

**Includes:**
- ✅ Full ASCII header
- ✅ Local variables section
- ✅ Initialization thread
- ✅ Resource initialization function
- ✅ Main update loop with configurable interval
- ✅ Target system initialization (ox_target)
- ✅ Interaction handler with progress bar
- ✅ Keybind registration example (commented)
- ✅ Client event handlers
- ✅ Callback trigger example
- ✅ Utility functions
- ✅ Cleanup on resource stop
- ✅ Export examples

**Usage Pattern:**
1. Wait for framework to be ready
2. Get player data
3. Initialize resource systems
4. Start main loop
5. Handle interactions via framework adapter

**Reference:** Production-ready structure with examples

---

### 5. `server.lua` - Server Script Template
**Purpose:** Branded server-side template with security

**Includes:**
- ✅ Full ASCII header
- ✅ Server variables (cooldowns, rate limiters)
- ✅ Initialization thread
- ✅ **Security Functions:**
  - ValidatePlayer (state validation)
  - ValidateDistance (distance checks)
  - CheckCooldown (cooldown system)
  - SetCooldown (cooldown management)
  - RateLimit (spam prevention)
  - LogSuspicious (activity logging)
  - SendSecurityWebhook (Discord alerts)
- ✅ Cleanup thread (auto-cleanup old data)
- ✅ Server event handlers (secure examples)
- ✅ Action handlers
- ✅ Callback registration examples
- ✅ Utility functions
- ✅ Player disconnect cleanup
- ✅ Resource stop cleanup
- ✅ Export examples

**Security Architecture:**
```lua
RegisterNetEvent('event', function(params)
    -- 1. Validate player
    -- 2. Rate limiting
    -- 3. Validate entity
    -- 4. Distance check
    -- 5. Cooldown check
    -- 6. Perform action
    -- 7. Set cooldown
end)
```

**Reference:** Follows `/redm-agent/standards/security.md`

---

### 6. `README.md` - Resource README Template
**Purpose:** Professional resource documentation

**Includes:**
- ✅ Full ASCII art header
- ✅ Server branding (wolves.land)
- ✅ **Standard Sections:**
  - Overview
  - Features (Core + Technical)
  - Requirements
  - Installation (step-by-step)
  - Configuration guide
  - Usage (players + developers)
  - Customization examples
  - Security information
  - Debug mode
  - Performance metrics
  - Support & documentation links
  - License & credits
  - Changelog
  - Roadmap
- ✅ Heavy section dividers throughout
- ✅ Professional formatting
- ✅ Placeholder sections for customization

**Reference:** Complete production-ready documentation

═══════════════════════════════════════════════════════════════════════════════

## 🚀 Quick Start

### Using the Templates

1. **Copy the entire templates directory** to your new resource:
   ```bash
   cp -r redm-agent/templates/ /path/to/your-new-resource/
   ```

2. **Rename the resource folder** to match your resource name:
   ```bash
   mv your-new-resource lxr-resourcename
   ```

3. **Update `config.lua`:**
   - Change `REQUIRED_RESOURCE_NAME` to your resource name
   - Update ASCII art title
   - Update description
   - Customize config sections

4. **Update `fxmanifest.lua`:**
   - Change resource name in ASCII art
   - Update name, description, repository
   - Add/remove script files as needed

5. **Update `framework-bridge.lua`:**
   - Update ASCII art title if needed
   - Customize if adding new framework functions

6. **Customize `client.lua` and `server.lua`:**
   - Add your resource-specific logic
   - Follow the examples provided
   - Use framework adapter functions

7. **Update `README.md`:**
   - Replace placeholders with your resource details
   - Update features list
   - Update usage instructions
   - Add screenshots if available

═══════════════════════════════════════════════════════════════════════════════

## 📋 Customization Checklist

### Required Changes
- [ ] Change resource folder name
- [ ] Update `REQUIRED_RESOURCE_NAME` in config.lua
- [ ] Update ASCII art titles (resource name)
- [ ] Update descriptions
- [ ] Update fxmanifest.lua metadata
- [ ] Update README.md overview and features

### Resource-Specific Changes
- [ ] Add resource-specific config sections
- [ ] Implement resource logic in client.lua
- [ ] Implement resource logic in server.lua
- [ ] Add target zones (if using ox_target)
- [ ] Add keybinds (if needed)
- [ ] Add locale translations
- [ ] Add resource-specific callbacks
- [ ] Update README.md usage section

### Optional Changes
- [ ] Add UI files
- [ ] Add database operations
- [ ] Add exports for other resources
- [ ] Add custom security checks
- [ ] Add Discord webhooks
- [ ] Customize performance settings

═══════════════════════════════════════════════════════════════════════════════

## 🎨 Branding Standards

All templates follow the branding standards from `/redm-agent/standards/branding-and-style.md`:

### ASCII Headers
- High-density ASCII art title
- Purpose statement
- SERVER INFORMATION block
- Version and performance target
- Tags list
- Framework support list
- Credits section with copyright

### Section Dividers
**Heavy Dividers** (for major sections):
```lua
-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 SECTION NAME
-- ═══════════════════════════════════════════════════════════════════════════════
```

**BIG Banners** (for config sections):
```lua
-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SECTION NAME ██████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
```

═══════════════════════════════════════════════════════════════════════════════

## 🔒 Security Standards

All templates follow security standards from `/redm-agent/standards/security.md`:

### Server-Side Validation
- ✅ Player state validation
- ✅ Distance validation
- ✅ Entity existence validation
- ✅ Cooldown enforcement
- ✅ Rate limiting
- ✅ Suspicious activity logging

### Best Practices
- Never trust client-provided data
- Validate all critical operations server-side
- Use server-side cooldowns
- Implement rate limiting
- Log suspicious activity
- Use Discord webhooks for alerts

═══════════════════════════════════════════════════════════════════════════════

## 🌉 Multi-Framework Standards

All templates follow multi-framework standards from `/redm-agent/standards/multi-framework.md`:

### Framework Priority
1. LXR-Core (Primary)
2. RSG-Core (Primary)
3. VORP Core (Supported)
4. RedEM:RP (Optional)
5. QBR-Core (Optional)
6. QR-Core (Optional)
7. Standalone (Fallback)

### Framework Adapter
- Unified API across all frameworks
- Automatic detection
- Clean fallback
- No framework-specific code in main logic

═══════════════════════════════════════════════════════════════════════════════

## 📚 Related Documentation

- [Branding & Style Standards](../standards/branding-and-style.md)
- [Configuration Standards](../standards/configuration.md)
- [Multi-Framework Support](../standards/multi-framework.md)
- [Security Standards](../standards/security.md)
- [FXManifest Standards](../standards/fxmanifest.md)
- [Resource Name Protection](../standards/resource-name-protection.md)

═══════════════════════════════════════════════════════════════════════════════

## 🤝 Support

### Questions or Issues?
- **Discord:** https://discord.gg/CrKcWdfd3A
- **Website:** https://www.wolves.land
- **GitHub:** https://github.com/iBoss21

### Contributing
Found an issue with the templates? Create an issue or pull request!

═══════════════════════════════════════════════════════════════════════════════

## 📜 License

© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved

These templates are provided for use in creating wolves.land branded resources.

═══════════════════════════════════════════════════════════════════════════════

**Made with ❤️ by iBoss21 / The Lux Empire**  
**For The Land of Wolves 🐺 | wolves.land**

*ისტორია ცოცხლდება აქ!* (History Lives Here!)

═══════════════════════════════════════════════════════════════════════════════
