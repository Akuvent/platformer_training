extends Node2D

@onready var platform = $Platform
@onready var left_point = $LeftPoint
@onready var right_point = $RightPoint
var speed = 80.0
var direction = -1


func _physics_process(delta):
	platform.position.x += speed * direction * delta
	if direction < 0 and platform.position.x <= left_point.position.x:
		direction = 1
	elif direction > 0 and platform.position.x >= right_point.position.x:
		direction = -1
