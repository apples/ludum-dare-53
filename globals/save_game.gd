extends Node

const filename = "user://ld53_save.json"

var current: Dictionary

var _default_values := {
	current_cycle = 1,
	money = 0,
	inventory = {
		thrusters = 0,
	},
	deployed_structures = [],
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
	
	if not "inventory" in current or current.inventory == null:
		current.inventory = _default_values.inventory.duplicate(true)
	if "deployed_structures" not in current or current.deployed_structures == null:
		current.deployed_structures = _default_values.deployed_structures.duplicate(true)
	
	print("Loaded save game: ", current)


