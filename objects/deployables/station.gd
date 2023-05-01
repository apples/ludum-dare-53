extends Area2D

@onready var collision_shape_2d = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	var r = (collision_shape_2d.shape as CircleShape2D).radius
	draw_arc(Vector2.ZERO, r, 0, TAU, 16, Color.WHITE, 3)

func _on_body_entered(body):
	pass


func _on_body_exited(body):
	pass


