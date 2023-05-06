extends Control

var mission_scene = "res://scenes/mission_menu/mission_menu.tscn"

var _checking = false

func _ready():
	$spinner_wheel.play("default")
	
	$version_label.text = ProjectSettings.get_setting("application/config/git_version/version", "(debug)")
	
	if Configs.offline_mode:
		$online_mode_toggle.button_pressed = false
		$online_mode_toggle.disabled = false
		$spinner_wheel.visible = false
		$logged_in_as_label.visible = false
		$logged_in_username_label.visible = false
	else:
		$online_mode_toggle.button_pressed = true
		check_api_sever()
	
	Bgmusic.PlayGameplayMusic()
	
func check_api_sever():
	if _checking:
		return
	$spinner_wheel.visible = true
	$online_mode_toggle.disabled = true
	$error_label.visible = false
	$logged_in_as_label.visible = false
	$logged_in_username_label.visible = false
	_checking = true
	var server_up = await Api.get_api_status()
	_checking = false
	if server_up:
		if Configs.username != null:
			$logged_in_as_label.visible = true
			$logged_in_username_label.visible = true
			$online_mode_details/username_input.text = Configs.username
			$logged_in_username_label.text = Configs.username
	else:
		$online_mode_toggle.set_pressed_no_signal(false)
		$error_label.visible = true
	$online_mode_toggle.disabled = false
	$spinner_wheel.visible = false

func _on_play_button_pressed():
	if $online_mode_toggle.button_pressed:
		print("Connecting with config %s:%s" % [Configs.username, Configs.user_key])
		if Configs.user_key == null:
			print("No user_key found!")
			$online_mode_details.visible = true
		else:
			var serverPlayerExists = await Api.get_player()
			if not serverPlayerExists:
				print("Player not recognized by server!")
				$online_mode_details.visible = true
			else:
				print("We are GREEEN!")
				switch_to_gameplay_scene()
	else:
		print("We are also GREEEN!")
		switch_to_gameplay_scene()

func create_random_client_id(): 
	const chars := "FGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	var clientId = ""

	for i in range(0, 7):
		clientId += chars[randi_range(0, chars.length() - 1)]
		
	return clientId

func switch_to_gameplay_scene():
	get_tree().change_scene_to_file(mission_scene)

func _on_online_mode_confirm_pressed():
	var success = await Api.send_create_player($online_mode_details/username_input.text)
	if success:
		switch_to_gameplay_scene()
	else:
		$online_mode_details/username_validation_label.visible = true

func _on_online_mode_cancel_pressed():
	$online_mode_details.visible = false

func _on_username_input_text_changed(new_text):
	$online_mode_details/username_validation_label.visible = false


func _on_online_mode_toggle_toggled(button_pressed):
	if Configs.offline_mode != not button_pressed:
		Configs.offline_mode = not button_pressed
		Configs.save()
	
	if button_pressed:
		check_api_sever()
	else:
		$logged_in_as_label.visible = false
		$logged_in_username_label.visible = false
		$online_mode_details/username_input.text = "Player_%s" % create_random_client_id()
