# Repo-by-repo audit — RSG (56 repos) · VORP (55) · QBR (34) vs LXRCore v3

Date: 2026-09-19. Every non-archived repository of `Rexshack-RedM`, `VORPCORE` and `qbcore-redm`
was shallow-cloned (scratchpad `ref/all/`, 145 repos, survey in `ref/all/SURVEY.md`) and read for
what it *does* (README feature lists, config keys, exports, commands, events, animation dictionaries).
This file is the honest gap list against what LXRCore v3 ships today, domain by domain, and the
order in which the gaps get closed. Learning only — their code and assets stay theirs.

Legend: **have** = shipped in v3 · **gap** = they have it, we do not · **ours** = we have it, they do not.
Line counts are their Lua / our Lua (a size hint, not a quality score).

---

## 0. What the live test says (before any feature talk)

Playing the framework on the owner's server exposed the truth the checklists hid: money not updating
(export copy), ammo doing nothing visible (plain `SetPedAmmoByType` on a ped without the gun), console
commands crashing (source 0), a wheel that was not even shipped (`ui/` skipped by sync). Every one of
those was a *framework-level* wiring fault, not a missing feature. Rule from here: **a resource is not
done until it was used in game** — the reference frameworks are less ambitious but they were played.

---

## 1. Inventory — rsg-inventory 4.3k · vorp_inventory-v2 18.6k · qbr-inventory 1.5k · **lxr-inventory 1.8k + React UI**

have: satchel + secondary panel, drag with amount, split, hotbar 1-5, stashes by preset, ground drops with
prop + marker + expiry, shops, give-nearby, search/rob, item boxes, decay, rarity borders, category chips,
transfer all/matching, wear panel (clothing), server-validated move engine with tests, every rejection reported.

gap (rsg): **player-to-player trade with escrow** (request → both confirm → rollback on cancel/disconnect) ·
`ItemsDecayWhileOffline` · hotbar spam protection · **33 exports** (`AddItem/RemoveItem/HasItem/GetItemCount/
CanAddItem/GetFreeWeight/CreateInventory/OpenInventoryById/SetItemData/…`) — third-party scripts call these
by name · vending objects · drop-target on the bag prop.
gap (vorp): shift+drag = all, alt+drag = half · **gizmo prop placement for drops** · weapons as inventory rows with
serial / custom label / custom description API · item **groups** and per-item **limit** · **secondary
inventories by kind** (horse, cart, house, clan, hideout, *steal*) · money/gold **pickups on the ground** shared
to nearby players · pickup animations (`mech_pickup@money@coins@table`).
gap (qbr): combine items (`combineItem`), attachment crafting (moved to lxr-craft — fine).
ours: decay to a spoiled form, rarity, freshness, category chips, transfer matching, wear panel, tests.

Close first: trade with escrow; export surface (`AddItem … GetFreeWeight`) as thin wrappers over the core;
shift/alt drag; money pickups; steal/horse/wagon kinds through one `OpenInventory(kind, id)`.

## 2. Weapons — rsg-weapons 1.3k + rsg-ammo 0.5k + rsg-weaponcomp 5k · vorp_weaponsv2 5.1k · qbr-weapons 0.4k · **lxr-weapons 1.2k**

have: serials, loadout → holsters, calibre pools in metadata, wear per shot, jam, field care, gunsmith panel
(repair, parts fit/remove, unload), dual wield, **loading progress with animation + box prop (today)**, pools
applied by difference (today).
gap (rsg): `/infinityammo` admin · **damage modifiers** per weapon (`SetPlayerWeaponDamageModifier`) · disable
sprint while aiming · `DisableCriticalHits` · **weapon inspection** (`mech_inspection@weapons@…`, `/w_inspect`) ·
weaponcomp's **gunsmith camera** (zoom / rotate / random position on the gun object, stats card) · job-locked
gunsmith · gunsmith robbery with lockpick · weapon restriction by job · `/loadweapon`, `/scope`.
gap (vorp): **weapon crafting** at benches with job lock and animations · grips/barrels/colours as priced options.
gap (qbr): repair points per town with costs, durability multiplier per class.
ours: pools with caps per calibre, care items, ledger-priced repair, wear warnings.

