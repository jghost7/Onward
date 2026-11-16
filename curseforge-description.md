<!--
CurseForge project text for Onward. Two parts:
  SUMMARY     -> the project's "Summary" field (one line, shown in search results)
  DESCRIPTION -> the "Description" field (set the editor to Markdown, paste everything below the line)
-->

SUMMARY:
Free leveling and profession guide for WoW Forever: every zone, 1-300 in every profession, nav arrow, quest-mob targeting. Beta.

---

# Onward

*Formerly Sloppy Questing. Upgrading? Delete the old `SloppyQuesting` folder from your AddOns first.*

**A free leveling guide for World of Warcraft: Forever.** Onward tells you what to do next, points you there, and keeps up as you play: pick up these quests, kill these mobs, hand them in, take this flight.

> **Beta.** The routes are generated from quest data and have not all been played through yet. Expect the odd step in a strange order. Please report what you find (see *Reporting problems* below).

## Every zone, both factions

- Guides for all open-world zones from 1 to 60, Alliance and Horde.
- Includes the Forever zones: **Riverglades, Zephras Isle, Mount Hyjal and Shen'dralas**.
- Zones that span a wide level range are split into bands, and each guide hands you on to the next.
- Routes finish one area before moving to the next and keep running back and forth to a minimum. They take flight paths where flying is faster.

## Profession guides, 1 to 300

Every profession for both factions: Alchemy, Blacksmithing, Enchanting, Engineering, Leatherworking, Tailoring, Cooking, First Aid, Herbalism, Mining, Skinning and Fishing. Open them with `/ow prof`.

- What to craft up to which skill, about how many times, and the mats for the rest of the run against what's in your bags and bank.
- The arrow takes you to the nearest trainer when it's time to train, and to the nearest vendor for recipes you buy.
- Herbalism and Mining name the best zone for each skill band.
- It checks the plan against the game: open your profession window once and it sees your recipes and their real colours. When the planned recipe has gone green, or you're out of mats, it suggests the best orange or yellow recipe you can make right now.
- Built from Forever's own game data, so Forever's recipe changes are in.

## Skip the quests that aren't worth it

Choose how thorough you want to be, in Options or with `/ow mode`:

- **All:** every quest in the zone.
- **Efficient** (default): leaves out clear time sinks, like long collection grinds for little XP. Keeps at least 85% of each zone's XP.
- **Fastest:** the best XP per hour. Keeps at least 60% of each zone's XP, so you move on to the next zone sooner.

A quest that unlocks a worthwhile follow-up is always kept.

Elite and dungeon quests are marked on the panel ("Elite: bring a group"). Playing solo? Hide them, and any follow-ups that need them, in Options or with `/ow group hide`.

## Picks up where you are

A new character starts straight on its starting zone's guide, with the arrow on the first quest giver. Later, the recommended guide follows your quest log, the zone you're in and your level: it's first in the guide list, marked "recommended". When the guide you're on stops fitting, the panel suggests the better one, and `/ow suggest` switches to it.

Install it on a character you've already been playing and Onward works out what you have done. Completed quests are skipped. Quests you passed by are listed so you can go back for them, or not.

## Getting around

- **Nav arrow** with distance and arrival time. It turns green when you face your target.
- **Flight advice:** when a flight path you know beats running, the arrow points you to the flight master and Onward picks the flight for you. Hold Shift to choose yourself.
- **Route on the world map:** a dotted line to the current step and on through the next three stops, numbered, with flight legs marked.
- On kill and loot steps the arrow points at the nearest mobs, not the middle of the area.
- Map pin on the current step, and TomTom support if you use it.

## Quest-mob targeting

On kill and loot steps a crosshair appears next to the step. Click it, or **bind a key** (Key Bindings > AddOns > Onward), to target the nearest living quest mob and put a skull on it. When several kill quests share an area, Onward lists them together and the button covers all of them.

## Drop rates: lucky or not?

For "collect" quests, each item objective shows your own drop rate per kill and the expected one (turn on enemy nameplates so kills you don't target are counted too), e.g. *3 in 14 kills (21%) · Wowhead 35% · unluckier · ~9 more kills*. The expected rates come from **Questie** (install it to see them; your own rate works without it). The Forever-only zones mostly have no expected rates yet. Stats add up across your characters; `/ow drops` lists them.

## Less clicking

- Accepts the guide's quests and turns in finished ones. Hold Shift at an NPC to pause.
- It never chooses between quest rewards for you.

## Questing with friends

- See your party's progress on the current quest: who has it, how far along they are, who is ready to turn in.
- Works with party members running Onward, and with those running **Questie**.
- Optional pop-ups and party chat messages when someone finishes a quest.

## Looks and feel

A compact panel showing the current step, its objectives and what comes next. The default look is flat and dark with a green accent; with **EllesmereUI** installed it takes your EllesmereUI accent colour, panel colour and font. Prefer frosted glass? It's under Options > Panel > Look. Opacity, size, number of upcoming steps and more are in the options (`/ow options`, the gear on the panel, or Esc > Options > AddOns).

## Write your own routes

`/ow rec start` records a guide as you play: every quest you accept, complete and turn in, and every flight. `/ow rec show` gives you the text to keep or share.

## Commands

| Command | What it does |
|---|---|
| `/ow` | Show or hide the panel |
| `/ow guides` | Choose a guide |
| `/ow suggest` | Switch to the recommended guide |
| `/ow prof` | Profession guides |
| `/ow options` | Options |
| `/ow mode all` / `efficient` / `fastest` | Which quests to include |
| `/ow group show` / `hide` | Elite and dungeon quests in the guides |
| `/ow next` / `/ow prev` | Skip ahead or go back a step |
| `/ow arrow` | Show or hide the nav arrow |
| `/ow drops` | Your quest-item drop rates vs the expected ones |
| `/ow reset` | Reset frame positions |

## Optional addons

- **Questie:** more accurate quest locations, party progress and expected drop rates.
- **TomTom:** adds TomTom waypoints alongside Onward's own.
- **EllesmereUI:** the panel matches your EllesmereUI colours and font.

None of them is required.

## Reporting problems

Please leave a comment with:

- the guide name and the step you were on;
- what you expected and what happened;
- for errors, the full text from **BugSack** (install BugGrabber + BugSack to capture it).

## License and credits

Onward is free software under the **GPL-3.0** license. Quest, NPC and item locations come from the [Questie](https://github.com/Questie/Questie) database (GPL-3.0). The routes are generated by Onward's own tools.
