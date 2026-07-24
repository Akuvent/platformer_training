extends Node2D
## Sets the respawn point when the player touches this area


func _on_area_2d_body_entered(body):
	if not body.is_in_group("Player"):
		return
	GameState.set_checkpoint(global_position)
