extends Node2D
const buoy_scene = preload("res://objects/buoy/buoy.tscn")
var buoys: Array[RigidBody2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_buoys()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_buoys():
	var buoy_pos_x = 20
	var buoy_pos_y_top_row = 20
	var buoy_pos_y_bottom_row = 200
	for i in range(8):
		generate_buoy(buoy_pos_x, buoy_pos_y_top_row)
		generate_buoy(buoy_pos_x, buoy_pos_y_bottom_row)
		buoy_pos_x += 50

func generate_buoy(pos_x, pos_y):
	var new_buoy = buoy_scene.instantiate()
	buoys.append(new_buoy)
	var buoy_pos = Vector2(pos_x, pos_y)
	new_buoy.set_position(buoy_pos)
	$buoy_container.call_deferred("add_child", new_buoy)
