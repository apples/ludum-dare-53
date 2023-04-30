extends Node

@export var count: int = 5
@export var spacing: float = 200
@export var lane_height: float = 400

var buoy_scene = preload("res://objects/buoy/buoy.tscn")

func _ready():
	var prev_up
	var prev_down
	for i in range(count):
		var buoy_up = buoy_scene.instantiate()
		buoy_up.position = Vector2(i * spacing, lane_height / 2)
		if prev_up:
			prev_up.tape_neighbor = buoy_up
		var buoy_down = buoy_scene.instantiate()
		buoy_down.position = Vector2(i * spacing, -lane_height / 2)
		buoy_down.rotation_degrees = 180
		if prev_down:
			prev_down.tape_neighbor = buoy_down
		add_child(buoy_up)
		add_child(buoy_down)
		prev_up = buoy_up
		prev_down = buoy_down

