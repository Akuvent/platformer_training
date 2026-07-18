extends Node2D
@export var coin_scene: PackedScene
@export var ennemy_scene: PackedScene
var is_spawning = 0

func hit_from_below():
	if is_spawning == 1:
		return
	is_spawning = 1
	var coin = coin_scene.instantiate()
	var ennemy = ennemy_scene.instantiate()
	var choice = randi_range(1,2)
	if choice == 1:
		get_parent().add_child(coin)
		coin.global_position = global_position
		var tween = create_tween()
		tween.tween_property(coin, "position:y", coin.global_position.y - 16, 0.2)
		tween.finished.connect(func():
			is_spawning = 0)

	if choice == 2:
		get_parent().add_child(ennemy)
		ennemy.set_physics_process(false)
		ennemy.global_position = global_position
		var tween = create_tween()
		tween.finished.connect(func():
			ennemy.set_physics_process(true)
			is_spawning = 0)
		tween.tween_property(ennemy, "position:y", ennemy.global_position.y - 16, 1)
		
