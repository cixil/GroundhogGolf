extends Node

@onready var animation_player: AnimationPlayer = %AnimationPlayer


var states:Dictionary # maps state name string to state node
var current_state:State
var transitioning:bool = true

func _ready() -> void:
	for node in get_children():
		if node is State:
			states[node.name.to_lower()] = node
			node.animation_player = animation_player
			node.body = owner
			node.init()

func _process(delta: float) -> void:
	if not transitioning:
		current_state.proc_update(delta)

func _physics_process(delta: float) -> void:
	if not transitioning:
		current_state.phys_update(delta)

func start(init_state:String, init_args:Array = []):
	current_state = states[init_state.to_lower()]
	await current_state.enter(init_args)
	transitioning = false

func transition_to(new_state:String, args:Array = []):
	transitioning = true
	await current_state.exit()
	current_state = states[new_state.to_lower()]
	await current_state.enter(args)
	transitioning = false
