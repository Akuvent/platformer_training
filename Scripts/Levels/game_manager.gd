extends Node

#region HUD
@onready var death_screen = get_node("../HUD/DeathScreen")
@onready var death_timer = $Timer
@onready var score_label = $"../HUD/score"
@onready var final_score = $"../HUD/WinScreen/Layout/WinTitle/score"
@onready var death_anim = $"../HUD/DeathScreen/DeathAnim"
@onready var win_screen = get_node("../HUD/WinScreen")
@onready var lives_sprite = $"../HUD/LivesSprite"
#endregion

#region State
var player: Node = null
var won = false ## Prevents double-triggering win from pole + flag
#endregion


func _enter_tree() -> void:
	# So chance blocks / tilemap scenes can find us without a fixed path
	add_to_group("game_manager")


func _ready() -> void:
	_sync_score_label()
	lives_sprite.frame = GameState.lives
	# TileMapLayer scene tiles spawn during their _ready — wire after that
	call_deferred("_wire_level")


#region Wiring
## Connects coins, enemies, flag, and player anywhere under the level root
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
#endregion


#region Score
func _sync_score_label() -> void:
	score_label.text = "Score: " + str(GameState.score)
	final_score.text = "Final score: " + str(GameState.score)


func add_score(amount: int = 100) -> void:
	GameState.add_points(amount)
	_sync_score_label()
#endregion


#region Death / lives
func _on_player_died() -> void:
	death_screen.show()
	death_anim.frame = 0
	death_anim.play("default")
	death_timer.start()
	await death_timer.timeout
	death()


## Respawn button
func _on_button_pressed() -> void:
	death()


## Lose a life (or full reset) then reload the level
func death() -> void:
	GameState.hurt()
	if GameState.lives == 0:
		GameState.reset()
	get_tree().reload_current_scene()
#endregion


#region Scoring callbacks
func _on_ennemy_enemydied() -> void:
	add_score()


func _on_coin_coin_pickup() -> void:
	add_score()
#endregion


#region Win
## Stub for now — reloads the same scene
func _on_next_level_pressed() -> void:
	get_tree().reload_current_scene()


## Touched the flag pole
func _on_flag_win() -> void:
	if won:
		return
	won = true
	score_label.hide()
	win_screen.show()
	add_score(500)
	if player:
		player.set_physics_process(false)


## Touched the flag top (bonus)
func _on_flag_super_win() -> void:
	if won:
		return
	won = true
	score_label.hide()
	win_screen.show()
	add_score(1000)
	if player:
		player.set_physics_process(false)
#endregion
