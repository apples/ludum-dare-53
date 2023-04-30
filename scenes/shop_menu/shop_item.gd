extends Control

signal clicked()

func focus():
	%ItemDetails.grab_focus()

func _on_item_details_clicked():
	clicked.emit()
