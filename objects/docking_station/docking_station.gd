extends StaticBody2D

signal ship_docked(ship_body, anchor_point)

@export var allow_docking: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_dock_area_body_entered(body: Node):
	if not allow_docking:
		return
	
	if body.is_in_group("player_ship"):
		ship_docked.emit(body, $DockArea.global_position, 0)
