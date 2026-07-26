# Platformer Training

**Status: finished.** Training scope is complete — this repo is kept as a learning archive.

A small 2D Mario-style platformer built in **Godot 4.6**. Made to practice core platformer systems (movement, combat, level objects, game state), not as a commercial release.

## Features

### Player
- Run and jump with acceleration, friction, and air control
- Coyote-style feel via tunable gravity, jump power, and terminal fall speed
- Squash / stretch feedback on land and jump
- Death, bounce-on-stomp, and respawn at the last checkpoint (or level spawn)

### Combat & hazards
- Walking enemies with facing direction and stomp kill
- Side contact with enemies kills the player
- Spikes and world-border fall zones as lethal hazards

### Collectibles & blocks
- Coins that add score on pickup
- Breakable bricks (hit from below)
- Chance blocks that can spawn a coin or an enemy, with limited uses

### Level systems
- Checkpoints that save spawn position and restore lives
- Horizontally patrolling moving platforms
- End flag with normal win (pole) and bonus win (flag top)
- Score HUD and win / game-over UI flow
- Shared game state (lives, score, checkpoint) across respawns

### Audio & presentation
- SFX for win, checkpoint, death, and enemy stomp
- 640×360 viewport, stretched, borderless fullscreen
- One playable level: `Scenes/Levels/FirstLevel.tscn`

## Controls

| Action | Keys |
|--------|------|
| Move left | A / ← |
| Move right | D / → |
| Jump | Space / W / ↑ |

## How to run

1. Install [Godot 4.6](https://godotengine.org/)
2. Open this folder as a Godot project
3. Run the main scene
