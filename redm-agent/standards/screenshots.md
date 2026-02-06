# 🐺 Screenshots & Assets Requirements

```
██╗     ██╗  ██╗██████╗         ███████╗ ██████╗██████╗ ███████╗███████╗███╗   ██╗███████╗
██║     ╚██╗██╔╝██╔══██╗        ██╔════╝██╔════╝██╔══██╗██╔════╝██╔════╝████╗  ██║██╔════╝
██║      ╚███╔╝ ██████╔╝        ███████╗██║     ██████╔╝█████╗  █████╗  ██╔██╗ ██║███████╗
██║      ██╔██╗ ██╔══██╗        ╚════██║██║     ██╔══██╗██╔══╝  ██╔══╝  ██║╚██╗██║╚════██║
███████╗██╔╝ ██╗██║  ██║        ███████║╚██████╗██║  ██║███████╗███████╗██║ ╚████║███████║
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝        ╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═══╝╚══════╝
```

**Standard**: Screenshots & Assets (MANDATORY)  
**wolves.land | The Land of Wolves 🐺**

═══════════════════════════════════════════════════════════════════════════════

## Overview

Every resource MUST include documentation of required screenshots with a clear checklist for what visual documentation is needed.

═══════════════════════════════════════════════════════════════════════════════

## 📁 Storage Structure

```
/docs/
└── assets/
    └── screenshots/
        ├── 01_startup_console.png
        ├── 02_config_sections.png
        ├── 03_ui_interaction.png
        ├── 04_framework_detection.png
        ├── 05_discord_logs.png
        └── 06_txadmin_performance.png
```

═══════════════════════════════════════════════════════════════════════════════

## 📋 Required Screenshots

### 1. Startup Console (01_startup_console.png)

**What to Capture**:
- Server console output when resource starts
- Must show the branded startup banner
- Must show detected framework
- Must show version and configuration summary

**Requirements**:
- Clear, readable text
- Full startup banner visible
- No errors visible (or document any expected warnings)

**When Required**: Always

---

### 2. Config Sections (02_config_sections.png)

**What to Capture**:
- config.lua file open in editor
- Showing key sections with banners
- Clear view of section organization

**Requirements**:
- Syntax highlighting enabled
- Banner formatting visible
- Representative sections shown

**When Required**: Always

---

### 3. UI Interaction (03_ui_interaction.png)

**What to Capture**:
- Resource UI in active use
- Player interaction with the system
- Clear view of UI elements

**Requirements**:
- In-game screenshot
- UI elements clearly visible
- Good lighting/visibility
- Representative of typical usage

**When Required**: If resource has UI

---

### 4. Framework Detection (04_framework_detection.png)

**What to Capture**:
- Console output showing framework detection
- Framework adapter initialization messages
- Confirmation of correct framework loaded

**Requirements**:
- Clear framework name visible
- Detection process visible
- No errors

**When Required**: Always (multi-framework resources)

---

### 5. Discord Logs (05_discord_logs.png)

**What to Capture**:
- Discord webhook messages
- Security logs or event logs
- Formatted embeds

**Requirements**:
- Full embed visible
- Clear formatting
- Representative example

**When Required**: If resource includes Discord logging

---

### 6. txAdmin Performance (06_txadmin_performance.png)

**What to Capture**:
- txAdmin resources page
- Resource showing in list
- Performance metrics visible (ms, tick time, etc.)

**Requirements**:
- Resource name visible
- Performance metrics visible
- Other resources for context

**When Required**: Always

═══════════════════════════════════════════════════════════════════════════════

## 📸 Screenshot Guidelines

### Technical Requirements

**Resolution**: 
- Minimum: 1920x1080
- Recommended: 1920x1080 or 2560x1440
- No upscaling of lower resolution images

**Format**:
- PNG (preferred for clarity)
- JPEG acceptable if file size is concern
- No compression artifacts

