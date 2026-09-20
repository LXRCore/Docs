# Character+ vs every creator / clothing / barber on the RedM market — feature matrix

2026-09-20. Sources: the forum topics and stores read on 2026-09-19 (`docs/MARKET-CHARACTER-SUITE.md`), the free
baseline's code (rsg-appearance, rsg-wardrobe, rsg-barbers, vorp_character, vorp_clothingstores, vorp_barbershop in
the reference clones), and our own code. "✓" = shipped and verified (offline suite, live server or page test);
"○" = claimed by the seller, not verifiable without buying; "—" = absent.

## Creator / select / spawn

| Feature | **LXR Creator+** | Murphy Creator | CAS | RCO-Identity | RW | Valenor | rsg-multichar + appearance | vorp_character |
|---|---|---|---|---|---|---|---|---|
| Frameworks | ✓ LXRCore · RSG (qbr/qr) · VORP · standalone | ○ VORP/RSG/QBR/RedEM | ○ VORP + RSG | ○ RSG + VORP | VORP | VORP | RSG | VORP |
| Own select scene (room, posed characters, click a name in the world) | ✓ Guarma cliff, six slots, pins | ○ | ○ | ○ | ○ cinematic | ○ | menu | menu |
| Pin creator (bone-anchored labels, 2D pads, sliders, variation steppers) | ✓ 66 face sliders, 21 overlay layers | ○ pins | ○ | ○ | — | — | menu | menu |
| Mouse camera (drag orbit, wheel zoom, W/S height, ticks) | ✓ | ○ | — | — | ○ | — | — | — |
| Skin tint palettes + mixed random | ✓ | ○ | — | — | — | — | — | — |
| Character traits step (perks / flaws / skills, budgets, presets, linked flaws) | ✓ 63-trait engine, published modifiers for other scripts | — | — | — | — | — | — | — |
| Spawn map (towns with region / services, last position, random, arrival protection) | ✓ | ○ selector | ○ | ○ | — | — | rsg-spawn | vorp spawn |
| Identity validation server-side (names, birth years, blocklist, Unicode) | ✓ EN + Georgian | ○ | ○ | ○ | ○ | ○ | basic | basic |
| Slots per licence / ace / per-identifier | ✓ | ○ | ○ | ○ Discord roles | — | — | config | users.char |
| Legacy character import (rsg / vorp looks) | ✓ hash-driven, dry run, export back | — | — | — | — | — | n/a | n/a |
| Escrow layout with open bridge + docs set | ✓ 7 docs | ○ | ○ | ○ | ○ | ○ | open | open |

## Clothing / tailor / wardrobe

| Feature | **LXR Tailor+** | Murphy Clothing | JOS Clothing Store | RCO (stores) | MulderDev | rsg-wardrobe / clothing | vorp_clothingstores |
|---|---|---|---|---|---|---|---|
| MP catalogue pieces | ✓ 112 / 74 categories, every hash the game has (harvested tables) | ○ | ○ | ○ 15,700 | ○ | lists | lists |
| NPC-model garments on player peds (bespoke) | ✓ with albedo / normal / material variants | ○ | ○ add-on €20 | ○ | — | — | — |
| Tints / colourways per piece | ✓ palette + 3 channels | ○ | ○ add-on €10 | ○ | — | — | tints |
| Wearable states (sleeves, collar, tucked, holster side, pomade) | ✓ | ○ | — | — | — | — | — |
| Basket with per-garment price, dye price, town price multiplier | ✓ | ○ | ○ | ○ | — | flat | flat |
| Outfits (save / wear / rename / delete / pack as item to hand over) | ✓ | ○ | ○ premade add-on €40 | ○ | 10 outfits | ✓ | ✓ |
| Job lockers + `/uniform` | ✓ | — | — | — | — | — | — |
| Wardrobes at runtime for housing / camps (export) | ✓ | ○ | — | — | — | — | — |
| Clothing wheel (categories on/off, states, undress) | ✓ lxr-clothingradial (free) | — | ○ add-on €15 | — | — | — | — |
| Mannequins showing outfits in the store | **→ added today** (`Config.Mannequins`) | — | ○ add-on €30 | — | — | — | — |
| Ready-made outfits for sale at the counter | **→ added today** (`Config.ReadyOutfits`) | — | ○ add-on €40 | — | ✓ 10 | — | — |
| Special skins (vampire, zombie …) | ✓ presets | — | — | — | — | — | — |
| Live-preview posts, no server round trip per click | ✓ | ○ | ○ | ○ | ○ | menu | menu |
| Migration from rsg-appearance / qbr / vorp with dry run + export | ✓ | — | — | — | — | n/a | n/a |
| Auto SQL install, configurable tables / schema | ✓ | ○ | ○ | ○ | sql file | sql file | sql file |

## Barber

| Feature | **LXR Barber+** | Murphy Barber | RicX Barber Shops | rsg-barbers | vorp_barbershop |
|---|---|---|---|---|---|
| Hair + four beard slots + bonnet, MP and bespoke NPC | ✓ | ○ | ○ | lists | lists |
| Tints | ✓ | ○ | ○ | — | tints |
| Makeup layers (eyeliner, shadow, lipstick, blush, foundation, painted masks, brows) | ✓ | ○ | — | — | — |
| Orbit camera around the head, chair scenario | ✓ | ○ | ○ | — | — |
| Grooming kits from the satchel that wear out | ✓ | — | — | — | — |
| Player-owned barber businesses | — (lxr-business handles ownership framework-side) | — | ✓ €55 | — | — |
| Prices per part, dye price, town multiplier | ✓ | ○ | ○ | flat | flat |

## Where we are behind, honestly, and what is done about it today

1. **Store mannequins** (JOS sells it as a €30 add-on) — added: `Config.Mannequins` per tailor, a posed ped wearing a ready-made outfit, "Buy this look" on the eye card.
2. **Ready-made outfits for sale** (JOS €40 add-on, MulderDev's ten) — added: `Config.ReadyOutfits`, listed on the Outfits tab with a price, bought in one click.
3. **Player-owned barber businesses** (RicX) — not in the barber itself by design; wolves.land runs ownership through lxr-business. Listed so nobody claims parity where there is none.
4. **Discord-role slots** (RCO) — ours are ace-based; a Discord-role check needs a bot token and belongs to the framework's permission layer, not the creator. Ace-based slots cover the same use through txAdmin / discord ace resources.
5. **Tattoos** (RCO "tattoo parlour") — the game has no tattoo system; RCO composes face overlays. Our 21 overlay layers include the same painted-mask / scar sheets; no separate parlour screen.

Claims we do not make: piece counts against RCO's "15,700" — ours is *every hash the game has* per category (harvested, not hand-listed), which is the same ceiling; we have not counted them the same way.
