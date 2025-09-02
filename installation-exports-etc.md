---

# 🌐 LXRCore

*A Lightweight & Flexible RedM Framework Core*

LXRCore is the central backbone of **The Lux Empire’s RedM development ecosystem**, designed to provide developers with a **clean, extensible, and secure foundation** for creating advanced roleplay systems.

It manages **player data, inventory, callbacks, usable items, notifications, and localization**, while being **framework-agnostic** and highly customizable.

---

## 📦 Features

* 🔑 **Core Object Access** – exportable across all scripts via `exports['lxrcore']:GetCoreObject()`.
* 🎒 **Inventory Functions** – add, remove, and use items with metadata support.
* 🧑 **Player Management** – load, store, and retrieve player data server ↔ client.
* 🛠 **Callbacks** – register and trigger server ↔ client callbacks with ease.
* 📢 **Notifications** – built-in notify system for both server and client.
* 🌍 **Localization** – configurable multi-language support with variable substitution.
* 📊 **Progress Bars** – simple client-side progress bar functionality.
* 🔌 **Extensible** – easily integrates with crafting, job systems, HUDs, and custom UIs.

---

## ⚙️ Installation

1. Clone into your `resources/` directory:

   ```bash
   git clone https://github.com/yourname/lxrcore.git
   ```

2. Add to your `server.cfg`:

   ```cfg
   ensure lxrcore
   ```

3. Make sure **LXRCore** is loaded before any dependent scripts.

---

## 🏗 Architecture Overview

### Server Side

* Initializes **Players**, **Items**, and **Functions** containers.
* Handles player loading, inventory manipulation, and item usage.
* Provides exports for other scripts.

### Client Side

* Manages **PlayerData**, **local inventory**, and **progress events**.
* Handles callbacks and UI updates.
* Integrates with notifications and localization.

### Common Functions

* `Notify()` → unified notify system (server & client).
* `Locale()` → dynamic localization.
* `Config` → language, events, translations.

---

## 📚 Developer Usage

### 🔗 Access Core

```lua
local LXRCore = exports['lxrcore']:GetCoreObject()
```

---

### 🎒 Inventory Management

**Add Item**

```lua
LXRCore.Functions.AddItem(src, "bread", 2, { quality = "fresh" })
```

**Remove Item**

```lua
LXRCore.Functions.RemoveItem(src, "bread", 1, { quality = "fresh" })
```

**Use Item**

```lua
LXRCore.Functions.UseItem("health_potion")
```

---

### 🧑 Player Data

**Get Player Data**

```lua
local playerData = LXRCore.Functions.GetPlayerData(src)
print(playerData.cash, playerData.gold)
```

**On Player Load**

```lua
RegisterNetEvent("LXRCore:Client:OnPlayerLoaded")
AddEventHandler("LXRCore:Client:OnPlayerLoaded", function()
    print("Player loaded into the game.")
end)
```

---

### 🛠 Callbacks

**Register Server Callback**

```lua
LXRCore.Functions.RegisterCallback("GetPlayerStats", function(src, cb)
    local data = LXRCore.Functions.GetPlayerData(src)
    cb(data)
end)
```

**Trigger Callback from Client**

```lua
LXRCore.Functions.TriggerServerCallback("GetPlayerStats", function(data)
    print("Cash:", data.cash)
end)
```

---

### 📢 Notifications

**Server Side**

```lua
Notify({ source = src, text = "Welcome to the server!", time = 5000, type = "info" })
```

**Client Side**

```lua
Notify({ text = "You received a new item!", time = 5000, type = "success" })
```

---

### ⏳ Progress Bars

```lua
LXRCore.Functions.Progress("Crafting Item...", 5000, function()
    print("Craft complete!")
end)
```

---

### 🌍 Localization

**Example Config**

```lua
Config.Language = "en"
Config.Locale = {
    en = {
        welcome = "Welcome to LXRCore!",
        item_not_found = "Item not found: ${item}",
    },
    ge = {
        welcome = "მოგესალმებით LXRCore-ში!",
        item_not_found = "ვერ მოიძებნა ნივთი: ${item}",
    }
}
```

**Usage**

```lua
print(Locale("item_not_found", { item = "Magic Sword" }))
```

---

## 🧩 API Reference

| Function                                                   | Side   | Description                             |
| ---------------------------------------------------------- | ------ | --------------------------------------- |
| `GetCoreObject()`                                          | Both   | Returns the LXRCore object.             |
| `LXRCore:Initialize()`                                     | Both   | Initializes framework on client/server. |
| `LXRCore.Functions.AddItem(src, item, count, metadata)`    | Server | Adds item to player’s inventory.        |
| `LXRCore.Functions.RemoveItem(src, item, count, metadata)` | Server | Removes item.                           |
| `LXRCore.Functions.UseItem(item)`                          | Client | Uses item from inventory.               |
| `LXRCore.Functions.GetPlayerData(src)`                     | Server | Returns player data.                    |
| `LXRCore.Functions.RegisterUsableItem(item, cb)`           | Server | Registers usable item.                  |
| `LXRCore.Functions.RegisterCallback(event, cb)`            | Server | Register server callback.               |
| `LXRCore.Functions.TriggerServerCallback(event, cb, ...)`  | Client | Trigger callback and get result.        |
| `LXRCore.Functions.Progress(text, time, cb)`               | Client | Runs progress bar.                      |
| `Notify(data)`                                             | Both   | Sends a notification.                   |
| `Locale(key, subs)`                                        | Both   | Translates a string.                    |

---

## 🔒 Best Practices

* ✅ Always validate metadata before removing/adding items.
* ✅ Use callbacks instead of direct `TriggerClientEvent` when expecting return data.
* ✅ Load LXRCore before dependent scripts.
* ✅ Keep translations updated for multi-language servers.
* 🚫 Don’t trust client data — always check server side.

---

## 🤝 Contributing

We welcome contributions!

1. Fork the repo
2. Create a new branch (`feature/my-feature`)
3. Commit changes (`git commit -m "Added feature"`)
4. Push to branch and open a PR

---

## 📜 License

Released under the **MIT License**.

---
