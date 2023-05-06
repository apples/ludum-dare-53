extends RigidBody2D

var _textures = [
	preload("res://objects/trash/large_trash2/strut_junk.png")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = _textures.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
