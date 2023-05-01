extends Camera2D

@export var follow_target: Node2D
@export var center_offset: float = 0
@export var stabilization_window: float = 0

enum {
	FACING_LEFT,
	FACING_RIGHT,
}

var current_facing = FACING_LEFT
var target_prev_position: Vector2

var _zoom_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	if not follow_target:
		push_error("No follow target for follow_camera")
		return
	
	target_prev_position = follow_target.global_position


func map_zoom(z: float):
	if _zoom_tween:
		_zoom_tween.kill
	_zoom_tween = create_tween()
	_zoom_tween.tween_property(self, "zoom", Vector2(z,z), 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not follow_target:
		return
	
	# stabiliazation
	
	match current_facing:
		FACING_LEFT:
			if follow_target.global_position.x > global_position.x + center_offset + stabilization_window:
				current_facing = FACING_RIGHT
		FACING_RIGHT:
			if follow_target.global_position.x < global_position.x - center_offset - stabilization_window:
				current_facing = FACING_LEFT
	
	# follow
	
	match current_facing:
		FACING_LEFT:
			if follow_target.global_position.x < global_position.x + center_offset:
				global_position.x = follow_target.global_position.x - center_offset
		FACING_RIGHT:
			if follow_target.global_position.x > global_position.x - center_offset:
				global_position.x = follow_target.global_position.x + center_offset
	
	global_position.y = follow_target.global_position.y
	
