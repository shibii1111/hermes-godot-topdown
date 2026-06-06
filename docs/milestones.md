# RogueWatch Milestones

## Milestone 0: Inspection and Architecture

Status: completed.

- Repository inspected.
- Repository initially empty except for `.gitignore`.
- Architecture proposed and approved.
- Autoloads approved.
- Controller mapping option A approved.

## Milestone 1: Playable Foundation

Status: foundation implemented.

- Top-down player movement.
- Facing direction.
- Melee attack in front of the player.
- Dash.
- Health/damage verified through a test damage zone.
- Playable test room.
- Keyboard and Xbox controller input.

## Milestone 2: Combat and Enemies

Status: foundation implemented.

- Enemy base class.
- 2 clockpunk enemies: automaton and mechanical rat.
- Simple chase/patrol AI.
- Hitboxes/hurtboxes.
- Minimal hit/death visual feedback.
- Simple run currency drops.

## Milestone 3: UI and Menus

Status: foundation implemented.

- Existing start menu kept functional.
- Pause menu via Start/Escape.
- HUD health/run currency/XP.
- Inventory overlay via Y/I with 12 placeholder slots and equipment summary.
- Special/spell feedback via X/Q with an extensible Clockburst indicator.

## Milestone 4: Hub

Status: foundation implemented.

- Central hub UI with a workshop/portal layout.
- Upgrade station for Reinforced Heart.
- Permanent gears saved between runs.
- Run payout transfers run gears into permanent gears on death/manual return.
- Saved permanent progression influences future runs through max health upgrades.

## Milestone 5: Procedural Dungeons

Status: foundation implemented.

- Binding-of-Isaac-inspired branching room graph.
- `DungeonGenerator` creates a reliable 10-room dungeon with a main path and side branches.
- `DungeonRoot` loads one active room at a time and keeps the player/HUD persistent across transitions.
- 10 playable room prefabs exist under `scenes/dungeon/rooms/`.
- Cardinal door buttons connect generated room neighbors.
- Hub run portal now starts the generated dungeon root.

## Milestone 6: RPG Systems and Progressive Art

Goal:

- M6.0: Initial art pipeline and first sprite replacement.
- M6.0.1: Approved A1.5 clean readable clockpunk style direction.
- M6.0.2: Replace first high-impact placeholders with A1.5-style production placeholders.
- M6.1: Run XP, level-up rollover, enemy XP rewards, and temporary damage stat bonuses.
- M6.2: Physical gear loot pickups dropped from dungeon enemies and collected into run currency.
- M6.3: Starter equipment loadout with Clockwork Blade weapon bonus and inventory summary binding.
- M6.4: Clockburst gameplay spell with radial damage, cooldown, and real UI binding.
- M6.5: Hub merchant NPC with a permanent Winding Key shop offer and saved purchase state.
- M6.6: Simple First Haul quest with saved progress, run payout tracking, and hub reward claim UI.

Art integration rule:

- Do not defer all real sprites to the final polish pass.
- Add or replace relevant original stylized art alongside each gameplay slice.
- Use even-numbered, non-square source canvases fitted to the silhouette instead of forcing every sprite into a fixed square resolution.
- Keep collisions and gameplay data independent from sprite visuals.

## Milestone 7: Polish prototype

Goal:

- M7.0: Lightweight HUD feedback for run gear pickups.
- M7.1: Readable Clockburst radial VFX ring with expanding/fading burst polish.
- M7.2: Gear pickup collect micro-polish with an immediate pop and spark ring.
- M7.3: Enemy hit/death micro-polish with readable sparks and death pop feedback.
- M7.4: Basic player procedural visual animation for idle, walk, dash, and attack feedback.
- M7.5: Dash trail and melee attack arc readability VFX without changing movement or weapon timing.
- M7.6: Room portal readability polish with active-exit highlights and direction arrows.
- M7.7: Complete flow polish validation with returned-run summary and new-run upgrade continuity.
- M7.8: Starter balance tuning profile aligning first level-up, enemy rewards, and first hub upgrade cost.
- Improve and complete coherent clean readable clockpunk assets introduced progressively during M6.
- Basic animations.
- Visual effects.
- Minimal balancing.
- Complete flow: start menu -> hub -> run -> combat/loot/currency -> death -> hub -> permanent upgrade -> new run.
