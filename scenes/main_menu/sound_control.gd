extends Control
var toggle_on = true
#
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			toggle_sound()
	
func toggle_sound():
	if toggle_on:
		toggle_on = false
		$SoundControlAnim.frame = 1
		AudioServer.set_bus_mute(1, true)
	else:
		toggle_on = true
		$SoundControlAnim.frame = 0
		AudioServer.set_bus_mute(1, false)
