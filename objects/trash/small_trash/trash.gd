extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	match (rng.randi_range(0, 7)):
		0:
			$Sprite2D.texture = load("res://objects/trash/small_trash/Aicore_junk.png")
		1:
			$Sprite2D.texture = load("res://objects/trash/small_trash/Broken_ship_junk.png")
		2:
			$Sprite2D.texture = load("res://objects/trash/small_trash/cone_junk.png")
		3:
			$Sprite2D.texture = load("res://objects/trash/small_trash/hal_junk.png")
		4:
			$Sprite2D.texture = load("res://objects/trash/small_trash/Plantetoid_junk.png")
		5:
			$Sprite2D.texture = load("res://objects/trash/small_trash/Ship_piece_junk.png")
#		6:
#			$Sprite2D.texture = load("res://objects/trash/small_trash/strut_junk.png")
		6:
			$Sprite2D.texture = load("res://objects/trash/small_trash/Strut2_junk.png")
		7:
			$Sprite2D.texture = load("res://objects/trash/small_trash/strut3_junk.png")
#	pass
#	var rng = RandomNumberGenerator.new()
#	linear_velocity = Vector2(rng.randf_range(-75, 75), rng.randf_range(-75, 75))
#	position = Vector2(rng.randf_range(0, 400), rng.randf_range(0, 200))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
