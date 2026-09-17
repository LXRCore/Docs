# LXR UI Kit

The genatsvale.shop design system, packaged for RedM NUI.

Version 1.0.0 · extracted from `src/app/globals.css` at commit `cafef82`

| File | What it is |
|---|---|
| `lxr-ui.css` | The stylesheet. Drop into any `lxr-*` resource and link it. |
| `index.html` | Live styleguide and working component examples. Open in a browser. |
| `LXR-UI-KIT.md` | This document. |

---

## 1. Before anything else: NUI is not a browser tab

RedM and FiveM render NUI in an embedded CEF build that trails mainline
Chromium. Four things the website depends on will fail there, and all four
fail **silently** — the rule is dropped, the page renders, and it just looks
wrong:

| Feature | Needs | What the kit does instead |
|---|---|---|
| `color-mix()` | Chrome 111+ | Precomputed `rgba()` values |
| `oklab` / `oklch` | Chrome 111+ | Never used |
| CSS nesting (`&:hover`) | Chrome 112+ | Every rule flattened |
| Google Fonts `@import` | Outbound internet | Fonts shipped in the resource |

Mixing any colour with `transparent` is arithmetically just an alpha scale,
so the precomputed values are exact, not eyeballed.

**Do not copy `src/app/globals.css` into a resource.** It is Tailwind v4
source with `@theme` and `@utility` blocks that mean nothing without a build
step. `lxr-ui.css` is the compiled, CEF-safe equivalent.

---

## 2. Colour

Six inks, one accent. No second hue.

### Ink

| Token | Hex | Role |
|---|---|---|
| `--lxr-void` | `#050506` | Page ground, deepest panel, primary-button text |
| `--lxr-pit` | `#0e0e11` | Raised surface — panel, card, toast |
| `--lxr-edge` | `#1e1e23` | Hairline borders and dividers |
| `--lxr-smoke` | `#58575e` | Decorative meta, disabled — **see contrast** |
| `--lxr-ash` | `#9b9aa0` | Body copy, secondary text |
| `--lxr-bone` | `#f4f2ee` | Primary text, primary-button fill |

No pure `#000` and no pure `#fff` anywhere. Pure black flattens depth over a
rendered game frame; pure white glares at night.

### Accent

| Token | Hex | Role |
|---|---|---|
| `--lxr-blood` | `#8d1226` | Deep — fills, glows, washes. Never text. |
| `--lxr-blood-lit` | `#c21c37` | Lit — hover, active, focus, destructive, alert |

**One accent. This is the hard rule.** No gold, no bronze, no brown, no
second hue. If two things compete and both want red, change one's weight or
size — not its colour.

### State

Green and amber exist **only** as status semantics — a meter that is
genuinely low, a job that genuinely succeeded. They are never decoration and
never a button colour.

| Token | Hex |
|---|---|
| `--lxr-ok` | `#3f9a6b` |
| `--lxr-warn` | `#b8862f` |
| `--lxr-bad` | `#c21c37` (the accent) |

### Alpha ramps

| Token | Value | Used by |
|---|---|---|
| `--lxr-bone-07` | `rgba(244,242,238,0.07)` | Ghost button hover fill |
| `--lxr-bone-26` | `rgba(244,242,238,0.26)` | Ghost button border |
| `--lxr-bone-40` | `rgba(244,242,238,0.40)` | Input focus border |
| `--lxr-blood-18` | `rgba(194,28,55,0.18)` | Soft glow |
| `--lxr-blood-34` | `rgba(141,18,38,0.34)` | Background wash |

### Contrast — measured against `--lxr-void`

| Colour | Ratio | Verdict |
|---|---|---|
| `bone` `#f4f2ee` | **18.2:1** | AA + AAA, any size |
| `ash` `#9b9aa0` | **7.3:1** | AA + AAA, any size |
| `blood-lit` `#c21c37` | **3.4:1** | Large text only (≥24px, or ≥19px bold) |
| `smoke` `#58575e` | **2.9:1** | **Fails AA at every size** |
| `blood` `#8d1226` | **2.2:1** | **Fails** — fill colour only |

Two consequences, and they are not optional:

1. `--lxr-smoke` is for decoration, disabled states, and text nobody has to
   read. The moment it carries meaning, use `--lxr-ash`.
2. `--lxr-blood-lit` works as a heading, an icon, or a border. It does not
   work as body copy. For a wine-coloured warning, put the wine on the border
   and the text in bone.

