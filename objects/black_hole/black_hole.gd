extends Area2D

var _influenced_objects: Array[RigidBody2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Called every physics frame. Use to apply physics forces, move things, etc.
func _physics_process(delta):
	for obj in self._influenced_objects:
		obj.apply_force((self.global_position - obj.global_position) * delta)

func _on_body_entered(body):
	if body is RigidBody2D:
		self._influenced_objects.push_back(body)


func _on_body_exited(body):
	var index = self._influenced_objects.find(body)
	if index != -1:
		self._influenced_objects.pop_at(index)
