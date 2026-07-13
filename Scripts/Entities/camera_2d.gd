extends Camera2D

var lock_y: float

func _ready():
	lock_y = global_position.y  # remember starting height

func _physics_process(_delta):
	global_position.y = lock_y
