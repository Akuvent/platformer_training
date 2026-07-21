extends Node2D

func _on_pole_area_body_entered(body):
	if not body.is_in_group("Player"):
		return


func _on_flag_area_body_entered(body):
	if not body.is_in_group("Player"):
		return
