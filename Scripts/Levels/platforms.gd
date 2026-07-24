extends Node2D
## Horizontal moving platform

#region Setup
@onready var platform = $Platform
@export var speed := 80.0
@export var patrol_distance := 64.0 ## How far it travels from start_x

var direction := -1
var start_x: float
#endregion


func _ready():
	start_x = platform.position.x


func _physics_process(delta):
	platform.position.x += speed * direction * delta

	# Ping-pong between start and start + patrol_distance
	if platform.position.x <= start_x:
		direction = 1
	elif platform.position.x >= start_x + patrol_distance:
		direction = -1
