# RogueWatch Controls

## Direction d'attaque

RogueWatch n'est pas un twin-stick shooter. La direction d'attaque vient de la direction où le personnage regarde.

## Clavier / souris

- Mouvement: WASD ou flèches.
- Attaque melee: clic gauche ou Space.
- Dash: Shift.
- Pause: Escape.
- Inventaire: I.
- Interact: E.
- Spell / special: Q ou clic droit.

## Manette Xbox

Mapping approuvé: option A.

- Left stick / D-pad: mouvement.
- A: attaque melee en combat/run.
- A: interaction contextuelle hors combat.
- B: dash.
- Start: pause.
- Y: inventaire.
- X: spell ou special attack.

## Note d'implémentation

Comme A sert à la fois à l'attaque et à l'interaction contextuelle, le code devra résoudre le contexte proprement:

- Si le joueur est en dialogue/menu/hub interactif: A déclenche `interact` ou `confirm`.
- Si le joueur est en run/combat actif: A déclenche `attack`.
- Le système d'input ne doit pas viser avec le stick droit.
