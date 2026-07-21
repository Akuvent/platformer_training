extends Node2D

func _on_spike_area_body_entered(body):
	if body.is_in_group("Player"):
		body.get_parent().die()
