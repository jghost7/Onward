-- Quest hints: short notes for quests where the map pin isn't enough (inside a sunken ship, up
-- a hidden path, an item that's easy to miss). Shown on the step card while you work on the quest.
--
-- Written in our own words, from play or from what several players agree on in a quest's
-- Wowhead comments (never copied text). Each entry says where it came from. Add yours with
-- /ow hint <text> in game and /ow hints to share them.
--
--   [questId] = {
--       quest = "a note for the whole quest",
--       objectives = { ["<objective name as the quest log shows it>"] = "a note for that one" },
--       source = "where the hint comes from",
--   },
Onward:RegisterHints{

    -- Arathi Highlands, Faldir's Cove
    [662] = {   -- Deep Sea Salvage
        quest = "Both ships are underwater. Naga in the lowest holds can hit you through the walls: pull them out before you loot.",
        objectives = {
            ["Maiden's Folly Charts"] = "Eastern ship, middle deck: in the middle of the ship, on the north side of the mast.",
            ["Maiden's Folly Log"] = "Eastern ship: down the stairs to the middle deck. A book in a bucket among the junk, toward the bow.",
            ["Spirit of Silverpine Charts"] = "Western ship, middle deck: on a barrel by a cannon at the bow. You can swim in through a cannon port.",
            ["Spirit of Silverpine Log"] = "Western ship: on the sea floor inside the hull, right under the hole in the bottom.",
        },
        source = "Wowhead comments (Classic), in our own words",
    },

    -- Riverglades
    [94923] = {   -- Hats Off
        objectives = {
            ["Robbie's Hat"] = "It's inside a hollow clam shell by the river, around 49, 79.",
        },
        source = "Wowhead WoW Forever (where the clam shell spawns)",
    },
    [95951] = {   -- Fetch 'n' Fletch
        quest = "Loot Bundles of Wood around Turner's Logging Camp, then use the Wood Bundles (quest item button) to fletch the spears.",
        source = "Quest text and Wowhead WoW Forever (where the wood bundles spawn)",
    },

}
