extends Node2D

var item_scene = preload("res://scenes/mission_menu/mission_item.tscn")

var _item_infos = [
]

var _easy_missions = [
	{ name = "Gravel", desc = "The people need their gravel." },
]

var _hard_missions = [
	{ name = "Fine Glassware", desc = "The people need their wine glasses." },
]

var _boss_missions = [
	{ name = "Human Heart", desc = "The people need their heart organs." },
]

var _items = []

@onready var mission_select_list = %MissionSelect
@onready var dialog_label = %DialogLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	_add_item(_easy_missions.pick_random(), 0)
	
	if SaveGame.current.current_cycle > 1:
		_add_item(_hard_missions.pick_random(), 1)
	
	if SaveGame.current.current_cycle > 6:
		_add_item(_boss_missions.pick_random(), 2)
	
	for i in range(_item_infos.size()):
		var item_info = _item_infos[i]
		var item = item_scene.instantiate()
		mission_select_list.add_child(item)
		item.item = item_info
		item.clicked.connect(func (): _on_item_clicked(i))
		item.button_focused.connect(func (): _on_item_focused(i))
		_items.append(item)
	
	_items[0].focus()
	
	say_dialog(["Here's the jobs."])

func _add_item(info, difficulty):
	var with_diff = info.duplicate(true)
	with_diff.difficulty = difficulty
	_item_infos.append(with_diff)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_item_clicked(i: int):
	var info = _item_infos[i]
	print("Buying %s" % info.name)
	
	if SaveGame.current.money < info.cost:
		say_dialog([
			"I CANNOT EAT EXPOSURE.",
			"Can't afford that one, cowboy...",
		])
	
	if info.key == null:
		return
	
	SaveGame.current.money -= info.cost
	if info.key in SaveGame.current.inventory:
		SaveGame.current.inventory[info.key] += 1
	else:
		SaveGame.current.inventory[info.key] = 1
	
	SaveGame.save()

func _on_item_focused(i: int):
	var info = _item_infos[i]
	say_dialog(info.desc)

func _on_done_panel_clicked():
	say_dialog("Goodbye!")


func _on_done_panel_focus_entered():
	say_dialog([
		"Done already?",
		"W-wait! I need the money for college!",
	])

func say_dialog(options):
	if options is String:
		dialog_label.speak(options)
		return
	dialog_label.speak(options.pick_random())
