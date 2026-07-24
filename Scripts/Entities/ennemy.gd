extends Node2D

#region Nodes
@onready var enemy = $EnemyBody
@onready var enemysprite = $EnemyBody/Sprite2D
@onready var sfx = $EnemyBody/AudioStreamPlayer2D
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

	# Turn around when hitting a wall (not the player)
	var on_wall = false
	for i in enemy.get_slide_collision_count():
		var collision = enemy.get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is Node and collider.is_in_group("Player"):
			# Side bump into the player — hurt them (stomps are handled on the player side)
			var normal: Vector2 = collision.get_normal()
			if absf(normal.x) > 0.5:
				collider.get_parent().die()
			continue
		if absf(collision.get_normal().x) > 0.5:
			on_wall = true

	if on_wall and not was_on_wall:
		direction *= -1
		_apply_facing()
	was_on_wall = on_wall
#endregion


#region Combat
## Called by the player when they land on top (slide normal check)
func receive_stomp() -> void:
	sfx.play()
	enemydied.emit()
	queue_free()
#endregion
