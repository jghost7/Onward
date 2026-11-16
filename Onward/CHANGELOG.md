# Changelog

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
