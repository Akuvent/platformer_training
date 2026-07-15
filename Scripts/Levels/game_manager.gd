extends Node
@onready var player = get_node("../Entities/Player")
@onready var death_screen = get_node("../HUD/DeathScreen")
@onready var death_timer = $Timer
@onready var score_label = $"../HUD/score"
@onready var death_anim = $"../HUD/DeathScreen/DeathAnim"
var score = 0

func _ready():
	for enemy in get_node("../Entities").get_children():
		if enemy.has_signal("enemydied"):
			enemy.enemydied.connect(_on_ennemy_enemydied)
	for node in get_node("../Interactables").get_children():
		if node.has_signal("CoinPickup"):
			node.CoinPickup.connect(_on_coin_coin_pickup)
func _on_player_died():
	death_screen.show()
	death_anim.frame = 0
	death_anim.play("default")
	death_timer.start()
	await death_timer.timeout
	get_tree().reload_current_scene()

func _on_timer_timeout():
	pass


func _on_ennemy_enemydied():
	score = score + 100
	score_label.text = "Score: " + str(score)

func _on_coin_coin_pickup():
	score = score + 100
	score_label.text = "Score: " + str(score)
