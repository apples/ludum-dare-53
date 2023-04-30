extends RigidBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

@export var thrust: float = 100

var connected_to: PhysicsBody2D
var relative_angle: float

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("windup")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if connected_to:
		self.rotation = connected_to.rotation + relative_angle
	
	self.apply_force(self.global_transform.basis_xform(Vector2.RIGHT) * thrust)


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "windup":
		animated_sprite_2d.play("loop")
	if animated_sprite_2d.animation == "detonate":
		queue_free()


func _on_body_entered(body):
	if not body.is_in_group("thrustable"):
		return
	
	var joint := PinJoint2D.new()
	self.add_child(joint)
	joint.global_position = global_position
	joint.node_a = body.get_path()
	joint.node_b = self.get_path()
	self.call_deferred("set_contact_monitor", false)
	
	connected_to = body
	relative_angle = self.rotation - body.rotation
	


func _on_animated_sprite_2d_tree_entered():
	pass # Replace with function body.


func _on_burn_timer_timeout():
	animated_sprite_2d.play("flameout")
	thrust = 0


func _on_detonation_timer_timeout():
	animated_sprite_2d.play("detonate")
