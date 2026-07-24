extends Node2D

#region Exports
@export var speed = 900 ## Horizontal acceleration
@export var friction = 1600 ## How fast we slow down when no input
@export var max_player_velocity = 175 ## Top run speed
@export var gravity = 980
@export var jump_power = -460 ## Negative = up
@export var air_mult = 1 ## Extra move control while airborne
#endregion

#region State
var fall_time = 0.0 ## How long we've been falling (for heavy fall gravity)
var max_fall_mult = 6.0
@export var max_fall_speed = 800 ## Terminal velocity — snappy gaps, stomps handle the rest
var is_dead = false
var was_falling = false ## True last frame if velocity.y > 0 (used by enemy stomps)
var stomp_bounce = false ## Skip ground snap this frame after bouncing on an enemy
var coyote_time = 0.12 ## Grace window to jump after leaving a ledge
var coyote_timer = 0.0
#endregion

#region Nodes
@onready var player = $PlayerBody
@onready var playerSprite = $PlayerBody/PlayerSprite
var base_sprite_scale := Vector2.ONE
var scale_tween: Tween
#endregion

signal died


func _ready():
	base_sprite_scale = playerSprite.scale


func _physics_process(delta):
	#region Horizontal movement
	var direction = 0
	var was_on_floor = player.is_on_floor()
	if was_on_floor:
		air_mult = 1.0
	else:
		air_mult = 1.2

	if Input.is_action_pressed("move_left"):
		direction = -1
		playerSprite.flip_h = false
	elif Input.is_action_pressed("move_right"):
		direction = 1
		playerSprite.flip_h = true

	# Accelerate when holding a direction, friction when not
	if direction != 0:
		player.velocity.x += direction * speed * air_mult * delta
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, friction * delta)
	player.velocity.x = clampf(player.velocity.x, -max_player_velocity, max_player_velocity)
	#endregion

	#region Gravity & jump
	if not was_on_floor:
		coyote_timer -= delta
		if player.velocity.y > 0:
			fall_time += delta
		# Fall gets heavier the longer you're falling
		var fall_mult = min(2.0 + fall_time, max_fall_mult)
		player.velocity.y += gravity * fall_mult * delta
		player.velocity.y = min(player.velocity.y, max_fall_speed)

	if Input.is_action_just_pressed("jump") and (was_on_floor or coyote_timer > 0):
		player.velocity.y = jump_power
		coyote_timer = 0
		_squash_stretch(Vector2(0.75, 1.25), 0.08)
	elif was_on_floor and not Input.is_action_just_pressed("jump") and not stomp_bounce:
		# Grounded: reset fall state and refresh coyote window
		air_mult = 1
		fall_time = 0.0
		player.velocity.y = 0
		coyote_timer = coyote_time
	#endregion

	#region Visuals
	# Light run lean only — no velocity-driven spin
	var target_rot = direction * 0.18 if was_on_floor else 0.0
	playerSprite.rotation = lerpf(playerSprite.rotation, target_rot, 14.0 * delta)
	#endregion

	#region Apply movement
	stomp_bounce = false
	was_falling = player.velocity.y > 0
	var moving_up = player.velocity.y < 0
	player.move_and_slide()

	# Landing squash
	if player.is_on_floor() and not was_on_floor:
		_squash_stretch(Vector2(1.25, 0.75), 0.1)
	#endregion

	#region Hit blocks from below
	# Only true underside hits: rising + mostly downward normal (ignores corner/side scrapes)
	if moving_up:
		for i in player.get_slide_collision_count():
			var collision = player.get_slide_collision(i)
			var block = collision.get_collider().get_parent()
			var normal = collision.get_normal()
			if block.has_method("hit_from_below") and normal.y > 0.7:
				block.hit_from_below()
	#endregion


#region Helpers
## Quick squash/stretch tween for jump / land / bounce feel
func _squash_stretch(peak: Vector2, duration: float) -> void:
	if scale_tween:
		scale_tween.kill()
	scale_tween = create_tween()
	scale_tween.tween_property(playerSprite, "scale", base_sprite_scale * peak, duration * 0.45)
	scale_tween.tween_property(playerSprite, "scale", base_sprite_scale, duration * 0.55)


## Called by hazards / enemies — freezes the player and notifies GameManager
func die():
	if is_dead:
		return
	is_dead = true
	died.emit()
	set_physics_process(false)


## Bounce after stomping an enemy
func bounce():
	stomp_bounce = true
	fall_time = 0.0
	player.velocity.y = jump_power * 1.5
	_squash_stretch(Vector2(0.75, 1.25), 0.08)
#endregion
