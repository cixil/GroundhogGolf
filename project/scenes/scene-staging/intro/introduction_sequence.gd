extends Control

@export var slides:Array[PackedScene]
@onready var slide_container: Control = $SlideContainer
@onready var animation_player: AnimationPlayer = $Arrows/AnimationPlayer
@onready var arrows: Control = $Arrows

@export var main_scene:PackedScene

var idx := 0
var can_advance := false

func _ready() -> void:
	show_slide(0)

func advance_slide():
	if idx < len(slides)-1:
		idx += 1
		show_slide(idx)
	elif idx == len(slides)-1:
		get_tree().change_scene_to_packed(main_scene)

func previous_slide():
	if idx > 0:
		idx -= 1
		show_slide(idx)

func show_slide(index:int):
	arrows.hide()
	if slide_container.get_child_count() > 0:
		slide_container.get_child(0).queue_free()
	can_advance = false
	var scene:PackedScene = slides[index]
	var slide:Slide = scene.instantiate()
	slide_container.add_child(slide)
	slide.set_anchors_preset(Control.PRESET_FULL_RECT)
	slide.play()
	await slide.animation_finished
	can_advance = true
	arrows.show()
	animation_player.play('blink-right-arrow')

func _input(event: InputEvent) -> void:
	if can_advance:
		if event.is_action_pressed("ui_right"):
			advance_slide()
		elif event.is_action_pressed("ui_left"):
			previous_slide()
