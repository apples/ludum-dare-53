extends Control
var gameplay_scene = "res://scenes/gameplay/gameplay.tscn"

func _ready():
	$online_mode_details/username_input.text = "Player_%s" %[create_random_client_id()]
	pass

func _on_play_button_pressed():
	if $online_mode_toggle.button_pressed:
		$online_mode_details.visible = true
#		Api.get_healthcheck()
		print(await Api.get_api_status())
	else:
		switch_to_gameplay_scene()

func create_random_client_id(): 
	const chars = "FGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	var clientId = ""

	for i in range(0, 7):
		clientId += chars[randi_range(0, chars.length() - 1)]
		
	return clientId

func switch_to_gameplay_scene():
	get_tree().change_scene_to_file(gameplay_scene)

func _on_online_mode_confirm_pressed():
	Configs.username = $online_mode_details/username_input.text
	switch_to_gameplay_scene()
	

func _on_online_mode_cancel_pressed():
	$online_mode_details.visible = false

