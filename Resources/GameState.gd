extends Node
## Autoload — score and lives persist across scene reloads

#region State
var score: int = 0
var lives: int = 3
var checkpoint: Vector2 = Vector2.ZERO
var has_checkpoint: bool = false
var default_spawn := Vector2(136, 200)
#endregion

#region Level

func set_checkpoint(pos: Vector2) -> void:
	checkpoint = pos
	has_checkpoint = true


#endregion



#region Score / lives
func add_points(amount: int = 100) -> void:
	score += amount


## Full game over reset
func reset() -> void:
	score = 0
	lives = 3
	has_checkpoint = false

## Called on death — lose one life
func hurt():
	lives -= 1
#endregion
