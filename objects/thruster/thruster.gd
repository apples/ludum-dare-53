extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("windup")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "windup":
		animated_sprite_2d.play("loop")


func _on_body_entered(body):
	if body.is_in_group("player_ship"):
		return

	var joint = GrooveJoint2D.new()
	joint.global_position = global_position
	joint.node_b = self.get_path()
	joint.node_a = body.get_path()
	joint.length = 0.1
	joint.initial_offset = 0.1
	self.add_child(joint)
	self.call_deferred("set_contact_monitor", false)
	
