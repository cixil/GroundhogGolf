extends GridMap

@export var dirt_lump_scene:PackedScene
@export var enable_lumps:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if enable_lumps:
		Signals.lump_raised_at.connect(_raise_dirt_lump_at)


func _raise_dirt_lump_at(pos:Vector3) -> void:
	var lump:Node3D = dirt_lump_scene.instantiate()
	add_child(lump)
	var lump_pos = Vector3(pos.x, 1, pos.z)
	lump.position = lump_pos
