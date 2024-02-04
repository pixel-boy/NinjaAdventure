@tool
extends TextureRect


@export var active := false:
	set(v):
		active = v
		if !is_inside_tree():
			await ready
		if tween:
			tween.kill()
		tween = create_tween()
		if active:
			tween.tween_property(material,"shader_parameter/alpha",1,2)
		else:
			tween.tween_property(material,"shader_parameter/alpha",0,2)

var tween:Tween
