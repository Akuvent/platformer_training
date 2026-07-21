extends Node

var score: int = 0
var lives: int = 3

func add_points(amount: int = 100) -> void:
	score += amount


func reset() -> void:
	score = 0
	lives = 3

func hurt():
	lives -= 1
