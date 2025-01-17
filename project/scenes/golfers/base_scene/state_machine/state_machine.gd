extends Node
class_name StateMachine

@onready var pivot: Node3D = $"../Pivot"
@onready var animation_player: AnimationPlayer = $"../Pivot/ModelGoesHere/man/AnimationPlayer"

@export var debug := false

var states:Dictionary # maps state name string to state node
var current_state:State
var transitioning:bool = true

func _ready() -> void:
	for node in get_children():
		if node is State:
			states[node.name.to_lower()] = node
			node.animation_player = animation_player
			node.body = owner
			node.pivot = pivot
			node.init()

func _process(delta: float) -> void:
	if not transitioning:
		current_state.proc_update(delta)

func _physics_process(delta: float) -> void:
	if not transitioning:
		current_state.phys_update(delta)

func start(init_state:String, init_args:Array = []):
	current_state = states[init_state.to_lower()]
	current_state.active = true
	await current_state.enter(init_args)
	transitioning = false

func transition_to(new_state:String, args:Array = []):
	if debug:
		print_debug("Transitioning from ", current_state.name, " to ", new_state)
	transitioning = true
	await current_state.exit()
	#current_state.process_mode = Node.PROCESS_MODE_DISABLED
	current_state.active = false
	
	current_state = states[new_state.to_lower()]
	#current_state.process_mode = Node.PROCESS_MODE_INHERIT
	current_state.active = true
	await current_state.enter(args)
	transitioning = false
