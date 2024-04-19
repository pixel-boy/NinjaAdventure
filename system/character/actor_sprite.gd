@icon("../character/icon_character.png")
extends Node2D
class_name ActorSprite


enum State {IDLE,DEAD}

@onready var sprite: SpriteCharacter = $Sprite
@onready var weapon: Weapon = $Weapon
@onready var hitbox: Hitbox = $Hitbox
@onready var particle_damage: Particle = $ParticleDamage
var state

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	hitbox.damage_received.connect(take_damage)


func take_damage(damage:ResourceDamage,damage_pos = Vector2.ZERO):
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
