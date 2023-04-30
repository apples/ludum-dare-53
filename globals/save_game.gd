extends Node

const filename = "user://ld53_save.json"

var current: Dictionary

var _default_values := {
	current_cycle = 1,
	money = 0,
	inventory = {
		thrusters = 0,
	},
}

func _ready():
	reload()

func save():
	var data = JSON.stringify(current)
	var file = FileAccess.open(filename, FileAccess.WRITE)
	file.store_string(data)
	file.close()
	print("Game saved")

func reload():
	var file = FileAccess.open(filename, FileAccess.READ)
	if not file:
		current = _default_values.duplicate(true)
		print("No save game found")
		return
	var data = file.get_as_text()
	current = JSON.parse_string(data)
	print("Loaded save game: ", current)


