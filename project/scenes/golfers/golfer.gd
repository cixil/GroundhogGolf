extends CharacterBody3D
class_name Golfer
@onready var skeleton: Skeleton3D = %Skeleton3D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var state_machine: Node = $StateMachine
@onready var hand: Holdable = %BoneAttachment3D

var walk_speed := 1.0


## Golfer Roll #################
@export var golfer:bool = false
@export var tee_to_golf:GolfTee

@export var holding:Holdable.objects = Holdable.objects.None

## Default home position to return to
var home_position:Vector3

## If set, will fix the tee after hoggo knocks it over
@export var tee_to_monitor:GolfTee

## If set, will patrol this path on startup
@export var path_to_follow:Path3D

var direction:Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await get_tree().create_timer(1).timeout
	home_position = global_position
	
	if tee_to_monitor:
		Signals.golf_tee_fell.connect(_on_tee_fell)
	if tee_to_golf:
		Signals.golf_tee_fell.connect(_on_golf_tee_fell)
	
	hold_in_hand(holding)
	
	if path_to_follow:
		state_machine.start("FollowPath", [path_to_follow])
	elif golfer:
		state_machine.start('golf', [tee_to_golf])
	else:
		state_machine.start('idle')

func get_hand_pos() -> Transform3D:
	return skeleton.get_bone_global_pose(13)

func hold_in_hand(obj:Holdable.objects):
	hand.show_obj(obj)
	

func release_hand_object(obj:Node3D):
	return

func _on_golf_tee_fell(tee:GolfTee):
	if tee == tee_to_golf:
		if state_machine.current_state == $StateMachine/Golf and $StateMachine/Golf.about_to_swing:
			await $StateMachine/Golf.just_swung
			state_machine.transition_to("getangry")
		else:
			state_machine.transition_to('noticehog', [tee])

func _on_tee_fell(tee:GolfTee):
	if tee == tee_to_monitor:
		state_machine.transition_to('resettee', [tee])




func _on_lump_detector_body_entered(body: Node3D) -> void:
	if animation_player.current_animation == 'walking-forward':
		state_machine.transition_to('trip')

# TODO need to return to the last state not follow path

func _on_trip_state_ended() -> void:
	if path_to_follow:
		state_machine.transition_to('followpath', [path_to_follow])


func _on_reset_tee_state_ended() -> void:
	state_machine.transition_to('gotoposition', [home_position])
