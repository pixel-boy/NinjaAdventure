@tool
@icon("../camera/icon_camera_grid.png")
extends Camera2D
class_name CameraGrid


signal cell_changed
signal animation_finished

@export var grid_size := Vector2(320,176)
@export var current_cell = Vector2.ZERO:
	set(v):
		if current_cell == v:
			return
		current_cell = v
		cell_changed.emit()
		if Engine.is_editor_hint():
			snap_to_grid()
@export_group("animation")
@export var animation_trans:Tween.TransitionType = Tween.TRANS_SINE
@export var animation_ease:Tween.EaseType = Tween.EASE_IN_OUT
@export var transition_time:= 0.8

var tween:Tween
var target:Node2D:
	set(v):
		target = v
		set_process(target != null)


func _ready() -> void:
	add_to_group("camera")
	current_cell = world_to_grid(global_position)
	set_process(false)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if !target:
		set_process(false)
	go_to_world_position(target.global_position)


func get_world_position()->Vector2:
	return current_cell*grid_size


func go_to_world_position(pos:Vector2):
	var pos_target := pos
	var cell_target := world_to_grid(pos_target)
	if cell_target != current_cell:
		go_to_cell(cell_target)


func go_to_cell(cell_target:Vector2):
	current_cell = cell_target
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self,"position",grid_to_world(current_cell),transition_time).set_trans(animation_trans).set_ease(animation_ease)
	await tween.finished
	animation_finished.emit()


func set_world_position(world_pos:Vector2):
	current_cell = world_to_grid(world_pos)
	center_to_cell()


func teleport_to(target_position:Vector2):
	if tween:
		tween.kill()
	global_position = target_position


func world_to_grid(pos:Vector2) -> Vector2:
	return ((pos-offset)/grid_size).round()


func grid_to_world(pos:Vector2) -> Vector2:
	return (pos*grid_size)


func center_to_cell():
	global_position = grid_to_world(current_cell)


func _notification(what):
	if Engine.is_editor_hint():
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			return
		match what:
			NOTIFICATION_TRANSFORM_CHANGED:
				current_cell = world_to_grid(global_position)
				snap_to_grid()


func snap_to_grid():
	set_world_position(current_cell * grid_size)
