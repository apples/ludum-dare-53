extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	match (rng.randi_range(0, 0)):
		0:
			$Sprite2D.texture = load("res://objects/trash/large_trash2/strut_junk.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
