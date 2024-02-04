extends AudioStreamPlayer


signal music_stopped

const VOLUME_MIN = -60
const VOLUME_MORMAL = 0

var tween:Tween


func change_music(audio_stream:AudioStream):
	if stream:
		if stream == audio_stream:
			return
		await stop_music()
	play_music(audio_stream)


func play_music(audio_stream:AudioStream):
	stream = audio_stream
	volume_db = VOLUME_MORMAL
	play()


func stop_music(time = 1):
	if !time:
		stream = null
	else:
		tween = create_tween()
		tween.tween_property(self,"volume_db",VOLUME_MIN,time)
		await tween.finished
		music_stopped.emit()
		stream = null