**File Naming**:
- Use numbered prefix: `01_`, `02_`, etc.
- Use descriptive name: `startup_console`, `ui_interaction`
- Lowercase with underscores
- Example: `03_ui_interaction.png`

### Content Requirements

**Visibility**:
- All text must be readable
- No excessive blur or compression
- Adequate lighting for in-game shots

**Context**:
- Show relevant UI elements
- Include enough context to understand what's happening
- Crop out irrelevant screen areas

**Quality**:
- No low-quality or pixelated images
- Professional appearance
- Representative of actual usage

### In-Game Screenshots

**Lighting**:
- Use daytime for clarity
- Avoid extreme darkness
- Good visibility of all elements

**Location**:
- Choose clear, uncluttered areas
- Representative environments
- No distracting background elements

**Character**:
- Use default or clean outfit
- Position for clear view of interaction
- No blocking of important UI

═══════════════════════════════════════════════════════════════════════════════

## 📝 screenshots.md Template

Create `/docs/screenshots.md` with this structure:

```markdown
# 🐺 [Resource Name] - Screenshots

[ASCII Art]

**wolves.land | The Land of Wolves**

═══════════════════════════════════════════════════════════════════════════════

## Screenshot Checklist

### Required Screenshots

- [ ] **01_startup_console.png** - Server console on startup
- [ ] **02_config_sections.png** - Config.lua sections
- [ ] **03_ui_interaction.png** - UI in use [if applicable]
- [ ] **04_framework_detection.png** - Framework detection
- [ ] **05_discord_logs.png** - Discord webhook logs [if applicable]
- [ ] **06_txadmin_performance.png** - txAdmin performance metrics

### Optional Screenshots

- [ ] **07_feature_name.png** - [Feature description]
- [ ] **08_example_scenario.png** - [Scenario description]

═══════════════════════════════════════════════════════════════════════════════

## Screenshot Details

### 01 - Startup Console

Shows the resource starting up with branded banner and framework detection.

![Startup Console](./assets/screenshots/01_startup_console.png)

### 02 - Config Sections

Displays the config.lua file structure with section banners.

![Config Sections](./assets/screenshots/02_config_sections.png)

[Continue for each screenshot...]

═══════════════════════════════════════════════════════════════════════════════

## How to Capture

### Console Screenshots

1. Start your RedM server
2. Watch the console for the resource start
3. Capture the full startup output
4. Save as PNG

### In-Game Screenshots

1. Load into game with resource running
2. Position character appropriately
3. Use F8 console or screenshot tool
4. Ensure good lighting and visibility

### txAdmin Screenshots

1. Open txAdmin web interface
2. Navigate to Resources page
3. Locate your resource in the list
4. Capture showing performance metrics

═══════════════════════════════════════════════════════════════════════════════

© 2026 iBoss21 / The Lux Empire | wolves.land
```

═══════════════════════════════════════════════════════════════════════════════

## 🎯 When Screenshots Are Required

### Always Required
1. Startup console (01)
2. Config sections (02)
3. Framework detection (04)
4. txAdmin performance (06)

### Conditionally Required
- **UI interaction (03)**: If resource has any UI
- **Discord logs (05)**: If resource includes Discord webhooks
- **Feature-specific**: Additional screenshots for unique features

═══════════════════════════════════════════════════════════════════════════════

## ✅ Validation Checklist

- [ ] /docs/screenshots.md exists
- [ ] All required screenshots documented
- [ ] Screenshot checklist included
- [ ] File naming convention followed
- [ ] Resolution requirements met
- [ ] Format requirements met (PNG preferred)
- [ ] All images readable and clear
- [ ] Context provided for each screenshot
- [ ] Instructions for capturing included
- [ ] Conditional screenshots identified

═══════════════════════════════════════════════════════════════════════════════

## 🔗 Related Standards

- [Documentation Requirements](./documentation.md) - Overall docs structure
- [Delivery Format](./delivery-format.md) - What to include in delivery

═══════════════════════════════════════════════════════════════════════════════

© 2026 iBoss21 / The Lux Empire | wolves.land
