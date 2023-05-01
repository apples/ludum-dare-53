extends Node2D
var player_ship: RigidBody2D = null
var follow_distance = 50
var angle = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$OutOfBoundsBotAnim.play("default")
	$ZapAnim.play("default")
	$ZapAnim.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_ship:
		angle += delta * 2.5
		self.global_position = player_ship.global_position + (Vector2.RIGHT).rotated(angle) * follow_distance
		self.look_at(player_ship.global_position)


func _on_zap_attack_timer_timeout():
	$ZapAnim.visible = true
	$ZapAttackVisibleTimer.start()

func _on_zap_attack_visible_timer_timeout():
	$ZapAnim.visible = false
