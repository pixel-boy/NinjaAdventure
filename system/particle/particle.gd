@icon("../particle/icon_particle.png")
@tool
extends GPUParticles2D
class_name Particle


@export var resource_particle:ResourceParticle:
	set(v):
		resource_particle = v
		if !resource_particle:
			texture = null
			material = null
			return
		if !resource_particle.changed.is_connected(update_particle):
			resource_particle.changed.connect(update_particle)
		update_particle()


func update_particle():
		texture = resource_particle.texture
		material = resource_particle.get_material()
