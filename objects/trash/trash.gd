extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	linear_velocity = Vector2(rng.randf_range(-75, 75), rng.randf_range(-75, 75))
	position = Vector2(rng.randf_range(0, 400), rng.randf_range(0, 200))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
