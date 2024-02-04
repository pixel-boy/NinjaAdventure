@icon("../character/icon.png")
@tool
extends CharacterBody2D
class_name Character

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
		weapon.resource_weapon = resource_weapon
@export var behavior:Behavior = Behavior.NPC:
	set(v):
		behavior = v
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

@onready var sprite: Sprite2D = $Sprite
@onready var weapon: Weapon = $Weapon


func _process(delta: float) -> void:
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
	move_and_slide()

func teleport(to_teleporter:Teleporter,teleport_offset:=Vector2.ZERO):
	if just_teleported:
		return
	just_teleported = true
	global_position = to_teleporter.global_position
	move_and_collide(teleport_offset)
	direction = to_teleporter.direction
	cinematic = true
	velocity = direction*SPEED
	var camera:Camera = get_tree().get_first_node_in_group("camera")
	if camera:
		camera.center()
	await get_tree().create_timer(0.05).timeout
	just_teleported = false
	velocity = Vector2.ZERO
	cinematic = false