Close first: damage modifiers + sprint/aim + crit config; inspection; gunsmith camera + stats; job lock.

## 3. HUD & needs — rsg-hud 1.0k · vorp_metabolism 1.7k · qbr-hud 0.25k · **lxr-hud 0.8k + React**

have: compass tape, clock/date, identity, cash, six meters, weapon + rounds, mount, needs on the server,
consumables with animations/props, nerves shake, native cores hidden per icon, `/hud` settings, drag editor.
gap (rsg): **temperature** (clothing warmth values per slot, job exemption, °C/°F) · **flies effect** below
cleanliness · voice-range icon (always / while talking) · minimap on foot vs mounted · stress from speed ·
starvation damage fx + pain sound · money "show on change" · `/cash` `/bloodmoney` · telegram unread icon.
gap (vorp): "metabolism" third stat, give-back item after consume (bottle → empty bottle), effects
(`PlayerDrunkSaloon1`) per consumable, hunger/thirst reset on respawn config.
ours: per-piece drag editor, themes, catalogue-driven consumables.

Close first: temperature (with lxr-weather), flies, voice icon, give-back item, drunk effects.

## 4. Admin — rsg-adminmenu 7.3k · vorp_admin 22.5k · qbr-adminmenu 1.5k · **lxr-admin 0.5k**

have: players (goto/bring/freeze/heal/revive), server card, me (noclip/god/invisible), ban book, tiers,
`/whoami`, console commands (today).
gap (rsg): **player blips** · **reports** (`/report`, cooldown, nearby distance) · Discord bot · webhooks per
category · admin horse · door hashes tool · world settings (weather/time from the menu) · give item / money /
job / gang from the menu · spectate · kick/ban with reasons + durations from the menu · vehicle/horse spawn ·
teleport to marker / coords · entity deleter · developer tools (coords, hash, entity info).
gap (vorp): database-backed permissions per action · scoreboard/playerlist · request-staff with cooldown ·
Guarma/mainland teleport · per-character vs per-user groups · heal/speed/offsets tuned · "allowed actions"
matrix per group.
ours: kit UI, ledger-backed ban book.

Close first: give item/money/job, spectate, player blips, reports, teleport to waypoint, dev tools.

## 5. Medic — rsg-medic 2.0k · vorp_medic 1.3k · qbr-ambulancejob 3.1k · **lxr-doctor 0.7k**

have: down → bleed-out timer → respawn at office with fee, doctor revive with bandage, treatment picker,
duty, blips, `lxr:player:died/revived` events, dispatch calls.
gap (rsg): **[E] self-revive prompt after timer** vs medic revive (different health %) · wipe inventory/cash/
bloodmoney on respawn (config) · **injury body parts** with states (healthy/injured/broken/bleeding) from
bones, `checkskeleton`, `setinjury` · GPS route to calls · medic shop items · medic storage · `ResetOutlawStatus`.
gap (vorp): shared/private storages · teleports menu · boss menu (hire/fire) · alert only when dead.
gap (qbr): **bleeding system** (tick damage, movement advance, blackout/fade), painkillers, weapon-class
injury chances, critical/stagger areas, `MinimalDoctors` gate for self-respawn.
ours: fee to the doctor's society, treatment from carried medicine.

Close first: injuries + bleeding (bones → parts → states → limp/blackout), self-revive gate by doctors online,
wipe options, medic storage/shop, GPS route.

## 6. Law — rsg-lawman 1.1k + rsg-mdt 5.2k + rsg-prison 0.6k + rsg-robbery 0.4k · vorp_police 1.9k · qbr-policejob 3.3k · **lxr-lawman 0.9k + lxr-dispatch 0.6k**

