extends Node2D
@onready var platform = $Platform
var speed = 80
var direction = -1

func _physics_process(delta):
	platform.velocity.x = speed * direction
	platform.move_and_slide()
