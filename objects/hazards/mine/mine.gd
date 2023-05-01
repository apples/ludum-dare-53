extends RigidBody2D

@export var damage: int = 3
var _exploded = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("player_ship") || body.is_in_group("package"):
		body.linear_velocity += (body.global_position - global_position).normalized() * 100
		body.health -= damage
		$AnimatedSprite2D.sprite_frames = load("res://objects/hazards/mine/exploding.tres")
		$AnimatedSprite2D.play("default")
		_exploded = true

func _on_animated_sprite_2d_animation_looped():
	if _exploded:
		self.queue_free()
