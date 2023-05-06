extends RigidBody2D

var connect_to
var radius = 20
var move_force = 100

var worth = 1

var _textures: Array[Texture2D] = [
	preload("res://objects/trash/small_trash/Aicore_junk.png"),
	preload("res://objects/trash/small_trash/Broken_ship_junk.png"),
	preload("res://objects/trash/small_trash/cone_junk.png"),
	preload("res://objects/trash/small_trash/hal_junk.png"),
	preload("res://objects/trash/small_trash/Plantetoid_junk.png"),
	preload("res://objects/trash/small_trash/Ship_piece_junk.png"),
	preload("res://objects/trash/small_trash/Strut2_junk.png"),
	preload("res://objects/trash/small_trash/strut3_junk.png"),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = _textures.pick_random()
#	pass
#	var rng = RandomNumberGenerator.new()
#	linear_velocity = Vector2(rng.randf_range(-75, 75), rng.randf_range(-75, 75))
#	position = Vector2(rng.randf_range(0, 400), rng.randf_range(0, 200))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if connect_to && connect_to != null:
		var d = global_position.distance_to(connect_to.global_position)#connect_to is null when last trash piece breaks
		if d > radius:
			var dir = global_position.direction_to(connect_to.global_position)
			apply_force(dir * move_force)
			linear_damp = 5
		else:
			linear_damp = clamp(inverse_lerp(radius, 1.0, d), 0.0, 1.0) * 40 + 10
