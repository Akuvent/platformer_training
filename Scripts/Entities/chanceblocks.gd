extends Node2D
@export var coin_scene: PackedScene
@export var ennemy_scene: PackedScene
var is_spawning = 0
var used = false
@export var uses = 1 
@onready var game_manager = $"../../GameManager"
@onready var off = $ChanceBlockBody/ChanceBlockOff
@onready var on = $ChanceBlockBody/ChanceBlockOn


func hit_from_below():
	if is_spawning == 1 or uses == 0:
		return
	is_spawning = 1
	var coin = coin_scene.instantiate()
	var ennemy = ennemy_scene.instantiate()
	var choice = randi_range(1,2)
	if choice == 1:
		get_parent().add_child(coin)
		coin.CoinPickup.connect(game_manager._on_coin_coin_pickup)
		coin.global_position = global_position
		var tween = create_tween()
		tween.tween_property(coin, "position:y", coin.global_position.y - 16, 0.2)
		tween.finished.connect(func():
			uses -= 1
			is_spawning = 0)
		uses = uses - 1
	if choice == 2:
		get_parent().add_child(ennemy)
		ennemy.set_physics_process(false)
		ennemy.global_position = global_position
		var tween = create_tween()
		tween.finished.connect(func():
			ennemy.set_physics_process(true)
			uses -= 1
			is_spawning = 0)
		tween.tween_property(ennemy, "position:y", ennemy.global_position.y - 16, 1)
		

func _physics_process(delta):
	if uses == 0:
		off.show()
		on.hide()
