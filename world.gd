extends Node2D


@onready var rain: GPUParticles2D = %Rain
@onready var snow: GPUParticles2D = %Snow
@onready var cloud: GPUParticles2D = %Cloud
@onready var leaf: GPUParticles2D = %Leaf
@onready var raylight: GPUParticles2D = %Raylight
@onready var fog: TextureRect = %Fog

@onready var transition: ColorRect = %Transition
@onready var music: AudioStreamPlayer = %Music
@onready var post_processing: ColorRect = %PostProcessing
@onready var color_correction: ColorRect = %ColorCorrection


func apply_environment(resource_environment:ResourceEnvironment):
	# METEO
	if !resource_environment:
		return
	rain.emitting = ResourceEnvironment.Meteo.RAIN in resource_environment.meteo_list
	snow.emitting = ResourceEnvironment.Meteo.SNOW in resource_environment.meteo_list
	cloud.emitting = ResourceEnvironment.Meteo.CLOUD in resource_environment.meteo_list
	leaf.emitting = ResourceEnvironment.Meteo.LEAF in resource_environment.meteo_list
	fog.active = ResourceEnvironment.Meteo.FOG in resource_environment.meteo_list
	raylight.emitting = ResourceEnvironment.Meteo.RAY in resource_environment.meteo_list
	
	# MUSIC
	if resource_environment.music:
		music.change_music(resource_environment.music)
	else:
		music.stop_music()
	
	# GRADIENT
	color_correction.gradient = resource_environment.color_gradient


func play_transition(type:Transition.Type):
	transition
