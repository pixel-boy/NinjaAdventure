@icon("../map/icon_map.png")
extends TileMap
class_name Map


@onready var environment_area: EnvironmentArea = %EnvironmentArea
@onready var spawn_point: SpawnPoint = %SpawnPoint
@onready var screen_grid_ref: TextureRect = $ScreenGridRef


func _ready() -> void:
	screen_grid_ref.visible = false


func get_spawn_pos():
	return spawn_point.global_position
