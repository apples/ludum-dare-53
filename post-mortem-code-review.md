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
