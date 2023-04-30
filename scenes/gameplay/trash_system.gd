extends Node

@export var small_count: int = 500
@export var medium_count: int = 200
@export var large_count: int = 50
var small_trash_scene = preload("res://objects/trash/small_trash/small_trash.tscn")
var medium_trash_scene = preload("res://objects/trash/medium_trash/medium_trash.tscn")
var large_trash_scene = preload("res://objects/trash/large_trash/large_trash.tscn")

@export var trash_spawn_timer: float = 10
var current_timer: float = 0

@onready var player_ship = get_node("/root/Gameplay/PlayerShip")

func _ready():
	var rng = RandomNumberGenerator.new()
	for i in range(0, small_count - 1):
		var new_trash = small_trash_scene.instantiate()
		#new_trash.linear_velocity = Vector2(rng.randf_range(-75, 75), rng.randf_range(-75, 75))
		new_trash.position = Vector2(rng.randf_range(200, 3500), rng.randf_range(-300, 300))
		add_child(new_trash)
	for i in range(0, medium_count - 1):
		var new_trash = medium_trash_scene.instantiate()
		#new_trash.linear_velocity = Vector2(rng.randf_range(-75, 75), rng.randf_range(-75, 75))
		new_trash.position = Vector2(rng.randf_range(200, 3500), rng.randf_range(-300, 300))
		add_child(new_trash)
	for i in range(0, large_count - 1):
		var new_trash = large_trash_scene.instantiate()
		#new_trash.linear_velocity = Vector2(rng.randf_range(-75, 75), rng.randf_range(-75, 75))
		new_trash.position = Vector2(rng.randf_range(200, 3500), rng.randf_range(-300, 300))
		add_child(new_trash)


func _process(delta):
	current_timer -= delta
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

