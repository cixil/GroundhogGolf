extends CharacterBody3D

@onready var state_machine: Node = $StateMachine
@export var path_to_follow:Path3D

var direction:Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	state_machine.start("FollowPath", [path_to_follow])


func _on_lump_detector_body_entered(body: Node3D) -> void:
	state_machine.transition_to('trip')


func _on_trip_state_ended() -> void:
	state_machine.transition_to('followpath', [path_to_follow])
