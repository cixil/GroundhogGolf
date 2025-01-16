extends GridMap

@export var dirt_lump_scene:PackedScene

@export var obstacle_clear_scene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.lump_raised_at.connect(_raise_dirt_lump_at)
	Signals.hog_left_ground_at.connect(_raise_obstacle_clear_at)

func _raise_dirt_lump_at(pos:Vector3) -> void:
	
	var lump:Node3D = dirt_lump_scene.instantiate()
	add_child(lump)
	var lump_pos = Vector3(pos.x, pos.y - 0.13, pos.z)
	lump.global_position = lump_pos
	#print('raise at ', lump_pos)


func _raise_obstacle_clear_at(pos:Vector3) -> void:
	
	var lump:Node3D = obstacle_clear_scene.instantiate()
	add_child(lump)
	var lump_pos = Vector3(pos.x, pos.y, pos.z)
	lump.global_position = lump_pos
	print('raise at ', lump_pos)
