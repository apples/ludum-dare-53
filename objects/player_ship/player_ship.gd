extends RigidBody2D

@export var angular_acceleration: float = 5000
@export var black_hole_spawn_distance: float = 32
@export var black_hole_strength: float = 100

@export var thruster_spawn_distance: float = 16
@export var thruster_spawn_velocity: float = 5

@export var dock_anchor_strength: float = 1

@export var enable_input: bool = true

@export var thrust_strength: float = 50

var black_hole_scene = preload("res://objects/black_hole/black_hole.tscn")
var thruster_scene = preload("res://objects/thruster/thruster.tscn")

var current_black_hole
var thruster_count: int = 5

var _turn_direction: float
var _thrust_direction: float
var _queue_thruster: bool = false

func _process(delta):
	if not enable_input:
		_turn_direction = 0
		_thrust_direction = 0
		_queue_thruster = false
		return
	
	if thruster_count > 0 and Input.is_action_just_pressed("spawn_thruster"):
		_queue_thruster = true
	
	if Input.is_action_just_pressed("spawn_black_hole"):
		current_black_hole = black_hole_scene.instantiate()
		current_black_hole.global_position = global_position + global_transform.basis_xform(Vector2.RIGHT) * black_hole_spawn_distance
		current_black_hole.strength = black_hole_strength
		get_parent().add_child(current_black_hole)
	
	if current_black_hole and not Input.is_action_pressed("spawn_black_hole"):
		current_black_hole.queue_free()
		current_black_hole = null
	
	_turn_direction = Input.get_axis("turn_left", "turn_right")
	_thrust_direction = -Input.get_axis("thrust_forward", "thrust_backwards")
	

func _physics_process(delta):
	
	if _queue_thruster:
		_queue_thruster = false
		var new_thruster = thruster_scene.instantiate()
		var direction = global_transform.basis_xform(Vector2.RIGHT)
		new_thruster.global_position = global_position + direction * thruster_spawn_distance
		new_thruster.linear_velocity = direction * thruster_spawn_velocity
		new_thruster.rotation = self.rotation
		thruster_count -= 1
		get_parent().add_child(new_thruster)
	
	apply_torque(_turn_direction * angular_acceleration)
	apply_force(_thrust_direction * global_transform.basis_xform(Vector2.RIGHT) * thrust_strength)

func anchor_to(anchor_point: Vector2, anchor_rotation: float):
	var anchor = Anchor.new()
	anchor.anchor_position = anchor_point
	anchor.anchor_angle = anchor_rotation
	anchor.linear_spring_constant = dock_anchor_strength
	add_child(anchor)
