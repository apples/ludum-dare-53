extends Node2D
const buoy_scene = preload("res://objects/buoy/buoy.tscn")
var buoys: Array[RigidBody2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_buoy = buoy_scene.instantiate()
	buoys.append(new_buoy)
	var buoy_pos = Vector2(100, 100)
	new_buoy.set_position(buoy_pos)
	$buoy_container.call_deferred("add_child", new_buoy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
