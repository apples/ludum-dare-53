extends Node

@export var count: int = 5
@export var spacing: float = 200
@export var lane_height: float = 400

var buoy_scene = preload("res://objects/buoy/buoy.tscn")
var oob_bot_scene = preload("res://objects/oob_bot/oob_bot.tscn")
var oob_bot_active: Node2D = null

func _ready():
	var prev_up
	var prev_down
	for i in range(count):
		var buoy_up = buoy_scene.instantiate()
		buoy_up.position = Vector2(i * spacing, lane_height / 2)
		if prev_up:
			prev_up.tape_neighbor = buoy_up
		var buoy_down = buoy_scene.instantiate()
		buoy_down.position = Vector2(i * spacing, -lane_height / 2)
		buoy_down.rotation_degrees = 180
		if prev_down:
			prev_down.tape_neighbor = buoy_down
		add_child(buoy_up)
		add_child(buoy_down)
		prev_up = buoy_up
		prev_down = buoy_down

func _process(delta):
	if %PlayerShip.global_position.y > lane_height / 2 and oob_bot_active == null:
		oob_bot_active = generate_oob_bot()
	
	if %PlayerShip.global_position.y < -lane_height / 2 and oob_bot_active == null:
		oob_bot_active = generate_oob_bot()
#
	if %PlayerShip.global_position.y < lane_height / 2 and %PlayerShip.global_position.y > -lane_height / 2 and oob_bot_active != null:
		destroy_oob_bot()
#
	if %PlayerShip.global_position.y > -lane_height / 2 and %PlayerShip.global_position.y < lane_height / 2 and oob_bot_active != null:
		destroy_oob_bot()

func generate_oob_bot():
	var oob_bot = oob_bot_scene.instantiate()
	oob_bot.player_ship = %PlayerShip
	oob_bot.out_of_bounds_bot_zapped.connect(on_out_of_bounds_bot_zapped)
	self.call_deferred("add_child", oob_bot)
	return oob_bot

func destroy_oob_bot():
	if oob_bot_active != null:
		oob_bot_active.queue_free()
		oob_bot_active = null

func on_out_of_bounds_bot_zapped():
	%PlayerShip.health -= 1
