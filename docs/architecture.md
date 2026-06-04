# RogueWatch Architecture

## Principes

- GDScript seulement.
- Petits scripts spécialisés par domaine.
- Composants réutilisables pour health, hitbox, hurtbox, stats, inventory et progression.
- UI séparée de la logique gameplay.
- Progression de run séparée de la progression permanente.
- Génération de donjon séparée des scènes concrètes de rooms.

## Dossiers principaux

- `assets/`: assets originaux du prototype, notamment pixel art 32x32.
- `scenes/`: scènes Godot réutilisables.
- `scripts/`: scripts GDScript organisés par domaine.
- `resources/`: données Godot `.tres` pour items, weapons, upgrades, rooms et loot tables.
- `docs/`: documentation interne du projet.

## Autoloads approuvés

- `GameState`: état global start menu, hub, run et pause.
- `SceneLoader`: transitions de scènes principales.
- `SaveManager`: progression permanente et sauvegarde.
- `SignalBus`: signaux globaux limités pour réduire le couplage.

## Flow cible

```text
Start menu -> Hub -> Run/dungeon -> mort ou sortie -> Hub -> upgrades permanents -> nouvelle run
```

## Séparation des systèmes

- `player`: contrôle, movement, facing, dash, combat joueur.
- `combat`: dégâts, health, hitboxes, hurtboxes, armes melee.
- `enemies`: base enemy, IA et ennemis clockpunk concrets.
- `dungeon`: génération, layout, rooms et gestion de run.
- `inventory`: slots, équipement et stacks.
- `items`: définitions, loot, pickups et chests.
- `progression`: XP, levels, stats, run progression, permanent progression.
- `npcs`: marchand, station d'upgrade, donneur de quête.
- `quests`: définitions et état de quêtes simples.
- `saves`: save data et save manager.
- `ui`: HUD, menus et dialogues.
