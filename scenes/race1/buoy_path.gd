extends Path2D

@export var buoy_spacing = 50

const buoy_scene = preload("res://objects/buoy/buoy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var length = curve.get_baked_length()
	
	for i in range(0, length, buoy_spacing):
		var curve_sample = curve.sample_baked_with_rotation(i)
		
		var buoy = buoy_scene.instantiate()
		buoy.transform = curve_sample.rotated_local(PI / 2)
		
		var buoy_anchor = buoy.find_child("Anchor")
		buoy_anchor.anchor_position = buoy.transform.get_origin()
		buoy_anchor.anchor_angle = buoy.transform.get_rotation()
		
		add_child(buoy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
