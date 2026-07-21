extends Node

var score: int = 0


func add_points(amount: int = 100) -> void:
	score += amount


func reset_score() -> void:
	score = 0
