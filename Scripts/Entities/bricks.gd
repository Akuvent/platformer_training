extends Node2D
var can_hit = true


func hit_from_below():
	can_hit = false
	queue_free()
	can_hit = true
