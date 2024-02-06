@icon("../character/icon_actor.png")
extends Node2D
class_name Actor


@export var stat:ResourceStat
@export var team:ResourceDamageTeam:
	set(v):
		team = v
		if !is_inside_tree():
			await ready
		weapon.team = team
		hitbox.team = team

@onready var sprite: CharacterSprite = $Sprite
@onready var weapon: Weapon = $Weapon
@onready var hitbox: Hitbox = $Hitbox
@onready var particle_damage: Particle = $ParticleDamage

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	stat = stat.make_unique()
	if stat:
		if stat.life:
			stat.life.killed.connect(on_killed)
	hitbox.damage_received.connect(take_damage)


func take_damage(damage:ResourceDamage,damage_pos = Vector2.ZERO):
	stat.life.damage(damage.amount)
	if damage.push_force:
		get_parent().push(damage_pos,damage.push_force)
	damage_fx()


func damage_fx():
	flash()
	shake()
	particle_damage.restart()


func flash(time = 0.2):
	sprite.modulate = Color(5,5,5)
	await get_tree().create_timer(time).timeout
	sprite.modulate = Color.WHITE


func shake(intensity := 2.0,time := 0.1):
	var tween = create_tween()
	tween.tween_property(sprite,"offset",Vector2(-1,-1)*intensity,time/3)
	tween.tween_property(sprite,"offset",Vector2.LEFT*intensity,time/3)
	tween.tween_property(sprite,"offset",Vector2.ZERO,time/3)


func on_killed():
	state = State.DEAD
