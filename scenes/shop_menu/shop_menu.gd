extends Node2D

var mission_scene = "res://scenes/mission_menu/mission_menu.tscn"
var item_scene = preload("res://scenes/shop_menu/shop_item.tscn")

var _item_infos = [
	{ key = "thrusters", name = "Thrusters", cost = 4, desc = "Woah these bad boys sure do thrust! Out of sight, out of mind." },
	{ key = null, name = "Boosters", cost = 4, desc = "Boy howdy these'll sure boost ya! Go fast and stuff!" },
]

var _items = []

@onready var shop_list = %ShopList
@onready var dialog_label = %DialogLabel
@onready var money_label = %MoneyLabel
@onready var shop_group = %ShopGroup

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(_item_infos.size()):
		var item = item_scene.instantiate()
		shop_list.add_child(item)
		item.clicked.connect(func (): _on_item_clicked(i))
		item.button_focused.connect(func (): _on_item_focused(i))
		
		var item_info = _item_infos[i]
		item.item = item_info
		if item_info.key in SaveGame.current.inventory:
			item.owned = SaveGame.current.inventory[item_info.key]
		
		_items.append(item)
	
	_items[0].focus()
	
	money_label.text = "$%s" % SaveGame.current.money
	
	say_dialog(["Howdy!!"])
	
	Bgmusic.PlayMenuMusic()


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
		return
	
	if info.key == null:
		return
	
	SaveGame.current.money -= info.cost
	money_label.text = "$%s" % SaveGame.current.money
	
	if info.key in SaveGame.current.inventory:
		SaveGame.current.inventory[info.key] += 1
		_items[i].owned = SaveGame.current.inventory[info.key]
	else:
		SaveGame.current.inventory[info.key] = 1
	
	SaveGame.save()

func _on_item_focused(i: int):
	var info = _item_infos[i]
	say_dialog(info.desc)

func _on_done_panel_clicked():
	say_dialog("Goodbye!")
	$ShoppingDoneTimer.start()
	shop_group.visible = false

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

func _on_shopping_done_timer_timeout():
	get_tree().change_scene_to_file(mission_scene)
