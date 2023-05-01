extends Area2D

@export var damage_time: float = .5

var _influenced_objects: Array[RigidBody2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for obj in _influenced_objects:
		obj.gas_accumulation += delta
		if obj.gas_accumulation > damage_time:
			obj.health -= 1
			obj.gas_accumulation = 0


func _on_body_entered(body):
	if body.is_in_group("player_ship"):
		_influenced_objects.push_back(body)

func _on_body_exited(body):
	if body.is_in_group("player_ship"):
		var index = self._influenced_objects.find(body)
		if index != -1:
			self._influenced_objects.pop_at(index)