have: duty desk page, cuff/uncuff/escort/search/seize/fine/jail, cuffed restrictions, jail yard with walk-back,
bounties, armoury/evidence stashes, `/backup`, dispatch kinds with GPS routes and cards.
gap (rsg): **MDT** (records, warrants, BOLOs, reports, charge templates, fines with grace, staff roles) ·
prison zone with PolyZone, job removal on jail, blip · **robbery** of a player (cuff → open their inventory) ·
death alerts (player/NPC) · `/lawbadge`.
gap (vorp): drag player · cuffs/keys as items with delete · persistent jail across relog with remaining time
check · respawn/escape protection inside Sisika · teleports menu · shared/private storages.
gap (qbr): **evidence** (casings, blood, fingerprints) · armoury whitelist · license rank.
ours: bounties, dispatch as its own resource with kinds and sync.

Close first: robbery (cuffed → inventory), persistent jail time + escape protection, drag, MDT-lite
(records + warrants + fines) on the kit, evidence later.

## 7. Horses — rsg-horses 8.9k · vorp_stables-lua 3.8k · vorp_wildhorse 0.5k · qbr-stable 1.7k · **lxr-horses 3.3k**

have: ownership, stables NUI, cores + bonding, catalog breeds/coats/stats, 546 tack pieces, wild herds + taming,
training courses, breeding, saddlebags, overhead tag, `/givehorse`.
gap (rsg): **XP & 10 levels** (health/stamina/speed/accel/inventory scale) · 4 bonding levels unlocking
**actions: drink at troughs/water, graze hay, play tricks, lay down** · horse **aging → death** · **trading**
between players (`/accepttrade`) · **death & revival** with reviver item · brush/lantern/feed/stimulant items ·
gender · fleeing (+ auto store) · two riders · `/findhorse`, `/sethorsename` · component prices per slot.
gap (vorp): **carts/wagons** with storage (U) · hard death with long-term health · vendor inventories per stable ·
follow (E) / stop (Space) / prance · ride transfer · groom job.
ours: wild herds, breeding, training courses, catalog with town availability.

Close first: XP/levels, actions (drink/graze/lay/tricks), items (brush/lantern/reviver), trading, aging,
wagons (with lxr-vehicles).

## 8. Stores — rsg-stores 2.2k · vorp_stores 17.8k (data) · qbr-shops 0.3k · **lxr-shops 0.7k + React**

have: catalog shelves, ledger prices, selling with offers, limited stock option, cart validated line by line,
clerks, staff counters, themes.
gap (rsg): **store hours + doors** (closed blip, NPC removed) · **dynamic pricing** (±% per unit, clamps) ·
overstock reduction schedule · "show only owned" filter · cent-level prices · external registration with live
price/stock updates · Discord log queue · buy/sell baskets with limits.
gap (vorp): job/grade lock per store · buy with **gold** · moveable black markets per restart · categories per
store · decay-aware selling.
ours: society-owned counters, night theme.

Close first: hours + doors, dynamic pricing, job lock, gold, black-market relocation.

## 9. Banking — rsg-banking 1.0k · vorp_banking 1.8k · qbr-banking 1.1k · **lxr-bank 0.7k + React**

have: per-branch books, wires, drafts, cheques, bank notes, societies, tellers, ledger.
gap (rsg): **safe deposit box** per character per town · open/close hours · withdraw fee · money clips
(cash → item) · give money to a player id · bank door presets · webhook.
gap (vorp): weapon storage · buy extra slots · gold deposit/withdraw with fee.
gap (qbr): savings accounts with interest, gang accounts.
ours: cheques, drafts, bank notes, society books.

Close first: safe deposit box (lxr-inventory stash), hours, money clip item, savings.

## 10. Appearance — rsg-appearance 255k (data) · rsg-wardrobe 0.7k · rsg-barbers 15.6k · vorp_character 70.5k · vorp_clothingstores 13.8k · qbr-clothing 2.2k · **lxr-creator 3.2k · lxr-clothing 2.5k · lxr-barber 0.6k**

