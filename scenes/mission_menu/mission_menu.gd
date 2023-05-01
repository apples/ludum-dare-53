extends Node2D

var item_scene = preload("res://scenes/mission_menu/mission_item.tscn")
var gameplay_scene = "res://scenes/gameplay/gameplay.tscn"
var shop_scene = "res://scenes/shop_menu/shop_menu.tscn"

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

# Phrases said after each successful delivery.
# Ordered from worst to best.
var _score_phrases = [
	"A moonrat could've done a better job.",
	"Wow good job.",
]

# Neutral dialog phrases. Picked at random.
var _neutral_phrases = [
	"Here's the jobs.",
	"Dont' forget to shop!",
]

# Goodbye phrases said when departing on mission.
var _goodbye_phrases = [
	"Sayonara."
]

var _items = []

@onready var mission_select_list = %MissionSelect
@onready var dialog_label = %DialogLabel
@onready var mission_select_wrapper = %MissionSelectWrapper

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
	
	Bgmusic.PlayMenuMusic()
	
	if GameplaySingleton.delivery_score != -1:
		_say_score()
	else:
		_say_neutral()

func _say_neutral():
	say_dialog(_neutral_phrases)

func _say_score():

	var i = _score_phrases.size() * GameplaySingleton.delivery_score / 101
	
	mission_select_wrapper.visible = false
	
	await say_dialog(_score_phrases[i])
	
	await get_tree().create_timer(2).timeout
	
	mission_select_wrapper.visible = true
	
	_say_neutral()

func _add_item(info, difficulty):
	var with_diff = info.duplicate(true)
	with_diff.difficulty = difficulty
	_item_infos.append(with_diff)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_item_clicked(i: int):
	var info = _item_infos[i]
	print("Staring mission %s" % info.name)
	
	mission_select_wrapper.visible = false
	
	await say_dialog(_goodbye_phrases)
	
	await get_tree().create_timer(2).timeout
	
	GameplaySingleton.current_mission = info
	get_tree().change_scene_to_file(gameplay_scene)

func _on_item_focused(i: int):
	var info = _item_infos[i]
	say_dialog(info.desc)

func say_dialog(options):
	if options is String:
		dialog_label.speak(options)
		return
	dialog_label.speak(options.pick_random())
	return dialog_label.done


func _on_shop_panel_clicked():
	get_tree().change_scene_to_file(shop_scene)

