extends Node2D


var text = "":
	get:
		return text
	set(value):
		text = value
		%Label.text = text



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_rotation = 0
