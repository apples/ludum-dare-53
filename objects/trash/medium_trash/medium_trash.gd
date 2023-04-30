extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	match (rng.randi_range(0, 5)):
		0:
			$Sprite2D.texture = load("res://objects/trash/medium_trash/medjunk1.png")
		1:
			$Sprite2D.texture = load("res://objects/trash/medium_trash/medjunk3.png")
		2:
			$Sprite2D.texture = load("res://objects/trash/medium_trash/medrock1.png")
		3:
			$Sprite2D.texture = load("res://objects/trash/medium_trash/medrock2.png")
		4:
			$Sprite2D.texture = load("res://objects/trash/medium_trash/missing_medjunk.png")
		5:
			$Sprite2D.texture = load("res://objects/trash/medium_trash/tempTrash.png")
#		6:
#			$Sprite2D.texture = load("res://objects/trash/medium_trash/longstrutjunk.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
