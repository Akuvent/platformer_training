extends Node2D
var speed = 150
var gravity = 980
var jump_power = -400
var fall_time = 0.0
var max_fall_mult = 6.0
var max_fall_speed = 1800
var is_dead = false
var was_falling = false
var stomp_bounce = false
var coyote_time = 0.12
var coyote_timer = 0.0
@onready var player = $PlayerBody
@onready var playerSprite = $PlayerBody/PlayerSprite
signal died


func _physics_process(delta):
	var direction = 0
	
	if Input.is_action_pressed("move_left"):
		direction = -1
		playerSprite.flip_h = false
	elif Input.is_action_pressed("move_right"):
		direction = 1 
		playerSprite.flip_h = true
	player.velocity.x = direction * speed
	
	
	if not player.is_on_floor():
		coyote_timer = coyote_timer - delta
		if player.velocity.y < 0:
			playerSprite.rotation = 320
		if player.velocity.y > 0:
			fall_time += delta
			playerSprite.rotation = PI
		var fall_mult = min(2.0 + fall_time, max_fall_mult) 
		player.velocity.y += gravity * fall_mult * delta
		player.velocity.y = min(player.velocity.y, max_fall_speed)
	if Input.is_action_just_pressed("jump") and (player.is_on_floor() or coyote_timer > 0):
		player.velocity.y = jump_power
		coyote_timer = 0
	elif player.is_on_floor() and not Input.is_action_just_pressed("jump") and not stomp_bounce:
		playerSprite.rotation = 0
		fall_time = 0.0
		player.velocity.y = 0
		coyote_timer = coyote_time
	stomp_bounce = false
	was_falling = player.velocity.y > 0
	player.move_and_slide()

func die():
	if is_dead:
		return
	is_dead = true
	died.emit()
	set_physics_process(false)	

func bounce():
	stomp_bounce = true
	fall_time = 0.0
	player.velocity.y = jump_power * 1.5
