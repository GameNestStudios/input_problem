extends Node


@export var camera_controller: Node
@export var movement_controller: Node

var input_vector: Vector2 = Vector2.ZERO

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent):
	if event is InputEventMouse:
		handle_mouse_event(event)
		return
	
	print(event.is_action_released("move_forward"))
	handle_keyboard_event()

func handle_keyboard_event():
	if Input.is_action_just_pressed("move_forward"):
		input_vector += Vector2(0, 1)
		return
	if Input.is_action_just_pressed("move_backward"):
		input_vector -= Vector2(0, 1)
		return
	if Input.is_action_just_pressed("move_left"):
		input_vector -= Vector2(1, 0)
		return
	if Input.is_action_just_pressed("move_right"):
		input_vector += Vector2(1, 0)
		return
		
	if Input.is_action_just_released("move_forward"):
		input_vector -= Vector2(0, 1)
		return
	if Input.is_action_just_released("move_backward"):
		input_vector += Vector2(0, 1)
		return
	if Input.is_action_just_released("move_left"):
		input_vector += Vector2(1, 0)
		return
	if Input.is_action_just_released("move_right"):
		input_vector -= Vector2(1, 0)
		return

func handle_mouse_event(event: InputEventMouse):
	if event is InputEventMouseMotion:
		camera_controller.horizontal_rotate(event.relative.x)
		camera_controller.vertical_rotate(event.relative.y)


func _process(_delta: float):
	process_movement_inputs()


func process_movement_inputs():
	movement_controller.update_input_vector(input_vector)
	movement_controller.update_walking(Input.is_action_pressed("walk"))
