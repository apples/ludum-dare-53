extends Node

@export var small_count: int = 400
@export var medium_count: int = 200
@export var large_count: int = 100
var small_trash_scene = preload("res://objects/trash/small_trash/small_trash.tscn")
var medium_trash_scene = preload("res://objects/trash/medium_trash/medium_trash.tscn")
var large_trash_scene = preload("res://objects/trash/large_trash/large_trash.tscn")
var large_trash_scene2 = preload("res://objects/trash/large_trash2/large_trash2.tscn")

@export var trash_spawn_timer: float = 10
var current_timer: float = 0

@onready var player_ship = get_node("/root/Gameplay/PlayerShip")

func _ready():
	var rng = RandomNumberGenerator.new()
	var new_trash
	for i in range(0, small_count - 1):
		new_trash = small_trash_scene.instantiate()
		#new_trash.linear_velocity = Vector2(rng.randf_range(-75, 75), rng.randf_range(-75, 75))
		new_trash.position = Vector2(rng.randf_range(200, 3500), rng.randf_range(-300, 300))
		add_child(new_trash)
	for i in range(0, medium_count - 1):
		new_trash = medium_trash_scene.instantiate()
		#new_trash.linear_velocity = Vector2(rng.randf_range(-75, 75), rng.randf_range(-75, 75))
		new_trash.position = Vector2(rng.randf_range(200, 3500), rng.randf_range(-300, 300))
		add_child(new_trash)
	for i in range(0, (large_count / 2) - 1):
		new_trash = large_trash_scene.instantiate()
		new_trash.position = Vector2(rng.randf_range(200, 3500), rng.randf_range(-300, 300))
		add_child(new_trash)
		new_trash = large_trash_scene2.instantiate()
		new_trash.position = Vector2(rng.randf_range(200, 3500), rng.randf_range(-300, 300))
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

