extends Node2D

@onready var left = $LeftRigidBody2D
@onready var right = $RightRigidBody2D
@onready var static_body_2d = $StaticBody2D

var scale_step = 1.0 / 16.0

var gameplay_root
var player_ship

var spring_length = 32*2+16

func _ready():
	var angle = rotation
	rotation = 0
	
	var f = func (n):
		var o = load(n.get_instance_path()).instantiate()
		o.position = o.position.rotated(angle)
		o.rotation = angle
		add_child(o)
		n.queue_free()
		return o
	
	left = f.call(left)
	right = f.call(right)
	static_body_2d = f.call(static_body_2d)
	
	var s = DampedSpringJoint2D.new()
	s.length = 1
	s.rest_length = spring_length
	s.node_a = left.get_path()
	s.node_b = right.get_path()
	s.position = Vector2(0,0)
	s.rotation = angle
	add_child(s)
	
	s = DampedSpringJoint2D.new()
	s.length = 1
	s.rest_length = spring_length
	s.node_a = left.get_path()
	s.node_b = right.get_path()
	s.position = Vector2(96,0).rotated(angle)
	s.rotation = angle
	add_child(s)
	
	s = DampedSpringJoint2D.new()
	s.length = 1
	s.rest_length = spring_length
	s.node_a = left.get_path()
	s.node_b = right.get_path()
	s.position = Vector2(192,0).rotated(angle)
	s.rotation = angle
	add_child(s)
	
	s = GrooveJoint2D.new()
	s.length = 80
	s.initial_offset = 8
	s.node_a = static_body_2d.get_path()
	s.node_b = left.get_path()
	s.position = Vector2(96,0).rotated(angle)
	s.rotation = PI + angle
	add_child(s)
	
	s = GrooveJoint2D.new()
	s.length = 80
	s.initial_offset = 9
	s.node_a = static_body_2d.get_path()
	s.node_b = right.get_path()
	s.position = Vector2(96,0).rotated(angle)
	s.rotation = angle
	add_child(s)
	
	left.scale.y = scale_step
	right.scale.y = scale_step
	
	left.lock_rotation = true
	right.lock_rotation = true
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	scale_step += delta
	scale_step = min(scale_step, 1.0)
	left.scale.y = scale_step
	right.scale.y = scale_step
	
	if scale_step == 1.0:
		set_physics_process(false)
