@tool
@icon("../life/icon_resource.png")
extends Resource
class_name ResourceLife


signal life_changed
signal damaged
signal healed
signal revived
signal killed

@export var max_life:= 10.0:
	set(v):
		max_life = v
		life = min(v,max_life)

@export var life:= max_life:
	set(v):
		life = clamp(v,0,max_life)
		life_changed.emit()
@export var can_be_damaged_with_no_life := false


func heal(heal_value = -1):
	if life == max_life:
		return
	if heal_value == -1:
		life = max_life
	else:
		life += max_life
	healed.emit()


func damage(damage_value = -1):
	if !is_alive() and !can_be_damaged_with_no_life:
		return
	if damage_value == -1:
		kill()
	else:
		life -= damage_value
	if life <= 0:
		killed.emit()
	damaged.emit()


func revive(heal_value = -1):
	if is_alive():
		return
	heal(heal_value)
	revived.emit()


func kill():
	if !is_alive():
		return
	life = 0
	killed.emit()


func is_alive():
	return life > 0
