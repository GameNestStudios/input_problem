extends Node

@export var animation_tree: AnimationTree

var state_machine: AnimationNodeStateMachinePlayback


func _ready():
	state_machine = animation_tree["parameters/playback"]

func go_iddle():
	change_IRS_value(0)

func go_walking():
	change_IRS_value(1)

func go_running():
	change_IRS_value(2)

func change_IRS_value(value: float):
	animation_tree.set("parameters/IRS/blend_position", lerpf(animation_tree.get("parameters/IRS/blend_position"), value, 0.2))


func travel_to_state(state_name: String):
	state_machine.travel(state_name)