`bone` on `blood-lit` (the button hover state) is **5.3:1** — safe.

### What was deliberately excluded

`src/lib/brand.ts` declares four collection accents — vermilion `#ff3d2e`,
lapis `#2b4bff`, emerald `#00e0a4`, violet `#8b2bff`. They are **rendered
nowhere on the live site** (verified: no component reads `.accent`), and they
contradict the single-accent rule. They are not part of this kit. Do not
reintroduce them.

---

## 3. Typography

Four faces, four jobs, no overlap.

| Token | Face | Job |
|---|---|---|
| `--lxr-font-cut` | Fraunces (variable) | Headlines and numbers **at scale only** |
| `--lxr-font-plain` | Inter (variable) | Body copy, inputs, everything readable |
| `--lxr-font-code` | JetBrains Mono (variable) | Labels, keybinds, counters, nav |
| `--lxr-font-ka` | Noto Sans Georgian | Mkhedruli, when you print Georgian |

### The four classes

```html
<h1 class="lxr-cut lxr-title-lg">Wanted</h1>
<h1 class="lxr-cut-slant">dead or alive.</h1>
<span class="lxr-mono">Chapter 01 — Saint Denis</span>
<span class="lxr-num">$1,284.50</span>
<span class="lxr-ka" lang="ka">გენაცვალე</span>
```

**`.lxr-cut`** — Fraunces at `opsz 88`, line-height `0.94`, tracking
`-0.018em`. Never below ~22px: at small sizes its low contrast and tight
leading turn to mush. Never body copy.

**`.lxr-cut-slant`** — the same face italic with `WONK 1`. Used for the
second half of a two-part headline, usually at reduced opacity. One per
screen at most.

**`.lxr-mono`** — 11px uppercase at `0.18em` tracking. This is the single
most recognisable thing in the kit. Wide-tracked uppercase mono is what makes
an unfamiliar panel read as *yours*.

**`.lxr-num`** — tabular figures. Use it for anything that changes in place:
money, ammo, timers, weights. Without it the layout twitches on every digit.

**`.lxr-ka`** — Mkhedruli has thirty-three letters and **no uppercase**.
Never `text-transform` it, never track it out, and set `lang="ka"` on the
element as well as the class.

### Scale

Fixed px, not rem. NUI has no user font-size preference to respect, and a rem
scale invites a stray `html { font-size }` in one resource to resize another
resource's HUD.

| Token | px | Use |
|---|---|---|
| `--lxr-text-micro` | 11 | The mono label — the workhorse |
| `--lxr-text-sm` | 13 | Dense secondary |
| `--lxr-text-body` | 14 | Body |
| `--lxr-text-lg` | 17 | Lead paragraph |
| `--lxr-text-xl` | 22 | Row name, small heading |
| `--lxr-title` | 34 | Panel heading |
| `--lxr-title-lg` | 52 | Screen heading |

---

## 4. Space and geometry

4px base. Every gap is a multiple: `--lxr-s1` (4) through `--lxr-s8` (64).

**Radius is `0`.** The brand is editorial, not app-like. A 12px radius on
everything is the fastest way to make this look like every other NUI kit.
Only floating pills round, via `--lxr-radius-pill`.

Borders are always `1px`. There is no 2px border in this system except the
left rail of a toast.

---

## 5. Motion

Two curves:

| Token | Curve | For |
|---|---|---|
| `--lxr-ease` | `cubic-bezier(0.16, 1, 0.3, 1)` | Things arriving — decelerates hard |
| `--lxr-cut` | `cubic-bezier(0.7, 0, 0.16, 1)` | Things being replaced — fast in, fast out |

Durations: `--lxr-fast` 180ms, `--lxr-mid` 320ms, `--lxr-slow` 450ms.

| Class | Effect |
|---|---|
| `.lxr-rise` | Translate up 26px + fade in |
| `.lxr-wipe` | `clip-path` reveal from the bottom |
| `.lxr-pulse` | Slow opacity breathe, for a live indicator |
| `.lxr-scroller` | Infinite marquee — duplicate the track twice inside |
| `.lxr-letter` | Per-glyph rise out of a clipped box |
| `.lxr-stagger` | Auto 60ms delay ramp on the first 8 children |

### One gotcha worth knowing

