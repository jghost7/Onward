# Changelog

## 0.9.7

- **Removed Alliance-zone Horde guides:** Dropped `Dun Morogh (30-35)` (0 solo quests, Gnomeregan
  only) and `Westfall (16-20)` (Alliance starter territory) from Horde's guide list and
  recommendations, and excluded enemy-faction home zones in `tools/draft_all.py`.
- **Fail-closed faction filtering:** Added `W.PlayerFaction()` (with Classic + Skyborne race-ID
  fallback when `UnitFactionGroup("player")` is not yet populated at login) and `G:FactionMatches()`
  across the guide picker, recommendations, login restore (dropping any saved opposite-faction
  guide), profession trainers, travel, and bag cleanup.
- **Faction-friendly NPC selection:** Updated `tools/draft_guide.py` and `QuestieBridge.lua` to
  prefer NPCs friendly to the player's faction on shared quests, and rebuilt the 5 affected guides
  so Horde uses `Zaruk`, `Keeper Bel'dugur`, and `Jeremiah Payson` instead of Ironforge/Stormwind
  givers (and Alliance uses `Garion Wendell` instead of Undercity's `Owen Thadd`).

## 0.9.6

- **Mountain-wall flight routing:** Flight advice now uses a walkable Classic zone-border graph so
  it never lands on the wrong side of an impassable mountain ridge or sea barrier (for example,
  flying to `Tarren Mill, Hillsbrad` instead of `Hammerfall, Arathi` when heading to
  `Shadra'Alor, The Hinterlands`).
- **Full external prerequisite guidance:** When an `accept` step waits on a prerequisite from an
  earlier level band or zone (such as *Lack of Surplus* part 1 → part 2), Onward now guides you
  through all three stages (`PREREQUISITE · ACCEPT` → `COMPLETE` → `TURN IN`), routes to the giver,
  live objective areas, and finisher, targets its NPCs/mobs, and auto-accepts the prerequisite so
  it unlocks the gated quest smoothly.
- **Cleaner 2-line drop-rate display & faster luck feedback:** Reorganized item drop stats into two
  compact lines (`9/34 kills · 26% (avg 12%)` above `🍀 very lucky (+14%) · ~9 kills left`) to
  prevent mid-phrase wrapping, and lowered the luck-verdict threshold from 5 kills to 3 kills (plus
  early streaks at `|z| ≥ 1.5`).

## 0.9.5

- **Nav arrow status medallions:** Replaced the orphaned corner checkmark when hearthstoning or
  traveling across continents with centered Lucide medallions (`hearth` house with `"use
  hearthstone"`, `boat` ship for crossings, and `continent` globe for other-continent targets).
- **Safer fresh-install flight default:** Changed `Pick flight automatically` (`autoTaxi`) to off by
  default on new installs (existing saved settings are untouched; Onward still highlights the
  recommended destination on the flight map).

## 0.9.4

- **Uncrowded step-card actions:** Replaced the boxed `Later` and `Done` text pills with compact
  borderless Lucide icon buttons (`clock` for Later, `check` for Done) matching the panel header.
- **Drop-rate luck icons and variance colors:** Added Lucide four-leaf `clover` (lucky) and
  `cloud-rain` (unlucky) icons alongside escalating variance colors (soft green → bright emerald for
  `+1σ` / `+2σ+`, warm amber → vivid red for `-1σ` / `-2σ+`) highlighting both your observed drop
  rate and its percentage delta against the expected average.

## 0.9.3

- **Lucide icon overhaul:** Replaced all 17 UI icons with crisp 64×64 Lucide sprites (ISC license,
  credited in `CREDITS.txt`), including a new speech-bubble icon (`talk.tga`) on the Target button
  when targeting an NPC to talk to.
- **Objective source context:** Unfinished, non-obvious objectives now display what to kill, loot,
  click, or buy right under the objective row (e.g. `Kill: Gorishi Wasp, Gorishi Worker, Gorishi
  Reaver (+4)` and `Loot: Un'Goro Dirt Pile`), staying silent on already-obvious `slain` lines.
  Vague event or zero-objective steps with no guide note fall back to a concise quest-log summary.
- **Live Target button fallback:** `Target.lua` now pulls unfinished mob droppers live from Questie
  when a step has no baked `|mobs` list (restoring the Target button on out-of-zone objectives like
  *Bungle in the Jungle* and in the Quest Log smart guide).

## 0.9.2

- Fixed auto-accept requiring a second click on quest givers:
  - Follow-up quests offered immediately after a turn-in now auto-accept without waiting on the
    100 ms refresh debounce or stale `HeldReason` checks.
  - Multi-quest NPCs and turn-in + pickup NPCs now skip stale just-accepted / just-turned-in rows
    when `GOSSIP_SHOW` or `QUEST_GREETING` re-fires before `QUEST_LOG_UPDATE`, immediately selecting
    the next quest instead of stalling.
  - Added title-matching fallback for `QUEST_GREETING` when `GetAvailableQuestInfo` omits the quest
    ID, and `AcknowledgeAutoAcceptQuest()` handling for auto-accepted quests.

## 0.9.1

- Added **DialogueUI** support for highest vendor sell-value quest reward highlighting: detects
  active choice buttons inside `DUIQuestFrame.itemButtonPool`, refreshes on async item-cache loads
  (`GET_ITEM_INFO_RECEIVED`) while DialogueUI is open, hooks `DUIQuestFrame:RequestSellPrice`, and
  clears cleanly when DialogueUI closes or changes quest dialogs.

## 0.9.0

- **Hub-and-loop guide routing overhaul (all 103 zone guides rebuilt):**
  - Guides now start at the zone's main quest hub instead of lone roadside edge quests, flush all
    ready turn-ins and new pickups in a single town pass (`flush_hubs()`), batch nearby objectives
    into clean regional loops (`REGION_R = 9`, stronger area-change penalties), and group
    out-of-zone errands into a zone- and continent-ordered tour at the end.
- **Complete Elite, Dungeon, and Raid quest hiding:**
  - Merged Questie's Classic Era quest tag corrections (`Elite`, `Dungeon`, `Raid`, `Heroic`) with
    NPC-rank and instance detection, fixing 115 previously untagged object-loot, talk-to, and
    summoned-boss elite/dungeon quests (e.g. *Separation Anxiety*, *Dark Vessels*,
    *Kidnapped Elder Torntusk!*, *Summoning Shadra*, Uldaman, Gnomeregan, Zul'Farrak, and Forever
    dungeon quests) so **Elite and dungeon quests: Hide** reliably hides them and their follow-ups.
- **Removed dead and Season of Discovery quests:**
  - Applied Questie's WoW Forever quest blacklist and filtered `"no longer available"` entries,
    removing 77 unreachable/promo/SoD quests (including 54 Nightmare Incursion missions in
    Hinterlands, Feralas, and Duskwood).
- **Improved `Efficient` and `Fastest` quest value scoring:**
  - Computes zone median XP/min and the 85% / 60% XP floor against solo quests too, so heavy-elite
    zones never starve solo players when elites are hidden.
- Fixed rapid hover flashing on the step card's **Later** and **Done** buttons: **Done** now stays
  steadily visible beside **Later** on expanded cards instead of shifting layout on hover.

## 0.8.3

- Improved multi-zone flight advice: ground travel estimates now account for cross-zone road and
  terrain winding beyond 2,000 yards (while keeping short same-zone mounted rides direct), so
  multi-zone trips like Undercity → Tarren Mill → The Hinterlands reliably suggest flying on both
  60% and 100% mounts.
- Always refreshes flight advice on `TAXIMAP_OPENED` so live flight-map nodes take effect
  immediately.

## 0.8.2

- Fixed neutral-town flight master targeting (Gadgetzan, Booty Bay, Everlook, etc.): filters out
  opposite-faction taxi nodes and prioritizes reachable/authoritative flight master coordinates so
  Horde players are no longer pointed to Alliance flight masters (and vice versa).
- Added WoW Forever's cross-continent sea lanes to travel routing:
  **Powderfuse Port (Riverglades) ↔ Steamwheedle Port (Tanaris)** (neutral boat),
  **Stormwind Harbor ↔ Auberdine** (Alliance boat), and **Southshore ↔ Auberdine** (Alliance boat).
- Upgraded cross-continent travel planning to compare real total travel time (combining riding and
  known flight paths on both continents), check ready Hearthstones on the destination continent or
  toward the dock before suggesting boats/zeppelins, refresh crossings dynamically as you move, and
  look across all known flight networks near isolated local hubs.
- Restored the nav arrow toggle button in the panel header.

## 0.8.1

- Multi-choice quest turn-ins now highlight the reward with the highest vendor sell value
  (`sellPrice × stackCount`) with a gold border and formatted price badge (`2g 50s`, `15s`, etc.),
  handling ties, unsellable `0c` items, and async item-cache loads (`GET_ITEM_INFO_RECEIVED`).
- Added **Options → Questing → Highlight highest-value reward** (enabled by default).

## 0.8.0

- Interactive step rows: click any **ALSO HERE**, **AT THIS HUB**, or **ON YOUR WAY** row to focus
  that step (right-click to defer or mark done), and hover/click **NEXT** upcoming steps to inspect
  details or jump straight to them.
- Upgraded Guide Picker (`Onward/Picker.lua`): live search by zone, title, or level; thin visible
  scrollbar; section headers (Recommended, In Progress, Your Level, Other Zones, Completed); hover
  previews anchored cleanly away from the panel; and scroll reset on tab switch.
- Tabbed Options window (**Questing**, **Navigation**, **Appearance**, **Party & Tools**) with live
  color swatch previews for every theme, plus exposed **Header art**, **Route stops ahead**, and
  **List quests on your way** controls.
- Frosted-glass popups (`Onward/Popups.lua`) for **Items to bring** (checklist + copy button),
  **Quests to find** (drop notes + Map pin button), and **Skipped steps** (per-step **Go back** +
  **Restore all**), replacing chat dumps.
- Reliable Back (`<` / `/ow prev`) and skip recovery: tracks manual skips, `MarkDone`, and `Later`
  in a LIFO history stack so Back works past `goto`/`fly` steps, on `Quest log (auto)`, and across
  accidental end-of-guide switches; clicking a **Turn-in waiting** notice now jumps back to the
  unfinished quest; and manual skips show a clickable **Undo** toast.
- Fixed selecting a partially completed guide (such as Tanaris at 63%) from auto-jumping to another
  zone: manually activating a guide never auto-transitions to `next`, and automatically opens any
  remaining undone quests behind a stale resume frontier.
- Panel header, collapsed mode, toasts, arrow, and world map polish: decluttered 5-icon header with
  Gear right-click quick menu; compact 1-line collapsed summary with live distance; wrapping,
  clickable toasts; adaptive-width nav arrow pill with contextual travel/corpse badges and right-click
  quick menu; rounded World Map route pins with hover tooltips; and dead flat-skin texture pruning.

## 0.7.1

- Voluntary completed quest item cleanup (`/ow clean`, the "N old quest items" link in the panel
  footer, or Options → Tools → Clean quest items). Lists soulbound/quest-bound items in your bags
  whose entire quest chain is finished and no longer needed by any downstream quest, with per-item
  **Delete**, **Delete next** (one click per item, never automatic), and **Keep** buttons.
- Protects quest rewards, repeatable/war-effort items, tradable/vendorable/equippable/Rare+ items,
  usable dungeon/raid tools, and any item mentioned by an active quest in your quest log, with a
  live Questie cross-check when Questie is installed.
- Options → Panel → "Flag old quest items in bags" toggles the footer link.

## 0.7.0

- Restored all exploration and escort quests across every zone (187 quests, including The Fargodeep
  Mine, The Jasperlode Mine, The Forgotten Pools, The Escape, and the OOX escorts) that were
  previously filtered out along with repeatables, fixing dozens of broken follow-up chains.
- Fixed out-of-order quest steps: prerequisite chains with faction or class alternates no longer
  appear ahead of their own prerequisite, zone band splits keep chains intact, quests follow level
  progression instead of pulling high-level quests to the start of a zone, and routes stay within
  Classic's 20-quest log limit.
- Fixed forgotten steps: quests whose objectives are missing from Questie's Forever data now keep
  proper objective steps (and unfinished turn-ins stay active with live Blizzard objectives instead
  of being skipped), ready turn-ins are handed in before moving on to the next guide, and guide
  rebuilds no longer hide earlier steps behind a stale resume point.
- Smoother step flow: leveling up mid-objective no longer pulls you backward across the zone,
  breadcrumbs auto-complete if you already took or finished their target quest, failed escorts
  point you back to the quest giver, mob-drop starter quests no longer stall the route waiting on
  RNG (with a usable bag-item button once they drop), and multi-location objectives split into
  separate steps by objective name.
- Hub grouping and cleaner auto-accept: co-located town turn-ins and accepts group together on the
  card ("AT THIS HUB"), and auto-accept only takes upcoming hub quests (never skipped, Later, or
  far-ahead quests).
- Efficient mode now scores quests relative to their own level, so level 1-4 starting quests are no
  longer dropped in starter zones. Desolace routes cleanly follow the Gelkis centaurs instead of
  interleaving hostile Magram/Gelkis camps, and Stranglethorn's Green Hills ties cleanly to its
  four chapters.
- All 105 leveling guides were rebuilt from Questie's Forever database.

## 0.6.39

- A quest you take and hand in here but do in another zone no longer sits in the middle of the
  guide. "Screecher Spirits" sent you from Tanaris to Feralas partway through; the trip now
  waits until the zone is done, together with the hand-in and the quest that follows it.
  The same goes for the other guides. Guides were rebuilt from Questie's latest data, so step
  numbers shift.

## 0.6.38

- Fixed the error "NamePlate1:GetCenter(): Can't measure restricted regions". The target button
  read where enemy nameplates sit on screen to pick the mob you're facing, which the game no
  longer allows. It now takes the first untagged quest mob on a nameplate without measuring.

## 0.6.37

- First Aid: the guide sent you to the Triage quest at 210 skill, but the quest isn't on offer
  until 225. It now takes you to 225 first, then to the quest. Horde Cooking had the same
  mistake before its Artisan quest and is fixed too.

## 0.6.36

- Rogues: a Lockpicking 1-300 guide on the Professions tab. It takes you from the practice boxes
  (Alther's Mill for the Alliance, the pirate ship off Ratchet for the Horde) through the
  footlockers of each skill band up to Tyr's Hand, with an arrow to each spot, the skill the
  boxes need and the level each band takes. Only rogues are shown it.

## 0.6.35

- Quests that need an item in hand first now say so. "Marla's Last Wish" sent you to the grave
  without Samuel's remains, because the remains aren't one of the quest's listed objectives.
  63 steps like it across the guides now get a step of their own first ("First get ... from
  ..."), with an arrow to where the item comes from; it's done once the item is in your bags.
- Guides above your level are no longer recommended. A quest in your log could pull in a guide
  many levels up, and finishing a guide early moved you on to its next part whatever your
  level. A guide is now suggested from one level below its range, and at the end of a guide
  you're sent to one that fits your level when the next part is still above you.

## 0.6.34

- Travel is worked out live. Guides no longer contain "Fly to ..." and "Take the boat to ..."
  steps. A step only says where it is, and the arrow plans the way from wherever you are: a
  boat or zeppelin when it's on the other continent, your hearthstone when it's ready and
  faster, a flight between two points you've learned when that beats running, otherwise on
  foot. The step card shows the first leg ("first fly from Rog'mar to Undercity"). This ends
  the round trips and flights to nowhere that written travel steps caused whenever a quest
  was already done or not on offer.
- Guides are rebuilt without travel steps, so they are shorter and step numbers change.

## 0.6.33

- Items to bring. Some quests want something no mob drops: Frost Oil for "Coolant Heads
  Prevail", a potion, a crafted weapon, a drink from a vendor two zones away. The guide now
  says so before you get there: a "to bring" link on the panel lists every such item for the
  guide you're on, with where it comes from (which vendor, or which profession makes it), and
  the quest's own steps say "Bring ..." until it's in your bags. About 40 quests are covered so far.
- The target button works on people too. On a step where you talk to someone (pick up, hand in,
  innkeeper, trainer) it targets that NPC and puts a star over them, so you can find them in a
  crowded town. Same button and key binding as for quest mobs.
- On your way. Kill and loot quests already in your log are listed on the card when their mobs
  are near you or near where the step sends you, even if the guide hasn't reached them yet,
  and the target button picks up their mobs. /ow passing turns it off.
- /ow report <what went wrong> gives the current step, its state and your position as text to
  copy into a bug report. No character or realm name is included.
- Far fewer trips out of the zone in the middle of a guide. A hand-in or pickup in another zone
  that nothing in the current zone depends on now waits until you're done there, instead of
  riding along on some other trip. Boat and zeppelin trips in the middle of a guide drop from
  69 to 41 across all guides; the ones left are quest chains that really go overseas and back.
- No flight just because the next step is over a zone border: a flight is added only when it
  beats walking.
- Flight and boat steps say what the trip is for ("for: Turn in ...").
- All leveling guides are rebuilt, so step order changes again; progress carries over.

## 0.6.32

- Trips with nothing left to do are passed over whole. 0.6.31 dropped the flights of such a trip
  but left its boat steps and the last flight back, so a guide could still send you to Ratchet
  and back for nothing.

## 0.6.31

- All leveling guides are rebuilt from Questie's newest data, so step order changes in most
  zones. Your progress carries over: steps follow the quests you have done, not their numbers.
  Horde Azshara is now one guide and Horde Tirisfal Glades is two; if you were on one of those,
  pick it again with /ow guides.

- No more pointless round trips. When a guide flies you somewhere and back, and everything it
  wanted there is already done, skipped or not on offer yet, both flights are passed over.

- Riverglades, "Proof of Profit": the step now points to the Cubic Draconia crystal in the
  Cinderscale cave and says what to loot. It had no arrow and no location.

## 0.6.30

- The detail under a step's title is easier to read. It used to be one run of grey text; now each
  kind of information has its own line, led by a small icon: who to talk to, a boat or flight leg
  to take first, where to go (coordinates dimmed, distance in bright text), the note or hint in
  the warm hint colour, and anything else the step asks of you. Profession steps show their
  skill line the same way.

## 0.6.29

- Herbalism, Mining and Skinning: "Train Artisan" had no trainer to point at, and Journeyman and
  Expert could skip a nearer one. Their trainers teach every rank up to Artisan (only the Junior
  trainers in the starting zones stop at Apprentice), so each "Train" step now goes to the
  nearest of them.

## 0.6.28

- Profession guides sent you to the wrong trainer for a new rank. "Train Journeyman Engineering"
  pointed at Mukdrak in Razor Hill, a Journeyman Engineer, who only teaches Apprentice. A
  trainer's title is their own rank and they teach the one below it, so every "Train" step now
  points one tier up: Expert trainers for Journeyman, Artisan trainers for Expert, and Master
  trainers for Artisan. Specialisation trainers (Goblin and Gnome Engineer, Dragonscale,
  Elemental and Tribal Leatherworker, Shadoweave Tailor) are no longer offered for a rank.
- Artisan Enchanting says where to go: Annora, inside the Uldaman dungeon.

## 0.6.27

- The guide no longer stops on a quest it can't lead you to. "Accept Torn Mystical Scroll" in
  Stranglethorn showed no place and no hint: the quest starts from a dropped item, and neither
  the quest data nor Wowhead knows where it drops. Quests like that are passed over in the
  step order and listed on the panel instead ("2 to find here"): hover for what is known about
  each, such as the item it starts from, what drops it, and who takes it in the end. Get the
  quest and the guide takes it from there; when it starts from an item and that item is in your
  bags, its step comes up and says so.
- Party: after a /reload or login, every finished quest still in your log was announced again
  ("[Onward] done: ..." in party chat, and a toast for party members). A quest is now announced
  only when it goes from unfinished to finished while you're playing.
- Routes now use the nearest place for quests that can be done in several: the route planner
  works each such quest at the camp closest to the steps around it, instead of always the
  biggest camp. "Akiris by the Bundle" is now routed to the naga by Booty Bay when that's
  where the route is.

## 0.6.26

- Quests whose mobs or objects sit in several places well apart ("Akiris by the Bundle": naga
  on the north coast of Stranglethorn and again near Booty Bay) now know all of them. The step
  points at the place nearest you, and follows you if another becomes clearly nearer. The panel
  shows "Area 1 of 2" with the place name: hover for the list with spawn counts and distances,
  click (or `/ow area`) to send the arrow, the pin and the map route to the next one and stay
  on it, for a camp that's overrun or one that suits where you're heading. The other places
  are marked on the world map.

## 0.6.25

- Riverglades (Horde): "Step One: Rock" came up near the start of the guide, but Gorgegut and
  Hamur don't offer it until "Land of Giants" is done, which the quest data doesn't say. The
  guide now takes it after that quest's turn-in. Corrections like this live in
  `tools/quest_fixes.json`.

## 0.6.24

- About 300 quests were in no guide because the quest data gives them no zone, most of them in
  the new zones. They now go by where their quest giver stands. Mount Hyjal grows from 22 to 128
  quests (Alliance; 18 to 123 Horde), Riverglades from 87 to 108 (72 to 91), Shen'dralas from 16
  to 37 (8 to 29), and Moonglade gets a guide. Since 0.6.22 every quest that follows one of the
  missing ones was held back with nothing leading to it; those are back in the route.
- A quest that follows one the guide doesn't cover (a chain that starts in another zone) now
  comes up at the end of the guide marked "after <quest>", with the arrow on that first
  quest's giver when Questie knows it, instead of staying hidden.
- Alterac Mountains and Hillsbrad (Alliance) and Shen'dralas (Horde) are now two guides each.
  If one of those was your guide, pick it again with /ow guides or /ow suggest.

## 0.6.23

- The step count on the panel (122/226 on a new character in Riverglades) started at the number
  of quests not on offer yet instead of 0: since 0.6.22 those steps were counted as done. They
  now count as still ahead. Only the number was wrong; the steps and their order were not.

## 0.6.22

Quest and step logic, after an audit of how quests and steps connect:

- Picking a quest up before the guide asks for it no longer makes the guide jump ahead and mark
  the quests in between as missed. Where a guide resumes is now worked out once per guide and
  character, from the quests you've turned in, and kept; `/ow resume` works it out again.
- Skipping an accept step skips the quest: its objectives and turn-in no longer come up as the
  next steps. Pick the quest up anyway and they come back.
- Skips and ticked notes stay on their own step when you change the quest mode or the elite
  setting, and when a guide is updated. They used to be saved by step number, which moved. Skips
  saved by the old numbers are dropped once, since they can't be matched to steps any more.
- Quests the game won't offer yet (you're under their level, or the quest before them isn't
  turned in) are passed over instead of sending you to a quest giver with nothing for you, and
  come back when they're on offer. The generated guides carry each quest's level and the quests
  it follows (`|lvl`, `|pre`, `|preany`).
- A step behind you that opens again (you lost a quest item, or took a quest you had skipped)
  brings the guide back to it right away, not only after a relog.
- Guides: the route optimizer could place a turn-in before its own accept (109 steps in 27
  guides, Tanaris and the Hinterlands most). It can't any more, and `python tests/run.py` now
  checks every guide's step order and tags.

## 0.6.21

- A flight point you've discovered but can't reach from here (Rog'mar in Riverglades before its
  connecting flight point is learned) is no longer picked: Onward now reads the flight map's
  own route check, which tells those apart (the game's node list calls them reachable). At the
  flight master it says once that a connecting flight point is still to find, flies you to the
  nearest point it can reach, and the arrow leads on.

## 0.6.20

- The guides now know Forever's own flight masters (Grakna and Gretchen Mayberry in Riverglades,
  Fayran Elthas in Mount Hyjal), which the quest data doesn't mark as flight masters: trips to and
  from Riverglades fly there instead of running.
- Flight points on a network of their own (Riverglades' flight point, learned before any flight
  connects it to the rest) no longer get suggested from flight masters that can't reach them.
  Each flight master shows which points it really flies to; Onward remembers that per character,
  and at the flight master it re-plans on the spot: it flies to the nearest point it can reach
  and the arrow leads the rest of the way.
- Flight advice now compares travel times using your own speed: on foot, or your mount's once
  you've ridden it. A flight is suggested when it saves at least 30 seconds and 15% of the trip.
  On foot that catches flights it used to miss (Booty Bay to Grom'gol for the north of
  Stranglethorn); mounted, it no longer sends you to a flight master to save a few seconds.
- The guides use the same rule and measure in yards (a zone map is rarely square: Stranglethorn
  is half again as wide as it is tall). Ten more flights inside zones, in Stranglethorn, the
  Barrens, Stonetalon, Ashenvale, Mulgore and Thousand Needles.
- After you die and release, the arrow leads back to your body ("Back to your body", then the
  step you were on) instead of the quest. Once you're alive again, at your body, a spirit healer
  or from a resurrection, it goes back to the guide.
- On the way to a boat or zeppelin across the continent, the flight master now marks the flight
  point nearest the dock (Ratchet, say) on the flight map and takes that flight. The arrow reads
  "Fly: <here>, to Ratchet, then take the boat to Booty Bay" instead of pointing straight at the
  dock thousands of yards away.

## 0.6.19

- At the end of a guide, the "Guide complete" card no longer offers the guide you just finished
  (it did when some of its turn-ins were skipped and their quests were still in your log). The
  guide list's "recommended" tag skips it too.
- The options window drops the route recorder buttons (Record route, Show recording) and the
  Header art choice. The art behind the panel header is off for now.

## 0.6.18

- Five new looks under Options > Panel > Look, each a dark glass with a highlight from the other
  side of the colour wheel: Twilight (teal on violet), Alliance (gold on navy, blue edge), Horde
  (ember red on blood-iron, bronze edge), Feywood (glowing fae green on deep moss, violet edge) and
  Neon (hot pink on deep purple, teal edge). The Look picker wraps onto a second row.
- The guides no longer fly between continents: the generator now routes those trips through the
  boat or zeppelin (fly to the dock, "Take the boat to Ratchet", fly on from the far side). 145
  impossible flights across the guides became 211 travel steps.
- A step on the other continent (a flight to Feralas from Booty Bay, say) now sends you to the boat
  or zeppelin first: "Take the boat to Ratchet", picking the crossing that makes the whole trip
  shortest for your faction (Booty Bay - Ratchet; Grom'gol and Undercity - Orgrimmar zeppelins;
  Menethil - Theramore and Auberdine boats). Across, a fly step starts from the learned flight
  point nearest you instead of the guide's departure on the far side.

## 0.6.17

- Fly steps to a flight point you haven't discovered yet: the flight master now flies you to the
  learned flight point nearest it, and from there the arrow leads you on foot to the destination's
  flight master so you learn it. When no learned point gets you closer than where you start, it
  sends you there on foot straight away. The arrow and step card say which.
- That step now completes at the flight master itself (20 yd), not 150 yd out, so you don't move
  on before the flight path is learned.

## 0.6.16

- Animations, each small and played once:
  - Quest ready to turn in: a soft sheen sweeps across the step card and the step label glows.
  - An objective finishes: its "done" pops and the line eases to the dimmed colour.
  - The progress bar slides to its new length with a glint at the front.
  - A new step: the card fades up a few pixels into place.
  - Arriving: one soft ring pulses out from the arrow's check mark.
  - Guide finished: the header art warms to full colour and back, and the bar glows.
  - The flight point marked on the flight map breathes slowly while the map is open.
- Nothing animates in combat (anything running finishes at once when a fight starts), and
  Options > Panel > Animations turns them all off.

## 0.6.15

- The notice under the step card is back to its thin outline, now with all four edges: the top and
  left edges had been disappearing when the outline was scaled down. (0.6.14's glow there is gone;
  the glow belongs on the flight map only.)

## 0.6.14

- The notice under the step card (turn-ins waiting, left for later) has a soft glow in Onward's
  colour instead of an outline. The outline's top edge had been disappearing.
- The flight point marked on the flight map gets a soft round glow behind it instead of a square
  border.

## 0.6.13

- The flight master now picks the flight the arrow suggested. Talking to the flight master
  refreshed the guide, which cleared the wanted flight just before the flight map opened, so
  nothing happened. The flight is also matched by name now, not only by position.
- The wanted flight point gets a glow on the flight map, and chat names it. With "Pick the flight
  automatically" off, or Shift held, it's marked for you to click.
- If this flight master can't reach the wanted flight point yet, chat says so.

## 0.6.12

- Logging in no longer drops you back on quests you skipped earlier in the guide. The step was
  picked before the game had loaded your quest records; for the first seconds after login the guide
  now rescans from the start whenever they arrive (what re-picking the guide used to fix).

## 0.6.11

- The quest mob target button skips mobs someone else has tagged: with enemy nameplates on, out of
  combat, it goes for an untagged quest mob (the one nearest the middle of your screen). Without
  nameplates, or once you're in combat, it targets the nearest quest mob by name as before.

## 0.6.10

- Route on the world map, Current: once you're at the step the line had nothing to draw, so the map
  showed no route. It now shows the way to the step after it.

## 0.6.9

- The quest mob target button lets go of a mob once you have what it's there for: the guides now say
  which item each mob drops, so when "Sand Crawler Meat" is done the button stops targeting Sand and
  Shore Crawlers and sticks to the murlocs. Kill objectives already dropped out when finished.

## 0.6.8

- The notice under the step card (left for later, ready to turn in, a better guide) is no longer a solid
  block of the accent colour, which washed out its text: it's a thin rounded accent outline with a faint
  tint, and the text reads like the rest of the panel.

## 0.6.7

- **Font picker** (Options > Panel > Font): choose the font for all of Onward's text (panel, arrow, options). Lists the game's fonts plus every font your other addons share through SharedMedia, each drawn in its own font. Automatic (the default) keeps EllesmereUI's font, or each look's own. A font whose addon you remove falls back to Automatic.

## 0.6.6

- Options > Panel > Look: the descriptions now match what you get. With EllesmereUI installed the
  Ellesmere look says it uses your EllesmereUI colours (not "green highlights"), and every look
  says its text uses your EllesmereUI font.

## 0.6.5

- The text under the nav arrow (distance, arrival time, where it's pointing) is no longer in a box:
  it sits on a soft dark fade with a firm shadow, so it reads on bright ground without a panel.
- **Arrow text size** is its own setting now (Options > Navigation), apart from the arrow's size.

## 0.6.4

- **Ink-and-wash zone art** behind the header for 22 zones (more to come): a generated painting
  of each zone's landscape, grey, very faint and evened out so every zone sits equally quiet,
  fading in only after the title. The window is no taller. Zones without one show the map strip.
  Options > Panel > Header art: Zone shot / Map / Off.
- Screenshot pictures (`tools/make_zone_art.py`) are grey and fainter too.

## 0.6.3

- The map strip behind the header is now grey only and much fainter, and it stays clear of the
  guide's title (it fades in after the title, toward the buttons), so the header reads cleanly.
- Header art pictures can be screenshots (`tools/make_zone_art.py`) or generated ink paintings
  (`tools/gen_zone_art.py`, not shipped for now).

## 0.6.2

- **Header art: Zone shot / Map / Off** (Options > Panel). "Zone shot" shows a faded picture of the
  guide's zone behind the title, made from real screenshots; zones that don't have one yet show
  the map strip. Pictures come from screenshots: Onward now notes the zone of every screenshot you
  take, and `tools/make_zone_art.py` turns them into header pictures (hide the UI with Alt+Z first).
  No zone has one yet.

## 0.6.1

- **Later** moved to the top-right corner of the step card, in both layouts: no longer next to the
  target and item buttons (or in the dock), where a hurried click could send the quest to the end.
- Objectives written count first ("0/12 Saltwater Murloc Eye", as Forever's quest log does) now
  split properly: the name on the left, the count once, on the right.
- The action strip only shows when there's a mob to target or an item to use.

## 0.6.0

The panel, redesigned around the current step (direction A from the mock-ups):

- **The step card reads top to bottom:** what kind of step in small capitals (KILL, LOOT, TURN IN,
  FLY ...), the quest title at full width, then one location line.
- **Action strip** under the title: the target button, the quest item buttons and a **Later**
  button in one row, instead of squeezed into the corner over the title.
- **Objectives** get their count on the right and a thin progress bar. Drop-rate lines appear only
  once there is something to say (no more "counting your kills" before your first kill).
- **Also here** is a compact list: one row per grouped quest with its total progress; hover for its
  objectives and hint.
- **One notice at a time** (busy area, ready to turn in, back near a quest left for later, a waiting
  turn-in, a better guide). The rest, and missed quests, are short links in a footer row.
- **Next** steps under their own label.
- **Zone art:** a faded strip of the guide's own zone map behind the header, so each guide looks a
  little different. Options > Panel > Zone art in the header.
- **Dock:** Options > Navigation > Buttons in a dock moves the target, quest item and Later buttons
  into a glass dock of action-button-sized buttons with your key bindings on them; place it above
  your action bars (right-drag the target button).

## 0.5.4

- Several quest item buttons when you need them: when the quests you're working on together each
  have an item to use, one button per item (up to four) in a row beside the target button, the
  current step's first. Each has its own key binding (Use quest item, 2, 3, 4).

## 0.5.3

- **Quest item button.** On a step where the quest has you use an item (fletch the Wood Bundles,
  throw the spear at a crocolisk), a button that uses it appears beside the target button, or
  beside the detached target button. It shows the item's icon, count and cooldown. Bind a key under
  Key Bindings > AddOns > Onward; turn it off in Options > Navigation. It uses the item the quest
  hands you, or a usable quest item in your bags that the quest's text names.
- Looked-up spots for Riverglades quests Questie has no data for (Fetch 'n' Fletch, A Boar's
  Delight, Hats Off, Stuff 'Em and Stick 'Em, Apple of My Eye, Her World), from Wowhead's WoW
  Forever database. The arrow goes to the nearest bush, bale or woodpile, and drops an objective's
  spots once it's done. More to come (`tools/quest_spots.json`).
- Hints for Hats Off (the hat is in a clam shell) and Fetch 'n' Fletch (fletch the bundles).

## 0.5.2

- Quests whose objectives Questie has no spawn data for (many of Forever's own quests) now get a
  location from their own text: the mobs it names ("Paletusk Harvesting" -> the Paletusk boars)
  or the place it names ("Wood Bundles ... in Turner's Logging Camp"). Fetch 'n' Fletch now has
  an arrow, and steps without a pin went from 295 to 208 across the guides.
- Routes rebuilt. Steps nobody could place no longer drag the route around (they used to sit
  wherever the step before them was), and hand-ins in another zone are saved up for one trip
  instead of sending you away mid-zone. Total travel is down 28%, zone changes down 43%.
  Fetch 'n' Fletch is now done together with Borrowed Blades at the logging camp.
- "Also here" no longer lists a quest across the zone just because the current step has no pin.

## 0.5.1

- A step for a quest you haven't picked up (you skipped past its giver) now sends you there:
  "Pick up WANTED: Trapclaw first", with the giver's name, where they are and the arrow on them,
  instead of just "not in quest log". Once you have the quest it goes back to the step.
- Locations are named where the map names them: "Powderfuse Port · 83.0, 52.0", or
  "Tarren Mill, Hillsbrad Foothills 62, 21" for another zone. Uses the world map's own named
  areas from Forever's client data (`tools/make_places.py`).

## 0.5.0

- **Hearthstone advice.** When your hearthstone is ready and hearthing beats running or the best
  flight to the next step by a clear margin, the arrow says "Hearth to <town>". Never while it's
  on cooldown. Options > Travel > Suggest your hearthstone.
- **Set your hearthstone here.** Every guide now tells you where to set it: at the inn of its
  busiest quest hub (Tarren Mill in Hillsbrad, Goldshire in Elwynn, the Crossroads in the
  Barrens), the first time you get there. Already bound there? The step ticks itself off.
- Onward learns where your hearthstone takes you when you set it, or whenever you're in that
  town. `/ow arrow debug` shows what it knows.
- Flight steps name the place you fly to ("Fly to Tarren Mill, Hillsbrad", the flight point's
  in-game name) instead of the flight master; the flight master is on the line below.

## 0.4.2

- **Quest hints.** Tricky quests get a short note on the step card: one for the quest, and one
  under each objective you still need (gone once you have it). First up: Deep Sea Salvage, with
  where each chart and log is inside the two sunken ships.
- Your own notes: `/ow hint <text>` adds one to the current quest (all your characters see it),
  `/ow hint clear` removes it, and `/ow hints` lists them all, ready to paste into a GitHub issue
  so they can go into the addon for everyone.
- Hover the step card to read the quest's own text from your quest log, which often says where
  to go.

## 0.4.1

- Nav arrow on kill and loot steps whose mobs are over a zone border, like Bracers of Binding
  and The Crown of Will (Hillsbrad quests done in Alterac Mountains). The guides now point into
  the neighbouring zone: 133 more steps have a location.
- Any step still without a location falls back to the nearest place Questie knows the objective
  can be done, instead of showing no arrow.

## 0.4.0

- **Come back later.** When an area is overrun and you're fighting other players for tags, set
  the quest aside: the guide moves on and lists it under "Left for later". It offers it again
  when you're back in that area, and brings you back to it at the end of the guide before moving
  to the next one. Shift-right-click the step, type `/ow later`, or click the busy prompt.
- **Busy areas are spotted for you.** With enemy nameplates on, when most of the quest's mobs in
  sight (3 or more) are tagged by other players, the panel says so ("Busy: 5 of 7 here are
  tagged by others") and offers to come back later.
- **Target button on its own.** Options > Navigation > Target button on its own: the quest-mob
  target button leaves the step card and becomes an action-button-sized button you can put
  anywhere, e.g. beside your action bars. Right-drag it to move it (out of combat).

## 0.3.4

- No drop-rate line on items you loot from objects (chests, crates, things on the ground), like
  the charts and logs in Deep Sea Salvage: a rate per kill means nothing there. Uses Questie's
  item sources, so without Questie the line still shows.

## 0.3.3

- With EllesmereUI installed, its font is used in every look again (0.3.2 limited it to the
  Ellesmere look). Its colours still apply only to the Ellesmere look.
- Switching the look recolours the selected option buttons right away; they kept the previous
  look's highlight colour until the window was reopened.

## 0.3.2

- **The way you came.** Heading back to a quest giver you walked away from, the arrow now follows
  your own path (around the cliff, over the bridge) instead of a straight line through it, and
  the map route draws that path. The distance shown is the whole way back. It points straight
  again once you're close, if you've left the path, or when your path was a long detour.
  Onward keeps the last few kilometres you walked; a flight, hearthstone or teleport starts it
  over. Options > Navigation > Lead back the way you came.
- Every look is frosted glass now, each in its own colours: **Onward** (teal glass, gold edge,
  gold highlights; the default), **Glass** (blue-slate, green) and **Ellesmere** (neutral dark,
  green, plain font; takes your EllesmereUI colours and font when it's installed). Ellesmere
  replaces the old square Flat look.

## 0.3.1

- New look to match the logo, and the default for new installs: deep teal panels, a thin gold
  border, gold highlights and Warcraft-style headings. Already using Flat or Glass? Pick
  **Onward** under Options > Panel > Look.

## 0.3.0

- **The addon is now called Onward.** Same addon, new name. The command is `/ow` (or `/onward`);
  `/sq` still works for now.
- **Upgrading:** delete the addon's old folder from `Interface\AddOns`, or both copies
  load and fight over the panel. Settings start fresh under the new name: the game keeps saved
  settings per addon folder, so it can't hand the old ones over by itself.
  `tools/migrate_settings.py` in the source copies them across (run it with the game closed).

## 0.2.6

- The recommended guide is easier to find. In the guide list it's always labelled "recommended"
  in the accent colour, even when you've already made progress in it (before, the progress
  percentage replaced the label, so it looked unmarked).
- When the guide you're on stops fitting (you've out-levelled it, finished it, or are on the
  quest-log guide without having chosen it), the panel shows "Suggested: <guide> · click to
  switch". Right-click the line to hide that suggestion.

## 0.2.5

- Less back and forth. Every route was rebuilt to finish one area before moving to the next:
  across all guides, 24% fewer trips back to an area you've already left (Darkshore 14 → 6,
  the Barrens 21 → 13, Elwynn Forest 28 → 22). The returns that are left mostly come from quests
  you're not high enough level for on the first pass, and from chains that send you back to the
  quest giver.
- Elite and dungeon quests are marked on the panel ("Elite: bring a group", "Dungeon quest"),
  and so are follow-ups that need one of them first. To leave them all out for solo play, use
  Options > Elite and dungeon quests > Hide, or `/sq group hide`.
- Zephras Isle now includes the Skyborne-only quests that were missing: Falling With Style,
  Reading the Leylines and The Missing Scholar (Alliance), plus The Gift of Skysight (Horde).
  The level 40 riding quests are listed at the end of the guide.
- Other zones pick up their Skyborne-only quests too, and every guide is rebuilt from Questie's
  current data.

## 0.2.4

- Recommended guide. A new character no longer starts on an empty quest-log guide: a few seconds
  after login it switches to its starting zone's guide (Elwynn Forest, Dun Morogh, Teldrassil,
  Durotar, Mulgore, Tirisfal Glades or Zephras Isle), whose first step is the first quest to pick
  up, with the arrow on the quest giver.
- Later on, the recommendation follows the quests in your log, the zone you're in and your level.
  It's first in the guide list (marked "recommended"), the panel offers it whenever there's
  nothing left to do, and `/sq suggest` switches to it.
- Choosing "Quest log (auto)" in the guide list yourself keeps it; it's never swapped out.

## 0.2.3

- Guides leave out quests your character's race or class can't get, so they no longer show up as
  missed or not done:
  - Forever's Skyborne races are recognised. Skyborne-only quests used to reach every character
    of the faction; Skyborne characters now also get the quests open to all of their faction's races.
  - Follow-ups inherit their chain's limits: if only night elves can do the first quest, only night
    elves see the rest of the chain. This covers most of the Alliance Zephras Isle story, which
    starts from a Skyborne-only quest, plus a few chains in Teldrassil, Tirisfal Glades, Mulgore,
    Tanaris and the Eastern Plaguelands.

## 0.2.2

- The Professions tab in the guide list really works now, and so does `/sq prof`: the tab state
  was a stray global the list never read, so clicking did nothing. 0.2.1's fix was for the wrong
  cause.

## 0.2.1

- The Professions tab in the guide list can be clicked again (its click area was almost zero
  wide when the font loaded late). Both tabs now highlight on hover.

## 0.2.0

- Profession guides, 1 to 300, for every profession: Alchemy, Blacksmithing, Enchanting,
  Engineering, Leatherworking, Tailoring, Cooking, First Aid, Herbalism, Mining, Skinning and
  Fishing, for both factions. Open them with `/sq prof` or the new Professions tab in the guide list.
  - Crafting: which recipe to make up to which skill, about how many crafts, and the mats for the
    rest of the run against what's in your bags and bank. Recipes you buy are named, and the arrow
    takes you to the nearest vendor that sells them; training steps point to the nearest trainer.
  - Expert and Artisan Cooking, First Aid and Fishing: the book to buy and the quest to do.
  - Herbalism and Mining: the best zone for each skill band, by node count. Skinning: the beast
    levels to skin. Fishing: the waters for each band.
  - Checked against the game: open your profession window once and the guide sees the recipes you
    know and their real colours. Recipe names on the panel show that colour, and when the planned
    recipe has gone green or you lack the mats, it suggests the best orange or yellow you can make now.
  - Routes come from Forever's own client data, so Forever's recipe changes are included; they
    are estimates and haven't been played through yet.
- The panel now grows downward when a step has more lines, instead of out from the middle.

## 0.1.2

- The drop rate line now shows on "collect" objectives from the start, before your first kill:
  the expected rate and a kill estimate when Questie has one, otherwise "counting your kills".
  Before, it stayed hidden until a kill or drop had been counted, so it looked missing.
- Item objectives the game doesn't label as items are recognised through Questie's quest data.
- Clearer auto-flight message: "Auto flight to X. To pick your own destination, hold Shift when
  you talk to the flight master." (Only shown while auto flight is on.)

## 0.1.1

- Renamed. Commands are now `/sq`; settings start fresh once.
- Drop rates on "collect" objectives: how many of your kills dropped the item, the expected
  rate (Wowhead's, read from Questie) and whether you're luckier or unluckier than that, with
  an estimate of the kills left. Kills are counted as mobs you fought die (target and enemy
  nameplates), so kills that drop nothing count too. `/sq drops` lists everything tracked;
  `/sq drops debug` shows what the kill counter can see.
- New flat look (the default): solid dark panels, thin borders, square buttons and a green
  accent. With EllesmereUI installed it takes your EllesmereUI accent colour, panel colour and
  font. The old frosted glass is still there: Options > Panel > Look.
- The drop line also shows the rate per looted corpse next to the rate per kill.
- Travel route on the world map: a dotted line to the current step (via flight masters when
  flying is faster) and on to the next three stops, numbered. Options > Navigation.
- Steadier nav arrow: kill and loot steps point at the nearest mobs instead of the middle of the
  area; a suggested flight no longer flips on and off as you walk; the arrow keeps working in
  caves and buildings, and holds its last direction when the game hides your facing.
  `/sq arrow debug` shows what it is working from.
- A turn-in for a quest you haven't finished (say you skipped a boss) no longer becomes the
  current step. The guide tells you and moves on; the panel shows it as waiting, and once the
  quest is done it turns into "Ready to turn in" (click to go back for it).

## 0.1.0 - first test build

- Guides for every open-world Forever zone, both factions: classic zones plus Riverglades,
  Zephras Isle, Mount Hyjal and Shen'dralas. Routes are generated from Questie's database
  and have not been played through yet.
- Quest modes: All, Efficient (skips clear time sinks) and Fastest (best XP per hour).
- Picks up where you are: quests you already completed are skipped, missed ones listed.
- Nav arrow with distance and arrival time; flight-path advice and automatic flight pick.
- Quest-mob target button and key binding, covering every kill quest in the area.
- Auto accept and turn-in (hold Shift to pause), party progress sharing (works with Questie).
- Route recorder: `/sq rec` writes a guide as you play.
