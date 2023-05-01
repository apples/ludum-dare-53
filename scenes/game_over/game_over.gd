extends Control

var mission_scene = "res://scenes/mission_menu/mission_menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_return_to_mission_pressed():
	get_tree().change_scene_to_file(mission_scene)
