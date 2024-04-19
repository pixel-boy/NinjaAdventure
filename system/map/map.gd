@icon("../map/icon_map.png")
extends Node2D
class_name Map

@onready var screen_grid_ref: TextureRect = $ScreenGridRef
@onready var environment_area: EnvironmentArea = %EnvironmentArea


func _ready() -> void:
	screen_grid_ref.visible = false
