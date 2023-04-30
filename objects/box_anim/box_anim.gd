extends Node2D

signal animation_finished(anim_name: String)

func _on_animation_player_animation_finished(anim_name):
	animation_finished.emit(anim_name)
	queue_free()
