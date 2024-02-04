extends Node


enum StartingScene {TITLE_SCREEN,GAME}

@export var starting_menu:StartingScene = StartingScene.TITLE_SCREEN

var current_scene:Node


func _ready() -> void:
	match starting_menu:
		StartingScene.TITLE_SCREEN:
			launch_scene(load("res://world.tscn"))
		StartingScene.GAME:
			launch_scene(load("res://title_screen.tscn"))


func launch_scene(packed_scene:PackedScene):
	if current_scene:
		current_scene.queue_free()
	current_scene = packed_scene.instantiate()
	add_child(current_scene)
