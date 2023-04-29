extends Control
var gameplay_scene = "res://scenes/gameplay/gameplay.tscn"

func _ready():
	pass

func _process(delta):
	pass

func _on_play_button_pressed():
	if $online_mode.button_pressed:
		print("open modal")
	else:
		get_tree().change_scene_to_file(gameplay_scene)
