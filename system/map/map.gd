@icon("../map/icon_map.png")
extends TileMap
class_name Map


@onready var environment_area: EnvironmentArea = %EnvironmentArea
@onready var spawn_point: SpawnPoint = %SpawnPoint


func get_spawn_pos():
	return spawn_point.global_position
