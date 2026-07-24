extends Area2D
## Killbox under the level — falling off the map

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.get_parent().die()
