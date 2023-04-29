extends CharacterBody2D

@export var angular_acceleration: float
@export var angular_damping: float

var black_hole_scene = preload("res://objects/black_hole/black_hole.tscn")

var current_black_hole

func _physics_process(delta):
	velocity
	# Handle Jump.
	if Input.is_action_just_pressed("spawn_black_hole"):
		current_black_hole = black_hole_scene.instantiate()
#		current_black_hole.global_position = global_position + global_transform.basis_xform()
		get_parent().add_child(current_black_hole)
	
	#if not Input.is_action_pressed("spawn_black_hole") and 

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("turn_left", "turn_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#
#	move_and_slide()
