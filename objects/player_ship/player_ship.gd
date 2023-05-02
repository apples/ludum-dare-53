extends RigidBody2D

signal player_ship_damaged(amount)

@export var angular_acceleration: float = 5000
@export var black_hole_spawn_distance: float = 32
@export var black_hole_strength: float = 100

@export var thruster_spawn_distance: float = 16
@export var thruster_spawn_velocity: float = 5

@export var dock_anchor_strength: float = 1

@export var enable_input: bool = true

@export var thrust_strength: float = 50

@export var tether_strength: float = 5

@export var impact_threshold: float = 50 # m/s

var death_explosion_scene = preload("res://objects/death_explosion/death_explosion.tscn")
var black_hole_scene = preload("res://objects/black_hole/black_hole.tscn")
var thruster_scene = preload("res://objects/thruster/thruster.tscn")
var game_over_scene = "res://scenes/game_over/game_over.tscn"
var current_black_hole
var death_initiated = false

var initial_health = 15

var health = 15:
	get:
		return health
	set(value):
		health = value
		player_ship_damaged.emit(value)
		$player_ship_animations.play("hurt")
		print("Damage! Health left: ", health)
		if health <= 0 and not death_initiated:
			$sfx/take_damage.stop()
			initiate_death_sequence()

var gas_accumulation: float = 0

var _turn_direction: float
var _thrust_direction: float
var _queue_thruster: bool = false

var tethered_objects: Array[RigidBody2D]

var packages = []

@onready var tail_anchor = $TailAnchor

func _process(delta):
	if not enable_input:
		_turn_direction = 0
		_thrust_direction = 0
		_queue_thruster = false
		return
	
	if SaveGame.current.inventory.thrusters > 0 and Input.is_action_just_pressed("spawn_thruster"):
		_queue_thruster = true
	
	if Input.is_action_just_pressed("spawn_black_hole"):
		current_black_hole = black_hole_scene.instantiate()
		current_black_hole.global_position = global_position + global_transform.basis_xform(Vector2.RIGHT) * black_hole_spawn_distance
		current_black_hole.strength = black_hole_strength
		get_parent().add_child(current_black_hole)
	
	if current_black_hole and not Input.is_action_pressed("spawn_black_hole"):
		current_black_hole.queue_free()
		current_black_hole = null
	
	_turn_direction = Input.get_axis("turn_left", "turn_right")
	_thrust_direction = -Input.get_axis("thrust_forward", "thrust_backwards")
	
	if Input.is_action_just_pressed("grab"):
		var objects = $Area2D.get_overlapping_bodies()
		for obj in objects:
			if obj.is_in_group("small_trash"):
				obj.mass = .1
#				tethered_objects.push_back(obj)
				obj.global_transform.origin = global_position
				obj.connect_to = packages[-1] if packages.size() > 0 else tail_anchor
				#packages.add_child(obj)
				get_parent().packages.add_child(obj)
				packages.append(obj)
				break

func _physics_process(delta):
	
	if _queue_thruster:
		_queue_thruster = false
		var new_thruster = thruster_scene.instantiate()
		var direction = global_transform.basis_xform(Vector2.RIGHT)
		new_thruster.global_position = global_position + direction * thruster_spawn_distance
		new_thruster.linear_velocity = direction * thruster_spawn_velocity
		new_thruster.rotation = self.rotation
		SaveGame.current.inventory.thrusters -= 1
		SaveGame.save()
		get_parent().add_child(new_thruster)
		$sfx/shoot_thruster.play()
	
	apply_torque(_turn_direction * angular_acceleration)
	apply_force(_thrust_direction * global_transform.basis_xform(Vector2.RIGHT) * thrust_strength)
	
	for obj in tethered_objects:
		#print($Area2D.position)
		obj.linear_velocity += ($Area2D.global_position - obj.position) * tether_strength * delta

func anchor_to(anchor_point: Vector2, anchor_rotation: float):
	var anchor = Anchor.new()
	anchor.anchor_position = anchor_point
	anchor.anchor_angle = anchor_rotation
	anchor.linear_spring_constant = dock_anchor_strength
	add_child(anchor)


func _on_body_entered(body):
	if body.is_in_group("thrustable"):
		var impact_vector = self.linear_velocity - body.linear_velocity
		#print(impact_vector.length())
		if impact_vector.length() > impact_threshold:
			health -= 1
			$sfx/take_damage.play()
			
func initiate_death_sequence():
	death_initiated = true
	$sfx/death_noise.play()
	$DeathInitiatedTimer.start()
	$ExplosionAddedTimer.start()
	enable_input = false

func _on_death_initiated_timer_timeout():
	SaveGame.reload()
	get_tree().change_scene_to_file(game_over_scene)

func _on_explosion_added_timer_timeout():
	var death_explosion: Node2D = death_explosion_scene.instantiate()
	death_explosion.position.x += randf_range(-20, 20)
	death_explosion.position.y += randf_range(-20, 20)
	death_explosion.play("default")
	$DeathExplosions.add_child(death_explosion)
