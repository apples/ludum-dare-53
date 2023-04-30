extends Control
var gameplay_scene = "res://scenes/gameplay/gameplay.tscn"

func _ready():
	$spinner_wheel.play("default")
	$online_mode_details/username_input.text = "Player_%s" %[create_random_client_id()]
	check_api_sever()
	
func check_api_sever():
	var server_up = await Api.get_api_status()
	if server_up:
		$online_mode_toggle.disabled = false
		$online_mode_toggle.button_pressed = true
		$spinner_wheel.visible = false
	else:
		$spinner_wheel.visible = false

func _on_play_button_pressed():
	if $online_mode_toggle.button_pressed:
		$online_mode_details.visible = true
#		Api.get_healthcheck()
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
	var success = await Api.send_create_player(Configs.username)
	if success:
		switch_to_gameplay_scene()
	else:
		$online_mode_details/username_validation_label.visible = true

func _on_online_mode_cancel_pressed():
	$online_mode_details.visible = false

func _on_username_input_text_changed(new_text):
	$online_mode_details/username_validation_label.visible = false
