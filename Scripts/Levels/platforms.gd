extends Node2D

@onready var platform = $Platform

@export var speed := 80.0
@export var patrol_distance := 64.0  

var direction := -1
var start_x: float

func _ready():
	start_x = platform.position.x

func _physics_process(delta):
	platform.position.x += speed * direction * delta

	if platform.position.x <= start_x - patrol_distance:
		direction = 1
	elif platform.position.x >= start_x + patrol_distance:
		direction = -1
