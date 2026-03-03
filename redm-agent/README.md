# 🐺 RedM Engineering Agent - Production-Grade Development Standards

```
██╗     ██╗  ██╗██████╗         ██████╗ ███████╗██████╗ ███╗   ███╗
██║     ╚██╗██╔╝██╔══██╗        ██╔══██╗██╔════╝██╔══██╗████╗ ████║
██║      ╚███╔╝ ██████╔╝        ██████╔╝█████╗  ██║  ██║██╔████╔██║
██║      ██╔██╗ ██╔══██╗        ██╔══██╗██╔══╝  ██║  ██║██║╚██╔╝██║
███████╗██╔╝ ██╗██║  ██║        ██║  ██║███████╗██████╔╝██║ ╚═╝ ██║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚═╝  ╚═╝╚══════╝╚═════╝ ╚═╝     ╚═╝
                                                                     
    ███████╗███╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗███████╗██████╗ 
    ██╔════╝████╗  ██║██╔════╝ ██║████╗  ██║██╔════╝██╔════╝██╔══██╗
    █████╗  ██╔██╗ ██║██║  ███╗██║██╔██╗ ██║█████╗  █████╗  ██████╔╝
    ██╔══╝  ██║╚██╗██║██║   ██║██║██║╚██╗██║██╔══╝  ██╔══╝  ██╔══██╗
    ███████╗██║ ╚████║╚██████╔╝██║██║ ╚████║███████╗███████╗██║  ██║
    ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝  ╚═╝
```

**The Land of Wolves 🐺 | wolves.land**  
*Production-Grade RedM Resource Development Standards*

═══════════════════════════════════════════════════════════════════════════════

## 🎯 Mission

CREATE, CONVERT, or REFACTOR ANY RedM resource into the exact **Land of Wolves / LXR** codebase style while **SUPPORTING MULTIPLE FRAMEWORKS**.

This documentation defines the **authoritative production-grade standards** for all RedM resources developed for The Land of Wolves ecosystem, created by **iBoss21 / The Lux Empire**.

═══════════════════════════════════════════════════════════════════════════════

## 📋 Table of Contents

### Core Standards
1. [**Branding & File Style**](./standards/branding-and-style.md) - Non-negotiable presentation standards
2. [**Multi-Framework Support**](./standards/multi-framework.md) - Framework auto-detection and adapter architecture
3. [**Events & Triggers**](./standards/events-and-triggers.md) - Correct per-framework event patterns
4. [**Resource Name Protection**](./standards/resource-name-protection.md) - Runtime validation guards
5. [**Configuration Standards**](./standards/configuration.md) - Config structure and organization
6. [**FXManifest Standards**](./standards/fxmanifest.md) - Branded manifest requirements
7. [**Security & Server Authority**](./standards/security.md) - Anti-cheat and validation
8. [**Documentation Requirements**](./standards/documentation.md) - Required docs structure
9. [**Screenshots & Assets**](./standards/screenshots.md) - Visual documentation requirements
10. [**Delivery Format**](./standards/delivery-format.md) - Output order and completeness
11. [**Tebex Escrow Compliance**](./standards/tebex-escrow.md) - Requirements for Tebex store submission

### Templates
- [**Config Template**](./templates/config.lua) - Full branded config.lua
- [**FXManifest Template**](./templates/fxmanifest.lua) - Branded fxmanifest.lua
- [**Framework Bridge Template**](./templates/framework-bridge.lua) - Multi-framework adapter
- [**Client Template**](./templates/client.lua) - Branded client script
- [**Server Template**](./templates/server.lua) - Branded server script
- [**README Template**](./templates/README.md) - Resource README structure

### Examples
- [**Complete Example Resource**](./examples/lxr-example/) - Full working example demonstrating all standards

### Quick References
- [**Validation Checklist**](./validation-checklist.md) - Pre-delivery validation
- [**Common Patterns**](./common-patterns.md) - Recommended approaches
- [**Anti-Patterns**](./anti-patterns.md) - What NOT to do

═══════════════════════════════════════════════════════════════════════════════

## 🎨 Framework Priority

All resources **MUST** support framework auto-detection with the following priority:

