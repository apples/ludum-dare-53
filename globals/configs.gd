extends Node
var username = null
var user_key = null

const filename = "user://ld53.cfg"

func save():
	var config_file = ConfigFile.new()
	config_file.set_value("player", "username", username)
	config_file.set_value("player", "user_key", user_key)
	config_file.save(filename)
	
func load():
	var config_file = ConfigFile.new()
	config_file.load(filename)
	if config_file.has_section("player"):
		username = config_file.get_value("player", "username")
		user_key = config_file.get_value("player", "user_key")
