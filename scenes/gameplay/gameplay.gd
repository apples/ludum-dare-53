extends Node
var mission_menu_scene = "res://scenes/mission_menu/mission_menu.tscn"
var given_boxes: int = 5

var start_impulse = 350

var package_scene = preload("res://objects/package/package.tscn")

var _total_package_health = 1

@onready var player_ship = %PlayerShip
@onready var packages = $Packages
@onready var deployables = $Deployables
@onready var ui = %UI
@onready var follow_camera = $FollowCamera

var _preloaded_scenes = []

var _current_interactions = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameplaySingleton.current_mission:
		load_mission(GameplaySingleton.current_mission)
	else:
		load_mission({ difficulty = 0 })
	Bgmusic.PlayGameplayMusic()
	
	# preload
	for k in Deployables.infos:
		_preloaded_scenes.append(load(Deployables.infos[k].scene))
		
	$DockingArrowAnim.play("default")
	
	for i in SaveGame.current.deployed_structures:
		_spawn_deployable(i)
	
	# TODO: LOAD INTERACTIONS HERE
	
	var remote_interactions = await Api.get_interactions("level_1", SaveGame.current.current_cycle, min(5, SaveGame.current.current_cycle))
	
	for i in remote_interactions:
		_spawn_deployable(i.Content, i.UserName)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("deploy"):
		if not get_tree().paused:
			var f = func ():
				get_tree().paused = true
				ui.deploy_menu_root.visible = true
			f.call_deferred()


var _cheat_code = []
func _unhandled_input(event):
	if event is InputEventKey and event.is_pressed():
		_cheat_code.append(event.keycode - KEY_KP_0)
		_cheat_code = _cheat_code.slice(-7)
		match _cheat_code:
			[8, 6, 7, 5, 3, 0, 9]:
				_on_docking_completed_timer_timeout()
	


func _on_docking_station_ship_docked(ship_body, anchor_point, anchor_rotation):
	%PlayerShip.anchor_to(anchor_point, anchor_rotation)
	$DockingCompletedTimer.start()


func _on_start_timer_timeout():
	player_ship.enable_input = true
	player_ship.apply_impulse(Vector2.RIGHT * start_impulse)
	$StartTimer.queue_free()

func _on_docking_completed_timer_timeout():
	print("unload cargo, load shop, reset level")
	
	var remaining_health = 0
	SaveGame.current.money += 10 # base reward for simply returning alive
	for c in packages.get_children():
		SaveGame.current.money += 1 # base reward per package
		SaveGame.current.money += int(c.worth * c.health / c.initial_health)
		remaining_health += c.health
		c.queue_free()
	
	GameplaySingleton.delivery_score = 100 * remaining_health / _total_package_health
	
	SaveGame.current.current_cycle += 1
	SaveGame.save()
	get_tree().change_scene_to_file(mission_menu_scene)
	
	# TODO: SEND INTERACTIONS HERE
	print(JSON.stringify(_current_interactions))
	print(await Api.send_interactions("level_1", SaveGame.current.current_cycle,
		_current_interactions.map(func (x):
			return {
				"InteractionType": "PlaceStructure",
				"Content": JSON.stringify(x),
			})
	))
	_current_interactions = []

func load_mission(mission_info):
	var num_packages
	var package_hp
	var package_value
	
	match mission_info.difficulty:
		0:
			num_packages = 3
			package_hp = 4
			package_value = 4
		1:
			num_packages = 5
			package_hp = 2
			package_value = 6
		2:
			num_packages = 1
			package_hp = 1
			package_value = 900
	
	var prev_link = player_ship.tail_anchor
	for c in packages.get_children():
		c.queue_free()
	_total_package_health = 0
	for i in range(num_packages):
		var package = package_scene.instantiate()
		package.global_transform.origin = player_ship.global_position
		package.connect_to = prev_link
		package.health = package_hp
		package.initial_health = package_hp
		_total_package_health += package_hp
		package.worth = package_value
		package.destroyed.connect(func (): call_deferred("_on_package_destroyed", package))
		packages.add_child(package)
		prev_link = package
	player_ship.packages = packages.get_children()

func _on_package_destroyed(package):
	var i = package.get_index()
	packages.remove_child(package)
	if i < packages.get_child_count():
		packages.get_child(i).connect_to = package.connect_to
	package.queue_free()
	player_ship.packages = packages.get_children()


func _on_ui_deploy_item(key):
	if not key in SaveGame.current.inventory:
		return
	if SaveGame.current.inventory[key] <= 0:
		return
	
	print("Deploying item ", key)
	
	var interaction = {
		type = "structure",
		key = key,
		position = { x = 0, y = 0 },
		rotation = 0,
	}
	
	var pos = player_ship.global_position
	
	var info = Deployables.infos[key]
	
	if "directed" in info and info.directed:
		pos += Vector2.RIGHT.rotated(player_ship.rotation) * 16
		interaction.rotation = player_ship.rotation
	
	interaction.position = { x = pos.x, y = pos.y }
	
	_post_interaction(interaction)
	_spawn_deployable(interaction)
	
	SaveGame.current.inventory[key] -= 1
	SaveGame.current.deployed_structures.append(interaction)
	SaveGame.current.deployed_structures = SaveGame.current.deployed_structures.slice(-5)
	
	get_tree().paused = false
	ui.deploy_menu_root.visible = false
	
	# TODO: server interaction
	


func _on_ui_exit_deploy():
	get_tree().paused = false
	ui.deploy_menu_root.visible = false

var structure_label_scene = preload("res://scenes/gameplay/structure_label.tscn")
func _spawn_deployable(interaction, whom = null):
	assert(interaction.type == "structure")
	
	var info = Deployables.infos[interaction.key]
	var node = load(info.scene).instantiate()
	node.global_position = Vector2(interaction.position.x, interaction.position.y)
	node.rotation = interaction.rotation
	node.gameplay_root = self
	node.player_ship = player_ship
	
	if whom != null:
		var label = structure_label_scene.instantiate()
		label.text = whom
		node.add_child(label)
	
	deployables.add_child(node)

func _post_interaction(interaction):
	_current_interactions.append(interaction)
