extends Node2D
@export var speed = 150
@export var gravity = 980
@export var jump_power = -400
var fall_time = 0.0
var max_fall_mult = 6.0
var max_fall_speed = 1800
var is_dead = false
var was_falling = false
var stomp_bounce = false
var coyote_time = 0.12
var coyote_timer = 0.0
@export var air_mult = 1
@onready var player = $PlayerBody
@onready var playerSprite = $PlayerBody/PlayerSprite
var base_sprite_scale := Vector2.ONE
var scale_tween: Tween
signal died


func _ready():
	base_sprite_scale = playerSprite.scale

 
func _physics_process(delta):
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
	player.velocity.x = direction * speed * air_mult

	if not was_on_floor:
		coyote_timer -= delta
		if player.velocity.y > 0:
			fall_time += delta
		var fall_mult = min(2.0 + fall_time, max_fall_mult)
		player.velocity.y += gravity * fall_mult * delta
		player.velocity.y = min(player.velocity.y, max_fall_speed)
	if Input.is_action_just_pressed("jump") and (was_on_floor or coyote_timer > 0):
		player.velocity.y = jump_power
		coyote_timer = 0
		_squash_stretch(Vector2(0.75, 1.25), 0.08)
	elif was_on_floor and not Input.is_action_just_pressed("jump") and not stomp_bounce:
		air_mult = 1
		fall_time = 0.0
		player.velocity.y = 0
		coyote_timer = coyote_time

	# Light run lean only — no velocity-driven spin
	var target_rot = direction * 0.18 if was_on_floor else 0.0
	playerSprite.rotation = lerpf(playerSprite.rotation, target_rot, 14.0 * delta)

	stomp_bounce = false
	was_falling = player.velocity.y > 0
	var moving_up = player.velocity.y < 0
	player.move_and_slide()

	if player.is_on_floor() and not was_on_floor:
		_squash_stretch(Vector2(1.25, 0.75), 0.1)

	# Only true underside hits: rising + mostly downward normal (ignores corner/side scrapes)
	if moving_up:
		for i in player.get_slide_collision_count():
			var collision = player.get_slide_collision(i)
			var block = collision.get_collider().get_parent()
			var normal = collision.get_normal()
			if block.has_method("hit_from_below") and normal.y > 0.7:
				block.hit_from_below()


func _squash_stretch(peak: Vector2, duration: float) -> void:
	if scale_tween:
		scale_tween.kill()
	scale_tween = create_tween()
	scale_tween.tween_property(playerSprite, "scale", base_sprite_scale * peak, duration * 0.45)
	scale_tween.tween_property(playerSprite, "scale", base_sprite_scale, duration * 0.55)


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
	_squash_stretch(Vector2(0.75, 1.25), 0.08)
