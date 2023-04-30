extends Control

signal clicked()
signal button_focused()
signal button_unfocused()

var item = { name = "", difficulty = 0 }:
	get:
		return item
	set(value):
		item = value
		item_name_label.text = item.name
		match item.difficulty:
			0:
				item_difficulty_label.text = "Easy"
			1:
				item_difficulty_label.text = "Hard"
			2:
				item_difficulty_label.text = "Final"

@onready var item_name_label = %ItemNameLabel
@onready var item_difficulty_label = %ItemDifficultyLabel

func _ready():
	item_name_label.text = item.name
	match item.difficulty:
		0:
			item_difficulty_label.text = "Easy"
		1:
			item_difficulty_label.text = "Hard"
		2:
			item_difficulty_label.text = "Final"

func focus():
	%ItemDetails.grab_focus()

func _on_item_details_clicked():
	clicked.emit()


func _on_item_details_focus_entered():
	button_focused.emit()


func _on_item_details_focus_exited():
	button_unfocused.emit()
