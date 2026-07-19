extends Node2D
var can_hit = true
@onready var game_manager = $"../../GameManager"
@onready var off = $ChanceBlockBody/ChanceBlockOff
@onready var on = $ChanceBlockBody/ChanceBlockOn


func hit_from_below():
	can_hit = false
	queue_free()
	can_hit = true
