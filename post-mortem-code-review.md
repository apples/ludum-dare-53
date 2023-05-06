# Post-mortem Code Review

This review was made after submitting the final jam version of the game (0.2.7).

# 1. Excessive use of `load()`

Using `load()` instead of `preload()` causes resources to be loaded when the `load()` expression is executed.
This can result in hiccups and stutters while the game is running.
Resources are cached for subsequent loads, but when a resource's refcount drops to zero, it is immediately freed.

By using `preload()` instead, the resource is loaded with the scene as a whole.

Our code had excessive uses of `load()` in situations where `preload()` makes more sense.

## `res://objects/trash/small_trash/trash.gd` 12-30

```gdscript
	match (rng.randi_range(0, 7)):
		0:
			$Sprite2D.texture = load("res://objects/trash/small_trash/Aicore_junk.png")
		1:
			$Sprite2D.texture = load("res://objects/trash/small_trash/Broken_ship_junk.png")
		2:
			$Sprite2D.texture = load("res://objects/trash/small_trash/cone_junk.png")
		3:
			$Sprite2D.texture = load("res://objects/trash/small_trash/hal_junk.png")
		4:
			$Sprite2D.texture = load("res://objects/trash/small_trash/Plantetoid_junk.png")
		5:
			$Sprite2D.texture = load("res://objects/trash/small_trash/Ship_piece_junk.png")
#		6:
#			$Sprite2D.texture = load("res://objects/trash/small_trash/strut_junk.png")
		6:
			$Sprite2D.texture = load("res://objects/trash/small_trash/Strut2_junk.png")
		7:
			$Sprite2D.texture = load("res://objects/trash/small_trash/strut3_junk.png")
```

Lack of array aside, this code `load()`s a resource each time an object is instantiated.
Resource caching helps with this, but it's still more work to be done on the first frame when the scene is loaded.

Switching to an array also allows for the use of the `Array` type's `.pick_random()` method.
Using this method avoids having to figure out the `randi_range()` parameters.

Suggested replacement:

```gdscript
# Class scope

var _textures: Array[Texture2D] = [
	preload("res://objects/trash/small_trash/Aicore_junk.png"),
	preload("res://objects/trash/small_trash/Broken_ship_junk.png"),
	preload("res://objects/trash/small_trash/cone_junk.png"),
	preload("res://objects/trash/small_trash/hal_junk.png"),
	preload("res://objects/trash/small_trash/Plantetoid_junk.png"),
	preload("res://objects/trash/small_trash/Ship_piece_junk.png"),
	preload("res://objects/trash/small_trash/Strut2_junk.png"),
	preload("res://objects/trash/small_trash/strut3_junk.png"),
]


$Sprite2D.texture = _textures.pick_random()
```

The following files also have the same problematic pattern:

- `res://objects/trash/medium_trash/medium_trash.gd` 7-19
- `res://objects/trash/large_trash/large_trash.gd` 7-9
- `res://objects/trash/large_trash2/large_trash2.gd` 7-9

## `res://objects/hazards/mine/mine.gd` 18

```gdscript
		$AnimatedSprite2D.sprite_frames = load("res://objects/hazards/mine/exploding.tres")
```

Pretty simple and obvious replacement here, just add the `pre`.

```gdscript
		$AnimatedSprite2D.sprite_frames = preload("res://objects/hazards/mine/exploding.tres")
```

## `res://scenes/gameplay/gameplay.gd` 30-31, 211-212

```gdscript
	for k in Deployables.infos:
		_preloaded_scenes.append(load(Deployables.infos[k].scene))
```

```gdscript
	var info = Deployables.infos[interaction.key]
	var node = load(info.scene).instantiate()
```

This code attempts to simulate preloading for the deployables scenes.
This honestly doesn't accomplish much.

The reason that the `Deployables` node needs to store the resource paths instead of preloading the resources itself,
is because it's an autoload global.
Preloading the resources would mean that they're loaded at program launch, which would also be bad.

A much better solution would be to use a custom resource type which stores direct references to the resources,
and then have the gameplay script preload that new resource.

Here's what the structure of the `Deployables` script looks like:

```gdscript
var infos = {
	"repair_station": {
		name = "Repair Station",
		scene = "res://objects/deployables/repair_station/repair_station.tscn",
		# directed = false,
	},
	# ...
```

So we can convert this into a pair of resource types:

```gdscript
class_name DeployableStructure extends Resource

@export var key: StringName
@export var name: String
@export var scene: PackedScene
@export var directed: bool = false
```

```gdscript
class_name DeployableStructureList extends Resource

@export var structures: Array[DeployableStructure] = []

var _cache: Dictionary
func get_by_key(key: StringName) -> DeployableStructure:
	if _cache:
		return _cache[key]
	for s in structures:
		_cache[s.key] = s
	return _cache[key]
```

And then, after creating a resource of this type, we can preload it in the gameplay script:

```diff
diff --git a/scenes/gameplay/gameplay.gd b/scenes/gameplay/gameplay.gd
index 6ece23a..e754175 100644
--- a/scenes/gameplay/gameplay.gd
+++ b/scenes/gameplay/gameplay.gd
@@ -6,6 +6,8 @@ var start_impulse = 350
 
 var package_scene = preload("res://objects/package/package.tscn")
 
+var deployable_list = preload("res://assets/deployables_list.tres")
+
 var _total_package_health = 1
 
 @onready var player_ship = %PlayerShip
@@ -26,10 +28,6 @@ func _ready():
 		load_mission({ difficulty = 0 })
 	Bgmusic.PlayGameplayMusic()
 	
-	# preload
-	for k in Deployables.infos:
-		_preloaded_scenes.append(load(Deployables.infos[k].scene))
-	
 	$DockingArrowAnim.play("default")
 	
 	for i in SaveGame.current.deployed_structures:
@@ -178,7 +176,7 @@ func _on_ui_deploy_item(key):
 	
 	var pos = player_ship.global_position
 	
-	var info = Deployables.infos[key]
+	var info = deployable_list.get_by_key(key)
 	
 	if "directed" in info and info.directed:
 		pos += Vector2.RIGHT.rotated(player_ship.rotation) * 16
@@ -208,8 +206,8 @@ var structure_label_scene = preload("res://scenes/gameplay/structure_label.tscn"
 func _spawn_deployable(interaction, whom = null):
 	assert(interaction.type == "structure")
 	
-	var info = Deployables.infos[interaction.key]
-	var node = load(info.scene).instantiate()
+	var info = deployable_list.get_by_key(interaction.key)
+	var node = info.scene.instantiate()
 	node.global_position = Vector2(interaction.position.x, interaction.position.y)
 	node.rotation = interaction.rotation
 	node.gameplay_root = self
```

