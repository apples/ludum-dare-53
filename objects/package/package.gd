extends RigidBody2D

var connect_to: Node2D:
	get:
		return connect_to
	set(value):
		connect_to = value
		$DampedSpringJoint2D.length = 0
		$DampedSpringJoint2D.node_b = connect_to.get_path()
