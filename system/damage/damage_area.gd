@icon("../damage/icon_damage_area.png")
extends Area2D
class_name DamageArea


const HITBOX_MASK = 3

@export var damage:ResourceDamage
@export var team:ResourceDamageTeam


func _ready() -> void:
	area_entered.connect(on_area_entered)
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(HITBOX_MASK,true)
	monitorable = false


func on_area_entered(area):
	area.take_damage(damage,global_position)
