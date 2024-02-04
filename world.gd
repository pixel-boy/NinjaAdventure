extends Node2D


@export var starting_map:PackedScene
@export var player_character:ResourceCharacter = preload("res://content/character/blue_ninja/blue_ninja.tres")
@export var stating_weapon:ResourceWeapon

var player:Character
var map:Map

@onready var rain: GPUParticles2D = %Rain
@onready var snow: GPUParticles2D = %Snow
@onready var cloud: GPUParticles2D = %Cloud
@onready var leaf: GPUParticles2D = %Leaf
@onready var raylight: GPUParticles2D = %Raylight
@onready var fog: TextureRect = %Fog

@onready var transition: ColorRect = %Transition
@onready var music: AudioStreamPlayer = %Music
@onready var color_correction: ColorRect = %ColorCorrection
@onready var camera_grid: CameraGrid = %CameraGrid
@onready var pivot: Node2D = %Pivot


func _ready():
	generate_map(starting_map)
	init_map()
	camera_grid.animation_finished.connect(on_camera_animation_finished)


func _process(delta: float) -> void:
	camera_grid.go_to_world_position(player.global_position)


func on_camera_animation_finished():
	pivot.position = camera_grid.global_position


func generate_map(map_scene:PackedScene):
	if map:
		map.queue_free()
	map = starting_map.instantiate()
	add_child(map)
	map.environment_area.environment_changed.connect(apply_environment)


func generate_player():
	if !player:
		player = preload("res://system/character/character.tscn").instantiate()
		player.resource_character = player_character
		player.behavior = player.Behavior.PLAYER
		player.teleported.connect(on_player_teleported)
		player.resource_weapon = stating_weapon


func on_player_teleported():
	camera_grid.set_world_position(player.global_position)


func init_map():
	generate_player()
	map.add_child(player)
	player.global_position = map.get_spawn_pos()


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
