# SimpleAssist

World of Warcraft addon that keeps a learned assist target on a single bind.

## Current Retail Direction

The addon's differentiator is preserved: it does not rely on a separate focus macro.
The current implementation uses a hidden secure action button that is rebound to the
configured assist key and updated outside combat lockdown.

## Behavior

- Bind `Set Player to Assist` to learn your current friendly player target.
- Bind `Assist Learned Player` to assist the learned target with one key.
- If you try to learn a new target during combat, the addon defers the update until combat ends.
- Clearing the learned target falls back to `/assist target`.

## Retail Notes

- The assist action is implemented through Blizzard's secure button model, not by creating a player macro.
- Ordinary macros and `/run` cannot replace this workflow without losing the addon-driven, no-focus behavior.
- Retail compatibility still needs in-client verification for settings UI and combat behavior.
