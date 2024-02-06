@icon("../behavior/icon_behavior_path_follow.png")
@tool
extends Node2D
class_name BehaviorFollowPath


signal end_reached
signal point_reached
signal wait_started
signal wait_finished

enum WaitMode{AT_END,EACH_POINT,RANDOMLY,NEVER}

@export var active:=true:
	set(v):
		active = v
		if Engine.is_editor_hint():
			return
		if !active:
			parent.move_vector = Vector2.ZERO
		update_process()
@export var path:Path2D:
	set(v):
		path = v
		if !path:
			return
		curve = path.curve
		point_count = path.curve.point_count
		point_id = get_closest_point()
		if is_point_reached():
			next_point()
@export var precision := 5
@export var loop := false
@export var wait_mode :WaitMode = WaitMode.AT_END:
	set(v):
		wait_mode = v
		notify_property_list_changed()

var wait_time := 1.0
var wait_chance := 50

var point_id := 0:
	set(v):
		point_id = v
		update_target_pos()
var direction := 1
var parent:Node2D
var point_count:= 0
var target_pos:Vector2
var wait_timer:Timer
var curve:Curve2D


func _get_property_list()->Array:
	var properties = []
	# WAIT TIME
	var wait_time_usage = PROPERTY_USAGE_NO_EDITOR
	if wait_mode != WaitMode.NEVER:
		wait_time_usage = PROPERTY_USAGE_DEFAULT
	properties.append({
		"name": "wait_time",
		"type": TYPE_FLOAT,
		"usage": wait_time_usage,
	})
	# WAIT CHANCE
	var wait_chance_usage = PROPERTY_USAGE_NO_EDITOR
	if wait_mode == WaitMode.RANDOMLY:
		wait_chance_usage = PROPERTY_USAGE_DEFAULT
	properties.append({
		"name": "wait_chance",
		"type": TYPE_INT,
		"usage": wait_chance_usage,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,100,suffix:%"
	})
	return properties


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	parent = get_parent()
	update_process()
	update_target_pos()
	wait_timer = Timer.new()
	add_child(wait_timer)
	wait_timer.one_shot = true
	if wait_time:
		wait_timer.wait_time = wait_time


func update_process():
	if path != null and active:
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		process_mode = Node.PROCESS_MODE_DISABLED


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if path:
		if !is_point_reached():
			parent.move_vector = global_position.direction_to(target_pos)
		else:
			point_reached.emit()
			if is_at_end():
				end_reached.emit()
			next_point()


func next_point():
	if wait_time > 0:
		match wait_mode:
			WaitMode.AT_END:
				if is_at_end():
					await wait(wait_time)
			WaitMode.EACH_POINT:
				await wait(wait_time)
			WaitMode.RANDOMLY:
				if randi_range(0,100) < wait_chance:
					await wait(wait_time)
	if loop:
		point_id = wrap(point_id+1,0,point_count)
	else:
		if is_at_end():
			change_direction()
		point_id = point_id+direction


func wait(time := 1.0):
	parent.move_vector = Vector2.ZERO
	wait_timer.start(time)
	wait_started.emit()
	set_process(false)
	await wait_timer.timeout
	wait_finished.emit()
	set_process(true)


func is_at_end():
	return point_id == point_count -1 or point_id == 0


func change_direction():
	if point_id == 0:
		direction = 1
	else:
		direction = -1


func update_target_pos():
	if !path:
		return
	var point_position = curve.get_point_position(point_id)
	target_pos = point_position+path.position


func get_closest_point()->int:
	var parent_pos = global_position-path.position
	var max_dist = INF
	var final_point := 0
	for point in curve.point_count:
		var point_pos =  curve.get_point_position(point)
		var dist = sqrt(parent_pos.distance_squared_to(point_pos))
		if dist < max_dist:
			max_dist = dist
			final_point = point
	return final_point


func distance_to_target()->float:
	return sqrt(global_position.distance_squared_to(target_pos))


func is_point_reached()->bool:
	return distance_to_target() < precision
