extends Node

@onready var death_screen = get_node("../HUD/DeathScreen")
@onready var death_timer = $Timer
@onready var score_label = $"../HUD/score"
@onready var final_score = $"../HUD/WinScreen/Layout/WinTitle/score"
@onready var death_anim = $"../HUD/DeathScreen/DeathAnim"
@onready var win_screen = get_node("../HUD/WinScreen")
@onready var lives_sprite = $"../HUD/LivesSprite"

var player: Node = null
var won = false


func _enter_tree() -> void:
	add_to_group("game_manager")


func _ready() -> void:
	_sync_score_label()
	lives_sprite.frame = GameState.lives
	# TileMapLayer scene tiles instantiate during their _ready; wire after that.
	call_deferred("_wire_level")


func _wire_level() -> void:
	_walk_and_wire(get_parent())


func _walk_and_wire(node: Node) -> void:
	if node.has_signal("CoinPickup") and not node.CoinPickup.is_connected(_on_coin_coin_pickup):
		node.CoinPickup.connect(_on_coin_coin_pickup)
	if node.has_signal("enemydied") and not node.enemydied.is_connected(_on_ennemy_enemydied):
		node.enemydied.connect(_on_ennemy_enemydied)
	if node.has_signal("win") and not node.win.is_connected(_on_flag_win):
		node.win.connect(_on_flag_win)
	if node.has_signal("super_win") and not node.super_win.is_connected(_on_flag_super_win):
		node.super_win.connect(_on_flag_super_win)
	if node.has_node("PlayerBody") and node.has_signal("died"):
		player = node
		if not node.died.is_connected(_on_player_died):
			node.died.connect(_on_player_died)

	for child in node.get_children():
		_walk_and_wire(child)


func _sync_score_label() -> void:
	score_label.text = "Score: " + str(GameState.score)
	final_score.text = "Final score: " + str(GameState.score)


func add_score(amount: int = 100) -> void:
	GameState.add_points(amount)
	_sync_score_label()


func _on_player_died() -> void:
	death_screen.show()
	death_anim.frame = 0
	death_anim.play("default")
	death_timer.start()
	await death_timer.timeout
	death()


func _on_button_pressed() -> void:
	death()


func death() -> void:
	GameState.hurt()
	if GameState.lives == 0:
		GameState.reset()
	get_tree().reload_current_scene()


func _on_ennemy_enemydied() -> void:
	add_score()


func _on_coin_coin_pickup() -> void:
	add_score()


func _on_next_level_pressed() -> void:
	get_tree().reload_current_scene()


func _on_flag_win() -> void:
	if won:
		return
	won = true
	score_label.hide()
	win_screen.show()
	add_score(500)
	if player:
		player.set_physics_process(false)


func _on_flag_super_win() -> void:
	if won:
		return
	won = true
	score_label.hide()
	win_screen.show()
	add_score(1000)
	if player:
		player.set_physics_process(false)
