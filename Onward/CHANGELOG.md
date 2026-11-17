# Changelog

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

- **Sloppy Questing is now Onward.** Same addon, new name. The command is `/ow` (or `/onward`);
  `/sq` still works for now.
- **Upgrading:** delete the old `SloppyQuesting` folder from `Interface\AddOns`, or both copies
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

- Renamed from Wayfarer to Sloppy Questing. Commands are now `/sq`; settings start fresh once.
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
