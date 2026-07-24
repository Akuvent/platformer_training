extends Node2D
## Instant-kill hazard

func _on_spike_area_body_entered(body):
	if body.is_in_group("Player"):
		body.get_parent().die()
