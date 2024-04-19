@tool
@icon("../destroyable/icon_destroyable.png")
extends CharacterBody2D
class_name Destroyable


@export var life:ResourceLife
var push_velocity:= Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite
@onready var hitbox: Hitbox = $Hitbox
@onready var particle: Particle = $Particle


func _ready() -> void:
	hitbox.damage_received.connect(take_damage)
	life = life.duplicate(true)
	life.killed.connect(destroy)
	collision_mask = 0


func _physics_process(delta: float) -> void:
	if push_velocity.length():
		move_and_collide(push_velocity*delta)
		push_velocity = push_velocity.move_toward(Vector2.ZERO,300*delta)


func take_damage(damage:ResourceDamage,damage_pos = Vector2.ZERO):
	life.damage(damage.amount)
	if damage.push_force:
		push(damage_pos,damage.push_force)
	damage_fx()


func push(from,force:int):
	push_velocity += from.direction_to(global_position)*force


func damage_fx():
	flash()
	particle.restart()
	await shake()


func shake(intensity := 1.0,time := 0.1):
	var tween = create_tween()
	tween.tween_property(sprite,"offset",Vector2(-1,-1)*intensity,time/3)
	tween.tween_property(sprite,"offset",Vector2.LEFT*intensity,time/3)
	tween.tween_property(sprite,"offset",Vector2.ZERO,time/3)
	await tween.finished


func flash(time = 0.2):
	sprite.modulate = Color(5,5,5)
	await get_tree().create_timer(time).timeout
	sprite.modulate = Color.WHITE


func destroy():
	collision_layer = 0
	await damage_fx()
	sprite.visible = false
	hitbox.disable()
	await get_tree().create_timer(2.0).timeout
	queue_free()
