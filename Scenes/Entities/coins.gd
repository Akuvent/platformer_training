extends Node2D
signal CoinPickup

func _on_area_2d_body_entered(body):
	if not body.is_in_group("Player"):
		return
	CoinPickup.emit()
	queue_free()
