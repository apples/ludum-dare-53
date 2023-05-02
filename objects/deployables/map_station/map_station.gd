extends "res://objects/deployables/station.gd"


var active = false

var initial_ping_color = Color.WHITE
var final_ping_color = Color(0.5, 0.5, 1, 0)
var max_ping_radius: float = 32*3*2
var _ping_radius: float = 0

var ping_time = 2

var _tween

func _ready():
	$Timer.wait_time = ping_time

func _process(delta):
	if active:
		queue_redraw()

func _draw():
	super()
	
	if active:
		var c = lerp(initial_ping_color, final_ping_color, sqrt(_ping_radius / max_ping_radius))
		draw_arc(Vector2.ZERO, _ping_radius, 0, TAU, 16, c, 2)

func _on_body_entered(body):
	if body != player_ship:
		return
	
	active = true
	$Timer.start()
	_reset_ping()
	gameplay_root.follow_camera.map_zoom(.5)
	print("Entered map field")


func _on_body_exited(body):
	if body != player_ship:
		return
	
	active = false
	$Timer.stop()
	_tween.kill()
	_tween = null
	gameplay_root.follow_camera.map_zoom(1)
	queue_redraw()
	print("Exited map field")


func _on_timer_timeout():
	_reset_ping()

func _reset_ping():
	if _tween:
		_tween.kill()
	_ping_radius = 0
	_tween = create_tween()
	_tween.tween_property(self, "_ping_radius", max_ping_radius, ping_time)
	print("tweened")
	
