@icon("../weapon/icon.png")
@tool
extends CharacterBody2D
class_name Weapon


enum State {BACK,ATTACK,PROJECTED,ON_FLOOR}


@export var resource_weapon:ResourceWeapon:
	set(v):
		resource_weapon = v

		if !is_inside_tree():
			await ready
		if !resource_weapon:
			sprite.texture = null
			return
		sprite.texture = resource_weapon.sprite_in_hand
		update_weapon()

var direction:= Vector2.ZERO:
	set(v):
		direction = v
		update_weapon()

var state:State = State.BACK:
	set(v):
		state = v
		update_weapon()

@onready var sprite: Sprite2D = $Sprite


func update_weapon():
	if !resource_weapon:
		return
	match state:
		State.BACK:
			sprite.texture = resource_weapon.sprite_in_hand
			show_behind_parent = direction.y < 0
			sprite.position = Vector2(10,10)*direction
			sprite.rotation = direction.angle()-(PI/2)
		_:
			rotation = 0
			sprite.texture = resource_weapon.sprite
			sprite.offset = Vector2(-7,-5)*direction
			show_behind_parent = direction.y >= 0
