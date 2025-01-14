extends Node

@onready var dirt_enter_sound: AudioStreamPlayer = $DirtEnterSound
@onready var audio_stream_player: AudioStreamPlayer = $Node/AudioStreamPlayer

@export var sfx:Array[AudioStream]

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	# play the sound when the signal is emitted.
	#play_once(Signals.hog_entered_dirt, sfx[0])
	
	#play_once(Signals.hog_exited_dirt, sfx[1])
	
	# play sound when signal 1 is emitted and end it when signal 2 is emitted
	# the sound should be a looping sound
	#play_until(Signals.hog_entered_dirt, Signals.hog_exited_dirt, sfx[2])


func play_once(sig:Signal, sound:AudioStream):
	var player = AudioStreamPlayer.new()
	player.stream = sound
	add_child(player)
	sig.connect(player.play)

func play_until(sig_start:Signal, sig_end:Signal, sound:AudioStream):
	var player = AudioStreamPlayer.new()
	player.stream = sound
	add_child(player)
	sig_start.connect(player.play)
	sig_end.connect(player.stop)