### Primary Frameworks (Mandatory)
1. **LXR-Core** - Primary framework
2. **RSG-Core** - Primary framework  
3. **VORP Core** - Supported/Legacy

### Optional Frameworks
Include **ONLY** if they exist in source being converted or user explicitly requests:
- RedEM:RP
- QBR-Core
- QR-Core
- Standalone (always as fallback)

═══════════════════════════════════════════════════════════════════════════════

## 🔑 Hard Requirements

✅ **MUST HAVE:**
- Preserve working logic and compatibility
- Rebrand presentation, configuration, headers, banners, documentation
- Events/triggers correct per framework (NO FAKE EVENTS)
- Match Land of Wolves style (high-density ASCII, heavy banners, runtime guards)
- Multi-framework adapter architecture
- Server-side security and validation
- Complete branded documentation

❌ **FORBIDDEN:**
- Minimal/generic "clean configs"
- Invented/fake framework events
- Client-trusted data for critical operations
- Missing branding headers
- Incomplete documentation

═══════════════════════════════════════════════════════════════════════════════

## 📦 Canonical Server Info

Unless explicitly overridden by user, use this in `Config.ServerInfo`:

```lua
Config.ServerInfo = {
    name          = 'The Land of Wolves 🐺',
    tagline       = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description   = 'ისტორია ცოცხლდება აქ!', -- History Lives Here!
    type          = 'Serious Hardcore Roleplay',
    access        = 'Discord & Whitelisted',
    website       = 'https://www.wolves.land',
    discord       = 'https://discord.gg/CrKcWdfd3A',
    github        = 'https://github.com/iBoss21',
    store         = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',
    developer     = 'iBoss21 / The Lux Empire',
    tags          = {'RedM','Georgian','SeriousRP','Whitelist','Economy','RPG'}
}
```

═══════════════════════════════════════════════════════════════════════════════

## 🏗️ Quick Start

### For Developers Creating New Resources

1. Read [Branding & File Style](./standards/branding-and-style.md)
2. Copy [Config Template](./templates/config.lua)
3. Copy [FXManifest Template](./templates/fxmanifest.lua)
4. Copy [Framework Bridge Template](./templates/framework-bridge.lua)
5. Review [Complete Example](./examples/lxr-example/)
6. Review [Tebex Escrow Compliance](./standards/tebex-escrow.md)
7. Validate with [Validation Checklist](./validation-checklist.md)

### For Developers Converting Resources

1. Understand existing resource logic
2. Read all standards documents
3. Copy templates as starting point
4. Preserve core functionality
5. Apply branding and structure
6. Implement framework adapter
7. Create full documentation
8. Validate before delivery

### For AI Agents/Tools

Follow standards **EXACTLY** as written. Any deviation from the specification results in **INVALID** output that must be corrected.

═══════════════════════════════════════════════════════════════════════════════

## 🔗 Related Resources

- **LXR Core Framework**: [github.com/LXRCore](https://github.com/LXRCore)
- **Reference Implementation**: [lxr-proploot](https://github.com/iboss21/lxr-proploot)
- **Server**: [The Land of Wolves](https://servers.redm.net/servers/detail/8gj7eb)
- **Discord**: [Join Community](https://discord.gg/CrKcWdfd3A)
- **Store**: [Tebex](https://theluxempire.tebex.io)
- **Website**: [wolves.land](https://www.wolves.land)

═══════════════════════════════════════════════════════════════════════════════

## 📜 License & Credits

**Author**: iBoss21 / The Lux Empire  
**Owner/Brand**: 🐺 wolves.land — The Land of Wolves (The Lux Empire)  
**Copyright**: © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved

═══════════════════════════════════════════════════════════════════════════════

## ⚠️ Final Rule

Output must **look and feel** authored by **iBoss21** for **wolves.land**:
- Big ASCII mega headers
- Heavy █████ banners
- Runtime name guard
- Multi-framework auto-detect + adapter layer
- Branded docs + screenshot requirements
- Boot print banner

**If anything is missing → FAIL and correct immediately.**

═══════════════════════════════════════════════════════════════════════════════
