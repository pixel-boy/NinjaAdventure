@tool
extends CharacterBody2D
class_name CharacterBody


signal teleported

const ACCELERATION := 10
const DECCELERATION := 10


@export var speed := 80

var cinematic := false
var direction:= Vector2.RIGHT
var just_teleported := false
var push_velocity := Vector2.ZERO
var move_vector := Vector2.ZERO


#func _physics_process(delta: float) -> void:
	#if Engine.is_editor_hint():
		#return
	#if cinematic:
		#pass
	#else:
		#match state:
			#State.IDLE:
				#if move_vector.length():
					#state = State.MOVING
					#return
				#velocity = velocity.move_toward(Vector2.ZERO,DECCELERATION)
			#State.MOVING:
				#velocity = velocity.move_toward(move_vector*speed,ACCELERATION)
				#if move_vector.length():
					#direction = move_vector
				#if !move_vector.length():
					#state = State.IDLE
					#return
			#State.DEAD:
				#velocity = velocity.move_toward(Vector2.ZERO,DECCELERATION)
	#move_and_slide()
	#if push_velocity.length():
		#move_and_collide(push_velocity*delta)
		#push_velocity = push_velocity.move_toward(Vector2.ZERO,300*delta)


func teleport(to_teleporter:Teleporter,teleport_offset:=Vector2.ZERO):
	if just_teleported:
		return
	just_teleported = true
	global_position = to_teleporter.global_position
	move_and_collide(teleport_offset)
	direction = to_teleporter.direction
	cinematic = true
	velocity = direction*speed
	teleported.emit()
	await get_tree().create_timer(0.05).timeout
	just_teleported = false
	velocity = Vector2.ZERO
	cinematic = false


func push(from,force:int):
	push_velocity += from.direction_to(global_position)*force
	velocity = Vector2.ZERO


func sleep():
	set_physics_process(false)

func awake():
	set_physics_process(true)
