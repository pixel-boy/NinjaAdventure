@icon("../color_correction/icon.png")
extends ColorRect


const NEUTRAL_GRADIENT = preload("../color_correction/gradient_neutral.tres")

@export var gradient:GradientTexture1D:
	set(v):
		if !v:
			v = NEUTRAL_GRADIENT
		gradient = v
		if !is_inside_tree():
			await ready
		var tween := create_tween()
		material.set_shader_parameter("old_gradient",material.get_shader_parameter("gradient"))
		material.set_shader_parameter("gradient",gradient)
		material.set_shader_parameter("amount",0.0)
		tween.tween_property(material,"shader_parameter/amount",1.0,1)


func _ready() -> void:
	material = preload("../color_correction/material.tres")
	gradient = gradient
