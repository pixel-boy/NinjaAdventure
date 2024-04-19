@tool
@icon("../teleporter/icon_teleporter.png")
extends Area2D
class_name Teleporter


const MASK_PLAYER = 5

@export var target:Teleporter:
	set(v):
		if v == target:
			return
		if v == self:
			push_warning("Impossible to assign a teleporter to itself")
			v = null
		target = v
		if !target:
			return
		if target.target != self:
			target.target = self
		queue_redraw()
@export var direction = Vector2.DOWN:
	set(v):
		direction = v
		update_arrow_direction()
@export var transition_enter:Transition.Type = Transition.Type.INSTANT_IN
@export var transition_exit:Transition.Type = Transition.Type.FADE_OUT


var arrow_direction:Sprite2D

func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(MASK_PLAYER,true)
	body_entered.connect(on_player_entered)
	update_arrow_direction()


func on_player_entered(player:Character):
	var transition:Transition = get_tree().get_first_node_in_group("transition")
	if transition:
		await transition.play(transition_enter)
	await player.teleport(target,player.global_position-global_position)
	if transition:
		await transition.play(target.transition_exit)


func _draw() -> void:
	if Engine.is_editor_hint():
		if target:
			draw_line(Vector2.ZERO,target.position-position,Color.RED,2)


func _notification(what):
	if Engine.is_editor_hint():
		match what:
			NOTIFICATION_TRANSFORM_CHANGED:
				queue_redraw()
				if target:
					target.queue_redraw()


func update_arrow_direction():
	if Engine.is_editor_hint():
		if !arrow_direction:
			arrow_direction = Sprite2D.new()
			arrow_direction.offset.x = 8
			arrow_direction.z_index = 2
			arrow_direction.texture = load("res://system/teleporter/teleporter_arrow.png")
			add_child(arrow_direction)
		arrow_direction.rotation = direction.angle()
