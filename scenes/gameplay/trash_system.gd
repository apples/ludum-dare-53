extends Node

#spawn weights
@export var small_count: int = 400#16
@export var medium_count: int = 200#8
@export var large_count: int = 100#4
@export var mine_count: int = 50#2
@export var cloud_count: int = 25#1

@export var background_object_num: int = 500
@export var trash_cluster_num: int = 20

var small_trash_scene = preload("res://objects/trash/small_trash/small_trash.tscn")
var medium_trash_scene = preload("res://objects/trash/medium_trash/medium_trash.tscn")
var large_trash_scene = preload("res://objects/trash/large_trash/large_trash.tscn")
var large_trash_scene2 = preload("res://objects/trash/large_trash2/large_trash2.tscn")
var cloud_hazard = preload("res://objects/hazards/cloud/cloud_hazard.tscn")
var mine_hazard = preload("res://objects/hazards/mine/mine.tscn")

@export var trash_spawn_timer: float = 10
var current_timer: float = 0

@export var cloud_chance: float = .5

@onready var player_ship = get_node("/root/Gameplay/PlayerShip")

func _ready():
	var rng = RandomNumberGenerator.new()
	var new_trash
	
	#spawns clusters
	var spoke = Vector2(0, 100)
	var point = Vector2(200, 0)
	var step_mod = 5
	for i in range(0, trash_cluster_num):
		spoke = Vector2(0, 150)
		point = Vector2(rng.randf_range(200, 3500), rng.randf_range(-225, 225))
		while spoke.length() > 32:
			spawn_rand_trash(point + spoke + Vector2(rng.randf_range(-5, 5), rng.randf_range(-5, 5)))
			spoke = spoke.normalized() * (spoke.length() - step_mod)
			spoke.rotated(PI/8)

	for i in range(0, background_object_num):
		var rand_pos = Vector2(rng.randf_range(200, 3500), rng.randf_range(-300, 300))
		$ShapeCast2D.global_position = rand_pos
		if !$ShapeCast2D.is_colliding():
			spawn_rand_trash(rand_pos)


func spawn_rand_trash(pos: Vector2):
	var rng = RandomNumberGenerator.new()
	var rand = rng.randi_range(0, small_count)
	var new_trash
	
	if rand <= cloud_count:
		new_trash = cloud_hazard.instantiate()
		new_trash.position = pos
		add_child(new_trash)
	elif rand <= mine_count:
		new_trash = mine_hazard.instantiate()
		new_trash.position = pos
		add_child(new_trash)
	elif rand <= large_count:
		if rng.randf() > .5:
			new_trash = large_trash_scene.instantiate()
			new_trash.position = pos
			add_child(new_trash)
		else:
			new_trash = large_trash_scene2.instantiate()
			new_trash.position = pos
			add_child(new_trash)
	elif rand <= medium_count:
		new_trash = medium_trash_scene.instantiate()
		new_trash.position = pos
		add_child(new_trash)
	else:
		new_trash = small_trash_scene.instantiate()
		new_trash.position = pos
		add_child(new_trash)

func _process(delta):
	current_timer -= delta * (player_ship.linear_velocity.x / 8)
	if(current_timer <= 0):
		current_timer = trash_spawn_timer

		var rng = RandomNumberGenerator.new()
		var new_trash = large_trash_scene.instantiate()
		new_trash.linear_velocity = Vector2(rng.randf_range(-75, 75), rng.randf_range(-50, -75))
		new_trash.position = Vector2(player_ship.position.x + 50, 350)
		add_child(new_trash)

		new_trash = large_trash_scene.instantiate()
		new_trash.linear_velocity = Vector2(rng.randf_range(-75, 75), rng.randf_range(50, 75))
		new_trash.position = Vector2(player_ship.position.x + 50, -350)
		add_child(new_trash)

		if rng.randf() < cloud_chance / 2:
			new_trash = cloud_hazard.instantiate()
			new_trash.linear_velocity = Vector2(rng.randf_range(-75, 75), rng.randf_range(-25, -50))
			new_trash.position = Vector2(player_ship.position.x + 50, 350)
			add_child(new_trash)
		elif rng.randf() < cloud_chance / 2:
			new_trash = cloud_hazard.instantiate()
			new_trash.linear_velocity = Vector2(rng.randf_range(-75, 75), rng.randf_range(25, 50))
			new_trash.position = Vector2(player_ship.position.x + 50, -350)
			add_child(new_trash)

