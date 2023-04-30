extends Label

@export var state_prop_name: StringName

# Called when the node enters the scene tree for the first time.
func _ready():
	if not GameplaySingleton.current:
		return
	GameplaySingleton.current.changed.connect(_on_state_prop_change)
	text = str(GameplaySingleton.current.get(state_prop_name))

func _on_state_prop_change(prop_name: StringName, value):
	if prop_name != state_prop_name:
		return
	
	text = str(value)
