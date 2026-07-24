extends Node2D

#region Exports
@export var coin_scene: PackedScene
@export var ennemy_scene: PackedScene
@export var uses = 1 ## How many times this block can be hit
#endregion

#region State
var is_spawning = false ## Blocks re-hits while a spawn tween is playing
var can_hit = true
#endregion

#region Nodes
@onready var off = $ChanceBlockBody/ChanceBlockOff ## Empty / used sprite
@onready var on = $ChanceBlockBody/ChanceBlockOn ## Active sprite
#endregion


## Finds GameManager even when this block was painted on a TileMapLayer
func _game_manager() -> Node:
	return get_tree().get_first_node_in_group("game_manager")


#region Hit logic
## Called by the player when they bonk this block from below
func hit_from_below():
	if is_spawning or uses == 0:
		return
	var game_manager = _game_manager()
	if game_manager == null:
		return

	can_hit = false
	uses -= 1
	is_spawning = true

	var coin = coin_scene.instantiate()
	var ennemy = ennemy_scene.instantiate()
	var choice = randi_range(1, 100)

	# ~66% coin, ~34% enemy
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
		ennemy.set_physics_process(false) ## Freeze until the rise tween ends
		ennemy.global_position = global_position
		ennemy.direction = [-1, 1].pick_random()
		ennemy.enemysprite.flip_h = max(ennemy.direction, 0)
		ennemy.enemydied.connect(game_manager._on_ennemy_enemydied)
		var tween = create_tween()
		tween.tween_property(ennemy, "global_position:y", ennemy.global_position.y - 16, 1)
		tween.finished.connect(func():
			ennemy.set_physics_process(true)
			can_hit = true
			is_spawning = false)
#endregion


#region Visuals
func _physics_process(_delta):
	# Swap to the "used" look when depleted
	if uses == 0:
		off.show()
		on.hide()
#endregion
