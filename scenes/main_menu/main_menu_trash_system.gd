extends Node

@export var small_count: int = 50
@export var medium_count: int = 25

var small_trash_scene = preload("res://objects/trash/small_trash/small_trash.tscn")
var medium_trash_scene = preload("res://objects/trash/medium_trash/medium_trash.tscn")

func _ready():
	spawn_trash()
		
func spawn_trash():
	var rng = RandomNumberGenerator.new()
	for i in range(0, small_count - 1):
		var new_trash = small_trash_scene.instantiate()
		new_trash.linear_velocity = Vector2(rng.randf_range(-75, 0), rng.randf_range(-75, 75))
		new_trash.position = Vector2(rng.randf_range(500, 600), rng.randf_range(-300, 300))
		%trash_container.call_deferred("add_child", new_trash)
	for i in range(0, medium_count - 1):
		var new_trash = medium_trash_scene.instantiate()
		new_trash.linear_velocity = Vector2(rng.randf_range(-75, 0), rng.randf_range(-75, 75))
		new_trash.position = Vector2(rng.randf_range(500, 600), rng.randf_range(-300, 300))
		%trash_container.call_deferred("add_child", new_trash)

func _on_trash_collector_body_entered(body: Node):
	if body.get_parent().name == "trash_container":
		body.queue_free()

func _on_spawn_trash_timer_timeout():
	spawn_trash()


