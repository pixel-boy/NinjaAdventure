@tool
extends Resource
class_name ResourceEnvironment


enum Meteo {RAIN,SNOW,FOG,CLOUD,LEAF,RAY}

@export var color_gradient:GradientTexture1D:
	set(v):
		color_gradient = v
		emit_changed()
@export var music:AudioStream:
	set(v):
		music = v
		emit_changed()
@export var meteo_list:Array[Meteo] = []:
	set(v):
		meteo_list = v
		emit_changed()


func get_debug_info()->String:
	var debug_info:String
	if music:
		debug_info += str(music.resource_path.get_file()) + "\n"
	if meteo_list.size():
		var i = 0
		for meteo in meteo_list:
			debug_info += Meteo.keys()[meteo].to_lower()
			if i < meteo_list.size()-1:
				debug_info += "/"
			i += 1
	return debug_info
