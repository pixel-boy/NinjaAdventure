@icon("../weapon/icon_weapon.png")
@tool
extends Node2D
class_name Weapon


enum State {BACK,ATTACK,PROJECTED,ON_FLOOR}


@export var resource_weapon:ResourceWeapon:
	set(v):
		resource_weapon = v
		if !is_inside_tree():
			await ready
		if !resource_weapon:
			sprite.texture = null
			damage_area.damage = null
			return
		sprite.texture = resource_weapon.sprite_in_hand
		damage_area.damage = resource_weapon.damage
		update_weapon()
@export var team:ResourceDamageTeam:
	set(v):
		team = v
		if !is_inside_tree():
			await ready
		damage_area.team = team

var direction:= Vector2.ZERO:
	set(v):
		direction = v
		update_weapon()

var state:State = State.BACK:
	set(v):
		state = v
		update_weapon()

@onready var sprite: Sprite2D = $Sprite
@onready var damage_area: DamageArea = $Sprite/DamageArea


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
			sprite.rotation = 0
			sprite.texture = resource_weapon.sprite
			sprite.offset = Vector2(-7,-5)*direction
			show_behind_parent = direction.y >= 0


func use_weapon():
	print("use_weapon")
