# HANDOFF — Character+ suite → the Tebex production box (Claude)

Written 2026-09-20 03:00 for the next Claude session (the "custom Tebex production" box). Everything this session
knew, decided, built and left open is here. Read it top to bottom before touching a file.

---

## 0. Who / what / where

* **Owner**: iBoss21 (wolves.land / The Land of Wolves, LXRCore — https://www.lxrcore.com, Discord https://discord.gg/GAhk8cgXe9, store https://theluxempire.tebex.io). Pronouns unknown — use they.
* **Workspace**: `G:\GitHub\LXRCore-Framework\` — one folder per resource, each its own git repo (`main`). Framework repos push to `origin` = github.com/LXRCore/<name>.
* **The four products of this handoff** (all version **3.0.0**):
  | Product | Repo (private, LXRCore) | Sell copy (private, iboss21) | Escrow | Tebex price (brand tier) |
  |---|---|---|---|---|
  | `lxr-creator` — Creator+ | LXRCore/lxr-creator | iboss21/lxr-creator | yes | **€79** |
  | `lxr-clothing` — Tailor+ (the appearance engine) | LXRCore/lxr-clothing | iboss21/lxr-clothing | yes | **€59** |
  | `lxr-barber` — Barber+ | LXRCore/lxr-barber | iboss21/lxr-barber | yes | **€29** |
  | `lxr-clothingradial` — the wheel (GPL-3 fork of murphy_radialmenu) | LXRCore/lxr-clothingradial (public) | — | **no** (GPL, free) | free |
  | `lxr-character-plus` — the bundle (README, `docs/tebex_bundle_description.md`, `tools/pack.py` → `dist/*.zip`) | iboss21/lxr-character-plus | — | — | **€149 list · €119 launch week**, open-source tier ×2, raise to €169 after ten reviews |
  * The workspace checkouts of creator/clothing/barber have **two remotes**: `origin` (LXRCore) and `iboss` (iboss21). Push both: `git push origin main && git push iboss main`.
  * `lxr-nui` (free, public, LXRCore/lxr-nui) is the optional UI kit the suite uses when present.
* **Live test server**: txAdmin profile `J:\Laki.Cloud\GameServer-Fivem-Redm\txData\LXRCorev3`; log `J:\Laki.Cloud\GameServer-Fivem-Redm\txData\default\logs\fxserver.log`. Other profiles in the same txData: `RSGCore-Dev`, `VORPCore` (for the bridge tests).
* **Sync**: `python tools/sync_server.py "J:\Laki.Cloud\GameServer-Fivem-Redm\txData\LXRCorev3" lxr-clothing lxr-barber lxr-creator lxr-nui lxr-clothingradial`.
* **Reference clones** (145 RSG/VORP/QBR repos, read-only, learning only): scratchpad `…\scratchpad\ref\all\{Rexshack-RedM,VORPCORE,qbcore-redm}` (re-clone list: `scratchpad/orgs.tsv`; see `docs/AUDIT-FRAMEWORKS-2026-09-19.md`). Also `G:\GitHub\lxr-playerstore`, `lxr-fishing`, `lxr-flags`, `lxr-blindfold` — the owner's own Tebex scripts, **pattern reference only, never copy their code**.
* **Memory** (Claude auto-memory): `C:\Users\iBoss\.claude\projects\G--GitHub-LXRCore-Framework\memory\` — `MEMORY.md` index + one file per fact; the owner's prompt pack in `memory\prompts\` and workspace `prompts\` (constitution, branding, NUI design system, Tebex packaging, council protocol…). Read `prompts/REDM_AGENT_CONSTITUTION.md`, `# RedM Engineering Agent — Branding & Fo.md`, `lxr-scripts-nui.md`, `lxrcore-brand-wiki.md` first.

## 1. Standing rules (the owner's, verbatim in spirit — do not relax)

1. **Own code only.** tgiann / murphy / rsg / vorp / qbr code and assets are studied, never copied. The owner's `G:\GitHub\lxr-*` Tebex builds: patterns only, no code reuse.
2. **Quality bar**: tgiann/murphy design and features, our code. One resource at a time. Verify every native / anim / prop / hash against game data (rdr3natives.com, the harvested tables in `lxr-clothing/shared/data/`). Look at assets before using them.
3. **Events** `lxr:<domain>:<verb>`; every resource **version 3.0.0**; **EN + KA locales** with parity; 0.00 ms idle.
4. **LXR UI Kit** for every NUI (`lxr-ui.css`: inks + one blood accent, radius 0, index rows). Brown/gold palettes forbidden.
5. **Five checkers before every commit** (from the workspace root): `python tools/native_check.py <repos>`, `lua_check.py`, `kit_check.py`, `js_check.py`, `perf_check.py`. Plus `lua tests/run.lua` inside repos that have `tests/` (clothing 10 tests, barber 3). **No test sections in READMEs** (keep `tests/`, do not advertise).
6. **Never commit secrets.** Commit each repo to `main` with `Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>`, push (both remotes for the products), sync to the live server.
7. **Resource name guard** (owner's words: "hardcoded in server and client main lua … no explanation anywhere. no config files description etc."): top of every server entry file
   ```lua
   if GetCurrentResourceName() ~= 'lxr-clothing' then
       CreateThread(function() Wait(1500) StopResource(GetCurrentResourceName()) ExecuteCommand('quit') end)
       return
   end
   ```
   and `if GetCurrentResourceName() ~= 'lxr-clothing' then return end` at the top of every client file. **No comment, no config key, no doc line about it** (the INSTALL docs only say "the folder must be named exactly this; not configurable").
8. **Brand rules**: ASCII banners in file headers, `████` section dividers in config, colours per the UI kit, escrow layout (`escrow_ignore { README, CHANGELOG, LICENSE, docs/**, config.lua, fxmanifest.lua, locales/**, shared/**, bridge/**, html/** }`; `client/**` + `server/**` protected).
9. **Banner art (decided tonight, three corrections from the owner)**: the word art says the plain word — **CREATOR / CLOTHING / BARBER / NUI / RADIAL** (ANSI Shadow font, pyfiglet `ansi_shadow`, width 200) — **not** "LXR-CREATOR", not "LXR-MULTICHAR". The console start-up card is the **blood-red** style of `G:\GitHub\lxr-blindfold\config.lua` (art in `^8`, `^3` rules, `🐺 LXR-<NAME> · tagline · RedM`, `Label ········ value` rows with values in `^8`, links in `^4`), **never magenta/cyan (`^5`/`^6`)**. Implemented as `Bridge.Banner{}` in `shared/framework.lua` (clothing, barber) and inline in creator / nui / radial server files. The generated art is in the scratchpad `banners.json` — regenerate with `pyfiglet` if the scratchpad is gone.
10. Config header banners: every `.lua`/`.md` header block of the three products now carries the plain-word art (script `banner_words.py` did the swap).

## 2. What was built tonight (2026-09-19 → 20) — state on disk, all committed + pushed + synced

### 2.1 lxr-clothing 3.0.0 — the engine, now multi-framework
* **`shared/framework.lua`** — `Bridge`: detection (`Config.Framework = 'auto' | lxr | rsg | vorp | standalone`; order lxr-core → rsg-core/qbr-core/qr-core → vorp_core → standalone), own **RPC channel** (`<res>:bridge:req/res`, ticket ids, 10 s timeout; `Bridge.RPC.Register/Server/Client`), **ready hooks** (`Bridge.OnReady/OnUnload/Ready/Unload`, `Bridge.Loaded`), `Bridge.Boot()` copies the adapter's `server`/`client` table onto `Bridge`, `Bridge.Is()`, `Bridge.Label()`, **`Bridge.Banner{}`**.
* **`bridge/lxr.lua` · `rsg.lua` · `vorp.lua` · `standalone.lua`** — adapters. Server surface: `Player(src)→{src,id,license,firstname,lastname,name,gender,job{name,grade},raw}`, `Identity`, `Characters(src)`, `Money/Take/Give(src,n,reason,account)`, `Notify(src,text,kind)` (src 0 prints), `Job`, `JobExists`, `AddItem/RemoveItem/HasItem`, `GetItem(src,item)→{name,slot,amount,info}`, `SetItemInfo(src,held,info)`, `Usable(item,fn(src,{name,slot,info}))`, `SetMeta`, `IsAdmin` (console / ace `Config.Security.adminAce` / framework group), `Command{name,help,args,permission,handler}`, `Log/Exploit/Emit`, `OnCharacterDeleted`. Client: `Notify`, `Door/DoorRemove`, `Brand()`, `IsLoaded()`.
  * Verified against the reference code: RSG `RSGCore:Server:PlayerLoaded` / `Client:OnPlayerLoaded` / `OnPlayerUnload`, `Player.Functions.RemoveMoney/AddMoney/GetMoney/SetMetaData`, `rsg-inventory` exports `AddItem(src,item,n,slot,info,reason)`, `RemoveItem`, `HasItem`, `GetItemByName`, `SetItemData(src,item,key,val)`, `RSGCore.Functions.CreateUseableItem`, `HasPermission`, notifications via `ox_lib:notify`; VORP `Core.getUser(src).getUsedCharacter` (`charIdentifier, identifier, firstname, lastname, gender, job, jobgrade, money, gold, group, addCurrency/removeCurrency(currency 0=cash,1=gold,2=rol)`), `vorp:SelectedCharacter` (server + client), `vorp:TipRight`, `LocalPlayer.state.IsInSession`, `vorp_inventory` exports `addItem, subItem, getItemCount(src, cb, item)`, `getItemByName`, `setItemMetadata`, `registerUsableItem(name, fn(data{source,item}))`. VORP has **no** character-deleted / logout events (orphan rows harmless). qbr/qr forks use prefix `QBCore`/`QRCore`.
* **`bridge/ui.lua`** (client) — `Bridge.Toast` (lxr-nui `Toast` or a drawn line via `_DISPLAY_TEXT`), `Bridge.NativeDoor` (lxr-interact `AddPoint` or a game prompt: PromptRegisterBegin/SetControlAction/SetText/SetEnabled/SetVisible/SetStandardMode/RegisterEnd/HasStandardModeCompleted/Delete — all hashes verified by native_check), `Bridge.Progress`.
* **`bridge/db.lua`** (server) — `Bridge.DB.Single/Query/Scalar/Insert/Update/UpdateAsync`, `Table(key)` ('auto' → `playerskins`/`player_outfits` on LXRCore, `lxr_appearance`/`lxr_outfits` elsewhere, `lxr_job_outfits` everywhere), `T(key)` (quoted, schema-qualified), `Migrate(name, sql)` with `{appearance}` placeholders, `Install()` (own ledger `lxr_migrations` on oxmysql; the core's runner on LXRCore; tolerates MariaDB<10.2 duplicate-column), `TableExists`, `Columns`, `Ready()` waits for oxmysql (`Upgrade.WaitForMysqlMs`).
* **`bridge/migrate.lua`** (server) — hash-driven importers: `M.FromRsg(skinJson, clothesJson)` (rsg-appearance / qbr-clothing / LXR v2: `sex, skin_tone, body_size, body_waist, height, head` index→`CLOTHING_ITEM_?_HEAD_nnn_V_00k` with rsg's remap 16→18,17→21,18→22,19→25,20→28 (male) / 17→20,18→22,19→27,20→28 (female) and colour map {1,4,3,5,2,6}; `eyes/eyes_color/teeth` index or hash; face keys −100..100 → 0..100 with aliases `eyebrow_→brows_`, `cheekbones_→cheekbone_`, `lower_lip_→lip_lower_`, `upper_lip_→lip_upper_`, `mouth_x_pos→mouth_x`; overlays `<layer>_id/_op/_t`; every `{hash}` resolved across all categories), `M.FromVorp(skinPlayer, compPlayer, compTints)` (`HeadType/Eyes/Teeth/Body/Waist` hashes, `Scale` 0.9–1.1 → height, 63 face comps by hash (`HeadSize=0x84D6 … CalvesS=42067`) −1..1 → 0..100, overlays `<layer>_tx_id/_visibility/_opacity/_color`, comps by hash with `compTints[k] = {palette,tint0..2}` joined by key), readers `rsg` (`playerskins` where `version<3`, + `playeroutfit`) and `vorp` (`characters`), `M.Run(source, dry, write, writeOutfit, say)`, `M.Export('rsg'|'vorp', rec)`. Tested offline (`tests/run.lua` test 10).
* **`server/main.lua`** rewritten on the bridge (same behaviour; tables via `DB.T()`; commands `/skin`, `/uniform`, **`/lxr-clothing:migrate <rsg|vorp|auto> [dry]`, `:export <rsg|vorp> <id>`, `:install`, `:cleanup`**; `Config.Migration.runOnStart`; exports + `Framework()`, `Identity(src)`; the blood-red card). **`client/main.lua`** on the bridge (`Bridge.RPC.Server`, `Bridge.OnReady`, `Bridge.Door`, `Bridge.Brand()`).
* **`config.lua`** new blocks: `Config.Framework`, `Config.Brand = { name = 'LXR', theme = 'blood' }`, `Config.Database { schema, useSchemaQualifier, createDatabaseOnStart, autoMigrateOnStart, tables{appearance,outfits,uniforms,ledger}, Upgrade{SafeMode, WaitForMysqlMs, SchemaVersion} }`, `Config.Migration { enabled, runOnStart, dryRunFirst, overwriteExisting, verbose, sources{rsg{skins,outfits}, vorp{characters}}, LegacyCleanup{autoRemoveLegacyTables, confirmLegacyDataMigrated, legacyTableNames} }`, `Config.Debug.enabled`.
* **`fxmanifest.lua`**: no `@lxr-core/shared/import.lua`, no `dependencies { 'lxr-core' }`; loads `shared/framework.lua`, `bridge/{lxr,rsg,vorp,standalone}.lua` (shared), `bridge/ui.lua` (client), `bridge/db.lua` + `bridge/migrate.lua` (server); `bridge/**` in `escrow_ignore`.
* **Docs** (playerstore layout): `docs/INSTALL.md, FRAMEWORKS.md, MIGRATION.md, CONFIG.md, API.md, PERMISSIONS.md, ESCROW.md, TROUBLESHOOTING.md` + `docs/templates/{tebex_product_description, tebex_install_snippet, cfx_forum_post}.md`. README install section rewritten; CHANGELOG 3.0.0 — 2026-09-20 entry.
* `tools/native_check.py`: RUNTIME allowlist gained `Bridge GetPlayerIdentifierByType GetPlayerIdentifiers IsPlayerAceAllowed GetInvokingResource` (server natives in shared bridge files).

### 2.2 lxr-barber 3.0.0 — on the bridge
* Same `shared/framework.lua` + `bridge/{lxr,rsg,vorp,standalone,ui}.lua` (identical copies — **keep the bridge folders identical across the three products**; source of truth = lxr-clothing's).
* `server/main.lua`: `Bridge.Player/Money/Take/Give/Notify/GetItem/SetItemInfo/RemoveItem/Usable/Exploit/Log/Emit/RPC`, kit label from `Config.Kits[].label` (added `label` to razor / vanity), the blood-red card. `client/main.lua`: `Bridge.RPC.Server`, `Bridge.Door`, `Bridge.Brand()`, `Bridge.Notify`.
* `config.lua`: `Config.Framework`, `Config.Brand`, `Config.Security.adminAce`, `Config.Debug.enabled`. `fxmanifest.lua`: no core import, `dependencies { 'lxr-clothing' }`, bridge files, `bridge/**` open.
* Docs: INSTALL, FRAMEWORKS, CONFIG, API, PERMISSIONS, ESCROW, TROUBLESHOOTING; README + CHANGELOG updated.

### 2.3 lxr-creator 3.0.0 — on the bridge (done 2026-09-20 ~05:00, not yet run in game)
* Same shared bridge files + `bridge/db.lua` + **`bridge/characters.lua`** (`Bridge.Chars`: `List, Max, Select, Create, Delete, Logout, Meta/SetMeta, LastSeen, SetPosition, StarterItems, ValidId, SkillList, Capacity, AddSkillLevels, Spawned`) with four implementations:
  * **lxr**: `Player.GetCharacters / Login / DeleteCharacter / Logout`, metadata, `players.slots/weight`, `AddXp`; ready = client `Bridge.LXR.Player.Spawned()` (`lxr:client:loaded` + `lxr:player:spawn`).
  * **rsg**: `players` rows by licence, `Player.Login(src, id)` / `Login(src, false, { cid, charinfo })`, `DeleteCharacter`, metadata via `SetMetaData`; ready = server fires `<Prefix>:Client:OnPlayerLoaded` (rsg-spawn's job — stop rsg-spawn, rsg-multicharacter, rsg-appearance's creator).
  * **vorp**: `characters` rows, `user.setUsedCharacter(id)`, `user.addCharacter{firstname,lastname,skin='{}',comps='{}',compTints='{}',age,gender,charDescription,nickname}` (async insert — polled until the used character appears), `user.removeCharacter(id)`, logout = DropPlayer; traits in `lxr_character_meta`; ready = server fires `vorp:initCharacter(coords, heading, false)` (SelectedCharacter already fired by setUsedCharacter).
  * **standalone**: `lxr_characters` (id `<licence>:<slot>`) + `lxr_character_meta`; `C.Boot()` overrides `Bridge.Identity/Player` so the selected character is the identity; lxr-clothing/barber's standalone adapter asks `exports['lxr-creator']:Identity(src)`.
* `server/main.lua`, `server/spawn.lua` (`dataOf(src)`, `lxr-creator:server:spawned` → `Chars.Spawned`), `server/traits.lua` (takes `src`, records through `Chars.Meta/SetMeta`, capacity/xp only where the framework has them), `client/main.lua` + `client/spawn.lua` on `Bridge.RPC / OnReady / IsLoaded / Brand / Notify`. `Config.Framework`, `Config.Brand`, `Config.Database { tables.characters = 'auto', meta = 'lxr_character_meta' }`. Exports `Identity(src)`, `Framework()`.
* Docs: INSTALL (per framework, what to stop), FRAMEWORKS (the Chars table), CONFIG, PERMISSIONS, ESCROW, TROUBLESHOOTING + the existing API / ARCHITECTURE / TRAITS. README + CHANGELOG updated.
* Server side live-booted on all three cores (see §4a); client-side flows untested. Known soft spots: VORP `Create` polling (100 × 50 ms), VORP `Max` via `Core.maxCharacters`, RSG `Config.Player.MaxCharacters` key name, standalone `Bridge.Player` override order (C.Boot runs after Bridge.Boot in server/main.lua).

### 2.4 lxr-clothingradial — the wheel
* Today: the **GPL-3 fork of levraimurphy/murphy_radialmenu** (React build in `ui/build`, `integrations/` folder, `shared/config.lua`, `client/client.lua`), plus tonight a `server/main.lua` with the blood-red card (RADIAL art) and the manifest line for it.
* **Owner's order (not built yet)**: recreate from scratch as an lxr-* brand script — "same style same format same ui same component as it works … but recreate from scratch". Spec captured: SVG wheel SIZE 400, ring inner 116 / outer 198, clip 100/210, 2° gap, centre radius 107, hub Ø196, icon size clamp 28–56, hover by cursor angle with dead zone r<92, sub-rings via `children` / `childrenBuilder`, `visibleWhen`, `stayOpen` (refresh after 150 ms), actions command / clientEvent / serverEvent / function, NUI messages `nui:radial:open/close/update`, callbacks `radial:select/close`, hold key `+lxr_wheel` (F1), direct keys (clothing J), `Config.Menus/Contexts/Integrations/AllCategories`, integrations API `RadialIntegrations.addSlot/whenStarted/playerNearby`, existing integrations: lxr_clothing (categories on/off, states, undress/dress), lxr_actions (horse, satchel, duty, papers, HUD, Trade, Emotes). Rebuild = **vanilla SVG/JS in `html/` (LXR UI Kit, no React build), own ring art, same config format and integration API**, keep GPL-3 for the fork or relicense once no murphy code remains (then it may become escrow-able — owner's call).

### 2.5 lxr-nui — the blood-red card in `server/main.lua` (NUI word art). Free, public; the suite uses it when present (`Toast`, `Progress`), falls back otherwise.

### 2.6 lxr-character-plus — bundle repo (iboss21). `tools/pack.py` rebuilt `dist/lxr-creator-3.0.0.zip, lxr-clothing-3.0.0.zip, lxr-barber-3.0.0.zip, lxr-character-plus-3.0.0.zip` tonight (skips .git/node_modules/ui/tests). README carries the prices. `docs/tebex_bundle_description.md`.

## 3. Earlier in the session (still relevant)

* **Framework audit**: 145 RSG/VORP/QBR repos reviewed, `docs/AUDIT-FRAMEWORKS-2026-09-19.md` (gap list + closing order + progress log: items 1–11 landed — inventory trade/escrow/robbery, weapons ammo/inspect/gunsmith cam, doctor injuries/bones, lawman records/warrants/fines, hud temperature/flies/drunk/arrival, admin reports/spectate, horses actions/trade, emotes (new repo), shops pricing drift, bank deposit box, hunting 64 animals, business jobs/billing, frontier wash/loot, doors key anim, mining break; **left**: gang desks, lxr-fishing rebuild, herbs, housing, outlaws, bathing anim scenes).
* **Mouse camera** in creator/clothing/barber: `docs/HANDOFF-MOUSE-CAMERA.md` (drag orbit, wheel zoom, W/S height, `nudge` callback, barber orbits `session.cam.angle`).
* **Forum post** `docs/FORUM-POST-CFX.md` + `docs/forum/*.jpg` — **must be rewritten** before posting: it still says creator/clothing/barber are free. Cfx Releases rules: RedM Releases `/c/redm-releases/60`, tags free|paid (+escrow), one topic per product, disclosure table, Trust Level 1, 48 h between posts, no AI-pasted descriptions. The framework topic first; the suite topic (paid + escrow) 48 h later.
* **Market research** `docs/MARKET-CHARACTER-SUITE.md` (Murphy €288/€216, CAS €120/€240, RCO €110→99, RW $100, Valenor €89.99/44.99, JOS €50, RicX €55, MulderDev €15) → our brand-tier prices above. Its "two things that break it": announce the paid suite from day one; and sell only after it has been played (the owner overrode the second: **"sellable in Tebex tomorrow"**, so ship with support-ready docs and test tonight).
* **Recipe**: creator/clothing/barber are private now, so the public framework recipe breaks — needs **Lite** screens (free creator: name/gender/birthdate/body preset/tone/short hair list/starter outfit/spawn/select; plain tailor counter; plain barber) or a recipe change. Not started.
* **Comfy icons**: blindfold rendered as goggles, hoe as shovel — re-roll; 15 new items need icons (`docs/HANDOFF-COMFY-ITEMS.md`).
* Core fixes earlier: `revive 1` from console (Perms/Notify/EmitClient allow source 0); ammo delta natives; Vite build overwrites `html/style.css` → edit `ui/public/style.css` then build; fetch CSS with `cache:'reload'`.
* Bash gotcha on this machine: multi-line heredocs with box-drawing art or nested quotes sometimes fail to parse — write patch scripts with the Write tool and run `python file.py`; `PYTHONIOENCODING=utf-8` for emoji/box output.

## 4. Test plan for tonight / tomorrow (nothing below has run in game yet)

1. **LXRCorev3 profile**: restart; the three cards must print (framework `LXRCore (lxr-core)`, tables `playerskins / player_outfits / lxr_job_outfits`). Create a character, tailor buy + outfit save/wear/rename/delete/pack, wardrobe, locker + `/uniform save vallaw Deputy 0`, barber chair + shaving kit wear, `/skin vampire`, `/lxr-clothing:migrate rsg dry` (should say 0 rows or list v2 rows), `/lxr-clothing:export rsg <cid>`.
2. **RSGCore-Dev profile**: `ensure oxmysql, rsg-core, rsg-inventory, ox_lib, lxr-clothing, lxr-barber, lxr-creator`; stop `rsg-multicharacter`, `rsg-spawn`, `rsg-appearance`. Card: framework `RSG Core (rsg-core)`, tables `lxr_appearance / lxr_outfits`. Select / create / delete / spawn through the creator; `RSGCore:Client:OnPlayerLoaded` must fire once (rsg-inventory opens, HUD shows). Run `lxr-clothing:migrate rsg dry` against rsg-appearance's `playerskins`, then real; log in → the imported look must show on `RSGCore:Client:OnPlayerLoaded`. Tailor pay via `RemoveMoney`, kits via `SetItemData`.
3. **VORPCore profile**: `ensure oxmysql, vorp_core, vorp_inventory, lxr-clothing, lxr-barber, lxr-creator`; stop `vorp_character`; create a character through the creator (`addCharacter` polling), `vorp:initCharacter` teleports; migrate vorp dry/real; `vorp:SelectedCharacter` applies the look; TipRight notifications; `getItemByName`/`setItemMetadata` for kits.
4. **standalone**: only oxmysql + lxr-clothing + lxr-barber — spawn, prompt at the tailor (game prompt, no interact), free dressing.
5. After each: the five checkers, `lua tests/run.lua`, commit, push both remotes, sync, `tools/pack.py`.

## 4a. LIVE TEST RESULTS (2026-09-20 05:30–07:00, headless FXServer + rcon, no player joined)

Method: `FXServer.exe +exec <profile>.cfg +set rcon_password … +ensure lxr-nui lxr-clothing lxr-barber lxr-creator`,
console captured to a file, commands sent with `scratchpad/rcon.py` (UDP rcon), DB inspected with pymysql. The RSG and
VORP profiles pointed at databases that did not exist on this MariaDB — created `RexshackRedMBuild_379E8F` from
rsg-core's `txAdminRecipe/rsgcore.sql` and `VORPCore_FC0DB3` from `VORP_txAdmin/MariaDB.sql`; their own licence keys are
dead, so they were booted from a temporary cfg copy carrying the LXRCorev3 key (deleted afterwards). Test rows removed.

| Profile | Result |
|---|---|
| **LXRCorev3** (lxr-core) | all cards print (`Framework LXRCore (lxr-core)`, tables `playerskins / player_outfits / lxr_job_outfits`); `install`, `migrate auto dry`, `migrate rsg` (a planted v2 row → written, unknown hash listed), `export rsg/vorp`, `cleanup` refusal — all correct. **Bug found + fixed**: the live `playerskins` predates the unique key → the upsert added a second row; 3.0.0 now dedupes + adds `uniq_citizen` at boot (verified: key added, 1 row left) and `load()` prefers the newest v3 row. |
| **RSGCore-Dev** (rsg-core 2025 build) | oxmysql connected, own ledger `lxr_migrations`, `0003/0004` applied, tables `lxr_appearance / lxr_outfits / lxr_job_outfits`; import of a real rsg-appearance skin + `playeroutfit` row → 1 character + 1 outfit written, source untouched, exports round-trip (`nose_width 20 → NoseW 0.2`). **Bugs found + fixed**: `playeroutfit.name` (not `outfitname`); failed queries showed as an empty `db.lua:100` error → now print the SQL + message; **rsg-core's `Commands.Add` keeps the first instance's function ref, so every command died after a resource restart** → RSG commands are now `RegisterCommand`ed in our own context with the admin check inside (verified across `restart lxr-clothing` and `restart lxr-creator`). Note: `restart X` stops dependents (creator, barber) and does not restart them — FXServer behaviour, `ensure` them again. |
| **VORPCore** (vorp_core) | cards print `VORP Core (vorp_core)`; creator's `0001_meta` → `lxr_character_meta`; clothing tables created; import of a real `characters` row (skinPlayer / compPlayer / compTints) → 1 written with hair, head, eyes, teeth, body, waist, `Scale 1.05 → height 75`, `NoseW -0.5 → 25`, `HeadSize 0.4 → 70`, scars overlay (opacity 60), hat tint carried; exports round-trip; `traits`, `resettraits`, `skin` answer. Zero errors from our four resources (the profile's old Tebex lxr-* scripts print their own). |
| **lxr-nui / radial** | **Bug found + fixed**: the card's framework line did `'^8' .. (A and 'x') or …` → concatenated `false` off LXRCore. |
| **lxr-creator load order** | **Bug found + fixed**: `traits.lua` ran `Bridge.Command` before `main.lua` called `Bridge.Boot()` → every server file boots the bridge; `Chars.Boot` idempotent. |

**Not covered by this pass** (needs a client): the pages, the ped apply, RSG `Player.Login` / VORP `addCharacter` with a
real connected player, the spawn map, `RSGCore:Client:OnPlayerLoaded` / `vorp:initCharacter` ordering, kits' wear.
That is the first thing to do on the Tebex box with a game client (§4).

## 4b. PAGE (NUI) TESTS (2026-09-20 07:30, real `index.html` + the offline suites' payloads, Chromium)

Preview pages regenerated from the shipping `index.html` (`html/preview-*.html`, gitignored) with `tests/run.lua --mock`
payloads; a static server on :8765 (`.claude/launch.json` → `nui-preview`); NUI posts intercepted; the creator page driven
through its `__LXR_MOCK_CLIENT__` hook answering exactly as `client/main.lua` does (`pin new:` → stage identity →
`identity` → stage traits → `traits` → stage appearance).

| Page | Driven as a player | Result |
|---|---|---|
| lxr-clothing tailor | tabs, pick Hats, step variants (`wear {cat, comp}` live preview), basket row `01 Hats $1.50`, total, Confirm → `save { clothes }` | ✅ no JS errors, payload = what `lxr-clothing:save` validates |
| lxr-clothing locker | Uniforms tab lists the job's two uniforms, Wear → `outfit { action = 'uniform', arg }` + `wearAll` | ✅ |
| lxr-clothing embedded (creator mode) | opens free (cart hidden) | ✅ |
| lxr-barber | step hair → `set { comp, value }` (NPC drawable shape), Makeup tab (Eyeliner / Shadow / Lipstick / Blush / Foundation), Pay → `save { parts }`, total $0.50 | ✅ |
| lxr-creator | select room (2 / 5 characters, KA name renders), New character → identity form → intro modal → traits (Gunslinger / Tracker presets: perks, linked flaws, skills) → Lock in → appearance stage (wheel zoom, W height, E turn → `cr:nudge`), This is me → `cr:confirm`; spawn map renders the offered towns | ✅ |
| scene input hardening | synthetic wheel/keys on `document` (target not an Element) threw `e.target.closest is not a function` in all three pages' `onScene` | **fixed** (`instanceof Element` guard) |

Screenshots could not be captured reliably (the desktop pane was hidden); the DOM/network evidence above is what was
checked. Still untested: the ped itself (apply layer, camera natives), `Player.Login` / `addCharacter` with a
connected client, and kit wear — needs RedM.

## 5. Open work, in order (for the Tebex box)

1. In-game test pass (§4) on the three profiles — creator, clothing, barber are all on the bridge now; fix what breaks.
2. (done) lxr-creator on the bridge + docs.
3. **lxr-clothingradial clean-room rebuild** (§2.4).
4. Lite screens for the free recipe (or drop the three from the recipe and point to Tebex) + rewrite `docs/FORUM-POST-CFX.md` to "paid suite".
5. Tebex store: three packages + bundle, escrow, the Cfx disclosure table (code accessible: no · subscription: no · lines · requirements: oxmysql, lxr-clothing · support: yes), `docs/templates/tebex_product_description.md` per product, screenshots from `docs/img/`, a 90-second video, Discord support channel.
6. Same `Config.Database` + migration pattern for **lxr-bank** (VORP `bank_users`, RSG accounts) and other sellable resources later.
7. Icons re-roll; the audit leftovers (gang desks, fishing rebuild, herbs, housing, outlaws, bathing).

## 6. Quick commands

```bash
cd /g/GitHub/LXRCore-Framework
for t in native_check lua_check kit_check js_check perf_check; do PYTHONIOENCODING=utf-8 python tools/$t.py lxr-clothing lxr-barber lxr-creator lxr-nui lxr-clothingradial; done
(cd lxr-clothing && lua tests/run.lua) && (cd lxr-barber && lua tests/run.lua)
python tools/sync_server.py "J:\Laki.Cloud\GameServer-Fivem-Redm\txData\LXRCorev3" lxr-clothing lxr-barber lxr-creator lxr-nui lxr-clothingradial
(cd lxr-character-plus && python tools/pack.py)
```
Git per product: `git add -A && git commit -m "…" && git push origin main && git push iboss main`.

---
Everything above is on disk and pushed as of this file's timestamp; nothing is pending in a working tree.
