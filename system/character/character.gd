@icon("../character/icon_character.png")
@tool
extends CharacterBody2D
class_name Character


signal teleported

enum Behavior{PLAYER,NPC,ENEMY}
enum State {IDLE,MOVING,ATTACK,JUMP,HIT,DEAD,ITEM,ABILITY,ABILITY_2}

const SPEED := 90
const ACCELERATION := 10
const DECCELERATION := 10


@export var resource_character:ResourceCharacter:
	set(v):
		resource_character = v
		if !is_inside_tree():
			await ready
		sprite.texture = resource_character.sprite
		if Engine.is_editor_hint():
			if behavior == Behavior.PLAYER:
				name = "Player"
			else:
				name = resource_character.resource_path.get_file().get_slice(".",0).to_pascal_case()
@export var resource_weapon:ResourceWeapon:
	set(v):
		resource_weapon = v
		if !is_inside_tree():
			await ready
		if resource_weapon:
			if !weapon.is_inside_tree():
				add_child(weapon)
		else:
			if weapon.is_inside_tree():
				remove_child(weapon)
		weapon.resource_weapon = resource_weapon
@export var behavior:Behavior = Behavior.NPC:
	set(v):
		behavior = v
@export var stat:ResourceStat
@export var team:ResourceDamageTeam:
	set(v):
		team = v
		if !is_inside_tree():
			await ready
		weapon.team = team

var cinematic := false
var direction:= Vector2.RIGHT:
	set(v):
		direction = v
		sprite.direction = direction
		weapon.direction = direction
var state:State = State.IDLE:
	set(v):
		state = v
		var key:String = State.keys()[state]
		if CharacterSprite.Anim.has(key):
			sprite.anim = CharacterSprite.Anim.keys().find(key)
var just_teleported := false
var push_velocity := Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite
@onready var weapon: Weapon = $Weapon
@onready var life_bar: TextureProgressBar = $LifeBar
@onready var hitbox: Area2D = $Hitbox
@onready var particle_damage: Particle = $ParticleDamage


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	stat = stat.make_unique()
	if stat:
		if stat.life:
			life_bar.resource_life = stat.life
			stat.life.killed.connect(on_killed)
	hitbox.damage_received.connect(take_damage)
	match behavior:
		Behavior.PLAYER:
			team = load("res://content/team/player_team.tres")
		Behavior.ENEMY:
			team = load("res://content/team/enemy_team.tres")
		Behavior.NPC:
			team = load("res://content/team/neutral_team.tres")


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	var move_vector:Vector2
	match behavior:
		Behavior.PLAYER:
			move_vector = Input.get_vector("move_left","move_right","move_up","move_down")
		_:
			pass
	if cinematic:
		pass
	else:
		match state:
			State.IDLE:
				if move_vector.length():
					state = State.MOVING
					return
				velocity = velocity.move_toward(Vector2.ZERO,DECCELERATION)
			State.MOVING:
				velocity = velocity.move_toward(move_vector*SPEED,ACCELERATION)
				if move_vector.length():
					direction = move_vector
				if !move_vector.length():
					state = State.IDLE
					return
			State.DEAD:
				velocity = velocity.move_toward(Vector2.ZERO,DECCELERATION)
	move_and_slide()
	if push_velocity.length():
		move_and_collide(push_velocity*delta)
		push_velocity = push_velocity.move_toward(Vector2.ZERO,300*delta)


func teleport(to_teleporter:Teleporter,teleport_offset:=Vector2.ZERO):
	if just_teleported:
		return
	just_teleported = true
	global_position = to_teleporter.global_position
	move_and_collide(teleport_offset)
	direction = to_teleporter.direction
	cinematic = true
	velocity = direction*SPEED
	teleported.emit()
	await get_tree().create_timer(0.05).timeout
	just_teleported = false
	velocity = Vector2.ZERO
	cinematic = false


func take_damage(damage:ResourceDamage,damage_pos = Vector2.ZERO):
	stat.life.damage(damage.amount)
	if damage.push_force:
		push(damage_pos,damage.push_force)
	damage_fx()


func push(from,force:int):
	push_velocity += from.direction_to(global_position)*force
	velocity = Vector2.ZERO


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
	life_bar.visible = false
