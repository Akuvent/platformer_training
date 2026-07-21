extends Node2D
@export var coin_scene: PackedScene
@export var ennemy_scene: PackedScene
var is_spawning = false	
var can_hit = true
@export var uses = 1 
@onready var game_manager = $"../../GameManager"
@onready var off = $ChanceBlockBody/ChanceBlockOff
@onready var on = $ChanceBlockBody/ChanceBlockOn


func hit_from_below():
	if is_spawning or uses == 0:
		return
	can_hit = false
	uses -= 1
	is_spawning = true
	var coin = coin_scene.instantiate()
	var ennemy = ennemy_scene.instantiate()
	var choice = randi_range(1,100)
	if choice <= 66:
		get_parent().add_child(coin)
		coin.CoinPickup.connect(game_manager._on_coin_coin_pickup)
		coin.global_position = global_position
		var tween = create_tween()
		tween.tween_property(coin, "global_position:y", coin.global_position.y - 16, 0.2)
		tween.finished.connect(func():
			can_hit = true
			is_spawning = false)
		
	else:
		get_parent().add_child(ennemy) 
		ennemy.set_physics_process(false)
		ennemy.global_position = global_position
		ennemy.enemydied.connect(game_manager._on_ennemy_enemydied)
		var tween = create_tween()
		tween.tween_property(ennemy, "global_position:y", ennemy.global_position.y - 16, 1)
		tween.finished.connect(func():
			ennemy.set_physics_process(true)
			can_hit = true
			is_spawning = false)

		

func _physics_process(delta):
	if uses == 0:
		off.show()
		on.hide()
