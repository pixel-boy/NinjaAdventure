@icon("../stat/icon.png")
extends Resource
class_name ResourceStat


@export var life:ResourceLife:
	set(v):
		life = v


func make_unique()->ResourceStat:
	life = life.duplicate(true)
	return duplicate(true)
