extends Node2D
## Sets the respawn point when the player touches this area
@onready var sfx = $Area2D/AudioStreamPlayer2D
var used = false

func _on_area_2d_body_entered(body):
	if not body.is_in_group("Player"):
		return
	GameState.set_checkpoint(global_position)
	if used == false:
		sfx.play()
	used = true
