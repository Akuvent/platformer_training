extends Node2D
signal win
signal super_win

func _on_pole_area_body_entered(body):
	if not body.is_in_group("Player"):
		return
	else:
		win.emit()
		

func _on_flag_area_body_entered(body):
	if not body.is_in_group("Player"):
		return
	else:
		super_win.emit()
