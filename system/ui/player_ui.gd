extends Control


@onready var receptacle_bar: Control = %ReceptacleBar


var resource_life:ResourceLife:
	set(v):
		resource_life = v
		receptacle_bar.max_life = resource_life.max_life
		resource_life.life_changed.connect(on_life_changed)


func on_life_changed():
	receptacle_bar.life = resource_life.life
