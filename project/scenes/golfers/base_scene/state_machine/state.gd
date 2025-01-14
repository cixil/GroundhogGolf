extends Node
class_name State

var animation_player:AnimationPlayer
var body:Golfer
var pivot:Node3D
var active := false

signal state_ended

func init() -> void:
	pass

func enter(_enter_params:Array = []) -> void:
	pass

func exit() -> void:
	pass

func proc_update(_delta:float) -> void:
	pass

func phys_update(_delta:float) -> void:
	pass
