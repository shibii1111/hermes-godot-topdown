# RogueWatch Controls

## Attack Direction

RogueWatch is not a twin-stick shooter. Attack direction comes from the direction the character is facing.

## Keyboard / Mouse

- Movement: WASD or arrow keys.
- Melee attack: left click or Space.
- Dash: Shift.
- Pause: Escape.
- Inventory: I.
- Interact: E.
- Spell / special: Q or right click.

## Xbox Controller

Approved mapping: option A.

- Left stick / D-pad: movement.
- A: melee attack in combat/run.
- A: contextual interaction outside combat.
- B: dash.
- Start: pause.
- Y: inventory.
- X: spell or special attack.

## Implementation Note

Because A is used for both attack and contextual interaction, the code must resolve context cleanly:

- If the player is in dialogue/menu/interactive hub context: A triggers `interact` or `confirm`.
- If the player is in an active run/combat context: A triggers `attack`.
- The input system must not aim with the right stick.
