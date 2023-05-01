extends RigidBody2D

var connect_to

var radius = 20
var move_force = 100

var gas_accumulation: float = 0

var worth = 1

var initial_health = 4

var health = 4:
	get:
		return health
	set(value):
		health = value
		_update_sprite()
		if health <= 0:
			destroyed.emit()
			print("Package destroyed")

var damage_velocity_threshold = 30
var fragile_health_threshold = 2

var default_texture = preload("res://assets/pckge_amzn_1.png")
var fragile_texture = preload("res://assets/pckge_amzn_fragile.png")
var bio_texture = preload("res://assets/pckge_bio_1.png")

signal destroyed()

func _ready():
	_update_sprite()

func _physics_process(delta):
	if connect_to:
		var d = global_position.distance_to(connect_to.global_position)
		if d > radius:
			var dir = global_position.direction_to(connect_to.global_position)
			apply_force(dir * move_force)
			linear_damp = 5
		else:
			linear_damp = clamp(inverse_lerp(radius, 1.0, d), 0.0, 1.0) * 40 + 10



func _on_body_entered(body):
	if body is RigidBody2D && (!body.is_in_group("small_trash") || !body.connect_to):
		var vd = (linear_velocity - body.linear_velocity).length()
		print(vd)
		if vd > damage_velocity_threshold:
			print("Package damaged")
			health -= 1

func _update_sprite():
	if health <= fragile_health_threshold:
		$Sprite2D.texture = fragile_texture
	else:
		$Sprite2D.texture = default_texture
