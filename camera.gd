extends Camera2D
class_name Camera


signal screen_changed

const RESOLUTION = Vector2(320,176)
const CAM_OFFET = Vector2(RESOLUTION.x,RESOLUTION.y+32)/2

@export var target:Node

var screen_pos = Vector2.ZERO:
	set(v):
		if screen_pos == v:
			return
		screen_pos = v
		update_position()
		screen_changed.emit()


func _init() -> void:
	add_to_group("camera")


func _ready():
	center()
	update_screen_pos()
	update_position()


func update_position():
	var pos_target = (screen_pos*RESOLUTION)
	var tween = create_tween()
	tween.tween_property(self,"position",pos_target+CAM_OFFET,0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _process(delta):
	update_screen_pos()


func update_screen_pos():
	if !target:
			return
	screen_pos = (((target.global_position+Vector2(CAM_OFFET.x,-CAM_OFFET.y)-Vector2(24,0))/RESOLUTION).floor())


func center():
	update_screen_pos()
	var pos_target = (screen_pos*RESOLUTION)
	position = pos_target+CAM_OFFET
