# RogueWatch Art Direction

## Goal

RogueWatch uses original stylized 2D art with a clean readable clockpunk direction. Art should be integrated progressively with each gameplay milestone so collisions, pivots, hitboxes, HUD layout, and readability evolve together instead of being replaced in one large polish pass.

The approved baseline is **A1.5: Clean Readable Clockpunk**.

## Visual Pillars

- **Clean readable silhouettes:** sprites must read clearly during fast top-down action at 1920x1080.
- **Clockpunk machinery:** gears, springs, copper pipes, brass frames, steel plating, teal energy.
- **Human player, mechanical threats:** the player should stay approachable and adventurer-like; enemies, portals, props, and interactables can lean harder into machinery.
- **Simple hand-drawn/vector-like rendering:** thick dark outlines, flat fills, limited cel shading, and readable shapes. Avoid strict pixel art, photorealism, noisy texture, or tiny details that disappear at gameplay scale.
- **Prototype-first polish:** early sprites may be simple, but they should use the final folder structure, pivots, and scene architecture.
- **Original assets only:** do not import commercial, unlicensed, or third-party art.

## Style Baseline: A1.5 Clean Readable Clockpunk

Use this mix as the current target:

- **Player:** A1 readability and warmth. Rounded/human silhouette, cloak, goggles/teal eyes, clockmaker-adventurer feel, not overly robotic.
- **Enemies:** A3 mechanical identity. Harder brass plates, visible gears, riggable/separable-looking parts, more hostile silhouettes.
- **Portal/props:** A3 mechanical identity. Larger brass/copper machinery with teal energy cores.
- **Palette/readability:** A1 clarity. Warm brass/copper against dark dungeon/workshop backgrounds, with teal energy as the main accent.

Reference exploration sheet:

- `/docs/art/a15_clean_readable_clockpunk.png`

## Asset Scale

Sprites are **not** required to be square. Source dimensions should generally use even-numbered widths and heights to avoid half-pixel pivots and export ambiguity.

Source size and displayed gameplay size are separate decisions:

- Source canvas: large enough for the silhouette, outline, animation padding, and effects.
- Displayed size: chosen for readability in a 1920x1080 gameplay viewport.
- Collision/hitboxes: kept independent from sprite artwork.

Baseline source canvas guidelines:

- Player: around `192x224`, displayed around 110-140 px tall in normal gameplay.
- Player attack/slash effects: wide non-square canvases around `256x128` or larger as needed.
- Mechanical rat/small enemies: wide low canvases around `160x112` to `192x128`.
- Humanoid/mechanical enemies: around `208x224` to `256x256`.
- Pickups/icons: around `64x64` to `96x96`, square or non-square depending on silhouette.
- Horizontal portals: around `384x192` or larger.
- Vertical portals: around `192x384` or larger.
- Props: free even-numbered canvases fitted to the silhouette, commonly `128x96`, `180x150`, `256x180`, or larger.
- Bosses/large fixtures: `512x384` or larger, depending on silhouette.

## Palette Direction

- Brass: warm yellow/orange metal for machinery, outlines, trims, and important readable accents.
- Copper: darker orange-brown for bodies, frames, aged metal, and warm shadows.
- Dark steel: grey mechanical parts, enemy limbs, weapon parts, and exposed mechanisms.
- Teal energy: portals, magical clockwork power, eyes, cores, special effects, and high-priority interactables.
- Cream highlights: UI accents, gleams, readable small details.
- Deep brown/black: floors, shadows, negative space, and outline color.

## Pivot and Collision Rules

- Keep gameplay collisions independent from sprite shapes.
- Character and enemy pivots should generally sit near the feet/base contact point, not the center of the source canvas.
- Pickups and props can pivot at visual center unless gameplay interaction needs a base pivot.
- Portals should pivot at the doorway/threshold center so placement and spawn offsets stay predictable.
- Prefer `Sprite2D`, `AnimatedSprite2D`, or composed Node2D visual children under existing gameplay nodes.
- Preserve stable node names like `BodyVisual`, `WeaponVisual`, and `Visual` so scripts/tests can keep finding them.

## Integration Rules

- Replace placeholder geometry gradually per milestone.
- Avoid large-bang art migrations; every gameplay feature that introduces a new visible object should include the correct style direction from the start.
- Every visual pass should still pass headless scene loading and gameplay validations.
- Commit production-ready assets as `.png` files with their Godot `.import` metadata.
- Keep exploratory sketches outside the project until a direction is accepted; accepted references may be copied under `docs/art/`.

## Current Status

M6.0 introduced an initial pixel-art-oriented sprite pipeline. M6.0.1 pivots the approved direction away from strict `32x32` pixel art and toward A1.5 clean readable clockpunk.

Existing M6.0 pixel assets can remain temporarily as placeholders, but future production sprites should follow this document instead of the earlier square pixel-art constraints.
