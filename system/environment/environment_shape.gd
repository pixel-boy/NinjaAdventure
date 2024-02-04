@tool
@icon("../environment/icon_environment_shape.png")
extends CollisionShape2D
class_name EnvironmentShape


var label_debug:Label

@export var resource_environment:ResourceEnvironment:
	set(v):
		resource_environment = v
		if Engine.is_editor_hint():
			resource_environment.changed.connect(update_debug_info)
			update_debug_info()


func update_debug_info():
	if resource_environment:
		if !label_debug:
			label_debug = Label.new()
			add_child(label_debug)
			label_debug.z_index = 10
			label_debug.set("theme_override_font_sizes/font_size",8)
		var shape_rect = shape.get_rect()
		label_debug.size = shape_rect.size
		label_debug.position = shape_rect.position
		label_debug.text = resource_environment.get_debug_info()
