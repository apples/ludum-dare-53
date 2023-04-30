extends Node

var given_boxes: int = 5

var start_impulse = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_docking_station_ship_docked(ship_body, anchor_point, anchor_rotation):
	%PlayerShip.anchor_to(anchor_point, anchor_rotation)


func _on_start_timer_timeout():
	$PlayerShip.enable_input = true
	$PlayerShip.apply_impulse(Vector2.RIGHT * start_impulse)
	$StartTimer.queue_free()
