extends Control

signal exit()

func _process(delta):
	if Input.is_action_just_pressed("deploy"):
		exit.emit()
