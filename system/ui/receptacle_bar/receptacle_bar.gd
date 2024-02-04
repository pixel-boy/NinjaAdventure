@icon("../ui/icon_receptacle_bar.png")
@tool
extends Control


@export var max_life := 10:
	set(v):
		max_life = v
		life = min(life,max_life)
		queue_redraw()
@export var life := 10:
	set(v):
		life = clamp(v,0,max_life)
		queue_redraw()
@export var texture:Texture2D:
	set(v):
		texture = v
		queue_redraw()
@export var receptacle_size := 4:
	set(v):
		receptacle_size = max(v,1)
		queue_redraw()

@export var sprite_size := Vector2(16,16):
	set(v):
		sprite_size = v
		queue_redraw()


func _draw() -> void:
	var rect_sprite := Rect2(Vector2.ZERO,sprite_size)
	var rect_draw := Rect2(Vector2.ZERO,sprite_size)
	var life_left := life
	for i in get_receptacle_count():
		var receptable_life = min(max(0,life_left),receptacle_size)
		rect_sprite.position.x = receptable_life*sprite_size.x
		draw_texture_rect_region(texture,rect_draw,rect_sprite)
		rect_draw.position.x += sprite_size.x
		if life_left > 0:
			life_left -= receptacle_size
	custom_minimum_size = Vector2(sprite_size.x*get_receptacle_count(),sprite_size.y)


func get_receptacle_count():
	return ceil(max_life/float(receptacle_size))


func get_not_empty_receptacle_count():
	return ceil(life/float(receptacle_size))
