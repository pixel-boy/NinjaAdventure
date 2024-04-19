@icon("../behavior/icon_behavior_follow.png")
extends Node2D
class_name BehaviorFollow


## A behavior node which can be add to a character so that it follows 
## a target, with minimum and maximum distance parameters.


@export var active := true:
	set(v):
		active = v
		if Engine.is_editor_hint():
			return
		update_process()
@export var target:Node2D:
	set(v):
		target = v
		if !target:
			target_pos = start_pos
		target.teleported.connect(on_target_teleported)
		update_process()
@export var min_dist := 8
@export var max_dist := 24

var start_pos := Vector2.ZERO
var parent:Node2D
var target_pos


func _ready() -> void:
	parent = get_parent()
	update_process()
	start_pos = global_position


func on_target_teleported():
	parent.global_position = target.global_position
	parent.teleported.emit()


func _process(delta: float) -> void:
	if target:
		go_to_pos(target.global_position)
	elif target_pos:
		go_to_pos(target_pos)
	else:
		update_process()


func go_to_pos(pos):
	var dist = sqrt(global_position.distance_squared_to(pos))
	if dist > max_dist:
		parent.move_vector = global_position.direction_to(pos)
	elif dist < min_dist:
		parent.move_vector = -global_position.direction_to(pos)
	else:
		target_pos = null
		parent.move_vector = Vector2.ZERO


func update_process():
	if active and (target != null or target_pos != null):
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		parent.move_vector = Vector2.ZERO
		process_mode = Node.PROCESS_MODE_DISABLED
