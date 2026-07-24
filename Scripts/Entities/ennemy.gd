extends Node2D

#region Nodes
@onready var enemy = $EnemyBody
@onready var enemysprite = $EnemyBody/BodyKillzone/Sprite2D
@onready var stomp_area = $EnemyBody/Stomp
@onready var stomp_shape = $EnemyBody/Stomp/CollisionShape2D
@onready var body_shape = $EnemyBody/CollisionShape2D
#endregion

#region Movement
enum StartDirection { LEFT = -1, RIGHT = 1 }
@export var start_direction: StartDirection = StartDirection.LEFT ## Walk left or right at spawn
var gravity = 980
var speed = 60
var direction = -1 ## -1 left, 1 right
var was_on_wall = false ## Edge-detect so we only flip once per wall touch
#endregion

signal enemydied


func _ready():
	direction = start_direction
	_apply_facing()


func _apply_facing() -> void:
	enemysprite.flip_h = direction > 0


#region Physics
func _physics_process(delta):
	if not enemy.is_on_floor():
		enemy.velocity.y += gravity * delta
	enemy.velocity.x = speed * direction
	enemy.move_and_slide()

	# Turn around when hitting a wall
	var on_wall = enemy.is_on_wall()
	if on_wall and not was_on_wall:
		direction *= -1
		_apply_facing()
	was_on_wall = on_wall
#endregion


#region Stomp helpers
## Bottom of the player's collision shape
func _get_feet_y(body: CharacterBody2D) -> float:
	for child in body.get_children():
		if child is CollisionShape2D and child.shape:
			var half_h: float = child.shape.get_rect().size.y * 0.5 * abs(body.global_scale.y)
			return body.global_position.y + half_h
	return body.global_position.y


## True if the player is landing on top (not a side bump)
func _is_player_stomping(body: CharacterBody2D) -> bool:
	var player: Node = body.get_parent()
	# Absolute fall, or falling faster than the enemy (airborne enemy case)
	var relative_vy: float = body.velocity.y - enemy.velocity.y
	var descending: bool = body.velocity.y > 0 or player.was_falling or relative_vy > 0.0
	if not descending:
		return false

	# Horizontal alignment only — high fall speed can clip fully through in one frame,
	# so vertical "still above" checks falsely fail and the killzone wins.
	var stomp_half_w: float = stomp_shape.shape.get_rect().size.x * 0.5 * abs(stomp_shape.global_scale.x)
	if abs(body.global_position.x - enemy.global_position.x) > stomp_half_w + 6.0:
		return false

	return true


## Kill enemy and bounce the player
func _stomp(body: CharacterBody2D) -> void:
	body.get_parent().bounce()
	enemydied.emit()
	queue_free()
#endregion


#region Hitboxes
func _on_stomp_body_entered(body):
	if not body.is_in_group("Player"):
		return
	if not _is_player_stomping(body):
		return
	_stomp(body)


func _on_body_killzone_body_entered(body):
	if not body.is_in_group("Player"):
		return
	# Killzone often fires first when both fall — still treat as stomp if on top
	if _is_player_stomping(body):
		_stomp(body)
		return
	body.get_parent().die()
#endregion
