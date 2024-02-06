extends CharacterBody
class_name Character


enum State {IDLE,MOVING,ATTACK,JUMP,HIT,DEAD,ITEM,ABILITY,ABILITY_2}


@export var team:ResourceDamageTeam:
	set(v):
		team = v
		if !is_inside_tree():
			await ready
		actor.team = team

@export var resource_character:ResourceCharacter:
	set(v):
		resource_character = v
		if !is_inside_tree():
			await ready
		actor.resource_character = resource_character
		if Engine.is_editor_hint():
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
@onready var actor:CharacterSprite = $Actor


var state:State = State.IDLE:
	set(v):
		state = v
		var key:String = State.keys()[state]
		#if CharacterSprite.Anim.has(key):
			#sprite.anim = CharacterSprite.Anim.keys().find(key)