`.lxr-letter` carries `padding-bottom: 0.26em; margin-bottom: -0.26em`. That
pair is load-bearing, not tidy-up. Fraunces' descenders are taller than its
`0.94` line-height, so a plain `overflow: hidden` clip box shears the tail off
every `y`, `g` and `p`. This exact bug shipped to production on the website
before it was caught.

Everything respects `prefers-reduced-motion`. Players do set it.

---

## 6. The index row — the signature pattern

**If you take one thing from this kit, take this.** It is the site's nav overlay,
and it is what makes an unfamiliar panel read as yours. Reach for it before you
reach for a grid of cards or a table.

```html
<button class="lxr-row">
  <span class="lxr-row-index">01</span>
  <span class="lxr-row-name">Saddlebags</span>
  <span class="lxr-row-meta">14 / 40</span>
</button>
```

### Four rules that keep it recognisable

| Part | Rule |
|---|---|
| `.lxr-row-index` | Always mono, always accent, always zero-padded — **01, never 1** |
| `.lxr-row-name` | Always the serif at scale. Never the sans. |
| `border-top` | Hairline on the **top** of each row, so a list reads open-ended rather than boxed in |
| `.lxr-row-meta` | Right-aligned by `margin-left: auto`, never a fixed column |

### What it replaces

| | |
|---|---|
| **Menus** | Stores, stables, crafting, job boards, dialogue trees |
| **Inventories** | Saddlebags, satchel, wagon, stash, player trade |
| **Rosters** | Players online, gang members, employees, wanted list |
| **Records** | Transactions, warrants, licences, deliveries, logs |
| **Settings** | Any enumerable list of toggles or bindings |

### Variants — same row, one thing added

Do not invent a new row shape. Add a modifier.

| Class | Effect |
|---|---|
| `.lxr-row--sub` | Two-line: a Georgian name, a description, a subtitle |
| `.lxr-row--compact` | Dense — 17px name, tighter padding, for long lists |
| `.is-active` | Selected. Accent moves to the name; the index stays put so the number column never jumps. |
| `.is-locked` | Unavailable. Dimmed rather than hidden — a player needs to see a thing exists before they can want it. |

Children: `-index` `-name` `-body` `-sub` `-ka` `-meta` `-price` `-badge`
`-lead` `-group` `-bar`.

```html
<!-- two-line, with a price -->
<button class="lxr-row lxr-row--sub">
  <span class="lxr-row-index">01</span>
  <span class="lxr-row-body">
    <span class="lxr-row-name">Khinkali Tee</span>
    <span class="lxr-row-ka" lang="ka">ხინკალი</span>
  </span>
  <span class="lxr-row-price">$48.00</span>
</button>

<!-- roster: leading status dot, trailing badge -->
<button class="lxr-row">
  <span class="lxr-row-index">01</span>
  <span class="lxr-row-lead"><span class="lxr-dot is-ok"></span></span>
  <span class="lxr-row-name">Arthur Morgan</span>
  <span class="lxr-row-badge">Lvl 24</span>
</button>
```

> **Build the list from this row before you reach for anything else.** A grid of
> cards is the generic answer and it costs you the one pattern that identifies
> the brand. If a screen genuinely cannot be a list, that is the moment to
> design something — not the default.

---

## 7. Other components

| Class | What |
|---|---|
| `.lxr-panel` | Opaque ink panel with hairline + lift shadow |
| `.lxr-well` | Deeper recess for a list or input |
| `.lxr-glass` | Blurred glass — **small floating controls only** |
| `.lxr-btn` | Primary — bone fill, wine on hover. One per screen. |
| `.lxr-btn-ghost` | Secondary — hairline. The default for most actions. |
| `.lxr-btn-bad` | Destructive — the only button wine at rest |
| `.lxr-btn-sm` | Size modifier for dense toolbars |
| `.lxr-input` | Text field |
| `.lxr-chip` | Segmented option / filter. `aria-pressed="true"` to select. |
| `.lxr-key` | Keybind glyph |
| `.lxr-meter` + `.lxr-meter-fill` | Progress / stamina bar |
| `.lxr-dot` | Status dot — `.is-ok` `.is-warn` `.is-bad` |
| `.lxr-toast` | Notification with coloured left rail |
| `.lxr-scrim` | Full-screen dim behind a modal |

### Two warnings

**Panels are opaque on purpose.** A translucent panel over a moving game
frame becomes unreadable the moment the player walks past a lit wall. Use
`.lxr-panel`, not `.lxr-glass`, for anything holding text.

