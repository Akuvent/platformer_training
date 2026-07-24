extends Node
@onready var player = get_node("../Entities/Player")
@onready var death_screen = get_node("../HUD/DeathScreen")
@onready var death_timer = $Timer
@onready var score_label = $"../HUD/score"
@onready var final_score = $"../HUD/WinScreen/Layout/WinTitle/score"
@onready var death_anim = $"../HUD/DeathScreen/DeathAnim"
@onready var win_screen = get_node("../HUD/WinScreen")
@onready var lives_sprite = $"../HUD/LivesSprite"
var won = false


func _ready():
	for enemy in get_node("../Entities").get_children():
		if enemy.has_signal("enemydied"):
			enemy.enemydied.connect(_on_ennemy_enemydied)
	for node in get_node("../Interactables/Coins").get_children():
		if node.has_signal("CoinPickup"):
			node.CoinPickup.connect(_on_coin_coin_pickup)
	_sync_score_label()
	lives_sprite.frame = GameState.lives

func _sync_score_label() -> void:
	score_label.text = "Score: " + str(GameState.score)
	final_score.text = "Final score: " + str(GameState.score)


func add_score(amount: int = 100) -> void:
	GameState.add_points(amount)
	_sync_score_label()


func _on_player_died():
	death_screen.show()
	death_anim.frame = 0
	death_anim.play("default")
	death_timer.start()
	await death_timer.timeout
	death()

func _on_button_pressed():
	death()

func death():
	GameState.hurt()
	if GameState.lives == 0:
		GameState.reset()
	get_tree().reload_current_scene()

func _on_ennemy_enemydied():
	add_score()


func _on_coin_coin_pickup():
	add_score()


func _on_next_level_pressed():
	get_tree().reload_current_scene()


func _on_flag_win():
	if won:
		return
	won = true
	score_label.hide()
	win_screen.show()
	add_score(500)
	player.set_physics_process(false)


func _on_flag_super_win():
	if won:
		return
	won = true
	score_label.hide()
	win_screen.show()
	add_score(1000)
	player.set_physics_process(false)
