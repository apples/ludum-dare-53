extends RigidBody2D

var connect_to

var radius = 10
var move_force = 100

func _physics_process(delta):
	if connect_to:
		var d = global_position.distance_to(connect_to.global_position)
		if d > radius:
			var dir = global_position.direction_to(connect_to.global_position)
			apply_force(dir * move_force)
			linear_damp = 5
		else:
			linear_damp = clamp(inverse_lerp(radius, 1.0, d), 0.0, 1.0) * 40 + 10