**`backdrop-filter` costs whole frames** on a mid-range GPU. `.lxr-glass` is
for a toggle pill or a keybind hint. A full-screen glass panel will cost FPS
in a way players notice and blame your script for.

---

## 8. Wiring it into an `lxr-*` resource

### Layout

```
lxr-yourscript/
  fxmanifest.lua
  client/main.lua
  html/
    index.html
    lxr-ui.css
    app.js
    fonts/
      Fraunces.woff2
      Inter.woff2
      JetBrainsMono.woff2
      NotoSansGeorgian.woff2   -- only if you print Georgian
```

### `fxmanifest.lua`

```lua
fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/lxr-ui.css',
  'html/app.js',
  'html/fonts/*.woff2',
}

client_script 'client/main.lua'
```

`files` must list the fonts explicitly or CEF gets a 404 and silently falls
back to Georgia/Segoe UI — which still renders, so it is easy to ship broken.

### `html/index.html`

```html
<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
    <link rel="stylesheet" href="lxr-ui.css" />
  </head>
  <body class="lxr">
    <div id="app" class="lxr-hidden"></div>
    <script src="app.js"></script>
  </body>
</html>
```

`<body class="lxr">` is required — the whole kit is scoped to `.lxr` so it can
sit beside another script's CSS without fighting it.

### The pointer-events rule

`.lxr` sets `pointer-events: none` on everything. NUI is a full-screen
overlay, and without this your HUD swallows every click meant for the game.

Opt individual interactive panels back in with `.lxr-hit`:

```html
<!-- A HUD that must never eat a click -->
<div class="lxr-br">…</div>

<!-- A menu the player actually clicks -->
<div class="lxr-center lxr-panel lxr-hit">…</div>
```

### Client Lua

```lua
local open = false

RegisterNUICallback('close', function(_, cb)
  open = false
  SetNuiFocus(false, false)
  cb({ ok = true })
end)

RegisterCommand('lxrmenu', function()
  open = true
  -- SetNuiFocus(hasKeyboard, hasMouse). Both true for a menu; both false
  -- for a HUD, or the player cannot move.
  SetNuiFocus(true, true)
  SendNUIMessage({ action = 'open', payload = { money = 1284.50 } })
end)
```

### `html/app.js`

```js
const app = document.getElementById('app')

window.addEventListener('message', (e) => {
  const { action, payload } = e.data || {}
  if (action === 'open') {
    render(payload)
    app.classList.remove('lxr-hidden')
  }
  if (action === 'close') app.classList.add('lxr-hidden')
})

// ESC must always close. A player stuck in a focused NUI with no way out
// has to restart their game.
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') close()
})

function close() {
  app.classList.add('lxr-hidden')
  fetch(`https://${GetParentResourceName()}/close`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: '{}',
  })
}
```

`GetParentResourceName()` is injected by CEF — do not hardcode the resource
name, or renaming the folder breaks every callback.

---

## 9. Checklist before shipping a screen

- [ ] `<body class="lxr">`, interactive panels marked `.lxr-hit`
- [ ] Fonts listed in `files{}` and present in `html/fonts/`
- [ ] ESC closes, and `SetNuiFocus(false, false)` runs on close
- [ ] No `--lxr-smoke` on text a player has to read
- [ ] No `--lxr-blood-lit` on body copy — headings and borders only
- [ ] One `.lxr-btn` per screen; everything else is `.lxr-btn-ghost`
- [ ] Numbers that tick use `.lxr-num`
- [ ] Any list is `.lxr-row`, not a card grid or a table
- [ ] Georgian text is `.lxr-ka` **and** `lang="ka"`, never uppercased
- [ ] No `backdrop-filter` on anything full-screen
- [ ] Tested at 1920×1080 and 2560×1440 — NUI does not reflow like a website

---

## 10. Changing the palette for a different `lxr-*` brand

Every colour resolves from the six ink tokens and two accent tokens in
`:root`. To re-skin a resource, override those eight and nothing else:

```css
/* lxr-yourscript/html/theme.css — loaded AFTER lxr-ui.css */
:root {
  --lxr-blood: #1c4f8d;
  --lxr-blood-lit: #2f7fd4;
}
```

Do not override component classes. If a component needs a variant the kit
does not have, add it to `lxr-ui.css` so every resource gets it — the point
of a shared kit is that `lxr-inventory` and `lxr-jobs` cannot drift apart.
