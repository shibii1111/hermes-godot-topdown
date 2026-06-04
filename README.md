# RogueWatch

RogueWatch est un prototype de roguelike/roguelite 2D top-down action RPG dans Godot 4.6.

## Vision

- Combat temps réel inspiré Zelda: attaque avec un bouton, pas de combat au tour par tour.
- Univers clockpunk: engrenages, horlogerie, automates, cuivre/laiton, ateliers et donjons mécaniques.
- Cible PC seulement.
- GDScript seulement.
- Architecture modulaire, orientée objet, sans fichiers monolithiques.

## État actuel

Fondation initiale:

- Projet Godot 4.6.3 créé.
- Start menu minimal fonctionnel.
- Hub placeholder fonctionnel.
- Donjon placeholder fonctionnel.
- Autoloads limités: `GameState`, `SceneLoader`, `SaveManager`, `SignalBus`.
- Input map clavier/souris et manette Xbox préparé.

## Vérification

Depuis la racine du repo:

```bash
godot --headless --path . --quit
```

Pour lancer l'éditeur:

```bash
godot --path .
```

## Documentation

- `docs/architecture.md`: organisation technique proposée.
- `docs/controls.md`: contrôles clavier/souris et manette Xbox.
- `docs/milestones.md`: découpage progressif du prototype.
