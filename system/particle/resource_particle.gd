@icon("../particle/icon_resource_particle.png")
@tool
extends Resource
class_name ResourceParticle


@export var texture:Texture2D:
	set(v):
		texture = v
		emit_changed()
@export var frame_h := 1:
	set(v):
		frame_h = v
		generate_material()
		emit_changed()
@export var frame_v := 1:
	set(v):
		frame_v = v
		generate_material()
		emit_changed()

var material:CanvasItemMaterial


func get_material()->CanvasItemMaterial:
	if !material:
		generate_material()
	return material


func generate_material():
	material = CanvasItemMaterial.new()
	material.particles_animation = true
	material.particles_anim_h_frames = frame_h
	material.particles_anim_v_frames = frame_v