have: pin creator, skins with verified tones, overlays, mixes, tailor with basket/lockers/uniform, wardrobe
wear/undress, barber, mouse camera (drag/wheel/keys), ticks.
gap (rsg-wardrobe): **one command per slot** (`/hat /shirt /pants … /undress /dress`) and exports
`ToggleClothing / IsWearing / RemoveAllClothing` — we have the wheel and exports, not the commands.
gap (vorp_character): banned names, min age, `/rc` reload, initial anim scene, per-slot commands (`ccoat`, `tuck`,
`sleeves`, `bandanaon`, `ringsL/R`), outfit menu export.
gap (rsg-barbers): NPC barbers at shops, price per style.
ours: pins, mixes, kit UI, tailor basket, uniform lockers.

Close first: per-slot commands + `/undress /dress` (thin over existing exports), banned names/min age.

## 11. Multicharacter & spawn — rsg-multicharacter 1.3k · rsg-spawn 0.2k · qbr-* · **lxr-creator (absorbed)**

have: select/create/delete, spawn places, arrival protection, starter outfit.
gap: **starter horse** on creation (rsg) · starter items list in the core · slots per license override ·
random tips on the load string · auto dual-wield on spawn · `/logout`.
Close first: starter horse + starter items, slots per license, `/logout`.

## 12. Hunting & fishing — rsg-hunting 3.3k · vorp_hunting 3.6k · rsg-fishing 1.3k · vorp_fishing 1.4k · vorp_crawfish 0.7k · **lxr-hunting 0.4k · lxr-fishing (not built)**

have: skinning by native event, grade, take, poaching call, 39 animals.
gap (rsg): **90+ animals** · **trapper vendors** (buy/sell, stock pricing) · **butcher shops** (12) selling whole
carcasses · carcass on the horse · legendary handling · `resetvendorstock`.
gap (vorp): pelts stored on the horse's back · sell big fish · whole animals.
gap (fishing): **the whole resource** — native fishing struct minigame, baits, species/sizes, weight metadata,
keep/throw, crawfish holes. Owner's `iboss21/lxr-fishing` (8.5k) is the base to rebuild.
Close first: butchers + trappers (lxr-shops kinds), carcass on horse, animal table to 90; then lxr-fishing.

## 13. Gathering & crafting — rsg-herbalist 8.7k · vorp_herbs 1.6k · vorp_mining 1.3k · vorp_lumberjack 1.2k · vorp_crafting 1.9k · **lxr-farming 0.6k · lxr-mining 0.5k · lxr-craft 0.6k**

gap: **herb nodes across the map** (hundreds of points, zones, regrow, composite pickups, mortar & pestle tonic
crafting) · tool durability + break chance (pickaxe / hatchet) · **lumberjack** · town restrictions ·
placeable campfire crafting with props and `/extinguish` · kneeling animations.
Close first: herbs (lxr-farming → lxr-herbs?), tool durability in mining, lumberjack, campfire in lxr-camp.

## 14. Business & jobs — rsg-bossmenu 0.7k · rsg-gangmenu 0.8k · rsg-multijob 0.8k · vorp_bossmanager 0.9k · vorp_paycheck 0.3k · vorp_billing 0.4k · qbr-management 1.2k · **lxr-business 0.5k**

have: staff, hire/grades/fire, society book, desks.
gap: **gangs** (menu, stash, funds) · **multijob** (hold several, switch, per-citizen cap, icons) · **billing**
(receipt item, max, job/grade) · paycheck per minute per grade with on-duty option · licenses give/revoke.
Close first: multijob in the core + business page, billing, gang desks.

## 15. Essentials — rsg-essentials 1.9k · qbr-smallresources 0.7k · vorp_zonenotify 4.0k · Vorp_walkanim 0.4k · rsg-bathing 1.1k · rsg-npcs 0.3k · rsg-playerinfo 0.3k · rsg-animations 1.8k · vorp_animations 0.5k · **lxr-frontier 0.4k · lxr-me 0.4k**

