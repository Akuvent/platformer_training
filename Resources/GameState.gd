extends Node
## Autoload — score and lives persist across scene reloads

#region State
var score: int = 0
var lives: int = 3
#endregion


#region Score / lives
func add_points(amount: int = 100) -> void:
	score += amount


## Full game over reset
func reset() -> void:
	score = 0
	lives = 3


## Called on death — lose one life
func hurt():
	lives -= 1
#endregion
