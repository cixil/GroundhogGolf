extends CharacterBody3D
class_name Golfer
#@onready var skeleton: Skeleton3D = %Skeleton3D
@onready var animation_player: AnimationPlayer = $Pivot/ModelGoesHere/man/AnimationPlayer
@onready var state_machine: Node = $StateMachine
@onready var hand: Holdable = $Pivot/ModelGoesHere/man/Armature/Skeleton3D/BoneAttachment3D
@onready var pivot: Node3D = $Pivot

@export var walk_speed := 1.0

@export var receptive_to_radio:bool = false
@export var radio:Radio
@export var dancing_spot:Node3D

var in_mud:bool = false

## Default home position to return to
var home_position:Vector3

var holding_object:Holdable.objects

## If set, will patrol this path on startup
@export var path_to_follow:Path3D
@export var path_point_animations:Array[String]

@export var is_manager:bool = false # need this to detect radio in main scene

var direction:Vector3

var trippable:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	home_position = global_position
	if receptive_to_radio:
		Signals.radio_turned_off.connect(notice_radio_turned_off.bind(radio))


func hold_in_hand(obj:Holdable.objects):
	holding_object = obj
	hand.show_obj(obj)

func notice_radio(radio:Radio):
	trippable = false
	pivot.basis = Basis.looking_at(global_position.direction_to(radio.global_position))
	animation_player.play("scared")
	await animation_player.animation_finished
	state_machine.transition_to("gotoposition", [dancing_spot.global_position])
	await $StateMachine/GoToPosition.state_ended
	state_machine.transition_to("dance")
	await $StateMachine/Dance.state_ended
	trippable = true

func notice_radio_turned_off(radio:Radio):
	state_machine.transition_to("stopdance", [radio.global_position, 2])
	await $StateMachine/StopDance.state_ended
	state_machine.transition_to("followpath", [path_to_follow, path_point_animations])

func get_muddy():
	Signals.outfit_ruined.emit()
	var mesh:Mesh = $Pivot/man/Armature/Skeleton3D/man.mesh
	var material:Material = mesh.surface_get_material(0)
	var mud_color = Color('9d5a40')
	material.albedo_color = mud_color
	#mesh.surface_set_material(0)

func _on_lump_detector_body_entered(_body: Node3D) -> void:
	if animation_player.current_animation == 'walking-forward' and trippable:
		state_machine.transition_to('trip')



func _on_trip_state_ended() -> void:
	# TODO would be nice to return to the point on the path we were at before being tripped
	if path_to_follow:
		state_machine.transition_to('followpath', [path_to_follow])


func move_to(target):
	target.y = 0
	animation_player.play('walking-forward')
	direction =  global_position.direction_to(target)
	velocity = walk_speed * direction
	pivot.basis = Basis.looking_at(direction)
	move_and_slide()
