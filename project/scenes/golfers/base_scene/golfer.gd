extends CharacterBody3D
class_name Golfer
#@onready var skeleton: Skeleton3D = %Skeleton3D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var state_machine: Node = $StateMachine
@onready var hand: Holdable = %BoneAttachment3D
@onready var pivot: Node3D = $Pivot

@export var walk_speed := 1.0

var in_mud:bool = false

## Default home position to return to
var home_position:Vector3

var holding_object:Holdable.objects

## If set, will patrol this path on startup
@export var path_to_follow:Path3D

var direction:Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await get_tree().create_timer(1).timeout
	home_position = global_position
	
	
	if path_to_follow:
		state_machine.start("FollowPath", [path_to_follow])
	else:
		state_machine.start('idle')

#func get_hand_pos() -> Transform3D:
	#return skeleton.get_bone_global_pose(13)

func hold_in_hand(obj:Holdable.objects):
	holding_object = obj
	hand.show_obj(obj)
	

func get_muddy():
	Signals.outfit_ruined.emit()
	var mesh:Mesh = $Pivot/man2/Armature/Skeleton3D/man.mesh
	var material:Material = mesh.surface_get_material(0)
	var mud_color = Color('9d5a40')
	material.albedo_color = mud_color
	#mesh.surface_set_material(0)

func _on_lump_detector_body_entered(_body: Node3D) -> void:
	if animation_player.current_animation == 'walking-forward':
		state_machine.transition_to('trip')

# TODO need to return to the last state not follow path

func _on_trip_state_ended() -> void:
	if path_to_follow:
		state_machine.transition_to('followpath', [path_to_follow])
