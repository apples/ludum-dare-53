extends Node
var username = null
var user_key = null

#const filename = "user://ld53.cfg"
const filename = "user://ld53_config.json"

func save():
	var config_file = FileAccess.open(filename, FileAccess.WRITE)
	config_file.store_string(JSON.stringify({ username = username, user_key = user_key }))
	config_file.close()
	print("Saved config")
	
func load():
	if FileAccess.file_exists(filename):
		var config_file = FileAccess.open(filename, FileAccess.READ)
		var cfg = JSON.parse_string(config_file.get_as_text())
		username = cfg.username
		user_key = cfg.user_key
		print("Loaded config: ", cfg)
		print(username, ":", user_key)
	else:
		print("No existing config")
