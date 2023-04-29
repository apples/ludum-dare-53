extends Control
var gameplay_scene = "res://scenes/gameplay/gameplay.tscn"

func _ready():
	$online_mode_details/username_input.text = "Player_%s" %[create_random_client_id()]
	print(create_random_client_id())
	pass

func _process(delta):
	pass

func _on_play_button_pressed():
	if $online_mode.button_pressed:
		$online_mode_details.visible = true
		print("open modal")
	else:
		get_tree().change_scene_to_file(gameplay_scene)

func create_random_client_id(): 
	const chars = "FGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	var clientId = ""

	for i in range(0, 7):
		clientId += chars[randi_range(0, chars.length() - 1)]
		
	return clientId


func _on_details_cancel_button_pressed():
	$online_mode_details.visible = false
