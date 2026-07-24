extends Node2D
## End-of-level goal
@onready var sfx = $AudioStreamPlayer2D
signal win ## Pole touch — normal win
signal super_win ## Flag top touch — bonus win


#region Triggers
func _on_pole_area_body_entered(body):
	if not body.is_in_group("Player"):
		return
	sfx.play()
	win.emit()


func _on_flag_area_body_entered(body):
	if not body.is_in_group("Player"):
		return
	sfx.play()
	super_win.emit()
#endregion
