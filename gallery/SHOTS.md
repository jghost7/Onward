# Gallery: real captures to take

`out/` holds rendered cards (Onward's own colours and icons over blurred game scenery, Poppins as
the font). They are mock-ups. Replace them with real captures as you get them: drop a capture in
`captures/` and I'll frame it the same way (crop, caption, logo).

## Before you shoot

- Turn off every other quest addon for the session (Zygor, Questie's tracker, RXP). The page
  must not show another guide's panel.
- Hide chat and the clutter around the panel; keep the minimap if you like.
- Panel size 1.2–1.4 in Options, so the text reads on the page.
- Screenshots save at 3840x2160; that's plenty.

## The shots (in order of value)

1. **Step card mid-quest**: a kill/loot step with an objective bar part-filled and the drop-rate line
   showing, the NEXT list below. Daylight zone with open scenery behind the panel.
2. **Arrow with flight advice**: walking up to a flight master with "Fly: …" on the arrow.
3. **Flight map**: the flight map open, the destination glowing with the "Onward" label.
4. **Boat**: in Booty Bay or Ratchet with "Take the boat to …" on the arrow.
5. **Guide list**: the guide picker open with a "recommended" guide and a few % values.
6. **Looks**: the same spot taken in three or four looks (Onward, Twilight, Feywood, Neon).
7. **Party**: in a group, the step card with party progress lines, and a "finished" pop-up.
8. **Ghost**: released at a graveyard, the arrow reading "Back to your body".

Re-render the cards with `python gallery/render.py` (needs Playwright).
