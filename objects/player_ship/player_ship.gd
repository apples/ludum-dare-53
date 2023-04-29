extends RigidBody2D

@export var angular_acceleration: float = 300
@export var black_hole_spawn_distance: float = 16

var black_hole_scene = preload("res://objects/black_hole/black_hole.tscn")

var current_black_hole

func _physics_process(delta):
	
	if Input.is_action_just_pressed("spawn_black_hole"):
		current_black_hole = black_hole_scene.instantiate()
		current_black_hole.global_position = global_position + global_transform.basis_xform(Vector2.RIGHT) * black_hole_spawn_distance
		get_parent().add_child(current_black_hole)
	
	if current_black_hole and not Input.is_action_pressed("spawn_black_hole"):
		current_black_hole.queue_free()
		current_black_hole = null
	
	var turn_direction = Input.get_axis("turn_left", "turn_right")
	
	apply_torque(turn_direction * angular_acceleration)
