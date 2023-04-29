extends Node

@export var count: int = 5
@export var spacing: float = 200
@export var lane_height: float = 400

var buoy_scene = preload("res://objects/buoy/buoy.tscn")

func _ready():
	for i in range(count):
		var buoy_up = buoy_scene.instantiate()
		buoy_up.position = Vector2(i * spacing, lane_height / 2)
		var buoy_down = buoy_scene.instantiate()
		buoy_down.position = Vector2(i * spacing, -lane_height / 2)
		add_child(buoy_up)
		add_child(buoy_down)

