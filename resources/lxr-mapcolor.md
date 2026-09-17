<img src="https://raw.githubusercontent.com/LXRCore/.github/main/profile/lxrcore-logo.png" alt="LXRCore" width="72" align="left" style="margin-right:12px">

# lxr-mapcolor — one colour for the whole map

Standalone RedM resource. Picks a theme (`Config.Theme`) and:

* redraws the route to your waypoint as a GPS multi-route in the theme colour
  (RDR3 has no `ReplaceHudColourWithRgba`; routes take named colours such as
  `COLOR_GOLD`);
* exposes the theme to every other LXR resource so job / shop / stable blips
  share it:

```lua
local mod = exports['lxr-mapcolor']:modifier()      -- BLIP_MODIFIER_MP_COLOR_n hash
Citizen.InvokeNative(0x662D364ABF16DE2F, blip, mod)  -- BLIP_ADD_MODIFIER
local r, g, b = table.unpack(exports['lxr-mapcolor']:rgb())
```

* `/mapcolor <preset>` lets a player pick their own (saved in KVP);
  `exports['lxr-mapcolor']:setTheme('bluelight')` from scripts.

**Status:** syntax-checked; NOT TESTED in-game (route natives from the RDR3
native DB: `START_GPS_MULTI_ROUTE`, `ADD_POINT_TO_GPS_MULTI_ROUTE`,
`SET_GPS_MULTI_ROUTE_RENDER`).

© 2026 iBoss21 / LXRCore | lxrcore.com | All Rights Reserved — see LICENSE.
