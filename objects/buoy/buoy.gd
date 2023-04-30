extends RigidBody2D
var stationary_pos_x = 0
var stationary_pos_y = 0
var stationary_angle = 0
var spring_factor = 10
var angular_spring_factor = 250
var damping_factor = 25
var tangent_damping_factor = 0.5
var tape_thickness: float = 8

var tape_neighbor: Node2D = null:
	get:
		return tape_neighbor
	set(value):
		tape_neighbor = value
		if tape_neighbor.is_inside_tree() and self.is_inside_tree():
			_reconcile_tape()

@onready var tape_sprite = $TapeSprite

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var blink_sprite = $BlinkSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	stationary_pos_x = self.position.x
	stationary_pos_y = self.position.y
	
	if tape_neighbor:
		_reconcile_tape()
		tape_sprite.visible = true

func _process(delta):
	if tape_neighbor:
		tape_sprite.visible = true
		tape_sprite.global_rotation = global_position.angle_to_point(tape_neighbor.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	apply_linear_spring()
	apply_angular_spring()
	
	if tape_neighbor:
		_reconcile_tape()

func apply_angular_spring():
	var current_angle = self.rotation
#	var direction = sign(current_angle - stationary_angle)
	if current_angle != stationary_angle:
		var result = -(current_angle - stationary_angle) * angular_spring_factor # - angular_velocity * direction * damping_factor 
		apply_torque(result)

func apply_linear_spring():
	var current_pos = Vector2(self.position.x, self.position.y)
	var stationary_pos = Vector2(stationary_pos_x, stationary_pos_y)
	if current_pos != stationary_pos:
		var direction = current_pos.direction_to(stationary_pos)
		var spring_force = (stationary_pos - current_pos) * spring_factor
		var damping_force = -linear_velocity.project(direction) * damping_factor
		var tangent = direction.orthogonal()
		var tangent_velocity = linear_velocity.project(tangent)
		var tangent_force = -tangent_velocity * tangent_damping_factor
		var result = spring_force + damping_force + tangent_force
		apply_force(result)


func _reconcile_tape():
	var dist = global_position.distance_to(tape_neighbor.global_position)
	tape_sprite.scale.x = 1
	tape_sprite.region_rect = Rect2(0, 0, dist, 8)
	tape_sprite.offset.x = dist/2


func _on_animated_sprite_2d_frame_changed():
	match animated_sprite_2d.frame:
		6:
			blink_sprite.visible = true
			blink_sprite.position.y = -7
		7:
			blink_sprite.visible = true
			blink_sprite.position.y = 7
		_:
			blink_sprite.visible = false
