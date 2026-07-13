extends Node2D

@onready var enemy = $EnemyBody
@onready var enemysprite = $EnemyBody/BodyKillzone/Sprite2D
@onready var stomp_area = $EnemyBody/Stomp
@onready var stomp_shape = $EnemyBody/Stomp/CollisionShape2D
var gravity = 980
var speed = 60
var direction = -1
var was_on_wall = false
signal enemydied

func _physics_process(delta):
	if not enemy.is_on_floor():
		enemy.velocity.y += gravity * delta
	enemy.velocity.x = speed * direction
	enemy.move_and_slide()

	var on_wall = enemy.is_on_wall()
	if on_wall and not was_on_wall:
		direction *= -1
		enemysprite.flip_h = max(direction, 0)
	was_on_wall = on_wall

func _get_feet_y(body: CharacterBody2D) -> float:
	for child in body.get_children():
		if child is CollisionShape2D and child.shape:
			var half_h: float = child.shape.get_rect().size.y * 0.5 * abs(body.global_scale.y)
			return body.global_position.y + half_h
	return body.global_position.y

func _get_stomp_bottom_y() -> float:
	var half_h: float = stomp_shape.shape.get_rect().size.y * 0.5 * abs(stomp_shape.global_scale.y)
	return stomp_shape.global_position.y + half_h

func _is_player_stomping(body: CharacterBody2D) -> bool:
	if not stomp_area.overlaps_body(body):
		return false

	var player: Node = body.get_parent()
	if player.was_falling:
		return true

	# Fallback when velocity was zeroed by landing on the solid body this frame.
	var feet_y: float = _get_feet_y(body)
	return feet_y <= _get_stomp_bottom_y() + 4.0

func _on_stomp_body_entered(body):
	if not body.is_in_group("Player"):
		return
	if not _is_player_stomping(body):
		return
	body.get_parent().bounce()
	enemydied.emit()
	queue_free()

func _on_body_killzone_body_entered(body):
	if not body.is_in_group("Player"):
		return
	if _is_player_stomping(body):
		return
	body.get_parent().die()