have: density, AFK, hands up, teleports, eagle eye, `/me`.
gap: **animation/emote menu** (categorised, favourites in DB, scenarios, props) · **walk styles** · **zone
notify** (town name card with time/temperature/wind) · **bathing** (bathhouses, normal/deluxe, cleanliness) ·
bandana toggle · first-person shooting · crouch · Discord rich presence · `/info` card · NPC placer with
scenarios and proximity audio · Xmas toggle · book pause.
Close first: emote menu (biggest player-facing hole), walk styles, zone notify, bathing.

## 16. Doors, target, weather, chat, radial, mail, loading, lockpick

* doors — rsg-doorlock / ox_doorlock / vorp_doorlocks vs **lxr-doors**: gap = key unlock animation with prop,
  Sisika gates forced, lockpick alert to law (we raise it), double doors (have), housing access grants.
* target — ox_target / qbr-target vs **lxr-interact**: gap = generic options for all peds/objects/models,
  option stacking, bones, `lib.zones`-style boxes/spheres; have = eye card, points, cursor.
* weather — weathersync vs **lxr-weather**: gap = **forecast UI**, regions, timescale, per-player local override,
  `/forecast /weather /time /freezetime` admin set.
* chat — rsg-chat vs **lxr-chat**: have = IC names, OOC, suggestions, Georgian; gap = PSA event, templates,
  `/clearchat`.
* radial — rsg-radialmenu vs **lxr-clothingradial (murphy fork) + lxr-radial**: have; gap = walk styles submenu,
  horse lantern, register-category export used by other scripts.
* telegram — rsg-telegram 1.8k / vorp_mailbox vs **lxr-post**: gap = broadcast for a price, unread state bag
  for the HUD icon, player picker.
* loading — rsg-loading vs **lxr-loading**: have video/music? (check) ; ours reads locales at first frame.
* lockpick / safecracker vs **lxr-lockpick**: have mouse-rotate minigame; gap = safe cracking dial.

## 17. Not built at all (they have it, we have nothing)

fishing · animations/emotes · walk styles · bathing · MDT · multijob · billing · gangs · lumberjack · herbs
nodes · outlaws ambush (vorp_outlaws) · loot NPCs (vorp_lootnpcs) · saloons (vorp_saloons) · housing
(vorp_housing — lxr-storage covers yards only) · Discord bot · zone notify · NPC placer · imap view tool (dev).

---

## The order

Player-facing, every day, in this order — each one finished and *played* before the next:

1. **lxr-inventory**: trade with escrow, export surface, shift/alt drag, ground money, kinds (horse/wagon/steal).
2. **lxr-weapons**: damage/sprint/crit config, inspection, gunsmith camera + stats, job lock.
3. **lxr-doctor**: injuries + bleeding, self-revive gate, wipe options, storage/shop, GPS.
4. **lxr-lawman**: robbery, persistent jail + escape protection, drag, MDT-lite.
5. **lxr-hud**: temperature, flies, voice icon, give-back item, drunk effects.
6. **lxr-admin**: give item/money/job, spectate, blips, reports, waypoint teleport, dev tools.
7. **lxr-horses**: XP/levels, actions, items, trading, aging, wagons.
8. **lxr-emotes** (new): emote menu + walk styles + favourites.
9. **lxr-shops / lxr-bank**: hours+doors, dynamic pricing, gold, safe deposit, money clip, savings.
10. **lxr-hunting → lxr-fishing**: butchers/trappers/carcass; then fishing from the owner's repo.
11. **lxr-business**: multijob, billing, gangs.
12. **lxr-frontier**: zone notify, bathing, bandana, crouch, first person.
13. **lxr-herbs / lumberjack / tool durability**, then the rest of §16-17.

Progress is recorded per item below as it lands (date · resource · what · commit).

