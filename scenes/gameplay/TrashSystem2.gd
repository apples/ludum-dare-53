extends Node

var small_trash_scene = preload("res://objects/trash/small_trash/small_trash.tscn")
var medium_trash_scene = preload("res://objects/trash/medium_trash/medium_trash.tscn")
var large_trash_scene = preload("res://objects/trash/large_trash/large_trash.tscn")
var large_trash_scene2 = preload("res://objects/trash/large_trash2/large_trash2.tscn")
var cloud_hazard = preload("res://objects/hazards/cloud/cloud_hazard.tscn")
var mine_hazard = preload("res://objects/hazards/mine/mine.tscn")

@onready var shape_cast_2d = $ShapeCast2D


func _ready():
	randomize()
	
	var decided_spawns = []
	
	var children = get_children()
	children.shuffle()
	
	var accumulator: float = 0.0
	
	for c in children:
		if not c is CollisionShape2D:
			continue
		accumulator += c.chance
		if accumulator >= 1.0:
			decided_spawns.append(c)
			accumulator -= 1.0
		c.queue_free()
	
	for s in decided_spawns:
		_spawn(s)

func _spawn(spawn_shape):
	match spawn_shape.kind:
		Kind.SMALL_TRASH:
			_spawn_typical(spawn_shape, small_trash_scene)
		Kind.ROCKS:
			_spawn_typical(spawn_shape, medium_trash_scene)
		Kind.GAS:
			_spawn_gas(spawn_shape, cloud_hazard)

func _spawn_typical(spawn_shape, obj_scene):
	
	var origin = spawn_shape.position
	var radius = (spawn_shape.shape as CircleShape2D).radius
	var arc_stride = spawn_shape.arc_stride
	var radius_stride: float = spawn_shape.radius_stride
	
	var pos = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var f = 0
	var s = 0
	
	while pos.length() < radius:
		shape_cast_2d.position = origin + pos
		shape_cast_2d.force_shapecast_update()
		
		if not shape_cast_2d.is_colliding():
			var obj = obj_scene.instantiate()
			obj.position = origin + pos
			add_child(obj)
			s += 1
		else:
			f += 1
		
		var a = arc_stride / pos.length()
		pos = pos.rotated(a)
		pos += pos.normalized() * max(0.5, (radius_stride * (1 - sqrt(pos.length() / radius))))
	

func _spawn_gas(spawn_shape, obj_scene):
	var origin = spawn_shape.position
	var shape = spawn_shape.shape
	
	if shape is CircleShape2D:
		var radius = shape.radius
		var radius2 = radius * radius
		
		for y in range(-radius, radius, 32):
			for x in range(-radius, radius, 32):
				var pos = Vector2(x, y)
				if pos.length_squared() > radius2:
					continue
				var obj = obj_scene.instantiate()
				obj.position = origin + pos
				add_child(obj)
	elif shape is RectangleShape2D:
		var rx = shape.size.x / 2
		var ry = shape.size.y / 2
		for y in range(-ry, ry, 32):
			for x in range(-rx, rx, 32):
				var pos = Vector2(x, y)
				var obj = obj_scene.instantiate()
				obj.position = origin + pos
				add_child(obj)

enum Kind {
	SMALL_TRASH,
	ROCKS,
	GAS,
}
