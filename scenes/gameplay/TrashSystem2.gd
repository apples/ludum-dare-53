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
		if GameplaySingleton.current_mission and c.min_difficulty > GameplaySingleton.current_mission.difficulty:
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
			shape_cast_2d.shape.radius = 7
			_spawn_typical(spawn_shape, small_trash_scene)
		Kind.ROCKS:
			shape_cast_2d.shape.radius = 16
			_spawn_typical(spawn_shape, medium_trash_scene)
		Kind.GAS:
			shape_cast_2d.shape.radius = 16
			_spawn_gas(spawn_shape, cloud_hazard)
		Kind.MINES:
			shape_cast_2d.shape.radius = 8
			_spawn_typical(spawn_shape, mine_hazard)
		Kind.MIXED:
			shape_cast_2d.shape.radius = 32
			_spawn_mixed(spawn_shape)

func _spawn_typical(spawn_shape: CollisionShape2D, obj_scene):
	
	var radius = (spawn_shape.shape as CircleShape2D).radius
	var arc_stride = spawn_shape.arc_stride
	var radius_stride: float = spawn_shape.radius_stride
	
	var pos = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var f = 0
	var s = 0
	
	while pos.length() < radius:
		shape_cast_2d.global_position = spawn_shape.to_global(pos)
		shape_cast_2d.force_shapecast_update()
		
		if not shape_cast_2d.is_colliding():
			var obj = obj_scene.instantiate()
			obj.global_position = spawn_shape.to_global(pos)
			add_child(obj)
			s += 1
		else:
			f += 1
		
		var a = arc_stride / pos.length()
		pos = pos.rotated(a)
		pos += pos.normalized() * max(0.5, (radius_stride * (1 - sqrt(pos.length() / radius))))

func _spawn_mixed(spawn_shape: CollisionShape2D):
	var rng = RandomNumberGenerator.new()
	var rand = rng.randf()
	var radius = (spawn_shape.shape as CircleShape2D).radius
	var arc_stride = spawn_shape.arc_stride
	var radius_stride: float = spawn_shape.radius_stride
	
	var pos = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var f = 0
	var s = 0
	
	while pos.length() < radius:
		shape_cast_2d.global_position = spawn_shape.to_global(pos)
		shape_cast_2d.force_shapecast_update()
		rand = rng.randf()
		if not shape_cast_2d.is_colliding():
			var obj
			if rand < .5:
				obj = medium_trash_scene.instantiate()
			elif rand < .75:
				obj = small_trash_scene.instantiate()
			elif rand < .87:
				obj = large_trash_scene.instantiate()
			else:
				obj = large_trash_scene2.instantiate()
			obj.global_position = spawn_shape.to_global(pos)
			add_child(obj)
			s += 1
		else:
			f += 1
		
		var a = arc_stride / pos.length()
		pos = pos.rotated(a)
		pos += pos.normalized() * max(0.5, (radius_stride * (1 - sqrt(pos.length() / radius))))

func _spawn_gas(spawn_shape: CollisionShape2D, obj_scene):
	var shape = spawn_shape.shape
	
	var rate = spawn_shape.gas_rate
	var step = Vector2(32, 32) / spawn_shape.scale
	
	if shape is CircleShape2D:
		var radius = shape.radius
		var radius2 = radius * radius
		
		for y in range(-radius, radius, step.y):
			for x in range(-radius, radius, step.x):
				if rate != 1 and randf() > rate:
					continue
				var pos = Vector2(x, y)
				if pos.length_squared() > radius2:
					continue
				var obj = obj_scene.instantiate()
				obj.global_position = spawn_shape.to_global(pos)
				obj.rotation = randf_range(0, TAU)
				add_child(obj)
	elif shape is RectangleShape2D:
		var rx = shape.size.x / 2
		var ry = shape.size.y / 2
		for y in range(-ry, ry, step.y):
			for x in range(-rx, rx, step.x):
				if rate != 1 and randf() > rate:
					continue
				var pos = Vector2(x, y)
				var obj = obj_scene.instantiate()
				obj.global_position = spawn_shape.to_global(pos)
				obj.rotation = randf_range(0, TAU)
				add_child(obj)

enum Kind {
	SMALL_TRASH,
	ROCKS,
	GAS,
	MINES,
	MIXED
}
