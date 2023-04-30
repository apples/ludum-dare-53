extends Node

@export var box_count: int:
	get:
		return box_count
	set(value):
		box_count = value
		changed.emit("box_count", box_count)

signal changed(property: StringName, value)

func _enter_tree():
	GameplaySingleton.current = self

func _exit_tree():
	GameplaySingleton.current = null
