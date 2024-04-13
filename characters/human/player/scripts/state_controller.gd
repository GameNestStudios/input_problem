extends Node


@export var animations_controller: Node


enum HumanState { 
	ANY,
	IDDLE,
	WALKING,
	RUNNING 
}

var current_state = HumanState.IDDLE
var state_change_handler = {}

var last_delta = 0

func _ready():
	reset_handlers()
	bind_handlers()

func reset_handlers():
	for state in HumanState.values():
		state_change_handler[state] = {}

func travel_state(new_state: HumanState):
	if state_change_handler[current_state].has(new_state):
		state_change_handler[current_state][new_state].call()
		
	if state_change_handler[HumanState.ANY].has(new_state):
		state_change_handler[HumanState.ANY][new_state].call()
		
	if state_change_handler[current_state].has(HumanState.ANY):
		state_change_handler[current_state][HumanState.ANY].call()
	
	current_state = new_state

func go_iddle():
	travel_state(HumanState.IDDLE)

func go_walking():
	travel_state(HumanState.WALKING)

func go_running():
	travel_state(HumanState.RUNNING)

func bind_handlers():
	bind_arrival_handlers()
	bind_exiting_handlers()
	bind_specific_handlers()

func bind_arrival_handlers():
	state_change_handler[HumanState.ANY][HumanState.IDDLE] = handle_iddle_start
	state_change_handler[HumanState.ANY][HumanState.RUNNING] = handle_running_start
	state_change_handler[HumanState.ANY][HumanState.WALKING] = handle_walking_start
	
func bind_exiting_handlers():
	pass

func bind_specific_handlers():
	pass

func handle_iddle_start():
	animations_controller.go_iddle()

func handle_walking_start():
	animations_controller.go_walking()

func handle_running_start():
	animations_controller.go_running()
