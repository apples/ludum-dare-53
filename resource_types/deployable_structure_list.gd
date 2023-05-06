class_name DeployableStructureList extends Resource

@export var structures: Array[DeployableStructure] = []

var _cache: Dictionary
func get_by_key(key: StringName) -> DeployableStructure:
	if _cache == {}:
		for s in structures:
			_cache[s.key] = s
	return _cache[key]