## Progress log
* 2026-09-19 · lxr-core · console source 0 allowed/notified; `EmitClient` never targets nobody · `fix: console commands`
* 2026-09-19 · 10 client resources · `PlayerData` listener (export copy) · `fix: PlayerData stays current`
* 2026-09-19 · lxr-weapons · loading progress + animation + box prop; pools by difference · `ammo: loading progress…`
* 2026-09-19 · lxr-inventory · drop target by position at release · `ui: drop target by position`
* 2026-09-19 · lxr-inventory · face-to-face trade with escrow (both confirm, weight/slot/money checked both sides, everything back on cancel/ESC/walk-away/disconnect, offline return stash), shift/alt drag, the item export surface (AddItem … DeleteInventory) · `trade: face-to-face trade…` — left for later: money pickups on the ground, gizmo placement of drops
* 2026-09-19 · lxr-clothingradial · Trade on the player wheel
* 2026-09-19 · lxr-weapons · Config.Combat (damage per category/melee, no sprint while aiming, /infiniteammo), /inspect + care with the game's inspection dictionaries, gunsmith camera (drag/wheel/W-S) holding the selected gun, job-locked counters · `combat config, /inspect…` — left: weapon crafting benches (lxr-craft recipes), gunsmith robbery
* 2026-09-19 · lxr-doctor · injuries + bleeding by body part (real bone ids), self bandage, examine + treat a part, no-doctor shorter wait, wipe options, office cabinet · `injuries and bleeding…` — left: medic shop counter (lxr-shops has doctor counters), HUD indicator for `injured` state bag
* 2026-09-19 · lxr-lawman · the record book (auto charges, warrants, notes, owed fines settled at a desk) · `the record book…`; jail persistence + walk-back already covered; drag = escort
* 2026-09-19 · lxr-inventory · robbery at gunpoint (hands up + armed), Rob/Search options on people · `robbery at gunpoint…` — left: evidence (casings/blood), prison zone blip
* 2026-09-19 · lxr-hud · temperature (+clothing warmth, drink warmth), flies, drunk need + post-fx + heavy walk, `use.gives` leftovers (core: `bottle_empty`) · `temperature with clothing warmth…` — left: icon for bottle_empty (comfy batch), voice range display, minimap on foot/mounted toggles
* 2026-09-19 · lxr-admin · spectate, staff blips, /report + Reports tab, dev tools · `spectate, staff blips…` — left: Discord bot/webhooks (lxr-core log channels cover part), admin horse spawn, DB-backed per-action permissions
* 2026-09-19 · lxr-barber · chair camera drag/wheel/keys (owner asked) · `chair camera…`
* 2026-09-19 · lxr-horses · interact cards replace native prompts, graze/drink/rest/rear (verified animal dictionaries), hand-over between players · `interact cards on the horse…` — left: lantern, wagons/carts with storage (lxr-vehicles), XP levels beyond bond (bond IS the level system here), horse death/revive already there
* 2026-09-19 · lxr-emotes (new) · 131 kit emotes from the game's list, 13 verified scenarios, 21 walk styles, favourites, /e /walk, walk on a state bag · first release; recipe + live server.cfg updated
* 2026-09-19 · lxr-shops · prices that move (per store/item drift, clamps, hourly easing, persisted); hours/job lock/gold/butchers/trappers were already there · `prices that move`
* 2026-09-19 · lxr-bank · safe deposit box per character per branch · `the safe deposit box` — left: savings interest (owner's economy call), money clip (bank notes cover it)
* 2026-09-19 · lxr-hunting · every wild animal of the game (64 kinds / 91 models) + catalog pelts/feathers · `every wild animal…` — left: carcass on the horse's back, trapper vendors are lxr-shops counters already
* 2026-09-19 · lxr-business · jobs held + /myjobs switch/leave, billing with receipt items · `jobs held…` — left: gang desks (gangs exist in the core registry; a gang page like the business page)
* 2026-09-19 · lxr-hud · arrival card (zone notify) · `arrival card`
* deferred · lxr-fishing · the owner's iboss21/lxr-fishing (6k, native fishing struct via a JS helper) is the base; a dedicated session rebuilds it native v3 (zones/species/baits/journal/tackle counters via lxr-shops, tournaments later)
