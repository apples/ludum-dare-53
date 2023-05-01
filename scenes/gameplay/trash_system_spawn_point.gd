extends CollisionShape2D

@export_range(0, 1) var chance: float = 1
@export var kind: Kind = Kind.SMALL_TRASH
@export var arc_stride: float = 16
@export var radius_stride: float = 4
@export var min_difficulty: int = 0
@export var gas_rate: float = 1.0

enum Kind {
	SMALL_TRASH,
	ROCKS,
	GAS,
	MINES,
}
