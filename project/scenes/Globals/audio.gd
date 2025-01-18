extends Node


@onready var main_theme: AudioStreamPlayer = $MainTheme
@onready var radio_theme: AudioStreamPlayer = $RadioTheme

# soundbanks
@export var sfx:Array[AudioStream]
@export var chaos_fills:Array[AudioStream]
@export var ambient_guitar:Array[AudioStream]
@export var ambient_birds:Array[AudioStream]
@export var ambient_bugs:Array[AudioStream]

@onready var guitar_timer:Timer = $GuitarTimer
@onready var bird_timer: Timer = $BirdTimer
@onready var cricket_timer: Timer = $CricketTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 #play the sound when the signal is emitted.
	play_once(Signals.hog_touched_ball, sfx[0])
	play_once(Signals.golfer_swung_no_arg, sfx[3])
	play_once(Signals.golf_ball_hit_by_golfer, sfx[4])
	play_once(Signals.hog_entered_dirt, sfx[5])
	play_once(Signals.hog_exited_dirt, sfx[6])
	play_once(Signals.golfer_tripped, chaos_fills[0])
	play_once(Signals.crate_pushed_from_ground, chaos_fills[1])
	
	play_until(Signals.hog_started_walking, Signals.hog_stopped_walking, sfx[1])
	play_until(Signals.hog_entered_dirt, Signals.hog_exited_dirt, sfx[2])
	
	Signals.radio_turned_on.connect(play_radio_music)
	Signals.radio_turned_off.connect(stop_radio_music)
	
	#main_theme.play()
	
	guitar_timer.timeout.connect(
		_play_random_from_array.bind(guitar_timer, 5, 10, ambient_guitar)
	)
	bird_timer.timeout.connect(
		_play_random_from_array.bind(bird_timer, 7, 10, ambient_birds)
	)
	_play_random_from_array(guitar_timer, 5, 10, ambient_guitar)
	_play_random_from_array(bird_timer, 7, 10, ambient_birds)


func play_radio_music():
	main_theme.stop()
	radio_theme.play()
	radio_theme.seek(11)

func stop_radio_music():
	main_theme.play()
	radio_theme.stop()

func dim_theme():
	main_theme.volume_db = linear_to_db(0.35)

func undim_theme():
	main_theme.volume_db = 0

func play_once(sig:Signal, sound:AudioStream):
	var player = AudioStreamPlayer.new()
	player.stream = sound
	player.bus = &"SFX"
	add_child(player)
	sig.connect(player.play)


func play_until(sig_start:Signal, sig_end:Signal, sound:AudioStream):
	var player = AudioStreamPlayer.new()
	player.stream = sound
	player.bus = &"SFX"
	add_child(player)
	sig_start.connect(player.play)
	sig_end.connect(player.stop)



func _play_random_from_array(timer:Timer, min_delay:float, max_delay:float, samples:Array[AudioStream]) -> void:
	timer.wait_time = randi_range(min_delay, max_delay)
	timer.start()
	
	var sound = samples.pick_random()
	var player:AudioStreamPlayer = AudioStreamPlayer.new()
	player.stream = sound
	player.bus = &"Music"
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
