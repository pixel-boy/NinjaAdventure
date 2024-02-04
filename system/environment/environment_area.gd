@icon("../environment/icon_environment_area.png")
extends Area2D
class_name EnvironmentArea


const PLAYER_MASK = 5

signal environment_changed(environment)


func _ready() -> void:
	body_shape_entered.connect(on_player_enter_environment_shape)
	collision_layer = 0
	collision_mask = 0
	monitorable = false
	set_collision_mask_value(PLAYER_MASK,true)


func on_player_enter_environment_shape(body_rid, body, body_shape_index,local_shape_index):
	var shape = get_child(local_shape_index)
	if shape is EnvironmentShape:
		environment_changed.emit(shape.resource_environment)
