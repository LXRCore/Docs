# LXRCore — Official Brand Logo

Canonical wolf mark for **every** `lxr-*` RedM script.

## Asset

| File | Use |
|------|-----|
| `GitHub/brand/lxrcore-logo.png` | **Studio master** — copy from here into every script |
| `docs/brand/lxrcore-logo.png` | Per-resource docs copy |
| `html/img/lxrcore-logo.png` | **Ship in every resource** — NUI header avatar |

**Do not rename** the NUI filename. Buyers and escrow tooling expect `img/lxrcore-logo.png`.

## NUI integration (required)

1. Copy `lxrcore-logo.png` into `html/img/`.
2. Ensure `fxmanifest.lua` `files{}` includes `html/img/*.png`.
3. Header markup:

```html
<div class="adm-store-banner__avatar-wrap adm-store-banner__avatar-wrap--lxrcore">
    <img class="adm-store-banner__avatar adm-store-banner__avatar--lxrcore" id="brand-logo"
         src="img/lxrcore-logo.png" alt="LXRCore" />
</div>
```

4. `Config.LXR.Brand.NuiLogo = 'img/lxrcore-logo.png'` — merged into NUI locale as `nui_logo`.
5. `app.js` `updateChrome()` sets `#brand-logo` from `nuiT('nui_logo', 'img/lxrcore-logo.png')`.

## CSS (canonical design system)

`:root` token: `--img-lxrcore-logo: url("img/lxrcore-logo.png");`

Use `.adm-store-banner__avatar-wrap--lxrcore` (charcoal tile + gold edge) so the white wolf reads on the cream banner.

## HUDs & session chrome

When a script uses `.lxr-session-hud` or `.lxr-guide-hud`, set `__brand` background to `--img-lxrcore-logo` (contain, no repeat).

## Tebex / Discord

Use this logo on hero banners and store thumbnails. Pair with `www.lxrcore.com` — not legacy Tebex URLs.

© 2026 iBoss21 / LXRCore | lxrcore.com
