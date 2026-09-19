# Handoff — mouse / keyboard camera control in the creator and the tailor

Written 2026-09-19 for another Claude session. This is how `lxr-creator` (character creation) and
`lxr-clothing` (tailor / wardrobe) let the player turn the ped by dragging, zoom with the wheel and
move the camera height with W/S — the feel of the tgiann-style FiveM screens, on our own code.
Everything below is shipped and live on the owner's test server (both resources at 3.0.0).

## The idea in one paragraph

The NUI page has keyboard *and* mouse focus while these screens are open (`SetNuiFocus(true, true)`),
so the game never sees Q/E/W/S or the mouse — a Lua `IsControlPressed` loop is dead there. So the
**page** listens to `mousedown / mousemove / mouseup / wheel / keydown` and posts small *relative*
nudges to Lua (`{ turn = deg }`, `{ zoom = ±1 }`, `{ height = ±1 }`). Lua applies them to the ped
heading and to a single scripted camera it already owns, then tells the page the new normalised
zoom/height so the on-screen sliders follow. No per-frame thread anywhere; the resources stay 0.00 ms.

## Files

| Resource | Page side | Lua side | Config |
|---|---|---|---|
| lxr-creator | `html/app.js` — block "the scene: drag to turn, wheel to zoom…" (≈ line 400) — posts `cr:nudge`; `case 'creator:cam'` (≈ line 537) receives the slider sync | `client/creator.lua` — `RegisterNUICallback('cr:nudge')` (≈ line 253), `frame(key, cut)` (≈ line 25) | `config.lua` `Camera.fovRange = {15, 50}`, `Camera.heightRange = {-0.8, 0.6}`, `Camera.cameras.<key>.offset/.look/.fov` |
| lxr-clothing | `html/app.js` — keydown block (≈ line 260) and "the scene: drag to turn…" (≈ line 278) — posts `nudge`; the `message` listener applies `action = 'cam'` | `client/main.lua` — `RegisterNUICallback('nudge')` (≈ line 190), `camUpdate()` (≈ line 74), `camOff(embedded)` (≈ line 97) | `config.lua` `Camera.heightRange`, `Camera.fovRange`, `Camera.<kind>.offset/.look`, `Camera.transitionMs` |
| lxr-barber | `html/app.js` — same block, posts `nudge`; `action = 'cam'` syncs the H/Z/R sliders | `client/main.lua` — `RegisterNUICallback('nudge')`: **turn orbits the camera** (`session.cam.angle`), the customer stays in the chair | `config.lua` `Camera.fovRange / heightRange` |
| both | `html/style.css` — `body.is-dragging, body.is-dragging * { cursor: grabbing !important; user-select: none }` | | |

## Page side (identical in both, only the callback name differs)

```js
// only the empty scene counts: panels, inputs, buttons, pins and the camera sliders keep their own mouse
const onScene = (e) => open() && !e.target.closest('.lxr-hit, input, button, select, textarea, #look-panel, #look-cam, #pins .pin');
let drag = null, pending = 0, raf = 0;
const flushTurn = () => { raf = 0; if (pending) { postNUI('cr:nudge', { turn: pending }); pending = 0; } };
document.addEventListener('mousedown', (e) => { if (e.button === 0 && onScene(e)) { drag = e.clientX; document.body.classList.add('is-dragging'); } });
document.addEventListener('mousemove', (e) => { if (drag === null) return; pending += (e.clientX - drag) * 0.4; drag = e.clientX; if (!raf) raf = requestAnimationFrame(flushTurn); });
document.addEventListener('mouseup',   () => { if (drag !== null) { drag = null; document.body.classList.remove('is-dragging'); flushTurn(); } });
document.addEventListener('wheel', (e) => { if (onScene(e)) postNUI('cr:nudge', { zoom: e.deltaY < 0 ? 1 : -1 }); }, { passive: true });
document.addEventListener('keydown', (e) => {
    if (!open()) return;
    if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;   // a focused bar keeps its own arrows
    const k = e.key.toLowerCase();
    if (k === 'q' || k === 'a' || k === 'arrowleft') postNUI('cr:nudge', { turn: -15 });
    else if (k === 'e' || k === 'd' || k === 'arrowright') postNUI('cr:nudge', { turn: 15 });
    else if (k === 'w' || k === 'arrowup') postNUI('cr:nudge', { height: 1 });
    else if (k === 's' || k === 'arrowdown') postNUI('cr:nudge', { height: -1 });
    else return;
    e.preventDefault();
});
```

Points that matter:
* **Horizontal drag only** — `clientX` delta × 0.4 = degrees. Accumulated into `pending` and flushed
  once per animation frame (`requestAnimationFrame`), so a fast drag is one NUI callback per frame,
  not one per mouse event. The last partial is flushed on `mouseup`.
