extends RigidBody2D


var _textures: Array[Texture2D] = [
	preload("res://objects/trash/medium_trash/medjunk1.png"),
	preload("res://objects/trash/medium_trash/medjunk3.png"),
	preload("res://objects/trash/medium_trash/medrock1.png"),
	preload("res://objects/trash/medium_trash/medrock2.png"),
	preload("res://objects/trash/medium_trash/missing_medjunk.png"),
	preload("res://objects/trash/medium_trash/tempTrash.png"),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = _textures.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
