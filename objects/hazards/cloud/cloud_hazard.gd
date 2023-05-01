extends Area2D

@export var damage_time: float = .5
@export var rotation_speed:float = 50

var linear_velocity: Vector2
var _influenced_objects: Array[RigidBody2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	rotation_speed = rng.randf_range(25, 50)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += linear_velocity * delta
	rotation_degrees += rotation_speed * delta
	for obj in _influenced_objects:
		obj.gas_accumulation += delta
		if obj.gas_accumulation > damage_time:
			obj.health -= 1
			obj.gas_accumulation = 0


func _on_body_entered(body):
	if body.is_in_group("player_ship") || body.is_in_group("package"):
		_influenced_objects.push_back(body)

func _on_body_exited(body):
	if body.is_in_group("player_ship") || body.is_in_group("package"):
		var index = self._influenced_objects.find(body)
		if index != -1:
			self._influenced_objects.pop_at(index)
