extends Label

@export var state_prop_name: StringName

# Called when the node enters the scene tree for the first time.
func _ready():
#	if not GameplaySingleton.current:
#		return
	text = str(SaveGame.current.inventory.thrusters)
#	SaveGame.current.changed.connect(_on_state_prop_change)
#	GameplaySingleton.current.changed.connect(_on_state_prop_change)
#	text = str(GameplaySingleton.current.get(state_prop_name))

func _process(_delta):
	if text.to_float() != SaveGame.current.inventory.thrusters:
		text = str(SaveGame.current.inventory.thrusters)

