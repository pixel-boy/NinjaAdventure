extends ColorRect
class_name Transition


signal finished

enum Type{INSTANT_IN,INSTANT_OUT,FADE_IN,FADE_OUT}

var tween:Tween


func _init() -> void:
	add_to_group("transition")


func _ready() -> void:
	play(Type.INSTANT_OUT)
	get_parent().visible = true


func play(type):
	if tween:
		tween.kill()
	match type:
		Type.INSTANT_IN:
			modulate.a = 1.0
		Type.INSTANT_OUT:
			modulate.a = 0.0
		Type.FADE_IN:
			await fade(1)
		Type.FADE_OUT:
			await fade(0)
	finished.emit()


func fade(alpha:float,time = 0.3):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self,"modulate:a",alpha,time)
	await tween.finished
