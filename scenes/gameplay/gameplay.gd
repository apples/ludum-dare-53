extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_docking_station_ship_docked(ship_body, anchor_point, anchor_rotation):
	%PlayerShip.anchor_to(anchor_point, anchor_rotation)
