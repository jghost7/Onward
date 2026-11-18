# Guide format

A guide is one Lua file in this folder, listed in `Guides.xml`.

```lua
Onward:RegisterGuide{
  id = "riverglades-35",            -- unique, used for saved progress
  title = "Riverglades (35-40)",
  faction = "Alliance",             -- "Alliance", "Horde" or "" for both
  levels = { 35, 40 },
  next = "riverglades-40",          -- optional: switch to this guide when done
  steps = [[
-- comments start with -- or #
accept 12345 |npc Harbormaster Vell |at 1423 45.2,60.1
accept 12346
complete 12345 |note Stalkers roam the east bank
complete 12346 2                     -- objective 2 only
goto 1423 62.0,48.5 30 |note Cross the bridge (30 yd radius, default 15)
turnin 12345
turnin 12346 |npc Harbormaster Vell
level 37
note Train new abilities in town |class WARRIOR,PALADIN
]]}
```

The IDs above show the syntax only. They are not real quests.

A step line can end in a `  -- comment`, written with whitespace before the `--`. The parser removes it before reading the options.

## Steps

| Step | Done when |
|---|---|
| `accept <questID>` | The quest is in your log or already turned in |
| `complete <questID> [objective]` | The quest, or that objective, is finished |
| `turnin <questID>` | The quest is turned in |
| `goto <mapID> <x>,<y> [radius]` | You are within the radius in yards (default 15) |
| `fly <mapID> <x>,<y> [radius] \|from <mapID> <x>,<y>` | You land within the radius of the destination (default 150 yd). The pin and arrow point at the departure flight master (`from`) until take-off, then at the destination. At the flight master, the flight is picked for you; hold Shift to choose yourself |
| `level <n>` | You reach that level |
| `home \|npc <innkeeper> \|at <mapID> x,y` | Your hearthstone is set at that inn (within 200 yd). Onward learns where you're bound when you set it, or when you stand in that town. The generator adds one per guide, at the inn of the busiest quest hub |
| `note <text>` | You right-click it, or click it |

### Profession guides

Register with `kind = "profession"` and `skill = <skillLine>` (171 Alchemy, 164 Blacksmithing, 333 Enchanting, 202 Engineering, 165 Leatherworking, 197 Tailoring, 185 Cooking, 129 First Aid, 182 Herbalism, 186 Mining, 393 Skinning, 356 Fishing). They appear on the picker's Professions tab.

| Step | Done when |
|---|---|
| `train <skillLine> <cap> [\|level n] [\|book <itemID>] [\|quest <questID>]` | Your max rank in it reaches `cap` (75 = learning it). Points to the nearest trainer that teaches that rank, or the vendor selling `book`, or the giver of `quest` |
| `craft <spellID> <until> \|name <text> \|n <crafts> \|from <skill> [\|mats id:n;id:n] [\|recipe <itemID>]` | Your skill reaches `until`. `n` is the estimated crafts from `from`; the panel scales it to the skill left and lists `mats` (per craft) against your bags and bank. `recipe`: the item to buy first; the arrow points to its nearest vendor until you know the recipe |
| `gather <skillLine> <until> [\|at <mapID> x,y] [\|beasts <level>]` | Your skill reaches `until` |

## Options (after `|`)

| Option | Meaning |
|---|---|
| `at <mapID> x,y` | Waypoint for the step. Without it, accept and turn-in steps use Questie's NPC location, and complete steps use Blizzard's quest area |
| `npc <name>` | Name shown under the step |
| `note <text>` | Hint line |
| `item <itemID>` | The item the quest has you use. While it's in your bags the quest item button uses it (and the step says "use <item>"). Without it, the button looks for a usable quest item in your bags that the quest's text names. The drafter writes the item a quest gives you when you accept it |
| `mobs <Name>;<Name>` | Mobs the target button and key binding target on a `complete` step, in order of preference (kill targets first, then the mobs that drop the quest items). The drafter writes up to four |
| `class`, `race`, `faction` | The step is shown only to matching characters. Use comma lists of class tokens (`WARRIOR`) or race names: `Human`, `Orc`, `Dwarf`, `NightElf`, `Scourge` (or `Undead`), `Tauren`, `Gnome`, `Troll`, and Forever's `SkyborneAlliance` / `SkyborneHorde`. The generated guides narrow a quest by its prerequisites too: the follow-up to a dwarf-and-gnome quest is tagged dwarf-and-gnome (`tools/retag_guides.py`) |
| `lvl <n>`, `pre <questID>,<questID>`, `preany <questID>,<questID>` | On `accept` steps: what the game asks before it offers the quest (its minimum level; quests that must all be turned in; quests of which one must be). Until then the step is passed over, with its objectives and turn-in, and comes back by itself once the quest is on offer. A quest you're under-level for becomes the step, marked "needs level N", when nothing else is left in the guide. The drafter writes all three from Questie's data |
| `group <kind>` | Needs a group: `elite` (elite targets), `dungeon` (targets only inside an instance) or `chain` (only reachable through one of those). Shown marked on the panel; left out when Options > Elite and dungeon quests is Hide (`/ow group hide`). The drafter sets it from Questie's NPC rank and spawn maps |
| `optional` | Marks the step as optional |

## How the guide follows you

Each step is judged by its own quest: an accept is done when the quest is in your log or turned in, and so on.
Picking a quest up early just ticks its accept step when the guide gets there.

- Skipping an accept skips the quest: its objectives and turn-in go with it, and come back if you pick it up anyway.
- Skips and ticked notes are saved by what the step is (`accept:123`, or a note's own line), not by its number,
  so they stay put when the quest mode or a new version of the guide moves the steps.
- A character that already did part of a guide resumes at the point that best divides quests turned in from
  quests not yet done. That point is worked out once per guide and character and saved; `/ow resume` works it out again.
- Keep a quest's steps in order (accept, complete, turnin) and give them the same `value`, `group`, `class` and
  `race` tags. `python tests/run.py` checks every guide for this.

## Quest hints

`QuestHints.lua` holds short notes for quests where the pin isn't enough. They show on the step card for any guide:

```lua
Onward:RegisterHints{
  [662] = {
    quest = "A note for the whole quest",
    objectives = { ["Maiden's Folly Charts"] = "A note under that objective" },  -- matched by name
    source = "Where it comes from",
  },
}
```

Write hints in your own words, from play or from what several players agree on. In game, `/ow hint <text>` adds a personal note and `/ow hints` lists them in this shape.

## Writing a guide by playing

Turn on the recorder, play the zone in the order you want, then copy the result:

```
/ow rec start Riverglades
/ow rec mark Take the lift down
/ow rec stop
/ow rec show
```

The recorder writes every accept, objective, turn-in and level-up, with coordinates and the NPC's name.
Paste the result into a file here and tidy the order. Recordings are also saved in
`WTF\Account\<account>\SavedVariables\Onward.lua` under `recordings`.
