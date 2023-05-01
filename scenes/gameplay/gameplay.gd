extends Node
var shop_menu_scene = "res://scenes/shop_menu/shop_menu.tscn"
var given_boxes: int = 5

var start_impulse = 500

var package_scene = preload("res://objects/package/package.tscn")

@onready var player_ship = %PlayerShip
@onready var packages = $Packages

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameplaySingleton.current_mission:
		load_mission(GameplaySingleton.current_mission)
	else:
		load_mission({ difficulty = 0 })
	Bgmusic.PlayGameplayMusic()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_docking_station_ship_docked(ship_body, anchor_point, anchor_rotation):
	%PlayerShip.anchor_to(anchor_point, anchor_rotation)
	$DockingCompletedTimer.start()


func _on_start_timer_timeout():
	$PlayerShip.enable_input = true
	$PlayerShip.apply_impulse(Vector2.RIGHT * start_impulse)
	$StartTimer.queue_free()

func _on_docking_completed_timer_timeout():
	print("unload cargo, load shop, reset level")
	SaveGame.current.current_cycle += 1
	SaveGame.save()
	get_tree().change_scene_to_file(shop_menu_scene)

func load_mission(mission_info):
	var num_packages
	var package_hp
	
	match mission_info.difficulty:
		0:
			num_packages = 3
			package_hp = 4
		1:
			num_packages = 5
			package_hp = 2
		2:
			num_packages = 1
			package_hp = 1
	
	var prev_link = player_ship.tail_anchor
	for c in packages.get_children():
		c.queue_free()
	for i in range(num_packages):
		var package = package_scene.instantiate()
		package.global_transform.origin = player_ship.global_position
		package.connect_to = prev_link
		package.health = package_hp
		package.destroyed.connect(func (): call_deferred("_on_package_destroyed", package))
		packages.add_child(package)
		prev_link = package

func _on_package_destroyed(package):
	var i = package.get_index()
	packages.remove_child(package)
	if i < packages.get_child_count():
		packages.get_child(i).connect_to = package.connect_to
	package.queue_free()
