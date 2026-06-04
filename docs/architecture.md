# RogueWatch Architecture

## Principles

- GDScript only.
- Small domain-specific scripts.
- Reusable components for health, hitbox, hurtbox, stats, inventory, and progression.
- UI separated from gameplay logic.
- Run progression separated from permanent progression.
- Dungeon generation separated from concrete room scenes.

## Main Folders

- `assets/`: original prototype assets, including 32x32 pixel art.
- `scenes/`: reusable Godot scenes.
- `scripts/`: GDScript files organized by domain.
- `resources/`: Godot `.tres` data for items, weapons, upgrades, rooms, and loot tables.
- `docs/`: internal project documentation.

## Approved Autoloads

- `GameState`: global state for start menu, hub, run, and pause.
- `SceneLoader`: main scene transitions.
- `SaveManager`: permanent progression and saving.
- `SignalBus`: limited global signals to reduce coupling.

## Target Flow

```text
Start menu -> Hub -> Run/dungeon -> death or exit -> Hub -> permanent upgrades -> new run
```

## System Separation

- `player`: input control, movement, facing, dash, player combat.
- `combat`: damage, health, hitboxes, hurtboxes, melee weapons.
- `enemies`: enemy base, AI, and concrete clockpunk enemies.
- `dungeon`: generation, layout, rooms, and run management.
- `inventory`: slots, equipment, and stacks.
- `items`: definitions, loot, pickups, and chests.
- `progression`: XP, levels, stats, run progression, permanent progression.
- `npcs`: merchant, upgrade station, quest giver.
- `quests`: simple quest definitions and state.
- `saves`: save data and save manager.
- `ui`: HUD, menus, and dialogues.
