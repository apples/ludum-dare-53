extends Node2D

var anchor_position: Vector2
var anchor_angle: float
var use_anchor_angle: bool = false
var body: RigidBody2D
var linear_spring_constant = 10
var angular_spring_constant = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	if not body:
		body = get_parent() as RigidBody2D
	if anchor_position == Vector2.ZERO:
		anchor_position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if use_anchor_angle:
		apply_angular_spring()
	apply_linear_spring()

func apply_angular_spring():
	var current_angle = body.rotation
	if current_angle != anchor_angle:
		var result = (anchor_angle - current_angle) * angular_spring_constant
		body.apply_torque(result)

func apply_linear_spring():
	var current_pos = body.global_position
	if current_pos != anchor_position:
		var direction = current_pos.direction_to(anchor_position)
		var spring_force = (anchor_position - current_pos) * linear_spring_constant
		body.apply_force(spring_force)
