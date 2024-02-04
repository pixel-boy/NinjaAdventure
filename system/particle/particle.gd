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
		texture = resource_particle.texture
		material = resource_particle.get_material()
