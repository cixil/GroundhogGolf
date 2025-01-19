extends Area3D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _on_body_entered(body: Node3D) -> void:
	if body is GroundHog:
		audio_stream_player.play()
		await get_tree().create_timer(3).timeout
		queue_free()
