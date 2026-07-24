extends Camera2D
## Follows the player on X only — Y stays locked

var lock_y: float


func _ready():
	lock_y = global_position.y ## Remember starting height


func _physics_process(_delta):
	global_position.y = lock_y
