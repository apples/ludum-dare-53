extends Area2D

var _influenced_objects: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	self._influenced_objects.push_back(body)


func _on_body_exited(body):
	var index = self._influenced_objects.find(body)
	if index != -1:
		self._influenced_objects.pop_at(index)
