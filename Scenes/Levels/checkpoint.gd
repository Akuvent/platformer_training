extends Node2D


func _on_area_2d_body_entered(body):
	if not body.is_in_group("Player"):
		return
	GameState.checkpoint = global_position	
