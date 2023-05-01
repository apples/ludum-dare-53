extends ColorRect

var end_position: float = 4000 - 240
var max_width: int = 40
@onready var player_ship = get_node("/root/Gameplay/PlayerShip")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.size.x = max(1, int(player_ship.global_position.x / end_position * max_width))
	
