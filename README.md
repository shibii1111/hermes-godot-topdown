# RogueWatch

RogueWatch is a 2D top-down action RPG roguelike/roguelite prototype built in Godot 4.6.

## Vision

- Zelda-inspired real-time combat: one-button attacks, no turn-based combat.
- Clockpunk setting: gears, clockwork, automatons, copper/brass, workshops, and mechanical dungeons.
- PC-only target.
- GDScript only.
- Modular object-oriented architecture without monolithic files.

## Current Status

Initial foundation:

- Godot 4.6.3 project created.
- Minimal functional start menu.
- Functional hub placeholder.
- Functional dungeon placeholder.
- Limited autoloads: `GameState`, `SceneLoader`, `SaveManager`, `SignalBus`.
- Keyboard/mouse and Xbox controller input map prepared.

## Verification

From the repository root:

```bash
godot --headless --path . --quit
```

To launch the editor:

```bash
godot --path .
```

## Documentation

- `docs/architecture.md`: proposed technical organization.
- `docs/controls.md`: keyboard/mouse and Xbox controller mapping.
- `docs/milestones.md`: progressive prototype breakdown.
