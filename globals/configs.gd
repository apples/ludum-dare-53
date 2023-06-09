extends Node
var offline_mode = false
var username = null
var user_key = null

#const filename = "user://ld53.cfg"
const filename = "user://ld53_config.json"

func _ready():
	self.load()

func save():
	var config_file = FileAccess.open(filename, FileAccess.WRITE)
	var data = JSON.stringify({
		offline_mode = offline_mode,
		username = username,
		user_key = user_key,
	})
	print("Saving configs: ", data)
	config_file.store_string(data)
	config_file.close()
	print("Saved config")
	
func load():
	if FileAccess.file_exists(filename):
		var config_file = FileAccess.open(filename, FileAccess.READ)
		var cfg = JSON.parse_string(config_file.get_as_text())
		if "offline_mode" in cfg:
			offline_mode = cfg.offline_mode
		username = cfg.username
		user_key = cfg.user_key
		print("Loaded config: ", cfg)
		print(username, ":", user_key)
	else:
		print("No existing config")
