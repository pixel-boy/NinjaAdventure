@icon("../stat/life/icon_life_bar.png")
extends TextureProgressBar


@export var resource_life:ResourceLife:
	set(v):
		resource_life = v
		if !resource_life:
			return
		max_value = resource_life.max_life
		if !resource_life.life_changed.is_connected(update_life):
			resource_life.life_changed.connect(update_life)
		update_life()


func update_life():
	value = resource_life.life
