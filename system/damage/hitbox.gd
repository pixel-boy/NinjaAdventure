@icon("../damage/icon_hitbox.png")
@tool
extends Area2D
class_name Hitbox


signal damage_received(damage,at_pos)

const HITBOX_LAYER = 3

@export var team:ResourceDamageTeam


func take_damage(damage:ResourceDamage,at_pos):
	if !damage:
		return
	damage_received.emit(damage,at_pos)


func _ready() -> void:
	collision_mask = 0
	collision_layer = 0
	set_collision_layer_value(HITBOX_LAYER,true)
	monitoring = false


func disable():
	monitorable = false
