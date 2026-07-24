extends Node2D
## Collectible — emits CoinPickup then removes itself
@onready var sfx = $Area2D/CoinSound
signal CoinPickup


func _on_area_2d_body_entered(body):
	if not body.is_in_group("Player"):
		return
	CoinPickup.emit()
	sfx.play()
	hide()  # or disable the Area2D
	await sfx.finished
	queue_free()
