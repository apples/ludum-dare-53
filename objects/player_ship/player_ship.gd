extends RigidBody2D

@export var angular_acceleration: float = 200
@export var black_hole_spawn_distance: float = 16
@export var black_hole_strength: float = 10

@export var thruster_spawn_distance: float = 16
@export var thruster_spawn_velocity: float = 5


var black_hole_scene = preload("res://objects/black_hole/black_hole.tscn")
var thruster_scene = preload("res://objects/thruster/thruster.tscn")

var current_black_hole
var thruster_count: int = 5

func _physics_process(delta):
	
	if thruster_count > 0 and Input.is_action_just_pressed("spawn_thruster"):
		var new_thruster = thruster_scene.instantiate()
		var direction = global_transform.basis_xform(Vector2.RIGHT)
		new_thruster.global_position = global_position + direction * thruster_spawn_distance
		new_thruster.linear_velocity = direction * thruster_spawn_velocity
		new_thruster.rotation = self.rotation
		thruster_count -= 1
		get_parent().add_child(new_thruster)
	
	if Input.is_action_just_pressed("spawn_black_hole"):
		current_black_hole = black_hole_scene.instantiate()
		current_black_hole.global_position = global_position + global_transform.basis_xform(Vector2.RIGHT) * black_hole_spawn_distance
		current_black_hole.strength = black_hole_strength
		get_parent().add_child(current_black_hole)
	
	if current_black_hole and not Input.is_action_pressed("spawn_black_hole"):
		current_black_hole.queue_free()
		current_black_hole = null
	
	var turn_direction = Input.get_axis("turn_left", "turn_right")
	
	apply_torque(turn_direction * angular_acceleration)

func anchor_to(anchor_point: Vector2, anchor_rotation: float):
	pass
