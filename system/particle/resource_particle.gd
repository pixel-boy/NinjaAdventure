@tool
extends Resource
class_name ResourceParticle


@export var texture:Texture2D
@export var frame_count := 1

var material:CanvasItemMaterial


func get_material()->CanvasItemMaterial:
	if !material:
		material = CanvasItemMaterial.new()
		material.particles_animation = true
		material.particles_anim_h_frames = frame_count
	return material