* `onScene()` is the gate: dragging on a slider, a chip, a pin label or a panel must *not* turn the
  ped. Every interactive region is in that `closest()` selector list — when you add a new panel class,
  add it there (lxr-clothing's list is `.cl-panel, .cl-cam, .cl-var, .cl-detail`).
* Wheel is `passive: true` (never `preventDefault`), direction: wheel up = zoom in.
* Keys: Q/E and A/D and ←/→ turn 15° per press; W/S and ↑/↓ move the camera height one step. The
  `INPUT` guard is what lets a focused range slider keep ←/→ for its own value (the tailor's detail
  panel additionally routes ↑/↓ to move focus between its bars/steppers — see the `inDetail` block).
* `is-dragging` on `<body>` switches the cursor to `grabbing` and disables text selection for the
  drag's duration.

## Lua side

```lua
-- lxr-creator/client/creator.lua
RegisterNUICallback('cr:nudge', function(d, cb)
    if not st then return cb('no') end
    local ped = PlayerPedId()
    if d.turn then SetEntityHeading(ped, (GetEntityHeading(ped) + (tonumber(d.turn) or 0)) % 360) end
    local moved = false
    if d.zoom   then st.cam.fov = math.max(C.fovRange[1],    math.min(C.fovRange[2],    st.cam.fov - (tonumber(d.zoom) or 0) * 3.0))    moved = true end
    if d.height then st.cam.h   = math.max(C.heightRange[1], math.min(C.heightRange[2], st.cam.h   + (tonumber(d.height) or 0) * 0.05)) moved = true end
    if moved then
        frame(currentPinCameraKey or 'body')   -- re-aim the one scripted camera
        SendNUIMessage({ action = 'creator:cam',
            z = (C.fovRange[2] - st.cam.fov) / (C.fovRange[2] - C.fovRange[1]),
            h = (st.cam.h - C.heightRange[1]) / (C.heightRange[2] - C.heightRange[1]) })
    end
    cb('ok')
end)
```

* **Turn** = `SetEntityHeading` on the ped, relative. The camera is anchored to the ped's *world*
  position, not its heading, so turning the ped turns the model in front of a fixed camera (the way
  a tailor's mirror works). The creator's `Scene.CamOnPed` and the tailor's `camUpdate()` both compute
  the camera from `GetOffsetFromEntityInWorldCoords(ped, offset)` — that offset **does** rotate with the
  ped, which is why the camera stays in front of the face while the player spins it. If a future
  screen wants the camera to orbit instead of the ped turning, rotate the offset vector and leave
  the heading alone.
* **Zoom** = FOV: one wheel notch = 3° of FOV, clamped to `fovRange` (15 close-up … 50 full body).
* **Height** = a Z offset added to both the camera position and its look-at point (`c.offset.z + h`,
  `c.look.z + h`), one key press = 0.05 m, clamped to `heightRange`.
* State lives in the session table (`st.cam` / `session.cam`), so the camera survives category
  changes: the creator's `frame(key)` and the tailor's `camUpdate()` always add the current `h` and use
  the current `fov` on top of the per-category preset (`Camera.cameras.head/body/legs…`).
* After every zoom/height change Lua sends the **normalised** 0..1 values back (`creator:cam` /
  `cam`), and the page sets the H/Z range sliders to them — the sliders and the wheel/keys never
  disagree. The sliders themselves post the absolute form (`cr:cam { h = 0..1 }` / `camera { h, z, r }`).
* One camera object per screen: the creator renders through `Scene.CamOnPed` (cut or interpolated,
  keyed by `key:h:fov` so an unchanged frame is not re-created); the tailor keeps `cam` and only
  `SetCamCoord/PointCamAtCoord/SetCamFov` it after the first `RenderScriptCams(true, …)`.
  `SetCamFocusDistance(cam, #(pos - look))` keeps the DOF on the ped.
* **Embedded tailor** (the wardrobe opened from inside the creator): `camOff(embedded)` only destroys
  its own cam and does *not* call `RenderScriptCams(false)` — that would drop the creator's camera
  too (this was the "camera stuck on gameplay cam after wardrobe" bug). The creator calls
  `Scene.CamReset()` and re-frames when the wardrobe hands back.

## The tick sound (murphy's mechanical click)

Ranges and steppers play `Amount_Increase` / `Amount_Decrease` from the `HUD_Donate_Sounds` set on
each step, throttled to one tick per 28 ms so a fast drag does not machine-gun:

```js
let lastTick = 0;
function tick(dir) { const now = performance.now(); if (now - lastTick < 28) return; lastTick = now;
    post('sound', { name: dir < 0 ? 'Amount_Decrease' : 'Amount_Increase', set: 'HUD_Donate_Sounds' }); }
```
Lua: `RegisterNUICallback('sound', function(d, cb) PlaySoundFrontend(d.name, d.set or 'HUD_SHOP_SOUNDSET', true, 0) cb('ok') end)`.
Every range has ‹ › arrow buttons on both ends (`.rng__arrow`, `stepRange(input, ±1)`) so it can be
driven by mouse, and ←/→ when focused; steppers (`.stp`) are the same for discrete variations/tints.

## Adding this to another screen (checklist)

1. Page: copy the block above; rename the callback; put every panel/control class into `onScene()`.
2. Lua: a `nudge` callback that mutates `session.cam.{fov,h}` + `SetEntityHeading`, re-aims the one
   camera, and sends the normalised sync message; clamp with the config ranges.
3. Config: `Camera.fovRange`, `Camera.heightRange`, per-view `offset`/`look`.
4. CSS: `.lxr body.is-dragging, .lxr body.is-dragging * { cursor: grabbing !important; user-select: none; }`
5. Run `python tools/js_check.py <repo>`, `python tools/lua_check.py <repo>`, `python tools/kit_check.py <repo>`.
6. No `Wait(0)` loops for input — the page has focus, the game does not see keys.

## Known limits / open items
* Drag is horizontal only (no vertical orbit) — by design, matches the reference feel.
* The creator's spawn-page and character-select pages do not take nudges (`lookOpen()` gate).
* Touch/pen not handled (irrelevant for RedM).
