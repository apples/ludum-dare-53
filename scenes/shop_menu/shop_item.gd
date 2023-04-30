extends Control

signal clicked()
signal button_focused()

@onready var item_name_label = %ItemNameLabel
@onready var item_cost_label = %ItemCostLabel
@onready var owned_count_label = %OwnedCountLabel

var item = { name = "", cost = 0 }:
	get:
		return item
	set(value):
		item = value
		item_name_label.text = item.name
		item_cost_label.text = "$%s" % item.cost

var owned = 0:
	get:
		return owned
	set(value):
		owned = value
		owned_count_label.text = str(owned)

func _ready():
	item_name_label.text = item.name
	item_cost_label.text = "$%s" % item.cost
	owned_count_label.text = str(owned)

func focus():
	%ItemDetails.grab_focus()

func _on_item_details_clicked():
	clicked.emit()


func _on_item_details_focus_entered():
	button_focused.emit()
