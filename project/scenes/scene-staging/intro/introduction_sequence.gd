extends Control

@export var slides:Array[PackedScene]
@onready var slide_container: Control = $SlideContainer
@onready var animation_player: AnimationPlayer = $Arrows/AnimationPlayer
@onready var arrows: Control = $Arrows
@onready var indicator: AnimatedSprite2D = $Arrows/Indicator

@export var main_scene:PackedScene

var idx := 0
var can_advance := false

var transform_slide = 7 # used to cut music off

func _ready() -> void:
	show_slide(0)

func advance_slide():
	if idx < len(slides)-1:
		idx += 1
		show_slide(idx)
	elif idx == len(slides)-1:
		# start the game
		get_tree().change_scene_to_packed(main_scene)

func previous_slide():
	if idx > 0:
		idx -= 1
		show_slide(idx)

func show_slide(index:int):
	if index == transform_slide:
		Audio.stop_intro()
	indicator.hide()
	if slide_container.get_child_count() > 0:
		slide_container.get_child(0).queue_free()
	can_advance = false
	var scene:PackedScene = slides[index]
	var slide:Slide = scene.instantiate()
	slide_container.add_child(slide)
	slide.set_anchors_preset(Control.PRESET_FULL_RECT)
	slide.play()
	#await slide.animation_finished
	if index == len(slides)-1:
		await get_tree().create_timer(4).timeout
	else:
		await get_tree().create_timer(1).timeout
	can_advance = true
	#arrows.show()
	#animation_player.play('blink-right-arrow')
	indicator.show()

func _input(event: InputEvent) -> void:
	if can_advance:
		if event.is_action_pressed("ui_right"):
			advance_slide()
		elif event.is_action_pressed("ui_left"):
			previous_slide()
