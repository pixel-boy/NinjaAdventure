@icon("../behavior/icon_area_target_finder.png")
extends Area2D


var parent

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	parent = get_parent() 
	process_mode = Node.PROCESS_MODE_ALWAYS


func on_body_entered(body):
	parent.target = body


func on_body_exited(body):
	if parent.target == body:
		parent.target = null
