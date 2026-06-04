# RogueWatch Art Direction

## Goal

RogueWatch uses original 32x32 pixel art with a clockpunk fantasy tone. Art should be integrated progressively with each gameplay milestone so collisions, pivots, hitboxes, HUD layout, and readability evolve together instead of being replaced in one large polish pass.

## Visual Pillars

- **Clockpunk machinery:** gears, springs, copper pipes, brass frames, steel plating, teal energy.
- **Readable top-down action:** silhouettes must remain clear at gameplay scale.
- **Prototype-first polish:** early sprites may be simple, but they should use the final folder structure, pivots, and scene architecture.
- **Original assets only:** do not import commercial, unlicensed, or third-party art.

## Sprite Scale

- Characters: `32x32` PNG, transparent background.
- Pickups/icons: `32x32` PNG unless a smaller UI-only icon is explicitly needed.
- Dungeon/hub tiles: `64x64` PNG tiles for now.
- Portals: horizontal `96x32`, vertical `32x96` PNGs.
- Larger props should be multiples of 32 pixels.

## Palette Direction

- Brass: warm yellow/orange metal for machinery and important outlines.
- Copper: darker orange-brown for bodies, frames, and aged metal.
- Dark steel: grey mechanical parts and enemy limbs.
- Teal energy: portals, magical clockwork power, special effects.
- Cream highlights: UI accents, gleams, readable tiny details.
- Deep brown/black: floors, shadows, negative space.

## Integration Rules

- Keep gameplay collisions independent from sprite shapes.
- Prefer `Sprite2D` or `AnimatedSprite2D` visuals as children of existing gameplay nodes.
- Preserve stable node names like `BodyVisual`, `WeaponVisual`, and `Visual` so scripts/tests can keep finding them.
- Replace placeholder geometry gradually per milestone.
- Every visual pass should still pass headless scene loading and gameplay validations.

## First Sprite Batch

M6.0 introduces the initial original pixel art pipeline and replaces high-impact placeholders:

- Player: `assets/pixel/player/clockmaker_player.png`
- Melee slash: `assets/pixel/player/brass_slash.png`
- Automaton: `assets/pixel/enemies/clockwork_automaton.png`
- Mechanical rat: `assets/pixel/enemies/mechanical_rat.png`
- Gear pickup/icon: `assets/pixel/items/gear_pickup.png`, `assets/pixel/ui/gear_icon.png`
- Dungeon portals: `assets/pixel/dungeon/portal_horizontal.png`, `assets/pixel/dungeon/portal_vertical.png`
- Dungeon/hub floor tile seeds: `assets/pixel/dungeon/clockwork_floor_tile.png`, `assets/pixel/hub/workshop_floor_tile.png`
