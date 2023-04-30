extends Node2D

var item_scene = preload("res://scenes/shop_menu/shop_item.tscn")

var _item_infos = [
	{ name = "Thrusters", cost = 4, desc = "Woah these bad boys sure do thrust! Out of sight, out of mind." },
	{ name = "Boosters", cost = 4, desc = "Boy howdy these'll sure boost ya! Go fast and stuff!" },
]

var _items = []

@onready var shop_list = %ShopList

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(_item_infos.size()):
		var item_info = _item_infos[i]
		var item = item_scene.instantiate()
		shop_list.add_child(item)
		item.clicked.connect(func (): _on_item_clicked(i))
		_items.append(item)
	
	_items[0].focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_item_clicked(i: int):
	var info = _item_infos[i]
	print("Bought %s" % info.name)

func _on_done_panel_clicked():
	print("Done shopping")
