extends Node3D

@export var disabled := false

func _on_life_time_timeout() -> void:
	$StaticBody3D.set_collision_layer_value(1, false)


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if not disabled:
		queue_free()
