extends CollisionShape2D

@export_range(0, 1) var chance: float = 1
@export var kind: Kind = Kind.SMALL_TRASH
@export var arc_stride: float = 16
@export var radius_stride: float = 4

enum Kind {
	SMALL_TRASH,
	ROCKS,
	GAS,
}
