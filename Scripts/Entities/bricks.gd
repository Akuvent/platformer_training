extends Node2D
## Breakable brick — destroyed when hit from below

var can_hit = true


func hit_from_below():
	can_hit = false
	queue_free()
	can_hit = true
