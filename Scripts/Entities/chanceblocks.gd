extends Node2D
@export var coin_scene: PackedScene
@export var ennemy_scene: PackedScene

func hit_from_below():
	var coin = coin_scene.instantiate()
	var ennemy = ennemy_scene.instantiate()
	var choice = randi_range(1,2)
	if choice == 1:
		add_child(coin)
		coin.global_position = global_position
	if choice == 2:
		add_child(ennemy)
		ennemy.global_position = global_position
