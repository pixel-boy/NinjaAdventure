@tool
@icon("../spawn/spawn.png")
extends Node2D
class_name SpawnPoint


func _draw():
	if Engine.is_editor_hint():
		var texture = preload("../spawn/spawn.png") 
		draw_texture(texture,-texture.get_size()/2)
