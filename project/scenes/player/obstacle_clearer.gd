extends Node3D

# Clears crates out of the way when groundhog comes up so he doesn't get stuck in the ground

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
